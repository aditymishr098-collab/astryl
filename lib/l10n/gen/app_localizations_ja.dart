// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Heliora';

  @override
  String get tagline => '太陽系を探検しよう、完全オフライン';

  @override
  String get navExplore => '探検';

  @override
  String get navCompare => '比較';

  @override
  String get navWeight => '体重';

  @override
  String get navQuiz => 'クイズ';

  @override
  String get viewMode => '表示モード';

  @override
  String get settings => '設定';

  @override
  String get notToScale => '縮尺は正確ではありません · 惑星をタップして開く';

  @override
  String get dragToRotate => 'ドラッグで回転 · ピンチでズーム';

  @override
  String get planetsTitle => '惑星';

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
    return '太陽から $n 番目の惑星';
  }

  @override
  String get openDetails => '詳細を開く';

  @override
  String get diameter => '直径';

  @override
  String get gravity => '重力';

  @override
  String get avgTemp => '平均気温';

  @override
  String get avgTempShort => '平均気温';

  @override
  String get dayLength => '1 日';

  @override
  String get yearLength => '1 年';

  @override
  String get moons => '既知の衛星';

  @override
  String get moonsShort => '衛星';

  @override
  String get distance => '太陽からの距離';

  @override
  String get pressure => '表面気圧';

  @override
  String get noSurface => '固い地表はありません';

  @override
  String valueKm(String value) {
    return '$value km';
  }

  @override
  String valueMillionKm(String value) {
    return '$value 百万 km';
  }

  @override
  String valueHours(String value) {
    return '$value 時間';
  }

  @override
  String valueDays(String value) {
    return '$value 日';
  }

  @override
  String valueYears(String value) {
    return '$value 年';
  }

  @override
  String get atmosphere => '大気';

  @override
  String get thinAtmosphere => '大気はほとんどありません。これらの気体は外気圏と呼ばれるとても薄い層をつくっています。';

  @override
  String get oxygen => '酸素';

  @override
  String get oxygenVsEarth => '酸素：地球との比較';

  @override
  String get breathable => '人間が呼吸できる';

  @override
  String get notBreathable => '呼吸できません。宇宙服が必要です';

  @override
  String weightFeelsLike(String weight) {
    return '地球で $weight kg の人はここでは';
  }

  @override
  String get gasCo2 => '二酸化炭素';

  @override
  String get gasN2 => '窒素';

  @override
  String get gasO2 => '酸素';

  @override
  String get gasAr => 'アルゴン';

  @override
  String get gasH2 => '水素';

  @override
  String get gasHe => 'ヘリウム';

  @override
  String get gasCh4 => 'メタン';

  @override
  String get gasNa => 'ナトリウム';

  @override
  String get gasK => 'カリウム';

  @override
  String get compareTitle => '惑星を比較';

  @override
  String get compareHint => '2 つの惑星を選んで並べて比べましょう。';

  @override
  String get weightTitle => 'ほかの惑星でのあなたの体重';

  @override
  String get weightInput => '地球でのあなたの体重 (kg)';

  @override
  String gravityTimes(String factor) {
    return '地球の重力の $factor×';
  }

  @override
  String get quizTitle => '惑星クイズ';

  @override
  String get quizIntro => '惑星と衛星についての 10 問。何問正解できるかな？';

  @override
  String get quizStart => 'クイズを始める';

  @override
  String quizProgress(int current, int total) {
    return '$total 問中 $current 問目';
  }

  @override
  String get quizNext => '次へ';

  @override
  String get quizSeeResult => '結果を見る';

  @override
  String get quizCorrect => '正解！';

  @override
  String quizWrong(String answer) {
    return '残念。正解は$answerです。';
  }

  @override
  String quizScore(int score, int total) {
    return '$total 問中 $score 問正解';
  }

  @override
  String quizBest(int score) {
    return 'ベストスコア：$score';
  }

  @override
  String get quizNewBest => 'ベストスコア更新！';

  @override
  String get quizAgain => 'もう一度遊ぶ';

  @override
  String get qLargest => 'いちばん大きい惑星は？';

  @override
  String get qSmallest => 'いちばん小さい惑星は？';

  @override
  String get qHottest => 'いちばん暑い惑星は？';

  @override
  String get qColdest => 'いちばん寒い惑星は？';

  @override
  String get qMostMoons => '既知の衛星がいちばん多い惑星は？';

  @override
  String get qBreathable => '人間が空気を呼吸できる惑星は？';

  @override
  String get qClosest => '太陽にいちばん近い惑星は？';

  @override
  String get qFarthest => '太陽からいちばん遠い惑星は？';

  @override
  String get qStrongestGravity => '重力がいちばん強い惑星は？';

  @override
  String get qShortestDay => '1 日がいちばん短い惑星は？';

  @override
  String get qLongestDay => '1 日がいちばん長い惑星は？';

  @override
  String get appearance => '外観';

  @override
  String get theme => 'テーマ';

  @override
  String get themeSystem => 'システム';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get language => '言語';

  @override
  String get appLanguage => 'アプリの言語';

  @override
  String get languageNote => '20 言語 · 惑星の名前も';

  @override
  String get phoneLanguage => 'スマホの言語';

  @override
  String get updates => 'アップデート';

  @override
  String get version => 'バージョン';

  @override
  String get checkForUpdates => 'アップデートを確認';

  @override
  String get checking => '確認中…';

  @override
  String get autoUpdateCheck => '1 日 1 回自動で確認';

  @override
  String get updateNote => 'アップデートは GitHub Releases から届きます。設定はスマホに残ります。';

  @override
  String get upToDate => '最新バージョンです。';

  @override
  String get updateFailed => 'GitHub に接続できませんでした。インターネットを確認してもう一度お試しください。';

  @override
  String get updateAvailable => 'アップデートがあります';

  @override
  String updateReady(String version) {
    return 'バージョン $version をダウンロードできます。';
  }

  @override
  String get download => 'ダウンロード';

  @override
  String get later => '後で';

  @override
  String get about => 'このアプリについて';

  @override
  String get sourceCode => 'GitHub のソースコード';

  @override
  String get privacyLine => 'オフライン · 広告なし · トラッキングなし';

  @override
  String get dataSource => '出典：NASA Planetary Fact Sheet';

  @override
  String get openFailed => 'リンクを開けませんでした。';

  @override
  String get bodySun => '太陽';

  @override
  String get bodyMoon => '月';

  @override
  String get bodyPluto => '冥王星';

  @override
  String get moonIo => 'イオ';

  @override
  String get moonEuropa => 'エウロパ';

  @override
  String get moonGanymede => 'ガニメデ';

  @override
  String get moonCallisto => 'カリスト';

  @override
  String get moonTitan => 'タイタン';

  @override
  String get moonEnceladus => 'エンケラドゥス';

  @override
  String get moonTriton => 'トリトン';

  @override
  String get kindStar => '私たちの恒星、太陽系の中心';

  @override
  String get kindDwarf => '準惑星';

  @override
  String moonOf(String planet) {
    return '$planetの衛星';
  }

  @override
  String get orbitPeriod => '1 周';

  @override
  String distanceFrom(String body) {
    return '$bodyからの距離';
  }

  @override
  String get composition => '何でできているか';

  @override
  String get noAtmosphere => '本当の大気はなく、ほぼ真空です。';

  @override
  String get majorMoons => '主な衛星';

  @override
  String get lifeTitle => '人間はここで暮らせる？';

  @override
  String get lifeScoreShort => 'くらしスコア';

  @override
  String get lifeNote => '気温・気圧・酸素・水・地表・重力から計算。地球は 10 点。';

  @override
  String get water => '水';

  @override
  String get waterLiquid => '液体の水';

  @override
  String get waterIce => '氷';

  @override
  String get waterOcean => '氷の下の海';

  @override
  String get waterNone => '水なし';

  @override
  String get surface => '地表';

  @override
  String get solidSurface => '固い地表';

  @override
  String get lifeHome => 'まるで我が家';

  @override
  String get lifeHard => 'とても大変、密閉された基地と宇宙服が必要';

  @override
  String get lifeNo => '人間には不可能';

  @override
  String get downloadInstall => 'ダウンロードしてインストール';

  @override
  String downloadingPercent(String percent) {
    return 'ダウンロード中… $percent%';
  }

  @override
  String get installNow => 'インストール';

  @override
  String get allowInstalls =>
      '開いた画面で Heliora にアプリのインストールを許可し、戻って「インストール」をタップしてください。';

  @override
  String get downloadFailed => 'ダウンロードが完了しませんでした。インターネットを確認してもう一度お試しください。';

  @override
  String get tryAgain => '再試行';

  @override
  String get today => '今日';

  @override
  String get play => '再生';

  @override
  String get pause => '一時停止';

  @override
  String get monthBack => '30 日前';

  @override
  String get monthForward => '30 日後';

  @override
  String get positionsNote => 'この日の実際の位置 · 大きさと距離は縮尺どおりではありません · 惑星をタップ';

  @override
  String get navYou => 'あなた';

  @override
  String get ageTitle => 'ほかの惑星でのあなたの年齢';

  @override
  String get setBirthDate => '誕生日を設定';

  @override
  String get changeBirthDate => '変更';

  @override
  String nextBirthday(String days) {
    return '次の誕生日まであと $days 日';
  }

  @override
  String get ageNote => '誕生日はこのスマホにだけ保存されます。';

  @override
  String get share => '共有';

  @override
  String shareText(String planet) {
    return 'Heliora の$planet。無料・オフラインの太陽系アプリ：https://github.com/lumio-apps/heliora';
  }

  @override
  String get shareFailed => '画像を共有できませんでした。';

  @override
  String get travelTitle => 'どれくらい遠い？';

  @override
  String get distanceFromEarth => '今日の地球からの距離';

  @override
  String get lightTime => '光でかかる時間';

  @override
  String get bySpacecraft => '時速 60,000 km の宇宙船で';

  @override
  String get byCar => '時速 100 km の車で';

  @override
  String valueSeconds(String value) {
    return '$value 秒';
  }

  @override
  String valueMinutes(String value) {
    return '$value 分';
  }

  @override
  String get sizeTitle => '大きさ';

  @override
  String sizeTimes(String big, String times, String small) {
    return '$bigの直径は$smallの $times× です。';
  }

  @override
  String sizeSimilar(String a, String b) {
    return '$aと$bはほぼ同じ大きさです。';
  }

  @override
  String get navSky => '星空';

  @override
  String get skyTitle => '今夜の空';

  @override
  String get chooseCity => '都市を選ぶ';

  @override
  String get chooseCityHint =>
      'いちばん近い都市を選ぶと、月と今夜見える惑星がわかります。位置情報の許可は不要で、スマホの中だけに保存されます。';

  @override
  String get searchCity => '都市を検索';

  @override
  String get noCityFound => '都市が見つかりません';

  @override
  String get cityNote => '時刻はスマホのタイムゾーンです。暗い空で地平線から 5° 以上の高さにあれば見えるとしています。';

  @override
  String illuminated(String percent) {
    return '$percent% 輝面';
  }

  @override
  String get moonrise => '月の出';

  @override
  String get moonset => '月の入り';

  @override
  String get sunset => '日の入り';

  @override
  String get sunrise => '日の出';

  @override
  String get nextFull => '次の満月';

  @override
  String get nextNew => '次の新月';

  @override
  String get phaseNew => '新月';

  @override
  String get phaseWaxingCrescent => '三日月';

  @override
  String get phaseFirstQuarter => '上弦の月';

  @override
  String get phaseWaxingGibbous => '十三夜';

  @override
  String get phaseFull => '満月';

  @override
  String get phaseWaningGibbous => '寝待月';

  @override
  String get phaseLastQuarter => '下弦の月';

  @override
  String get phaseWaningCrescent => '有明月';

  @override
  String get planetsTonight => '今夜の惑星';

  @override
  String get statusVisible => '今夜見える';

  @override
  String get statusEvening => '夕方、日没後';

  @override
  String get statusMorning => '明け方、日の出前';

  @override
  String get statusNotVisible => '今夜は見えない';

  @override
  String bestAt(String time) {
    return '見ごろ $time';
  }

  @override
  String altitudeDir(String direction, String degrees) {
    return '$direction、高さ $degrees°';
  }

  @override
  String riseSet(String rise, String set) {
    return '出 $rise · 入り $set';
  }

  @override
  String get needsTelescope => '双眼鏡か望遠鏡が必要';

  @override
  String get dirN => '北';

  @override
  String get dirNE => '北東';

  @override
  String get dirE => '東';

  @override
  String get dirSE => '南東';

  @override
  String get dirS => '南';

  @override
  String get dirSW => '南西';

  @override
  String get dirW => '西';

  @override
  String get dirNW => '北西';

  @override
  String get findPlanet => '空で探す';

  @override
  String finderTitle(String name) {
    return '$nameを探す';
  }

  @override
  String get pointPhone => 'スマホを持ち上げて、ゆっくり動かしてください。';

  @override
  String turnRight(String degrees) {
    return '右へ $degrees° 回る';
  }

  @override
  String turnLeft(String degrees) {
    return '左へ $degrees° 回る';
  }

  @override
  String tiltUp(String degrees) {
    return '$degrees° 上へ傾ける';
  }

  @override
  String tiltDown(String degrees) {
    return '$degrees° 下へ傾ける';
  }

  @override
  String onTarget(String name) {
    return '$nameはすぐそこです！';
  }

  @override
  String belowHorizon(String name) {
    return '$nameは今、地平線の下にあります。';
  }

  @override
  String risesAt(String time) {
    return '$time に昇ります。';
  }

  @override
  String get noSensor => 'このスマホにはコンパスセンサーがないため、探す機能は使えません。';

  @override
  String get calibrate => 'コンパスの調整が必要です。スマホで数回、8の字を描くように動かしてください。';

  @override
  String get phoneNow => 'スマホが向いている方向';

  @override
  String get finderNote => 'スマホの背面を空に向け、磁石や金属から離してください。太陽は絶対に見ないでください。';

  @override
  String get eventsTitle => '宇宙イベント';

  @override
  String get eventsSubtitle => 'これから12か月の空の見どころ。';

  @override
  String eventsNext(String event, String when) {
    return '次: $event · $when';
  }

  @override
  String get eventFullMoon => '満月';

  @override
  String get eventNewMoon => '新月';

  @override
  String eventOpposition(String planet) {
    return '$planetが衝';
  }

  @override
  String eventEveningElongation(String planet) {
    return '$planet：夕方の見ごろ';
  }

  @override
  String eventMorningElongation(String planet) {
    return '$planet：明け方の見ごろ';
  }

  @override
  String eventConjunction(String a, String b) {
    return '$aと$bが接近';
  }

  @override
  String get eventMarchEquinox => '3月の春分';

  @override
  String get eventJuneSolstice => '6月の夏至';

  @override
  String get eventSeptemberEquinox => '9月の秋分';

  @override
  String get eventDecemberSolstice => '12月の冬至';

  @override
  String get eventFullMoonDesc => '月の全面が明るく輝きます。日没ごろに昇ります。';

  @override
  String get eventNewMoonDesc => '月は見えません。星や惑星を見るのに月で最も暗い空です。';

  @override
  String eventOppositionDesc(String planet) {
    return '$planetは太陽の反対側にあります。今年いちばん明るく、一晩中見えます。';
  }

  @override
  String eventEveningDesc(String planet, String degrees) {
    return '$planetは太陽から $degrees° 離れ、最も遠い位置です。日没後、西の低い空を見てください。';
  }

  @override
  String eventMorningDesc(String planet, String degrees) {
    return '$planetは太陽から $degrees° 離れ、最も遠い位置です。日の出前、東の低い空を見てください。';
  }

  @override
  String eventConjunctionDesc(String degrees) {
    return '空でわずか $degrees° の距離まで近づきます。';
  }

  @override
  String get eventEquinoxDesc => '地球のどこでも昼と夜がほぼ同じ長さになります。';

  @override
  String get eventJuneSolsticeDesc => '北半球で昼が最も長く、南半球で最も短い日。';

  @override
  String get eventDecemberSolsticeDesc => '北半球で昼が最も短く、南半球で最も長い日。';

  @override
  String eventMeteorShower(String shower) {
    return '$shower流星群';
  }

  @override
  String eventMeteorDesc(String rate, String percent) {
    return '暗い空で1時間に最大約 $rate 個の流星。月の明るさは $percent% です。';
  }

  @override
  String get showerQuadrantids => 'しぶんぎ座';

  @override
  String get showerLyrids => 'こと座';

  @override
  String get showerEtaAquariids => 'みずがめ座η';

  @override
  String get showerPerseids => 'ペルセウス座';

  @override
  String get showerOrionids => 'オリオン座';

  @override
  String get showerLeonids => 'しし座';

  @override
  String get showerGeminids => 'ふたご座';

  @override
  String get showerUrsids => 'こぐま座';

  @override
  String get eventToday => '今日';

  @override
  String get eventTomorrow => '明日';

  @override
  String eventInDays(String days) {
    return '$days 日後';
  }

  @override
  String get eventsNote =>
      '日付はスマホの中で計算し、スマホのタイムゾーンで表示します。流星群の極大日は毎年の目安で、1日ずれることがあります。リマインダーはスマホの中だけに保存されます。';

  @override
  String get remindMe => '通知する';

  @override
  String reminderSet(String date) {
    return 'わかりました。$date にお知らせします。';
  }

  @override
  String get reminderOff => 'リマインダーを削除しました。';

  @override
  String get reminderTooLate => 'イベントが近すぎてリマインダーを設定できません。';

  @override
  String get notificationsOff => 'Heliora の通知がオフです。Android の設定でオンにしてください。';

  @override
  String get reminderTomorrow => '明日です';

  @override
  String get reminderToday => '今日です';

  @override
  String get onlineTitle => 'オンライン機能';

  @override
  String get onlineSubtitle =>
      '宇宙ステーションとロケット打ち上げを表示します。オンにすると、Heliora は wheretheiss.at、Celestrak、Launch Library 2 とだけ通信し、これらはスマホのインターネットアドレスを見られます。ほかには何も送りません。初期設定はオフです。';

  @override
  String get turnOnOnline => 'オンライン機能をオンにする';

  @override
  String get issTitle => '宇宙ステーション';

  @override
  String get issCardHint => '今どこにいるか、いつ上空を通るか';

  @override
  String get issNeedsOnline =>
      'ステーションを表示するには、インターネットから軌道データを取得する必要があります。一度ダウンロードすれば数日間オフラインで使えます。';

  @override
  String get issLoading => '軌道データを取得中…';

  @override
  String get issFailed => '軌道データを取得できませんでした。通信を確認してもう一度お試しください。';

  @override
  String issStale(String days) {
    return '軌道データは $days 日前のものなので、位置がずれることがあります。インターネットに接続して更新してください。';
  }

  @override
  String get issHeight => '高度';

  @override
  String get issSpeed => '速度';

  @override
  String get issFromYou => 'あなたからの距離';

  @override
  String valueKmh(String value) {
    return '$value km/h';
  }

  @override
  String issAboveHorizon(String direction, String degrees) {
    return '今、地平線の上にいます！$directionを見てください、高さ $degrees°。';
  }

  @override
  String get issBelowHorizon => '今は地平線の下です。';

  @override
  String issPassesTitle(String city) {
    return '$cityの上空を通る次の日時';
  }

  @override
  String get issNoPasses => '今後5日間に見ごろの通過はありません。';

  @override
  String issMaxHigh(String degrees) {
    return '最高 $degrees°';
  }

  @override
  String issFromTo(String start, String end) {
    return '$startから$endへ';
  }

  @override
  String get issVisible => '見つけやすい';

  @override
  String get issHidden => '見つけにくい';

  @override
  String get issPassTitle => '宇宙ステーションがあなたの上空を通ります';

  @override
  String issPassBody(String degrees, String direction) {
    return '10分後に昇ります、最高 $degrees°。$directionを見てください。';
  }

  @override
  String get issNote =>
      '位置はスマホの中でステーションの軌道データから計算します。空が暗く、ステーションに太陽光が当たっているときは見つけやすく、明るく速く動く星のように見えます。';

  @override
  String get launchesNeedOnline => 'これからのロケット打ち上げをここで見るには、オンライン機能をオンにしてください。';

  @override
  String get launchesFailed => '打ち上げリストを更新できませんでした。保存済みのリストを表示しています。';

  @override
  String get launchesNote =>
      '打ち上げ時刻は Launch Library 2 から取得され、よく変わります。名称と場所は英語です。';

  @override
  String get launchReminderBody => '約1時間後に打ち上げ。時刻は変わることがあります。';

  @override
  String get launchTimeTbd => '時刻は未定';

  @override
  String get quizChoose => 'レベルを選ぶ';

  @override
  String get levelEasy => 'かんたん';

  @override
  String get levelMedium => 'ふつう';

  @override
  String get levelHard => 'むずかしい';

  @override
  String get levelEasyHint => '惑星の基本';

  @override
  String get levelMediumHint => '惑星と衛星';

  @override
  String get levelHardHint => 'ひねった比較とランキング';

  @override
  String get qStar => '次のうち、惑星ではなく恒星はどれ？';

  @override
  String get qDwarf => '次のうち、準惑星はどれ？';

  @override
  String get qMoonVisited => '人が歩いたことのある衛星はどれ？';

  @override
  String get qLargestMoon => 'これらの衛星のうち、いちばん大きいのはどれ？';

  @override
  String get qSmallestMoon => 'これらの衛星のうち、いちばん小さいのはどれ？';

  @override
  String get qThickAirMoon => 'これらの衛星のうち、厚い大気を持つのはどれ？';

  @override
  String get qGeyserMoon => '水の噴水を宇宙へ噴き出している衛星はどれ？';

  @override
  String get qVolcanicMoon => '活火山がいちばん多い衛星はどれ？';

  @override
  String get qBackwardsMoon => '惑星のまわりを逆向きに回っている衛星はどれ？';

  @override
  String get qBiggestRocky => '4つの岩石惑星のうち、いちばん大きいのはどれ？';

  @override
  String get qColdestRocky => '4つの岩石惑星のうち、いちばん寒いのはどれ？';

  @override
  String get qHighestPressure => '地表の気圧がいちばん高い惑星はどれ？';

  @override
  String get qSecondLargest => '2番目に大きい惑星はどれ？';

  @override
  String get qLongestYear => '1年がいちばん長い惑星はどれ？';

  @override
  String get qShortestYear => '1年がいちばん短い惑星はどれ？';

  @override
  String get qSmallestGiant => '4つの巨大惑星のうち、いちばん小さいのはどれ？';

  @override
  String get qRockyLongestYear => '4つの岩石惑星のうち、1年がいちばん長いのはどれ？';

  @override
  String get qFastestMoon => 'これらの衛星のうち、惑星のまわりをいちばん速く回るのはどれ？';

  @override
  String get qSlowestMoon => 'これらの衛星のうち、惑星を1周するのにいちばん時間がかかるのはどれ？';

  @override
  String get qStrongestMoonGravity => 'これらの衛星のうち、重力がいちばん強いのはどれ？';

  @override
  String get qColdestMoon => 'これらの衛星のうち、いちばん寒いのはどれ？';

  @override
  String get qSecondLargestMoon => 'これらの衛星のうち、2番目に大きいのはどれ？';

  @override
  String get factTitle => '知ってた？';

  @override
  String get factTap => 'タップで次の豆知識';

  @override
  String get factSun1 => '太陽は、太陽系全体の質量の99.8%を占めています。';

  @override
  String get factSun2 => '太陽の光が地球に届くまで、約8分20秒かかります。';

  @override
  String get factMercury1 => '水星の1日は、日の出から次の日の出まで約176地球日。1年のちょうど2倍の長さです。';

  @override
  String get factMercury2 => '水星にはほとんど空気がないので、昼でも空は真っ暗で、夜は凍えるほど寒くなります。';

  @override
  String get factVenus1 => '金星は逆向きに自転しているので、太陽は西から昇ります。';

  @override
  String get factVenus2 => '金星は太陽から遠いのに水星より熱いのは、厚い大気が熱を閉じ込めているからです。';

  @override
  String get factEarth1 => '生命が知られているのは地球だけで、表面の約71%は水でおおわれています。';

  @override
  String get factEarth2 => '地球は完全な球ではありません。自転のせいで、赤道あたりが少しふくらんでいます。';

  @override
  String get factMars1 => '火星のオリンポス山は太陽系で一番高い火山で、エベレストの約2.5倍の高さです。';

  @override
  String get factMars2 => '火星の夕焼けは青く見えます。';

  @override
  String get factJupiter1 => '木星の質量は、ほかのすべての惑星をあわせたものの2倍以上あります。';

  @override
  String get factJupiter2 => '大赤斑は地球より大きな嵐で、150年以上前から観測されています。';

  @override
  String get factSaturn1 => '土星は大きさのわりにとても軽く、じゅうぶん大きな浴槽があれば水に浮かびます。';

  @override
  String get factSaturn2 => '土星の環はとても幅広いのに、とても薄く、場所によっては厚さがたった10メートルほどです。';

  @override
  String get factUranus1 => '天王星は横倒しになって太陽のまわりを転がるように回っていて、軸が約98度かたむいています。';

  @override
  String get factUranus2 => '天王星は望遠鏡で初めて見つかった惑星です。1781年にウィリアム・ハーシェルが発見しました。';

  @override
  String get factNeptune1 => '海王星には惑星で最速の風が吹き、時速2,000kmを超えます。';

  @override
  String get factNeptune2 =>
      '海王星は、誰かが見るより先に計算で見つかりました。1846年に天文学者が、あるはずの位置を割り出したのです。';

  @override
  String get factMoon1 => '月は毎年、地球から約3.8センチずつ遠ざかっています。';

  @override
  String get factMoon2 => '月は地球を1周する間にちょうど1回自転するので、いつも同じ面が見えます。';

  @override
  String get factPluto1 => '冥王星の1年は、地球の約248年にあたります。';

  @override
  String get factPluto2 => '冥王星には、凍った窒素でできたハート形の大きな平原があります。';

  @override
  String get factIo1 => 'イオは、数百もの活火山がある、知られているなかで最も火山活動が激しい天体です。';

  @override
  String get factIo2 => '木星の重力がイオをぎゅっと押したり引っぱったりし、そこで生まれる熱が火山を動かしています。';

  @override
  String get factEuropa1 => 'エウロパの氷の殻の下には、地球の海全部の約2倍の水がありそうです。';

  @override
  String get factEuropa2 => 'エウロパは地球外生命を探す最有力の場所のひとつで、探査機エウロパ・クリッパーが向かっています。';

  @override
  String get factGanymede1 => 'ガニメデは太陽系で一番大きな衛星で、水星よりも大きいです。';

  @override
  String get factGanymede2 => 'ガニメデは、自分の磁場を持つことが知られている唯一の衛星です。';

  @override
  String get factCallisto1 => 'カリストは太陽系でもとくにクレーターが多い天体で、表面はとても古いです。';

  @override
  String get factCallisto2 =>
      'カリストは木星から十分に遠く、強い放射線をあまり受けないので、将来の基地の候補として提案されています。';

  @override
  String get factTitan1 => 'タイタンは、厚い大気を持つ唯一の衛星です。地表の気圧は地球より高いです。';

  @override
  String get factTitan2 => 'タイタンには川や湖がありますが、満たしているのは水ではなく、液体のメタンとエタンです。';

  @override
  String get factEnceladus1 => 'エンケラドゥスは、南極近くの割れ目から氷と水蒸気のジェットを宇宙へ噴き出しています。';

  @override
  String get factEnceladus2 => 'エンケラドゥスのジェットは、土星のE環をつくっています。';

  @override
  String get factTriton1 =>
      'トリトンは海王星のまわりを逆向きに回っているので、海王星にとらえられた準惑星だったのかもしれません。';

  @override
  String get factTriton2 => '約−235 °Cのトリトンは、太陽系で温度が測られたなかでも特に寒い場所のひとつです。';

  @override
  String get jumpInput => '地球でのジャンプの高さ（cm）';

  @override
  String jumpHigh(String height) {
    return 'ジャンプ：$height';
  }

  @override
  String jumpFeelsLike(String height) {
    return '地球で $height のジャンプは、ここでは';
  }

  @override
  String get jumpNote => '地面をける力は地球と同じです。太陽やガス惑星には立てる地面がないので、これは空想の遊びです。';

  @override
  String valueCm(String value) {
    return '$value cm';
  }

  @override
  String valueM(String value) {
    return '$value m';
  }

  @override
  String get eclipseTotalLunar => '皆既月食';

  @override
  String get eclipsePartialLunar => '部分月食';

  @override
  String get eclipsePenumbralLunar => '半影月食';

  @override
  String get eclipseTotalSolar => '皆既日食';

  @override
  String get eclipseAnnularSolar => '金環日食';

  @override
  String get eclipseHybridSolar => '金環皆既日食';

  @override
  String get eclipsePartialSolar => '部分日食';

  @override
  String get eclipseTotalLunarDesc =>
      '月が完全に地球の影に入り、暗い赤色になることがよくあります。地球の夜側にいる人なら誰でも見られ、肉眼で見ても安全です。';

  @override
  String eclipsePartialLunarDesc(String percent) {
    return '月の一部（幅の $percent%）が地球の濃い影に入ります。肉眼で見ても安全です。';
  }

  @override
  String get eclipsePenumbralLunarDesc =>
      '月が地球の薄い外側の影を通ります。少し暗くなるだけなので、気づきにくいです。';

  @override
  String get eclipseTotalSolarDesc =>
      '地球上の細い帯の中で、月が太陽を完全に隠します。その帯の外では部分日食になります。';

  @override
  String get eclipseAnnularSolarDesc =>
      '月が少し遠く、太陽を完全には隠せないため、明るいリングが残ります。リングは細い帯の中で見え、その外では部分日食です。';

  @override
  String get eclipseHybridSolarDesc =>
      'この日食は、帯の中で場所によって皆既になったり金環になったりします。帯の外では部分日食です。';

  @override
  String get eclipsePartialSolarDesc =>
      '月は太陽の一部だけを隠し、地球上のどこでも太陽が完全に隠れることはありません。';

  @override
  String get eclipseNoCity => 'Heliora で都市を選ぶと、そこから見られるかどうかが分かります。';

  @override
  String eclipseLunarUp(String city) {
    return '食の最大のとき、$city では月が地平線の上にあります。';
  }

  @override
  String eclipseLunarPartly(String city) {
    return '$city では、月が地平線の上にあるのは食の一部の間だけです。';
  }

  @override
  String eclipseLunarDown(String city) {
    return '$city では月がずっと地平線の下にあるので、見られません。';
  }

  @override
  String eclipseSolarNone(String city) {
    return '$city からは見えません。月の影が届かないか、太陽が地平線の下にあります。';
  }

  @override
  String eclipseSolarSlight(String city) {
    return '$city からは、せいぜいごくわずかな部分日食で、気づきにくいです。';
  }

  @override
  String eclipseSolarPartial(String city, String percent) {
    return '$city のおおまかな目安：月が太陽の幅の最大で約 $percent% を隠します。';
  }

  @override
  String eclipseSolarNear(String city) {
    return '$city は、太陽がほぼ、または完全に隠れる帯に近い場所です。日食の地図で確認してください。この目安はおおまかです。';
  }

  @override
  String get eclipseSolarSafety => '日食グラスなしで太陽を絶対に見ないでください。';

  @override
  String get alertsTitle => '通知';

  @override
  String get tonightAlertSwitch => '毎晩「今夜の空」をお知らせ';

  @override
  String get tonightAlertTime => '時刻';

  @override
  String get tonightAlertNote =>
      '選んだ時刻に、月と見える惑星についての短いメモを表示します。計算はスマホの中で行い、インターネットは不要です。Android では約 2 週間先までしか Heliora が準備できないので、ときどきアプリを開いてください。';

  @override
  String get tonightNotifTitle => '今夜の空';

  @override
  String tonightMoon(String phase, String percent) {
    return '月：$phase、$percent% 輝面。';
  }

  @override
  String tonightPlanets(String planets) {
    return '探してみよう：$planets。';
  }

  @override
  String get tonightNoPlanets => '夕方の空に明るい惑星はありません。';

  @override
  String get tonightNoCity => '惑星を見るには Heliora で都市を選んでください。';

  @override
  String get birthdayTitle => '私の誕生日の空';

  @override
  String get birthdaySubtitle => 'あなたが生まれた日の月と惑星、そして人生の節目の日。';

  @override
  String get birthdayCardHint => '月の満ち欠け、惑星、節目';

  @override
  String get birthdayNeedDate => '誕生日を設定';

  @override
  String get birthdayMoon => '誕生日の月';

  @override
  String get birthdayPlanets => 'その日の惑星';

  @override
  String birthdayDaysOld(String count) {
    return '今日で生まれてから $count 日です。';
  }

  @override
  String get birthdayMilestones => '節目';

  @override
  String birthdayDayN(String count) {
    return '$count 日目';
  }

  @override
  String get birthdayBillion => '生後 10 億秒';

  @override
  String get birthdayPassed => '達成';

  @override
  String get birthdayNote =>
      'Heliora の他の部分と同じ軌道から、スマホの中で計算します。誕生日がスマホの外に出ることはありません。';

  @override
  String get missionsTitle => '宇宙ミッション';

  @override
  String get missionsSubtitle => '宇宙探査の有名な出来事を、古い順に。';

  @override
  String get missionsCardHint => '時代を追う有名なミッション';

  @override
  String get missionSputnik1 =>
      '最初の人工衛星。ビーチボールほどの金属の球が約 3 か月間地球を回りました。そのピーピーという音はラジオで聞こえ、宇宙時代が始まりました。';

  @override
  String get missionVostok1 => 'ユーリ・ガガーリンが人類初の宇宙飛行士になりました。約 108 分で地球を 1 周しました。';

  @override
  String get missionApollo11 =>
      'ニール・アームストロングとバズ・オルドリンが静かの海に着陸し、月面を歩いた最初の人間になりました。マイケル・コリンズは軌道で待っていました。';

  @override
  String get missionVenera7 =>
      '別の惑星に着陸して信号を送った最初の探査機。金星の猛烈な暑さの中で、約 23 分間データを送りました。';

  @override
  String get missionViking1 =>
      '火星に着陸して 6 年以上動き続け、別の惑星の地表から最初の長い写真と天気報告のシリーズを送りました。';

  @override
  String get missionVoyager1 =>
      '1977 年に打ち上げられ、木星と土星のそばを通り、2012 年に星間空間に入りました。地球から最も遠い人工物です。';

  @override
  String get missionHubble =>
      '1990 年に打ち上げられ、地球の大気の上から宇宙を見ています。その鮮明な画像は宇宙の年齢を測る助けになり、何千もの遠い銀河を見せてくれました。';

  @override
  String get missionHuygens =>
      'カッシーニに載せられていた探査機ホイヘンスが、パラシュートで土星の衛星タイタンに降りました。外惑星の世界への初めての着陸で、地表から写真を送りました。';

  @override
  String get missionCuriosity =>
      '自動車ほどの大きさのこのローバーは、ロケット推進の「スカイクレーン」でゲール・クレーターに着陸しました。火星にはかつて生命に適した条件があったことを見つけました。';

  @override
  String get missionMangalyaan =>
      'インドの火星探査機は、最初の挑戦で火星の軌道に入りました。どの国にとっても初めてで、しかも非常に低い費用でした。';

  @override
  String get missionRosetta =>
      'ロゼッタの着陸機フィラエが、67P/チュリュモフ・ゲラシメンコ彗星に着陸しました。彗星への初めての着陸です。ロゼッタ本体は 2 年間彗星を回りました。';

  @override
  String get missionNewhorizons =>
      '9 年の旅の末に冥王星のそばを通り、初めて氷の山と巨大なハート形の平原を見せてくれました。';

  @override
  String get missionPerseverance =>
      'パーサビアランス・ローバーは、昔の生命の跡を探して岩石を集めるため、ジェゼロ・クレーターに着陸しました。搭載のヘリコプター、インジェニュイティは別の惑星で初めて動力飛行をしました。';

  @override
  String get missionJwst =>
      '最大の宇宙望遠鏡で、6.5 メートルの金色の鏡を持ち、150 万 km 離れた場所から赤外線で空を見ています。最初期の銀河のいくつかを捉えます。';

  @override
  String get missionChandrayaan3 =>
      'インドは月に軟着陸した 4 番目の国になり、月の南極付近に着陸した最初の国になりました。ビクラム着陸機は探査車プラギャンを載せていました。';

  @override
  String get spacecraftTitle => 'いまの宇宙機';

  @override
  String get spacecraftSubtitle => '有名な宇宙機が、いま地球からどれくらい離れているか。';

  @override
  String get spacecraftCardHint => 'ボイジャー、JWST、火星ローバーなど';

  @override
  String get spacecraftDistance => '地球からの距離';

  @override
  String get spacecraftAltitude => '地上からの高さ';

  @override
  String get spacecraftInAu => '天文単位で';

  @override
  String get spacecraftSpeed => '速さ';

  @override
  String get spacecraftSignal => '電波が届くまで';

  @override
  String get spacecraftNote =>
      '距離は推定値です。遠くの探査機は平均の速さから計算していて、地球が太陽のまわりを回るため約1%ずれることがあります。火星までの距離は今日の分を計算しています。1 AU（天文単位）は地球から太陽までの距離です。';

  @override
  String valueBillionKm(String value) {
    return '$value 十億 km';
  }

  @override
  String valueAu(String value) {
    return '$value AU';
  }

  @override
  String valueKmS(String value) {
    return '$value km/秒';
  }

  @override
  String get spacecraftVoyager1 =>
      '1977年に打ち上げ。2012年に星間空間に入った最初の探査機になりました。電波が私たちに届くころには、およそ1日前のものになっています。';

  @override
  String get spacecraftVoyager2 =>
      '1977年に打ち上げ。天王星と海王星の両方を訪れた唯一の探査機で、2018年に星間空間に入りました。';

  @override
  String get spacecraftNewHorizons =>
      '2015年に冥王星、2019年にカイパーベルト天体アロコスのそばを通過。いまも外へ向かって進み、データを送り続けています。';

  @override
  String get spacecraftJwst =>
      '最大の宇宙望遠鏡で、2021年に打ち上げ。L2という点の近く、地球から約150万kmにあり、日よけはいつも太陽の方を向いています。';

  @override
  String get spacecraftIss => '約90分で地球を1周します。2000年から、人が途切れることなく暮らしています。';

  @override
  String get spacecraftHubble =>
      '1990年に打ち上げられ、いまも活躍中。画像をぼやけさせる大気の上を回っているので、とても鮮明な写真が撮れます。';

  @override
  String get spacecraftMarsRovers =>
      'キュリオシティ（2012年着陸）とパーセベランス（2021年着陸）が火星を走っています。火星までの距離は約5500万kmから4億km以上まで変わります。';

  @override
  String get searchTooltip => '検索';

  @override
  String get searchHint => '惑星、衛星、ミッションを検索…';

  @override
  String get searchClear => '消去';

  @override
  String searchEmpty(String query) {
    return '「$query」は見つかりませんでした。';
  }

  @override
  String get searchBodies => '惑星と衛星';

  @override
  String get searchMissions => 'ミッション';

  @override
  String get searchSpacecraft => '宇宙機';

  @override
  String get favoritesTitle => 'お気に入り';

  @override
  String get favoritesEmpty => '惑星、ミッション、宇宙機の星をタップすると、ここに残ります。';

  @override
  String get favoriteAdd => 'お気に入りに追加';

  @override
  String get favoriteRemove => 'お気に入りから削除';

  @override
  String get textSize => '文字の大きさ';

  @override
  String get textSizeNormal => '標準';

  @override
  String get textSizeLarge => '大';

  @override
  String get textSizeLarger => '特大';

  @override
  String get textSizeNote => 'Heliora の文字を大きくします。スマホ自体の文字サイズより小さくなることはありません。';

  @override
  String get skyOtherNight => '夜空';

  @override
  String get planetsThatNight => 'その夜の惑星';

  @override
  String get previousDay => '前の日';

  @override
  String get nextDay => '次の日';

  @override
  String get pickDate => '日付を選ぶ';

  @override
  String get backToTonight => '今夜に戻る';

  @override
  String get moonCalendar => '月齢カレンダー';

  @override
  String get moonCalendarHint => '毎日の月の満ち欠け';

  @override
  String get previousMonth => '前の月';

  @override
  String get nextMonth => '次の月';

  @override
  String get keyMoonDates => '今月の主な月相';

  @override
  String get moonCalendarNote => '月相の日付と時刻はスマホのタイムゾーンで表示され、誤差は1時間ほどです。';

  @override
  String get seeSkyThatDay => 'この日の空を見る';

  @override
  String get sunLightTitle => '太陽と光';

  @override
  String get firstLight => '最初の光';

  @override
  String get goldenMorningEnds => '朝のゴールデンアワー終了';

  @override
  String get solarNoon => '南中';

  @override
  String get goldenEveningStarts => '夕方のゴールデンアワー開始';

  @override
  String get lastLight => '最後の光';

  @override
  String get darkSky => '完全に暗い空';

  @override
  String get sunDayLength => '昼の長さ';

  @override
  String durationHm(String hours, String minutes) {
    return '$hours時間$minutes分';
  }

  @override
  String get sunNote =>
      'ゴールデンアワーは、太陽が地平線の上6°未満にある時間です。太陽が地平線の下6°にあるときが最初の光と最後の光で、18°下まで沈むと空は完全に暗くなります。時刻は選んだ日付で計算しています。';

  @override
  String get sunStaysUp => 'この日は太陽が沈みません。';

  @override
  String get sunStaysDown => 'この日は太陽が昇りません。';
}
