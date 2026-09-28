/// 游戏图标组件：正式 AI 图标优先，缺失时回退到统一的 Material 图标。
library;

import 'package:flutter/material.dart';

import '../../domain/config/game_config.dart';

const Map<ItemId, String> _itemFiles = {
  ItemId.sunnyCrystal: 'sun_crystal',
  ItemId.stardust: 'stardust',
  ItemId.morningDew: 'morning_dew',
  ItemId.prismCrystal: 'rainbow_crystal',
  ItemId.mistDew: 'mist_dew',
  ItemId.warmFront: 'warm_front',
  ItemId.tailwind: 'tailwind',
  ItemId.knotShard: 'heart_knot_shard',
  ItemId.cloudMica: 'cloud_mica',
  ItemId.lantern: 'lantern',
};

class ItemIcon extends StatelessWidget {
  final ItemId id;
  final double size;
  const ItemIcon(this.id, {super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    final file = _itemFiles[id];
    return Image.asset(
      'assets/items/icons/$file.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => SizedBox(
          width: size,
          height: size,
          child: const Center(child: Icon(Icons.auto_awesome_rounded))),
    );
  }
}

class SouvenirIcon extends StatelessWidget {
  final String souvenirId;
  final double size;
  const SouvenirIcon(this.souvenirId, {super.key, this.size = 22});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/souvenirs/$souvenirId.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => SizedBox(
          width: size,
          height: size,
          child: const Center(child: Icon(Icons.card_giftcard_rounded))),
    );
  }
}

class UiStickerIcon extends StatelessWidget {
  final String path;
  final double size;
  final IconData fallback;

  const UiStickerIcon(this.path,
      {super.key, this.size = 24, this.fallback = Icons.auto_awesome_rounded});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/ui/$path.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => SizedBox(
        width: size,
        height: size,
        child: Center(child: Icon(fallback, size: size * 0.8)),
      ),
    );
  }
}
