// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Heliora';

  @override
  String get tagline => 'استكشف المجموعة الشمسية، دون إنترنت بالكامل';

  @override
  String get navExplore => 'استكشاف';

  @override
  String get navCompare => 'مقارنة';

  @override
  String get navWeight => 'الوزن';

  @override
  String get navQuiz => 'اختبار';

  @override
  String get viewMode => 'وضع العرض';

  @override
  String get settings => 'الإعدادات';

  @override
  String get notToScale => 'ليس بمقياس حقيقي · اضغط على كوكب لفتحه';

  @override
  String get dragToRotate => 'اسحب للتدوير · قرّب بإصبعين للتكبير';

  @override
  String get planetsTitle => 'الكواكب';

  @override
  String get planetMercury => 'عطارد';

  @override
  String get planetVenus => 'الزهرة';

  @override
  String get planetEarth => 'الأرض';

  @override
  String get planetMars => 'المريخ';

  @override
  String get planetJupiter => 'المشتري';

  @override
  String get planetSaturn => 'زحل';

  @override
  String get planetUranus => 'أورانوس';

  @override
  String get planetNeptune => 'نبتون';

  @override
  String planetOrder(int n) {
    return 'الكوكب رقم $n من الشمس';
  }

  @override
  String get openDetails => 'فتح التفاصيل';

  @override
  String get diameter => 'القطر';

  @override
  String get gravity => 'الجاذبية';

  @override
  String get avgTemp => 'متوسط درجة الحرارة';

  @override
  String get avgTempShort => 'متوسط الحرارة';

  @override
  String get dayLength => 'اليوم';

  @override
  String get yearLength => 'السنة';

  @override
  String get moons => 'الأقمار المعروفة';

  @override
  String get moonsShort => 'الأقمار';

  @override
  String get distance => 'البعد عن الشمس';

  @override
  String get pressure => 'الضغط على السطح';

  @override
  String get noSurface => 'لا يوجد سطح صلب';

  @override
  String valueKm(String value) {
    return '$value كم';
  }

  @override
  String valueMillionKm(String value) {
    return '$value مليون كم';
  }

  @override
  String valueHours(String value) {
    return '$value ساعة';
  }

  @override
  String valueDays(String value) {
    return '$value يوم';
  }

  @override
  String valueYears(String value) {
    return '$value سنة';
  }

  @override
  String get atmosphere => 'الغلاف الجوي';

  @override
  String get thinAtmosphere =>
      'لا يوجد غلاف جوي تقريبًا. تشكّل هذه الغازات طبقة رقيقة جدًا تُسمّى الإكسوسفير.';

  @override
  String get oxygen => 'الأكسجين';

  @override
  String get oxygenVsEarth => 'الأكسجين مقارنة بالأرض';

  @override
  String get breathable => 'صالح لتنفس البشر';

  @override
  String get notBreathable => 'غير صالح للتنفس، تلزم بدلة فضاء';

  @override
  String weightFeelsLike(String weight) {
    return '$weight كغ على الأرض تعادل هنا';
  }

  @override
  String get gasCo2 => 'ثاني أكسيد الكربون';

  @override
  String get gasN2 => 'النيتروجين';

  @override
  String get gasO2 => 'الأكسجين';

  @override
  String get gasAr => 'الأرغون';

  @override
  String get gasH2 => 'الهيدروجين';

  @override
  String get gasHe => 'الهيليوم';

  @override
  String get gasCh4 => 'الميثان';

  @override
  String get gasNa => 'الصوديوم';

  @override
  String get gasK => 'البوتاسيوم';

  @override
  String get compareTitle => 'مقارنة الكواكب';

  @override
  String get compareHint => 'اختر كوكبين لعرضهما جنبًا إلى جنب.';

  @override
  String get weightTitle => 'وزنك على الكواكب الأخرى';

  @override
  String get weightInput => 'وزنك على الأرض (كغ)';

  @override
  String gravityTimes(String factor) {
    return '$factor× من جاذبية الأرض';
  }

  @override
  String get quizTitle => 'اختبار الكواكب';

  @override
  String get quizIntro =>
      '10 أسئلة عن الكواكب والأقمار. كم إجابة صحيحة ستحصل عليها؟';

  @override
  String get quizStart => 'ابدأ الاختبار';

  @override
  String quizProgress(int current, int total) {
    return 'السؤال $current من $total';
  }

  @override
  String get quizNext => 'التالي';

  @override
  String get quizSeeResult => 'عرض النتيجة';

  @override
  String get quizCorrect => 'صحيح!';

  @override
  String quizWrong(String answer) {
    return 'ليس تمامًا. الإجابة هي $answer.';
  }

  @override
  String quizScore(int score, int total) {
    return 'أجبت $score من $total إجابات صحيحة';
  }

  @override
  String quizBest(int score) {
    return 'أفضل نتيجة: $score';
  }

  @override
  String get quizNewBest => 'أفضل نتيجة جديدة!';

  @override
  String get quizAgain => 'العب مرة أخرى';

  @override
  String get qLargest => 'ما أكبر كوكب؟';

  @override
  String get qSmallest => 'ما أصغر كوكب؟';

  @override
  String get qHottest => 'ما أشد الكواكب حرارة؟';

  @override
  String get qColdest => 'ما أشد الكواكب برودة؟';

  @override
  String get qMostMoons => 'أي كوكب لديه أكبر عدد من الأقمار المعروفة؟';

  @override
  String get qBreathable => 'على أي كوكب يستطيع البشر تنفس الهواء؟';

  @override
  String get qClosest => 'ما أقرب كوكب إلى الشمس؟';

  @override
  String get qFarthest => 'ما أبعد كوكب عن الشمس؟';

  @override
  String get qStrongestGravity => 'أي كوكب لديه أقوى جاذبية؟';

  @override
  String get qShortestDay => 'أي كوكب لديه أقصر يوم؟';

  @override
  String get qLongestDay => 'أي كوكب لديه أطول يوم؟';

  @override
  String get appearance => 'المظهر';

  @override
  String get theme => 'السمة';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get language => 'اللغة';

  @override
  String get appLanguage => 'لغة التطبيق';

  @override
  String get languageNote => '20 لغة · وأسماء الكواكب أيضًا';

  @override
  String get phoneLanguage => 'لغة الهاتف';

  @override
  String get updates => 'التحديثات';

  @override
  String get version => 'الإصدار';

  @override
  String get checkForUpdates => 'البحث عن تحديثات';

  @override
  String get checking => 'جارٍ البحث…';

  @override
  String get autoUpdateCheck => 'ابحث تلقائيًا مرة واحدة يوميًا';

  @override
  String get updateNote =>
      'تأتي التحديثات من GitHub Releases. تبقى إعداداتك على هاتفك.';

  @override
  String get upToDate => 'لديك أحدث إصدار.';

  @override
  String get updateFailed =>
      'تعذّر الوصول إلى GitHub. تحقق من الإنترنت وحاول مرة أخرى.';

  @override
  String get updateAvailable => 'يتوفر تحديث';

  @override
  String updateReady(String version) {
    return 'الإصدار $version جاهز للتنزيل.';
  }

  @override
  String get download => 'تنزيل';

  @override
  String get later => 'لاحقًا';

  @override
  String get about => 'حول';

  @override
  String get sourceCode => 'الشيفرة المصدرية على GitHub';

  @override
  String get privacyLine => 'دون إنترنت · بلا إعلانات · بلا تتبع';

  @override
  String get dataSource => 'المعلومات: NASA Planetary Fact Sheet';

  @override
  String get openFailed => 'تعذّر فتح الرابط.';

  @override
  String get bodySun => 'الشمس';

  @override
  String get bodyMoon => 'القمر';

  @override
  String get bodyPluto => 'بلوتو';

  @override
  String get moonIo => 'آيو';

  @override
  String get moonEuropa => 'يوروبا';

  @override
  String get moonGanymede => 'غانيميد';

  @override
  String get moonCallisto => 'كاليستو';

  @override
  String get moonTitan => 'تيتان';

  @override
  String get moonEnceladus => 'إنسيلادوس';

  @override
  String get moonTriton => 'تريتون';

  @override
  String get kindStar => 'نجمنا، مركز المجموعة الشمسية';

  @override
  String get kindDwarf => 'كوكب قزم';

  @override
  String moonOf(String planet) {
    return 'قمر $planet';
  }

  @override
  String get orbitPeriod => 'دورة واحدة';

  @override
  String distanceFrom(String body) {
    return 'البعد عن $body';
  }

  @override
  String get composition => 'مِمَّ يتكوّن';

  @override
  String get noAtmosphere => 'لا يوجد غلاف جوي حقيقي، إنه شبه فراغ.';

  @override
  String get majorMoons => 'الأقمار الرئيسية';

  @override
  String get lifeTitle => 'هل يستطيع البشر العيش هنا؟';

  @override
  String get lifeScoreShort => 'درجة الحياة';

  @override
  String get lifeNote =>
      'محسوبة من الحرارة وضغط الهواء والأكسجين والماء والسطح والجاذبية. الأرض تحصل على 10.';

  @override
  String get water => 'الماء';

  @override
  String get waterLiquid => 'ماء سائل';

  @override
  String get waterIce => 'جليد';

  @override
  String get waterOcean => 'محيط تحت الجليد';

  @override
  String get waterNone => 'لا يوجد ماء';

  @override
  String get surface => 'السطح';

  @override
  String get solidSurface => 'سطح صلب';

  @override
  String get lifeHome => 'تمامًا مثل الوطن';

  @override
  String get lifeHard => 'صعب جدًا، يلزم مقر مغلق وبدلات فضاء';

  @override
  String get lifeNo => 'مستحيل على البشر';

  @override
  String get downloadInstall => 'تنزيل وتثبيت';

  @override
  String downloadingPercent(String percent) {
    return 'جارٍ التنزيل… $percent%';
  }

  @override
  String get installNow => 'تثبيت';

  @override
  String get allowInstalls =>
      'اسمح لتطبيق Heliora بتثبيت التطبيقات في الشاشة التي فُتحت، ثم ارجع واضغط تثبيت.';

  @override
  String get downloadFailed =>
      'لم يكتمل التنزيل. تحقق من الإنترنت وحاول مرة أخرى.';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get today => 'اليوم';

  @override
  String get play => 'تشغيل';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get monthBack => 'قبل 30 يومًا';

  @override
  String get monthForward => 'بعد 30 يومًا';

  @override
  String get positionsNote =>
      'المواقع الحقيقية في هذا التاريخ · الأحجام والمسافات ليست بمقياس حقيقي · اضغط على كوكب';

  @override
  String get navYou => 'أنت';

  @override
  String get ageTitle => 'عمرك على الكواكب الأخرى';

  @override
  String get setBirthDate => 'أدخل تاريخ ميلادك';

  @override
  String get changeBirthDate => 'تغيير';

  @override
  String nextBirthday(String days) {
    return 'عيد ميلادك القادم بعد $days يوم';
  }

  @override
  String get ageNote => 'يُحفظ تاريخ ميلادك على هذا الهاتف فقط.';

  @override
  String get share => 'مشاركة';

  @override
  String shareText(String planet) {
    return '$planet في Heliora، تطبيق المجموعة الشمسية المجاني دون إنترنت: https://github.com/lumio-apps/heliora';
  }

  @override
  String get shareFailed => 'تعذّرت مشاركة الصورة.';

  @override
  String get travelTitle => 'كم يبعد؟';

  @override
  String get distanceFromEarth => 'البعد عن الأرض اليوم';

  @override
  String get lightTime => 'يستغرق الضوء';

  @override
  String get bySpacecraft => 'بمركبة فضائية بسرعة 60,000 كم/س';

  @override
  String get byCar => 'بسيارة بسرعة 100 كم/س';

  @override
  String valueSeconds(String value) {
    return '$value ث';
  }

  @override
  String valueMinutes(String value) {
    return '$value د';
  }

  @override
  String get sizeTitle => 'الحجم';

  @override
  String sizeTimes(String big, String times, String small) {
    return 'عرض $big يساوي $times× عرض $small.';
  }

  @override
  String sizeSimilar(String a, String b) {
    return '$a و$b بالحجم نفسه تقريبًا.';
  }

  @override
  String get navSky => 'السماء';

  @override
  String get skyTitle => 'سماء الليلة';

  @override
  String get chooseCity => 'اختر مدينتك';

  @override
  String get chooseCityHint =>
      'اختر أقرب مدينة إليك لترى القمر والكواكب الظاهرة الليلة. لا حاجة لإذن الموقع، وتبقى على هاتفك.';

  @override
  String get searchCity => 'ابحث عن مدينة';

  @override
  String get noCityFound => 'لم يتم العثور على مدينة';

  @override
  String get cityNote =>
      'الأوقات بتوقيت هاتفك. يُعدّ الكوكب ظاهرًا إذا ارتفع 5° على الأقل فوق الأفق في سماء مظلمة.';

  @override
  String illuminated(String percent) {
    return '$percent% مضاء';
  }

  @override
  String get moonrise => 'شروق القمر';

  @override
  String get moonset => 'غروب القمر';

  @override
  String get sunset => 'غروب الشمس';

  @override
  String get sunrise => 'شروق الشمس';

  @override
  String get nextFull => 'البدر القادم';

  @override
  String get nextNew => 'المحاق القادم';

  @override
  String get phaseNew => 'محاق';

  @override
  String get phaseWaxingCrescent => 'هلال متزايد';

  @override
  String get phaseFirstQuarter => 'تربيع أول';

  @override
  String get phaseWaxingGibbous => 'أحدب متزايد';

  @override
  String get phaseFull => 'بدر';

  @override
  String get phaseWaningGibbous => 'أحدب متناقص';

  @override
  String get phaseLastQuarter => 'تربيع أخير';

  @override
  String get phaseWaningCrescent => 'هلال متناقص';

  @override
  String get planetsTonight => 'كواكب الليلة';

  @override
  String get statusVisible => 'ظاهر الليلة';

  @override
  String get statusEvening => 'مساءً، بعد الغروب';

  @override
  String get statusMorning => 'صباحًا، قبل الشروق';

  @override
  String get statusNotVisible => 'غير ظاهر الليلة';

  @override
  String bestAt(String time) {
    return 'أفضل وقت $time';
  }

  @override
  String altitudeDir(String direction, String degrees) {
    return '$direction، على ارتفاع $degrees°';
  }

  @override
  String riseSet(String rise, String set) {
    return 'يشرق $rise · يغرب $set';
  }

  @override
  String get needsTelescope => 'يحتاج إلى منظار أو تلسكوب';

  @override
  String get dirN => 'الشمال';

  @override
  String get dirNE => 'الشمال الشرقي';

  @override
  String get dirE => 'الشرق';

  @override
  String get dirSE => 'الجنوب الشرقي';

  @override
  String get dirS => 'الجنوب';

  @override
  String get dirSW => 'الجنوب الغربي';

  @override
  String get dirW => 'الغرب';

  @override
  String get dirNW => 'الشمال الغربي';

  @override
  String get findPlanet => 'ابحث عنه في السماء';

  @override
  String finderTitle(String name) {
    return 'ابحث عن $name';
  }

  @override
  String get pointPhone => 'ارفع هاتفك وحرّكه ببطء.';

  @override
  String turnRight(String degrees) {
    return 'استدر يمينًا $degrees°';
  }

  @override
  String turnLeft(String degrees) {
    return 'استدر يسارًا $degrees°';
  }

  @override
  String tiltUp(String degrees) {
    return 'ارفع الهاتف $degrees°';
  }

  @override
  String tiltDown(String degrees) {
    return 'اخفض الهاتف $degrees°';
  }

  @override
  String onTarget(String name) {
    return '$name هناك تمامًا!';
  }

  @override
  String belowHorizon(String name) {
    return '$name تحت الأفق الآن.';
  }

  @override
  String risesAt(String time) {
    return 'يشرق عند $time.';
  }

  @override
  String get noSensor =>
      'هذا الهاتف لا يحتوي على مستشعر بوصلة، لذلك لا يعمل الباحث.';

  @override
  String get calibrate =>
      'تحتاج البوصلة إلى معايرة: حرّك هاتفك على شكل رقم 8 عدة مرات.';

  @override
  String get phoneNow => 'هاتفك يشير إلى';

  @override
  String get finderNote =>
      'وجّه الجزء الخلفي من الهاتف نحو السماء وأبعده عن المغناطيس والمعادن. لا تنظر إلى الشمس أبدًا.';

  @override
  String get eventsTitle => 'أحداث فلكية';

  @override
  String get eventsSubtitle =>
      'ماذا تراقب في السماء خلال الأشهر الـ 12 القادمة.';

  @override
  String eventsNext(String event, String when) {
    return 'التالي: $event · $when';
  }

  @override
  String get eventFullMoon => 'البدر';

  @override
  String get eventNewMoon => 'المحاق';

  @override
  String eventOpposition(String planet) {
    return '$planet في المقابلة';
  }

  @override
  String eventEveningElongation(String planet) {
    return '$planet: أفضل رؤية مساءً';
  }

  @override
  String eventMorningElongation(String planet) {
    return '$planet: أفضل رؤية صباحًا';
  }

  @override
  String eventConjunction(String a, String b) {
    return '$a و$b يقتربان';
  }

  @override
  String get eventMarchEquinox => 'اعتدال مارس';

  @override
  String get eventJuneSolstice => 'انقلاب يونيو';

  @override
  String get eventSeptemberEquinox => 'اعتدال سبتمبر';

  @override
  String get eventDecemberSolstice => 'انقلاب ديسمبر';

  @override
  String get eventFullMoonDesc =>
      'يكون وجه القمر كله مضاءً، ويشرق قرابة الغروب.';

  @override
  String get eventNewMoonDesc =>
      'القمر مخفي. أكثر سماء مظلمة في الشهر لرؤية النجوم والكواكب.';

  @override
  String eventOppositionDesc(String planet) {
    return '$planet في مقابل الشمس. يبلغ أقصى لمعانه هذا العام ويظهر طوال الليل.';
  }

  @override
  String eventEveningDesc(String planet, String degrees) {
    return '$planet يبعد $degrees° عن الشمس، وهو أقصى بُعد له. انظر قرب الأفق الغربي بعد الغروب.';
  }

  @override
  String eventMorningDesc(String planet, String degrees) {
    return '$planet يبعد $degrees° عن الشمس، وهو أقصى بُعد له. انظر قرب الأفق الشرقي قبل الشروق.';
  }

  @override
  String eventConjunctionDesc(String degrees) {
    return 'يمران على بعد $degrees° فقط في السماء.';
  }

  @override
  String get eventEquinoxDesc =>
      'يتساوى الليل والنهار تقريبًا في كل مكان على الأرض.';

  @override
  String get eventJuneSolsticeDesc =>
      'أطول نهار في الشمال وأقصر نهار في الجنوب.';

  @override
  String get eventDecemberSolsticeDesc =>
      'أقصر نهار في الشمال وأطول نهار في الجنوب.';

  @override
  String eventMeteorShower(String shower) {
    return 'زخة شهب $shower';
  }

  @override
  String eventMeteorDesc(String rate, String percent) {
    return 'حتى نحو $rate شهابًا في الساعة تحت سماء مظلمة. سيكون القمر مضاءً بنسبة $percent%.';
  }

  @override
  String get showerQuadrantids => 'الرباعيات';

  @override
  String get showerLyrids => 'القيثارات';

  @override
  String get showerEtaAquariids => 'إيتا الدلويات';

  @override
  String get showerPerseids => 'البرشاويات';

  @override
  String get showerOrionids => 'الجباريات';

  @override
  String get showerLeonids => 'الأسديات';

  @override
  String get showerGeminids => 'التوأميات';

  @override
  String get showerUrsids => 'الدبيات الصغرى';

  @override
  String get eventToday => 'اليوم';

  @override
  String get eventTomorrow => 'غدًا';

  @override
  String eventInDays(String days) {
    return 'بعد $days أيام';
  }

  @override
  String get eventsNote =>
      'تُحسب التواريخ على هاتفك وتُعرض بتوقيته. ذروات زخات الشهب تواريخ سنوية معتادة وقد تتغير بيوم. تبقى التذكيرات على هاتفك.';

  @override
  String get remindMe => 'ذكّرني';

  @override
  String reminderSet(String date) {
    return 'حسنًا، سأذكّرك في $date.';
  }

  @override
  String get reminderOff => 'تمت إزالة التذكير.';

  @override
  String get reminderTooLate => 'هذا الحدث قريب جدًا لضبط تذكير.';

  @override
  String get notificationsOff =>
      'إشعارات Heliora متوقفة. فعّلها من إعدادات Android.';

  @override
  String get reminderTomorrow => 'غدًا';

  @override
  String get reminderToday => 'يحدث اليوم';

  @override
  String get onlineTitle => 'الميزات عبر الإنترنت';

  @override
  String get onlineSubtitle =>
      'عرض محطة الفضاء وعمليات إطلاق الصواريخ. عندها يتصل Heliora فقط بـ wheretheiss.at وCelestrak وLaunch Library 2، ويمكنها رؤية عنوان الإنترنت لهاتفك. لا يُرسل شيء آخر. متوقفة افتراضيًا.';

  @override
  String get turnOnOnline => 'تفعيل الميزات عبر الإنترنت';

  @override
  String get issTitle => 'محطة الفضاء';

  @override
  String get issCardHint => 'أين هي الآن ومتى تمر فوقك';

  @override
  String get issNeedsOnline =>
      'لعرض المحطة يحتاج Heliora إلى بيانات مدارها من الإنترنت. تُنزَّل مرة واحدة ثم تعمل دون اتصال لأيام.';

  @override
  String get issLoading => 'جارٍ جلب بيانات المدار…';

  @override
  String get issFailed =>
      'تعذر الحصول على بيانات المدار. تحقق من الإنترنت وحاول مجددًا.';

  @override
  String issStale(String days) {
    return 'بيانات المدار عمرها $days أيام، لذا قد تكون المواقع غير دقيقة. اتصل بالإنترنت لتحديثها.';
  }

  @override
  String get issHeight => 'الارتفاع';

  @override
  String get issSpeed => 'السرعة';

  @override
  String get issFromYou => 'المسافة منك';

  @override
  String valueKmh(String value) {
    return '$value كم/س';
  }

  @override
  String issAboveHorizon(String direction, String degrees) {
    return 'فوق أفقك الآن! انظر نحو $direction، بارتفاع $degrees°.';
  }

  @override
  String get issBelowHorizon => 'تحت أفقك الآن.';

  @override
  String issPassesTitle(String city) {
    return 'العبورات القادمة فوق $city';
  }

  @override
  String get issNoPasses => 'لا توجد عبورات جيدة في الأيام الخمسة القادمة.';

  @override
  String issMaxHigh(String degrees) {
    return 'حتى $degrees° ارتفاعًا';
  }

  @override
  String issFromTo(String start, String end) {
    return 'من $start إلى $end';
  }

  @override
  String get issVisible => 'سهلة الرؤية';

  @override
  String get issHidden => 'صعبة الرؤية';

  @override
  String get issPassTitle => 'محطة الفضاء تمر فوقك';

  @override
  String issPassBody(String degrees, String direction) {
    return 'تشرق بعد 10 دقائق، بارتفاع حتى $degrees°. انظر نحو $direction.';
  }

  @override
  String get issNote =>
      'تُحسب المواقع على هاتفك من بيانات مدار المحطة. يسهل رؤية العبور عندما تكون السماء مظلمة وتضيء الشمس المحطة: تبدو كنجمة ساطعة سريعة.';

  @override
  String get launchesNeedOnline =>
      'فعّل الميزات عبر الإنترنت لرؤية عمليات إطلاق الصواريخ القادمة هنا.';

  @override
  String get launchesFailed =>
      'تعذر تحديث قائمة الإطلاق. تُعرض القائمة المحفوظة.';

  @override
  String get launchesNote =>
      'تأتي أوقات الإطلاق من Launch Library 2 وتتغير كثيرًا. الأسماء والأماكن بالإنجليزية.';

  @override
  String get launchReminderBody => 'ينطلق خلال نحو ساعة. قد تتغير الأوقات.';

  @override
  String get launchTimeTbd => 'الوقت لم يُحدد بعد';

  @override
  String get quizChoose => 'اختر المستوى';

  @override
  String get levelEasy => 'سهل';

  @override
  String get levelMedium => 'متوسط';

  @override
  String get levelHard => 'صعب';

  @override
  String get levelEasyHint => 'أساسيات الكواكب';

  @override
  String get levelMediumHint => 'الكواكب والأقمار';

  @override
  String get levelHardHint => 'مقارنات وترتيبات صعبة';

  @override
  String get qStar => 'أيٌّ من هذه نجم وليس كوكبًا؟';

  @override
  String get qDwarf => 'أيٌّ من هذه كوكب قزم؟';

  @override
  String get qMoonVisited => 'على أي قمر مشى البشر؟';

  @override
  String get qLargestMoon => 'أي هذه الأقمار هو الأكبر؟';

  @override
  String get qSmallestMoon => 'أي هذه الأقمار هو الأصغر؟';

  @override
  String get qThickAirMoon => 'أي هذه الأقمار له غلاف جوي كثيف؟';

  @override
  String get qGeyserMoon => 'أي قمر يقذف نوافير من الماء إلى الفضاء؟';

  @override
  String get qVolcanicMoon => 'أي قمر فيه أكثر البراكين نشاطًا؟';

  @override
  String get qBackwardsMoon => 'أي قمر يدور حول كوكبه بالاتجاه المعاكس؟';

  @override
  String get qBiggestRocky => 'ما أكبر الكواكب الصخرية الأربعة؟';

  @override
  String get qColdestRocky => 'ما أبرد الكواكب الصخرية الأربعة؟';

  @override
  String get qHighestPressure => 'أي كوكب له أعلى ضغط هواء عند سطحه؟';

  @override
  String get qSecondLargest => 'أي كوكب هو ثاني أكبر الكواكب؟';

  @override
  String get qLongestYear => 'أي كوكب له أطول سنة؟';

  @override
  String get qShortestYear => 'أي كوكب له أقصر سنة؟';

  @override
  String get qSmallestGiant => 'ما أصغر الكواكب العملاقة الأربعة؟';

  @override
  String get qRockyLongestYear => 'أي الكواكب الصخرية الأربعة له أطول سنة؟';

  @override
  String get qFastestMoon => 'أي هذه الأقمار يدور حول كوكبه بأسرع ما يكون؟';

  @override
  String get qSlowestMoon =>
      'أي هذه الأقمار يستغرق أطول وقت للدوران حول كوكبه؟';

  @override
  String get qStrongestMoonGravity => 'أي هذه الأقمار له أقوى جاذبية؟';

  @override
  String get qColdestMoon => 'أي هذه الأقمار هو الأبرد؟';

  @override
  String get qSecondLargestMoon => 'أي هذه الأقمار هو ثاني أكبرها؟';

  @override
  String get factTitle => 'هل تعلم؟';

  @override
  String get factTap => 'اضغط لمعلومة أخرى';

  @override
  String get factSun1 => 'تحتوي الشمس على 99.8% من كتلة المجموعة الشمسية كلها.';

  @override
  String get factSun2 =>
      'يستغرق ضوء الشمس نحو 8 دقائق و20 ثانية ليصل إلى الأرض.';

  @override
  String get factMercury1 =>
      'اليوم على عطارد، من شروق الشمس إلى الشروق التالي، يستمر نحو 176 يومًا أرضيًا. وهذا ضعف طول سنته.';

  @override
  String get factMercury2 =>
      'لا هواء تقريبًا على عطارد، لذا تبقى سماؤه سوداء حتى في النهار، وتكون لياليه شديدة البرودة.';

  @override
  String get factVenus1 =>
      'تدور الزهرة بالاتجاه المعاكس، لذلك تشرق الشمس هناك من الغرب.';

  @override
  String get factVenus2 =>
      'الزهرة أسخن من عطارد رغم أنها أبعد عن الشمس، لأن هواءها الكثيف يحبس الحرارة.';

  @override
  String get factEarth1 =>
      'الأرض هي المكان الوحيد الذي نعرف فيه الحياة، ونحو 71% من سطحها مغطى بالماء.';

  @override
  String get factEarth2 =>
      'الأرض ليست كرة مثالية. فهي منتفخة قليلًا عند خط الاستواء بسبب دورانها.';

  @override
  String get factMars1 =>
      'أوليمبوس مونس على المريخ هو أعلى بركان في المجموعة الشمسية، ويبلغ ارتفاعه نحو مرتين ونصف ارتفاع جبل إيفرست.';

  @override
  String get factMars2 => 'غروب الشمس على المريخ يبدو أزرق.';

  @override
  String get factJupiter1 =>
      'كتلة المشتري أكثر من ضعف كتلة جميع الكواكب الأخرى مجتمعة.';

  @override
  String get factJupiter2 =>
      'البقعة الحمراء العظيمة عاصفة أكبر من الأرض، ويراقبها الناس منذ أكثر من 150 عامًا.';

  @override
  String get factSaturn1 =>
      'زحل خفيف جدًا بالنسبة لحجمه حتى إنه سيطفو على الماء، لو وجدنا حوض استحمام يكفيه.';

  @override
  String get factSaturn2 =>
      'حلقات زحل عريضة جدًا لكنها رقيقة جدًا: سمكها في بعض المواضع نحو عشرة أمتار فقط.';

  @override
  String get factUranus1 =>
      'يدور أورانوس حول الشمس وهو مائل على جنبه، بميل نحو 98 درجة.';

  @override
  String get factUranus2 =>
      'كان أورانوس أول كوكب يُكتشف بالتلسكوب. رصده ويليام هيرشل عام 1781.';

  @override
  String get factNeptune1 =>
      'في نبتون أسرع رياح بين الكواكب، أكثر من 2000 كم/س.';

  @override
  String get factNeptune2 =>
      'اكتُشف نبتون بالحساب قبل أن يراه أحد: ففي عام 1846 حسب علماء الفلك أين يجب أن يكون.';

  @override
  String get factMoon1 => 'يبتعد القمر عن الأرض نحو 3.8 سنتيمتر كل عام.';

  @override
  String get factMoon2 =>
      'نرى دائمًا الوجه نفسه من القمر، لأنه يدور حول نفسه مرة واحدة بالضبط مع كل دورة حول الأرض.';

  @override
  String get factPluto1 => 'السنة على بلوتو تعادل نحو 248 سنة أرضية.';

  @override
  String get factPluto2 =>
      'على بلوتو سهل ضخم على شكل قلب من النيتروجين المتجمد.';

  @override
  String get factIo1 =>
      'آيو هو أكثر العوالم التي نعرفها نشاطًا بركانيًا، وفيه مئات البراكين النشطة.';

  @override
  String get factIo2 =>
      'تضغط جاذبية المشتري على آيو وتشدّه، والحرارة الناتجة عن ذلك تغذي براكينه.';

  @override
  String get factEuropa1 =>
      'تحت قشرتها الجليدية، تحتوي يوروبا على الأرجح على ضعف ماء محيطات الأرض كلها تقريبًا.';

  @override
  String get factEuropa2 =>
      'يوروبا من أفضل الأماكن للبحث عن حياة خارج الأرض. والمركبة «يوروبا كليبر» في طريقها إليها.';

  @override
  String get factGanymede1 =>
      'غانيميد هو أكبر قمر في المجموعة الشمسية. بل إنه أكبر من عطارد.';

  @override
  String get factGanymede2 =>
      'غانيميد هو القمر الوحيد المعروف بأن له مجالًا مغناطيسيًا خاصًا به.';

  @override
  String get factCallisto1 =>
      'كاليستو من أكثر الأماكن حفرًا في المجموعة الشمسية، وسطحه قديم جدًا.';

  @override
  String get factCallisto2 =>
      'كاليستو بعيد عن المشتري بما يكفي ليتعرض لإشعاعه القاسي بدرجة أقل، لذلك اقترحه العلماء لقاعدة مستقبلية.';

  @override
  String get factTitan1 =>
      'تيتان هو القمر الوحيد ذو الغلاف الجوي الكثيف. وضغط هوائه عند السطح أعلى منه على الأرض.';

  @override
  String get factTitan2 =>
      'في تيتان أنهار وبحيرات، لكنها تحتوي على الميثان والإيثان السائلين لا على الماء.';

  @override
  String get factEnceladus1 =>
      'يقذف إنسيلادوس نفاثات من الجليد وبخار الماء إلى الفضاء عبر شقوق قرب قطبه الجنوبي.';

  @override
  String get factEnceladus2 => 'نفاثات إنسيلادوس تغذي حلقة E لزحل.';

  @override
  String get factTriton1 =>
      'يدور تريتون حول نبتون بالاتجاه المعاكس، لذلك ربما كان كوكبًا قزمًا أسره نبتون.';

  @override
  String get factTriton2 =>
      'عند نحو −235 °م، يُعدّ تريتون من أبرد الأماكن التي قيست حرارتها في المجموعة الشمسية.';

  @override
  String get jumpInput => 'ارتفاع قفزتك على الأرض (سم)';

  @override
  String jumpHigh(String height) {
    return 'القفزة: $height';
  }

  @override
  String jumpFeelsLike(String height) {
    return 'قفزة $height على الأرض تصبح';
  }

  @override
  String get jumpNote =>
      'الدفعة نفسها كما على الأرض. لا توجد أرض تقف عليها فوق الشمس والكواكب الغازية العملاقة، لذا هذه مجرد لعبة تخيّل.';

  @override
  String valueCm(String value) {
    return '$value سم';
  }

  @override
  String valueM(String value) {
    return '$value م';
  }

  @override
  String get eclipseTotalLunar => 'خسوف كلي للقمر';

  @override
  String get eclipsePartialLunar => 'خسوف جزئي للقمر';

  @override
  String get eclipsePenumbralLunar => 'خسوف شبه ظلي للقمر';

  @override
  String get eclipseTotalSolar => 'كسوف كلي للشمس';

  @override
  String get eclipseAnnularSolar => 'كسوف حلقي للشمس';

  @override
  String get eclipseHybridSolar => 'كسوف هجين للشمس';

  @override
  String get eclipsePartialSolar => 'كسوف جزئي للشمس';

  @override
  String get eclipseTotalLunarDesc =>
      'يدخل القمر بالكامل في ظل الأرض وكثيرًا ما يصبح أحمر خافتًا. يراه كل من هو في الجانب الليلي من الأرض، والنظر إليه بالعين المجردة آمن.';

  @override
  String eclipsePartialLunarDesc(String percent) {
    return 'يدخل جزء من القمر ($percent% من عرضه) في ظل الأرض المظلم. النظر إليه بالعين المجردة آمن.';
  }

  @override
  String get eclipsePenumbralLunarDesc =>
      'يمر القمر في ظل الأرض الخارجي الخافت. يخفت قليلًا فقط، لذلك يصعب ملاحظته.';

  @override
  String get eclipseTotalSolarDesc =>
      'يغطي القمر الشمس تمامًا على امتداد مسار ضيق فوق الأرض. خارج هذا المسار ترى كسوفًا جزئيًا.';

  @override
  String get eclipseAnnularSolarDesc =>
      'يكون القمر أبعد قليلًا من أن يغطي الشمس كاملة، فتبقى حلقة مضيئة. تظهر الحلقة على امتداد مسار ضيق، وخارجه يكون الكسوف جزئيًا.';

  @override
  String get eclipseHybridSolarDesc =>
      'على امتداد مساره يكون هذا الكسوف كليًا في بعض الأماكن وحلقيًا في أخرى. وخارج المسار يكون جزئيًا.';

  @override
  String get eclipsePartialSolarDesc =>
      'يغطي القمر جزءًا من الشمس فقط، ولا تُغطّى الشمس بالكامل في أي مكان على الأرض.';

  @override
  String get eclipseNoCity =>
      'اختر مدينة في Heliora لتعرف إن كان بإمكانك مشاهدته من هناك.';

  @override
  String eclipseLunarUp(String city) {
    return 'في منتصف الخسوف يكون القمر فوق الأفق في $city.';
  }

  @override
  String eclipseLunarPartly(String city) {
    return 'في $city يكون القمر فوق الأفق خلال جزء فقط من الخسوف.';
  }

  @override
  String eclipseLunarDown(String city) {
    return 'في $city يبقى القمر تحت الأفق، لذلك لا يمكن رؤيته من هناك.';
  }

  @override
  String eclipseSolarNone(String city) {
    return 'لا يُرى من $city: ظل القمر لا يصلها، أو الشمس تحت الأفق.';
  }

  @override
  String eclipseSolarSlight(String city) {
    return 'من $city على الأكثر كسوف جزئي طفيف جدًا يصعب ملاحظته.';
  }

  @override
  String eclipseSolarPartial(String city, String percent) {
    return 'تقدير تقريبي لـ $city: يغطي القمر نحو $percent% من عرض الشمس في أقصى حالاته.';
  }

  @override
  String eclipseSolarNear(String city) {
    return '$city قريبة من المسار الذي تُغطّى فيه الشمس تقريبًا أو كليًا. راجع خريطة الكسوف؛ هذا التقدير تقريبي.';
  }

  @override
  String get eclipseSolarSafety =>
      'لا تنظر إلى الشمس أبدًا من دون نظارات كسوف مناسبة.';

  @override
  String get alertsTitle => 'التنبيهات';

  @override
  String get tonightAlertSwitch => 'سماء الليلة، كل مساء';

  @override
  String get tonightAlertTime => 'الوقت';

  @override
  String get tonightAlertNote =>
      'ملاحظة قصيرة عن القمر والكواكب التي يمكنك رؤيتها، في الوقت الذي تختاره. تُحسب على هاتفك دون إنترنت. يسمح Android لـ Heliora بتجهيز ملاحظات نحو أسبوعين مسبقًا فقط، لذلك افتح التطبيق من حين لآخر.';

  @override
  String get tonightNotifTitle => 'سماء الليلة';

  @override
  String tonightMoon(String phase, String percent) {
    return 'القمر: $phase، $percent% مضاء.';
  }

  @override
  String tonightPlanets(String planets) {
    return 'ابحث عن: $planets.';
  }

  @override
  String get tonightNoPlanets => 'لا توجد كواكب ساطعة في سماء المساء.';

  @override
  String get tonightNoCity => 'اختر مدينة في Heliora لرؤية الكواكب.';

  @override
  String get birthdayTitle => 'سماء عيد ميلادي';

  @override
  String get birthdaySubtitle =>
      'القمر والكواكب في يوم ولادتك، وأيام حياتك الكبيرة.';

  @override
  String get birthdayCardHint => 'طور القمر والكواكب والمحطات المهمة';

  @override
  String get birthdayNeedDate => 'أدخل تاريخ ميلادك';

  @override
  String get birthdayMoon => 'القمر في يوم ميلادك';

  @override
  String get birthdayPlanets => 'الكواكب في ذلك اليوم';

  @override
  String birthdayDaysOld(String count) {
    return 'عمرك اليوم $count يومًا.';
  }

  @override
  String get birthdayMilestones => 'محطات مهمة';

  @override
  String birthdayDayN(String count) {
    return 'اليوم $count';
  }

  @override
  String get birthdayBillion => 'مليار ثانية من العمر';

  @override
  String get birthdayPassed => 'تم';

  @override
  String get birthdayNote =>
      'تُحسب على هاتفك من المدارات نفسها المستخدمة في باقي Heliora. تاريخ ميلادك لا يغادر هاتفك أبدًا.';

  @override
  String get missionsTitle => 'المهمات الفضائية';

  @override
  String get missionsSubtitle =>
      'لحظات مشهورة في استكشاف الفضاء، الأقدم أولًا.';

  @override
  String get missionsCardHint => 'مهمات مشهورة عبر الزمن';

  @override
  String get missionSputnik1 =>
      'أول قمر صناعي. دارت هذه الكرة المعدنية، بحجم كرة شاطئ تقريبًا، حول الأرض نحو ثلاثة أشهر. كان يُسمع صفيرها في أجهزة الراديو، وبها بدأ عصر الفضاء.';

  @override
  String get missionVostok1 =>
      'أصبح يوري غاغارين أول إنسان في الفضاء. دار حول الأرض مرة واحدة في نحو 108 دقائق.';

  @override
  String get missionApollo11 =>
      'هبط نيل أرمسترونغ وباز ألدرين في بحر الهدوء وأصبحا أول من مشى على القمر. وانتظرهما مايكل كولينز في المدار.';

  @override
  String get missionVenera7 =>
      'أول مركبة تهبط على كوكب آخر وترسل إشارة. أرسلت بيانات من الزهرة لنحو 23 دقيقة في حرارة ساحقة.';

  @override
  String get missionViking1 =>
      'هبطت على المريخ وعملت هناك أكثر من ست سنوات، وأرسلت أول سلسلة طويلة من الصور وتقارير الطقس من سطح كوكب آخر.';

  @override
  String get missionVoyager1 =>
      'أُطلقت عام 1977، ومرت قرب المشتري وزحل ودخلت الفضاء بين النجوم عام 2012. وهي أبعد جسم صنعه الإنسان عن الأرض.';

  @override
  String get missionHubble =>
      'أُطلق عام 1990، وينظر إلى الكون من فوق هواء الأرض. ساعدت صوره الحادة في قياس عمر الكون وكشفت آلاف المجرات البعيدة.';

  @override
  String get missionHuygens =>
      'هبط المسبار هيغنز، الذي حملته كاسيني، بالمظلة على قمر زحل تيتان. كان أول هبوط في المجموعة الشمسية الخارجية، وأرسل صورًا من السطح.';

  @override
  String get missionCuriosity =>
      'هبطت هذه المركبة الجوالة بحجم سيارة في فوهة غيل بمساعدة «رافعة سماوية» تعمل بالصواريخ. واكتشفت أن المريخ كان يومًا ما يملك ظروفًا مناسبة للحياة.';

  @override
  String get missionMangalyaan =>
      'وصلت مهمة المدار المريخي الهندية إلى مدار المريخ من أول محاولة، وهذا أول إنجاز من نوعه لأي دولة، وبتكلفة منخفضة جدًا.';

  @override
  String get missionRosetta =>
      'حطّ الهابط فيلة التابع لروزيتا على المذنب 67P/تشوريوموف–غيراسيمنكو، وهو أول هبوط على مذنب. ودار روزيتا نفسه حول المذنب لمدة عامين.';

  @override
  String get missionNewhorizons =>
      'بعد رحلة دامت تسع سنوات مرّ بجانب بلوتو، وأرانا لأول مرة جبالًا جليدية وسهلًا ضخمًا على شكل قلب.';

  @override
  String get missionPerseverance =>
      'هبطت المركبة بيرسيفيرانس في فوهة جيزيرو للبحث عن آثار حياة قديمة وجمع عينات من الصخور. وقامت مروحيتها إنجينيويتي بأول طيران مُتحكَّم به على كوكب آخر.';

  @override
  String get missionJwst =>
      'أكبر تلسكوب فضائي، مرآته الذهبية بعرض 6.5 أمتار، ويراقب السماء بالضوء تحت الأحمر من مسافة 1.5 مليون كم. يرى بعضًا من أولى المجرات.';

  @override
  String get missionChandrayaan3 =>
      'أصبحت الهند الدولة الرابعة التي تهبط بسلام على القمر، والأولى قرب قطبه الجنوبي. وحمل الهابط فيكرام المركبة الجوالة براغيان.';

  @override
  String get spacecraftTitle => 'المركبات الفضائية الآن';

  @override
  String get spacecraftSubtitle =>
      'كم تبعد بعض المركبات الفضائية المشهورة عن الأرض في هذه اللحظة.';

  @override
  String get spacecraftCardHint => 'فويجر وJWST ومركبات المريخ وغيرها';

  @override
  String get spacecraftDistance => 'البعد عن الأرض';

  @override
  String get spacecraftAltitude => 'الارتفاع عن الأرض';

  @override
  String get spacecraftInAu => 'بالوحدة الفلكية';

  @override
  String get spacecraftSpeed => 'السرعة';

  @override
  String get spacecraftSignal => 'تستغرق الإشارة اللاسلكية';

  @override
  String get spacecraftNote =>
      'المسافات تقديرية. بالنسبة للمسابر البعيدة تُحسب من متوسط السرعة وقد تخطئ بنحو 1% لأن الأرض تدور حول الشمس. أما مسافة المريخ فمحسوبة لليوم. الوحدة الفلكية (AU) هي المسافة من الأرض إلى الشمس.';

  @override
  String valueBillionKm(String value) {
    return '$value مليار كم';
  }

  @override
  String valueAu(String value) {
    return '$value وحدة فلكية';
  }

  @override
  String valueKmS(String value) {
    return '$value كم/ث';
  }

  @override
  String get spacecraftVoyager1 =>
      'أُطلقت عام 1977. وفي عام 2012 صارت أول مركبة تدخل الفضاء بين النجوم. تصل إشارتها اللاسلكية إلينا وقد مرّ عليها نحو يوم.';

  @override
  String get spacecraftVoyager2 =>
      'أُطلقت عام 1977. وهي المركبة الوحيدة التي زارت أورانوس ونبتون، ودخلت الفضاء بين النجوم عام 2018.';

  @override
  String get spacecraftNewHorizons =>
      'مرّت قرب بلوتو عام 2015 وقرب جرم حزام كايبر أروكوث عام 2019. ما زالت تتجه إلى الخارج وما زالت ترسل البيانات.';

  @override
  String get spacecraftJwst =>
      'أكبر تلسكوب فضائي، أُطلق عام 2021. يقع قرب نقطة تسمى L2 على بعد نحو 1.5 مليون كم من الأرض، ودرعه الواقي يواجه الشمس دائمًا.';

  @override
  String get spacecraftIss =>
      'تدور حول الأرض مرة كل 90 دقيقة تقريبًا. ويعيش على متنها أشخاص دون انقطاع منذ عام 2000.';

  @override
  String get spacecraftHubble =>
      'أُطلق عام 1990 وما زال يعمل. يدور حول الأرض فوق الهواء الذي يشوّش الصور، لذلك تأتي صوره شديدة الوضوح.';

  @override
  String get spacecraftMarsRovers =>
      'كيوريوسيتي (هبطت عام 2012) وبيرسيفيرنس (هبطت عام 2021) تتجولان على المريخ. تتغير المسافة إلى المريخ من نحو 55 مليون كم إلى أكثر من 400 مليون كم.';

  @override
  String get searchTooltip => 'بحث';

  @override
  String get searchHint => 'ابحث عن كوكب أو قمر أو مهمة…';

  @override
  String get searchClear => 'مسح';

  @override
  String searchEmpty(String query) {
    return 'لا نتائج لـ “$query”.';
  }

  @override
  String get searchBodies => 'الكواكب والأقمار';

  @override
  String get searchMissions => 'المهمات';

  @override
  String get searchSpacecraft => 'المركبات الفضائية';

  @override
  String get favoritesTitle => 'المفضلة';

  @override
  String get favoritesEmpty =>
      'اضغط على النجمة في كوكب أو مهمة أو مركبة ليبقى هنا.';

  @override
  String get favoriteAdd => 'أضف إلى المفضلة';

  @override
  String get favoriteRemove => 'أزل من المفضلة';

  @override
  String get textSize => 'حجم النص';

  @override
  String get textSizeNormal => 'عادي';

  @override
  String get textSizeLarge => 'كبير';

  @override
  String get textSizeLarger => 'أكبر';

  @override
  String get textSizeNote =>
      'يكبّر النص في Heliora. ولا يصغر أبدًا عن حجم النص الخاص بهاتفك.';

  @override
  String get skyOtherNight => 'سماء الليل';

  @override
  String get planetsThatNight => 'كواكب تلك الليلة';

  @override
  String get previousDay => 'اليوم السابق';

  @override
  String get nextDay => 'اليوم التالي';

  @override
  String get pickDate => 'اختر تاريخًا';

  @override
  String get backToTonight => 'العودة إلى الليلة';

  @override
  String get moonCalendar => 'تقويم القمر';

  @override
  String get moonCalendarHint => 'طور القمر في كل يوم';

  @override
  String get previousMonth => 'الشهر السابق';

  @override
  String get nextMonth => 'الشهر التالي';

  @override
  String get keyMoonDates => 'أطوار هذا الشهر الرئيسية';

  @override
  String get moonCalendarNote =>
      'تُعرض تواريخ الأطوار وأوقاتها بالمنطقة الزمنية لهاتفك، وهي دقيقة خلال ساعة تقريبًا.';

  @override
  String get seeSkyThatDay => 'شاهد سماء هذا اليوم';

  @override
  String get sunLightTitle => 'الشمس والضوء';

  @override
  String get firstLight => 'أول ضوء';

  @override
  String get goldenMorningEnds => 'انتهاء الساعة الذهبية صباحًا';

  @override
  String get solarNoon => 'الشمس في أعلى نقطة';

  @override
  String get goldenEveningStarts => 'بدء الساعة الذهبية مساءً';

  @override
  String get lastLight => 'آخر ضوء';

  @override
  String get darkSky => 'سماء مظلمة تمامًا';

  @override
  String get sunDayLength => 'طول النهار';

  @override
  String durationHm(String hours, String minutes) {
    return '$hours س $minutes د';
  }

  @override
  String get sunNote =>
      'الساعة الذهبية هي عندما تكون الشمس على ارتفاع أقل من 6° فوق الأفق. أول ضوء وآخر ضوء عندما تكون 6° تحته، وتصبح السماء مظلمة تمامًا عندما تكون 18° تحته. الأوقات محسوبة للتاريخ الذي تختاره.';

  @override
  String get sunStaysUp => 'في هذا اليوم لا تغيب الشمس.';

  @override
  String get sunStaysDown => 'في هذا اليوم لا تشرق الشمس.';
}
