// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'Heliora';

  @override
  String get tagline => 'সৌরজগৎ ঘুরে দেখুন, পুরোপুরি অফলাইনে';

  @override
  String get navExplore => 'অন্বেষণ';

  @override
  String get navCompare => 'তুলনা';

  @override
  String get navWeight => 'ওজন';

  @override
  String get navQuiz => 'কুইজ';

  @override
  String get viewMode => 'ভিউ মোড';

  @override
  String get settings => 'সেটিংস';

  @override
  String get notToScale => 'মাপমতো নয় · খুলতে কোনো গ্রহে ট্যাপ করুন';

  @override
  String get dragToRotate => 'ঘোরাতে টানুন · জুম করতে পিঞ্চ করুন';

  @override
  String get planetsTitle => 'গ্রহ';

  @override
  String get planetMercury => 'বুধ';

  @override
  String get planetVenus => 'শুক্র';

  @override
  String get planetEarth => 'পৃথিবী';

  @override
  String get planetMars => 'মঙ্গল';

  @override
  String get planetJupiter => 'বৃহস্পতি';

  @override
  String get planetSaturn => 'শনি';

  @override
  String get planetUranus => 'ইউরেনাস';

  @override
  String get planetNeptune => 'নেপচুন';

  @override
  String planetOrder(int n) {
    return 'সূর্য থেকে $n নম্বর গ্রহ';
  }

  @override
  String get openDetails => 'বিস্তারিত দেখুন';

  @override
  String get diameter => 'ব্যাস';

  @override
  String get gravity => 'মাধ্যাকর্ষণ';

  @override
  String get avgTemp => 'গড় তাপমাত্রা';

  @override
  String get avgTempShort => 'গড় তাপমাত্রা';

  @override
  String get dayLength => 'দিন';

  @override
  String get yearLength => 'বছর';

  @override
  String get moons => 'জানা চাঁদ';

  @override
  String get moonsShort => 'চাঁদ';

  @override
  String get distance => 'সূর্য থেকে দূরত্ব';

  @override
  String get pressure => 'পৃষ্ঠের চাপ';

  @override
  String get noSurface => 'কোনো শক্ত পৃষ্ঠ নেই';

  @override
  String valueKm(String value) {
    return '$value কিমি';
  }

  @override
  String valueMillionKm(String value) {
    return '$value মিলিয়ন কিমি';
  }

  @override
  String valueHours(String value) {
    return '$value ঘণ্টা';
  }

  @override
  String valueDays(String value) {
    return '$value দিন';
  }

  @override
  String valueYears(String value) {
    return '$value বছর';
  }

  @override
  String get atmosphere => 'বায়ুমণ্ডল';

  @override
  String get thinAtmosphere =>
      'প্রায় কোনো বায়ুমণ্ডল নেই। এই গ্যাসগুলো এক্সোস্ফিয়ার নামের খুব পাতলা স্তর তৈরি করে।';

  @override
  String get oxygen => 'অক্সিজেন';

  @override
  String get oxygenVsEarth => 'অক্সিজেন: পৃথিবীর সাথে তুলনা';

  @override
  String get breathable => 'মানুষের শ্বাস নেওয়ার উপযোগী';

  @override
  String get notBreathable => 'শ্বাস নেওয়া যায় না, স্পেসস্যুট লাগবে';

  @override
  String weightFeelsLike(String weight) {
    return 'পৃথিবীর $weight কেজি এখানে এত লাগবে';
  }

  @override
  String get gasCo2 => 'কার্বন ডাই অক্সাইড';

  @override
  String get gasN2 => 'নাইট্রোজেন';

  @override
  String get gasO2 => 'অক্সিজেন';

  @override
  String get gasAr => 'আর্গন';

  @override
  String get gasH2 => 'হাইড্রোজেন';

  @override
  String get gasHe => 'হিলিয়াম';

  @override
  String get gasCh4 => 'মিথেন';

  @override
  String get gasNa => 'সোডিয়াম';

  @override
  String get gasK => 'পটাশিয়াম';

  @override
  String get compareTitle => 'গ্রহের তুলনা';

  @override
  String get compareHint => 'পাশাপাশি দেখতে দুটি গ্রহ বেছে নিন।';

  @override
  String get weightTitle => 'অন্য গ্রহে আপনার ওজন';

  @override
  String get weightInput => 'পৃথিবীতে আপনার ওজন (কেজি)';

  @override
  String gravityTimes(String factor) {
    return 'পৃথিবীর মাধ্যাকর্ষণের $factor×';
  }

  @override
  String get quizTitle => 'গ্রহ কুইজ';

  @override
  String get quizIntro =>
      'গ্রহ ও উপগ্রহ নিয়ে ১০টি প্রশ্ন। কয়টি ঠিক করতে পারবেন?';

  @override
  String get quizStart => 'কুইজ শুরু করুন';

  @override
  String quizProgress(int current, int total) {
    return 'প্রশ্ন $current / $total';
  }

  @override
  String get quizNext => 'পরেরটি';

  @override
  String get quizSeeResult => 'ফলাফল দেখুন';

  @override
  String get quizCorrect => 'ঠিক!';

  @override
  String quizWrong(String answer) {
    return 'হয়নি। সঠিক উত্তর $answer।';
  }

  @override
  String quizScore(int score, int total) {
    return '$totalটির মধ্যে $scoreটি ঠিক';
  }

  @override
  String quizBest(int score) {
    return 'সেরা স্কোর: $score';
  }

  @override
  String get quizNewBest => 'নতুন সেরা স্কোর!';

  @override
  String get quizAgain => 'আবার খেলুন';

  @override
  String get qLargest => 'সবচেয়ে বড় গ্রহ কোনটি?';

  @override
  String get qSmallest => 'সবচেয়ে ছোট গ্রহ কোনটি?';

  @override
  String get qHottest => 'সবচেয়ে গরম গ্রহ কোনটি?';

  @override
  String get qColdest => 'সবচেয়ে ঠান্ডা গ্রহ কোনটি?';

  @override
  String get qMostMoons => 'কোন গ্রহের সবচেয়ে বেশি জানা চাঁদ আছে?';

  @override
  String get qBreathable => 'কোন গ্রহে মানুষ বাতাসে শ্বাস নিতে পারে?';

  @override
  String get qClosest => 'সূর্যের সবচেয়ে কাছের গ্রহ কোনটি?';

  @override
  String get qFarthest => 'সূর্য থেকে সবচেয়ে দূরের গ্রহ কোনটি?';

  @override
  String get qStrongestGravity => 'কোন গ্রহের মাধ্যাকর্ষণ সবচেয়ে বেশি?';

  @override
  String get qShortestDay => 'কোন গ্রহের দিন সবচেয়ে ছোট?';

  @override
  String get qLongestDay => 'কোন গ্রহের দিন সবচেয়ে লম্বা?';

  @override
  String get appearance => 'চেহারা';

  @override
  String get theme => 'থিম';

  @override
  String get themeSystem => 'সিস্টেম';

  @override
  String get themeLight => 'লাইট';

  @override
  String get themeDark => 'ডার্ক';

  @override
  String get language => 'ভাষা';

  @override
  String get appLanguage => 'অ্যাপের ভাষা';

  @override
  String get languageNote => '২০টি ভাষা · গ্রহের নামও';

  @override
  String get phoneLanguage => 'ফোনের ভাষা';

  @override
  String get updates => 'আপডেট';

  @override
  String get version => 'সংস্করণ';

  @override
  String get checkForUpdates => 'আপডেট দেখুন';

  @override
  String get checking => 'দেখা হচ্ছে…';

  @override
  String get autoUpdateCheck => 'দিনে একবার নিজে থেকে দেখুন';

  @override
  String get updateNote =>
      'আপডেট GitHub Releases থেকে আসে। আপনার সেটিংস ফোনেই থাকে।';

  @override
  String get upToDate => 'আপনার কাছে সর্বশেষ সংস্করণ আছে।';

  @override
  String get updateFailed =>
      'GitHub-এ পৌঁছানো যায়নি। ইন্টারনেট দেখে আবার চেষ্টা করুন।';

  @override
  String get updateAvailable => 'আপডেট আছে';

  @override
  String updateReady(String version) {
    return 'সংস্করণ $version ডাউনলোডের জন্য তৈরি।';
  }

  @override
  String get download => 'ডাউনলোড';

  @override
  String get later => 'পরে';

  @override
  String get about => 'সম্পর্কে';

  @override
  String get sourceCode => 'GitHub-এ সোর্স কোড';

  @override
  String get privacyLine => 'অফলাইন · বিজ্ঞাপন নেই · ট্র্যাকিং নেই';

  @override
  String get dataSource => 'তথ্য: NASA Planetary Fact Sheet';

  @override
  String get openFailed => 'লিংক খোলা যায়নি।';

  @override
  String get bodySun => 'সূর্য';

  @override
  String get bodyMoon => 'চাঁদ';

  @override
  String get bodyPluto => 'প্লুটো';

  @override
  String get moonIo => 'আইও';

  @override
  String get moonEuropa => 'ইউরোপা';

  @override
  String get moonGanymede => 'গ্যানিমিড';

  @override
  String get moonCallisto => 'ক্যালিস্টো';

  @override
  String get moonTitan => 'টাইটান';

  @override
  String get moonEnceladus => 'এনসেলাডাস';

  @override
  String get moonTriton => 'ট্রাইটন';

  @override
  String get kindStar => 'আমাদের তারা, সৌরজগতের কেন্দ্র';

  @override
  String get kindDwarf => 'বামন গ্রহ';

  @override
  String moonOf(String planet) {
    return '$planet-এর চাঁদ';
  }

  @override
  String get orbitPeriod => 'একবার প্রদক্ষিণ';

  @override
  String distanceFrom(String body) {
    return '$body থেকে দূরত্ব';
  }

  @override
  String get composition => 'এটি কী দিয়ে তৈরি';

  @override
  String get noAtmosphere => 'আসল বায়ুমণ্ডল নেই, প্রায় শূন্যস্থান।';

  @override
  String get majorMoons => 'প্রধান চাঁদ';

  @override
  String get lifeTitle => 'মানুষ কি এখানে থাকতে পারবে?';

  @override
  String get lifeScoreShort => 'জীবন স্কোর';

  @override
  String get lifeNote =>
      'তাপমাত্রা, বায়ুচাপ, অক্সিজেন, পানি, পৃষ্ঠ আর মাধ্যাকর্ষণ থেকে হিসাব। পৃথিবীর স্কোর ১০।';

  @override
  String get water => 'পানি';

  @override
  String get waterLiquid => 'তরল পানি';

  @override
  String get waterIce => 'বরফ';

  @override
  String get waterOcean => 'বরফের নিচে সমুদ্র';

  @override
  String get waterNone => 'পানি নেই';

  @override
  String get surface => 'পৃষ্ঠ';

  @override
  String get solidSurface => 'শক্ত পৃষ্ঠ';

  @override
  String get lifeHome => 'একদম বাড়ির মতো';

  @override
  String get lifeHard => 'খুব কঠিন, বন্ধ ঘাঁটি আর স্পেসস্যুট লাগবে';

  @override
  String get lifeNo => 'মানুষের পক্ষে অসম্ভব';

  @override
  String get downloadInstall => 'ডাউনলোড করে ইনস্টল করুন';

  @override
  String downloadingPercent(String percent) {
    return 'ডাউনলোড হচ্ছে… $percent%';
  }

  @override
  String get installNow => 'ইনস্টল';

  @override
  String get allowInstalls =>
      'যে স্ক্রিন খুলেছে সেখানে Heliora-কে অ্যাপ ইনস্টলের অনুমতি দিন, তারপর ফিরে এসে ইনস্টল চাপুন।';

  @override
  String get downloadFailed =>
      'ডাউনলোড শেষ হয়নি। ইন্টারনেট দেখে আবার চেষ্টা করুন।';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String get today => 'আজ';

  @override
  String get play => 'চালান';

  @override
  String get pause => 'থামান';

  @override
  String get monthBack => '৩০ দিন আগে';

  @override
  String get monthForward => '৩০ দিন পরে';

  @override
  String get positionsNote =>
      'এই তারিখে আসল অবস্থান · আকার ও দূরত্ব মাপমতো নয় · গ্রহে ট্যাপ করুন';

  @override
  String get navYou => 'আপনি';

  @override
  String get ageTitle => 'অন্য গ্রহে আপনার বয়স';

  @override
  String get setBirthDate => 'আপনার জন্মতারিখ দিন';

  @override
  String get changeBirthDate => 'বদলান';

  @override
  String nextBirthday(String days) {
    return 'পরের জন্মদিন $days দিন পরে';
  }

  @override
  String get ageNote => 'আপনার জন্মতারিখ শুধু এই ফোনেই সেভ থাকে।';

  @override
  String get share => 'শেয়ার';

  @override
  String shareText(String planet) {
    return 'Heliora-তে $planet, বিনামূল্যের অফলাইন সৌরজগৎ অ্যাপ: https://github.com/lumio-apps/heliora';
  }

  @override
  String get shareFailed => 'ছবি শেয়ার করা যায়নি।';

  @override
  String get travelTitle => 'কত দূরে?';

  @override
  String get distanceFromEarth => 'আজ পৃথিবী থেকে দূরত্ব';

  @override
  String get lightTime => 'আলোর লাগে';

  @override
  String get bySpacecraft => '৬০,০০০ কিমি/ঘণ্টার মহাকাশযানে';

  @override
  String get byCar => '১০০ কিমি/ঘণ্টার গাড়িতে';

  @override
  String valueSeconds(String value) {
    return '$value সেকেন্ড';
  }

  @override
  String valueMinutes(String value) {
    return '$value মিনিট';
  }

  @override
  String get sizeTitle => 'আকার';

  @override
  String sizeTimes(String big, String times, String small) {
    return '$big চওড়ায় $small-এর $times× বড়।';
  }

  @override
  String sizeSimilar(String a, String b) {
    return '$a আর $b প্রায় একই আকারের।';
  }

  @override
  String get navSky => 'আকাশ';

  @override
  String get skyTitle => 'আজ রাতের আকাশ';

  @override
  String get chooseCity => 'আপনার শহর বাছুন';

  @override
  String get chooseCityHint =>
      'চাঁদ আর আজ রাতে কোন গ্রহ দেখা যাবে জানতে কাছের শহর বাছুন। লোকেশনের অনুমতি লাগে না, আর এটি ফোনেই থাকে।';

  @override
  String get searchCity => 'শহর খুঁজুন';

  @override
  String get noCityFound => 'কোনো শহর পাওয়া যায়নি';

  @override
  String get cityNote =>
      'সময় আপনার ফোনের টাইম জোনে। অন্ধকার আকাশে দিগন্ত থেকে অন্তত 5° উপরে থাকলে গ্রহ দৃশ্যমান ধরা হয়।';

  @override
  String illuminated(String percent) {
    return '$percent% আলোকিত';
  }

  @override
  String get moonrise => 'চন্দ্রোদয়';

  @override
  String get moonset => 'চন্দ্রাস্ত';

  @override
  String get sunset => 'সূর্যাস্ত';

  @override
  String get sunrise => 'সূর্যোদয়';

  @override
  String get nextFull => 'পরের পূর্ণিমা';

  @override
  String get nextNew => 'পরের অমাবস্যা';

  @override
  String get phaseNew => 'অমাবস্যা';

  @override
  String get phaseWaxingCrescent => 'বর্ধমান বাঁকা চাঁদ';

  @override
  String get phaseFirstQuarter => 'প্রথম পাদ';

  @override
  String get phaseWaxingGibbous => 'বর্ধমান কুঁজো চাঁদ';

  @override
  String get phaseFull => 'পূর্ণিমা';

  @override
  String get phaseWaningGibbous => 'ক্ষীয়মাণ কুঁজো চাঁদ';

  @override
  String get phaseLastQuarter => 'শেষ পাদ';

  @override
  String get phaseWaningCrescent => 'ক্ষীয়মাণ বাঁকা চাঁদ';

  @override
  String get planetsTonight => 'আজ রাতের গ্রহ';

  @override
  String get statusVisible => 'আজ রাতে দেখা যাবে';

  @override
  String get statusEvening => 'সন্ধ্যায়, সূর্যাস্তের পরে';

  @override
  String get statusMorning => 'ভোরে, সূর্যোদয়ের আগে';

  @override
  String get statusNotVisible => 'আজ রাতে দেখা যাবে না';

  @override
  String bestAt(String time) {
    return 'সবচেয়ে ভালো $time';
  }

  @override
  String altitudeDir(String direction, String degrees) {
    return '$direction, $degrees° উঁচুতে';
  }

  @override
  String riseSet(String rise, String set) {
    return 'ওঠে $rise · অস্ত $set';
  }

  @override
  String get needsTelescope => 'দূরবীন বা টেলিস্কোপ লাগবে';

  @override
  String get dirN => 'উত্তর';

  @override
  String get dirNE => 'উত্তর-পূর্ব';

  @override
  String get dirE => 'পূর্ব';

  @override
  String get dirSE => 'দক্ষিণ-পূর্ব';

  @override
  String get dirS => 'দক্ষিণ';

  @override
  String get dirSW => 'দক্ষিণ-পশ্চিম';

  @override
  String get dirW => 'পশ্চিম';

  @override
  String get dirNW => 'উত্তর-পশ্চিম';

  @override
  String get findPlanet => 'আকাশে খুঁজুন';

  @override
  String finderTitle(String name) {
    return '$name খুঁজুন';
  }

  @override
  String get pointPhone => 'ফোন উঁচু করে ধীরে ধীরে ঘোরান।';

  @override
  String turnRight(String degrees) {
    return '$degrees° ডানে ঘুরুন';
  }

  @override
  String turnLeft(String degrees) {
    return '$degrees° বাঁয়ে ঘুরুন';
  }

  @override
  String tiltUp(String degrees) {
    return '$degrees° উপরে তুলুন';
  }

  @override
  String tiltDown(String degrees) {
    return '$degrees° নিচে নামান';
  }

  @override
  String onTarget(String name) {
    return '$name ঠিক ওখানেই!';
  }

  @override
  String belowHorizon(String name) {
    return '$name এখন দিগন্তের নিচে।';
  }

  @override
  String risesAt(String time) {
    return 'এটি $time-এ উঠবে।';
  }

  @override
  String get noSensor => 'এই ফোনে কম্পাস সেন্সর নেই, তাই খোঁজক কাজ করবে না।';

  @override
  String get calibrate =>
      'কম্পাস ক্যালিব্রেট করতে হবে: ফোনটি কয়েকবার 8-এর আকারে ঘোরান।';

  @override
  String get phoneNow => 'আপনার ফোন এদিকে তাক করা';

  @override
  String get finderNote =>
      'ফোনের পেছন দিক আকাশের দিকে রাখুন এবং চুম্বক ও ধাতু থেকে দূরে রাখুন। কখনও সূর্যের দিকে তাকাবেন না।';

  @override
  String get eventsTitle => 'মহাকাশের ঘটনা';

  @override
  String get eventsSubtitle => 'আগামী ১২ মাসে আকাশে কী দেখবেন।';

  @override
  String eventsNext(String event, String when) {
    return 'পরের: $event · $when';
  }

  @override
  String get eventFullMoon => 'পূর্ণিমা';

  @override
  String get eventNewMoon => 'অমাবস্যা';

  @override
  String eventOpposition(String planet) {
    return '$planet বিপ্রতীপে (অপজিশন)';
  }

  @override
  String eventEveningElongation(String planet) {
    return '$planet: সন্ধ্যায় দেখার সেরা সময়';
  }

  @override
  String eventMorningElongation(String planet) {
    return '$planet: ভোরে দেখার সেরা সময়';
  }

  @override
  String eventConjunction(String a, String b) {
    return '$a ও $b কাছাকাছি আসছে';
  }

  @override
  String get eventMarchEquinox => 'মার্চ বিষুব';

  @override
  String get eventJuneSolstice => 'জুন অয়নান্ত';

  @override
  String get eventSeptemberEquinox => 'সেপ্টেম্বর বিষুব';

  @override
  String get eventDecemberSolstice => 'ডিসেম্বর অয়নান্ত';

  @override
  String get eventFullMoonDesc =>
      'চাঁদের পুরো মুখ আলোকিত থাকে। সূর্যাস্তের কাছাকাছি সময়ে ওঠে।';

  @override
  String get eventNewMoonDesc =>
      'চাঁদ দেখা যায় না। তারা ও গ্রহ দেখার জন্য মাসের সবচেয়ে অন্ধকার আকাশ।';

  @override
  String eventOppositionDesc(String planet) {
    return '$planet সূর্যের ঠিক উল্টো দিকে। এ বছর এটি সবচেয়ে উজ্জ্বল এবং সারা রাত দেখা যায়।';
  }

  @override
  String eventEveningDesc(String planet, String degrees) {
    return '$planet সূর্য থেকে $degrees° দূরে, সবচেয়ে বেশি দূরত্বে। সূর্যাস্তের পর পশ্চিমে নিচু আকাশে দেখুন।';
  }

  @override
  String eventMorningDesc(String planet, String degrees) {
    return '$planet সূর্য থেকে $degrees° দূরে, সবচেয়ে বেশি দূরত্বে। সূর্যোদয়ের আগে পূর্বে নিচু আকাশে দেখুন।';
  }

  @override
  String eventConjunctionDesc(String degrees) {
    return 'আকাশে এরা মাত্র $degrees° দূরত্বে পাশ কাটায়।';
  }

  @override
  String get eventEquinoxDesc => 'পৃথিবীর সব জায়গায় দিন ও রাত প্রায় সমান।';

  @override
  String get eventJuneSolsticeDesc =>
      'উত্তরে বছরের দীর্ঘতম দিন, দক্ষিণে ক্ষুদ্রতম।';

  @override
  String get eventDecemberSolsticeDesc =>
      'উত্তরে বছরের ক্ষুদ্রতম দিন, দক্ষিণে দীর্ঘতম।';

  @override
  String eventMeteorShower(String shower) {
    return '$shower উল্কাবৃষ্টি';
  }

  @override
  String eventMeteorDesc(String rate, String percent) {
    return 'অন্ধকার আকাশে ঘণ্টায় প্রায় $rateটি পর্যন্ত উল্কা। চাঁদ $percent% আলোকিত থাকবে।';
  }

  @override
  String get showerQuadrantids => 'কোয়াড্রান্টিডস';

  @override
  String get showerLyrids => 'লাইরিডস';

  @override
  String get showerEtaAquariids => 'ইটা অ্যাকুয়ারিডস';

  @override
  String get showerPerseids => 'পার্সিডস';

  @override
  String get showerOrionids => 'ওরায়োনিডস';

  @override
  String get showerLeonids => 'লিওনিডস';

  @override
  String get showerGeminids => 'জেমিনিডস';

  @override
  String get showerUrsids => 'আর্সিডস';

  @override
  String get eventToday => 'আজ';

  @override
  String get eventTomorrow => 'আগামীকাল';

  @override
  String eventInDays(String days) {
    return '$days দিন পরে';
  }

  @override
  String get eventsNote =>
      'তারিখগুলো আপনার ফোনেই হিসাব করা হয় এবং ফোনের টাইম জোনে দেখানো হয়। উল্কাবৃষ্টির সর্বোচ্চ দিন প্রতি বছরের স্বাভাবিক তারিখ, একদিন এদিক-ওদিক হতে পারে। রিমাইন্ডার আপনার ফোনেই থাকে।';

  @override
  String get remindMe => 'আমাকে মনে করিয়ে দিন';

  @override
  String reminderSet(String date) {
    return 'ঠিক আছে, আমি আপনাকে $date তারিখে মনে করিয়ে দেব।';
  }

  @override
  String get reminderOff => 'রিমাইন্ডার সরানো হয়েছে।';

  @override
  String get reminderTooLate => 'ঘটনাটি খুব কাছে, রিমাইন্ডার দেওয়া যাচ্ছে না।';

  @override
  String get notificationsOff =>
      'Heliora-র নোটিফিকেশন বন্ধ আছে। Android সেটিংসে চালু করুন।';

  @override
  String get reminderTomorrow => 'আগামীকাল হবে';

  @override
  String get reminderToday => 'আজ হচ্ছে';

  @override
  String get onlineTitle => 'অনলাইন সুবিধা';

  @override
  String get onlineSubtitle =>
      'মহাকাশ স্টেশন ও রকেট উৎক্ষেপণ দেখান। তখন Heliora শুধু wheretheiss.at, Celestrak ও Launch Library 2-এর সঙ্গে যোগাযোগ করে, যারা আপনার ফোনের ইন্টারনেট ঠিকানা দেখতে পায়। আর কিছু পাঠানো হয় না। শুরুতে বন্ধ থাকে।';

  @override
  String get turnOnOnline => 'অনলাইন সুবিধা চালু করুন';

  @override
  String get issTitle => 'মহাকাশ স্টেশন';

  @override
  String get issCardHint => 'এখন কোথায় আর আপনার ওপর দিয়ে কখন যাবে';

  @override
  String get issNeedsOnline =>
      'স্টেশন দেখাতে Heliora-র ইন্টারনেট থেকে এর কক্ষপথের তথ্য লাগে। একবার ডাউনলোড হলে কয়েক দিন অফলাইনে চলে।';

  @override
  String get issLoading => 'কক্ষপথের তথ্য আনা হচ্ছে…';

  @override
  String get issFailed =>
      'কক্ষপথের তথ্য পাওয়া যায়নি। ইন্টারনেট দেখে আবার চেষ্টা করুন।';

  @override
  String issStale(String days) {
    return 'কক্ষপথের তথ্য $days দিনের পুরনো, তাই অবস্থান কিছুটা ভুল হতে পারে। নতুন তথ্য আনতে ইন্টারনেটে যুক্ত হন।';
  }

  @override
  String get issHeight => 'উচ্চতা';

  @override
  String get issSpeed => 'গতি';

  @override
  String get issFromYou => 'আপনার থেকে দূরত্ব';

  @override
  String valueKmh(String value) {
    return '$value কিমি/ঘণ্টা';
  }

  @override
  String issAboveHorizon(String direction, String degrees) {
    return 'এখন আপনার দিগন্তের ওপরে! $direction দিকে তাকান, $degrees° উঁচুতে।';
  }

  @override
  String get issBelowHorizon => 'এখন আপনার দিগন্তের নিচে।';

  @override
  String issPassesTitle(String city) {
    return '$city-এর ওপর দিয়ে পরের যাত্রা';
  }

  @override
  String get issNoPasses => 'আগামী ৫ দিনে ভালো কোনো যাত্রা নেই।';

  @override
  String issMaxHigh(String degrees) {
    return '$degrees° পর্যন্ত উঁচু';
  }

  @override
  String issFromTo(String start, String end) {
    return '$start থেকে $end';
  }

  @override
  String get issVisible => 'সহজে দেখা যাবে';

  @override
  String get issHidden => 'দেখা কঠিন';

  @override
  String get issPassTitle => 'মহাকাশ স্টেশন আপনার ওপর দিয়ে যাচ্ছে';

  @override
  String issPassBody(String degrees, String direction) {
    return '১০ মিনিটে উঠবে, $degrees° পর্যন্ত উঁচু। $direction দিকে তাকান।';
  }

  @override
  String get issNote =>
      'অবস্থান আপনার ফোনেই স্টেশনের কক্ষপথের তথ্য থেকে হিসাব করা হয়। আকাশ অন্ধকার আর স্টেশনে সূর্যের আলো থাকলে সহজে দেখা যায়: উজ্জ্বল, দ্রুত চলা তারার মতো।';

  @override
  String get launchesNeedOnline =>
      'আসন্ন রকেট উৎক্ষেপণ এখানে দেখতে অনলাইন সুবিধা চালু করুন।';

  @override
  String get launchesFailed =>
      'উৎক্ষেপণের তালিকা হালনাগাদ করা যায়নি। সংরক্ষিত তালিকা দেখানো হচ্ছে।';

  @override
  String get launchesNote =>
      'উৎক্ষেপণের সময় Launch Library 2 থেকে আসে এবং প্রায়ই বদলায়। নাম ও জায়গা ইংরেজিতে।';

  @override
  String get launchReminderBody =>
      'প্রায় এক ঘণ্টায় উৎক্ষেপণ। সময় বদলাতে পারে।';

  @override
  String get launchTimeTbd => 'সময় এখনও ঠিক হয়নি';

  @override
  String get quizChoose => 'একটি স্তর বেছে নিন';

  @override
  String get levelEasy => 'সহজ';

  @override
  String get levelMedium => 'মাঝারি';

  @override
  String get levelHard => 'কঠিন';

  @override
  String get levelEasyHint => 'গ্রহ সম্পর্কে মৌলিক কথা';

  @override
  String get levelMediumHint => 'গ্রহ ও উপগ্রহ';

  @override
  String get levelHardHint => 'কঠিন তুলনা ও ক্রম';

  @override
  String get qStar => 'এগুলোর মধ্যে কোনটি তারা, গ্রহ নয়?';

  @override
  String get qDwarf => 'এগুলোর মধ্যে কোনটি বামন গ্রহ?';

  @override
  String get qMoonVisited => 'কোন উপগ্রহে মানুষ হেঁটেছে?';

  @override
  String get qLargestMoon => 'এই উপগ্রহগুলোর মধ্যে সবচেয়ে বড় কোনটি?';

  @override
  String get qSmallestMoon => 'এই উপগ্রহগুলোর মধ্যে সবচেয়ে ছোট কোনটি?';

  @override
  String get qThickAirMoon => 'এই উপগ্রহগুলোর মধ্যে কোনটির বায়ুমণ্ডল ঘন?';

  @override
  String get qGeyserMoon => 'কোন উপগ্রহ মহাকাশে জলের ফোয়ারা ছোড়ে?';

  @override
  String get qVolcanicMoon =>
      'কোন উপগ্রহে সবচেয়ে বেশি সক্রিয় আগ্নেয়গিরি আছে?';

  @override
  String get qBackwardsMoon => 'কোন উপগ্রহ তার গ্রহকে উল্টো দিকে ঘোরে?';

  @override
  String get qBiggestRocky => 'চারটি পাথুরে গ্রহের মধ্যে সবচেয়ে বড় কোনটি?';

  @override
  String get qColdestRocky => 'চারটি পাথুরে গ্রহের মধ্যে সবচেয়ে ঠান্ডা কোনটি?';

  @override
  String get qHighestPressure => 'কোন গ্রহের পৃষ্ঠে বাতাসের চাপ সবচেয়ে বেশি?';

  @override
  String get qSecondLargest => 'কোন গ্রহ দ্বিতীয় সবচেয়ে বড়?';

  @override
  String get qLongestYear => 'কোন গ্রহের বছর সবচেয়ে লম্বা?';

  @override
  String get qShortestYear => 'কোন গ্রহের বছর সবচেয়ে ছোট?';

  @override
  String get qSmallestGiant => 'চারটি বিশাল গ্রহের মধ্যে সবচেয়ে ছোট কোনটি?';

  @override
  String get qRockyLongestYear =>
      'চারটি পাথুরে গ্রহের মধ্যে কোনটির বছর সবচেয়ে লম্বা?';

  @override
  String get qFastestMoon =>
      'এই উপগ্রহগুলোর মধ্যে কোনটি তার গ্রহকে সবচেয়ে দ্রুত ঘোরে?';

  @override
  String get qSlowestMoon =>
      'এই উপগ্রহগুলোর মধ্যে কোনটি তার গ্রহকে ঘুরতে সবচেয়ে বেশি সময় নেয়?';

  @override
  String get qStrongestMoonGravity =>
      'এই উপগ্রহগুলোর মধ্যে কোনটির মহাকর্ষ সবচেয়ে বেশি?';

  @override
  String get qColdestMoon => 'এই উপগ্রহগুলোর মধ্যে সবচেয়ে ঠান্ডা কোনটি?';

  @override
  String get qSecondLargestMoon =>
      'এই উপগ্রহগুলোর মধ্যে দ্বিতীয় সবচেয়ে বড় কোনটি?';

  @override
  String get factTitle => 'আপনি কি জানেন?';

  @override
  String get factTap => 'আরেকটি তথ্য দেখতে ট্যাপ করুন';

  @override
  String get factSun1 => 'সৌরজগতের মোট ভরের ৯৯.৮% সূর্যের মধ্যে আছে।';

  @override
  String get factSun2 =>
      'সূর্যের আলো পৃথিবীতে পৌঁছাতে প্রায় ৮ মিনিট ২০ সেকেন্ড লাগে।';

  @override
  String get factMercury1 =>
      'বুধে এক দিন, মানে এক সূর্যোদয় থেকে পরের সূর্যোদয় পর্যন্ত, প্রায় ১৭৬ পৃথিবী-দিনের সমান। এটা তার বছরের দ্বিগুণ লম্বা।';

  @override
  String get factMercury2 =>
      'বুধে প্রায় কোনো বাতাস নেই, তাই দিনেও তার আকাশ কালো থাকে আর রাতগুলো হিমশীতল।';

  @override
  String get factVenus1 =>
      'শুক্র উল্টো দিকে ঘোরে, তাই সেখানে সূর্য পশ্চিমে ওঠে।';

  @override
  String get factVenus2 =>
      'সূর্য থেকে বেশি দূরে হলেও শুক্র বুধের চেয়ে গরম, কারণ তার ঘন বাতাস তাপ আটকে রাখে।';

  @override
  String get factEarth1 =>
      'পৃথিবীই একমাত্র জায়গা যেখানে প্রাণের কথা আমরা জানি, আর তার পৃষ্ঠের প্রায় ৭১% জলে ঢাকা।';

  @override
  String get factEarth2 =>
      'পৃথিবী নিখুঁত গোলক নয়। ঘোরার কারণে বিষুবরেখার কাছে সে একটু ফুলে আছে।';

  @override
  String get factMars1 =>
      'মঙ্গলের অলিম্পাস মনস সৌরজগতের সবচেয়ে উঁচু আগ্নেয়গিরি, মাউন্ট এভারেস্টের প্রায় আড়াই গুণ উঁচু।';

  @override
  String get factMars2 => 'মঙ্গলে সূর্যাস্ত নীল দেখায়।';

  @override
  String get factJupiter1 =>
      'বৃহস্পতির ভর বাকি সব গ্রহের মোট ভরের দ্বিগুণেরও বেশি।';

  @override
  String get factJupiter2 =>
      'গ্রেট রেড স্পট পৃথিবীর চেয়ে বড় একটি ঝড়, যা মানুষ ১৫০ বছরেরও বেশি সময় ধরে দেখছে।';

  @override
  String get factSaturn1 =>
      'শনি তার আকারের তুলনায় এত হালকা যে জলে ভেসে থাকবে, যদি এত বড় বাথটাব পাওয়া যেত।';

  @override
  String get factSaturn2 =>
      'শনির বলয় খুব চওড়া কিন্তু খুব পাতলা: কোথাও কোথাও মাত্র প্রায় দশ মিটার পুরু।';

  @override
  String get factUranus1 =>
      'ইউরেনাস কাত হয়ে গড়িয়ে গড়িয়ে সূর্যকে প্রদক্ষিণ করে, তার অক্ষ প্রায় ৯৮ ডিগ্রি হেলানো।';

  @override
  String get factUranus2 =>
      'ইউরেনাস দূরবীন দিয়ে আবিষ্কৃত প্রথম গ্রহ। উইলিয়াম হার্শেল ১৭৮১ সালে এটি দেখতে পান।';

  @override
  String get factNeptune1 =>
      'নেপচুনে যেকোনো গ্রহের চেয়ে দ্রুত হাওয়া বয়, ঘণ্টায় ২,০০০ কিমির বেশি।';

  @override
  String get factNeptune2 =>
      'কেউ দেখার আগেই নেপচুনকে অঙ্ক কষে পাওয়া গিয়েছিল: ১৮৪৬ সালে জ্যোতির্বিদরা হিসাব করে বের করেন সেটা কোথায় থাকার কথা।';

  @override
  String get factMoon1 =>
      'চাঁদ প্রতি বছর পৃথিবী থেকে প্রায় ৩.৮ সেন্টিমিটার আরও দূরে সরে যায়।';

  @override
  String get factMoon2 =>
      'আমরা চাঁদের সবসময় একই পাশ দেখি, কারণ পৃথিবীকে প্রতিবার ঘোরার সময় সে ঠিক একবার নিজের চারপাশে ঘোরে।';

  @override
  String get factPluto1 => 'প্লুটোতে এক বছর প্রায় ২৪৮ পৃথিবী-বছরের সমান।';

  @override
  String get factPluto2 =>
      'প্লুটোতে জমাট নাইট্রোজেনের একটি বিশাল হৃদয়ের আকারের সমভূমি আছে।';

  @override
  String get factIo1 =>
      'আইও আমাদের জানা সবচেয়ে আগ্নেয় জগৎ, সেখানে শত শত সক্রিয় আগ্নেয়গিরি আছে।';

  @override
  String get factIo2 =>
      'বৃহস্পতির মহাকর্ষ আইওকে চেপে ও টেনে ধরে, আর তা থেকে তৈরি তাপ তার আগ্নেয়গিরিগুলোকে চালায়।';

  @override
  String get factEuropa1 =>
      'বরফের খোলের নিচে ইউরোপায় সম্ভবত পৃথিবীর সব মহাসাগরের প্রায় দ্বিগুণ জল আছে।';

  @override
  String get factEuropa2 =>
      'পৃথিবীর বাইরে প্রাণ খোঁজার সেরা জায়গাগুলোর একটি ইউরোপা। ইউরোপা ক্লিপার মহাকাশযান সেখানে যাচ্ছে।';

  @override
  String get factGanymede1 =>
      'গ্যানিমিড সৌরজগতের সবচেয়ে বড় উপগ্রহ। এটি বুধের চেয়েও বড়।';

  @override
  String get factGanymede2 =>
      'গ্যানিমিডই একমাত্র উপগ্রহ যার নিজস্ব চৌম্বক ক্ষেত্র আছে বলে জানা গেছে।';

  @override
  String get factCallisto1 =>
      'ক্যালিস্টো সৌরজগতের সবচেয়ে বেশি গর্তওয়ালা জায়গাগুলোর একটি, আর তার পৃষ্ঠ খুব পুরনো।';

  @override
  String get factCallisto2 =>
      'ক্যালিস্টো বৃহস্পতি থেকে এত দূরে যে তার কড়া বিকিরণ কম পায়, তাই বিজ্ঞানীরা ভবিষ্যতের ঘাঁটির জন্য এর কথা বলেছেন।';

  @override
  String get factTitan1 =>
      'টাইটানই একমাত্র উপগ্রহ যার বায়ুমণ্ডল ঘন। তার পৃষ্ঠে বাতাসের চাপ পৃথিবীর চেয়ে বেশি।';

  @override
  String get factTitan2 =>
      'টাইটানে নদী ও হ্রদ আছে, কিন্তু সেগুলোতে জল নয়, তরল মিথেন আর ইথেন আছে।';

  @override
  String get factEnceladus1 =>
      'এনসেলাডাস তার দক্ষিণ মেরুর কাছের ফাটল দিয়ে বরফ আর জলীয় বাষ্পের ফোয়ারা মহাকাশে ছোড়ে।';

  @override
  String get factEnceladus2 =>
      'এনসেলাডাসের এই ফোয়ারা শনির E বলয়কে ভরিয়ে রাখে।';

  @override
  String get factTriton1 =>
      'ট্রাইটন নেপচুনকে উল্টো দিকে ঘোরে, তাই সম্ভবত সে একটি বামন গ্রহ ছিল যাকে নেপচুন ধরে ফেলেছে।';

  @override
  String get factTriton2 =>
      'প্রায় −২৩৫ °C তাপমাত্রায় ট্রাইটন সৌরজগতের সবচেয়ে ঠান্ডা জায়গাগুলোর একটি, যেখানে তাপমাত্রা মাপা হয়েছে।';

  @override
  String get jumpInput => 'পৃথিবীতে আপনার লাফের উচ্চতা (সেমি)';

  @override
  String jumpHigh(String height) {
    return 'লাফ: $height';
  }

  @override
  String jumpFeelsLike(String height) {
    return 'পৃথিবীতে $height লাফ এখানে হয়ে যায়';
  }

  @override
  String get jumpNote =>
      'ধাক্কা পৃথিবীর মতোই থাকে। সূর্য আর গ্যাসের বিশাল গ্রহগুলোতে দাঁড়ানোর মাটি নেই, তাই এটা শুধুই কল্পনার খেলা।';

  @override
  String valueCm(String value) {
    return '$value সেমি';
  }

  @override
  String valueM(String value) {
    return '$value মি';
  }

  @override
  String get eclipseTotalLunar => 'পূর্ণ চন্দ্রগ্রহণ';

  @override
  String get eclipsePartialLunar => 'আংশিক চন্দ্রগ্রহণ';

  @override
  String get eclipsePenumbralLunar => 'উপচ্ছায়া চন্দ্রগ্রহণ';

  @override
  String get eclipseTotalSolar => 'পূর্ণ সূর্যগ্রহণ';

  @override
  String get eclipseAnnularSolar => 'বলয় সূর্যগ্রহণ';

  @override
  String get eclipseHybridSolar => 'সংকর সূর্যগ্রহণ';

  @override
  String get eclipsePartialSolar => 'আংশিক সূর্যগ্রহণ';

  @override
  String get eclipseTotalLunarDesc =>
      'চাঁদ পুরোপুরি পৃথিবীর ছায়ায় ঢুকে পড়ে এবং প্রায়ই ম্লান লাল দেখায়। পৃথিবীর রাতের দিকের সবাই এটি দেখতে পায়, আর খালি চোখে দেখা নিরাপদ।';

  @override
  String eclipsePartialLunarDesc(String percent) {
    return 'চাঁদের একটি অংশ (প্রস্থের $percent%) পৃথিবীর গাঢ় ছায়ায় ঢুকে পড়ে। খালি চোখে দেখা নিরাপদ।';
  }

  @override
  String get eclipsePenumbralLunarDesc =>
      'চাঁদ পৃথিবীর হালকা বাইরের ছায়ার ভেতর দিয়ে যায়। শুধু একটু ম্লান হয়, তাই চোখে পড়া কঠিন।';

  @override
  String get eclipseTotalSolarDesc =>
      'পৃথিবীর ওপর একটি সরু পথ ধরে চাঁদ সূর্যকে পুরোপুরি ঢেকে দেয়। সেই পথের বাইরে আংশিক গ্রহণ দেখা যায়।';

  @override
  String get eclipseAnnularSolarDesc =>
      'চাঁদ একটু বেশি দূরে থাকায় সূর্যকে পুরো ঢাকতে পারে না, ফলে একটি উজ্জ্বল বলয় থেকে যায়। বলয়টি একটি সরু পথে দেখা যায়; তার বাইরে গ্রহণ আংশিক।';

  @override
  String get eclipseHybridSolarDesc =>
      'নিজের পথে এই গ্রহণ কোথাও পূর্ণ আর কোথাও বলয়ের মতো দেখায়। পথের বাইরে এটি আংশিক।';

  @override
  String get eclipsePartialSolarDesc =>
      'চাঁদ সূর্যের শুধু একটি অংশ ঢাকে, আর পৃথিবীর কোথাও সূর্য পুরো ঢাকে না।';

  @override
  String get eclipseNoCity =>
      'Heliora-য় একটি শহর বেছে নিন, তাহলে দেখা যাবে সেখান থেকে এটি দেখা যাবে কি না।';

  @override
  String eclipseLunarUp(String city) {
    return 'গ্রহণের মাঝামাঝি সময়ে $city-তে চাঁদ দিগন্তের ওপরে থাকে।';
  }

  @override
  String eclipseLunarPartly(String city) {
    return '$city-তে গ্রহণের শুধু একটি অংশে চাঁদ দিগন্তের ওপরে থাকে।';
  }

  @override
  String eclipseLunarDown(String city) {
    return '$city-তে চাঁদ দিগন্তের নিচেই থাকে, তাই সেখান থেকে দেখা যাবে না।';
  }

  @override
  String eclipseSolarNone(String city) {
    return '$city থেকে দেখা যাবে না: চাঁদের ছায়া সেখানে পৌঁছায় না, অথবা সূর্য দিগন্তের নিচে থাকে।';
  }

  @override
  String eclipseSolarSlight(String city) {
    return '$city থেকে বড়জোর খুব সামান্য আংশিক গ্রহণ দেখা যাবে, যা চোখে পড়া কঠিন।';
  }

  @override
  String eclipseSolarPartial(String city, String percent) {
    return '$city-এর জন্য মোটামুটি আন্দাজ: চাঁদ সর্বোচ্চ সূর্যের প্রস্থের প্রায় $percent% ঢাকে।';
  }

  @override
  String eclipseSolarNear(String city) {
    return '$city সেই পথের কাছে যেখানে সূর্য প্রায় বা পুরোপুরি ঢাকা পড়ে। গ্রহণের মানচিত্র দেখে নিন; এই আন্দাজ মোটামুটি।';
  }

  @override
  String get eclipseSolarSafety =>
      'সঠিক গ্রহণ-চশমা ছাড়া কখনও সূর্যের দিকে তাকাবেন না।';

  @override
  String get alertsTitle => 'অ্যালার্ট';

  @override
  String get tonightAlertSwitch => 'প্রতি সন্ধ্যায় আজ রাতের আকাশ';

  @override
  String get tonightAlertTime => 'সময়';

  @override
  String get tonightAlertNote =>
      'আপনার বেছে নেওয়া সময়ে চাঁদ আর দেখা যাবে এমন গ্রহদের নিয়ে একটি ছোট বার্তা। এটি আপনার ফোনেই তৈরি হয়, ইন্টারনেট লাগে না। Android Heliora-কে আগে থেকে শুধু প্রায় দুই সপ্তাহের বার্তা তৈরি রাখতে দেয়, তাই মাঝে মাঝে অ্যাপটি খুলুন।';

  @override
  String get tonightNotifTitle => 'আজ রাতের আকাশ';

  @override
  String tonightMoon(String phase, String percent) {
    return 'চাঁদ: $phase, $percent% আলোকিত।';
  }

  @override
  String tonightPlanets(String planets) {
    return 'খুঁজে দেখুন: $planets।';
  }

  @override
  String get tonightNoPlanets => 'সন্ধ্যার আকাশে কোনো উজ্জ্বল গ্রহ নেই।';

  @override
  String get tonightNoCity => 'গ্রহ দেখতে Heliora-য় একটি শহর বেছে নিন।';

  @override
  String get birthdayTitle => 'আমার জন্মদিনের আকাশ';

  @override
  String get birthdaySubtitle =>
      'আপনি যেদিন জন্মেছিলেন সেদিন চাঁদ আর গ্রহরা কোথায় ছিল, এবং আপনার জীবনের বিশেষ দিনগুলো।';

  @override
  String get birthdayCardHint => 'চাঁদের কলা, গ্রহ আর মাইলফলক';

  @override
  String get birthdayNeedDate => 'আপনার জন্মতারিখ দিন';

  @override
  String get birthdayMoon => 'আপনার জন্মদিনে চাঁদ';

  @override
  String get birthdayPlanets => 'সেদিন গ্রহরা';

  @override
  String birthdayDaysOld(String count) {
    return 'আজ আপনার বয়স $count দিন।';
  }

  @override
  String get birthdayMilestones => 'মাইলফলক';

  @override
  String birthdayDayN(String count) {
    return '$count তম দিন';
  }

  @override
  String get birthdayBillion => '১০০ কোটি সেকেন্ড বয়স';

  @override
  String get birthdayPassed => 'হয়ে গেছে';

  @override
  String get birthdayNote =>
      'Heliora-র বাকি অংশের মতো একই কক্ষপথ থেকে আপনার ফোনেই হিসাব করা হয়। আপনার জন্মতারিখ ফোনের বাইরে যায় না।';

  @override
  String get missionsTitle => 'মহাকাশ অভিযান';

  @override
  String get missionsSubtitle =>
      'মহাকাশ অভিযানের বিখ্যাত মুহূর্ত, সবচেয়ে পুরোনোটি আগে।';

  @override
  String get missionsCardHint => 'সময়ের পথে বিখ্যাত অভিযান';

  @override
  String get missionSputnik1 =>
      'প্রথম কৃত্রিম উপগ্রহ। সৈকতে খেলার বলের মতো এই ধাতব গোলকটি প্রায় তিন মাস পৃথিবীকে ঘুরেছিল। এর বিপ বিপ শব্দ রেডিওতে শোনা যেত, আর এখান থেকেই মহাকাশ যুগ শুরু হয়।';

  @override
  String get missionVostok1 =>
      'ইউরি গাগারিন মহাকাশে যাওয়া প্রথম মানুষ হলেন। তিনি প্রায় ১০৮ মিনিটে পৃথিবীকে একবার ঘুরে এসেছিলেন।';

  @override
  String get missionApollo11 =>
      'নিল আর্মস্ট্রং আর বাজ অলড্রিন শান্তির সাগরে নামলেন এবং চাঁদে হাঁটা প্রথম মানুষ হলেন। মাইকেল কলিন্স কক্ষপথে তাঁদের জন্য অপেক্ষা করছিলেন।';

  @override
  String get missionVenera7 =>
      'অন্য গ্রহে নেমে সংকেত পাঠানো প্রথম মহাকাশযান। প্রচণ্ড গরমে শুক্র থেকে এটি প্রায় ২৩ মিনিট তথ্য পাঠিয়েছিল।';

  @override
  String get missionViking1 =>
      'এটি মঙ্গলে নেমে ছয় বছরের বেশি কাজ করেছিল, এবং অন্য গ্রহের মাটি থেকে ছবি আর আবহাওয়ার খবরের প্রথম দীর্ঘ ধারা পাঠিয়েছিল।';

  @override
  String get missionVoyager1 =>
      '১৯৭৭ সালে ছাড়া হয়, বৃহস্পতি আর শনির পাশ দিয়ে গিয়ে ২০১২ সালে নক্ষত্রদের মাঝের মহাকাশে ঢোকে। পৃথিবী থেকে এটিই মানুষের তৈরি সবচেয়ে দূরের বস্তু।';

  @override
  String get missionHubble =>
      '১৯৯০ সালে ছাড়া হয়, পৃথিবীর বাতাসের ওপর থেকে মহাবিশ্বকে দেখে। এর স্পষ্ট ছবি মহাবিশ্বের বয়স মাপতে সাহায্য করেছে এবং হাজার হাজার দূরের ছায়াপথ দেখিয়েছে।';

  @override
  String get missionHuygens =>
      'ক্যাসিনির সঙ্গে যাওয়া যন্ত্র হাইগেনস প্যারাশুটে শনির চাঁদ টাইটানে নামে। বাইরের সৌরজগতে এটিই প্রথম অবতরণ, আর এটি সেখানকার মাটি থেকে ছবি পাঠিয়েছিল।';

  @override
  String get missionCuriosity =>
      'গাড়ির মতো বড় এই রোভার রকেটচালিত ’স্কাই ক্রেন’-এর সাহায্যে গেইল গহ্বরে নামে। এটি জানিয়েছে, মঙ্গলে একসময় প্রাণের উপযোগী পরিস্থিতি ছিল।';

  @override
  String get missionMangalyaan =>
      'ভারতের মঙ্গল অরবিটার মিশন প্রথম চেষ্টাতেই মঙ্গলের কক্ষপথে পৌঁছায়। কোনো দেশের জন্য এটি প্রথম, এবং খরচও ছিল খুব কম।';

  @override
  String get missionRosetta =>
      'রোসেটার ল্যান্ডার ফিলে ধূমকেতু 67P/চুরিউমভ–গেরাসিমেঙ্কোয় নামে, ধূমকেতুতে এটিই প্রথম অবতরণ। রোসেটা নিজে দুই বছর ধূমকেতুটিকে ঘুরেছিল।';

  @override
  String get missionNewhorizons =>
      'নয় বছরের যাত্রার পর এটি প্লুটোর পাশ দিয়ে যায় এবং প্রথমবার আমাদের বরফের পাহাড় আর হৃদয়ের আকারের বিশাল সমভূমি দেখায়।';

  @override
  String get missionPerseverance =>
      'পারসিভারেন্স রোভার প্রাচীন প্রাণের চিহ্ন খুঁজতে আর পাথরের নমুনা জমাতে জেজেরো গহ্বরে নামে। এর হেলিকপ্টার ইনজেনুইটি অন্য গ্রহে প্রথম চালিত উড়ান দেয়।';

  @override
  String get missionJwst =>
      'সবচেয়ে বড় মহাকাশ দুরবিনের আয়না ৬.৫ মিটারের, সোনালি, আর এটি ১৫ লক্ষ কিমি দূর থেকে ইনফ্রারেড আলোয় আকাশ দেখে। এটি একেবারে প্রথম দিকের কিছু ছায়াপথ দেখতে পায়।';

  @override
  String get missionChandrayaan3 =>
      'ভারত চাঁদে নিরাপদে নামা চতুর্থ দেশ হলো, এবং দক্ষিণ মেরুর কাছে নামা প্রথম। বিক্রম ল্যান্ডার সঙ্গে নিয়ে গিয়েছিল প্রজ্ঞান রোভার।';

  @override
  String get spacecraftTitle => 'মহাকাশযান এখন';

  @override
  String get spacecraftSubtitle =>
      'কিছু বিখ্যাত মহাকাশযান এই মুহূর্তে পৃথিবী থেকে কত দূরে।';

  @override
  String get spacecraftCardHint =>
      'ভয়েজার, JWST, মঙ্গলের রোভার আর আরও অনেক কিছু';

  @override
  String get spacecraftDistance => 'পৃথিবী থেকে দূরত্ব';

  @override
  String get spacecraftAltitude => 'পৃথিবী থেকে উচ্চতা';

  @override
  String get spacecraftInAu => 'জ্যোতির্বিজ্ঞান একক-এ';

  @override
  String get spacecraftSpeed => 'গতি';

  @override
  String get spacecraftSignal => 'রেডিও সংকেতের লাগে';

  @override
  String get spacecraftNote =>
      'দূরত্বগুলো আনুমানিক। দূরের যানগুলোর ক্ষেত্রে এগুলো গড় গতি থেকে হিসাব করা, আর পৃথিবী সূর্যকে ঘিরে ঘোরে বলে প্রায় ১% ভুল হতে পারে। মঙ্গলের দূরত্ব আজকের জন্য হিসাব করা। এক AU (জ্যোতির্বিজ্ঞান একক) হলো পৃথিবী থেকে সূর্যের দূরত্ব।';

  @override
  String valueBillionKm(String value) {
    return '$value বিলিয়ন কিমি';
  }

  @override
  String valueAu(String value) {
    return '$value AU';
  }

  @override
  String valueKmS(String value) {
    return '$value কিমি/সেকেন্ড';
  }

  @override
  String get spacecraftVoyager1 =>
      '১৯৭৭ সালে ছাড়া হয়েছিল। ২০১২ সালে এটি নক্ষত্রের মধ্যবর্তী মহাকাশে পৌঁছানো প্রথম মহাকাশযান হয়। এর রেডিও সংকেত আমাদের কাছে পৌঁছাতে পৌঁছাতে প্রায় এক দিন পুরোনো হয়ে যায়।';

  @override
  String get spacecraftVoyager2 =>
      '১৯৭৭ সালে ছাড়া হয়েছিল। ইউরেনাস আর নেপচুনে পৌঁছানো এটিই একমাত্র মহাকাশযান, আর ২০১৮ সালে এটি নক্ষত্রের মধ্যবর্তী মহাকাশে পৌঁছায়।';

  @override
  String get spacecraftNewHorizons =>
      '২০১৫ সালে প্লুটোর পাশ দিয়ে এবং ২০১৯ সালে কুইপার বেল্টের বস্তু অ্যারোকোথের পাশ দিয়ে গেছে। এখনও বাইরের দিকে এগোচ্ছে আর তথ্য পাঠাচ্ছে।';

  @override
  String get spacecraftJwst =>
      'সবচেয়ে বড় মহাকাশ টেলিস্কোপ, ২০২১ সালে ছাড়া হয়েছে। এটি L2 নামের একটি বিন্দুর কাছে, পৃথিবী থেকে প্রায় ১৫ লক্ষ কিমি দূরে থাকে, আর এর সূর্যঢাল সবসময় সূর্যের দিকে ফেরানো।';

  @override
  String get spacecraftIss =>
      'প্রায় প্রতি ৯০ মিনিটে পৃথিবীকে একবার ঘোরে। ২০০০ সাল থেকে এতে মানুষ বিরতিহীনভাবে বাস করছে।';

  @override
  String get spacecraftHubble =>
      '১৯৯০ সালে ছাড়া হয়েছে আর এখনও কাজ করছে। ঝাপসা করা বাতাসের ওপর দিয়ে পৃথিবীকে ঘোরে, তাই এর ছবি খুব স্পষ্ট।';

  @override
  String get spacecraftMarsRovers =>
      'কিউরিওসিটি (২০১২ সালে নেমেছে) আর পারসিভিয়ারেন্স (২০২১ সালে নেমেছে) মঙ্গলে চলছে। মঙ্গলের দূরত্ব প্রায় ৫ কোটি ৫০ লক্ষ কিমি থেকে বদলে ৪০ কোটি কিমির বেশি হয়ে যায়।';

  @override
  String get searchTooltip => 'খুঁজুন';

  @override
  String get searchHint => 'গ্রহ, চাঁদ, অভিযান খুঁজুন…';

  @override
  String get searchClear => 'মুছুন';

  @override
  String searchEmpty(String query) {
    return '“$query”-এর জন্য কিছু পাওয়া যায়নি।';
  }

  @override
  String get searchBodies => 'গ্রহ ও চাঁদ';

  @override
  String get searchMissions => 'অভিযান';

  @override
  String get searchSpacecraft => 'মহাকাশযান';

  @override
  String get favoritesTitle => 'প্রিয়';

  @override
  String get favoritesEmpty =>
      'কোনো গ্রহ, অভিযান বা মহাকাশযানের তারায় চাপ দিন, সেটি এখানে থাকবে।';

  @override
  String get favoriteAdd => 'প্রিয়তে যোগ করুন';

  @override
  String get favoriteRemove => 'প্রিয় থেকে সরান';

  @override
  String get textSize => 'লেখার আকার';

  @override
  String get textSizeNormal => 'সাধারণ';

  @override
  String get textSizeLarge => 'বড়';

  @override
  String get textSizeLarger => 'আরও বড়';

  @override
  String get textSizeNote =>
      'Heliora-র লেখা বড় করে। এটি কখনও আপনার ফোনের নিজের লেখার আকারের চেয়ে ছোট হয় না।';

  @override
  String get skyOtherNight => 'রাতের আকাশ';

  @override
  String get planetsThatNight => 'সেই রাতের গ্রহ';

  @override
  String get previousDay => 'আগের দিন';

  @override
  String get nextDay => 'পরের দিন';

  @override
  String get pickDate => 'তারিখ বেছে নিন';

  @override
  String get backToTonight => 'আজ রাতে ফিরুন';

  @override
  String get moonCalendar => 'চাঁদের ক্যালেন্ডার';

  @override
  String get moonCalendarHint => 'প্রতিদিন চাঁদের কলা';

  @override
  String get previousMonth => 'আগের মাস';

  @override
  String get nextMonth => 'পরের মাস';

  @override
  String get keyMoonDates => 'এই মাসের প্রধান কলা';

  @override
  String get moonCalendarNote =>
      'কলার তারিখ ও সময় আপনার ফোনের সময় অঞ্চলে দেখানো হয়েছে এবং প্রায় এক ঘণ্টার মধ্যে নির্ভুল।';

  @override
  String get seeSkyThatDay => 'এই দিনের আকাশ দেখুন';

  @override
  String get sunLightTitle => 'সূর্য ও আলো';

  @override
  String get firstLight => 'প্রথম আলো';

  @override
  String get goldenMorningEnds => 'সকালের সোনালি সময় শেষ';

  @override
  String get solarNoon => 'সূর্য সবচেয়ে উঁচুতে';

  @override
  String get goldenEveningStarts => 'বিকেলের সোনালি সময় শুরু';

  @override
  String get lastLight => 'শেষ আলো';

  @override
  String get darkSky => 'পুরো অন্ধকার আকাশ';

  @override
  String get sunDayLength => 'দিনের দৈর্ঘ্য';

  @override
  String durationHm(String hours, String minutes) {
    return '$hours ঘণ্টা $minutes মিনিট';
  }

  @override
  String get sunNote =>
      'সোনালি সময় হলো যখন সূর্য দিগন্তের 6° এর কম উপরে থাকে। প্রথম ও শেষ আলো হয় যখন সে 6° নিচে থাকে, আর আকাশ পুরো অন্ধকার হয় যখন সে 18° নিচে থাকে। সময়গুলো আপনার বেছে নেওয়া তারিখের জন্য হিসাব করা।';

  @override
  String get sunStaysUp => 'এই দিনে সূর্য অস্ত যায় না।';

  @override
  String get sunStaysDown => 'এই দিনে সূর্য ওঠে না।';

  @override
  String get solarSystemTitle => 'সৌরজগৎ';

  @override
  String get starMapTitle => 'তারার মানচিত্র';

  @override
  String get starMapCardHint => 'আপনার আকাশের তারা ও তারামণ্ডল';

  @override
  String get starMapHint =>
      'চারপাশ দেখতে টেনে সরান, জুম করতে দুই আঙুলে ছড়ান, কোনো তারা বা তারামণ্ডলে ট্যাপ করুন।';

  @override
  String get starsLabel => 'তারা';

  @override
  String get constellationsLabel => 'তারামণ্ডল';

  @override
  String get starMapFind => 'খুঁজুন';

  @override
  String get constellationsList => 'সব তারামণ্ডল';

  @override
  String magnitudeValue(String value) {
    return 'উজ্জ্বলতা $value';
  }

  @override
  String get starBelowHorizon => 'এই সময়ে দিগন্তের নিচে';

  @override
  String get starMapNow => 'এখন';

  @override
  String get starUnnamed => 'তারা';

  @override
  String get binocularsTitle => 'বাইনোকুলার গাইড';

  @override
  String get binocularsHint => 'সাধারণ বাইনোকুলারে কী দেখবেন';

  @override
  String get binocularsIntro =>
      'বাইনোকুলার স্থির ধরুন, যেমন কনুই দেয়াল বা গাড়ির ছাদে রেখে। শহরের আলো থেকে দূরে তীক্ষ্ণ তারার বদলে ঝাপসা, ছড়ানো দাগ খুঁজুন।';

  @override
  String get binocularsNote =>
      'সময় দেখায় আপনার বেছে নেওয়া শহরে রাতের অন্ধকার অংশে প্রতিটি বস্তু কখন সবচেয়ে উঁচুতে থাকে। বস্তুর নামগুলো সারা বিশ্বে প্রচলিত নাম। তারার মানচিত্রে দেখতে একটিতে ট্যাপ করুন।';

  @override
  String get dsoCluster => 'তারাপুঞ্জ';

  @override
  String get dsoGalaxy => 'গ্যালাক্সি';

  @override
  String get dsoNebula => 'নীহারিকা';

  @override
  String get storyOri =>
      'শিকারি ওরিয়ন সহজেই চেনা যায়: একটি ছোট সোজা রেখায় তিনটি তারা তার কোমরবন্ধ। কোমরবন্ধের উপরে কমলা রঙের বেটেলজুস একটি কাঁধ আর নিচে নীলচে-সাদা রাইজেল একটি পা বোঝায়। কোমরবন্ধের নিচে ঝুলে আছে এক ঝাপসা দাগ, ওরিয়ন নীহারিকা, যে মেঘে নতুন তারা জন্ম নিচ্ছে। উত্তরে ওরিয়ন শীতের সন্ধ্যায় আর দক্ষিণে গ্রীষ্মের সন্ধ্যায় দেখা যায়।';

  @override
  String get storyUMa =>
      'বিগ ডিপার বা লাঙল নামে পরিচিত সাতটি উজ্জ্বল তারা সপ্তর্ষিমণ্ডল, অর্থাৎ বড় ভালুকের অংশ। বাটির প্রান্তের দুটি তারা, দুবহে আর মেরাক, ধ্রুবতারার দিকে পথ দেখায়: তাদের মধ্যবর্তী দূরত্বের প্রায় পাঁচ গুণ পর্যন্ত রেখাটি উপরের দিকে বাড়ান। উত্তরের অনেক জায়গা থেকে সপ্তর্ষিমণ্ডল সারা রাত ধ্রুবতারাকে ঘিরে ঘোরে, কখনো অস্ত যায় না।';

  @override
  String get storyUMi =>
      'ধ্রুবতারা, উত্তর দিকের তারা, ছোট ভালুকের লেজের ডগায় আছে। এটি প্রায় নড়ে না, কারণ এটি পৃথিবীর উত্তর মেরুর প্রায় ঠিক উপরে, তাই পুরো আকাশ ওকে ঘিরেই ঘুরছে মনে হয়। দিগন্ত থেকে এর উচ্চতা আপনার অক্ষাংশের সমান। এটি খুব উজ্জ্বল তারা নয়, কিন্তু উত্তর খুঁজতে সবচেয়ে কাজের। পৃথিবীর দক্ষিণ অর্ধ থেকে একে দেখা যায় না।';

  @override
  String get storyCas =>
      'ক্যাসিওপিয়া সময় ও ঋতুভেদে W বা M-এর মতো দেখায়, এতে পাঁচটি বেশ উজ্জ্বল তারা আছে। এটি ধ্রুবতারার সেই পাশে, যে পাশে সপ্তর্ষিমণ্ডল নেই, তাই একটি নিচে থাকলে অন্যটি উপরে থাকে। পুরোনো গল্পে তিনি এক রানি, যিনি নিজের রূপ নিয়ে গর্ব করতেন।';

  @override
  String get storyCyg =>
      'রাজহাঁস (সিগনাস) ছায়াপথ বরাবর উড়ে যায়। এর সবচেয়ে উজ্জ্বল তারাগুলো উত্তরের ক্রস গড়ে, যার মাথায় ডেনেব, অর্থাৎ হাঁসের লেজ। শহরের আলো থেকে দূরে ছায়াপথকে হাঁসের মধ্য দিয়ে বয়ে যাওয়া ফ্যাকাশে আলোর নদীর মতো দেখায়, আর বাইনোকুলারে বোঝা যায় এটি অসংখ্য ক্ষীণ তারায় গড়া। গ্রীষ্ম ও শরতের সন্ধ্যা সবচেয়ে ভালো সময়।';

  @override
  String get storySco =>
      'বৃশ্চিক (স্করপিয়াস) দেখতে বাঁকা লেজ আর বড়শির মতো ডগাওয়ালা এক কাঁকড়াবিছের মতো। এর হৃদয় লাল জ্যেষ্ঠা (অ্যান্টারেস), যার নামের অর্থ মঙ্গলের প্রতিদ্বন্দ্বী, কারণ রঙে দুটি একরকম দেখায়। উত্তরে এটি গ্রীষ্মের তারামণ্ডল, দক্ষিণ আকাশে নিচু, আর পৃথিবীর দক্ষিণ অর্ধের মানুষের মাথার ওপর দিয়ে উঁচুতে যায়।';

  @override
  String get storyLeo =>
      'সিংহ (লিও) সেই অল্প কয়েকটি তারামণ্ডলের একটি, যা সত্যিই নিজের প্রাণীর মতো দেখায়। তারার উল্টো প্রশ্নচিহ্ন, যার নাম কাস্তে, মাথা ও বুক গড়ে এবং উজ্জ্বল মঘা (রেগুলাস), সিংহের হৃদয়ে শেষ হয়। পূর্ব দিকের তারার ত্রিভুজটি তার পেছনের অংশ। উত্তরে বসন্তের সন্ধ্যা সবচেয়ে ভালো সময়।';

  @override
  String get storyTau =>
      'বৃষ (টরাস) এর মুখ V আকারের, এটি হায়াডিস তারাপুঞ্জ, আর কমলা রোহিণী (অ্যালডেবারান) তার চোখ। রোহিণীকে মনে হয় পুঞ্জের অংশ, কিন্তু আসলে সে আমাদের অনেক কাছে। উপরে কৃত্তিকা (প্লেয়াদিস), বা সাত বোন, নীল তারার ছোট একটি দল, যাতে বেশিরভাগ মানুষ ছয় বা সাতটি তারা দেখেন। কৃত্তিকা সারা বিশ্বে পরিচিত এবং বহু সংস্কৃতির গল্পে আছে।';

  @override
  String get storyGem =>
      'মিথুন (জেমিনি) চেনা যায় দুটি উজ্জ্বল তারা, ক্যাস্টর ও পোলাক্স দিয়ে, যারা দুই ভাইয়ের মাথার মতো পাশাপাশি দাঁড়িয়ে আছে। পোলাক্স বেশি উজ্জ্বল, তাতে কমলার আভা আছে। ক্যাস্টর আসলে ছয়টি তারার একটি ব্যবস্থা। উত্তরে শীত ও বসন্তের সন্ধ্যায় আকাশে উঁচুতে এদের খুঁজুন।';

  @override
  String get storyLyr =>
      'বীণা (লাইরা) ছোট, কিন্তু এতে আছে অভিজিৎ (ভেগা), উত্তর আকাশের অন্যতম উজ্জ্বল তারা। অভিজিৎ নীলচে-সাদা, আর সিগনাসের ডেনেব ও অ্যাকুইলার আলটাইরের সঙ্গে মিলে গ্রীষ্ম ত্রিভুজ গড়ে। অভিজিতের ঠিক পাশে তারার একটি ছোট সামান্তরিক বীণার দেহ গড়ে।';

  @override
  String get storyCru =>
      'ক্রাক্স, দক্ষিণ ক্রস, সব তারামণ্ডলের মধ্যে সবচেয়ে ছোট, কিন্তু সবচেয়ে বিখ্যাতদের একটি। চারটি উজ্জ্বল তারা একটি ক্রস গড়ে, আর তার লম্বা বাহুর দুটি তারা দক্ষিণ খগোলীয় মেরুর দিকে নির্দেশ করে, তাই এটি ভ্রমণকারীদের দক্ষিণ খুঁজতে সাহায্য করে। পৃথিবীর উত্তর অর্ধের বেশিরভাগ জায়গা থেকে একে দেখা যায় না।';
}
