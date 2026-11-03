// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'Heliora';

  @override
  String get tagline => 'सूर्यमालेची सफर, पूर्णपणे ऑफलाइन';

  @override
  String get navExplore => 'शोधा';

  @override
  String get navCompare => 'तुलना';

  @override
  String get navWeight => 'वजन';

  @override
  String get navQuiz => 'प्रश्नमंजुषा';

  @override
  String get viewMode => 'दृश्य मोड';

  @override
  String get settings => 'सेटिंग्ज';

  @override
  String get notToScale => 'प्रमाणात नाही · उघडण्यासाठी ग्रहावर टॅप करा';

  @override
  String get dragToRotate => 'फिरवण्यासाठी ओढा · झूमसाठी पिंच करा';

  @override
  String get planetsTitle => 'ग्रह';

  @override
  String get planetMercury => 'बुध';

  @override
  String get planetVenus => 'शुक्र';

  @override
  String get planetEarth => 'पृथ्वी';

  @override
  String get planetMars => 'मंगळ';

  @override
  String get planetJupiter => 'गुरू';

  @override
  String get planetSaturn => 'शनी';

  @override
  String get planetUranus => 'युरेनस';

  @override
  String get planetNeptune => 'नेपच्यून';

  @override
  String planetOrder(int n) {
    return 'सूर्यापासून ग्रह क्रमांक $n';
  }

  @override
  String get openDetails => 'तपशील उघडा';

  @override
  String get diameter => 'व्यास';

  @override
  String get gravity => 'गुरुत्वाकर्षण';

  @override
  String get avgTemp => 'सरासरी तापमान';

  @override
  String get avgTempShort => 'सरासरी तापमान';

  @override
  String get dayLength => 'दिवस';

  @override
  String get yearLength => 'वर्ष';

  @override
  String get moons => 'ज्ञात चंद्र';

  @override
  String get moonsShort => 'चंद्र';

  @override
  String get distance => 'सूर्यापासून अंतर';

  @override
  String get pressure => 'पृष्ठभागावरील दाब';

  @override
  String get noSurface => 'घन पृष्ठभाग नाही';

  @override
  String valueKm(String value) {
    return '$value किमी';
  }

  @override
  String valueMillionKm(String value) {
    return '$value दशलक्ष किमी';
  }

  @override
  String valueHours(String value) {
    return '$value तास';
  }

  @override
  String valueDays(String value) {
    return '$value दिवस';
  }

  @override
  String valueYears(String value) {
    return '$value वर्षे';
  }

  @override
  String get atmosphere => 'वातावरण';

  @override
  String get thinAtmosphere =>
      'जवळजवळ वातावरण नाही. हे वायू एक्सोस्फियर नावाचा अतिशय पातळ थर बनवतात.';

  @override
  String get oxygen => 'ऑक्सिजन';

  @override
  String get oxygenVsEarth => 'ऑक्सिजन: पृथ्वीशी तुलना';

  @override
  String get breathable => 'माणसांना श्वास घेण्यायोग्य';

  @override
  String get notBreathable => 'श्वास घेण्यायोग्य नाही, स्पेससूट लागेल';

  @override
  String weightFeelsLike(String weight) {
    return 'पृथ्वीवरचे $weight किलो इथे इतके वाटतील';
  }

  @override
  String get gasCo2 => 'कार्बन डायऑक्साइड';

  @override
  String get gasN2 => 'नायट्रोजन';

  @override
  String get gasO2 => 'ऑक्सिजन';

  @override
  String get gasAr => 'आर्गॉन';

  @override
  String get gasH2 => 'हायड्रोजन';

  @override
  String get gasHe => 'हीलियम';

  @override
  String get gasCh4 => 'मिथेन';

  @override
  String get gasNa => 'सोडियम';

  @override
  String get gasK => 'पोटॅशियम';

  @override
  String get compareTitle => 'ग्रहांची तुलना';

  @override
  String get compareHint => 'शेजारी शेजारी पाहण्यासाठी दोन ग्रह निवडा.';

  @override
  String get weightTitle => 'इतर ग्रहांवर तुमचे वजन';

  @override
  String get weightInput => 'पृथ्वीवर तुमचे वजन (किलो)';

  @override
  String gravityTimes(String factor) {
    return 'पृथ्वीच्या गुरुत्वाच्या $factor×';
  }

  @override
  String get quizTitle => 'ग्रह प्रश्नमंजुषा';

  @override
  String get quizIntro =>
      'ग्रह आणि चंद्रांबद्दल 10 प्रश्न. तुम्ही किती बरोबर देऊ शकता?';

  @override
  String get quizStart => 'प्रश्नमंजुषा सुरू करा';

  @override
  String quizProgress(int current, int total) {
    return 'प्रश्न $current / $total';
  }

  @override
  String get quizNext => 'पुढे';

  @override
  String get quizSeeResult => 'निकाल पहा';

  @override
  String get quizCorrect => 'बरोबर!';

  @override
  String quizWrong(String answer) {
    return 'नाही. बरोबर उत्तर $answer आहे.';
  }

  @override
  String quizScore(int score, int total) {
    return '$total पैकी $score बरोबर';
  }

  @override
  String quizBest(int score) {
    return 'सर्वोत्तम गुण: $score';
  }

  @override
  String get quizNewBest => 'नवीन सर्वोत्तम गुण!';

  @override
  String get quizAgain => 'पुन्हा खेळा';

  @override
  String get qLargest => 'सर्वात मोठा ग्रह कोणता?';

  @override
  String get qSmallest => 'सर्वात लहान ग्रह कोणता?';

  @override
  String get qHottest => 'सर्वात उष्ण ग्रह कोणता?';

  @override
  String get qColdest => 'सर्वात थंड ग्रह कोणता?';

  @override
  String get qMostMoons => 'कोणत्या ग्रहाला सर्वाधिक ज्ञात चंद्र आहेत?';

  @override
  String get qBreathable => 'कोणत्या ग्रहावर माणूस हवेत श्वास घेऊ शकतो?';

  @override
  String get qClosest => 'सूर्याच्या सर्वात जवळचा ग्रह कोणता?';

  @override
  String get qFarthest => 'सूर्यापासून सर्वात दूरचा ग्रह कोणता?';

  @override
  String get qStrongestGravity => 'कोणत्या ग्रहाचे गुरुत्वाकर्षण सर्वाधिक आहे?';

  @override
  String get qShortestDay => 'कोणत्या ग्रहाचा दिवस सर्वात लहान आहे?';

  @override
  String get qLongestDay => 'कोणत्या ग्रहाचा दिवस सर्वात मोठा आहे?';

  @override
  String get appearance => 'स्वरूप';

  @override
  String get theme => 'थीम';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

  @override
  String get language => 'भाषा';

  @override
  String get appLanguage => 'ॲपची भाषा';

  @override
  String get languageNote => '20 भाषा · ग्रहांची नावेही';

  @override
  String get phoneLanguage => 'फोनची भाषा';

  @override
  String get updates => 'अपडेट';

  @override
  String get version => 'आवृत्ती';

  @override
  String get checkForUpdates => 'अपडेट तपासा';

  @override
  String get checking => 'तपासत आहे…';

  @override
  String get autoUpdateCheck => 'दिवसातून एकदा आपोआप तपासा';

  @override
  String get updateNote =>
      'अपडेट GitHub Releases वरून येतात. तुमच्या सेटिंग्ज फोनमध्येच राहतात.';

  @override
  String get upToDate => 'तुमच्याकडे नवीनतम आवृत्ती आहे.';

  @override
  String get updateFailed =>
      'GitHub पर्यंत पोहोचता आले नाही. इंटरनेट तपासून पुन्हा प्रयत्न करा.';

  @override
  String get updateAvailable => 'अपडेट उपलब्ध आहे';

  @override
  String updateReady(String version) {
    return 'आवृत्ती $version डाउनलोडसाठी तयार आहे.';
  }

  @override
  String get download => 'डाउनलोड';

  @override
  String get later => 'नंतर';

  @override
  String get about => 'माहिती';

  @override
  String get sourceCode => 'GitHub वर सोर्स कोड';

  @override
  String get privacyLine => 'ऑफलाइन · जाहिराती नाहीत · ट्रॅकिंग नाही';

  @override
  String get dataSource => 'माहिती: NASA Planetary Fact Sheet';

  @override
  String get openFailed => 'लिंक उघडता आली नाही.';

  @override
  String get bodySun => 'सूर्य';

  @override
  String get bodyMoon => 'चंद्र';

  @override
  String get bodyPluto => 'प्लूटो';

  @override
  String get moonIo => 'आयो';

  @override
  String get moonEuropa => 'युरोपा';

  @override
  String get moonGanymede => 'गॅनिमीड';

  @override
  String get moonCallisto => 'कॅलिस्टो';

  @override
  String get moonTitan => 'टायटन';

  @override
  String get moonEnceladus => 'एन्सेलाडस';

  @override
  String get moonTriton => 'ट्रायटन';

  @override
  String get kindStar => 'आपला तारा, सूर्यमालेचे केंद्र';

  @override
  String get kindDwarf => 'बटू ग्रह';

  @override
  String moonOf(String planet) {
    return '$planet चा चंद्र';
  }

  @override
  String get orbitPeriod => 'एक प्रदक्षिणा';

  @override
  String distanceFrom(String body) {
    return '$body पासून अंतर';
  }

  @override
  String get composition => 'हे कशापासून बनले आहे';

  @override
  String get noAtmosphere => 'खरे वातावरण नाही, जवळजवळ निर्वात आहे.';

  @override
  String get majorMoons => 'मुख्य चंद्र';

  @override
  String get lifeTitle => 'माणूस इथे राहू शकेल का?';

  @override
  String get lifeScoreShort => 'जीवन गुण';

  @override
  String get lifeNote =>
      'तापमान, हवेचा दाब, ऑक्सिजन, पाणी, पृष्ठभाग आणि गुरुत्वाकर्षणावरून मोजले. पृथ्वीचे गुण 10.';

  @override
  String get water => 'पाणी';

  @override
  String get waterLiquid => 'द्रव पाणी';

  @override
  String get waterIce => 'बर्फ';

  @override
  String get waterOcean => 'बर्फाखाली महासागर';

  @override
  String get waterNone => 'पाणी नाही';

  @override
  String get surface => 'पृष्ठभाग';

  @override
  String get solidSurface => 'घन पृष्ठभाग';

  @override
  String get lifeHome => 'अगदी घरासारखे';

  @override
  String get lifeHard => 'खूप कठीण, बंद तळ आणि स्पेससूट लागेल';

  @override
  String get lifeNo => 'माणसांसाठी अशक्य';

  @override
  String get downloadInstall => 'डाउनलोड करून इन्स्टॉल करा';

  @override
  String downloadingPercent(String percent) {
    return 'डाउनलोड होत आहे… $percent%';
  }

  @override
  String get installNow => 'इन्स्टॉल करा';

  @override
  String get allowInstalls =>
      'उघडलेल्या स्क्रीनवर Heliora ला ॲप इन्स्टॉल करण्याची परवानगी द्या, मग परत येऊन इन्स्टॉल दाबा.';

  @override
  String get downloadFailed =>
      'डाउनलोड पूर्ण झाले नाही. इंटरनेट तपासून पुन्हा प्रयत्न करा.';

  @override
  String get tryAgain => 'पुन्हा प्रयत्न करा';

  @override
  String get today => 'आज';

  @override
  String get play => 'चालवा';

  @override
  String get pause => 'थांबवा';

  @override
  String get monthBack => '30 दिवस आधी';

  @override
  String get monthForward => '30 दिवस नंतर';

  @override
  String get positionsNote =>
      'या तारखेची खरी स्थिती · आकार आणि अंतर प्रमाणात नाही · ग्रहावर टॅप करा';

  @override
  String get navYou => 'तुम्ही';

  @override
  String get ageTitle => 'इतर ग्रहांवर तुमचे वय';

  @override
  String get setBirthDate => 'तुमची जन्मतारीख टाका';

  @override
  String get changeBirthDate => 'बदला';

  @override
  String nextBirthday(String days) {
    return 'पुढचा वाढदिवस $days दिवसांत';
  }

  @override
  String get ageNote => 'तुमची जन्मतारीख फक्त या फोनमध्येच सेव्ह होते.';

  @override
  String get share => 'शेअर करा';

  @override
  String shareText(String planet) {
    return 'Heliora मध्ये $planet, मोफत ऑफलाइन सूर्यमाला ॲप: https://github.com/lumio-apps/heliora';
  }

  @override
  String get shareFailed => 'चित्र शेअर करता आले नाही.';

  @override
  String get travelTitle => 'किती दूर आहे?';

  @override
  String get distanceFromEarth => 'आज पृथ्वीपासून अंतर';

  @override
  String get lightTime => 'प्रकाशाला लागतात';

  @override
  String get bySpacecraft => 'ताशी 60,000 किमी अंतराळयानाने';

  @override
  String get byCar => 'ताशी 100 किमी कारने';

  @override
  String valueSeconds(String value) {
    return '$value सेकंद';
  }

  @override
  String valueMinutes(String value) {
    return '$value मिनिटे';
  }

  @override
  String get sizeTitle => 'आकार';

  @override
  String sizeTimes(String big, String times, String small) {
    return '$big रुंदीत $small पेक्षा $times× मोठा आहे.';
  }

  @override
  String sizeSimilar(String a, String b) {
    return '$a आणि $b जवळजवळ सारख्या आकाराचे आहेत.';
  }

  @override
  String get navSky => 'आकाश';

  @override
  String get skyTitle => 'आजच्या रात्रीचे आकाश';

  @override
  String get chooseCity => 'तुमचे शहर निवडा';

  @override
  String get chooseCityHint =>
      'चंद्र आणि आज रात्री दिसणारे ग्रह पाहण्यासाठी जवळचे शहर निवडा. लोकेशनची परवानगी लागत नाही, आणि हे फोनमध्येच राहते.';

  @override
  String get searchCity => 'शहर शोधा';

  @override
  String get noCityFound => 'शहर सापडले नाही';

  @override
  String get cityNote =>
      'वेळ तुमच्या फोनच्या टाइम झोनमध्ये आहे. अंधाऱ्या आकाशात क्षितिजापासून किमान 5° वर असल्यास ग्रह दिसतो असे मानले जाते.';

  @override
  String illuminated(String percent) {
    return '$percent% प्रकाशित';
  }

  @override
  String get moonrise => 'चंद्रोदय';

  @override
  String get moonset => 'चंद्रास्त';

  @override
  String get sunset => 'सूर्यास्त';

  @override
  String get sunrise => 'सूर्योदय';

  @override
  String get nextFull => 'पुढची पौर्णिमा';

  @override
  String get nextNew => 'पुढची अमावस्या';

  @override
  String get phaseNew => 'अमावस्या';

  @override
  String get phaseWaxingCrescent => 'वाढती चंद्रकोर';

  @override
  String get phaseFirstQuarter => 'शुक्ल अष्टमी';

  @override
  String get phaseWaxingGibbous => 'वाढता चंद्र';

  @override
  String get phaseFull => 'पौर्णिमा';

  @override
  String get phaseWaningGibbous => 'कमी होणारा चंद्र';

  @override
  String get phaseLastQuarter => 'कृष्ण अष्टमी';

  @override
  String get phaseWaningCrescent => 'कमी होणारी चंद्रकोर';

  @override
  String get planetsTonight => 'आजच्या रात्रीचे ग्रह';

  @override
  String get statusVisible => 'आज रात्री दिसेल';

  @override
  String get statusEvening => 'संध्याकाळी, सूर्यास्तानंतर';

  @override
  String get statusMorning => 'सकाळी, सूर्योदयापूर्वी';

  @override
  String get statusNotVisible => 'आज रात्री दिसणार नाही';

  @override
  String bestAt(String time) {
    return 'सर्वोत्तम वेळ $time';
  }

  @override
  String altitudeDir(String direction, String degrees) {
    return '$direction, $degrees° उंच';
  }

  @override
  String riseSet(String rise, String set) {
    return 'उदय $rise · अस्त $set';
  }

  @override
  String get needsTelescope => 'दुर्बीण किंवा टेलिस्कोप लागेल';

  @override
  String get dirN => 'उत्तर';

  @override
  String get dirNE => 'ईशान्य';

  @override
  String get dirE => 'पूर्व';

  @override
  String get dirSE => 'आग्नेय';

  @override
  String get dirS => 'दक्षिण';

  @override
  String get dirSW => 'नैऋत्य';

  @override
  String get dirW => 'पश्चिम';

  @override
  String get dirNW => 'वायव्य';

  @override
  String get findPlanet => 'आकाशात शोधा';

  @override
  String finderTitle(String name) {
    return '$name शोधा';
  }

  @override
  String get pointPhone => 'फोन वर धरा आणि हळूहळू फिरवा.';

  @override
  String turnRight(String degrees) {
    return '$degrees° उजवीकडे वळा';
  }

  @override
  String turnLeft(String degrees) {
    return '$degrees° डावीकडे वळा';
  }

  @override
  String tiltUp(String degrees) {
    return '$degrees° वर उचला';
  }

  @override
  String tiltDown(String degrees) {
    return '$degrees° खाली करा';
  }

  @override
  String onTarget(String name) {
    return '$name अगदी तिथेच आहे!';
  }

  @override
  String belowHorizon(String name) {
    return '$name आत्ता क्षितिजाखाली आहे.';
  }

  @override
  String risesAt(String time) {
    return 'तो $time वाजता उगवेल.';
  }

  @override
  String get noSensor =>
      'या फोनमध्ये होकायंत्र सेन्सर नाही, त्यामुळे शोधक काम करणार नाही.';

  @override
  String get calibrate =>
      'होकायंत्र कॅलिब्रेट करायचे आहे: फोन काही वेळा 8 च्या आकारात फिरवा.';

  @override
  String get phoneNow => 'तुमचा फोन या दिशेला आहे';

  @override
  String get finderNote =>
      'फोनची मागची बाजू आकाशाकडे ठेवा आणि चुंबक व धातूपासून दूर ठेवा. सूर्याकडे कधीही पाहू नका.';

  @override
  String get eventsTitle => 'अंतराळातील घटना';

  @override
  String get eventsSubtitle => 'पुढील 12 महिन्यांत आकाशात काय पाहावे.';

  @override
  String eventsNext(String event, String when) {
    return 'पुढील: $event · $when';
  }

  @override
  String get eventFullMoon => 'पौर्णिमा';

  @override
  String get eventNewMoon => 'अमावस्या';

  @override
  String eventOpposition(String planet) {
    return '$planet प्रतियुतीत';
  }

  @override
  String eventEveningElongation(String planet) {
    return '$planet: संध्याकाळी पाहण्याची सर्वोत्तम वेळ';
  }

  @override
  String eventMorningElongation(String planet) {
    return '$planet: सकाळी पाहण्याची सर्वोत्तम वेळ';
  }

  @override
  String eventConjunction(String a, String b) {
    return '$a आणि $b जवळ येतात';
  }

  @override
  String get eventMarchEquinox => 'मार्च विषुव';

  @override
  String get eventJuneSolstice => 'जून अयनांत';

  @override
  String get eventSeptemberEquinox => 'सप्टेंबर विषुव';

  @override
  String get eventDecemberSolstice => 'डिसेंबर अयनांत';

  @override
  String get eventFullMoonDesc =>
      'चंद्राचा पूर्ण चेहरा प्रकाशित असतो. तो सूर्यास्ताच्या सुमारास उगवतो.';

  @override
  String get eventNewMoonDesc =>
      'चंद्र दिसत नाही. तारे आणि ग्रह पाहण्यासाठी महिन्यातील सर्वात अंधारे आकाश.';

  @override
  String eventOppositionDesc(String planet) {
    return '$planet सूर्याच्या अगदी समोर आहे. यंदा तो सर्वात तेजस्वी आहे आणि रात्रभर दिसतो.';
  }

  @override
  String eventEveningDesc(String planet, String degrees) {
    return '$planet सूर्यापासून $degrees° दूर आहे, सर्वाधिक अंतर. सूर्यास्तानंतर पश्चिमेला खाली पाहा.';
  }

  @override
  String eventMorningDesc(String planet, String degrees) {
    return '$planet सूर्यापासून $degrees° दूर आहे, सर्वाधिक अंतर. सूर्योदयापूर्वी पूर्वेला खाली पाहा.';
  }

  @override
  String eventConjunctionDesc(String degrees) {
    return 'आकाशात हे फक्त $degrees° अंतरावरून जातात.';
  }

  @override
  String get eventEquinoxDesc =>
      'पृथ्वीवर सर्वत्र दिवस आणि रात्र जवळजवळ सारखे असतात.';

  @override
  String get eventJuneSolsticeDesc =>
      'उत्तरेत सर्वात मोठा दिवस, दक्षिणेत सर्वात लहान.';

  @override
  String get eventDecemberSolsticeDesc =>
      'उत्तरेत सर्वात लहान दिवस, दक्षिणेत सर्वात मोठा.';

  @override
  String eventMeteorShower(String shower) {
    return '$shower उल्कावर्षाव';
  }

  @override
  String eventMeteorDesc(String rate, String percent) {
    return 'अंधाऱ्या आकाशात तासाला सुमारे $rate पर्यंत उल्का. चंद्र $percent% प्रकाशित असेल.';
  }

  @override
  String get showerQuadrantids => 'क्वाड्रंटिड्स';

  @override
  String get showerLyrids => 'लायरिड्स';

  @override
  String get showerEtaAquariids => 'एटा एक्वेरिड्स';

  @override
  String get showerPerseids => 'पर्सिड्स';

  @override
  String get showerOrionids => 'ओरायोनिड्स';

  @override
  String get showerLeonids => 'लिओनिड्स';

  @override
  String get showerGeminids => 'जेमिनिड्स';

  @override
  String get showerUrsids => 'अर्सिड्स';

  @override
  String get eventToday => 'आज';

  @override
  String get eventTomorrow => 'उद्या';

  @override
  String eventInDays(String days) {
    return '$days दिवसांत';
  }

  @override
  String get eventsNote =>
      'तारखा तुमच्या फोनवरच मोजल्या जातात आणि त्याच्या टाइम झोनमध्ये दिसतात. उल्कावर्षावाचे शिखर दिवस दरवर्षीचे सामान्य दिवस आहेत, एक दिवस मागेपुढे होऊ शकतो. रिमाइंडर तुमच्या फोनवरच राहतात.';

  @override
  String get remindMe => 'मला आठवण करून द्या';

  @override
  String reminderSet(String date) {
    return 'ठीक आहे, मी तुम्हाला $date रोजी आठवण करून देईन.';
  }

  @override
  String get reminderOff => 'रिमाइंडर काढला.';

  @override
  String get reminderTooLate => 'ही घटना खूप जवळ आहे, रिमाइंडर लावता येत नाही.';

  @override
  String get notificationsOff =>
      'Heliora च्या सूचना बंद आहेत. Android सेटिंग्जमध्ये चालू करा.';

  @override
  String get reminderTomorrow => 'उद्या होणार आहे';

  @override
  String get reminderToday => 'आज होत आहे';

  @override
  String get onlineTitle => 'ऑनलाइन सुविधा';

  @override
  String get onlineSubtitle =>
      'अंतराळ स्थानक आणि रॉकेट प्रक्षेपणे दाखवा. तेव्हा Heliora फक्त wheretheiss.at, Celestrak आणि Launch Library 2 शी संपर्क करते, ज्यांना तुमच्या फोनचा इंटरनेट पत्ता दिसू शकतो. आणखी काही पाठवले जात नाही. सुरुवातीला बंद असते.';

  @override
  String get turnOnOnline => 'ऑनलाइन सुविधा चालू करा';

  @override
  String get issTitle => 'अंतराळ स्थानक';

  @override
  String get issCardHint => 'आत्ता कुठे आहे आणि तुमच्या वरून कधी जाईल';

  @override
  String get issNeedsOnline =>
      'स्थानक दाखवण्यासाठी Heliora ला इंटरनेटवरून त्याचा कक्षा डेटा लागतो. तो एकदा डाउनलोड होतो आणि मग काही दिवस ऑफलाइन चालतो.';

  @override
  String get issLoading => 'कक्षा डेटा मिळवत आहे…';

  @override
  String get issFailed =>
      'कक्षा डेटा मिळाला नाही. इंटरनेट तपासा आणि पुन्हा प्रयत्न करा.';

  @override
  String issStale(String days) {
    return 'कक्षा डेटा $days दिवस जुना आहे, त्यामुळे स्थान थोडे चुकू शकते. नवीन घेण्यासाठी इंटरनेटशी जोडा.';
  }

  @override
  String get issHeight => 'उंची';

  @override
  String get issSpeed => 'वेग';

  @override
  String get issFromYou => 'तुमच्यापासून अंतर';

  @override
  String valueKmh(String value) {
    return '$value किमी/तास';
  }

  @override
  String issAboveHorizon(String direction, String degrees) {
    return 'आत्ता तुमच्या क्षितिजावर आहे! $direction दिशेला पाहा, $degrees° उंच.';
  }

  @override
  String get issBelowHorizon => 'आत्ता तुमच्या क्षितिजाखाली आहे.';

  @override
  String issPassesTitle(String city) {
    return '$city वरून पुढील फेऱ्या';
  }

  @override
  String get issNoPasses => 'पुढील 5 दिवसांत चांगली फेरी नाही.';

  @override
  String issMaxHigh(String degrees) {
    return '$degrees° पर्यंत उंच';
  }

  @override
  String issFromTo(String start, String end) {
    return '$start ते $end';
  }

  @override
  String get issVisible => 'सहज दिसेल';

  @override
  String get issHidden => 'दिसणे कठीण';

  @override
  String get issPassTitle => 'अंतराळ स्थानक तुमच्या वरून जात आहे';

  @override
  String issPassBody(String degrees, String direction) {
    return '10 मिनिटांत उगवेल, $degrees° पर्यंत उंच. $direction दिशेला पाहा.';
  }

  @override
  String get issNote =>
      'स्थाने तुमच्या फोनवरच स्थानकाच्या कक्षा डेटावरून मोजली जातात. आकाश अंधारे आणि स्थानकावर सूर्यप्रकाश असताना ते सहज दिसते: चमकदार, वेगवान ताऱ्यासारखे.';

  @override
  String get launchesNeedOnline =>
      'येणारी रॉकेट प्रक्षेपणे येथे पाहण्यासाठी ऑनलाइन सुविधा चालू करा.';

  @override
  String get launchesFailed =>
      'प्रक्षेपण यादी अपडेट होऊ शकली नाही. जतन केलेली यादी दाखवत आहे.';

  @override
  String get launchesNote =>
      'प्रक्षेपणाची वेळ Launch Library 2 कडून येते आणि अनेकदा बदलते. नावे आणि ठिकाणे इंग्रजीत आहेत.';

  @override
  String get launchReminderBody => 'सुमारे एका तासात उड्डाण. वेळ बदलू शकते.';

  @override
  String get launchTimeTbd => 'वेळ अजून ठरलेली नाही';

  @override
  String get quizChoose => 'स्तर निवडा';

  @override
  String get levelEasy => 'सोपा';

  @override
  String get levelMedium => 'मध्यम';

  @override
  String get levelHard => 'कठीण';

  @override
  String get levelEasyHint => 'ग्रहांबद्दल मूलभूत गोष्टी';

  @override
  String get levelMediumHint => 'ग्रह आणि चंद्र';

  @override
  String get levelHardHint => 'अवघड तुलना आणि क्रम';

  @override
  String get qStar => 'यापैकी कोणता तारा आहे, ग्रह नाही?';

  @override
  String get qDwarf => 'यापैकी कोणता बटू ग्रह आहे?';

  @override
  String get qMoonVisited => 'कोणत्या चंद्रावर माणसे चालली आहेत?';

  @override
  String get qLargestMoon => 'या चंद्रांमध्ये सर्वात मोठा कोणता?';

  @override
  String get qSmallestMoon => 'या चंद्रांमध्ये सर्वात लहान कोणता?';

  @override
  String get qThickAirMoon => 'या चंद्रांपैकी कोणाचे वातावरण दाट आहे?';

  @override
  String get qGeyserMoon => 'कोणता चंद्र पाण्याचे कारंजे अवकाशात उडवतो?';

  @override
  String get qVolcanicMoon =>
      'कोणत्या चंद्रावर सर्वाधिक सक्रिय ज्वालामुखी आहेत?';

  @override
  String get qBackwardsMoon =>
      'कोणता चंद्र आपल्या ग्रहाभोवती उलट दिशेने फिरतो?';

  @override
  String get qBiggestRocky => 'चार खडकाळ ग्रहांपैकी सर्वात मोठा कोणता?';

  @override
  String get qColdestRocky => 'चार खडकाळ ग्रहांपैकी सर्वात थंड कोणता?';

  @override
  String get qHighestPressure =>
      'कोणत्या ग्रहाच्या पृष्ठभागावर हवेचा दाब सर्वाधिक आहे?';

  @override
  String get qSecondLargest => 'कोणता ग्रह दुसरा सर्वात मोठा आहे?';

  @override
  String get qLongestYear => 'कोणत्या ग्रहाचे वर्ष सर्वात मोठे आहे?';

  @override
  String get qShortestYear => 'कोणत्या ग्रहाचे वर्ष सर्वात लहान आहे?';

  @override
  String get qSmallestGiant => 'चार महाकाय ग्रहांपैकी सर्वात लहान कोणता?';

  @override
  String get qRockyLongestYear =>
      'चार खडकाळ ग्रहांपैकी कोणाचे वर्ष सर्वात मोठे आहे?';

  @override
  String get qFastestMoon =>
      'या चंद्रांपैकी कोणता आपल्या ग्रहाभोवती सर्वात वेगाने फिरतो?';

  @override
  String get qSlowestMoon =>
      'या चंद्रांपैकी कोणाला आपल्या ग्रहाभोवती फिरायला सर्वाधिक वेळ लागतो?';

  @override
  String get qStrongestMoonGravity =>
      'या चंद्रांपैकी कोणाचे गुरुत्वाकर्षण सर्वाधिक आहे?';

  @override
  String get qColdestMoon => 'या चंद्रांमध्ये सर्वात थंड कोणता?';

  @override
  String get qSecondLargestMoon => 'या चंद्रांमध्ये दुसरा सर्वात मोठा कोणता?';

  @override
  String get factTitle => 'तुम्हाला माहीत आहे का?';

  @override
  String get factTap => 'आणखी एक तथ्य पाहण्यासाठी टॅप करा';

  @override
  String get factSun1 =>
      'सूर्यमालेच्या एकूण वस्तुमानाचा 99.8% भाग सूर्यात आहे.';

  @override
  String get factSun2 =>
      'सूर्यप्रकाशाला पृथ्वीवर पोहोचायला सुमारे 8 मिनिटे 20 सेकंद लागतात.';

  @override
  String get factMercury1 =>
      'बुधावर एक दिवस, म्हणजे एका सूर्योदयापासून पुढच्या सूर्योदयापर्यंत, सुमारे 176 पृथ्वी-दिवसांचा असतो. तो त्याच्या वर्षाच्या दुप्पट लांब आहे.';

  @override
  String get factMercury2 =>
      'बुधावर हवा जवळजवळ नाही, म्हणून दिवसाही त्याचे आकाश काळे असते आणि रात्री गोठवणाऱ्या थंड असतात.';

  @override
  String get factVenus1 =>
      'शुक्र उलट दिशेने फिरतो, म्हणून तिथे सूर्य पश्चिमेला उगवतो.';

  @override
  String get factVenus2 =>
      'सूर्यापासून जास्त दूर असूनही शुक्र बुधापेक्षा जास्त गरम आहे, कारण त्याची दाट हवा उष्णता अडवून ठेवते.';

  @override
  String get factEarth1 =>
      'जीवन असल्याचे आपल्याला माहीत असलेले पृथ्वी हे एकमेव ठिकाण आहे, आणि तिच्या पृष्ठभागाचा सुमारे 71% भाग पाण्याने व्यापलेला आहे.';

  @override
  String get factEarth2 =>
      'पृथ्वी परिपूर्ण गोल नाही. फिरत असल्यामुळे ती विषुववृत्ताजवळ थोडी फुगलेली आहे.';

  @override
  String get factMars1 =>
      'मंगळावरील ऑलिंपस मॉन्स हा सूर्यमालेतील सर्वात उंच ज्वालामुखी आहे, माउंट एव्हरेस्टपेक्षा सुमारे अडीच पट उंच.';

  @override
  String get factMars2 => 'मंगळावर सूर्यास्त निळे दिसतात.';

  @override
  String get factJupiter1 =>
      'गुरूचे वस्तुमान इतर सर्व ग्रहांच्या एकूण वस्तुमानाच्या दुप्पटीपेक्षा जास्त आहे.';

  @override
  String get factJupiter2 =>
      'ग्रेट रेड स्पॉट हे पृथ्वीपेक्षा मोठे वादळ आहे, जे लोक 150 वर्षांपेक्षा जास्त काळ पाहत आहेत.';

  @override
  String get factSaturn1 =>
      'शनी आपल्या आकारामानाने इतका हलका आहे की पुरेसा मोठा टब मिळाला तर तो पाण्यावर तरंगेल.';

  @override
  String get factSaturn2 =>
      'शनीची कडी खूप रुंद पण खूप पातळ आहेत: काही ठिकाणी फक्त सुमारे दहा मीटर जाड.';

  @override
  String get factUranus1 =>
      'युरेनस कुशीवर लोळत सूर्याभोवती फिरतो, त्याचा आस सुमारे 98 अंश कललेला आहे.';

  @override
  String get factUranus2 =>
      'युरेनस हा दुर्बिणीने शोधलेला पहिला ग्रह होता. विल्यम हर्शेल यांनी तो 1781 मध्ये पाहिला.';

  @override
  String get factNeptune1 =>
      'नेपच्यूनवर कोणत्याही ग्रहापेक्षा वेगवान वारे वाहतात, ताशी 2,000 किमीपेक्षा जास्त.';

  @override
  String get factNeptune2 =>
      'नेपच्यून कोणी पाहण्याआधीच गणिताने शोधला गेला: 1846 मध्ये खगोलशास्त्रज्ञांनी तो कुठे असायला हवा हे मोजले.';

  @override
  String get factMoon1 =>
      'चंद्र दरवर्षी पृथ्वीपासून सुमारे 3.8 सेंटिमीटर आणखी दूर जातो.';

  @override
  String get factMoon2 =>
      'आपल्याला चंद्राची नेहमी एकच बाजू दिसते, कारण पृथ्वीभोवतीच्या प्रत्येक फेरीत तो बरोबर एकदा स्वतःभोवती फिरतो.';

  @override
  String get factPluto1 => 'प्लूटोवर एक वर्ष सुमारे 248 पृथ्वी-वर्षांचे असते.';

  @override
  String get factPluto2 =>
      'प्लूटोवर गोठलेल्या नायट्रोजनचे हृदयाच्या आकाराचे मोठे मैदान आहे.';

  @override
  String get factIo1 =>
      'आयो हे आपल्याला माहीत असलेले सर्वात जास्त ज्वालामुखींचे जग आहे, तिथे शेकडो सक्रिय ज्वालामुखी आहेत.';

  @override
  String get factIo2 =>
      'गुरूचे गुरुत्वाकर्षण आयोला दाबते आणि ओढते, आणि त्यातून निर्माण होणारी उष्णता त्याच्या ज्वालामुखींना ऊर्जा देते.';

  @override
  String get factEuropa1 =>
      'बर्फाळ कवचाखाली युरोपावर कदाचित पृथ्वीवरील सर्व महासागरांपेक्षा सुमारे दुप्पट पाणी आहे.';

  @override
  String get factEuropa2 =>
      'पृथ्वीबाहेर जीवन शोधण्याच्या सर्वोत्तम ठिकाणांपैकी युरोपा एक आहे. युरोपा क्लिपर यान तिथे जात आहे.';

  @override
  String get factGanymede1 =>
      'गॅनिमीड हा सूर्यमालेतील सर्वात मोठा चंद्र आहे. तो बुधापेक्षाही मोठा आहे.';

  @override
  String get factGanymede2 =>
      'स्वतःचे चुंबकीय क्षेत्र असलेला गॅनिमीड हा एकमेव चंद्र आहे.';

  @override
  String get factCallisto1 =>
      'कॅलिस्टो हे सूर्यमालेतील सर्वाधिक विवरे असलेल्या ठिकाणांपैकी एक आहे, आणि त्याचा पृष्ठभाग खूप जुना आहे.';

  @override
  String get factCallisto2 =>
      'कॅलिस्टो गुरूपासून पुरेसा दूर असल्याने त्याला गुरूचे तीव्र किरणोत्सार कमी मिळतात, म्हणून शास्त्रज्ञांनी भविष्यातील तळासाठी त्याचे नाव सुचवले आहे.';

  @override
  String get factTitan1 =>
      'टायटन हा दाट वातावरण असलेला एकमेव चंद्र आहे. त्याच्या पृष्ठभागावरील हवेचा दाब पृथ्वीपेक्षा जास्त आहे.';

  @override
  String get factTitan2 =>
      'टायटनवर नद्या आणि सरोवरे आहेत, पण त्यांत पाणी नाही, द्रव मिथेन आणि इथेन आहे.';

  @override
  String get factEnceladus1 =>
      'एन्सेलाडस आपल्या दक्षिण ध्रुवाजवळच्या भेगांमधून बर्फ आणि पाण्याच्या वाफेचे झोत अवकाशात उडवतो.';

  @override
  String get factEnceladus2 => 'एन्सेलाडसचे हे झोत शनीच्या E कड्याला भरतात.';

  @override
  String get factTriton1 =>
      'ट्रायटन नेपच्यूनभोवती उलट दिशेने फिरतो, म्हणून तो कदाचित नेपच्यूनने पकडलेला बटू ग्रह असावा.';

  @override
  String get factTriton2 =>
      'सुमारे −235 °C वर ट्रायटन हे सूर्यमालेत तापमान मोजलेल्या सर्वात थंड ठिकाणांपैकी एक आहे.';

  @override
  String get jumpInput => 'पृथ्वीवर तुमच्या उडीची उंची (सेमी)';

  @override
  String jumpHigh(String height) {
    return 'उडी: $height';
  }

  @override
  String jumpFeelsLike(String height) {
    return 'पृथ्वीवरील $height उडी इथे होते';
  }

  @override
  String get jumpNote =>
      'धक्का पृथ्वीवरच्याइतकाच असतो. सूर्य आणि वायूंच्या महाकाय ग्रहांवर उभे राहायला जमीन नाही, म्हणून हा फक्त कल्पनेचा खेळ आहे.';

  @override
  String valueCm(String value) {
    return '$value सेमी';
  }

  @override
  String valueM(String value) {
    return '$value मी';
  }

  @override
  String get eclipseTotalLunar => 'खग्रास चंद्रग्रहण';

  @override
  String get eclipsePartialLunar => 'खंडग्रास चंद्रग्रहण';

  @override
  String get eclipsePenumbralLunar => 'छायाकल्प चंद्रग्रहण';

  @override
  String get eclipseTotalSolar => 'खग्रास सूर्यग्रहण';

  @override
  String get eclipseAnnularSolar => 'कंकणाकृती सूर्यग्रहण';

  @override
  String get eclipseHybridSolar => 'संकरित सूर्यग्रहण';

  @override
  String get eclipsePartialSolar => 'खंडग्रास सूर्यग्रहण';

  @override
  String get eclipseTotalLunarDesc =>
      'चंद्र पूर्णपणे पृथ्वीच्या सावलीत जातो आणि अनेकदा फिकट लाल दिसतो. पृथ्वीच्या रात्रीच्या बाजूला असलेले सर्वजण ते पाहू शकतात, आणि डोळ्यांनी पाहणे सुरक्षित आहे.';

  @override
  String eclipsePartialLunarDesc(String percent) {
    return 'चंद्राचा एक भाग (रुंदीच्या $percent%) पृथ्वीच्या गडद सावलीत जातो. डोळ्यांनी पाहणे सुरक्षित आहे.';
  }

  @override
  String get eclipsePenumbralLunarDesc =>
      'चंद्र पृथ्वीच्या फिकट बाहेरच्या सावलीतून जातो. तो थोडाच मंद होतो, म्हणून लक्षात येणे कठीण आहे.';

  @override
  String get eclipseTotalSolarDesc =>
      'पृथ्वीवरील एका अरुंद पट्ट्यात चंद्र सूर्याला पूर्णपणे झाकतो. त्या पट्ट्याच्या बाहेर खंडग्रास ग्रहण दिसते.';

  @override
  String get eclipseAnnularSolarDesc =>
      'चंद्र थोडा जास्त दूर असल्याने सूर्याला पूर्ण झाकू शकत नाही, आणि एक तेजस्वी कडे उरते. हे कडे एका अरुंद पट्ट्यात दिसते; त्याबाहेर ग्रहण खंडग्रास असते.';

  @override
  String get eclipseHybridSolarDesc =>
      'आपल्या पट्ट्यात हे ग्रहण काही ठिकाणी खग्रास आणि काही ठिकाणी कंकणाकृती दिसते. पट्ट्याबाहेर ते खंडग्रास असते.';

  @override
  String get eclipsePartialSolarDesc =>
      'चंद्र सूर्याचा फक्त एक भाग झाकतो, आणि पृथ्वीवर कुठेही सूर्य पूर्ण झाकला जात नाही.';

  @override
  String get eclipseNoCity =>
      'तेथून ते दिसेल का हे पाहण्यासाठी Heliora मध्ये शहर निवडा.';

  @override
  String eclipseLunarUp(String city) {
    return 'ग्रहणाच्या मध्यावर $city मध्ये चंद्र क्षितिजाच्या वर असतो.';
  }

  @override
  String eclipseLunarPartly(String city) {
    return '$city मध्ये चंद्र ग्रहणाच्या फक्त काही भागात क्षितिजाच्या वर असतो.';
  }

  @override
  String eclipseLunarDown(String city) {
    return '$city मध्ये चंद्र क्षितिजाच्या खालीच राहतो, त्यामुळे तेथून दिसणार नाही.';
  }

  @override
  String eclipseSolarNone(String city) {
    return '$city मधून दिसणार नाही: चंद्राची सावली तिथे पोहोचत नाही, किंवा सूर्य क्षितिजाखाली असतो.';
  }

  @override
  String eclipseSolarSlight(String city) {
    return '$city मधून फार तर अगदी हलके खंडग्रास ग्रहण दिसेल, जे लक्षात येणे कठीण आहे.';
  }

  @override
  String eclipseSolarPartial(String city, String percent) {
    return '$city साठी ढोबळ अंदाज: चंद्र जास्तीत जास्त सूर्याच्या रुंदीच्या सुमारे $percent% झाकतो.';
  }

  @override
  String eclipseSolarNear(String city) {
    return '$city त्या पट्ट्याजवळ आहे जिथे सूर्य जवळजवळ किंवा पूर्ण झाकला जातो. ग्रहणाचा नकाशा पाहा; हा अंदाज ढोबळ आहे.';
  }

  @override
  String get eclipseSolarSafety =>
      'योग्य ग्रहण-चष्म्याशिवाय कधीही सूर्याकडे पाहू नका.';

  @override
  String get alertsTitle => 'अलर्ट';

  @override
  String get tonightAlertSwitch => 'दररोज संध्याकाळी आज रात्रीचे आकाश';

  @override
  String get tonightAlertTime => 'वेळ';

  @override
  String get tonightAlertNote =>
      'तुम्ही निवडलेल्या वेळी चंद्र आणि दिसणाऱ्या ग्रहांबद्दल एक छोटा संदेश. तो तुमच्या फोनवरच तयार होतो, इंटरनेट लागत नाही. Android Heliora ला आधीपासून फक्त सुमारे दोन आठवड्यांचे संदेश तयार ठेवू देते, म्हणून अधूनमधून ॲप उघडा.';

  @override
  String get tonightNotifTitle => 'आज रात्रीचे आकाश';

  @override
  String tonightMoon(String phase, String percent) {
    return 'चंद्र: $phase, $percent% प्रकाशित.';
  }

  @override
  String tonightPlanets(String planets) {
    return 'शोधा: $planets.';
  }

  @override
  String get tonightNoPlanets => 'संध्याकाळच्या आकाशात तेजस्वी ग्रह नाहीत.';

  @override
  String get tonightNoCity => 'ग्रह पाहण्यासाठी Heliora मध्ये शहर निवडा.';

  @override
  String get birthdayTitle => 'माझ्या वाढदिवसाचे आकाश';

  @override
  String get birthdaySubtitle =>
      'तुमचा जन्म झाला त्या दिवशी चंद्र आणि ग्रह कुठे होते, आणि तुमच्या आयुष्यातील खास दिवस.';

  @override
  String get birthdayCardHint => 'चंद्राची कला, ग्रह आणि टप्पे';

  @override
  String get birthdayNeedDate => 'तुमची जन्मतारीख टाका';

  @override
  String get birthdayMoon => 'तुमच्या वाढदिवसाला चंद्र';

  @override
  String get birthdayPlanets => 'त्या दिवशी ग्रह';

  @override
  String birthdayDaysOld(String count) {
    return 'आज तुम्ही $count दिवसांचे आहात.';
  }

  @override
  String get birthdayMilestones => 'टप्पे';

  @override
  String birthdayDayN(String count) {
    return 'दिवस $count';
  }

  @override
  String get birthdayBillion => '100 कोटी सेकंदांचे';

  @override
  String get birthdayPassed => 'झाले';

  @override
  String get birthdayNote =>
      'Heliora मधील इतर गोष्टींप्रमाणेच त्याच कक्षांवरून तुमच्या फोनवरच हिशोब केला जातो. तुमची जन्मतारीख फोनबाहेर जात नाही.';

  @override
  String get missionsTitle => 'अंतराळ मोहिमा';

  @override
  String get missionsSubtitle =>
      'अंतराळ संशोधनातील प्रसिद्ध क्षण, सर्वात जुना आधी.';

  @override
  String get missionsCardHint => 'काळानुसार प्रसिद्ध मोहिमा';

  @override
  String get missionSputnik1 =>
      'पहिला कृत्रिम उपग्रह. बीच बॉलएवढा हा धातूचा गोळा सुमारे तीन महिने पृथ्वीभोवती फिरत राहिला. त्याचे बीप रेडिओवर ऐकू येत होते, आणि इथूनच अंतराळ युग सुरू झाले.';

  @override
  String get missionVostok1 =>
      'युरी गागारिन अंतराळात जाणारे पहिले माणूस ठरले. त्यांनी सुमारे 108 मिनिटांत पृथ्वीला एक फेरी मारली.';

  @override
  String get missionApollo11 =>
      'नील आर्मस्ट्राँग आणि बझ ऑल्ड्रिन शांतता सागरात उतरले आणि चंद्रावर चालणारे पहिले माणसे ठरले. मायकेल कॉलिन्स कक्षेत त्यांची वाट पाहत राहिले.';

  @override
  String get missionVenera7 =>
      'दुसऱ्या ग्रहावर उतरून संकेत पाठवणारे पहिले यान. शुक्राच्या चिरडून टाकणाऱ्या उष्णतेत त्याने सुमारे 23 मिनिटे माहिती पाठवली.';

  @override
  String get missionViking1 =>
      'हे मंगळावर उतरले आणि सहा वर्षांहून जास्त काम करत राहिले. दुसऱ्या ग्रहाच्या पृष्ठभागावरून फोटो आणि हवामानाच्या अहवालांची पहिली मोठी मालिका त्याने पाठवली.';

  @override
  String get missionVoyager1 =>
      '1977 मध्ये सोडले गेले, ते गुरू आणि शनीजवळून गेले आणि 2012 मध्ये ताऱ्यांमधील अवकाशात पोहोचले. पृथ्वीपासून सर्वात दूर असलेली मानवनिर्मित वस्तू हीच आहे.';

  @override
  String get missionHubble =>
      '1990 मध्ये सोडले गेले, पृथ्वीच्या हवेच्या वरून विश्वाकडे पाहते. त्याच्या स्पष्ट चित्रांमुळे विश्वाचे वय मोजायला मदत झाली आणि हजारो दूरच्या दीर्घिका दिसल्या.';

  @override
  String get missionHuygens =>
      'कॅसिनीसोबत गेलेले यान ह्युजन्स पॅराशूटने शनीच्या चंद्र टायटनवर उतरले. बाह्य सूर्यमालेतील हे पहिले उतरणे होते, आणि त्याने पृष्ठभागावरून चित्रे पाठवली.';

  @override
  String get missionCuriosity =>
      'कारएवढा हा रोव्हर रॉकेटवर चालणाऱ्या ’स्काय क्रेन’च्या मदतीने गेल विवरात उतरला. मंगळावर एकेकाळी जीवनासाठी योग्य परिस्थिती होती, असे त्याने शोधले.';

  @override
  String get missionMangalyaan =>
      'भारताची मार्स ऑर्बिटर मोहीम पहिल्याच प्रयत्नात मंगळाच्या कक्षेत पोहोचली. कोणत्याही देशासाठी हे पहिल्यांदाच घडले, आणि तेही अगदी कमी खर्चात.';

  @override
  String get missionRosetta =>
      'रोझेटाचा लँडर फिले धूमकेतू 67P/चुर्युमोव्ह–गेरासिमेन्को वर उतरला, धूमकेतूवरचे पहिले उतरणे. रोझेटा स्वतः दोन वर्षे धूमकेतूभोवती फिरत राहिले.';

  @override
  String get missionNewhorizons =>
      'नऊ वर्षांच्या प्रवासानंतर ते प्लूटोजवळून गेले आणि पहिल्यांदाच बर्फाचे पर्वत आणि हृदयाच्या आकाराचे प्रचंड मैदान दाखवले.';

  @override
  String get missionPerseverance =>
      'पर्सिव्हरन्स रोव्हर जुन्या जीवनाच्या खुणा शोधण्यासाठी आणि खडकांचे नमुने गोळा करण्यासाठी जेझेरो विवरात उतरला. त्याच्या हेलिकॉप्टर इन्जेन्युइटीने दुसऱ्या ग्रहावर पहिले नियंत्रित उड्डाण केले.';

  @override
  String get missionJwst =>
      'सर्वात मोठ्या अंतराळ दुर्बिणीत 6.5 मीटरचा सोनेरी आरसा आहे, आणि ती 15 लाख किमी अंतरावरून इन्फ्रारेड प्रकाशात आकाश पाहते. ती सर्वात पहिल्या दीर्घिकांपैकी काही पाहू शकते.';

  @override
  String get missionChandrayaan3 =>
      'भारत चंद्रावर सुरक्षितपणे उतरणारा चौथा देश ठरला, आणि दक्षिण ध्रुवाजवळ उतरणारा पहिला. विक्रम लँडरने सोबत प्रज्ञान रोव्हर नेला होता.';

  @override
  String get spacecraftTitle => 'अंतराळयाने आत्ता';

  @override
  String get spacecraftSubtitle =>
      'काही प्रसिद्ध अंतराळयाने आत्ता पृथ्वीपासून किती दूर आहेत.';

  @override
  String get spacecraftCardHint =>
      'व्हॉयेजर, JWST, मंगळावरील रोव्हर आणि बरेच काही';

  @override
  String get spacecraftDistance => 'पृथ्वीपासूनचे अंतर';

  @override
  String get spacecraftAltitude => 'पृथ्वीपासूनची उंची';

  @override
  String get spacecraftInAu => 'खगोलीय एककात';

  @override
  String get spacecraftSpeed => 'वेग';

  @override
  String get spacecraftSignal => 'रेडिओ संकेताला लागतो';

  @override
  String get spacecraftNote =>
      'अंतरे अंदाजे आहेत. दूरच्या यानांसाठी ती सरासरी वेगावरून काढलेली आहेत आणि पृथ्वी सूर्याभोवती फिरत असल्यामुळे सुमारे 1% इतकी चुकीची असू शकतात. मंगळाचे अंतर आजसाठी मोजलेले आहे. एक AU (खगोलीय एकक) म्हणजे पृथ्वीपासून सूर्याचे अंतर.';

  @override
  String valueBillionKm(String value) {
    return '$value अब्ज किमी';
  }

  @override
  String valueAu(String value) {
    return '$value AU';
  }

  @override
  String valueKmS(String value) {
    return '$value किमी/सेकंद';
  }

  @override
  String get spacecraftVoyager1 =>
      '1977 मध्ये सोडले. 2012 मध्ये ताऱ्यांमधील अंतराळात पोहोचणारे ते पहिले यान ठरले. त्याचा रेडिओ संकेत आपल्यापर्यंत पोहोचेपर्यंत सुमारे एक दिवस जुना झालेला असतो.';

  @override
  String get spacecraftVoyager2 =>
      '1977 मध्ये सोडले. युरेनस आणि नेपच्यूनला भेट देणारे ते एकमेव यान आहे, आणि 2018 मध्ये ते ताऱ्यांमधील अंतराळात पोहोचले.';

  @override
  String get spacecraftNewHorizons =>
      '2015 मध्ये प्लूटोजवळून आणि 2019 मध्ये कायपर पट्ट्यातील अरोकोथजवळून गेले. ते अजूनही बाहेरच्या दिशेने जात आहे आणि अजूनही डेटा पाठवत आहे.';

  @override
  String get spacecraftJwst =>
      'सर्वात मोठी अंतराळ दुर्बीण, 2021 मध्ये सोडली. ती L2 नावाच्या बिंदूजवळ, पृथ्वीपासून सुमारे 15 लाख किमी अंतरावर आहे, आणि तिची सूर्य-ढाल नेहमी सूर्याकडे असते.';

  @override
  String get spacecraftIss =>
      'सुमारे दर 90 मिनिटांनी पृथ्वीला एक फेरी मारते. 2000 पासून त्यावर लोक खंड न पडता राहत आहेत.';

  @override
  String get spacecraftHubble =>
      '1990 मध्ये सोडले आणि अजूनही काम करते. प्रतिमा धुरकट करणाऱ्या हवेच्या वरून ते पृथ्वीभोवती फिरते, म्हणून त्याची छायाचित्रे खूप स्पष्ट असतात.';

  @override
  String get spacecraftMarsRovers =>
      'क्युरिऑसिटी (2012 मध्ये उतरले) आणि पर्सिव्हरन्स (2021 मध्ये उतरले) मंगळावर फिरत आहेत. मंगळाचे अंतर सुमारे 5.5 कोटी किमीपासून 40 कोटी किमीपेक्षा जास्तपर्यंत बदलते.';

  @override
  String get searchTooltip => 'शोधा';

  @override
  String get searchHint => 'ग्रह, चंद्र, मोहिमा शोधा…';

  @override
  String get searchClear => 'पुसा';

  @override
  String searchEmpty(String query) {
    return '“$query” साठी काही सापडले नाही.';
  }

  @override
  String get searchBodies => 'ग्रह आणि चंद्र';

  @override
  String get searchMissions => 'मोहिमा';

  @override
  String get searchSpacecraft => 'अंतराळयाने';

  @override
  String get favoritesTitle => 'आवडते';

  @override
  String get favoritesEmpty =>
      'एखाद्या ग्रहावरील, मोहिमेवरील किंवा यानावरील ताऱ्यावर दाबा, ते इथे राहील.';

  @override
  String get favoriteAdd => 'आवडत्यांमध्ये जोडा';

  @override
  String get favoriteRemove => 'आवडत्यांमधून काढा';

  @override
  String get textSize => 'अक्षरांचा आकार';

  @override
  String get textSizeNormal => 'सामान्य';

  @override
  String get textSizeLarge => 'मोठा';

  @override
  String get textSizeLarger => 'आणखी मोठा';

  @override
  String get textSizeNote =>
      'Heliora मधील अक्षरे मोठी करते. ते तुमच्या फोनच्या स्वतःच्या अक्षर-आकारापेक्षा कधीच लहान होत नाही.';

  @override
  String get skyOtherNight => 'रात्रीचे आकाश';

  @override
  String get planetsThatNight => 'त्या रात्रीचे ग्रह';

  @override
  String get previousDay => 'मागचा दिवस';

  @override
  String get nextDay => 'पुढचा दिवस';

  @override
  String get pickDate => 'तारीख निवडा';

  @override
  String get backToTonight => 'आजच्या रात्रीकडे परत';

  @override
  String get moonCalendar => 'चंद्र दिनदर्शिका';

  @override
  String get moonCalendarHint => 'दररोज चंद्राची कला';

  @override
  String get previousMonth => 'मागचा महिना';

  @override
  String get nextMonth => 'पुढचा महिना';

  @override
  String get keyMoonDates => 'या महिन्यातील मुख्य कला';

  @override
  String get moonCalendarNote =>
      'कलांच्या तारखा आणि वेळ तुमच्या फोनच्या वेळ क्षेत्रात दाखवल्या आहेत आणि सुमारे एका तासाच्या आत अचूक आहेत.';

  @override
  String get seeSkyThatDay => 'या दिवसाचे आकाश पाहा';

  @override
  String get sunLightTitle => 'सूर्य आणि प्रकाश';

  @override
  String get firstLight => 'पहिला प्रकाश';

  @override
  String get goldenMorningEnds => 'सकाळची सोनेरी वेळ संपते';

  @override
  String get solarNoon => 'सूर्य सर्वात उंच';

  @override
  String get goldenEveningStarts => 'संध्याकाळची सोनेरी वेळ सुरू';

  @override
  String get lastLight => 'शेवटचा प्रकाश';

  @override
  String get darkSky => 'पूर्ण अंधारलेले आकाश';

  @override
  String get sunDayLength => 'दिवसाची लांबी';

  @override
  String durationHm(String hours, String minutes) {
    return '$hours तास $minutes मिनिटे';
  }

  @override
  String get sunNote =>
      'सूर्य क्षितिजापासून 6° पेक्षा कमी उंचीवर असतो तेव्हा सोनेरी वेळ. तो 6° खाली असतो तेव्हा पहिला आणि शेवटचा प्रकाश, आणि 18° खाली असतो तेव्हा आकाश पूर्ण अंधारलेले असते. वेळा तुम्ही निवडलेल्या तारखेसाठी काढल्या आहेत.';

  @override
  String get sunStaysUp => 'या दिवशी सूर्य मावळत नाही.';

  @override
  String get sunStaysDown => 'या दिवशी सूर्य उगवत नाही.';

  @override
  String get solarSystemTitle => 'सूर्यमाला';

  @override
  String get starMapTitle => 'तारा नकाशा';

  @override
  String get starMapCardHint => 'तुमच्या आकाशातील तारे आणि तारकासमूह';

  @override
  String get starMapHint =>
      'आजूबाजूला पाहण्यासाठी ओढा, झूम करण्यासाठी दोन बोटांनी पसरवा, एखाद्या ताऱ्यावर किंवा तारकासमूहावर टॅप करा.';

  @override
  String get starsLabel => 'तारे';

  @override
  String get constellationsLabel => 'तारकासमूह';

  @override
  String get starMapFind => 'शोधा';

  @override
  String get constellationsList => 'सर्व तारकासमूह';

  @override
  String magnitudeValue(String value) {
    return 'तेजस्विता $value';
  }

  @override
  String get starBelowHorizon => 'या वेळी क्षितिजाखाली';

  @override
  String get starMapNow => 'आता';

  @override
  String get starUnnamed => 'तारा';

  @override
  String get binocularsTitle => 'द्विनेत्री मार्गदर्शक';

  @override
  String get binocularsHint => 'साध्या द्विनेत्रीतून काय पाहावे';

  @override
  String get binocularsIntro =>
      'द्विनेत्री स्थिर धरा, उदाहरणार्थ कोपरे भिंतीवर किंवा गाडीच्या टपावर टेकवून. शहरातील दिव्यांपासून दूर, तीक्ष्ण ताऱ्यांऐवजी अंधुक, पसरट ठिपके शोधा.';

  @override
  String get binocularsNote =>
      'तुम्ही निवडलेल्या शहरात रात्रीच्या अंधाऱ्या भागात प्रत्येक वस्तू कधी सर्वात उंच असते ते वेळा दाखवतात. वस्तूंची नावे जगभर वापरली जाणारी नावे आहेत. तारा नकाशावर पाहण्यासाठी एकावर टॅप करा.';

  @override
  String get dsoCluster => 'तारकागुच्छ';

  @override
  String get dsoGalaxy => 'दीर्घिका';

  @override
  String get dsoNebula => 'तेजोमेघ';

  @override
  String get storyOri =>
      'शिकारी ओरायन (मृग) शोधणे सोपे आहे: लहान सरळ रेषेत तीन तारे त्याचा कमरपट्टा बनवतात. पट्ट्याच्या वर नारिंगी बेटेलज्यूस एक खांदा आणि खाली निळसर-पांढरा रायजल एक पाय दाखवतो. पट्ट्याखाली अंधुक ठिपका लटकतो, ओरायन तेजोमेघ, नवे तारे जन्माला येत असलेला ढग. ओरायन उत्तरेत हिवाळ्यातील संध्याकाळी आणि दक्षिणेत उन्हाळ्यातील संध्याकाळी दिसतो.';

  @override
  String get storyUMa =>
      'बिग डिपर किंवा नांगर म्हणूनही ओळखल्या जाणाऱ्या सप्तर्षींचे सात तेजस्वी तारे मोठ्या अस्वलाचा भाग आहेत. वाटीच्या टोकाचे दोन तारे, दुभे आणि मेराक, ध्रुव ताऱ्याकडे वाट दाखवतात: त्यांच्यातील अंतराच्या सुमारे पाचपट अंतरापर्यंत रेषा वर वाढवा. उत्तरेकडील अनेक ठिकाणांहून सप्तर्षी रात्रभर ध्रुव ताऱ्याभोवती फिरतात आणि कधीच मावळत नाहीत.';

  @override
  String get storyUMi =>
      'ध्रुव तारा (पोलारिस) लहान अस्वलाच्या शेपटीच्या टोकावर आहे. तो पृथ्वीच्या उत्तर ध्रुवाच्या जवळजवळ अगदी वर असल्यामुळे तो क्वचितच हलतो, म्हणून संपूर्ण आकाश त्याच्याभोवती फिरताना दिसते. क्षितिजापासून त्याची उंची तुमच्या अक्षांशाइतकी असते. तो फार तेजस्वी तारा नाही, पण उत्तर दिशा शोधण्यासाठी सर्वात उपयुक्त आहे. जगाच्या दक्षिण अर्ध्या भागातून तो दिसत नाही.';

  @override
  String get storyCas =>
      'शर्मिष्ठा (कॅसिओपिया) वेळ आणि ऋतूनुसार W किंवा M सारखी दिसते आणि पाच बऱ्यापैकी तेजस्वी ताऱ्यांनी बनलेली आहे. ती ध्रुव ताऱ्याच्या पलीकडे, सप्तर्षींच्या विरुद्ध बाजूला आहे, म्हणून एक खाली असताना दुसरी वर असते. जुन्या कथेत ती आपल्या सौंदर्याचा अभिमान बाळगणारी राणी होती.';

  @override
  String get storyCyg =>
      'हंस (सिग्नस) आकाशगंगेच्या बाजूने उडतो. त्याचे सर्वात तेजस्वी तारे उत्तरेकडचा क्रॉस बनवतात; वरच्या टोकाला डेनेब, म्हणजे हंसाची शेपटी. शहरातील दिव्यांपासून दूर आकाशगंगा हंसातून वाहणाऱ्या फिकट प्रकाशाच्या नदीसारखी दिसते, आणि ती असंख्य अंधुक ताऱ्यांनी बनलेली आहे हे द्विनेत्रीतून कळते. उन्हाळा आणि शरद ऋतूतील संध्याकाळ सर्वोत्तम वेळ आहे.';

  @override
  String get storySco =>
      'वृश्चिक (स्कॉर्पिअस) वाकलेली शेपटी आणि आकड्यासारखे टोक असलेल्या विंचवासारखा दिसतो. त्याचे हृदय लाल ज्येष्ठा (अँटारेस) आहे; त्या नावाचा अर्थ मंगळाचा प्रतिस्पर्धी आहे कारण दोन्ही रंगात सारखे दिसतात. उत्तरेत तो उन्हाळ्यातील तारकासमूह आहे आणि दक्षिणेकडे खाली दिसतो, तर जगाच्या दक्षिण अर्ध्या भागातील लोकांच्या डोक्यावरून उंचावरून जातो.';

  @override
  String get storyLeo =>
      'सिंह (लिओ) खरोखर आपल्या प्राण्यासारखा दिसणाऱ्या थोड्या तारकासमूहांपैकी एक आहे. ताऱ्यांचे उलटे प्रश्नचिन्ह, म्हणजे विळा, डोके आणि छाती बनवते आणि तेजस्वी मघा (रेगुलस), सिंहाच्या हृदयावर संपते. पूर्वेकडील ताऱ्यांचा त्रिकोण त्याचा मागचा भाग आहे. उत्तरेत वसंतातील संध्याकाळ सर्वोत्तम वेळ आहे.';

  @override
  String get storyTau =>
      'वृषभ (टॉरस) चा चेहरा V आकाराचा आहे, तो हायडीज गुच्छ आहे, आणि नारिंगी रोहिणी (अल्डेबरन) त्याचा डोळा आहे. रोहिणी गुच्छाचा भाग वाटते, पण प्रत्यक्षात ती आपल्या खूप जवळ आहे. वर कृत्तिका (प्लेयडीज), म्हणजे सात बहिणी, निळ्या ताऱ्यांचा लहान समूह आहे ज्यात बहुतेक लोकांना सहा किंवा सात तारे दिसतात. कृत्तिका जगभर ओळखल्या जातात आणि अनेक संस्कृतींच्या कथांत येतात.';

  @override
  String get storyGem =>
      'मिथुन (जेमिनी) दोन तेजस्वी तारे, कॅस्टर आणि पोलक्स, यांनी ओळखला जातो; ते दोन भावांच्या डोक्यांसारखे शेजारी शेजारी उभे आहेत. पोलक्स अधिक तेजस्वी आहे आणि त्याला नारिंगी छटा आहे. कॅस्टर प्रत्यक्षात सहा ताऱ्यांची प्रणाली आहे. उत्तरेत हिवाळा आणि वसंतातील संध्याकाळी आकाशात उंचावर त्यांना शोधा.';

  @override
  String get storyLyr =>
      'स्वरमंडळ (लायरा) लहान आहे, पण उत्तर आकाशातील सर्वात तेजस्वी ताऱ्यांपैकी एक असलेला अभिजित (वेगा) त्यात आहे. अभिजित निळसर-पांढरा आहे आणि सिग्नसमधील डेनेब व अक्विलामधील अल्टेअरसह उन्हाळी त्रिकोण बनवतो. अभिजिताच्या अगदी शेजारी ताऱ्यांचा लहान समांतरभुज चौकोन स्वरमंडळाचे शरीर बनवतो.';

  @override
  String get storyCru =>
      'क्रक्स, दक्षिणेकडील क्रॉस, सर्व तारकासमूहांत सर्वात लहान आहे, पण सर्वात प्रसिद्धांपैकी एक. चार तेजस्वी तारे क्रॉस बनवतात आणि त्याच्या लांब बाहूचे दोन तारे दक्षिण खगोलीय ध्रुवाकडे बोट दाखवतात, म्हणून तो प्रवाशांना दक्षिण शोधायला मदत करतो. जगाच्या उत्तर अर्ध्या भागातील बहुतेक ठिकाणांहून तो दिसत नाही.';
}
