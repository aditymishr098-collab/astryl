// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Heliora';

  @override
  String get tagline => '探索太阳系，完全离线';

  @override
  String get navExplore => '探索';

  @override
  String get navCompare => '对比';

  @override
  String get navWeight => '体重';

  @override
  String get navQuiz => '测验';

  @override
  String get viewMode => '视图模式';

  @override
  String get settings => '设置';

  @override
  String get notToScale => '未按比例 · 点按行星即可打开';

  @override
  String get dragToRotate => '拖动旋转 · 双指缩放';

  @override
  String get planetsTitle => '行星';

  @override
  String get planetMercury => '水星';

  @override
  String get planetVenus => '金星';

  @override
  String get planetEarth => '地球';

  @override
  String get planetMars => '火星';

  @override
  String get planetJupiter => '木星';

  @override
  String get planetSaturn => '土星';

  @override
  String get planetUranus => '天王星';

  @override
  String get planetNeptune => '海王星';

  @override
  String planetOrder(int n) {
    return '距太阳第 $n 颗行星';
  }

  @override
  String get openDetails => '查看详情';

  @override
  String get diameter => '直径';

  @override
  String get gravity => '重力';

  @override
  String get avgTemp => '平均温度';

  @override
  String get avgTempShort => '平均温度';

  @override
  String get dayLength => '一天';

  @override
  String get yearLength => '一年';

  @override
  String get moons => '已知卫星';

  @override
  String get moonsShort => '卫星';

  @override
  String get distance => '与太阳的距离';

  @override
  String get pressure => '表面气压';

  @override
  String get noSurface => '没有固体表面';

  @override
  String valueKm(String value) {
    return '$value 公里';
  }

  @override
  String valueMillionKm(String value) {
    return '$value 百万公里';
  }

  @override
  String valueHours(String value) {
    return '$value 小时';
  }

  @override
  String valueDays(String value) {
    return '$value 天';
  }

  @override
  String valueYears(String value) {
    return '$value 年';
  }

  @override
  String get atmosphere => '大气';

  @override
  String get thinAtmosphere => '几乎没有大气。这些气体只构成一层非常稀薄的外逸层。';

  @override
  String get oxygen => '氧气';

  @override
  String get oxygenVsEarth => '氧气与地球对比';

  @override
  String get breathable => '人类可以呼吸';

  @override
  String get notBreathable => '无法呼吸，需要宇航服';

  @override
  String weightFeelsLike(String weight) {
    return '地球上的 $weight 公斤在这里相当于';
  }

  @override
  String get gasCo2 => '二氧化碳';

  @override
  String get gasN2 => '氮气';

  @override
  String get gasO2 => '氧气';

  @override
  String get gasAr => '氩气';

  @override
  String get gasH2 => '氢气';

  @override
  String get gasHe => '氦气';

  @override
  String get gasCh4 => '甲烷';

  @override
  String get gasNa => '钠';

  @override
  String get gasK => '钾';

  @override
  String get compareTitle => '行星对比';

  @override
  String get compareHint => '选择两颗行星进行并排对比。';

  @override
  String get weightTitle => '你在其他行星上的体重';

  @override
  String get weightInput => '你在地球上的体重（公斤）';

  @override
  String gravityTimes(String factor) {
    return '地球重力的 $factor×';
  }

  @override
  String get quizTitle => '行星测验';

  @override
  String get quizIntro => '10 道关于行星和卫星的题目。你能答对几道？';

  @override
  String get quizStart => '开始测验';

  @override
  String quizProgress(int current, int total) {
    return '第 $current 题，共 $total 题';
  }

  @override
  String get quizNext => '下一题';

  @override
  String get quizSeeResult => '查看结果';

  @override
  String get quizCorrect => '答对了！';

  @override
  String quizWrong(String answer) {
    return '不对。正确答案是$answer。';
  }

  @override
  String quizScore(int score, int total) {
    return '你答对了 $total 题中的 $score 题';
  }

  @override
  String quizBest(int score) {
    return '最高分：$score';
  }

  @override
  String get quizNewBest => '新的最高分！';

  @override
  String get quizAgain => '再玩一次';

  @override
  String get qLargest => '哪颗行星最大？';

  @override
  String get qSmallest => '哪颗行星最小？';

  @override
  String get qHottest => '哪颗行星最热？';

  @override
  String get qColdest => '哪颗行星最冷？';

  @override
  String get qMostMoons => '哪颗行星的已知卫星最多？';

  @override
  String get qBreathable => '人类可以在哪颗行星上呼吸空气？';

  @override
  String get qClosest => '哪颗行星离太阳最近？';

  @override
  String get qFarthest => '哪颗行星离太阳最远？';

  @override
  String get qStrongestGravity => '哪颗行星的重力最强？';

  @override
  String get qShortestDay => '哪颗行星的一天最短？';

  @override
  String get qLongestDay => '哪颗行星的一天最长？';

  @override
  String get appearance => '外观';

  @override
  String get theme => '主题';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get language => '语言';

  @override
  String get appLanguage => '应用语言';

  @override
  String get languageNote => '20 种语言 · 包括行星名称';

  @override
  String get phoneLanguage => '手机语言';

  @override
  String get updates => '更新';

  @override
  String get version => '版本';

  @override
  String get checkForUpdates => '检查更新';

  @override
  String get checking => '正在检查…';

  @override
  String get autoUpdateCheck => '每天自动检查一次';

  @override
  String get updateNote => '更新来自 GitHub Releases。你的设置会一直保存在手机上。';

  @override
  String get upToDate => '你已是最新版本。';

  @override
  String get updateFailed => '无法连接 GitHub。请检查网络后重试。';

  @override
  String get updateAvailable => '有可用更新';

  @override
  String updateReady(String version) {
    return '版本 $version 可以下载了。';
  }

  @override
  String get download => '下载';

  @override
  String get later => '稍后';

  @override
  String get about => '关于';

  @override
  String get sourceCode => 'GitHub 上的源代码';

  @override
  String get privacyLine => '离线 · 无广告 · 无跟踪';

  @override
  String get dataSource => '资料来源：NASA Planetary Fact Sheet';

  @override
  String get openFailed => '无法打开链接。';

  @override
  String get bodySun => '太阳';

  @override
  String get bodyMoon => '月球';

  @override
  String get bodyPluto => '冥王星';

  @override
  String get moonIo => '木卫一';

  @override
  String get moonEuropa => '木卫二';

  @override
  String get moonGanymede => '木卫三';

  @override
  String get moonCallisto => '木卫四';

  @override
  String get moonTitan => '土卫六';

  @override
  String get moonEnceladus => '土卫二';

  @override
  String get moonTriton => '海卫一';

  @override
  String get kindStar => '我们的恒星，太阳系的中心';

  @override
  String get kindDwarf => '矮行星';

  @override
  String moonOf(String planet) {
    return '$planet的卫星';
  }

  @override
  String get orbitPeriod => '公转一周';

  @override
  String distanceFrom(String body) {
    return '与$body的距离';
  }

  @override
  String get composition => '它由什么组成';

  @override
  String get noAtmosphere => '没有真正的大气，几乎是真空。';

  @override
  String get majorMoons => '主要卫星';

  @override
  String get lifeTitle => '人类能在这里生活吗？';

  @override
  String get lifeScoreShort => '宜居分';

  @override
  String get lifeNote => '根据温度、气压、氧气、水、表面和重力计算。地球为 10 分。';

  @override
  String get water => '水';

  @override
  String get waterLiquid => '液态水';

  @override
  String get waterIce => '冰';

  @override
  String get waterOcean => '冰层下的海洋';

  @override
  String get waterNone => '没有水';

  @override
  String get surface => '表面';

  @override
  String get solidSurface => '固体表面';

  @override
  String get lifeHome => '就像家一样';

  @override
  String get lifeHard => '非常困难，需要封闭基地和宇航服';

  @override
  String get lifeNo => '人类无法生存';

  @override
  String get downloadInstall => '下载并安装';

  @override
  String downloadingPercent(String percent) {
    return '正在下载… $percent%';
  }

  @override
  String get installNow => '安装';

  @override
  String get allowInstalls => '请在打开的页面中允许 Heliora 安装应用，然后返回点按“安装”。';

  @override
  String get downloadFailed => '下载未完成。请检查网络后重试。';

  @override
  String get tryAgain => '重试';

  @override
  String get today => '今天';

  @override
  String get play => '播放';

  @override
  String get pause => '暂停';

  @override
  String get monthBack => '提前 30 天';

  @override
  String get monthForward => '推后 30 天';

  @override
  String get positionsNote => '这一天的真实位置 · 大小和距离未按比例 · 点按行星';

  @override
  String get navYou => '我';

  @override
  String get ageTitle => '你在其他行星上的年龄';

  @override
  String get setBirthDate => '设置你的生日';

  @override
  String get changeBirthDate => '更改';

  @override
  String nextBirthday(String days) {
    return '$days 天后过下一个生日';
  }

  @override
  String get ageNote => '你的生日只保存在这部手机上。';

  @override
  String get share => '分享';

  @override
  String shareText(String planet) {
    return 'Heliora 中的$planet，免费离线太阳系应用：https://github.com/lumio-apps/heliora';
  }

  @override
  String get shareFailed => '无法分享图片。';

  @override
  String get travelTitle => '有多远？';

  @override
  String get distanceFromEarth => '今天与地球的距离';

  @override
  String get lightTime => '光需要';

  @override
  String get bySpacecraft => '乘时速 60,000 公里的飞船';

  @override
  String get byCar => '乘时速 100 公里的汽车';

  @override
  String valueSeconds(String value) {
    return '$value 秒';
  }

  @override
  String valueMinutes(String value) {
    return '$value 分钟';
  }

  @override
  String get sizeTitle => '大小';

  @override
  String sizeTimes(String big, String times, String small) {
    return '$big的直径是$small的 $times×。';
  }

  @override
  String sizeSimilar(String a, String b) {
    return '$a和$b大小差不多。';
  }

  @override
  String get navSky => '星空';

  @override
  String get skyTitle => '今晚的星空';

  @override
  String get chooseCity => '选择你的城市';

  @override
  String get chooseCityHint => '选择离你最近的城市，查看月亮和今晚能看到的行星。不需要定位权限，数据只保存在手机上。';

  @override
  String get searchCity => '搜索城市';

  @override
  String get noCityFound => '没有找到城市';

  @override
  String get cityNote => '时间采用手机的时区。行星在黑暗天空中高于地平线至少 5° 时算作可见。';

  @override
  String illuminated(String percent) {
    return '$percent% 被照亮';
  }

  @override
  String get moonrise => '月出';

  @override
  String get moonset => '月落';

  @override
  String get sunset => '日落';

  @override
  String get sunrise => '日出';

  @override
  String get nextFull => '下次满月';

  @override
  String get nextNew => '下次新月';

  @override
  String get phaseNew => '新月';

  @override
  String get phaseWaxingCrescent => '娥眉月';

  @override
  String get phaseFirstQuarter => '上弦月';

  @override
  String get phaseWaxingGibbous => '盈凸月';

  @override
  String get phaseFull => '满月';

  @override
  String get phaseWaningGibbous => '亏凸月';

  @override
  String get phaseLastQuarter => '下弦月';

  @override
  String get phaseWaningCrescent => '残月';

  @override
  String get planetsTonight => '今晚的行星';

  @override
  String get statusVisible => '今晚可见';

  @override
  String get statusEvening => '傍晚，日落后';

  @override
  String get statusMorning => '清晨，日出前';

  @override
  String get statusNotVisible => '今晚不可见';

  @override
  String bestAt(String time) {
    return '最佳时间 $time';
  }

  @override
  String altitudeDir(String direction, String degrees) {
    return '$direction，高度 $degrees°';
  }

  @override
  String riseSet(String rise, String set) {
    return '升起 $rise · 落下 $set';
  }

  @override
  String get needsTelescope => '需要双筒望远镜或天文望远镜';

  @override
  String get dirN => '北';

  @override
  String get dirNE => '东北';

  @override
  String get dirE => '东';

  @override
  String get dirSE => '东南';

  @override
  String get dirS => '南';

  @override
  String get dirSW => '西南';

  @override
  String get dirW => '西';

  @override
  String get dirNW => '西北';

  @override
  String get findPlanet => '在天空中寻找';

  @override
  String finderTitle(String name) {
    return '寻找$name';
  }

  @override
  String get pointPhone => '举起手机，慢慢移动。';

  @override
  String turnRight(String degrees) {
    return '向右转 $degrees°';
  }

  @override
  String turnLeft(String degrees) {
    return '向左转 $degrees°';
  }

  @override
  String tiltUp(String degrees) {
    return '向上抬 $degrees°';
  }

  @override
  String tiltDown(String degrees) {
    return '向下压 $degrees°';
  }

  @override
  String onTarget(String name) {
    return '$name就在那里！';
  }

  @override
  String belowHorizon(String name) {
    return '$name现在在地平线以下。';
  }

  @override
  String risesAt(String time) {
    return '它将在 $time 升起。';
  }

  @override
  String get noSensor => '这部手机没有指南针传感器，无法使用寻星功能。';

  @override
  String get calibrate => '指南针需要校准：请用手机在空中画几次“8”字。';

  @override
  String get phoneNow => '手机指向';

  @override
  String get finderNote => '让手机背面朝向天空，并远离磁铁和金属。千万不要直视太阳。';

  @override
  String get eventsTitle => '太空事件';

  @override
  String get eventsSubtitle => '未来 12 个月的天象预告。';

  @override
  String eventsNext(String event, String when) {
    return '下一个：$event · $when';
  }

  @override
  String get eventFullMoon => '满月';

  @override
  String get eventNewMoon => '新月';

  @override
  String eventOpposition(String planet) {
    return '$planet冲日';
  }

  @override
  String eventEveningElongation(String planet) {
    return '$planet：最佳傍晚观测时间';
  }

  @override
  String eventMorningElongation(String planet) {
    return '$planet：最佳清晨观测时间';
  }

  @override
  String eventConjunction(String a, String b) {
    return '$a与$b相会';
  }

  @override
  String get eventMarchEquinox => '三月春分';

  @override
  String get eventJuneSolstice => '六月夏至';

  @override
  String get eventSeptemberEquinox => '九月秋分';

  @override
  String get eventDecemberSolstice => '十二月冬至';

  @override
  String get eventFullMoonDesc => '月面完全被照亮，大约在日落时升起。';

  @override
  String get eventNewMoonDesc => '月亮看不见。这是一个月中观星和看行星最黑暗的夜空。';

  @override
  String eventOppositionDesc(String planet) {
    return '$planet正好与太阳相对。它是今年最亮的时候，整夜可见。';
  }

  @override
  String eventEveningDesc(String planet, String degrees) {
    return '$planet与太阳相距 $degrees°，是最远的时候。日落后请看西方低空。';
  }

  @override
  String eventMorningDesc(String planet, String degrees) {
    return '$planet与太阳相距 $degrees°，是最远的时候。日出前请看东方低空。';
  }

  @override
  String eventConjunctionDesc(String degrees) {
    return '它们在天空中只相距 $degrees°。';
  }

  @override
  String get eventEquinoxDesc => '地球上各处昼夜几乎等长。';

  @override
  String get eventJuneSolsticeDesc => '北半球白昼最长，南半球白昼最短。';

  @override
  String get eventDecemberSolsticeDesc => '北半球白昼最短，南半球白昼最长。';

  @override
  String eventMeteorShower(String shower) {
    return '$shower流星雨';
  }

  @override
  String eventMeteorDesc(String rate, String percent) {
    return '在黑暗的天空下，每小时最多约 $rate 颗流星。届时月亮被照亮 $percent%。';
  }

  @override
  String get showerQuadrantids => '象限仪座流星雨';

  @override
  String get showerLyrids => '天琴座流星雨';

  @override
  String get showerEtaAquariids => '宝瓶座η流星雨';

  @override
  String get showerPerseids => '英仙座流星雨';

  @override
  String get showerOrionids => '猎户座流星雨';

  @override
  String get showerLeonids => '狮子座流星雨';

  @override
  String get showerGeminids => '双子座流星雨';

  @override
  String get showerUrsids => '小熊座流星雨';

  @override
  String get eventToday => '今天';

  @override
  String get eventTomorrow => '明天';

  @override
  String eventInDays(String days) {
    return '$days 天后';
  }

  @override
  String get eventsNote =>
      '日期在你的手机上计算，并按手机时区显示。流星雨极大日是每年的常见日期，可能相差一天。提醒只保存在你的手机上。';

  @override
  String get remindMe => '提醒我';

  @override
  String reminderSet(String date) {
    return '好的，我会在 $date 提醒你。';
  }

  @override
  String get reminderOff => '已取消提醒。';

  @override
  String get reminderTooLate => '这个事件太近了，无法设置提醒。';

  @override
  String get notificationsOff => 'Heliora 的通知已关闭。请在 Android 设置中打开。';

  @override
  String get reminderTomorrow => '明天发生';

  @override
  String get reminderToday => '今天发生';

  @override
  String get onlineTitle => '在线功能';

  @override
  String get onlineSubtitle =>
      '显示空间站和火箭发射。开启后，Heliora 只会连接 wheretheiss.at、Celestrak 和 Launch Library 2，它们能看到你手机的网络地址，不会发送其他任何内容。默认关闭。';

  @override
  String get turnOnOnline => '开启在线功能';

  @override
  String get issTitle => '空间站';

  @override
  String get issCardHint => '它现在在哪里，何时飞过你的上空';

  @override
  String get issNeedsOnline => '要显示空间站，Heliora 需要从网上获取它的轨道数据。下载一次后可离线使用数天。';

  @override
  String get issLoading => '正在获取轨道数据…';

  @override
  String get issFailed => '无法获取轨道数据。请检查网络后重试。';

  @override
  String issStale(String days) {
    return '轨道数据已有 $days 天，位置可能有偏差。请联网刷新。';
  }

  @override
  String get issHeight => '高度';

  @override
  String get issSpeed => '速度';

  @override
  String get issFromYou => '离你的距离';

  @override
  String valueKmh(String value) {
    return '$value 公里/小时';
  }

  @override
  String issAboveHorizon(String direction, String degrees) {
    return '现在就在你的地平线上方！请看$direction，高度 $degrees°。';
  }

  @override
  String get issBelowHorizon => '现在在你的地平线以下。';

  @override
  String issPassesTitle(String city) {
    return '$city上空的下几次飞越';
  }

  @override
  String get issNoPasses => '未来 5 天没有合适的飞越。';

  @override
  String issMaxHigh(String degrees) {
    return '最高 $degrees°';
  }

  @override
  String issFromTo(String start, String end) {
    return '$start到$end';
  }

  @override
  String get issVisible => '容易看到';

  @override
  String get issHidden => '不易看到';

  @override
  String get issPassTitle => '空间站正从你上空飞过';

  @override
  String issPassBody(String degrees, String direction) {
    return '10 分钟后升起，最高 $degrees°。请看$direction。';
  }

  @override
  String get issNote =>
      '位置由你的手机根据空间站的轨道数据计算。天空够暗且空间站被阳光照亮时最容易看到，它像一颗明亮快速移动的星星。';

  @override
  String get launchesNeedOnline => '开启在线功能，即可在这里查看即将进行的火箭发射。';

  @override
  String get launchesFailed => '无法更新发射列表，显示已保存的列表。';

  @override
  String get launchesNote => '发射时间来自 Launch Library 2，经常变动。名称和地点为英文。';

  @override
  String get launchReminderBody => '约一小时后发射。时间可能变动。';

  @override
  String get launchTimeTbd => '时间尚未确定';

  @override
  String get quizChoose => '选择难度';

  @override
  String get levelEasy => '简单';

  @override
  String get levelMedium => '中等';

  @override
  String get levelHard => '困难';

  @override
  String get levelEasyHint => '关于行星的基础知识';

  @override
  String get levelMediumHint => '行星和卫星';

  @override
  String get levelHardHint => '有难度的比较和排名';

  @override
  String get qStar => '下面哪一个是恒星，不是行星？';

  @override
  String get qDwarf => '下面哪一个是矮行星？';

  @override
  String get qMoonVisited => '人类走上过哪颗卫星？';

  @override
  String get qLargestMoon => '这些卫星中哪一颗最大？';

  @override
  String get qSmallestMoon => '这些卫星中哪一颗最小？';

  @override
  String get qThickAirMoon => '这些卫星中哪一颗有浓厚的大气？';

  @override
  String get qGeyserMoon => '哪颗卫星会向太空喷出水的喷泉？';

  @override
  String get qVolcanicMoon => '哪颗卫星上活火山最多？';

  @override
  String get qBackwardsMoon => '哪颗卫星绕它的行星逆向运行？';

  @override
  String get qBiggestRocky => '四颗岩质行星中哪一颗最大？';

  @override
  String get qColdestRocky => '四颗岩质行星中哪一颗最冷？';

  @override
  String get qHighestPressure => '哪颗行星表面的气压最高？';

  @override
  String get qSecondLargest => '哪颗行星是第二大的？';

  @override
  String get qLongestYear => '哪颗行星的一年最长？';

  @override
  String get qShortestYear => '哪颗行星的一年最短？';

  @override
  String get qSmallestGiant => '四颗巨行星中哪一颗最小？';

  @override
  String get qRockyLongestYear => '四颗岩质行星中哪一颗的一年最长？';

  @override
  String get qFastestMoon => '这些卫星中哪一颗绕行星转得最快？';

  @override
  String get qSlowestMoon => '这些卫星中哪一颗绕行星一圈用的时间最长？';

  @override
  String get qStrongestMoonGravity => '这些卫星中哪一颗的引力最强？';

  @override
  String get qColdestMoon => '这些卫星中哪一颗最冷？';

  @override
  String get qSecondLargestMoon => '这些卫星中哪一颗是第二大的？';

  @override
  String get factTitle => '你知道吗？';

  @override
  String get factTap => '点按查看另一条';

  @override
  String get factSun1 => '太阳集中了太阳系 99.8% 的质量。';

  @override
  String get factSun2 => '阳光大约要 8 分 20 秒才能到达地球。';

  @override
  String get factMercury1 => '水星上的一天，也就是从一次日出到下一次日出，大约是 176 个地球日，是它一年长度的两倍。';

  @override
  String get factMercury2 => '水星几乎没有空气，所以白天天空也是黑的，夜晚冷得刺骨。';

  @override
  String get factVenus1 => '金星自转方向相反，所以在金星上太阳从西边升起。';

  @override
  String get factVenus2 => '金星虽然离太阳更远，却比水星更热，因为它浓厚的大气把热量留住了。';

  @override
  String get factEarth1 => '地球是我们所知唯一有生命的地方，约 71% 的表面被水覆盖。';

  @override
  String get factEarth2 => '地球不是完美的球体。因为自转，赤道附近略微鼓起。';

  @override
  String get factMars1 => '火星上的奥林帕斯山是太阳系最高的火山，大约是珠穆朗玛峰的两倍半高。';

  @override
  String get factMars2 => '火星上的日落看起来是蓝色的。';

  @override
  String get factJupiter1 => '木星的质量是其他所有行星加起来的两倍多。';

  @override
  String get factJupiter2 => '大红斑是一场比地球还大的风暴，人们已经观测了 150 多年。';

  @override
  String get factSaturn1 => '土星相对于体积非常轻，如果有足够大的浴缸，它能浮在水上。';

  @override
  String get factSaturn2 => '土星环非常宽，却非常薄：有些地方只有大约十米厚。';

  @override
  String get factUranus1 => '天王星侧着身子绕太阳滚动，自转轴倾斜约 98 度。';

  @override
  String get factUranus2 => '天王星是第一颗用望远镜发现的行星，威廉·赫歇尔在 1781 年发现了它。';

  @override
  String get factNeptune1 => '海王星上的风是所有行星中最快的，超过每小时 2000 公里。';

  @override
  String get factNeptune2 => '海王星是先靠数学算出来、后才被人看到的：1846 年天文学家算出了它应该在哪里。';

  @override
  String get factMoon1 => '月球每年离地球远去约 3.8 厘米。';

  @override
  String get factMoon2 => '我们总是看到月球的同一面，因为它绕地球转一圈时恰好自转一圈。';

  @override
  String get factPluto1 => '冥王星上的一年约等于 248 个地球年。';

  @override
  String get factPluto2 => '冥王星上有一大片心形的冻氮平原。';

  @override
  String get factIo1 => '木卫一是我们所知火山活动最剧烈的天体，有数百座活火山。';

  @override
  String get factIo2 => '木星的引力不断挤压和拉伸木卫一，由此产生的热量驱动着它的火山。';

  @override
  String get factEuropa1 => '在冰壳之下，木卫二可能拥有大约相当于地球所有海洋两倍的水。';

  @override
  String get factEuropa2 => '木卫二是寻找地外生命的最佳地点之一，“欧罗巴快船”探测器正在前往那里。';

  @override
  String get factGanymede1 => '木卫三是太阳系中最大的卫星，甚至比水星还大。';

  @override
  String get factGanymede2 => '木卫三是已知唯一拥有自身磁场的卫星。';

  @override
  String get factCallisto1 => '木卫四是太阳系中陨击坑最密集的地方之一，表面非常古老。';

  @override
  String get factCallisto2 => '木卫四离木星足够远，受到的强辐射较少，所以科学家建议把它作为未来的基地。';

  @override
  String get factTitan1 => '土卫六是唯一拥有浓厚大气的卫星，表面气压比地球还高。';

  @override
  String get factTitan2 => '土卫六上有河流和湖泊，但里面是液态甲烷和乙烷，不是水。';

  @override
  String get factEnceladus1 => '土卫二通过南极附近的裂缝向太空喷出冰和水蒸气的喷流。';

  @override
  String get factEnceladus2 => '土卫二的喷流补充着土星的 E 环。';

  @override
  String get factTriton1 => '海卫一绕海王星逆向运行，所以它很可能原本是被海王星俘获的矮行星。';

  @override
  String get factTriton2 => '海卫一的温度约为 −235 °C，是太阳系中测得的最冷的地方之一。';

  @override
  String get jumpInput => '你在地球上的跳跃高度（厘米）';

  @override
  String jumpHigh(String height) {
    return '跳跃：$height';
  }

  @override
  String jumpFeelsLike(String height) {
    return '在地球上跳 $height，在这里会变成';
  }

  @override
  String get jumpNote => '起跳的力和在地球上一样。太阳和气态巨行星上没有可以站立的地面，所以这只是一个想象游戏。';

  @override
  String valueCm(String value) {
    return '$value 厘米';
  }

  @override
  String valueM(String value) {
    return '$value 米';
  }

  @override
  String get eclipseTotalLunar => '月全食';

  @override
  String get eclipsePartialLunar => '月偏食';

  @override
  String get eclipsePenumbralLunar => '半影月食';

  @override
  String get eclipseTotalSolar => '日全食';

  @override
  String get eclipseAnnularSolar => '日环食';

  @override
  String get eclipseHybridSolar => '日全环食';

  @override
  String get eclipsePartialSolar => '日偏食';

  @override
  String get eclipseTotalLunarDesc =>
      '月亮完全进入地球的影子，常常变成暗红色。地球夜晚一侧的人都能看到，肉眼观看是安全的。';

  @override
  String eclipsePartialLunarDesc(String percent) {
    return '月亮的一部分（宽度的 $percent%）进入地球的本影。肉眼观看是安全的。';
  }

  @override
  String get eclipsePenumbralLunarDesc => '月亮穿过地球淡淡的外层影子，只是稍微变暗，很难察觉。';

  @override
  String get eclipseTotalSolarDesc => '月亮沿着地球上一条狭窄的路径把太阳完全遮住。路径之外只能看到日偏食。';

  @override
  String get eclipseAnnularSolarDesc =>
      '月亮离地球稍远，无法完全遮住太阳，会留下一圈明亮的光环。光环只在一条狭窄的路径上可见，路径之外是日偏食。';

  @override
  String get eclipseHybridSolarDesc => '沿着它的路径，这次日食在有些地方是全食，在另一些地方是环食。路径之外是偏食。';

  @override
  String get eclipsePartialSolarDesc => '月亮只遮住太阳的一部分，地球上任何地方都看不到太阳被完全遮住。';

  @override
  String get eclipseNoCity => '在 Heliora 中选择一个城市，看看能否在那里观看。';

  @override
  String eclipseLunarUp(String city) {
    return '食甚时，$city 的月亮在地平线以上。';
  }

  @override
  String eclipseLunarPartly(String city) {
    return '在 $city，月亮只在月食的一部分时间里位于地平线以上。';
  }

  @override
  String eclipseLunarDown(String city) {
    return '在 $city，月亮一直在地平线以下，所以那里看不到。';
  }

  @override
  String eclipseSolarNone(String city) {
    return '在 $city 看不到：月影到不了那里，或者太阳在地平线以下。';
  }

  @override
  String eclipseSolarSlight(String city) {
    return '在 $city 最多只有很轻微的偏食，很难察觉。';
  }

  @override
  String eclipseSolarPartial(String city, String percent) {
    return '$city 的粗略估计：月亮最多遮住太阳宽度的约 $percent%。';
  }

  @override
  String eclipseSolarNear(String city) {
    return '$city 靠近太阳几乎或完全被遮住的路径。请查看日食地图；这个估计比较粗略。';
  }

  @override
  String get eclipseSolarSafety => '没有合格的日食眼镜，千万不要直视太阳。';

  @override
  String get alertsTitle => '提醒';

  @override
  String get tonightAlertSwitch => '每晚推送今晚的星空';

  @override
  String get tonightAlertTime => '时间';

  @override
  String get tonightAlertNote =>
      '在你选定的时间，推送一条关于月亮和可见行星的简短提示。内容在手机上计算，不需要网络。Android 只允许 Heliora 提前准备大约两周的提示，所以请时不时打开应用。';

  @override
  String get tonightNotifTitle => '今晚的星空';

  @override
  String tonightMoon(String phase, String percent) {
    return '月亮：$phase，$percent% 被照亮。';
  }

  @override
  String tonightPlanets(String planets) {
    return '可以找找：$planets。';
  }

  @override
  String get tonightNoPlanets => '傍晚的天空中没有明亮的行星。';

  @override
  String get tonightNoCity => '在 Heliora 中选择城市即可查看行星。';

  @override
  String get birthdayTitle => '我的生日星空';

  @override
  String get birthdaySubtitle => '你出生那天的月亮和行星，以及你人生中的重要日子。';

  @override
  String get birthdayCardHint => '月相、行星和里程碑';

  @override
  String get birthdayNeedDate => '设置你的生日';

  @override
  String get birthdayMoon => '你生日那天的月亮';

  @override
  String get birthdayPlanets => '那天的行星';

  @override
  String birthdayDaysOld(String count) {
    return '你今天出生 $count 天了。';
  }

  @override
  String get birthdayMilestones => '里程碑';

  @override
  String birthdayDayN(String count) {
    return '第 $count 天';
  }

  @override
  String get birthdayBillion => '10 亿秒';

  @override
  String get birthdayPassed => '已过';

  @override
  String get birthdayNote => '在你的手机上用 Heliora 其他部分相同的轨道计算。你的生日不会离开手机。';

  @override
  String get missionsTitle => '太空任务';

  @override
  String get missionsSubtitle => '太空探索中的著名时刻，从最早的开始。';

  @override
  String get missionsCardHint => '历史上的著名任务';

  @override
  String get missionSputnik1 =>
      '第一颗人造卫星。这个大小约如沙滩球的金属球绕地球运行了大约三个月，它的哔哔声可以用收音机收听到，太空时代由此开始。';

  @override
  String get missionVostok1 => '尤里·加加林成为第一个进入太空的人。他用约 108 分钟绕地球飞行了一圈。';

  @override
  String get missionApollo11 =>
      '尼尔·阿姆斯特朗和巴兹·奥尔德林降落在静海，成为第一批在月球上行走的人。迈克尔·柯林斯在轨道上等着他们。';

  @override
  String get missionVenera7 => '第一个降落在另一颗行星上并发回信号的探测器。它在金星的酷热中传回了约 23 分钟的数据。';

  @override
  String get missionViking1 => '它降落在火星上，工作了六年多，发回了另一颗行星表面的第一批长期照片和天气报告。';

  @override
  String get missionVoyager1 => '1977 年发射，飞掠木星和土星，2012 年进入星际空间。它是离地球最远的人造物体。';

  @override
  String get missionHubble =>
      '1990 年发射，在地球大气之上观察宇宙。它拍摄的清晰图像帮助测定了宇宙的年龄，还发现了成千上万个遥远的星系。';

  @override
  String get missionHuygens =>
      '惠更斯号探测器由卡西尼号携带，乘降落伞降落在土星的卫星土卫六上。这是外太阳系的第一次着陆，它还从表面发回了照片。';

  @override
  String get missionCuriosity =>
      '这辆汽车大小的火星车借助火箭驱动的“空中吊车”降落在盖尔陨石坑。它发现火星曾经具备适合生命的条件。';

  @override
  String get missionMangalyaan => '印度的火星轨道器任务一次就进入了火星轨道，这是任何国家的第一次，而且成本很低。';

  @override
  String get missionRosetta =>
      '罗塞塔号的着陆器菲莱降落在 67P/丘留莫夫–格拉西缅科彗星上，这是人类第一次在彗星上着陆。罗塞塔号本身绕这颗彗星飞行了两年。';

  @override
  String get missionNewhorizons => '经过九年的旅程，它飞掠冥王星，第一次让我们看到冰山和一大片心形平原。';

  @override
  String get missionPerseverance =>
      '毅力号火星车降落在耶泽罗陨石坑，寻找远古生命的迹象并收集岩石样本。它的直升机“机智号”完成了在另一颗行星上的首次动力飞行。';

  @override
  String get missionJwst =>
      '这台最大的太空望远镜有一面 6.5 米的金色镜面，在 150 万公里外用红外光观测天空。它能看到最早期的一些星系。';

  @override
  String get missionChandrayaan3 =>
      '印度成为第四个在月球上软着陆的国家，也是第一个在月球南极附近着陆的国家。“维克拉姆”着陆器带着“智慧”月球车。';

  @override
  String get spacecraftTitle => '航天器此刻';

  @override
  String get spacecraftSubtitle => '一些著名航天器此刻离地球有多远。';

  @override
  String get spacecraftCardHint => '旅行者号、JWST、火星车等';

  @override
  String get spacecraftDistance => '距地球';

  @override
  String get spacecraftAltitude => '距地面高度';

  @override
  String get spacecraftInAu => '以天文单位计';

  @override
  String get spacecraftSpeed => '速度';

  @override
  String get spacecraftSignal => '无线电信号需要';

  @override
  String get spacecraftNote =>
      '距离均为估算值。远方探测器的距离按平均速度推算，由于地球绕太阳运动，可能有约 1% 的误差。火星的距离是按今天计算的。1 AU（天文单位）就是地球到太阳的距离。';

  @override
  String valueBillionKm(String value) {
    return '$value 十亿公里';
  }

  @override
  String valueAu(String value) {
    return '$value AU';
  }

  @override
  String valueKmS(String value) {
    return '$value 公里/秒';
  }

  @override
  String get spacecraftVoyager1 =>
      '1977 年发射。2012 年成为第一个进入星际空间的航天器。它的无线电信号传到我们这里时，已经过去了大约一天。';

  @override
  String get spacecraftVoyager2 => '1977 年发射。它是唯一造访过天王星和海王星的航天器，2018 年进入星际空间。';

  @override
  String get spacecraftNewHorizons =>
      '2015 年飞掠冥王星，2019 年飞掠柯伊伯带天体阿罗科斯。它仍在向外飞行，仍在传回数据。';

  @override
  String get spacecraftJwst =>
      '最大的太空望远镜，2021 年发射。它位于名为 L2 的点附近，距地球约 150 万公里，遮阳板始终朝向太阳。';

  @override
  String get spacecraftIss => '大约每 90 分钟绕地球一圈。自 2000 年起，一直有人不间断地住在上面。';

  @override
  String get spacecraftHubble =>
      '1990 年发射，至今仍在工作。它在会让图像模糊的大气层之上绕地球运行，所以拍出的照片非常清晰。';

  @override
  String get spacecraftMarsRovers =>
      '好奇号（2012 年着陆）和毅力号（2021 年着陆）正在火星上行驶。火星的距离在约 5500 万公里到 4 亿多公里之间变化。';

  @override
  String get searchTooltip => '搜索';

  @override
  String get searchHint => '搜索行星、卫星、任务…';

  @override
  String get searchClear => '清除';

  @override
  String searchEmpty(String query) {
    return '没有找到“$query”。';
  }

  @override
  String get searchBodies => '行星和卫星';

  @override
  String get searchMissions => '任务';

  @override
  String get searchSpacecraft => '航天器';

  @override
  String get favoritesTitle => '收藏';

  @override
  String get favoritesEmpty => '点按行星、任务或航天器上的星标，就会收藏在这里。';

  @override
  String get favoriteAdd => '加入收藏';

  @override
  String get favoriteRemove => '取消收藏';

  @override
  String get textSize => '文字大小';

  @override
  String get textSizeNormal => '标准';

  @override
  String get textSizeLarge => '大';

  @override
  String get textSizeLarger => '特大';

  @override
  String get textSizeNote => '放大 Heliora 里的文字。永远不会小于手机自身的文字大小。';

  @override
  String get skyOtherNight => '夜空';

  @override
  String get planetsThatNight => '那晚的行星';

  @override
  String get previousDay => '前一天';

  @override
  String get nextDay => '后一天';

  @override
  String get pickDate => '选择日期';

  @override
  String get backToTonight => '回到今晚';

  @override
  String get moonCalendar => '月相日历';

  @override
  String get moonCalendarHint => '每天的月相';

  @override
  String get previousMonth => '上个月';

  @override
  String get nextMonth => '下个月';

  @override
  String get keyMoonDates => '本月主要月相';

  @override
  String get moonCalendarNote => '月相的日期和时间按手机时区显示，误差在一小时左右。';

  @override
  String get seeSkyThatDay => '查看这一天的星空';

  @override
  String get sunLightTitle => '太阳与光线';

  @override
  String get firstLight => '第一缕光';

  @override
  String get goldenMorningEnds => '早晨黄金时刻结束';

  @override
  String get solarNoon => '太阳最高';

  @override
  String get goldenEveningStarts => '傍晚黄金时刻开始';

  @override
  String get lastLight => '最后一缕光';

  @override
  String get darkSky => '完全黑暗的天空';

  @override
  String get sunDayLength => '白昼长度';

  @override
  String durationHm(String hours, String minutes) {
    return '$hours 小时 $minutes 分钟';
  }

  @override
  String get sunNote =>
      '黄金时刻是太阳在地平线以上不到 6° 的时候。第一缕光和最后一缕光出现在太阳位于地平线以下 6° 时，天空在太阳低于地平线 18° 时完全变黑。时间按你选的日期计算。';

  @override
  String get sunStaysUp => '这一天太阳不会落下。';

  @override
  String get sunStaysDown => '这一天太阳不会升起。';

  @override
  String get solarSystemTitle => '太阳系';

  @override
  String get starMapTitle => '星图';

  @override
  String get starMapCardHint => '你头顶的恒星和星座';

  @override
  String get starMapHint => '拖动可环顾四周，双指张开可放大，点按恒星或星座查看详情。';

  @override
  String get starsLabel => '恒星';

  @override
  String get constellationsLabel => '星座';

  @override
  String get starMapFind => '找到它';

  @override
  String get constellationsList => '所有星座';

  @override
  String magnitudeValue(String value) {
    return '星等 $value';
  }

  @override
  String get starBelowHorizon => '此刻在地平线以下';

  @override
  String get starMapNow => '现在';

  @override
  String get starUnnamed => '恒星';

  @override
  String get binocularsTitle => '双筒望远镜指南';

  @override
  String get binocularsHint => '用普通双筒望远镜可以看什么';

  @override
  String get binocularsIntro =>
      '双手握稳望远镜，比如把手肘靠在墙上或车顶上。远离城市灯光，寻找暗淡模糊的光斑，而不是清晰的亮点。';

  @override
  String get binocularsNote =>
      '时间表示在你所选城市夜晚黑暗时段内，每个天体最高的时刻。天体名称使用全球通用的名称。点按其中一个即可在星图上查看。';

  @override
  String get dsoCluster => '星团';

  @override
  String get dsoGalaxy => '星系';

  @override
  String get dsoNebula => '星云';

  @override
  String get storyOri =>
      '猎户座很容易找：三颗星排成一条短直线，是猎人的腰带。腰带上方，橙色的参宿四标出一侧肩膀；下方，蓝白色的参宿七标出一只脚。腰带下面悬着一小片模糊的光斑，那是猎户座大星云，一团正在孕育新恒星的云。猎户座在北半球是冬季傍晚的景象，在南半球则是夏季傍晚。';

  @override
  String get storyUMa =>
      '北斗七星是大熊座的一部分，它的七颗亮星很醒目。斗口末端的两颗星，天枢和天璇，指向北极星：沿这条线向上延伸，长度约为两星间距的五倍。在北半球的许多地方，北斗七星整夜绕着北极星转，永不落下。';

  @override
  String get storyUMi =>
      '北极星位于小熊座尾巴的尖端。它几乎不动，因为它差不多正好在地球北极的上方，所以整个天空看起来都在绕着它转。它在地平线上的高度等于你所在的纬度。它并不是很亮的星，却是找北方最有用的一颗。在南半球看不到它。';

  @override
  String get storyCas =>
      '仙后座像一个W或M，取决于时间和季节，由五颗较亮的星组成。它与北斗七星分别在北极星的两侧，所以一个低时另一个就高。在古老的传说中，她是一位夸耀自己美貌的王后。';

  @override
  String get storyCyg =>
      '天鹅座沿着银河飞行。它最亮的几颗星组成北十字，顶端是天津四，也就是天鹅的尾巴。远离城市灯光时，银河像一条淡淡的光河穿过天鹅，双筒望远镜能让你看出它由无数暗星组成。夏季和秋季的傍晚是最佳时间。';

  @override
  String get storySco =>
      '天蝎座像一只蝎子，弯曲的尾巴末端带着钩。它的心脏是红色的心宿二，名字的意思是“火星的对手”，因为两者颜色相近。在北半球它是夏季星座，位置偏南、较低；在南半球的人看来，它会升到头顶高处。';

  @override
  String get storyLeo =>
      '狮子座是少数真的像其动物的星座之一。一个反过来的问号形状的星群，叫“镰刀”，组成头和胸，末端是明亮的轩辕十四，即狮子的心脏。东边的三角形星群是它的后身。北半球春季的傍晚是最佳时间。';

  @override
  String get storyTau =>
      '金牛座的脸呈V字形，那就是毕星团，橙色的毕宿五是它的眼睛。毕宿五看起来像属于这个星团，其实离我们近得多。更高处是昴星团，也叫七姐妹，是一小群蓝色的星，大多数人能看到六七颗。昴星团举世闻名，出现在许多文化的故事里。';

  @override
  String get storyGem =>
      '双子座由两颗亮星标出，北河二和北河三，像两兄弟的头并排而立。北河三更亮，带点橙色。北河二其实是由六颗星组成的系统。在北半球，冬季和春季的傍晚可在高空找到它们。';

  @override
  String get storyLyr =>
      '天琴座虽小，却有织女星，北天最亮的星之一。织女星呈蓝白色，与天鹅座的天津四、天鹰座的河鼓二一起组成夏季大三角。紧挨着织女星，一个小小的平行四边形星群构成了琴身。';

  @override
  String get storyCru =>
      '南十字座是所有星座中最小的，却是最著名的之一。四颗亮星组成一个十字，长臂上的两颗星指向南天极，因此它能帮助旅行者找到南方。在北半球大部分地区看不到它。';
}
