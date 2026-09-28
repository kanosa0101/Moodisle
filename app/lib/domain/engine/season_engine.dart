/// 四季/节日引擎（docs/02 季节位；纯函数，UI 取色 + 横幅）。
library;

class SeasonDef {
  final String id;
  final String cn;
  final int seaColor;
  final int sandColor;
  final String particle; // sakura / firefly / leaf / snow
  final String tip;
  const SeasonDef(
      this.id, this.cn, this.seaColor, this.sandColor, this.particle, this.tip);
}

const List<SeasonDef> kSeasons = [
  SeasonDef('spring', '春', 0xFF9BD4E8, 0xFFF4E0A6, 'sakura', '樱粉漫天，万物舒展。'),
  SeasonDef('summer', '夏', 0xFF8FD0EE, 0xFFF6E2A0, 'firefly', '萤火轻舞，生机盎然。'),
  SeasonDef('autumn', '秋', 0xFF9BC4D8, 0xFFECCF8E, 'leaf', '金叶纷飞，静待收获。'),
  SeasonDef('winter', '冬', 0xFFAFC8DC, 0xFFE9E2CF, 'snow', '白雪皑皑，蓄势新生。'),
];

SeasonDef seasonOf(DateTime d) {
  final m = d.month;
  if (m >= 3 && m <= 5) return kSeasons[0];
  if (m >= 6 && m <= 8) return kSeasons[1];
  if (m >= 9 && m <= 11) return kSeasons[2];
  return kSeasons[3];
}

class FestivalDef {
  final String name;
  final int month;
  final int fromDay;
  final int toDay;
  final String blurb;
  const FestivalDef(
      this.name, this.month, this.fromDay, this.toDay, this.blurb);
}

const List<FestivalDef> kFestivals = [
  FestivalDef('新年', 1, 1, 3, '新年快乐，回廊掉落更丰厚！'),
  FestivalDef('儿童节', 6, 1, 1, '童心未泯，好运加倍！'),
  FestivalDef('仲夏夜', 6, 20, 22, '萤火满岛，时令掉落更丰！'),
  FestivalDef('万圣夜', 10, 31, 31, '南瓜灯亮起，好运降临！'),
  FestivalDef('圣诞', 12, 24, 26, '暖冬礼物，掉落翻倍！'),
];

FestivalDef? festivalOf(DateTime d) {
  for (final f in kFestivals) {
    if (d.month == f.month && d.day >= f.fromDay && d.day <= f.toDay) return f;
  }
  return null;
}
