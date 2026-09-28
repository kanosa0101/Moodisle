/// 云游引擎（docs/02 §7）：派遣/到期结算/纪念品权重抽取。
library;

import 'dart:math' as math;

import '../config/roam_config.dart';
import '../entities/emotion.dart';
import '../entities/game_state.dart';
import '../entities/social.dart';
import '../events/game_events.dart';

class RoamResultLine {
  final String souvenirId;
  final bool isNew;
  const RoamResultLine(this.souvenirId, this.isNew);
}

class RoamEngine {
  RoamEngine._();

  /// 派遣一只已收服精灵（不占用行动力/每日次数；同精灵不可同时云游）。
  static List<GameEvent> dispatch(
      GameState s, Emotion pet, String routeId, DateTime now) {
    final route = routeById(routeId);
    final events = <GameEvent>[];
    if (s.pets[pet] == null) {
      events.add(const GameNotice('这只精灵还未收服哦'));
      return events;
    }
    if (s.roam.isRoaming(pet)) {
      events.add(const GameNotice('它已经在云游途中啦'));
      return events;
    }
    if (s.roam.slots.isNotEmpty) {
      events.add(const GameNotice('云游名额已满，等伙伴回来再派遣～'));
      return events;
    }
    s.roam.slots.add(RoamSlot(
      pet: pet,
      routeId: route.id,
      startedAt: now,
      durationMs: route.duration.inMilliseconds,
    ));
    events.add(GameNotice('${pet.petCn} 出发去「${route.cn}」啦'));
    return events;
  }

  /// 迎接到期归来：权重抽取纪念品（新收藏标记 NEW）。
  static List<GameEvent> claim(GameState s, int slotIndex, DateTime now,
      {math.Random? rng}) {
    final r = rng ?? math.Random();
    final events = <GameEvent>[];
    if (slotIndex < 0 || slotIndex >= s.roam.slots.length) {
      events.add(const GameNotice('没有这个云游槽位'));
      return events;
    }
    final slot = s.roam.slots[slotIndex];
    if (!slot.isDue(now)) {
      events.add(const GameNotice('它还在路上，再等等～'));
      return events;
    }
    final route = routeById(slot.routeId);
    final count = route.count(r.nextInt(1 << 30));
    final lines = <RoamResultLine>[];
    for (var i = 0; i < count; i++) {
      final id = _weightedPick(route.pool, r);
      final isNew = (s.roam.souvenirs[id] ?? 0) == 0;
      s.roam.souvenirs[id] = (s.roam.souvenirs[id] ?? 0) + 1;
      lines.add(RoamResultLine(id, isNew));
    }
    s.roam.slots.removeAt(slotIndex);
    final summary = lines
        .map((l) => '${kSouvenirs[l.souvenirId]!.cn}${l.isNew ? "（新收藏）" : ""}')
        .join('、');
    events.add(GameNotice('${slot.pet.petCn} 归来：$summary'));
    return events;
  }

  static String _weightedPick(List<(String, int)> pool, math.Random r) {
    final total = pool.fold<int>(0, (a, e) => a + e.$2);
    var roll = r.nextInt(total == 0 ? 1 : total);
    for (final (id, w) in pool) {
      if ((roll -= w) < 0) return id;
    }
    return pool.last.$1;
  }
}

/// 群岛明信片码（docs/02 §10）：零服务器、本地校验和的定长 Base32 载荷。
/// 格式：`MDSL-<BODY>-<CHECK4>`；BODY = 载荷每个 UTF-16 码元 × 4 个 Base32 字符
/// （32⁴ > 65535，无损可逆）；CHECK = 31 进制滚动和。
class SocialEngine {
  SocialEngine._();

  static const String _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'; // 恰 32 字符

  static String encode({required String islandName, required Emotion pet}) {
    final nameSeg = islandName.trim().isEmpty ? '小屿' : islandName.trim();
    final payload = '$nameSeg|${pet.index}';
    final body = StringBuffer();
    for (final cu in payload.codeUnits) {
      var v = cu;
      final group = List<String>.generate(4, (_) {
        final d = v % 32;
        v = v ~/ 32;
        return _alphabet[d];
      });
      body.write(group.reversed.join());
    }
    final b = body.toString();
    return 'MDSL-$b-${_checksum(b)}';
  }

  static ({String islandName, Emotion pet})? decode(String code) {
    final c = code.trim().toUpperCase();
    if (!c.startsWith('MDSL-')) return null;
    final parts = c.split('-');
    if (parts.length != 3) return null;
    final body = parts[1];
    if (body.isEmpty || body.length % 4 != 0) return null;
    if (_checksum(body) != parts[2]) return null;
    final codeUnits = <int>[];
    for (var i = 0; i < body.length; i += 4) {
      var v = 0;
      for (var k = 0; k < 4; k++) {
        final idx = _alphabet.indexOf(body[i + k]);
        if (idx < 0) return null;
        v = v * 32 + idx;
      }
      codeUnits.add(v);
    }
    try {
      final text = String.fromCharCodes(codeUnits);
      final seg = text.split('|');
      if (seg.length != 2) return null;
      final petIdx = int.parse(seg[1]);
      if (petIdx < 0 || petIdx >= Emotion.values.length) return null;
      if (seg[0].isEmpty) return null;
      return (islandName: seg[0], pet: Emotion.values[petIdx]);
    } catch (_) {
      return null;
    }
  }

  static String _checksum(String body) {
    var sum = 0;
    for (var i = 0; i < body.length; i++) {
      sum = (sum * 31 + body.codeUnitAt(i)) % 1299709;
    }
    return sum.toRadixString(36).padLeft(4, '0').substring(0, 4).toUpperCase();
  }

  /// 导入好友码：挂明信片 + 对方招牌精灵到访 72h。
  static List<GameEvent> importPostcard(
      GameState s, String code, DateTime now) {
    final decoded = decode(code);
    if (decoded == null) {
      return [const GameNotice('导入码无效，检查一下再试试～')];
    }
    final already =
        s.social.postcards.any((p) => p.code == code.trim().toUpperCase());
    if (already) {
      return [const GameNotice('这张明信片已经挂上信标啦')];
    }
    s.social.postcards.insert(
      0,
      Postcard(
        code: code.trim().toUpperCase(),
        friendName: decoded.islandName,
        friendPet: decoded.pet,
        receivedAt: now,
      ),
    );
    s.social.visitingPet = decoded.pet;
    s.social.visitingExpire = now.add(const Duration(hours: 72));
    return [
      GameNotice(
          '「${decoded.islandName}」的明信片挂上信标，${decoded.pet.petCn} 来你家岛客住 72 小时'),
    ];
  }
}
