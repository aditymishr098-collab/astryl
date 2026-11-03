// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'Heliora';

  @override
  String get tagline => 'نظامِ شمسی کی سیر، مکمل طور پر آف لائن';

  @override
  String get navExplore => 'دریافت کریں';

  @override
  String get navCompare => 'موازنہ';

  @override
  String get navWeight => 'وزن';

  @override
  String get navQuiz => 'کوئز';

  @override
  String get viewMode => 'منظر کا موڈ';

  @override
  String get settings => 'ترتیبات';

  @override
  String get notToScale =>
      'پیمانے کے مطابق نہیں · کھولنے کے لیے سیارے پر ٹیپ کریں';

  @override
  String get dragToRotate => 'گھمانے کے لیے کھینچیں · زوم کے لیے پنچ کریں';

  @override
  String get planetsTitle => 'سیارے';

  @override
  String get planetMercury => 'عطارد';

  @override
  String get planetVenus => 'زہرہ';

  @override
  String get planetEarth => 'زمین';

  @override
  String get planetMars => 'مریخ';

  @override
  String get planetJupiter => 'مشتری';

  @override
  String get planetSaturn => 'زحل';

  @override
  String get planetUranus => 'یورینس';

  @override
  String get planetNeptune => 'نیپچون';

  @override
  String planetOrder(int n) {
    return 'سورج سے سیارہ نمبر $n';
  }

  @override
  String get openDetails => 'تفصیلات کھولیں';

  @override
  String get diameter => 'قطر';

  @override
  String get gravity => 'کششِ ثقل';

  @override
  String get avgTemp => 'اوسط درجۂ حرارت';

  @override
  String get avgTempShort => 'اوسط درجہ';

  @override
  String get dayLength => 'دن';

  @override
  String get yearLength => 'سال';

  @override
  String get moons => 'معلوم چاند';

  @override
  String get moonsShort => 'چاند';

  @override
  String get distance => 'سورج سے فاصلہ';

  @override
  String get pressure => 'سطح کا دباؤ';

  @override
  String get noSurface => 'کوئی ٹھوس سطح نہیں';

  @override
  String valueKm(String value) {
    return '$value کلومیٹر';
  }

  @override
  String valueMillionKm(String value) {
    return '$value ملین کلومیٹر';
  }

  @override
  String valueHours(String value) {
    return '$value گھنٹے';
  }

  @override
  String valueDays(String value) {
    return '$value دن';
  }

  @override
  String valueYears(String value) {
    return '$value سال';
  }

  @override
  String get atmosphere => 'فضا';

  @override
  String get thinAtmosphere =>
      'تقریباً کوئی فضا نہیں۔ یہ گیسیں ایکسوسفیئر نامی بہت پتلی تہہ بناتی ہیں۔';

  @override
  String get oxygen => 'آکسیجن';

  @override
  String get oxygenVsEarth => 'آکسیجن: زمین سے موازنہ';

  @override
  String get breathable => 'انسانوں کے سانس لینے کے قابل';

  @override
  String get notBreathable => 'سانس لینے کے قابل نہیں، اسپیس سوٹ ضروری ہے';

  @override
  String weightFeelsLike(String weight) {
    return 'زمین کے $weight کلو یہاں اتنے لگیں گے';
  }

  @override
  String get gasCo2 => 'کاربن ڈائی آکسائیڈ';

  @override
  String get gasN2 => 'نائٹروجن';

  @override
  String get gasO2 => 'آکسیجن';

  @override
  String get gasAr => 'آرگون';

  @override
  String get gasH2 => 'ہائیڈروجن';

  @override
  String get gasHe => 'ہیلیم';

  @override
  String get gasCh4 => 'میتھین';

  @override
  String get gasNa => 'سوڈیم';

  @override
  String get gasK => 'پوٹاشیم';

  @override
  String get compareTitle => 'سیاروں کا موازنہ';

  @override
  String get compareHint => 'ساتھ ساتھ دیکھنے کے لیے دو سیارے منتخب کریں۔';

  @override
  String get weightTitle => 'دوسرے سیاروں پر آپ کا وزن';

  @override
  String get weightInput => 'زمین پر آپ کا وزن (کلو)';

  @override
  String gravityTimes(String factor) {
    return 'زمین کی کششِ ثقل کا $factor×';
  }

  @override
  String get quizTitle => 'سیاروں کا کوئز';

  @override
  String get quizIntro =>
      'سیاروں اور چاندوں کے بارے میں 10 سوال۔ آپ کتنے درست کر سکتے ہیں؟';

  @override
  String get quizStart => 'کوئز شروع کریں';

  @override
  String quizProgress(int current, int total) {
    return 'سوال $current / $total';
  }

  @override
  String get quizNext => 'اگلا';

  @override
  String get quizSeeResult => 'نتیجہ دیکھیں';

  @override
  String get quizCorrect => 'درست!';

  @override
  String quizWrong(String answer) {
    return 'نہیں۔ درست جواب $answer ہے۔';
  }

  @override
  String quizScore(int score, int total) {
    return '$total میں سے $score درست';
  }

  @override
  String quizBest(int score) {
    return 'بہترین اسکور: $score';
  }

  @override
  String get quizNewBest => 'نیا بہترین اسکور!';

  @override
  String get quizAgain => 'دوبارہ کھیلیں';

  @override
  String get qLargest => 'سب سے بڑا سیارہ کون سا ہے؟';

  @override
  String get qSmallest => 'سب سے چھوٹا سیارہ کون سا ہے؟';

  @override
  String get qHottest => 'سب سے گرم سیارہ کون سا ہے؟';

  @override
  String get qColdest => 'سب سے ٹھنڈا سیارہ کون سا ہے؟';

  @override
  String get qMostMoons => 'کس سیارے کے سب سے زیادہ معلوم چاند ہیں؟';

  @override
  String get qBreathable => 'کس سیارے پر انسان ہوا میں سانس لے سکتے ہیں؟';

  @override
  String get qClosest => 'سورج کے سب سے قریب کون سا سیارہ ہے؟';

  @override
  String get qFarthest => 'سورج سے سب سے دور کون سا سیارہ ہے؟';

  @override
  String get qStrongestGravity => 'کس سیارے کی کششِ ثقل سب سے زیادہ ہے؟';

  @override
  String get qShortestDay => 'کس سیارے کا دن سب سے چھوٹا ہے؟';

  @override
  String get qLongestDay => 'کس سیارے کا دن سب سے لمبا ہے؟';

  @override
  String get appearance => 'ظاہری شکل';

  @override
  String get theme => 'تھیم';

  @override
  String get themeSystem => 'سسٹم';

  @override
  String get themeLight => 'لائٹ';

  @override
  String get themeDark => 'ڈارک';

  @override
  String get language => 'زبان';

  @override
  String get appLanguage => 'ایپ کی زبان';

  @override
  String get languageNote => '20 زبانیں · سیاروں کے نام بھی';

  @override
  String get phoneLanguage => 'فون کی زبان';

  @override
  String get updates => 'اپ ڈیٹس';

  @override
  String get version => 'ورژن';

  @override
  String get checkForUpdates => 'اپ ڈیٹ چیک کریں';

  @override
  String get checking => 'چیک ہو رہا ہے…';

  @override
  String get autoUpdateCheck => 'روزانہ ایک بار خود چیک کریں';

  @override
  String get updateNote =>
      'اپ ڈیٹس GitHub Releases سے آتی ہیں۔ آپ کی ترتیبات آپ کے فون میں ہی رہتی ہیں۔';

  @override
  String get upToDate => 'آپ کے پاس تازہ ترین ورژن ہے۔';

  @override
  String get updateFailed =>
      'GitHub تک رسائی نہیں ہو سکی۔ انٹرنیٹ چیک کر کے دوبارہ کوشش کریں۔';

  @override
  String get updateAvailable => 'اپ ڈیٹ دستیاب ہے';

  @override
  String updateReady(String version) {
    return 'ورژن $version ڈاؤن لوڈ کے لیے تیار ہے۔';
  }

  @override
  String get download => 'ڈاؤن لوڈ';

  @override
  String get later => 'بعد میں';

  @override
  String get about => 'تعارف';

  @override
  String get sourceCode => 'GitHub پر سورس کوڈ';

  @override
  String get privacyLine => 'آف لائن · کوئی اشتہار نہیں · کوئی ٹریکنگ نہیں';

  @override
  String get dataSource => 'حقائق: NASA Planetary Fact Sheet';

  @override
  String get openFailed => 'لنک نہیں کھل سکا۔';

  @override
  String get bodySun => 'سورج';

  @override
  String get bodyMoon => 'چاند';

  @override
  String get bodyPluto => 'پلوٹو';

  @override
  String get moonIo => 'آئیو';

  @override
  String get moonEuropa => 'یوروپا';

  @override
  String get moonGanymede => 'گینیمیڈ';

  @override
  String get moonCallisto => 'کیلسٹو';

  @override
  String get moonTitan => 'ٹائٹن';

  @override
  String get moonEnceladus => 'اینسیلاڈس';

  @override
  String get moonTriton => 'ٹرائٹن';

  @override
  String get kindStar => 'ہمارا ستارہ، نظامِ شمسی کا مرکز';

  @override
  String get kindDwarf => 'بونا سیارہ';

  @override
  String moonOf(String planet) {
    return '$planet کا چاند';
  }

  @override
  String get orbitPeriod => 'ایک چکر';

  @override
  String distanceFrom(String body) {
    return '$body سے فاصلہ';
  }

  @override
  String get composition => 'یہ کس چیز سے بنا ہے';

  @override
  String get noAtmosphere => 'اصل فضا نہیں، تقریباً خلا ہے۔';

  @override
  String get majorMoons => 'اہم چاند';

  @override
  String get lifeTitle => 'کیا انسان یہاں رہ سکتے ہیں؟';

  @override
  String get lifeScoreShort => 'زندگی اسکور';

  @override
  String get lifeNote =>
      'درجۂ حرارت، ہوا کے دباؤ، آکسیجن، پانی، سطح اور کششِ ثقل سے حساب۔ زمین کا اسکور 10 ہے۔';

  @override
  String get water => 'پانی';

  @override
  String get waterLiquid => 'مائع پانی';

  @override
  String get waterIce => 'برف';

  @override
  String get waterOcean => 'برف کے نیچے سمندر';

  @override
  String get waterNone => 'پانی نہیں';

  @override
  String get surface => 'سطح';

  @override
  String get solidSurface => 'ٹھوس سطح';

  @override
  String get lifeHome => 'بالکل گھر جیسا';

  @override
  String get lifeHard => 'بہت مشکل، بند اڈا اور اسپیس سوٹ چاہیے';

  @override
  String get lifeNo => 'انسانوں کے لیے ناممکن';

  @override
  String get downloadInstall => 'ڈاؤن لوڈ کر کے انسٹال کریں';

  @override
  String downloadingPercent(String percent) {
    return 'ڈاؤن لوڈ ہو رہا ہے… $percent%';
  }

  @override
  String get installNow => 'انسٹال کریں';

  @override
  String get allowInstalls =>
      'کھلی ہوئی اسکرین پر Heliora کو ایپس انسٹال کرنے کی اجازت دیں، پھر واپس آ کر انسٹال دبائیں۔';

  @override
  String get downloadFailed =>
      'ڈاؤن لوڈ مکمل نہیں ہوا۔ انٹرنیٹ چیک کر کے دوبارہ کوشش کریں۔';

  @override
  String get tryAgain => 'دوبارہ کوشش کریں';

  @override
  String get today => 'آج';

  @override
  String get play => 'چلائیں';

  @override
  String get pause => 'روکیں';

  @override
  String get monthBack => '30 دن پہلے';

  @override
  String get monthForward => '30 دن بعد';

  @override
  String get positionsNote =>
      'اس تاریخ پر اصل مقام · سائز اور فاصلہ پیمانے پر نہیں · سیارے پر ٹیپ کریں';

  @override
  String get navYou => 'آپ';

  @override
  String get ageTitle => 'دوسرے سیاروں پر آپ کی عمر';

  @override
  String get setBirthDate => 'اپنی تاریخِ پیدائش درج کریں';

  @override
  String get changeBirthDate => 'بدلیں';

  @override
  String nextBirthday(String days) {
    return 'اگلی سالگرہ $days دن میں';
  }

  @override
  String get ageNote => 'آپ کی تاریخِ پیدائش صرف اسی فون میں محفوظ رہتی ہے۔';

  @override
  String get share => 'شیئر کریں';

  @override
  String shareText(String planet) {
    return 'Heliora میں $planet، مفت آف لائن نظامِ شمسی ایپ: https://github.com/lumio-apps/heliora';
  }

  @override
  String get shareFailed => 'تصویر شیئر نہیں ہو سکی۔';

  @override
  String get travelTitle => 'کتنا دور ہے؟';

  @override
  String get distanceFromEarth => 'آج زمین سے فاصلہ';

  @override
  String get lightTime => 'روشنی کو لگتا ہے';

  @override
  String get bySpacecraft => '60,000 کلومیٹر فی گھنٹہ والے خلائی جہاز سے';

  @override
  String get byCar => '100 کلومیٹر فی گھنٹہ والی کار سے';

  @override
  String valueSeconds(String value) {
    return '$value سیکنڈ';
  }

  @override
  String valueMinutes(String value) {
    return '$value منٹ';
  }

  @override
  String get sizeTitle => 'سائز';

  @override
  String sizeTimes(String big, String times, String small) {
    return '$big چوڑائی میں $small سے $times× بڑا ہے۔';
  }

  @override
  String sizeSimilar(String a, String b) {
    return '$a اور $b تقریباً ایک جتنے بڑے ہیں۔';
  }

  @override
  String get navSky => 'آسمان';

  @override
  String get skyTitle => 'آج رات کا آسمان';

  @override
  String get chooseCity => 'اپنا شہر چنیں';

  @override
  String get chooseCityHint =>
      'چاند اور آج رات نظر آنے والے سیارے دیکھنے کے لیے قریبی شہر چنیں۔ لوکیشن کی اجازت نہیں چاہیے، اور یہ فون میں ہی رہتا ہے۔';

  @override
  String get searchCity => 'شہر تلاش کریں';

  @override
  String get noCityFound => 'کوئی شہر نہیں ملا';

  @override
  String get cityNote =>
      'اوقات آپ کے فون کے ٹائم زون میں ہیں۔ اندھیرے آسمان میں افق سے کم از کم 5° اوپر ہونے پر سیارہ نظر آنے والا مانا جاتا ہے۔';

  @override
  String illuminated(String percent) {
    return '$percent% روشن';
  }

  @override
  String get moonrise => 'چاند نکلنا';

  @override
  String get moonset => 'چاند ڈوبنا';

  @override
  String get sunset => 'غروبِ آفتاب';

  @override
  String get sunrise => 'طلوعِ آفتاب';

  @override
  String get nextFull => 'اگلا پورا چاند';

  @override
  String get nextNew => 'اگلا نیا چاند';

  @override
  String get phaseNew => 'نیا چاند';

  @override
  String get phaseWaxingCrescent => 'بڑھتا ہلال';

  @override
  String get phaseFirstQuarter => 'پہلا چوتھائی';

  @override
  String get phaseWaxingGibbous => 'بڑھتا چاند';

  @override
  String get phaseFull => 'پورا چاند';

  @override
  String get phaseWaningGibbous => 'گھٹتا چاند';

  @override
  String get phaseLastQuarter => 'آخری چوتھائی';

  @override
  String get phaseWaningCrescent => 'گھٹتا ہلال';

  @override
  String get planetsTonight => 'آج رات کے سیارے';

  @override
  String get statusVisible => 'آج رات نظر آئے گا';

  @override
  String get statusEvening => 'شام کو، غروب کے بعد';

  @override
  String get statusMorning => 'صبح، طلوع سے پہلے';

  @override
  String get statusNotVisible => 'آج رات نظر نہیں آئے گا';

  @override
  String bestAt(String time) {
    return 'بہترین وقت $time';
  }

  @override
  String altitudeDir(String direction, String degrees) {
    return '$direction، $degrees° بلند';
  }

  @override
  String riseSet(String rise, String set) {
    return 'طلوع $rise · غروب $set';
  }

  @override
  String get needsTelescope => 'دوربین یا ٹیلی اسکوپ چاہیے';

  @override
  String get dirN => 'شمال';

  @override
  String get dirNE => 'شمال مشرق';

  @override
  String get dirE => 'مشرق';

  @override
  String get dirSE => 'جنوب مشرق';

  @override
  String get dirS => 'جنوب';

  @override
  String get dirSW => 'جنوب مغرب';

  @override
  String get dirW => 'مغرب';

  @override
  String get dirNW => 'شمال مغرب';

  @override
  String get findPlanet => 'آسمان میں تلاش کریں';

  @override
  String finderTitle(String name) {
    return '$name تلاش کریں';
  }

  @override
  String get pointPhone => 'فون اوپر اٹھا کر آہستہ آہستہ گھمائیں۔';

  @override
  String turnRight(String degrees) {
    return '$degrees° دائیں مڑیں';
  }

  @override
  String turnLeft(String degrees) {
    return '$degrees° بائیں مڑیں';
  }

  @override
  String tiltUp(String degrees) {
    return '$degrees° اوپر کریں';
  }

  @override
  String tiltDown(String degrees) {
    return '$degrees° نیچے کریں';
  }

  @override
  String onTarget(String name) {
    return '$name بالکل وہیں ہے!';
  }

  @override
  String belowHorizon(String name) {
    return '$name اس وقت افق کے نیچے ہے۔';
  }

  @override
  String risesAt(String time) {
    return 'یہ $time پر طلوع ہوگا۔';
  }

  @override
  String get noSensor =>
      'اس فون میں قطب نما سینسر نہیں ہے، اس لیے تلاش کی سہولت کام نہیں کرے گی۔';

  @override
  String get calibrate =>
      'قطب نما کو کیلیبریٹ کرنا ہے: فون کو چند بار 8 کی شکل میں گھمائیں۔';

  @override
  String get phoneNow => 'آپ کا فون اس طرف ہے';

  @override
  String get finderNote =>
      'فون کا پچھلا حصہ آسمان کی طرف رکھیں اور مقناطیس و دھات سے دور رکھیں۔ سورج کی طرف کبھی نہ دیکھیں۔';

  @override
  String get eventsTitle => 'خلائی واقعات';

  @override
  String get eventsSubtitle => 'اگلے 12 مہینوں میں آسمان میں کیا دیکھیں۔';

  @override
  String eventsNext(String event, String when) {
    return 'اگلا: $event · $when';
  }

  @override
  String get eventFullMoon => 'پورا چاند';

  @override
  String get eventNewMoon => 'نیا چاند';

  @override
  String eventOpposition(String planet) {
    return '$planet مقابلے (اپوزیشن) میں';
  }

  @override
  String eventEveningElongation(String planet) {
    return '$planet: شام کو دیکھنے کا بہترین وقت';
  }

  @override
  String eventMorningElongation(String planet) {
    return '$planet: صبح دیکھنے کا بہترین وقت';
  }

  @override
  String eventConjunction(String a, String b) {
    return '$a اور $b قریب آتے ہیں';
  }

  @override
  String get eventMarchEquinox => 'مارچ اعتدال';

  @override
  String get eventJuneSolstice => 'جون انقلاب';

  @override
  String get eventSeptemberEquinox => 'ستمبر اعتدال';

  @override
  String get eventDecemberSolstice => 'دسمبر انقلاب';

  @override
  String get eventFullMoonDesc =>
      'چاند کا پورا چہرہ روشن ہوتا ہے۔ یہ غروبِ آفتاب کے آس پاس نکلتا ہے۔';

  @override
  String get eventNewMoonDesc =>
      'چاند چھپا رہتا ہے۔ ستاروں اور سیاروں کے لیے مہینے کا سب سے اندھیرا آسمان۔';

  @override
  String eventOppositionDesc(String planet) {
    return '$planet سورج کے عین مقابل ہے۔ اس سال یہ سب سے روشن ہے اور ساری رات نظر آتا ہے۔';
  }

  @override
  String eventEveningDesc(String planet, String degrees) {
    return '$planet سورج سے $degrees° دور ہے، یعنی سب سے زیادہ دور۔ غروب کے بعد مغرب میں نیچے دیکھیں۔';
  }

  @override
  String eventMorningDesc(String planet, String degrees) {
    return '$planet سورج سے $degrees° دور ہے، یعنی سب سے زیادہ دور۔ طلوع سے پہلے مشرق میں نیچے دیکھیں۔';
  }

  @override
  String eventConjunctionDesc(String degrees) {
    return 'آسمان میں یہ صرف $degrees° کے فاصلے سے گزرتے ہیں۔';
  }

  @override
  String get eventEquinoxDesc =>
      'زمین پر ہر جگہ دن اور رات تقریباً برابر ہوتے ہیں۔';

  @override
  String get eventJuneSolsticeDesc =>
      'شمال میں سب سے لمبا دن، جنوب میں سب سے چھوٹا۔';

  @override
  String get eventDecemberSolsticeDesc =>
      'شمال میں سب سے چھوٹا دن، جنوب میں سب سے لمبا۔';

  @override
  String eventMeteorShower(String shower) {
    return '$shower شہابیوں کی بارش';
  }

  @override
  String eventMeteorDesc(String rate, String percent) {
    return 'اندھیرے آسمان میں فی گھنٹہ تقریباً $rate تک شہابیے۔ چاند $percent% روشن ہوگا۔';
  }

  @override
  String get showerQuadrantids => 'کواڈرینٹڈز';

  @override
  String get showerLyrids => 'لائریڈز';

  @override
  String get showerEtaAquariids => 'ایٹا ایکوایریڈز';

  @override
  String get showerPerseids => 'پرسیڈز';

  @override
  String get showerOrionids => 'اورائنڈز';

  @override
  String get showerLeonids => 'لیونڈز';

  @override
  String get showerGeminids => 'جیمینڈز';

  @override
  String get showerUrsids => 'ارسڈز';

  @override
  String get eventToday => 'آج';

  @override
  String get eventTomorrow => 'کل';

  @override
  String eventInDays(String days) {
    return '$days دن میں';
  }

  @override
  String get eventsNote =>
      'تاریخیں آپ کے فون پر ہی نکالی جاتی ہیں اور اس کے ٹائم زون میں دکھائی جاتی ہیں۔ شہابیوں کی بارش کے عروج کے دن ہر سال کے عام دن ہیں، ایک دن کا فرق ہو سکتا ہے۔ یاد دہانیاں آپ کے فون پر ہی رہتی ہیں۔';

  @override
  String get remindMe => 'مجھے یاد دلائیں';

  @override
  String reminderSet(String date) {
    return 'ٹھیک ہے، میں آپ کو $date کو یاد دلاؤں گا۔';
  }

  @override
  String get reminderOff => 'یاد دہانی ہٹا دی گئی۔';

  @override
  String get reminderTooLate => 'یہ واقعہ بہت قریب ہے، یاد دہانی نہیں لگ سکتی۔';

  @override
  String get notificationsOff =>
      'Heliora کی اطلاعات بند ہیں۔ Android سیٹنگز میں انہیں چالو کریں۔';

  @override
  String get reminderTomorrow => 'کل ہوگا';

  @override
  String get reminderToday => 'آج ہو رہا ہے';

  @override
  String get onlineTitle => 'آن لائن سہولیات';

  @override
  String get onlineSubtitle =>
      'خلائی اسٹیشن اور راکٹ لانچ دکھائیں۔ تب Heliora صرف wheretheiss.at، Celestrak اور Launch Library 2 سے رابطہ کرتا ہے، جو آپ کے فون کا انٹرنیٹ پتا دیکھ سکتے ہیں۔ اور کچھ نہیں بھیجا جاتا۔ شروع میں بند ہوتا ہے۔';

  @override
  String get turnOnOnline => 'آن لائن سہولیات چالو کریں';

  @override
  String get issTitle => 'خلائی اسٹیشن';

  @override
  String get issCardHint => 'ابھی کہاں ہے اور آپ کے اوپر سے کب گزرے گا';

  @override
  String get issNeedsOnline =>
      'اسٹیشن دکھانے کے لیے Heliora کو انٹرنیٹ سے اس کا مداری ڈیٹا چاہیے۔ یہ ایک بار ڈاؤن لوڈ ہوتا ہے اور پھر کئی دن آف لائن چلتا ہے۔';

  @override
  String get issLoading => 'مداری ڈیٹا لیا جا رہا ہے…';

  @override
  String get issFailed =>
      'مداری ڈیٹا نہیں ملا۔ انٹرنیٹ چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String issStale(String days) {
    return 'مداری ڈیٹا $days دن پرانا ہے، اس لیے مقام کچھ غلط ہو سکتا ہے۔ نیا لینے کے لیے انٹرنیٹ سے جڑیں۔';
  }

  @override
  String get issHeight => 'اونچائی';

  @override
  String get issSpeed => 'رفتار';

  @override
  String get issFromYou => 'آپ سے فاصلہ';

  @override
  String valueKmh(String value) {
    return '$value کلومیٹر/گھنٹہ';
  }

  @override
  String issAboveHorizon(String direction, String degrees) {
    return 'ابھی آپ کے افق کے اوپر ہے! $direction کی طرف دیکھیں، $degrees° بلند۔';
  }

  @override
  String get issBelowHorizon => 'ابھی آپ کے افق کے نیچے ہے۔';

  @override
  String issPassesTitle(String city) {
    return '$city کے اوپر سے اگلی پروازیں';
  }

  @override
  String get issNoPasses => 'اگلے 5 دنوں میں کوئی اچھی پرواز نہیں۔';

  @override
  String issMaxHigh(String degrees) {
    return '$degrees° تک بلند';
  }

  @override
  String issFromTo(String start, String end) {
    return '$start سے $end تک';
  }

  @override
  String get issVisible => 'آسانی سے نظر آئے گا';

  @override
  String get issHidden => 'دیکھنا مشکل';

  @override
  String get issPassTitle => 'خلائی اسٹیشن آپ کے اوپر سے گزر رہا ہے';

  @override
  String issPassBody(String degrees, String direction) {
    return '10 منٹ میں طلوع ہوگا، $degrees° تک بلند۔ $direction کی طرف دیکھیں۔';
  }

  @override
  String get issNote =>
      'مقامات آپ کے فون پر ہی اسٹیشن کے مداری ڈیٹا سے نکالے جاتے ہیں۔ جب آسمان اندھیرا ہو اور اسٹیشن پر سورج کی روشنی پڑ رہی ہو تو یہ آسانی سے نظر آتا ہے: ایک چمکدار، تیز ستارے جیسا۔';

  @override
  String get launchesNeedOnline =>
      'آنے والے راکٹ لانچ یہاں دیکھنے کے لیے آن لائن سہولیات چالو کریں۔';

  @override
  String get launchesFailed =>
      'لانچ کی فہرست اپ ڈیٹ نہیں ہو سکی۔ محفوظ فہرست دکھا رہے ہیں۔';

  @override
  String get launchesNote =>
      'لانچ کا وقت Launch Library 2 سے آتا ہے اور اکثر بدلتا ہے۔ نام اور جگہیں انگریزی میں ہیں۔';

  @override
  String get launchReminderBody =>
      'تقریباً ایک گھنٹے میں روانہ ہوگا۔ وقت بدل سکتا ہے۔';

  @override
  String get launchTimeTbd => 'وقت ابھی طے نہیں';

  @override
  String get quizChoose => 'سطح چنیں';

  @override
  String get levelEasy => 'آسان';

  @override
  String get levelMedium => 'درمیانہ';

  @override
  String get levelHard => 'مشکل';

  @override
  String get levelEasyHint => 'سیاروں کے بارے میں بنیادی باتیں';

  @override
  String get levelMediumHint => 'سیارے اور چاند';

  @override
  String get levelHardHint => 'مشکل موازنے اور ترتیب';

  @override
  String get qStar => 'ان میں سے کون سا ستارہ ہے، سیارہ نہیں؟';

  @override
  String get qDwarf => 'ان میں سے کون سا بونا سیارہ ہے؟';

  @override
  String get qMoonVisited => 'کس چاند پر انسان چل چکے ہیں؟';

  @override
  String get qLargestMoon => 'ان چاندوں میں سب سے بڑا کون سا ہے؟';

  @override
  String get qSmallestMoon => 'ان چاندوں میں سب سے چھوٹا کون سا ہے؟';

  @override
  String get qThickAirMoon => 'ان چاندوں میں سے کس کی فضا گھنی ہے؟';

  @override
  String get qGeyserMoon => 'کون سا چاند پانی کے فوارے خلا میں پھینکتا ہے؟';

  @override
  String get qVolcanicMoon => 'کس چاند پر سب سے زیادہ فعال آتش فشاں ہیں؟';

  @override
  String get qBackwardsMoon =>
      'کون سا چاند اپنے سیارے کے گرد الٹی سمت میں گھومتا ہے؟';

  @override
  String get qBiggestRocky => 'چار چٹانی سیاروں میں سب سے بڑا کون سا ہے؟';

  @override
  String get qColdestRocky => 'چار چٹانی سیاروں میں سب سے ٹھنڈا کون سا ہے؟';

  @override
  String get qHighestPressure =>
      'کس سیارے کی سطح پر ہوا کا دباؤ سب سے زیادہ ہے؟';

  @override
  String get qSecondLargest => 'کون سا سیارہ دوسرا سب سے بڑا ہے؟';

  @override
  String get qLongestYear => 'کس سیارے کا سال سب سے لمبا ہے؟';

  @override
  String get qShortestYear => 'کس سیارے کا سال سب سے چھوٹا ہے؟';

  @override
  String get qSmallestGiant => 'چار دیو قامت سیاروں میں سب سے چھوٹا کون سا ہے؟';

  @override
  String get qRockyLongestYear =>
      'چار چٹانی سیاروں میں کس کا سال سب سے لمبا ہے؟';

  @override
  String get qFastestMoon =>
      'ان چاندوں میں سے کون اپنے سیارے کے گرد سب سے تیز گھومتا ہے؟';

  @override
  String get qSlowestMoon =>
      'ان چاندوں میں سے کسے اپنے سیارے کا چکر لگانے میں سب سے زیادہ وقت لگتا ہے؟';

  @override
  String get qStrongestMoonGravity =>
      'ان چاندوں میں سے کس کی کششِ ثقل سب سے زیادہ ہے؟';

  @override
  String get qColdestMoon => 'ان چاندوں میں سب سے ٹھنڈا کون سا ہے؟';

  @override
  String get qSecondLargestMoon => 'ان چاندوں میں دوسرا سب سے بڑا کون سا ہے؟';

  @override
  String get factTitle => 'کیا آپ جانتے ہیں؟';

  @override
  String get factTap => 'ایک اور بات دیکھنے کے لیے ٹیپ کریں';

  @override
  String get factSun1 => 'نظامِ شمسی کی کل کمیت کا 99.8% حصہ سورج میں ہے۔';

  @override
  String get factSun2 =>
      'سورج کی روشنی کو زمین تک پہنچنے میں تقریباً 8 منٹ 20 سیکنڈ لگتے ہیں۔';

  @override
  String get factMercury1 =>
      'عطارد پر ایک دن، یعنی ایک طلوعِ آفتاب سے اگلے طلوع تک، تقریباً 176 زمینی دنوں کا ہوتا ہے۔ یہ اس کے سال سے دگنا لمبا ہے۔';

  @override
  String get factMercury2 =>
      'عطارد پر ہوا تقریباً نہیں ہے، اس لیے دن میں بھی اس کا آسمان کالا رہتا ہے اور راتیں جما دینے والی ٹھنڈی ہوتی ہیں۔';

  @override
  String get factVenus1 =>
      'زہرہ الٹی سمت میں گھومتا ہے، اس لیے وہاں سورج مغرب سے نکلتا ہے۔';

  @override
  String get factVenus2 =>
      'سورج سے زیادہ دور ہونے کے باوجود زہرہ عطارد سے زیادہ گرم ہے، کیونکہ اس کی گھنی ہوا گرمی کو روک لیتی ہے۔';

  @override
  String get factEarth1 =>
      'زمین واحد جگہ ہے جہاں زندگی کا ہمیں علم ہے، اور اس کی سطح کا تقریباً 71% حصہ پانی سے ڈھکا ہوا ہے۔';

  @override
  String get factEarth2 =>
      'زمین بالکل گول گیند نہیں ہے۔ گھومنے کی وجہ سے وہ خطِ استوا کے پاس تھوڑی سی ابھری ہوئی ہے۔';

  @override
  String get factMars1 =>
      'مریخ کا اولمپس مونز نظامِ شمسی کا سب سے اونچا آتش فشاں ہے، ماؤنٹ ایورسٹ سے تقریباً اڑھائی گنا اونچا۔';

  @override
  String get factMars2 => 'مریخ پر غروبِ آفتاب نیلے دکھائی دیتے ہیں۔';

  @override
  String get factJupiter1 =>
      'مشتری کی کمیت باقی تمام سیاروں کی کل کمیت سے دگنی سے بھی زیادہ ہے۔';

  @override
  String get factJupiter2 =>
      'گریٹ ریڈ اسپاٹ زمین سے بڑا ایک طوفان ہے، جسے لوگ 150 سال سے زیادہ عرصے سے دیکھ رہے ہیں۔';

  @override
  String get factSaturn1 =>
      'زحل اپنے حجم کے لحاظ سے اتنا ہلکا ہے کہ پانی پر تیرنے لگے، اگر اتنا بڑا ٹب مل جائے۔';

  @override
  String get factSaturn2 =>
      'زحل کے چھلے بہت چوڑے مگر بہت پتلے ہیں: کئی جگہ صرف تقریباً دس میٹر موٹے۔';

  @override
  String get factUranus1 =>
      'یورینس پہلو کے بل لڑھکتے ہوئے سورج کے گرد گھومتا ہے، اس کا محور تقریباً 98 درجے جھکا ہوا ہے۔';

  @override
  String get factUranus2 =>
      'یورینس دوربین سے دریافت ہونے والا پہلا سیارہ تھا۔ ولیم ہرشل نے اسے 1781 میں دیکھا۔';

  @override
  String get factNeptune1 =>
      'نیپچون پر کسی بھی سیارے سے تیز ہوائیں چلتی ہیں، 2,000 کلومیٹر فی گھنٹہ سے بھی زیادہ۔';

  @override
  String get factNeptune2 =>
      'نیپچون کو کسی کے دیکھنے سے پہلے ریاضی سے دریافت کیا گیا: 1846 میں ماہرینِ فلکیات نے حساب لگایا کہ وہ کہاں ہونا چاہیے۔';

  @override
  String get factMoon1 =>
      'چاند ہر سال زمین سے تقریباً 3.8 سینٹی میٹر مزید دور ہو جاتا ہے۔';

  @override
  String get factMoon2 =>
      'ہمیں چاند کا ہمیشہ ایک ہی رخ نظر آتا ہے، کیونکہ زمین کے ہر چکر میں وہ ٹھیک ایک بار اپنے گرد گھومتا ہے۔';

  @override
  String get factPluto1 =>
      'پلوٹو پر ایک سال تقریباً 248 زمینی سالوں کے برابر ہوتا ہے۔';

  @override
  String get factPluto2 =>
      'پلوٹو پر جمی ہوئی نائٹروجن کا دل کی شکل کا ایک وسیع میدان ہے۔';

  @override
  String get factIo1 =>
      'آئیو ہماری معلوم دنیاؤں میں سب سے زیادہ آتش فشانی دنیا ہے، جہاں سینکڑوں فعال آتش فشاں ہیں۔';

  @override
  String get factIo2 =>
      'مشتری کی کششِ ثقل آئیو کو دباتی اور کھینچتی ہے، اور اس سے پیدا ہونے والی حرارت اس کے آتش فشانوں کو چلاتی ہے۔';

  @override
  String get factEuropa1 =>
      'برفیلی تہ کے نیچے یوروپا میں غالباً زمین کے تمام سمندروں سے تقریباً دگنا پانی ہے۔';

  @override
  String get factEuropa2 =>
      'زمین سے باہر زندگی تلاش کرنے کی بہترین جگہوں میں سے ایک یوروپا ہے۔ یوروپا کلپر خلائی جہاز وہاں جا رہا ہے۔';

  @override
  String get factGanymede1 =>
      'گینیمیڈ نظامِ شمسی کا سب سے بڑا چاند ہے۔ یہ عطارد سے بھی بڑا ہے۔';

  @override
  String get factGanymede2 =>
      'گینیمیڈ واحد چاند ہے جس کا اپنا مقناطیسی میدان معلوم ہوا ہے۔';

  @override
  String get factCallisto1 =>
      'کیلسٹو نظامِ شمسی کی سب سے زیادہ گڑھوں والی جگہوں میں سے ایک ہے، اور اس کی سطح بہت پرانی ہے۔';

  @override
  String get factCallisto2 =>
      'کیلسٹو مشتری سے اتنا دور ہے کہ اسے اس کی شدید تابکاری کم ملتی ہے، اس لیے سائنس دانوں نے مستقبل کے اڈے کے لیے اس کی تجویز دی ہے۔';

  @override
  String get factTitan1 =>
      'ٹائٹن واحد چاند ہے جس کی فضا گھنی ہے۔ اس کی سطح پر ہوا کا دباؤ زمین سے زیادہ ہے۔';

  @override
  String get factTitan2 =>
      'ٹائٹن پر دریا اور جھیلیں ہیں، مگر ان میں پانی نہیں، مائع میتھین اور ایتھین ہے۔';

  @override
  String get factEnceladus1 =>
      'اینسیلاڈس اپنے جنوبی قطب کے پاس کی دراڑوں سے برف اور آبی بخارات کی دھاریں خلا میں چھوڑتا ہے۔';

  @override
  String get factEnceladus2 =>
      'اینسیلاڈس کی یہ دھاریں زحل کے E چھلے کو بھرتی ہیں۔';

  @override
  String get factTriton1 =>
      'ٹرائٹن نیپچون کے گرد الٹی سمت میں گھومتا ہے، اس لیے غالباً وہ ایک بونا سیارہ تھا جسے نیپچون نے پکڑ لیا۔';

  @override
  String get factTriton2 =>
      'تقریباً −235 °C پر ٹرائٹن نظامِ شمسی کی ان سب سے ٹھنڈی جگہوں میں سے ہے جہاں درجۂ حرارت ناپا گیا ہے۔';

  @override
  String get jumpInput => 'زمین پر آپ کی چھلانگ کی اونچائی (سینٹی میٹر)';

  @override
  String jumpHigh(String height) {
    return 'چھلانگ: $height';
  }

  @override
  String jumpFeelsLike(String height) {
    return 'زمین پر $height کی چھلانگ یہاں بن جاتی ہے';
  }

  @override
  String get jumpNote =>
      'دھکا وہی رہتا ہے جو زمین پر ہوتا ہے۔ سورج اور گیس والے دیو قامت سیاروں پر کھڑے ہونے کے لیے زمین ہی نہیں، اس لیے یہ صرف خیالی کھیل ہے۔';

  @override
  String valueCm(String value) {
    return '$value سینٹی میٹر';
  }

  @override
  String valueM(String value) {
    return '$value میٹر';
  }

  @override
  String get eclipseTotalLunar => 'مکمل چاند گرہن';

  @override
  String get eclipsePartialLunar => 'جزوی چاند گرہن';

  @override
  String get eclipsePenumbralLunar => 'نیم سایہ چاند گرہن';

  @override
  String get eclipseTotalSolar => 'مکمل سورج گرہن';

  @override
  String get eclipseAnnularSolar => 'حلقہ نما سورج گرہن';

  @override
  String get eclipseHybridSolar => 'ملا جلا سورج گرہن';

  @override
  String get eclipsePartialSolar => 'جزوی سورج گرہن';

  @override
  String get eclipseTotalLunarDesc =>
      'چاند پوری طرح زمین کے سائے میں چلا جاتا ہے اور اکثر مدھم سرخ نظر آتا ہے۔ زمین کے رات والے حصے میں سب لوگ اسے دیکھ سکتے ہیں، اور آنکھوں سے دیکھنا محفوظ ہے۔';

  @override
  String eclipsePartialLunarDesc(String percent) {
    return 'چاند کا ایک حصہ (چوڑائی کا $percent%) زمین کے گہرے سائے میں جاتا ہے۔ آنکھوں سے دیکھنا محفوظ ہے۔';
  }

  @override
  String get eclipsePenumbralLunarDesc =>
      'چاند زمین کے ہلکے بیرونی سائے سے گزرتا ہے۔ وہ بس ذرا سا مدھم ہوتا ہے، اس لیے محسوس کرنا مشکل ہے۔';

  @override
  String get eclipseTotalSolarDesc =>
      'زمین پر ایک تنگ پٹی میں چاند سورج کو پوری طرح ڈھانپ لیتا ہے۔ اس پٹی سے باہر جزوی گرہن نظر آتا ہے۔';

  @override
  String get eclipseAnnularSolarDesc =>
      'چاند ذرا زیادہ دور ہوتا ہے، اس لیے سورج کو پوری طرح نہیں ڈھانپ پاتا اور ایک چمکدار حلقہ بچ جاتا ہے۔ حلقہ ایک تنگ پٹی میں نظر آتا ہے؛ اس سے باہر گرہن جزوی ہوتا ہے۔';

  @override
  String get eclipseHybridSolarDesc =>
      'اپنی پٹی میں یہ گرہن کہیں مکمل اور کہیں حلقے جیسا نظر آتا ہے۔ پٹی سے باہر یہ جزوی ہوتا ہے۔';

  @override
  String get eclipsePartialSolarDesc =>
      'چاند سورج کے صرف ایک حصے کو ڈھانپتا ہے، اور زمین پر کہیں بھی سورج پورا نہیں ڈھکتا۔';

  @override
  String get eclipseNoCity =>
      'Heliora میں کوئی شہر منتخب کریں تاکہ پتا چلے کہ وہاں سے یہ نظر آئے گا یا نہیں۔';

  @override
  String eclipseLunarUp(String city) {
    return 'گرہن کے بیچ میں $city میں چاند افق کے اوپر ہوتا ہے۔';
  }

  @override
  String eclipseLunarPartly(String city) {
    return '$city میں چاند گرہن کے صرف کچھ حصے میں افق کے اوپر ہوتا ہے۔';
  }

  @override
  String eclipseLunarDown(String city) {
    return '$city میں چاند افق کے نیچے ہی رہتا ہے، اس لیے وہاں سے نظر نہیں آئے گا۔';
  }

  @override
  String eclipseSolarNone(String city) {
    return '$city سے نظر نہیں آئے گا: چاند کا سایہ وہاں نہیں پہنچتا، یا سورج افق کے نیچے ہوتا ہے۔';
  }

  @override
  String eclipseSolarSlight(String city) {
    return '$city سے زیادہ سے زیادہ بہت ہلکا جزوی گرہن نظر آئے گا، جسے پہچاننا مشکل ہے۔';
  }

  @override
  String eclipseSolarPartial(String city, String percent) {
    return '$city کے لیے موٹا اندازہ: چاند زیادہ سے زیادہ سورج کی چوڑائی کا تقریباً $percent% ڈھانپتا ہے۔';
  }

  @override
  String eclipseSolarNear(String city) {
    return '$city اس پٹی کے قریب ہے جہاں سورج تقریباً یا پوری طرح ڈھک جاتا ہے۔ گرہن کا نقشہ دیکھیں؛ یہ اندازہ موٹا ہے۔';
  }

  @override
  String get eclipseSolarSafety =>
      'مناسب گرہن والے چشمے کے بغیر کبھی سورج کی طرف نہ دیکھیں۔';

  @override
  String get alertsTitle => 'الرٹس';

  @override
  String get tonightAlertSwitch => 'ہر شام آج رات کا آسمان';

  @override
  String get tonightAlertTime => 'وقت';

  @override
  String get tonightAlertNote =>
      'آپ کے چنے ہوئے وقت پر چاند اور نظر آنے والے سیاروں کے بارے میں ایک مختصر پیغام۔ یہ آپ کے فون پر ہی بنتا ہے، انٹرنیٹ کی ضرورت نہیں۔ Android Heliora کو پہلے سے صرف تقریباً دو ہفتوں کے پیغام تیار کرنے دیتا ہے، اس لیے ایپ کبھی کبھار کھولتے رہیں۔';

  @override
  String get tonightNotifTitle => 'آج رات کا آسمان';

  @override
  String tonightMoon(String phase, String percent) {
    return 'چاند: $phase، $percent% روشن۔';
  }

  @override
  String tonightPlanets(String planets) {
    return 'تلاش کریں: $planets۔';
  }

  @override
  String get tonightNoPlanets => 'شام کے آسمان میں کوئی روشن سیارہ نہیں۔';

  @override
  String get tonightNoCity => 'سیارے دیکھنے کے لیے Heliora میں شہر منتخب کریں۔';

  @override
  String get birthdayTitle => 'میری سالگرہ کا آسمان';

  @override
  String get birthdaySubtitle =>
      'جس دن آپ پیدا ہوئے اس دن چاند اور سیارے کہاں تھے، اور آپ کی زندگی کے خاص دن۔';

  @override
  String get birthdayCardHint => 'چاند کی شکل، سیارے اور سنگِ میل';

  @override
  String get birthdayNeedDate => 'اپنی تاریخِ پیدائش درج کریں';

  @override
  String get birthdayMoon => 'آپ کی سالگرہ پر چاند';

  @override
  String get birthdayPlanets => 'اس دن سیارے';

  @override
  String birthdayDaysOld(String count) {
    return 'آج آپ $count دن کے ہیں۔';
  }

  @override
  String get birthdayMilestones => 'سنگِ میل';

  @override
  String birthdayDayN(String count) {
    return 'دن $count';
  }

  @override
  String get birthdayBillion => '100 کروڑ سیکنڈ کے';

  @override
  String get birthdayPassed => 'ہو چکا';

  @override
  String get birthdayNote =>
      'Heliora کی باقی چیزوں جیسے ہی مداروں سے آپ کے فون پر ہی حساب لگایا جاتا ہے۔ آپ کی تاریخِ پیدائش فون سے باہر نہیں جاتی۔';

  @override
  String get missionsTitle => 'خلائی مشن';

  @override
  String get missionsSubtitle => 'خلا کی کھوج کے مشہور لمحے، سب سے پرانا پہلے۔';

  @override
  String get missionsCardHint => 'وقت کے ساتھ مشہور مشن';

  @override
  String get missionSputnik1 =>
      'پہلا مصنوعی سیارہ۔ بیچ بال جتنا یہ دھات کا گولہ تقریباً تین مہینے زمین کے گرد گھومتا رہا۔ اس کی بیپ ریڈیو پر سنی جا سکتی تھی، اور یہیں سے خلائی دور شروع ہوا۔';

  @override
  String get missionVostok1 =>
      'یوری گاگارین خلا میں جانے والے پہلے انسان بنے۔ انہوں نے تقریباً 108 منٹ میں زمین کا ایک چکر لگایا۔';

  @override
  String get missionApollo11 =>
      'نیل آرمسٹرانگ اور بز ایلڈرن سکون کے سمندر میں اترے اور چاند پر چلنے والے پہلے انسان بنے۔ مائیکل کولنز مدار میں ان کا انتظار کرتے رہے۔';

  @override
  String get missionVenera7 =>
      'دوسرے سیارے پر اتر کر اشارہ بھیجنے والی پہلی خلائی گاڑی۔ اس نے زہرہ کی کچل دینے والی گرمی میں تقریباً 23 منٹ تک ڈیٹا بھیجا۔';

  @override
  String get missionViking1 =>
      'یہ مریخ پر اترا اور چھ سال سے زیادہ کام کرتا رہا۔ اس نے کسی دوسرے سیارے کی سطح سے تصویروں اور موسم کی رپورٹوں کا پہلا طویل سلسلہ بھیجا۔';

  @override
  String get missionVoyager1 =>
      '1977 میں چھوڑا گیا، یہ مشتری اور زحل کے پاس سے گزرا اور 2012 میں ستاروں کے درمیان کی خلا میں داخل ہوا۔ زمین سے سب سے دور انسان کی بنائی ہوئی چیز یہی ہے۔';

  @override
  String get missionHubble =>
      '1990 میں چھوڑی گئی، یہ زمین کی ہوا کے اوپر سے کائنات کو دیکھتی ہے۔ اس کی صاف تصویروں نے کائنات کی عمر ناپنے میں مدد دی اور ہزاروں دور کی کہکشائیں دکھائیں۔';

  @override
  String get missionHuygens =>
      'کیسینی کے ساتھ گئی گاڑی ہائگنز پیراشوٹ سے زحل کے چاند ٹائٹن پر اتری۔ بیرونی نظامِ شمسی میں یہ پہلی لینڈنگ تھی، اور اس نے سطح سے تصویریں بھیجیں۔';

  @override
  String get missionCuriosity =>
      'کار جتنا یہ روور راکٹ سے چلنے والی ’اسکائی کرین’ کی مدد سے گیل کریٹر میں اترا۔ اس نے پتا لگایا کہ مریخ پر کبھی زندگی کے لیے مناسب حالات تھے۔';

  @override
  String get missionMangalyaan =>
      'بھارت کا مارس آربیٹر مشن پہلی ہی کوشش میں مریخ کے مدار میں پہنچ گیا۔ کسی بھی ملک کے لیے یہ پہلی بار تھا، اور وہ بھی بہت کم خرچ میں۔';

  @override
  String get missionRosetta =>
      'روزیٹا کے لینڈر فیلے نے دم دار ستارے 67P/چوریوموف–گیراسیمینکو پر اتر کر کسی دم دار ستارے پر پہلی لینڈنگ کی۔ روزیٹا خود دو سال تک اس دم دار ستارے کے گرد گھومتا رہا۔';

  @override
  String get missionNewhorizons =>
      'نو سال کے سفر کے بعد یہ پلوٹو کے پاس سے گزرا اور پہلی بار ہمیں برفیلے پہاڑ اور دل کی شکل کا بڑا میدان دکھایا۔';

  @override
  String get missionPerseverance =>
      'پرسیویرنس روور پرانی زندگی کے نشان ڈھونڈنے اور چٹانوں کے نمونے جمع کرنے کے لیے جیزیرو کریٹر میں اترا۔ اس کے ہیلی کاپٹر انجینیوٹی نے کسی دوسرے سیارے پر پہلی کنٹرول شدہ پرواز کی۔';

  @override
  String get missionJwst =>
      'سب سے بڑی خلائی دوربین میں 6.5 میٹر کا سنہری شیشہ ہے، اور یہ 15 لاکھ کلومیٹر دور سے زیریں سرخ روشنی میں آسمان دیکھتی ہے۔ یہ سب سے پہلی کہکشاؤں میں سے کچھ دیکھ لیتی ہے۔';

  @override
  String get missionChandrayaan3 =>
      'بھارت چاند پر آرام سے اترنے والا چوتھا ملک بنا، اور جنوبی قطب کے قریب اترنے والا پہلا۔ وکرم لینڈر اپنے ساتھ پرگیان روور لے گیا تھا۔';

  @override
  String get spacecraftTitle => 'خلائی جہاز ابھی';

  @override
  String get spacecraftSubtitle =>
      'کچھ مشہور خلائی جہاز اس وقت زمین سے کتنی دور ہیں۔';

  @override
  String get spacecraftCardHint => 'وائجر، JWST، مریخ کے روور اور بہت کچھ';

  @override
  String get spacecraftDistance => 'زمین سے فاصلہ';

  @override
  String get spacecraftAltitude => 'زمین سے اونچائی';

  @override
  String get spacecraftInAu => 'فلکیاتی اکائی میں';

  @override
  String get spacecraftSpeed => 'رفتار';

  @override
  String get spacecraftSignal => 'ریڈیو سگنل کو لگتا ہے';

  @override
  String get spacecraftNote =>
      'فاصلے اندازے ہیں۔ دور کے جہازوں کے لیے یہ اوسط رفتار سے نکالے گئے ہیں اور زمین کے سورج کے گرد گھومنے کی وجہ سے تقریباً 1% تک غلط ہو سکتے ہیں۔ مریخ کا فاصلہ آج کے لیے نکالا گیا ہے۔ ایک AU (فلکیاتی اکائی) زمین سے سورج کا فاصلہ ہے۔';

  @override
  String valueBillionKm(String value) {
    return '$value ارب کلومیٹر';
  }

  @override
  String valueAu(String value) {
    return '$value AU';
  }

  @override
  String valueKmS(String value) {
    return '$value کلومیٹر/سیکنڈ';
  }

  @override
  String get spacecraftVoyager1 =>
      '1977 میں روانہ کیا گیا۔ 2012 میں یہ ستاروں کے درمیان کی خلا میں داخل ہونے والا پہلا جہاز بنا۔ اس کا ریڈیو سگنل ہم تک پہنچتے پہنچتے تقریباً ایک دن پرانا ہو چکا ہوتا ہے۔';

  @override
  String get spacecraftVoyager2 =>
      '1977 میں روانہ کیا گیا۔ یہ واحد جہاز ہے جو یورینس اور نیپچون تک گیا، اور 2018 میں ستاروں کے درمیان کی خلا میں داخل ہوا۔';

  @override
  String get spacecraftNewHorizons =>
      '2015 میں پلوٹو کے پاس سے اور 2019 میں کوئپر پٹی کے جسم اروکوتھ کے پاس سے گزرا۔ یہ اب بھی باہر کی طرف جا رہا ہے اور اب بھی ڈیٹا بھیج رہا ہے۔';

  @override
  String get spacecraftJwst =>
      'سب سے بڑی خلائی دوربین، 2021 میں روانہ کی گئی۔ یہ L2 نامی مقام کے قریب، زمین سے تقریباً 15 لاکھ کلومیٹر دور ہے، اور اس کی دھوپ کی ڈھال ہمیشہ سورج کی طرف رہتی ہے۔';

  @override
  String get spacecraftIss =>
      'تقریباً ہر 90 منٹ میں زمین کا ایک چکر لگاتا ہے۔ 2000 سے اس میں لوگ بغیر وقفے کے رہ رہے ہیں۔';

  @override
  String get spacecraftHubble =>
      '1990 میں روانہ کیا گیا اور اب بھی کام کر رہا ہے۔ یہ تصویر دھندلی کرنے والی ہوا کے اوپر زمین کے گرد گھومتا ہے، اس لیے اس کی تصویریں بہت صاف ہوتی ہیں۔';

  @override
  String get spacecraftMarsRovers =>
      'کیوریوسٹی (2012 میں اترا) اور پرسیویرنس (2021 میں اترا) مریخ پر چل رہے ہیں۔ مریخ کا فاصلہ تقریباً 5.5 کروڑ کلومیٹر سے بدل کر 40 کروڑ کلومیٹر سے بھی زیادہ ہو جاتا ہے۔';

  @override
  String get searchTooltip => 'تلاش کریں';

  @override
  String get searchHint => 'سیارے، چاند، مشن تلاش کریں…';

  @override
  String get searchClear => 'صاف کریں';

  @override
  String searchEmpty(String query) {
    return '“$query” کے لیے کچھ نہیں ملا۔';
  }

  @override
  String get searchBodies => 'سیارے اور چاند';

  @override
  String get searchMissions => 'مشن';

  @override
  String get searchSpacecraft => 'خلائی جہاز';

  @override
  String get favoritesTitle => 'پسندیدہ';

  @override
  String get favoritesEmpty =>
      'کسی سیارے، مشن یا خلائی جہاز پر ستارے کو دبائیں، وہ یہاں رہے گا۔';

  @override
  String get favoriteAdd => 'پسندیدہ میں شامل کریں';

  @override
  String get favoriteRemove => 'پسندیدہ سے ہٹائیں';

  @override
  String get textSize => 'تحریر کا سائز';

  @override
  String get textSizeNormal => 'عام';

  @override
  String get textSizeLarge => 'بڑا';

  @override
  String get textSizeLarger => 'اور بڑا';

  @override
  String get textSizeNote =>
      'Heliora کی تحریر بڑی کر دیتا ہے۔ یہ آپ کے فون کے اپنے تحریری سائز سے کبھی چھوٹا نہیں ہوتا۔';

  @override
  String get skyOtherNight => 'رات کا آسمان';

  @override
  String get planetsThatNight => 'اس رات کے سیارے';

  @override
  String get previousDay => 'پچھلا دن';

  @override
  String get nextDay => 'اگلا دن';

  @override
  String get pickDate => 'تاریخ منتخب کریں';

  @override
  String get backToTonight => 'آج رات پر واپس';

  @override
  String get moonCalendar => 'چاند کیلنڈر';

  @override
  String get moonCalendarHint => 'ہر دن چاند کی شکل';

  @override
  String get previousMonth => 'پچھلا مہینہ';

  @override
  String get nextMonth => 'اگلا مہینہ';

  @override
  String get keyMoonDates => 'اس مہینے کی اہم شکلیں';

  @override
  String get moonCalendarNote =>
      'شکلوں کی تاریخیں اور اوقات آپ کے فون کے ٹائم زون میں دکھائے گئے ہیں اور تقریباً ایک گھنٹے کے اندر درست ہیں۔';

  @override
  String get seeSkyThatDay => 'اس دن کا آسمان دیکھیں';

  @override
  String get sunLightTitle => 'سورج اور روشنی';

  @override
  String get firstLight => 'پہلی روشنی';

  @override
  String get goldenMorningEnds => 'صبح کا سنہری وقت ختم';

  @override
  String get solarNoon => 'سورج سب سے اونچا';

  @override
  String get goldenEveningStarts => 'شام کا سنہری وقت شروع';

  @override
  String get lastLight => 'آخری روشنی';

  @override
  String get darkSky => 'مکمل اندھیرا آسمان';

  @override
  String get sunDayLength => 'دن کی لمبائی';

  @override
  String durationHm(String hours, String minutes) {
    return '$hours گھنٹے $minutes منٹ';
  }

  @override
  String get sunNote =>
      'سنہری وقت وہ ہے جب سورج افق سے 6° سے کم اونچا ہو۔ پہلی اور آخری روشنی تب ہوتی ہے جب وہ 6° نیچے ہو، اور آسمان مکمل اندھیرا تب ہوتا ہے جب وہ 18° نیچے ہو۔ اوقات آپ کی چنی ہوئی تاریخ کے لیے نکالے گئے ہیں۔';

  @override
  String get sunStaysUp => 'اس دن سورج غروب نہیں ہوتا۔';

  @override
  String get sunStaysDown => 'اس دن سورج طلوع نہیں ہوتا۔';

  @override
  String get solarSystemTitle => 'نظامِ شمسی';
}
