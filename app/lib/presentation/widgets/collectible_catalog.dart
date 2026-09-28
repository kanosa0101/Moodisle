/// 装扮与纪念品图鉴：完整展示挂件、岛屿装饰和云游收藏。
library;

import 'package:flutter/material.dart';

import '../../application/game_controller.dart';
import '../../domain/config/roam_config.dart';
import '../../shared/theme/tokens.dart';
import 'game_icons.dart';

enum _CollectionFilter { all, pendant, decor, roam }

class CollectibleCatalog extends StatefulWidget {
  final GameController controller;
  const CollectibleCatalog({super.key, required this.controller});

  @override
  State<CollectibleCatalog> createState() => _CollectibleCatalogState();
}

class _CollectibleCatalogState extends State<CollectibleCatalog> {
  _CollectionFilter _filter = _CollectionFilter.all;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final roamIds = kRoamRoutes
            .expand((route) => route.pool.map((entry) => entry.$1))
            .toSet();
        final shopIds = kDecorShop.map((item) => item.souvenirId).toSet();
        final all = kSouvenirs.values.toList();
        final visible = all.where((item) {
          return switch (_filter) {
            _CollectionFilter.all => true,
            _CollectionFilter.pendant => item.pendant,
            _CollectionFilter.decor => !item.pendant,
            _CollectionFilter.roam => roamIds.contains(item.id),
          };
        }).toList();
        final ownedCount = all
            .where((item) =>
                (widget.controller.state.roam.souvenirs[item.id] ?? 0) > 0)
            .length;

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: PaperPanel.decoration(),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('已发现 $ownedCount / ${all.length} 件',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final filter in _CollectionFilter.values)
                    ChoiceChip(
                      label: Text(_label(filter)),
                      selected: _filter == filter,
                      onSelected: (_) => setState(() => _filter = filter),
                      selectedColor: const Color(0xFFFFE5BA),
                      backgroundColor: const Color(0xFFFFFDF7),
                      side: BorderSide(
                          color: _filter == filter
                              ? MoodisleColors.orange
                              : MoodisleColors.line),
                      labelStyle: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ]),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(builder: (context, constraints) {
            final count = constraints.maxWidth >= 820
                ? 5
                : constraints.maxWidth >= 600
                    ? 4
                    : constraints.maxWidth >= 400
                        ? 3
                        : 2;
            return GridView.builder(
              itemCount: visible.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: count,
                mainAxisSpacing: 9,
                crossAxisSpacing: 9,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (context, index) {
                final item = visible[index];
                final count =
                    widget.controller.state.roam.souvenirs[item.id] ?? 0;
                final sources = <String>[
                  if (shopIds.contains(item.id)) '装扮商店',
                  if (roamIds.contains(item.id)) '伙伴云游',
                ];
                return _CollectibleCard(
                  item: item,
                  count: count,
                  sources: sources,
                  onTap: () => _showDetail(context, item, count, sources),
                );
              },
            );
          }),
        ]);
      },
    );
  }

  String _label(_CollectionFilter filter) => switch (filter) {
        _CollectionFilter.all => '全部',
        _CollectionFilter.pendant => '伙伴挂件',
        _CollectionFilter.decor => '岛屿装饰',
        _CollectionFilter.roam => '云游纪念品',
      };

  void _showDetail(
      BuildContext context, SouvenirDef item, int count, List<String> sources) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: MoodisleColors.paper,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MoodisleRadii.xl)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: '关闭',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
              _SouvenirArtwork(item: item, count: count, size: 190),
              const SizedBox(height: 8),
              Text(item.cn,
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.w900)),
              const SizedBox(height: 5),
              Text(
                  '${item.pendant ? '伙伴挂件' : '岛屿装饰'} · ${_rarity(item.rarity)}',
                  style: const TextStyle(
                      fontSize: 12, color: MoodisleColors.ink2)),
              const SizedBox(height: 8),
              Text(
                count > 0 ? '已拥有 ×$count' : '未发现',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color:
                        count > 0 ? MoodisleColors.ink : MoodisleColors.ink2),
              ),
              if (sources.isNotEmpty) ...[
                const SizedBox(height: 5),
                Text('可通过 ${sources.join('、')} 获得',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 11.5, color: MoodisleColors.ink2)),
              ],
            ]),
          ),
        ),
      ),
    );
  }

  String _rarity(int rarity) => switch (rarity) {
        3 => '限定',
        2 => '稀有',
        _ => '普通',
      };
}

class _CollectibleCard extends StatelessWidget {
  final SouvenirDef item;
  final int count;
  final List<String> sources;
  final VoidCallback onTap;

  const _CollectibleCard({
    required this.item,
    required this.count,
    required this.sources,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final owned = count > 0;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(MoodisleRadii.m),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDF7),
          borderRadius: BorderRadius.circular(MoodisleRadii.m),
          border: Border.all(
              color: owned ? MoodisleColors.green : MoodisleColors.line),
        ),
        child: Column(children: [
          Expanded(
            child: Center(
              child: _SouvenirArtwork(item: item, count: count, size: 96),
            ),
          ),
          const SizedBox(height: 4),
          Text(item.cn,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(
            owned ? '已拥有 ×$count' : '未发现',
            maxLines: 1,
            style: const TextStyle(fontSize: 9.5, color: MoodisleColors.ink2),
          ),
          Text(
            sources.isEmpty
                ? (item.pendant ? '伙伴挂件' : '岛屿装饰')
                : sources.join(' · '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 8.5, color: MoodisleColors.ink2),
          ),
        ]),
      ),
    );
  }
}

class _SouvenirArtwork extends StatelessWidget {
  final SouvenirDef item;
  final int count;
  final double size;
  const _SouvenirArtwork(
      {required this.item, required this.count, required this.size});

  @override
  Widget build(BuildContext context) {
    final image = SouvenirIcon(item.id, size: size);
    return count > 0
        ? image
        : ColorFiltered(
            colorFilter: const ColorFilter.matrix([
              0.2126,
              0.7152,
              0.0722,
              0,
              0,
              0.2126,
              0.7152,
              0.0722,
              0,
              0,
              0.2126,
              0.7152,
              0.0722,
              0,
              0,
              0,
              0,
              0,
              1,
              0,
            ]),
            child: Opacity(opacity: 0.62, child: image),
          );
  }
}
