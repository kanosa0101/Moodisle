/// 精灵云游（Idle 派遣，docs/02 §7）：离线按时长结算，纯外观纪念品。
library;

/// 三条天气航线。
class RoamRoute {
  final String id;
  final String cn;
  final String desc;
  final Duration duration;
  final int Function(int roll) count; // 产出件数
  final List<(String, int)> pool; // (纪念品id, 权重)

  const RoamRoute(
      this.id, this.cn, this.desc, this.duration, this.count, this.pool);
}

/// 八种天气收藏（挂件/装饰，3 稀有度；纯外观红线）。
class SouvenirDef {
  final String id;
  final String cn;
  final bool pendant; // true=挂件 false=装饰
  final int rarity; // 1普通 2稀有 3限定
  const SouvenirDef(this.id, this.cn,
      {required this.pendant, required this.rarity});
}

const Map<String, SouvenirDef> kSouvenirs = {
  'cloudBell': SouvenirDef('cloudBell', '云铃', pendant: true, rarity: 1),
  'windmillLamp': SouvenirDef('windmillLamp', '风车灯', pendant: true, rarity: 1),
  'rainbowHoop': SouvenirDef('rainbowHoop', '虹环', pendant: true, rarity: 2),
  'starChartScarf':
      SouvenirDef('starChartScarf', '星图巾', pendant: true, rarity: 3),
  'rainGauge': SouvenirDef('rainGauge', '雨量杯', pendant: false, rarity: 1),
  'sunnyRainDoll':
      SouvenirDef('sunnyRainDoll', '晴雨娃娃', pendant: false, rarity: 2),
  'convectionFire':
      SouvenirDef('convectionFire', '对流篝火', pendant: false, rarity: 1),
  'auroraVeil': SouvenirDef('auroraVeil', '极光纱', pendant: false, rarity: 3),
  // —— 装扮商店装饰/氛围件（docs/02 §8 货架） ——
  'breeze_chime_stand':
      SouvenirDef('breeze_chime_stand', '微风风铃架', pendant: false, rarity: 1),
  'travel_mailbox':
      SouvenirDef('travel_mailbox', '旅途邮筒', pendant: false, rarity: 1),
  'warm_night_campfire':
      SouvenirDef('warm_night_campfire', '暖夜篝火', pendant: false, rarity: 2),
  'star_wish_swing':
      SouvenirDef('star_wish_swing', '星愿秋千', pendant: false, rarity: 3),
  'lotus_boat': SouvenirDef('lotus_boat', '莲叶小船', pendant: false, rarity: 1),
  'fog_lamp_ornament':
      SouvenirDef('fog_lamp_ornament', '雾灯桩', pendant: false, rarity: 1),
  'shell_wind_chime':
      SouvenirDef('shell_wind_chime', '贝壳风铃', pendant: false, rarity: 1),
  'weather_house':
      SouvenirDef('weather_house', '晴雨表小屋', pendant: false, rarity: 2),
  'rainbow_arch':
      SouvenirDef('rainbow_arch', '虹光拱门', pendant: false, rarity: 3),
  'meteor_wishing_pool':
      SouvenirDef('meteor_wishing_pool', '流星许愿池', pendant: false, rarity: 3),
  'aurora_curtain':
      SouvenirDef('aurora_curtain', '极光帘', pendant: false, rarity: 3),
  'four_seasons_flower_clock': SouvenirDef('four_seasons_flower_clock', '四季花钟',
      pendant: false, rarity: 2),
};

const List<RoamRoute> kRoamRoutes = [
  RoamRoute(
    'monsoon',
    '季风短航',
    '近海小镇的轻松短途',
    Duration(minutes: 30),
    _count1,
    [
      ('cloudBell', 5),
      ('windmillLamp', 5),
      ('rainGauge', 4),
      ('convectionFire', 4)
    ],
  ),
  RoamRoute(
    'tradeWind',
    '信风半日',
    '山野驿道的半日远行',
    Duration(hours: 4),
    _count1to2,
    [
      ('rainGauge', 4),
      ('convectionFire', 4),
      ('cloudBell', 3),
      ('windmillLamp', 3),
      ('rainbowHoop', 2),
      ('sunnyRainDoll', 2),
    ],
  ),
  RoamRoute(
    'polarNight',
    '极地长航',
    '星空极夜的过夜长途',
    Duration(hours: 12),
    _count2to3,
    [
      ('starChartScarf', 4),
      ('auroraVeil', 4),
      ('rainbowHoop', 3),
      ('sunnyRainDoll', 3),
      ('windmillLamp', 2),
      ('cloudBell', 1),
    ],
  ),
];

int _count1(int _) => 1;
int _count1to2(int roll) => 1 + (roll % 2 == 0 ? 1 : 0);
int _count2to3(int roll) => 2 + (roll % 2 == 0 ? 1 : 0);

RoamRoute routeById(String id) =>
    kRoamRoutes.firstWhere((r) => r.id == id, orElse: () => kRoamRoutes.first);

/// 装扮商店货架（docs/02 §8：只卖外观）。cost 币种：sunny=晴晶 / stardust=星屑。
class DecorShopItem {
  final String souvenirId;
  final int costSunny;
  final int costStardust;
  const DecorShopItem(this.souvenirId, this.costSunny, [this.costStardust = 0]);
}

const List<DecorShopItem> kDecorShop = [
  DecorShopItem('breeze_chime_stand', 6),
  DecorShopItem('travel_mailbox', 5),
  DecorShopItem('warm_night_campfire', 6),
  DecorShopItem('star_wish_swing', 8),
  DecorShopItem('lotus_boat', 5),
  DecorShopItem('fog_lamp_ornament', 5),
  DecorShopItem('shell_wind_chime', 4),
  DecorShopItem('weather_house', 8),
  DecorShopItem('rainbow_arch', 10, 20),
  DecorShopItem('meteor_wishing_pool', 10, 20),
  DecorShopItem('aurora_curtain', 12, 30),
  DecorShopItem('four_seasons_flower_clock', 10, 20),
];
