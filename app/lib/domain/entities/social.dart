/// 云游 / 群岛社交 的状态实体（docs/02 §7/§10）。
library;
import 'emotion.dart';

class RoamSlot {
  final Emotion pet;
  final String routeId;
  final DateTime startedAt;
  final int durationMs;

  const RoamSlot({
    required this.pet,
    required this.routeId,
    required this.startedAt,
    required this.durationMs,
  });

  bool isDue(DateTime now) =>
      now.millisecondsSinceEpoch >=
      startedAt.millisecondsSinceEpoch + durationMs;

  RoamSlot copyWith({DateTime? startedAt}) => RoamSlot(
        pet: pet,
        routeId: routeId,
        startedAt: startedAt ?? this.startedAt,
        durationMs: durationMs,
      );
}

class RoamState {
  final List<RoamSlot> slots;
  final Map<String, int> souvenirs; // id -> 数量
  String? pendant; // 全队佩戴的挂件 id
  RoamState({
    List<RoamSlot>? slots,
    Map<String, int>? souvenirs,
    this.pendant,
  })  : slots = slots ?? [],
        souvenirs = souvenirs ?? {};

  bool isRoaming(Emotion pet) => slots.any((s) => s.pet == pet);
}

class Postcard {
  final String code; // 导入的原始码
  final String friendName; // 对方岛名
  final Emotion friendPet; // 到访的招牌精灵
  final DateTime receivedAt;

  const Postcard({
    required this.code,
    required this.friendName,
    required this.friendPet,
    required this.receivedAt,
  });
}

class SocialState {
  String myName;
  final List<Postcard> postcards;
  Emotion? visitingPet;
  DateTime? visitingExpire;

  SocialState({
    this.myName = '无名小屿',
    List<Postcard>? postcards,
    this.visitingPet,
    this.visitingExpire,
  }) : postcards = postcards ?? [];

  bool get hasVisitor =>
      visitingPet != null &&
      visitingExpire != null &&
      DateTime.now().isBefore(visitingExpire!);
}
