// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Astryl';

  @override
  String get tagline => 'अपने अंतरिक्ष को जानिए';

  @override
  String get navExplore => 'खोजें';

  @override
  String get navCompare => 'तुलना';

  @override
  String get navWeight => 'वज़न';

  @override
  String get navQuiz => 'क्विज़';

  @override
  String get viewMode => 'दृश्य मोड';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get notToScale => 'पैमाने पर नहीं · ग्रह खोलने के लिए उस पर टैप करें';

  @override
  String get dragToRotate => 'घुमाने के लिए खींचें · ज़ूम के लिए पिंच करें';

  @override
  String get planetsTitle => 'ग्रह';

  @override
  String get planetMercury => 'बुध';

  @override
  String get planetVenus => 'शुक्र';

  @override
  String get planetEarth => 'पृथ्वी';

  @override
  String get planetMars => 'मंगल';

  @override
  String get planetJupiter => 'बृहस्पति';

  @override
  String get planetSaturn => 'शनि';

  @override
  String get planetUranus => 'अरुण';

  @override
  String get planetNeptune => 'वरुण';

  @override
  String planetOrder(int n) {
    return 'सूर्य से ग्रह क्रमांक $n';
  }

  @override
  String get openDetails => 'विवरण खोलें';

  @override
  String get diameter => 'व्यास';

  @override
  String get gravity => 'गुरुत्वाकर्षण';

  @override
  String get avgTemp => 'औसत तापमान';

  @override
  String get avgTempShort => 'औसत तापमान';

  @override
  String get dayLength => 'दिन';

  @override
  String get yearLength => 'वर्ष';

  @override
  String get moons => 'ज्ञात चंद्रमा';

  @override
  String get moonsShort => 'चंद्रमा';

  @override
  String get distance => 'सूर्य से दूरी';

  @override
  String get pressure => 'सतह का दबाव';

  @override
  String get noSurface => 'कोई ठोस सतह नहीं';

  @override
  String valueKm(String value) {
    return '$value किमी';
  }

  @override
  String valueMillionKm(String value) {
    return '$value मिलियन किमी';
  }

  @override
  String valueHours(String value) {
    return '$value घंटे';
  }

  @override
  String valueDays(String value) {
    return '$value दिन';
  }

  @override
  String valueYears(String value) {
    return '$value वर्ष';
  }

  @override
  String get atmosphere => 'वायुमंडल';

  @override
  String get thinAtmosphere =>
      'लगभग कोई वायुमंडल नहीं। ये गैसें एक्सोस्फ़ीयर नाम की बहुत पतली परत बनाती हैं।';

  @override
  String get oxygen => 'ऑक्सीजन';

  @override
  String get oxygenVsEarth => 'ऑक्सीजन: पृथ्वी से तुलना';

  @override
  String get breathable => 'इंसानों के साँस लेने लायक';

  @override
  String get notBreathable => 'साँस लेने लायक नहीं, स्पेससूट ज़रूरी है';

  @override
  String weightFeelsLike(String weight) {
    return 'पृथ्वी के $weight किलो यहाँ इतने लगेंगे';
  }

  @override
  String get gasCo2 => 'कार्बन डाइऑक्साइड';

  @override
  String get gasN2 => 'नाइट्रोजन';

  @override
  String get gasO2 => 'ऑक्सीजन';

  @override
  String get gasAr => 'आर्गन';

  @override
  String get gasH2 => 'हाइड्रोजन';

  @override
  String get gasHe => 'हीलियम';

  @override
  String get gasCh4 => 'मीथेन';

  @override
  String get gasNa => 'सोडियम';

  @override
  String get gasK => 'पोटैशियम';

  @override
  String get compareTitle => 'ग्रहों की तुलना';

  @override
  String get compareHint => 'दो ग्रह चुनें और उन्हें साथ-साथ देखें।';

  @override
  String get weightTitle => 'दूसरे ग्रहों पर आपका वज़न';

  @override
  String get weightInput => 'पृथ्वी पर आपका वज़न (किलो)';

  @override
  String gravityTimes(String factor) {
    return 'पृथ्वी के गुरुत्व का $factor×';
  }

  @override
  String get quizTitle => 'ग्रह क्विज़';

  @override
  String get quizIntro =>
      'ग्रहों और चंद्रमाओं के बारे में 10 सवाल। आप कितने सही कर पाएँगे?';

  @override
  String get quizStart => 'क्विज़ शुरू करें';

  @override
  String quizProgress(int current, int total) {
    return 'सवाल $current / $total';
  }

  @override
  String get quizNext => 'अगला';

  @override
  String get quizSeeResult => 'नतीजा देखें';

  @override
  String get quizCorrect => 'सही!';

  @override
  String quizWrong(String answer) {
    return 'नहीं। सही जवाब है $answer।';
  }

  @override
  String quizScore(int score, int total) {
    return 'आपके $total में से $score सही';
  }

  @override
  String quizBest(int score) {
    return 'सबसे अच्छा स्कोर: $score';
  }

  @override
  String get quizNewBest => 'नया सबसे अच्छा स्कोर!';

  @override
  String get quizAgain => 'फिर से खेलें';

  @override
  String get qLargest => 'सबसे बड़ा ग्रह कौन सा है?';

  @override
  String get qSmallest => 'सबसे छोटा ग्रह कौन सा है?';

  @override
  String get qHottest => 'सबसे गर्म ग्रह कौन सा है?';

  @override
  String get qColdest => 'सबसे ठंडा ग्रह कौन सा है?';

  @override
  String get qMostMoons => 'किस ग्रह के सबसे ज़्यादा ज्ञात चंद्रमा हैं?';

  @override
  String get qBreathable => 'किस ग्रह पर इंसान हवा में साँस ले सकते हैं?';

  @override
  String get qClosest => 'सूर्य के सबसे पास कौन सा ग्रह है?';

  @override
  String get qFarthest => 'सूर्य से सबसे दूर कौन सा ग्रह है?';

  @override
  String get qStrongestGravity => 'किस ग्रह का गुरुत्वाकर्षण सबसे ज़्यादा है?';

  @override
  String get qShortestDay => 'किस ग्रह का दिन सबसे छोटा है?';

  @override
  String get qLongestDay => 'किस ग्रह का दिन सबसे लंबा है?';

  @override
  String get appearance => 'दिखावट';

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
  String get appLanguage => 'ऐप की भाषा';

  @override
  String get languageNote => '20 भाषाएँ · ग्रहों के नाम भी';

  @override
  String get phoneLanguage => 'फ़ोन की भाषा';

  @override
  String get updates => 'अपडेट';

  @override
  String get version => 'वर्ज़न';

  @override
  String get checkForUpdates => 'अपडेट जाँचें';

  @override
  String get checking => 'जाँच हो रही है…';

  @override
  String get autoUpdateCheck => 'रोज़ एक बार अपने-आप जाँचें';

  @override
  String get updateNote =>
      'Astryl हर बार खुलने पर GitHub से नया version पूछता है और पहले वही दिखाता है (आप छोड़ सकते हैं)। आपके बारे में कुछ नहीं भेजा जाता। आपकी सेटिंग्स आपके फ़ोन में ही रहती हैं।';

  @override
  String get upToDate => 'आपके पास नया वर्ज़न है।';

  @override
  String get updateFailed =>
      'GitHub से जुड़ नहीं पाया। इंटरनेट जाँचें और फिर कोशिश करें।';

  @override
  String get updateAvailable => 'अपडेट उपलब्ध है';

  @override
  String updateReady(String version) {
    return 'वर्ज़न $version डाउनलोड के लिए तैयार है।';
  }

  @override
  String get download => 'डाउनलोड';

  @override
  String get later => 'बाद में';

  @override
  String get reportBug => 'Bug की रिपोर्ट करें';

  @override
  String get updateSkip => 'छोड़ें';

  @override
  String get crashReportsTitle => 'Crash reports भेजें';

  @override
  String get crashReportsNote =>
      'App crash होने पर एक छोटा report (error का text, app version और Android version) Astryl के अपने server पर जाता है, ताकि bug ठीक हो सके। उसमें नाम, खाता या location नहीं होता। इसे कभी भी बंद कर सकते हैं।';

  @override
  String get about => 'जानकारी';

  @override
  String get sourceCode => 'GitHub पर सोर्स कोड';

  @override
  String get websiteLink => 'वेबसाइट: astryl.space';

  @override
  String get privacyLine =>
      'मुफ़्त · Open source · कोई विज्ञापन नहीं · खाता वैकल्पिक';

  @override
  String get dataSource => 'तथ्य: NASA Planetary Fact Sheet';

  @override
  String get openFailed => 'लिंक नहीं खुल पाया।';

  @override
  String get bodySun => 'सूर्य';

  @override
  String get bodyMoon => 'चंद्रमा';

  @override
  String get bodyPluto => 'प्लूटो';

  @override
  String get moonIo => 'आयो';

  @override
  String get moonEuropa => 'यूरोपा';

  @override
  String get moonGanymede => 'गैनिमीड';

  @override
  String get moonCallisto => 'कैलिस्टो';

  @override
  String get moonTitan => 'टाइटन';

  @override
  String get moonEnceladus => 'एन्सेलेडस';

  @override
  String get moonTriton => 'ट्राइटन';

  @override
  String get kindStar => 'हमारा तारा, सौरमंडल का केंद्र';

  @override
  String get kindDwarf => 'बौना ग्रह';

  @override
  String moonOf(String planet) {
    return '$planet का चंद्रमा';
  }

  @override
  String get orbitPeriod => 'एक परिक्रमा';

  @override
  String distanceFrom(String body) {
    return '$body से दूरी';
  }

  @override
  String get composition => 'यह किससे बना है';

  @override
  String get noAtmosphere => 'असली वायुमंडल नहीं है, लगभग निर्वात है।';

  @override
  String get majorMoons => 'मुख्य चंद्रमा';

  @override
  String get lifeTitle => 'क्या इंसान यहाँ रह सकते हैं?';

  @override
  String get lifeScoreShort => 'जीवन स्कोर';

  @override
  String get lifeNote =>
      'तापमान, हवा के दबाव, ऑक्सीजन, पानी, सतह और गुरुत्वाकर्षण से गिना गया। पृथ्वी का स्कोर 10 है।';

  @override
  String get water => 'पानी';

  @override
  String get waterLiquid => 'तरल पानी';

  @override
  String get waterIce => 'बर्फ़';

  @override
  String get waterOcean => 'बर्फ़ के नीचे समुद्र';

  @override
  String get waterNone => 'पानी नहीं';

  @override
  String get surface => 'सतह';

  @override
  String get solidSurface => 'ठोस सतह';

  @override
  String get lifeHome => 'बिल्कुल घर जैसा';

  @override
  String get lifeHard => 'बहुत मुश्किल, बंद बेस और स्पेससूट चाहिए';

  @override
  String get lifeNo => 'इंसानों के लिए असंभव';

  @override
  String get downloadInstall => 'डाउनलोड करके इंस्टॉल करें';

  @override
  String downloadingPercent(String percent) {
    return 'डाउनलोड हो रहा है… $percent%';
  }

  @override
  String get installNow => 'इंस्टॉल करें';

  @override
  String get allowInstalls =>
      'जो स्क्रीन खुली है उसमें Astryl को ऐप इंस्टॉल करने की अनुमति दें, फिर वापस आकर इंस्टॉल दबाएँ।';

  @override
  String get downloadFailed =>
      'डाउनलोड पूरा नहीं हुआ। इंटरनेट जाँचें और फिर कोशिश करें।';

  @override
  String get tryAgain => 'फिर कोशिश करें';

  @override
  String get today => 'आज';

  @override
  String get play => 'चलाएँ';

  @override
  String get pause => 'रोकें';

  @override
  String get monthBack => '30 दिन पहले';

  @override
  String get monthForward => '30 दिन बाद';

  @override
  String get positionsNote =>
      'इस तारीख़ पर असली स्थिति · आकार और दूरी पैमाने पर नहीं · ग्रह पर टैप करें';

  @override
  String get navYou => 'आप';

  @override
  String get ageTitle => 'दूसरे ग्रहों पर आपकी उम्र';

  @override
  String get setBirthDate => 'अपनी जन्मतिथि डालें';

  @override
  String get changeBirthDate => 'बदलें';

  @override
  String nextBirthday(String days) {
    return 'अगला जन्मदिन $days दिन में';
  }

  @override
  String get ageNote => 'आपकी जन्मतिथि सिर्फ़ इसी फ़ोन में सेव होती है।';

  @override
  String get share => 'शेयर करें';

  @override
  String shareText(String planet) {
    return 'Astryl में $planet, मुफ़्त सौरमंडल ऐप: https://github.com/aditymishr098-collab/astryl';
  }

  @override
  String get shareFailed => 'तस्वीर शेयर नहीं हो पाई।';

  @override
  String get travelTitle => 'कितनी दूर है?';

  @override
  String get distanceFromEarth => 'आज पृथ्वी से दूरी';

  @override
  String get lightTime => 'रोशनी को लगता है';

  @override
  String get bySpacecraft => '60,000 किमी/घंटा वाले अंतरिक्ष यान से';

  @override
  String get byCar => '100 किमी/घंटा वाली कार से';

  @override
  String valueSeconds(String value) {
    return '$value सेकंड';
  }

  @override
  String valueMinutes(String value) {
    return '$value मिनट';
  }

  @override
  String get sizeTitle => 'आकार';

  @override
  String sizeTimes(String big, String times, String small) {
    return '$big चौड़ाई में $small से $times× बड़ा है।';
  }

  @override
  String sizeSimilar(String a, String b) {
    return '$a और $b लगभग एक जितने बड़े हैं।';
  }

  @override
  String get navSky => 'आकाश';

  @override
  String get skyTitle => 'आज रात का आकाश';

  @override
  String get chooseCity => 'अपना शहर चुनें';

  @override
  String get chooseCityHint =>
      'अपने सबसे पास का शहर चुनें, ताकि चाँद और आज रात दिखने वाले ग्रह देख सकें। लोकेशन की अनुमति नहीं चाहिए, और यह आपके फ़ोन में ही रहता है।';

  @override
  String get searchCity => 'शहर खोजें';

  @override
  String get noCityFound => 'कोई शहर नहीं मिला';

  @override
  String get cityNote =>
      'समय आपके फ़ोन के टाइम ज़ोन में है। अंधेरे आकाश में क्षितिज से कम से कम 5° ऊपर होने पर ग्रह दिखने वाला माना जाता है।';

  @override
  String illuminated(String percent) {
    return '$percent% रोशन';
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
  String get nextFull => 'अगली पूर्णिमा';

  @override
  String get nextNew => 'अगली अमावस्या';

  @override
  String get phaseNew => 'अमावस्या';

  @override
  String get phaseWaxingCrescent => 'बढ़ता अर्धचंद्र';

  @override
  String get phaseFirstQuarter => 'शुक्ल अष्टमी';

  @override
  String get phaseWaxingGibbous => 'बढ़ता चंद्रमा';

  @override
  String get phaseFull => 'पूर्णिमा';

  @override
  String get phaseWaningGibbous => 'घटता चंद्रमा';

  @override
  String get phaseLastQuarter => 'कृष्ण अष्टमी';

  @override
  String get phaseWaningCrescent => 'घटता अर्धचंद्र';

  @override
  String get planetsTonight => 'आज रात के ग्रह';

  @override
  String get statusVisible => 'आज रात दिखेगा';

  @override
  String get statusEvening => 'शाम को, सूर्यास्त के बाद';

  @override
  String get statusMorning => 'सुबह, सूर्योदय से पहले';

  @override
  String get statusNotVisible => 'आज रात नहीं दिखेगा';

  @override
  String bestAt(String time) {
    return 'सबसे अच्छा समय $time';
  }

  @override
  String altitudeDir(String direction, String degrees) {
    return '$direction, $degrees° ऊँचा';
  }

  @override
  String riseSet(String rise, String set) {
    return 'उदय $rise · अस्त $set';
  }

  @override
  String get needsTelescope => 'दूरबीन या टेलीस्कोप चाहिए';

  @override
  String get dirN => 'उत्तर';

  @override
  String get dirNE => 'उत्तर-पूर्व';

  @override
  String get dirE => 'पूर्व';

  @override
  String get dirSE => 'दक्षिण-पूर्व';

  @override
  String get dirS => 'दक्षिण';

  @override
  String get dirSW => 'दक्षिण-पश्चिम';

  @override
  String get dirW => 'पश्चिम';

  @override
  String get dirNW => 'उत्तर-पश्चिम';

  @override
  String get findPlanet => 'आकाश में खोजें';

  @override
  String finderTitle(String name) {
    return '$name खोजें';
  }

  @override
  String get pointPhone => 'फ़ोन ऊपर उठाकर धीरे-धीरे घुमाएँ।';

  @override
  String turnRight(String degrees) {
    return '$degrees° दाएँ मुड़ें';
  }

  @override
  String turnLeft(String degrees) {
    return '$degrees° बाएँ मुड़ें';
  }

  @override
  String tiltUp(String degrees) {
    return '$degrees° ऊपर करें';
  }

  @override
  String tiltDown(String degrees) {
    return '$degrees° नीचे करें';
  }

  @override
  String onTarget(String name) {
    return '$name ठीक वहीं है!';
  }

  @override
  String belowHorizon(String name) {
    return '$name अभी क्षितिज के नीचे है।';
  }

  @override
  String risesAt(String time) {
    return 'यह $time पर उगेगा।';
  }

  @override
  String get noSensor =>
      'इस फ़ोन में कंपास सेंसर नहीं है, इसलिए खोजक काम नहीं करेगा।';

  @override
  String get calibrate =>
      'कंपास को कैलिब्रेट करना है: फ़ोन को कुछ बार 8 के आकार में घुमाएँ।';

  @override
  String get phoneNow => 'आपका फ़ोन इस ओर है';

  @override
  String get finderNote =>
      'फ़ोन का पिछला हिस्सा आकाश की ओर रखें और चुंबक व धातु से दूर रखें। सूरज को कभी न देखें।';

  @override
  String get eventsTitle => 'अंतरिक्ष की घटनाएँ';

  @override
  String get eventsSubtitle => 'अगले 12 महीनों में आकाश में क्या देखें।';

  @override
  String eventsNext(String event, String when) {
    return 'अगली: $event · $when';
  }

  @override
  String get eventFullMoon => 'पूर्णिमा';

  @override
  String get eventNewMoon => 'अमावस्या';

  @override
  String eventOpposition(String planet) {
    return '$planet प्रतिमुख (ऑपोज़िशन) में';
  }

  @override
  String eventEveningElongation(String planet) {
    return '$planet: शाम को देखने का सबसे अच्छा समय';
  }

  @override
  String eventMorningElongation(String planet) {
    return '$planet: सुबह देखने का सबसे अच्छा समय';
  }

  @override
  String eventConjunction(String a, String b) {
    return '$a और $b एक-दूसरे के पास';
  }

  @override
  String get eventMarchEquinox => 'मार्च विषुव';

  @override
  String get eventJuneSolstice => 'जून अयनांत';

  @override
  String get eventSeptemberEquinox => 'सितंबर विषुव';

  @override
  String get eventDecemberSolstice => 'दिसंबर अयनांत';

  @override
  String get eventFullMoonDesc =>
      'चाँद का पूरा चेहरा रोशन होता है। यह सूर्यास्त के आसपास उगता है।';

  @override
  String get eventNewMoonDesc =>
      'चाँद छिपा रहता है। तारों और ग्रहों को देखने के लिए महीने का सबसे अंधेरा आकाश।';

  @override
  String eventOppositionDesc(String planet) {
    return '$planet सूरज के ठीक सामने है। इस साल यह सबसे चमकीला है और पूरी रात दिखता है।';
  }

  @override
  String eventEveningDesc(String planet, String degrees) {
    return '$planet सूरज से $degrees° दूर है, यानी सबसे दूर। सूर्यास्त के बाद पश्चिम में नीचे देखें।';
  }

  @override
  String eventMorningDesc(String planet, String degrees) {
    return '$planet सूरज से $degrees° दूर है, यानी सबसे दूर। सूर्योदय से पहले पूर्व में नीचे देखें।';
  }

  @override
  String eventConjunctionDesc(String degrees) {
    return 'आकाश में ये बस $degrees° की दूरी से गुज़रते हैं।';
  }

  @override
  String get eventEquinoxDesc => 'पूरी धरती पर दिन और रात लगभग बराबर होते हैं।';

  @override
  String get eventJuneSolsticeDesc =>
      'उत्तर में सबसे लंबा दिन, दक्षिण में सबसे छोटा।';

  @override
  String get eventDecemberSolsticeDesc =>
      'उत्तर में सबसे छोटा दिन, दक्षिण में सबसे लंबा।';

  @override
  String eventMeteorShower(String shower) {
    return '$shower उल्कापात';
  }

  @override
  String eventMeteorDesc(String rate, String percent) {
    return 'साफ़ अंधेरे आकाश में प्रति घंटे लगभग $rate तक उल्काएँ। चाँद $percent% रोशन रहेगा।';
  }

  @override
  String get showerQuadrantids => 'क्वाड्रेंटिड्स';

  @override
  String get showerLyrids => 'लायरिड्स';

  @override
  String get showerEtaAquariids => 'एटा एक्वेरिड्स';

  @override
  String get showerPerseids => 'पर्सीड्स';

  @override
  String get showerOrionids => 'ओरियोनिड्स';

  @override
  String get showerLeonids => 'लियोनिड्स';

  @override
  String get showerGeminids => 'जेमिनिड्स';

  @override
  String get showerUrsids => 'अर्सिड्स';

  @override
  String get eventToday => 'आज';

  @override
  String get eventTomorrow => 'कल';

  @override
  String eventInDays(String days) {
    return '$days दिन में';
  }

  @override
  String get eventsNote =>
      'तारीख़ें आपके फ़ोन में ही निकाली जाती हैं और उसके टाइम ज़ोन में दिखती हैं। उल्कापात के चरम दिन हर साल के सामान्य दिन हैं, इनमें एक दिन का फ़र्क़ हो सकता है। रिमाइंडर आपके फ़ोन में ही रहते हैं।';

  @override
  String get remindMe => 'मुझे याद दिलाएँ';

  @override
  String reminderSet(String date) {
    return 'ठीक है, मैं आपको $date को याद दिलाऊँगा।';
  }

  @override
  String get reminderOff => 'रिमाइंडर हटा दिया।';

  @override
  String get reminderTooLate => 'यह घटना बहुत पास है, रिमाइंडर नहीं लग सकता।';

  @override
  String get notificationsOff =>
      'Astryl की सूचनाएँ बंद हैं। Android सेटिंग में इन्हें चालू करें।';

  @override
  String get reminderTomorrow => 'कल होने वाला है';

  @override
  String get reminderToday => 'आज हो रहा है';

  @override
  String get onlineTitle => 'ऑनलाइन सुविधाएँ';

  @override
  String get onlineSubtitle =>
      'अंतरिक्ष स्टेशन, तियांगोंग, हबल, रॉकेट लॉन्च और अंतरिक्ष समाचार दिखाएँ। तब Astryl सिर्फ़ wheretheiss.at, Celestrak, Launch Library 2 और Spaceflight News API से जुड़ता है, जो आपके फ़ोन का इंटरनेट पता देख सकते हैं। और कुछ नहीं भेजा जाता। शुरू में बंद रहता है।';

  @override
  String get turnOnOnline => 'ऑनलाइन सुविधाएँ चालू करें';

  @override
  String get issTitle => 'अंतरिक्ष स्टेशन';

  @override
  String get issCardHint => 'अभी कहाँ है और आपके ऊपर से कब गुज़रेगा';

  @override
  String get issNeedsOnline =>
      'स्टेशन दिखाने के लिए Astryl को इंटरनेट से उसका ऑर्बिट डेटा चाहिए। यह एक बार डाउनलोड होता है और फिर कई दिन ऑफ़लाइन चलता है।';

  @override
  String get issLoading => 'ऑर्बिट डेटा लिया जा रहा है…';

  @override
  String get issFailed =>
      'ऑर्बिट डेटा नहीं मिल सका। इंटरनेट जाँचें और फिर कोशिश करें।';

  @override
  String issStale(String days) {
    return 'ऑर्बिट डेटा $days दिन पुराना है, इसलिए जगह थोड़ी गलत हो सकती है। नया लेने के लिए इंटरनेट से जुड़ें।';
  }

  @override
  String get issHeight => 'ऊँचाई';

  @override
  String get issSpeed => 'रफ़्तार';

  @override
  String get issFromYou => 'आपसे दूरी';

  @override
  String valueKmh(String value) {
    return '$value किमी/घंटा';
  }

  @override
  String issAboveHorizon(String direction, String degrees) {
    return 'अभी आपके क्षितिज के ऊपर है! $direction की ओर देखें, $degrees° ऊँचा।';
  }

  @override
  String get issBelowHorizon => 'अभी आपके क्षितिज के नीचे है।';

  @override
  String issPassesTitle(String city) {
    return '$city के ऊपर से अगली उड़ानें';
  }

  @override
  String get issNoPasses => 'अगले 5 दिनों में कोई अच्छी उड़ान नहीं है।';

  @override
  String issMaxHigh(String degrees) {
    return '$degrees° तक ऊँचा';
  }

  @override
  String issFromTo(String start, String end) {
    return '$start से $end तक';
  }

  @override
  String get issVisible => 'आसानी से दिखेगा';

  @override
  String get issHidden => 'मुश्किल से दिखेगा';

  @override
  String get issPassTitle => 'अंतरिक्ष स्टेशन आपके ऊपर से गुज़र रहा है';

  @override
  String issPassBody(String degrees, String direction) {
    return '10 मिनट में उगेगा, $degrees° तक ऊँचा। $direction की ओर देखें।';
  }

  @override
  String get issNote =>
      'जगह आपके फ़ोन में ही स्टेशन के ऑर्बिट डेटा से निकाली जाती है। जब आकाश अंधेरा हो और स्टेशन पर सूरज की रोशनी पड़ रही हो तब वह आसानी से दिखता है: एक चमकीले, तेज़ तारे जैसा।';

  @override
  String get launchesNeedOnline =>
      'आने वाले रॉकेट लॉन्च यहाँ देखने के लिए ऑनलाइन सुविधाएँ चालू करें।';

  @override
  String get launchesFailed =>
      'लॉन्च सूची अपडेट नहीं हो सकी। सहेजी हुई सूची दिखा रहे हैं।';

  @override
  String get launchesNote =>
      'लॉन्च का समय Launch Library 2 से आता है और अक्सर बदलता है। नाम और जगहें अंग्रेज़ी में हैं।';

  @override
  String get launchReminderBody =>
      'करीब एक घंटे में उड़ान भरेगा। समय बदल सकता है।';

  @override
  String get launchTimeTbd => 'समय अभी तय नहीं';

  @override
  String get quizChoose => 'स्तर चुनें';

  @override
  String get levelEasy => 'आसान';

  @override
  String get levelMedium => 'मध्यम';

  @override
  String get levelHard => 'कठिन';

  @override
  String get levelEasyHint => 'ग्रहों की बुनियादी बातें';

  @override
  String get levelMediumHint => 'ग्रह और चंद्रमा';

  @override
  String get levelHardHint => 'मुश्किल तुलनाएँ और क्रम';

  @override
  String get qStar => 'इनमें से कौन सा तारा है, ग्रह नहीं?';

  @override
  String get qDwarf => 'इनमें से कौन सा बौना ग्रह है?';

  @override
  String get qMoonVisited => 'किस चंद्रमा पर इंसान चल चुके हैं?';

  @override
  String get qLargestMoon => 'इन चंद्रमाओं में सबसे बड़ा कौन सा है?';

  @override
  String get qSmallestMoon => 'इन चंद्रमाओं में सबसे छोटा कौन सा है?';

  @override
  String get qThickAirMoon => 'इन चंद्रमाओं में किसका वायुमंडल घना है?';

  @override
  String get qGeyserMoon =>
      'कौन सा चंद्रमा पानी के फ़व्वारे अंतरिक्ष में छोड़ता है?';

  @override
  String get qVolcanicMoon =>
      'किस चंद्रमा पर सबसे ज़्यादा सक्रिय ज्वालामुखी हैं?';

  @override
  String get qBackwardsMoon =>
      'कौन सा चंद्रमा अपने ग्रह का चक्कर उल्टी दिशा में लगाता है?';

  @override
  String get qBiggestRocky => 'चार चट्टानी ग्रहों में सबसे बड़ा कौन सा है?';

  @override
  String get qColdestRocky => 'चार चट्टानी ग्रहों में सबसे ठंडा कौन सा है?';

  @override
  String get qHighestPressure =>
      'किस ग्रह की सतह पर हवा का दबाव सबसे ज़्यादा है?';

  @override
  String get qSecondLargest => 'कौन सा ग्रह दूसरा सबसे बड़ा है?';

  @override
  String get qLongestYear => 'किस ग्रह का साल सबसे लंबा है?';

  @override
  String get qShortestYear => 'किस ग्रह का साल सबसे छोटा है?';

  @override
  String get qSmallestGiant => 'चार विशाल ग्रहों में सबसे छोटा कौन सा है?';

  @override
  String get qRockyLongestYear =>
      'चार चट्टानी ग्रहों में किसका साल सबसे लंबा है?';

  @override
  String get qFastestMoon =>
      'इन चंद्रमाओं में कौन अपने ग्रह का चक्कर सबसे तेज़ लगाता है?';

  @override
  String get qSlowestMoon =>
      'इन चंद्रमाओं में कौन अपने ग्रह का चक्कर लगाने में सबसे ज़्यादा समय लेता है?';

  @override
  String get qStrongestMoonGravity =>
      'इन चंद्रमाओं में किसका गुरुत्वाकर्षण सबसे ज़्यादा है?';

  @override
  String get qColdestMoon => 'इन चंद्रमाओं में सबसे ठंडा कौन सा है?';

  @override
  String get qSecondLargestMoon =>
      'इन चंद्रमाओं में दूसरा सबसे बड़ा कौन सा है?';

  @override
  String get factTitle => 'क्या आप जानते हैं?';

  @override
  String get factTap => 'दूसरा तथ्य देखने के लिए टैप करें';

  @override
  String get factSun1 =>
      'सौरमंडल के कुल द्रव्यमान का 99.8% हिस्सा सूर्य में है।';

  @override
  String get factSun2 =>
      'सूर्य की रोशनी को पृथ्वी तक पहुँचने में करीब 8 मिनट 20 सेकंड लगते हैं।';

  @override
  String get factMercury1 =>
      'बुध पर एक दिन, यानी एक सूर्योदय से अगले सूर्योदय तक, करीब 176 पृथ्वी-दिनों का होता है। यह उसके साल से दोगुना लंबा है।';

  @override
  String get factMercury2 =>
      'बुध पर हवा लगभग नहीं है, इसलिए दिन में भी उसका आसमान काला रहता है और रातें बर्फ़ जैसी ठंडी होती हैं।';

  @override
  String get factVenus1 =>
      'शुक्र उल्टी दिशा में घूमता है, इसलिए वहाँ सूरज पश्चिम में उगता है।';

  @override
  String get factVenus2 =>
      'सूर्य से ज़्यादा दूर होने पर भी शुक्र बुध से ज़्यादा गर्म है, क्योंकि उसकी घनी हवा गर्मी को रोक लेती है।';

  @override
  String get factEarth1 =>
      'पृथ्वी अकेली ऐसी जगह है जहाँ हम जीवन जानते हैं, और उसकी सतह का करीब 71% हिस्सा पानी से ढका है।';

  @override
  String get factEarth2 =>
      'पृथ्वी पूरी तरह गोल नहीं है। घूमने की वजह से वह भूमध्य रेखा पर थोड़ी उभरी हुई है।';

  @override
  String get factMars1 =>
      'मंगल का ओलंपस मॉन्स सौरमंडल का सबसे ऊँचा ज्वालामुखी है, माउंट एवरेस्ट से करीब ढाई गुना ऊँचा।';

  @override
  String get factMars2 => 'मंगल पर सूर्यास्त नीले दिखते हैं।';

  @override
  String get factJupiter1 =>
      'बृहस्पति का द्रव्यमान बाकी सभी ग्रहों के कुल द्रव्यमान से दोगुने से भी ज़्यादा है।';

  @override
  String get factJupiter2 =>
      'ग्रेट रेड स्पॉट पृथ्वी से बड़ा एक तूफ़ान है, जिसे लोग 150 साल से भी ज़्यादा समय से देख रहे हैं।';

  @override
  String get factSaturn1 =>
      'शनि अपने आकार के हिसाब से इतना हल्का है कि पानी में तैर जाएगा, अगर इतना बड़ा टब मिल जाए।';

  @override
  String get factSaturn2 =>
      'शनि के छल्ले बहुत चौड़े पर बहुत पतले हैं: कई जगह सिर्फ़ करीब दस मीटर मोटे।';

  @override
  String get factUranus1 =>
      'अरुण अपनी बगल के बल लुढ़कते हुए सूर्य का चक्कर लगाता है, उसकी धुरी करीब 98 डिग्री झुकी है।';

  @override
  String get factUranus2 =>
      'अरुण दूरबीन से खोजा गया पहला ग्रह था। विलियम हर्शल ने उसे 1781 में देखा।';

  @override
  String get factNeptune1 =>
      'वरुण पर किसी भी ग्रह से तेज़ हवाएँ चलती हैं, 2,000 किमी/घंटा से भी ज़्यादा।';

  @override
  String get factNeptune2 =>
      'वरुण को किसी के देखने से पहले गणित से खोजा गया: 1846 में खगोलविदों ने हिसाब लगाया कि वह कहाँ होना चाहिए।';

  @override
  String get factMoon1 =>
      'चंद्रमा हर साल पृथ्वी से करीब 3.8 सेंटीमीटर और दूर चला जाता है।';

  @override
  String get factMoon2 =>
      'हमें चंद्रमा का हमेशा एक ही हिस्सा दिखता है, क्योंकि वह पृथ्वी के हर चक्कर में ठीक एक बार घूमता है।';

  @override
  String get factPluto1 =>
      'प्लूटो पर एक साल करीब 248 पृथ्वी-वर्षों का होता है।';

  @override
  String get factPluto2 =>
      'प्लूटो पर जमी हुई नाइट्रोजन का दिल के आकार का एक विशाल मैदान है।';

  @override
  String get factIo1 =>
      'आयो हमारी जानकारी की सबसे ज़्यादा ज्वालामुखी वाली दुनिया है, जहाँ सैकड़ों सक्रिय ज्वालामुखी हैं।';

  @override
  String get factIo2 =>
      'बृहस्पति का गुरुत्वाकर्षण आयो को दबाता और खींचता है, और इससे पैदा गर्मी उसके ज्वालामुखियों को चलाती है।';

  @override
  String get factEuropa1 =>
      'अपनी बर्फ़ीली परत के नीचे यूरोपा में शायद पृथ्वी के सभी महासागरों से करीब दोगुना पानी है।';

  @override
  String get factEuropa2 =>
      'यूरोपा पृथ्वी से परे जीवन खोजने की सबसे अच्छी जगहों में से एक है। यूरोपा क्लिपर यान वहाँ जा रहा है।';

  @override
  String get factGanymede1 =>
      'गैनिमीड सौरमंडल का सबसे बड़ा चंद्रमा है। वह बुध से भी बड़ा है।';

  @override
  String get factGanymede2 =>
      'गैनिमीड अकेला चंद्रमा है जिसका अपना चुंबकीय क्षेत्र पाया गया है।';

  @override
  String get factCallisto1 =>
      'कैलिस्टो सौरमंडल की सबसे ज़्यादा गड्ढों वाली जगहों में से एक है, और उसकी सतह बहुत पुरानी है।';

  @override
  String get factCallisto2 =>
      'कैलिस्टो बृहस्पति से इतनी दूर है कि उसे उसका कठोर विकिरण कम मिलता है, इसलिए वैज्ञानिकों ने भविष्य के अड्डे के लिए उसका सुझाव दिया है।';

  @override
  String get factTitan1 =>
      'टाइटन अकेला चंद्रमा है जिसका वायुमंडल घना है। उसकी सतह पर हवा का दबाव पृथ्वी से ज़्यादा है।';

  @override
  String get factTitan2 =>
      'टाइटन पर नदियाँ और झीलें हैं, पर उनमें पानी नहीं, तरल मीथेन और ईथेन है।';

  @override
  String get factEnceladus1 =>
      'एन्सेलेडस अपने दक्षिणी ध्रुव के पास की दरारों से बर्फ़ और जलवाष्प की धाराएँ अंतरिक्ष में छोड़ता है।';

  @override
  String get factEnceladus2 =>
      'एन्सेलेडस की ये धाराएँ शनि के E छल्ले को भरती हैं।';

  @override
  String get factTriton1 =>
      'ट्राइटन वरुण का चक्कर उल्टी दिशा में लगाता है, इसलिए शायद वह एक बौना ग्रह था जिसे वरुण ने पकड़ लिया।';

  @override
  String get factTriton2 =>
      'करीब −235 °C पर ट्राइटन सौरमंडल की उन सबसे ठंडी जगहों में है जहाँ कभी तापमान नापा गया है।';

  @override
  String get jumpInput => 'पृथ्वी पर आपकी कूद की ऊँचाई (सेमी)';

  @override
  String jumpHigh(String height) {
    return 'कूद: $height';
  }

  @override
  String jumpFeelsLike(String height) {
    return 'पृथ्वी पर $height की कूद यहाँ बन जाती है';
  }

  @override
  String get jumpNote =>
      'धक्का वही रहता है जो पृथ्वी पर होता है। सूर्य और गैस वाले विशाल ग्रहों पर खड़े होने की ज़मीन नहीं है, इसलिए यह सिर्फ़ कल्पना का खेल है।';

  @override
  String valueCm(String value) {
    return '$value सेमी';
  }

  @override
  String valueM(String value) {
    return '$value मी';
  }

  @override
  String get eclipseTotalLunar => 'पूर्ण चंद्र ग्रहण';

  @override
  String get eclipsePartialLunar => 'आंशिक चंद्र ग्रहण';

  @override
  String get eclipsePenumbralLunar => 'उपछाया चंद्र ग्रहण';

  @override
  String get eclipseTotalSolar => 'पूर्ण सूर्य ग्रहण';

  @override
  String get eclipseAnnularSolar => 'वलयाकार सूर्य ग्रहण';

  @override
  String get eclipseHybridSolar => 'संकर सूर्य ग्रहण';

  @override
  String get eclipsePartialSolar => 'आंशिक सूर्य ग्रहण';

  @override
  String get eclipseTotalLunarDesc =>
      'चंद्रमा पूरी तरह पृथ्वी की छाया में चला जाता है और अक्सर हल्का लाल दिखता है। पृथ्वी के रात वाले हिस्से में सभी इसे देख सकते हैं, और इसे आँखों से देखना सुरक्षित है।';

  @override
  String eclipsePartialLunarDesc(String percent) {
    return 'चंद्रमा का एक हिस्सा (चौड़ाई का $percent%) पृथ्वी की गहरी छाया में चला जाता है। इसे आँखों से देखना सुरक्षित है।';
  }

  @override
  String get eclipsePenumbralLunarDesc =>
      'चंद्रमा पृथ्वी की हल्की बाहरी छाया से गुज़रता है। वह बस थोड़ा मद्धम होता है, इसलिए पहचानना मुश्किल है।';

  @override
  String get eclipseTotalSolarDesc =>
      'चंद्रमा पृथ्वी पर एक पतली पट्टी में सूरज को पूरी तरह ढक लेता है। उस पट्टी के बाहर आंशिक ग्रहण दिखता है।';

  @override
  String get eclipseAnnularSolarDesc =>
      'चंद्रमा थोड़ा ज़्यादा दूर होता है, इसलिए सूरज को पूरा नहीं ढक पाता और चमकदार छल्ला बच जाता है। छल्ला एक पतली पट्टी में दिखता है; उसके बाहर ग्रहण आंशिक होता है।';

  @override
  String get eclipseHybridSolarDesc =>
      'अपनी पट्टी में यह ग्रहण कुछ जगह पूर्ण और कुछ जगह छल्लेनुमा दिखता है। पट्टी के बाहर यह आंशिक होता है।';

  @override
  String get eclipsePartialSolarDesc =>
      'चंद्रमा सूरज के सिर्फ़ एक हिस्से को ढकता है, और पृथ्वी पर कहीं भी सूरज पूरा नहीं ढकता।';

  @override
  String get eclipseNoCity =>
      'Astryl में कोई शहर चुनें, ताकि पता चले कि वहाँ से यह दिखेगा या नहीं।';

  @override
  String eclipseLunarUp(String city) {
    return 'ग्रहण के बीच में $city में चंद्रमा क्षितिज के ऊपर रहता है।';
  }

  @override
  String eclipseLunarPartly(String city) {
    return '$city में चंद्रमा ग्रहण के सिर्फ़ कुछ हिस्से में क्षितिज के ऊपर रहता है।';
  }

  @override
  String eclipseLunarDown(String city) {
    return '$city में चंद्रमा क्षितिज के नीचे रहता है, इसलिए वहाँ से यह नहीं दिखेगा।';
  }

  @override
  String eclipseSolarNone(String city) {
    return '$city से नहीं दिखेगा: चंद्रमा की छाया वहाँ नहीं पहुँचती, या सूरज क्षितिज के नीचे होता है।';
  }

  @override
  String eclipseSolarSlight(String city) {
    return '$city से ज़्यादा से ज़्यादा बहुत हल्का आंशिक ग्रहण दिखेगा, जिसे पहचानना मुश्किल है।';
  }

  @override
  String eclipseSolarPartial(String city, String percent) {
    return '$city के लिए मोटा अंदाज़ा: चंद्रमा ज़्यादा से ज़्यादा सूरज की चौड़ाई का लगभग $percent% ढकता है।';
  }

  @override
  String eclipseSolarNear(String city) {
    return '$city उस पट्टी के पास है जहाँ सूरज लगभग या पूरी तरह ढक जाता है। ग्रहण का नक्शा देखें; यह अंदाज़ा मोटा है।';
  }

  @override
  String get eclipseSolarSafety =>
      'सूरज को कभी भी सही ग्रहण-चश्मे के बिना न देखें।';

  @override
  String get alertsTitle => 'अलर्ट';

  @override
  String get tonightAlertSwitch => 'हर शाम आज रात का आसमान';

  @override
  String get tonightAlertTime => 'समय';

  @override
  String get tonightAlertNote =>
      'आपके चुने समय पर चंद्रमा और दिखने वाले ग्रहों के बारे में एक छोटा सा संदेश। यह आपके फ़ोन पर ही बनता है, इंटरनेट नहीं चाहिए। Android Astryl को सिर्फ़ करीब दो हफ़्ते के संदेश पहले से तैयार करने देता है, इसलिए ऐप बीच-बीच में खोलते रहें।';

  @override
  String get tonightNotifTitle => 'आज रात का आसमान';

  @override
  String tonightMoon(String phase, String percent) {
    return 'चंद्रमा: $phase, $percent% रोशन।';
  }

  @override
  String tonightPlanets(String planets) {
    return 'देखिए: $planets।';
  }

  @override
  String get tonightNoPlanets => 'शाम के आसमान में कोई चमकीला ग्रह नहीं है।';

  @override
  String get tonightNoCity => 'ग्रह देखने के लिए Astryl में शहर चुनें।';

  @override
  String get birthdayTitle => 'मेरे जन्मदिन का आसमान';

  @override
  String get birthdaySubtitle =>
      'जिस दिन आप पैदा हुए, उस दिन चंद्रमा और ग्रह कहाँ थे, और आपकी ज़िंदगी के खास दिन।';

  @override
  String get birthdayCardHint => 'चंद्रमा की कला, ग्रह और खास पड़ाव';

  @override
  String get birthdayNeedDate => 'अपनी जन्मतिथि डालें';

  @override
  String get birthdayMoon => 'आपके जन्मदिन पर चंद्रमा';

  @override
  String get birthdayPlanets => 'उस दिन ग्रह';

  @override
  String birthdayDaysOld(String count) {
    return 'आज आप $count दिन के हैं।';
  }

  @override
  String get birthdayMilestones => 'खास पड़ाव';

  @override
  String birthdayDayN(String count) {
    return 'दिन $count';
  }

  @override
  String get birthdayBillion => '1 अरब सेकंड के';

  @override
  String get birthdayPassed => 'हो चुका';

  @override
  String get birthdayNote =>
      'यह आपके फ़ोन पर ही Astryl की बाकी चीज़ों जैसी कक्षाओं से निकाला जाता है। आपकी जन्मतिथि फ़ोन से बाहर नहीं जाती।';

  @override
  String get missionsTitle => 'अंतरिक्ष मिशन';

  @override
  String get missionsSubtitle =>
      'अंतरिक्ष की खोज के मशहूर पल, सबसे पुराने से शुरू।';

  @override
  String get missionsCardHint => 'समय के साथ मशहूर मिशन';

  @override
  String get missionSputnik1 =>
      'पहला कृत्रिम उपग्रह। बीच-बॉल जितनी यह धातु की गेंद करीब तीन महीने पृथ्वी का चक्कर लगाती रही। इसकी बीप रेडियो पर सुनी जा सकती थी, और इसी से अंतरिक्ष युग शुरू हुआ।';

  @override
  String get missionVostok1 =>
      'यूरी गागरिन अंतरिक्ष में जाने वाले पहले इंसान बने। उन्होंने करीब 108 मिनट में पृथ्वी का एक चक्कर लगाया।';

  @override
  String get missionApollo11 =>
      'नील आर्मस्ट्रांग और बज़ एल्ड्रिन शांति सागर में उतरे और चाँद पर चलने वाले पहले इंसान बने। माइकल कॉलिन्स कक्षा में उनका इंतज़ार करते रहे।';

  @override
  String get missionVenera7 =>
      'दूसरे ग्रह पर उतरकर संकेत भेजने वाला पहला यान। उसने शुक्र की कुचल देने वाली गर्मी में करीब 23 मिनट तक डेटा भेजा।';

  @override
  String get missionViking1 =>
      'यह मंगल पर उतरा और छह साल से ज़्यादा काम करता रहा। इसने किसी दूसरे ग्रह की सतह से तस्वीरों और मौसम की रिपोर्टों की पहली लंबी श्रृंखला भेजी।';

  @override
  String get missionVoyager1 =>
      '1977 में छोड़ा गया, यह बृहस्पति और शनि के पास से गुज़रा और 2012 में तारों के बीच की जगह में पहुँचा। यह पृथ्वी से सबसे दूर इंसान की बनाई चीज़ है।';

  @override
  String get missionHubble =>
      '1990 में छोड़ा गया, यह पृथ्वी की हवा के ऊपर से ब्रह्मांड को देखता है। इसकी साफ़ तस्वीरों से ब्रह्मांड की उम्र नापने में मदद मिली और हज़ारों दूर की आकाशगंगाएँ दिखीं।';

  @override
  String get missionHuygens =>
      'कैसिनी के साथ गया यान ह्यूजेन्स पैराशूट से शनि के चंद्रमा टाइटन पर उतरा। बाहरी सौरमंडल में यह पहली लैंडिंग थी, और उसने सतह से तस्वीरें भेजीं।';

  @override
  String get missionCuriosity =>
      'कार जितना बड़ा यह रोवर रॉकेट से चलने वाली ’स्काई क्रेन’ की मदद से गेल क्रेटर में उतरा। इसने पाया कि मंगल पर कभी जीवन के लायक हालात थे।';

  @override
  String get missionMangalyaan =>
      'भारत का मंगल ऑर्बिटर मिशन पहली ही कोशिश में मंगल की कक्षा में पहुँच गया। किसी भी देश के लिए यह पहली बार था, और वह भी बहुत कम खर्च में।';

  @override
  String get missionRosetta =>
      'रोसेटा के लैंडर फ़ाइली ने धूमकेतु 67P/चुर्यूमोव–गेरासिमेंको पर उतरकर धूमकेतु पर पहली लैंडिंग की। रोसेटा खुद दो साल तक धूमकेतु का चक्कर लगाता रहा।';

  @override
  String get missionNewhorizons =>
      'नौ साल के सफ़र के बाद यह प्लूटो के पास से गुज़रा और पहली बार हमें बर्फ़ीले पहाड़ और दिल के आकार का विशाल मैदान दिखाया।';

  @override
  String get missionPerseverance =>
      'पर्सिवियरेंस रोवर पुराने जीवन के निशान खोजने और चट्टानों के नमूने जमा करने के लिए जेज़ेरो क्रेटर में उतरा। उसके हेलिकॉप्टर इंजेन्युइटी ने किसी दूसरे ग्रह पर पहली संचालित उड़ान भरी।';

  @override
  String get missionJwst =>
      'सबसे बड़ी अंतरिक्ष दूरबीन में 6.5 मीटर का सुनहरा शीशा है, और वह 15 लाख किमी दूर से इन्फ्रारेड रोशनी में आसमान देखती है। वह कुछ सबसे पहली आकाशगंगाएँ देख पाती है।';

  @override
  String get missionChandrayaan3 =>
      'भारत चाँद पर आराम से उतरने वाला चौथा देश बना, और दक्षिणी ध्रुव के पास उतरने वाला पहला। विक्रम लैंडर अपने साथ प्रज्ञान रोवर लेकर गया था।';

  @override
  String get spacecraftTitle => 'अंतरिक्ष यान अभी';

  @override
  String get spacecraftSubtitle =>
      'कुछ मशहूर अंतरिक्ष यान अभी पृथ्वी से कितनी दूर हैं।';

  @override
  String get spacecraftCardHint => 'वॉयेजर, JWST, मंगल रोवर और बहुत कुछ';

  @override
  String get spacecraftDistance => 'पृथ्वी से दूरी';

  @override
  String get spacecraftAltitude => 'पृथ्वी से ऊँचाई';

  @override
  String get spacecraftInAu => 'खगोलीय इकाई में';

  @override
  String get spacecraftSpeed => 'गति';

  @override
  String get spacecraftSignal => 'रेडियो संकेत को लगता है';

  @override
  String get spacecraftNote =>
      'दूरियाँ अनुमान हैं। दूर के यानों के लिए ये औसत गति से निकाली गई हैं और पृथ्वी के सूर्य के चारों ओर घूमने के कारण लगभग 1% तक ग़लत हो सकती हैं। मंगल की दूरी आज के लिए गिनी गई है। एक AU (खगोलीय इकाई) पृथ्वी से सूर्य की दूरी है।';

  @override
  String valueBillionKm(String value) {
    return '$value अरब किमी';
  }

  @override
  String valueAu(String value) {
    return '$value AU';
  }

  @override
  String valueKmS(String value) {
    return '$value किमी/सेकंड';
  }

  @override
  String get spacecraftVoyager1 =>
      '1977 में छोड़ा गया। 2012 में यह तारों के बीच के अंतरिक्ष में पहुँचने वाला पहला यान बना। इसका रेडियो संकेत हम तक पहुँचते-पहुँचते लगभग एक दिन पुराना हो चुका होता है।';

  @override
  String get spacecraftVoyager2 =>
      '1977 में छोड़ा गया। यह अकेला यान है जो अरुण और वरुण तक गया, और 2018 में तारों के बीच के अंतरिक्ष में पहुँचा।';

  @override
  String get spacecraftNewHorizons =>
      '2015 में प्लूटो के पास से और 2019 में कुइपर पट्टी की चट्टान अरोकोथ के पास से गुज़रा। यह अब भी बाहर की ओर बढ़ रहा है और अब भी डेटा भेज रहा है।';

  @override
  String get spacecraftJwst =>
      'सबसे बड़ी अंतरिक्ष दूरबीन, 2021 में छोड़ी गई। यह L2 नाम के एक बिंदु के पास है, पृथ्वी से लगभग 15 लाख किमी दूर, और इसकी धूप-ढाल हमेशा सूर्य की ओर रहती है।';

  @override
  String get spacecraftIss =>
      'लगभग हर 90 मिनट में पृथ्वी का एक चक्कर लगाता है। 2000 से इस पर लोग बिना रुके रह रहे हैं।';

  @override
  String get spacecraftHubble =>
      '1990 में छोड़ा गया और आज भी काम कर रहा है। यह धुंधला करने वाली हवा के ऊपर से पृथ्वी की परिक्रमा करता है, इसलिए इसकी तस्वीरें बहुत साफ़ होती हैं।';

  @override
  String get spacecraftMarsRovers =>
      'क्यूरियोसिटी (2012 में उतरा) और पर्सिवरेंस (2021 में उतरा) मंगल पर चल रहे हैं। मंगल की दूरी लगभग 5.5 करोड़ किमी से बदलकर 40 करोड़ किमी से भी ज़्यादा तक पहुँच जाती है।';

  @override
  String get searchTooltip => 'खोजें';

  @override
  String get searchHint => 'ग्रह, चंद्रमा, मिशन खोजें…';

  @override
  String get searchClear => 'मिटाएँ';

  @override
  String searchEmpty(String query) {
    return '“$query” के लिए कुछ नहीं मिला।';
  }

  @override
  String get searchBodies => 'ग्रह और चंद्रमा';

  @override
  String get searchMissions => 'मिशन';

  @override
  String get searchSpacecraft => 'अंतरिक्ष यान';

  @override
  String get favoritesTitle => 'पसंदीदा';

  @override
  String get favoritesEmpty =>
      'किसी ग्रह, मिशन या अंतरिक्ष यान पर तारे को दबाएँ, वह यहाँ रखा जाएगा।';

  @override
  String get favoriteAdd => 'पसंदीदा में जोड़ें';

  @override
  String get favoriteRemove => 'पसंदीदा से हटाएँ';

  @override
  String get textSize => 'अक्षरों का आकार';

  @override
  String get textSizeNormal => 'सामान्य';

  @override
  String get textSizeLarge => 'बड़ा';

  @override
  String get textSizeLarger => 'और बड़ा';

  @override
  String get textSizeNote =>
      'Astryl के अक्षर बड़े कर देता है। यह आपके फ़ोन के अपने अक्षर-आकार से कभी छोटा नहीं होता।';

  @override
  String get skyOtherNight => 'रात का आकाश';

  @override
  String get planetsThatNight => 'उस रात के ग्रह';

  @override
  String get previousDay => 'पिछला दिन';

  @override
  String get nextDay => 'अगला दिन';

  @override
  String get pickDate => 'तारीख़ चुनें';

  @override
  String get backToTonight => 'आज रात पर वापस';

  @override
  String get moonCalendar => 'चंद्र कैलेंडर';

  @override
  String get moonCalendarHint => 'हर दिन चंद्रमा की कला';

  @override
  String get previousMonth => 'पिछला महीना';

  @override
  String get nextMonth => 'अगला महीना';

  @override
  String get keyMoonDates => 'इस महीने की मुख्य कलाएँ';

  @override
  String get moonCalendarNote =>
      'कलाओं की तारीख़ और समय आपके फ़ोन के समय क्षेत्र में दिखाए गए हैं और लगभग एक घंटे के भीतर सही हैं।';

  @override
  String get seeSkyThatDay => 'इस दिन का आकाश देखें';

  @override
  String get sunLightTitle => 'सूर्य और रोशनी';

  @override
  String get firstLight => 'पहली रोशनी';

  @override
  String get goldenMorningEnds => 'सुबह का सुनहरा समय खत्म';

  @override
  String get solarNoon => 'सूर्य सबसे ऊँचा';

  @override
  String get goldenEveningStarts => 'शाम का सुनहरा समय शुरू';

  @override
  String get lastLight => 'आखिरी रोशनी';

  @override
  String get darkSky => 'पूरी तरह अँधेरा आकाश';

  @override
  String get sunDayLength => 'दिन की लंबाई';

  @override
  String durationHm(String hours, String minutes) {
    return '$hours घंटे $minutes मिनट';
  }

  @override
  String get sunNote =>
      'सुनहरा समय वह है जब सूर्य क्षितिज से 6° से कम ऊपर हो। पहली और आखिरी रोशनी तब होती है जब वह 6° नीचे हो, और आकाश पूरी तरह अँधेरा तब होता है जब वह 18° नीचे हो। समय आपकी चुनी तारीख़ के लिए निकाले गए हैं।';

  @override
  String get sunStaysUp => 'इस दिन सूर्य अस्त नहीं होता।';

  @override
  String get sunStaysDown => 'इस दिन सूर्य उदय नहीं होता।';

  @override
  String get solarSystemTitle => 'सौर मंडल';

  @override
  String get starMapTitle => 'तारा-मानचित्र';

  @override
  String get starMapCardHint => 'आपके आकाश के तारे और तारामंडल';

  @override
  String get starMapHint =>
      'चारों ओर देखने के लिए उँगली घुमाएँ, ज़ूम के लिए दो उँगलियों से फैलाएँ, किसी तारे या तारामंडल को छुएँ।';

  @override
  String get starsLabel => 'तारे';

  @override
  String get constellationsLabel => 'तारामंडल';

  @override
  String get starMapFind => 'ढूँढें';

  @override
  String get constellationsList => 'सभी तारामंडल';

  @override
  String magnitudeValue(String value) {
    return 'परिमाण $value';
  }

  @override
  String get starBelowHorizon => 'इस समय क्षितिज के नीचे';

  @override
  String get starMapNow => 'अभी';

  @override
  String get starUnnamed => 'तारा';

  @override
  String get binocularsTitle => 'बाइनोकुलर गाइड';

  @override
  String get binocularsHint => 'साधारण बाइनोकुलर से क्या देखें';

  @override
  String get binocularsIntro =>
      'बाइनोकुलर को स्थिर पकड़ें, जैसे कोहनियाँ दीवार या कार की छत पर टिकाकर। शहर की रोशनी से दूर, तीखे तारों की जगह धुँधले, फैले हुए धब्बे ढूँढें।';

  @override
  String get binocularsNote =>
      'समय बताते हैं कि आपके चुने शहर में रात के अँधेरे हिस्से में हर वस्तु कब सबसे ऊँची होती है। वस्तुओं के नाम वही हैं जो दुनिया भर में चलते हैं। तारा-मानचित्र पर देखने के लिए किसी को छुएँ।';

  @override
  String get dsoCluster => 'तारा-गुच्छ';

  @override
  String get dsoGalaxy => 'आकाशगंगा';

  @override
  String get dsoNebula => 'नीहारिका';

  @override
  String get storyOri =>
      'ओरायन (मृग) को ढूँढना आसान है: एक छोटी सीधी रेखा में तीन तारे उसकी पेटी बनाते हैं। पेटी के ऊपर नारंगी बेटलज्यूस एक कंधे को और नीचे नीला-सफ़ेद रिजेल एक पैर को दिखाता है। पेटी के नीचे एक हल्का धुँधला धब्बा लटकता है, ओरायन नीहारिका, एक बादल जिसमें नए तारे जन्म ले रहे हैं। ओरायन उत्तर में सर्दियों की शाम को और दक्षिण में गर्मियों की शाम को दिखता है।';

  @override
  String get storyUMa =>
      'सप्तर्षि के सात चमकीले तारे, जिसे अंग्रेज़ी में बिग डिपर या प्लाउ कहते हैं, वृहत् ऋक्ष (बड़े भालू) का हिस्सा हैं। कटोरे के सिरे के दो तारे, दुबहे और मेराक, ध्रुव तारे का रास्ता दिखाते हैं: उनके बीच की दूरी की लगभग पाँच गुना दूरी तक रेखा को ऊपर की ओर बढ़ाइए। उत्तर के बहुत-से हिस्सों से सप्तर्षि रात भर ध्रुव तारे के चक्कर लगाता है और कभी अस्त नहीं होता।';

  @override
  String get storyUMi =>
      'ध्रुव तारा (पोलारिस) लघु ऋक्ष (छोटे भालू) की पूँछ की नोक पर है। यह लगभग नहीं हिलता क्योंकि यह पृथ्वी के उत्तरी ध्रुव के लगभग ठीक ऊपर है, इसलिए पूरा आकाश इसी के चारों ओर घूमता दिखता है। क्षितिज से इसकी ऊँचाई आपके अक्षांश के बराबर होती है। यह बहुत चमकीला तारा नहीं है, पर उत्तर दिशा खोजने के लिए सबसे काम का है। दुनिया के दक्षिणी आधे हिस्से से यह नहीं दिखता।';

  @override
  String get storyCas =>
      'शर्मिष्ठा (कैसियोपिया) W या M जैसी दिखती है, घड़ी और मौसम पर निर्भर करता है, और इसमें पाँच काफ़ी चमकीले तारे हैं। यह ध्रुव तारे के उस पार है जिधर सप्तर्षि नहीं है, इसलिए जब एक नीचे होता है तो दूसरा ऊपर। पुरानी कथा में वह एक रानी थी जिसे अपनी सुंदरता पर घमंड था।';

  @override
  String get storyCyg =>
      'हंस (सिग्नस) आकाशगंगा के साथ-साथ उड़ता है। इसके सबसे चमकीले तारे उत्तरी क्रॉस बनाते हैं, जिसके ऊपर डेनेब है, यानी हंस की पूँछ। शहर की रोशनी से दूर आकाशगंगा हंस के बीच से गुज़रती हल्की रोशनी की नदी जैसी दिखती है, और बाइनोकुलर से पता चलता है कि वह अनगिनत धुँधले तारों से बनी है। गर्मियों और पतझड़ की शामें सबसे अच्छा समय हैं।';

  @override
  String get storySco =>
      'वृश्चिक (स्कॉर्पियस) मुड़ी हुई पूँछ और काँटे जैसे सिरे वाले बिच्छू जैसा दिखता है। इसका हृदय लाल ज्येष्ठा (एंटारेस) है, जिसका नाम मंगल का प्रतिद्वंद्वी है क्योंकि दोनों रंग में एक जैसे दिखते हैं। उत्तर में यह गर्मियों का तारामंडल है और दक्षिण की ओर नीचा दिखता है, जबकि दुनिया के दक्षिणी आधे हिस्से में यह सिर के ऊपर तक ऊँचा चढ़ता है।';

  @override
  String get storyLeo =>
      'सिंह (लियो) उन गिने-चुने तारामंडलों में है जो सचमुच अपने जानवर जैसा दिखता है। तारों का उल्टा प्रश्नचिह्न, जिसे हँसिया कहते हैं, सिर और छाती बनाता है और चमकीले मघा (रेगुलस), यानी सिंह के हृदय पर ख़त्म होता है। पूर्व की ओर तारों का त्रिकोण उसका पिछला हिस्सा है। उत्तर में बसंत की शामें सबसे अच्छा समय हैं।';

  @override
  String get storyTau =>
      'वृषभ (टॉरस) का चेहरा V आकार का है, यह हायडीज़ गुच्छ है, और नारंगी रोहिणी (एल्डेबारन) उसकी आँख है। रोहिणी ऐसी दिखती है जैसे गुच्छ का हिस्सा हो, पर असल में वह हमारे बहुत पास है। ऊपर कृतिका (प्लेयडीज़), यानी सात बहनें, नीले तारों का छोटा समूह है जिसमें ज़्यादातर लोग छह या सात तारे देखते हैं। कृतिका दुनिया भर में जानी जाती है और कई संस्कृतियों की कहानियों में आती है।';

  @override
  String get storyGem =>
      'मिथुन (जेमिनी) को दो चमकीले तारे, कैस्टर और पोलक्स, दिखाते हैं, जो दो भाइयों के सिरों की तरह साथ-साथ खड़े हैं। पोलक्स ज़्यादा चमकीला है और उस पर नारंगी आभा है। कैस्टर असल में छह तारों का तंत्र है। उत्तर में इन्हें सर्दियों और बसंत की शामों में आकाश में ऊँचा खोजिए।';

  @override
  String get storyLyr =>
      'वीणा (लायरा) छोटी है, पर उसमें अभिजित (वेगा) है, जो उत्तरी आकाश के सबसे चमकीले तारों में से एक है। अभिजित नीला-सफ़ेद है और हंस के डेनेब तथा गरुड़ के अल्टेयर के साथ मिलकर ग्रीष्म त्रिकोण बनाता है। अभिजित के ठीक पास तारों का छोटा समांतर चतुर्भुज वीणा का ढाँचा बनाता है।';

  @override
  String get storyCru =>
      'त्रिशंकु (क्रक्स, सदर्न क्रॉस) सभी तारामंडलों में सबसे छोटा है, पर सबसे मशहूर में से एक है। चार चमकीले तारे एक क्रॉस बनाते हैं और उसकी लंबी भुजा के दो तारे दक्षिणी खगोलीय ध्रुव की ओर इशारा करते हैं, इसलिए यह यात्रियों को दक्षिण दिशा खोजने में मदद करता है। दुनिया के उत्तरी आधे हिस्से के ज़्यादातर भागों से यह नहीं दिखता।';

  @override
  String get satellitesTitle => 'तियांगोंग और हबल';

  @override
  String get satellitesCardHint => 'जब वे आपके शहर के ऊपर से गुज़रते हैं';

  @override
  String get tiangongName => 'तियांगोंग';

  @override
  String get hubbleName => 'हबल';

  @override
  String satNeedsOnline(String name) {
    return '$name दिखाने के लिए Astryl को इंटरनेट से उसका कक्षा-डेटा चाहिए। यह एक बार डाउनलोड होता है और फिर कई दिन बिना इंटरनेट चलता है।';
  }

  @override
  String satPassTitle(String name) {
    return '$name आपके ऊपर से गुज़र रहा है';
  }

  @override
  String get satNote =>
      'स्थितियाँ आपके फ़ोन पर कक्षा-डेटा से निकाली जाती हैं। जब आकाश अँधेरा हो और उपग्रह पर सूरज की रोशनी पड़ रही हो, तब उसे देखना आसान होता है। तियांगोंग चमकीला है, तेज़ चलते तारे जैसा। हबल बहुत धुँधला है, इसलिए दूरबीन (बाइनोकुलर) मदद करती है।';

  @override
  String get newsTitle => 'अंतरिक्ष समाचार';

  @override
  String get newsCardHint => 'अंतरिक्ष समाचार साइटों के ताज़ा लेख';

  @override
  String get newsNeedsOnline =>
      'ताज़ा अंतरिक्ष समाचार पढ़ने के लिए ऑनलाइन सुविधाएँ चालू करें।';

  @override
  String get newsFailed =>
      'समाचार अपडेट नहीं हो सके। सहेजे हुए लेख दिखाए जा रहे हैं।';

  @override
  String get newsNone =>
      'कोई समाचार लोड नहीं हो सका। इंटरनेट जाँचें और फिर कोशिश करें।';

  @override
  String get newsNote =>
      'लेख Spaceflight News API से आते हैं और अंग्रेज़ी में हैं। किसी लेख को छूने पर प्रकाशक की वेबसाइट आपके ब्राउज़र में खुलती है। Astryl कोई तस्वीर डाउनलोड नहीं करता।';

  @override
  String get newsOpenFailed => 'लिंक नहीं खुल सका।';

  @override
  String get tonightShareTitle => 'आज रात का आकाश साझा करें';

  @override
  String get tonightShareHint =>
      'आपके दोस्तों के लिए चाँद और ग्रहों की एक तस्वीर';

  @override
  String tonightShareText(String city) {
    return '$city के ऊपर का आकाश, Astryl से बना, जो मुफ़्त सौरमंडल ऐप है: https://github.com/aditymishr098-collab/astryl';
  }

  @override
  String skyOverCity(String city) {
    return '$city के ऊपर का आकाश';
  }

  @override
  String get cancel => 'रद्द करें';

  @override
  String get backupTitle => 'बैकअप';

  @override
  String get backupNote =>
      'आपके पसंदीदा, सेटिंग्स, क्विज़ स्कोर, शहर और जन्मतिथि एक छोटी फ़ाइल में सेव होते हैं। जब तक आप उसे कहीं भेजें नहीं, वह आपके फ़ोन में ही रहती है। अलग-अलग घटनाओं की घंटियाँ इसमें शामिल नहीं हैं: restore के बाद उन्हें फिर से लगाएँ।';

  @override
  String get backupSave => 'बैकअप सेव करें';

  @override
  String get backupRestore => 'बैकअप restore करें';

  @override
  String get backupShareText => 'Astryl बैकअप';

  @override
  String get backupSaveFailed => 'बैकअप नहीं बन सका।';

  @override
  String get backupRestoreTitle => 'यह बैकअप restore करें?';

  @override
  String get backupRestoreAsk =>
      'इससे इस फ़ोन के पसंदीदा, सेटिंग्स, क्विज़ स्कोर, शहर और जन्मतिथि बदल जाएँगे।';

  @override
  String get backupRestoreConfirm => 'Restore करें';

  @override
  String get backupRestored => 'बैकअप restore हो गया।';

  @override
  String get backupBad => 'यह फ़ाइल Astryl का बैकअप नहीं है।';

  @override
  String get surfaceMapTitle => 'सतह का नक़्शा';

  @override
  String surfaceMapOf(String body) {
    return '$body: सतह का नक़्शा';
  }

  @override
  String get surfaceMapMoonHint =>
      'जहाँ Apollo, Chang\'e, Chandrayaan और दूसरे यान उतरे।';

  @override
  String get surfaceMapMarsHint =>
      'जहाँ Viking, Curiosity, Perseverance और दूसरे lander और rover उतरे।';

  @override
  String get surfaceMapTap =>
      'कहानी पढ़ने के लिए किसी निशान पर दबाइए। Zoom करने के लिए दो उँगलियों से फैलाइए।';

  @override
  String get surfaceMapNote =>
      'यह सरल नक़्शा है, तस्वीर नहीं: बड़े सागर, बेसिन, craters और ज्वालामुखी सही जगह पर बनाए गए हैं, और हर landing site अपने असली अक्षांश और देशांतर पर है।';

  @override
  String get surfaceMapSites => 'उतरने की जगहें';

  @override
  String get siteKindCrewed => 'इंसान उतरे';

  @override
  String get siteKindLander => 'Lander';

  @override
  String get siteKindRover => 'Rover';

  @override
  String get siteKindSample => 'नमूने वापस लाया';

  @override
  String get mapNearSide => 'सामने का हिस्सा';

  @override
  String get mapFarSide => 'पीछे का हिस्सा';

  @override
  String get siteLuna9 =>
      'Luna 9 किसी दूसरी दुनिया पर पहली सॉफ़्ट लैंडिंग करने वाला यान था। उसने चाँद की सतह से खींची पहली तस्वीरें भेजीं।';

  @override
  String get siteSurveyor1 =>
      'Surveyor 1 चाँद पर अमेरिका की पहली सॉफ़्ट लैंडिंग थी। उसने 11,000 से ज़्यादा तस्वीरें भेजीं और दिखाया कि वहाँ की ज़मीन उतरने लायक़ मज़बूत है।';

  @override
  String get siteApollo11 =>
      'चाँद पर पहले इंसान, नील आर्मस्ट्रॉन्ग और बज़ ऑल्ड्रिन, जुलाई 1969 में यहाँ Tranquility Base पर उतरे।';

  @override
  String get siteApollo12 =>
      'Apollo 12 पुराने यान Surveyor 3 के पास उतरा, और यात्री उसके कुछ हिस्से धरती पर ले आए।';

  @override
  String get siteLuna16 =>
      'Luna 16 चाँद की मिट्टी धरती पर लाने वाला पहला रोबोट था, लगभग 100 ग्राम, बिना किसी इंसान के।';

  @override
  String get siteLunokhod1 =>
      'Lunokhod 1 किसी दूसरी दुनिया पर चलने वाला पहला rover था। उसने ग्यारह महीनों में लगभग 10 किमी का सफ़र तय किया।';

  @override
  String get siteApollo14 =>
      'Apollo 14 Fra Mauro की ऊँची ज़मीन पर उतरा। एलन शेपर्ड ने चाँद पर दो golf गेंदें मारीं।';

  @override
  String get siteApollo15 =>
      'Apollo 15 चाँद की गाड़ी (lunar rover) वाला पहला मिशन था, और उसने Apennine पहाड़ों के पास खोज की।';

  @override
  String get siteApollo16 =>
      'Apollo 16 ने rover से Descartes की ऊँची ज़मीन देखी और लगभग 95 किलो पत्थर वापस लाया।';

  @override
  String get siteApollo17 =>
      'दिसंबर 1972 का Apollo 17 अब तक का आख़िरी मिशन है जिसमें इंसान चाँद पर चले। भू-वैज्ञानिक हैरिसन श्मिट चलने वाले दो लोगों में थे।';

  @override
  String get siteChange3 =>
      'चीन के Chang\'e 3 ने दिसंबर 2013 में Yutu rover को चाँद पर उतारा। 1976 के बाद वहाँ यह पहली सॉफ़्ट लैंडिंग थी।';

  @override
  String get siteChange4 =>
      'Chang\'e 4 ने जनवरी 2019 में चाँद के पीछे के हिस्से पर, विशाल दक्षिणी ध्रुव–ऐटकेन बेसिन के अंदर, पहली सॉफ़्ट लैंडिंग की।';

  @override
  String get siteChange5 =>
      'Chang\'e 5 दिसंबर 2020 में चाँद के लगभग 1.7 किलो नमूने लाया, 44 साल में पहली बार नए नमूने।';

  @override
  String get siteChandrayaan3 =>
      'भारत का Chandrayaan-3 23 अगस्त 2023 को चाँद के दक्षिणी ध्रुव के पास उतरा। चाँद पर उतरने वाला भारत चौथा देश बना।';

  @override
  String get siteSlim =>
      'जापान का SLIM जनवरी 2024 में अपने निशाने से लगभग 100 मीटर के भीतर उतरा, यह बहुत सटीक लैंडिंग थी।';

  @override
  String get siteViking1 =>
      'Viking 1 जुलाई 1976 में मंगल पर पहली सफल लैंडिंग करने वाला यान था। उसने छह साल से ज़्यादा सतह पर काम किया।';

  @override
  String get siteViking2 =>
      'Viking 2 सितंबर 1976 में Utopia Planitia में उतरा और लाल ज़मीन पर जमी पाले की तस्वीर खींची।';

  @override
  String get sitePathfinder =>
      'Mars Pathfinder जुलाई 1997 में उतरा और अपने साथ Sojourner लाया, मंगल का पहला rover, जो लगभग microwave के आकार का था।';

  @override
  String get siteSpirit =>
      'Spirit जनवरी 2004 में Gusev crater में उतरा और ऐसे संकेत पाए कि कभी वहाँ पानी ने चट्टानों को आकार दिया था।';

  @override
  String get siteOpportunity =>
      'Opportunity जनवरी 2004 में उतरा और लगभग 15 साल चला, जबकि उसे सिर्फ़ 90 दिन के लिए बनाया गया था।';

  @override
  String get sitePhoenix =>
      'Phoenix मई 2008 में उत्तरी ध्रुव के पास उतरा और पक्का किया कि मिट्टी के ठीक नीचे पानी की बर्फ़ है।';

  @override
  String get siteCuriosity =>
      'Curiosity अगस्त 2012 में Gale crater में उतरा और दिखाया कि वह जगह कभी सूक्ष्म जीवन के लायक़ रही हो सकती है।';

  @override
  String get siteInsight =>
      'InSight नवंबर 2018 में उतरा और सैकड़ों मंगलकंप दर्ज किए, यानी ग्रह के अंदर की आवाज़ सुनी।';

  @override
  String get sitePerseverance =>
      'Perseverance फ़रवरी 2021 में Jezero crater में हेलिकॉप्टर Ingenuity के साथ उतरा, और भविष्य में धरती लाने के लिए चट्टानों के नमूने जमा करता है।';

  @override
  String get siteZhurong =>
      'चीन का Zhurong मई 2021 में उतरा। मंगल पर rover चलाने वाला चीन दूसरा देश बना।';

  @override
  String get featImbrium => 'मेयर इम्ब्रियम (वर्षा का सागर)';

  @override
  String get featSerenitatis => 'मेयर सेरेनिटाटिस (शांति का सागर)';

  @override
  String get featTranquillitatis => 'मेयर ट्रैंक्विलिटाटिस (सुकून का सागर)';

  @override
  String get featCrisium => 'मेयर क्रिसियम (संकटों का सागर)';

  @override
  String get featFecunditatis => 'मेयर फ़ेकंडिटाटिस (उर्वरता का सागर)';

  @override
  String get featNectaris => 'मेयर नेक्टेरिस (अमृत का सागर)';

  @override
  String get featNubium => 'मेयर न्यूबियम (बादलों का सागर)';

  @override
  String get featHumorum => 'मेयर ह्यूमोरम (नमी का सागर)';

  @override
  String get featProcellarum => 'ओशनस प्रोसेलारम (तूफ़ानों का महासागर)';

  @override
  String get featFrigoris => 'मेयर फ़्रिगोरिस (ठंड का सागर)';

  @override
  String get featOrientale => 'ओरिएंटेल बेसिन';

  @override
  String get featAitken => 'दक्षिणी ध्रुव–ऐटकेन बेसिन';

  @override
  String get featTycho => 'टाइको क्रेटर';

  @override
  String get featCopernicus => 'कोपरनिकस क्रेटर';

  @override
  String get featOlympus => 'ओलिंपस मॉन्स';

  @override
  String get featTharsis => 'थार्सिस ज्वालामुखी';

  @override
  String get featValles => 'वैलेस मैरिनेरिस';

  @override
  String get featHellas => 'हेलास प्लैनिशिया';

  @override
  String get featArgyre => 'आर्गायर प्लैनिशिया';

  @override
  String get featUtopia => 'यूटोपिया प्लैनिशिया';

  @override
  String get featIsidis => 'इसिडिस प्लैनिशिया';

  @override
  String get featSyrtis => 'सिर्टिस मेजर';

  @override
  String get featChryse => 'क्राइसी प्लैनिशिया';

  @override
  String get featAcidalia => 'एसिडेलिया प्लैनिशिया';

  @override
  String get featElysium => 'एलीसियम मॉन्स';

  @override
  String get featNorthCap => 'उत्तरी ध्रुवीय बर्फ़';

  @override
  String get featSouthCap => 'दक्षिणी ध्रुवीय बर्फ़';

  @override
  String get acctTitle => 'Astryl खाता';

  @override
  String get acctCreateTitle => 'अपना खाता बनाइए';

  @override
  String get acctIntro =>
      'ज़रूरी नहीं। बस एक username और password, e-mail नहीं। फिर आपके favourites, quiz scores और settings इस app और astryl.space पर आपके साथ चलते हैं।';

  @override
  String get acctTabCreate => 'खाता बनाएँ';

  @override
  String get acctTabLogin => 'Log in';

  @override
  String get acctUsername => 'Username';

  @override
  String get acctUsernameHint => '3 से 20 अक्षर (a से z), अंक या _';

  @override
  String get acctPassword => 'Password';

  @override
  String get acctPasswordHint => 'कम से कम 8 अक्षर';

  @override
  String get acctPasswordAgain => 'Password फिर से';

  @override
  String get acctForgot => 'Password भूल गए?';

  @override
  String get acctRecoverTitle => 'Recovery code से password बदलें';

  @override
  String get acctRecoverCode => 'Recovery code';

  @override
  String get acctRecoverNewPassword => 'नया password';

  @override
  String get acctRecoverButton => 'नया password लगाएँ';

  @override
  String get acctBackToLogin => 'Log in पर वापस';

  @override
  String get acctConsent =>
      'मैंने Privacy Policy पढ़ ली है और मैं इससे सहमत हूँ';

  @override
  String get acctReadPolicy => 'Privacy Policy पढ़ें';

  @override
  String get acctOptionalTitle => 'वैकल्पिक। जब तक आप चालू न करें, सब बंद।';

  @override
  String get acctCountMe => 'मुझे active user में गिनें';

  @override
  String get acctCountMeNote =>
      'इस फ़ोन पर बना एक random number कभी-कभी भेजा जाता है, ताकि Astryl दिखा सके कि कितने लोग इसे इस्तेमाल करते हैं। यह आपसे जुड़ा नहीं होता।';

  @override
  String get acctShareCountry => 'मेरा देश बताएँ';

  @override
  String get acctShareCountryNote =>
      'आपके फ़ोन की भाषा और region setting वाला देश, देशों के chart के लिए।';

  @override
  String get acctShareLocation => 'मेरी अनुमानित location बताएँ';

  @override
  String get acctShareLocationNote =>
      'Account चाहिए। Android की अनुमानित location इस्तेमाल होती है (कुछ किलोमीटर तक)। सिर्फ़ सबसे ताज़ा जगह रखी जाती है, लगभग 10 किमी में गोल करके, और वह app खोलने पर बदलती है।';

  @override
  String get acctSkip => 'अभी छोड़ें';

  @override
  String get acctSkipNote =>
      'खाता आप बाद में Settings में बना सकते हैं। खाते के बिना भी app वैसे ही चलता है।';

  @override
  String get acctCodeTitle => 'आपका recovery code';

  @override
  String get acctCodeWarn =>
      'इसे लिख लीजिए या कहीं सुरक्षित रखिए। Password भूलने पर खाते में वापस आने का यही अकेला रास्ता है। यह 3 बार चलता है।';

  @override
  String get acctCopy => 'Copy करें';

  @override
  String get acctCopied => 'Copy हो गया';

  @override
  String get acctCodeSaved => 'मैंने अपना recovery code सुरक्षित रख लिया है';

  @override
  String get acctContinue => 'आगे बढ़ें';

  @override
  String acctRecovered(int count) {
    return 'Password बदल गया। यह code अब $count बार और चल सकता है।';
  }

  @override
  String acctLoggedInAs(String name) {
    return '$name के रूप में log in';
  }

  @override
  String get acctNotLoggedIn => 'आप log in नहीं हैं।';

  @override
  String get acctSync => 'मेरा data sync करें';

  @override
  String get acctSyncNote =>
      'Favourites, quiz scores, भाषा, theme, शहर और जन्मतिथि आपके खाते में रखे जाते हैं और astryl.space से साझा होते हैं।';

  @override
  String get acctSyncNow => 'अभी sync करें';

  @override
  String get acctSyncOk => 'Sync हो गया';

  @override
  String get acctSyncFailed =>
      'Sync नहीं हो सका। Internet देखकर फिर कोशिश करें।';

  @override
  String get acctSyncing => 'Sync हो रहा है…';

  @override
  String get acctNewCode => 'नया recovery code बनाएँ';

  @override
  String get acctNewCodeNote => 'पुराना code काम करना बंद कर देगा।';

  @override
  String get acctLogOut => 'Log out';

  @override
  String get acctDelete => 'मेरा खाता मिटाएँ';

  @override
  String get acctDeleteNote =>
      'आपका खाता और उससे जुड़ा सारा online data मिट जाता है। इस फ़ोन का data रहता है।';

  @override
  String get acctDeleteConfirmTitle => 'खाता मिटाएँ?';

  @override
  String get acctDeleteConfirmBody =>
      'यह वापस नहीं हो सकता। पक्का करने के लिए अपना password लिखिए।';

  @override
  String get acctDeleteButton => 'मिटाएँ';

  @override
  String get acctDeleted => 'खाता मिट गया।';

  @override
  String get acctCommunity => 'Astryl समुदाय';

  @override
  String acctStatsLine(String registered, String active) {
    return '$registered खाते · पिछले 30 दिनों में $active active';
  }

  @override
  String get acctStatsNote => 'Active यानी वे लोग जिन्होंने गिने जाना चुना है।';

  @override
  String get acctPrivacyLink => 'Privacy Policy';

  @override
  String get acctErrOffline =>
      'Internet नहीं है, या server जवाब नहीं दे रहा। फिर कोशिश करें।';

  @override
  String get acctErrTaken => 'यह username पहले से लिया जा चुका है।';

  @override
  String get acctErrUsername => 'Username: 3 से 20 अक्षर (a से z), अंक या _।';

  @override
  String get acctErrPassword => 'Password: 8 से 72 अक्षर।';

  @override
  String get acctErrMismatch => 'दोनों password एक जैसे नहीं हैं।';

  @override
  String get acctErrLogin => 'Username या password ग़लत है।';

  @override
  String get acctErrRecovery => 'Username या recovery code ग़लत है।';

  @override
  String get acctErrUsedUp => 'यह recovery code 3 बार इस्तेमाल हो चुका है।';

  @override
  String get acctErrLocked => 'बहुत ज़्यादा ग़लत कोशिशें। 15 मिनट रुकिए।';

  @override
  String get acctErrRate => 'बहुत ज़्यादा कोशिशें। थोड़ी देर बाद फिर करें।';

  @override
  String get acctErrGeneric => 'कुछ गड़बड़ हुई। फिर कोशिश करें।';

  @override
  String get acctErrCode => 'Recovery code में 16 अक्षर और अंक होते हैं।';

  @override
  String get myLocation => 'मेरी location';

  @override
  String get useMyLocation => 'मेरी location इस्तेमाल करें';

  @override
  String get locDenied => 'Location की अनुमति नहीं मिली।';

  @override
  String get locOff => 'फ़ोन की settings में location चालू कीजिए।';

  @override
  String get locError => 'आपकी location नहीं मिल सकी। फिर कोशिश करें।';

  @override
  String get settingsAccountSubtitle =>
      'वैकल्पिक। अपना data astryl.space से sync करें।';

  @override
  String get anonymousTitle => 'खाते के बिना';

  @override
  String get spaceMode => 'स्पेस';

  @override
  String get spaceBack => 'पूरा सौर मंडल';

  @override
  String get spaceHint =>
      'घुमाने के लिए खींचें · ज़ूम के लिए पिंच करें · किसी ग्रह पर टैप करके वहाँ पहुँचें · आकार और दूरी पैमाने पर नहीं';

  @override
  String get spacecraftAdityal1 =>
      'भारत (ISRO) की पहली सौर वेधशाला। सूर्य और पृथ्वी के बीच L1 बिंदु (15 लाख किमी) पर रहकर हर समय सूर्य के कोरोना और सौर तूफ़ानों पर नज़र रखती है।';

  @override
  String get uniTitle => 'ब्रह्मांड का नक्शा';

  @override
  String get uniCardHint => 'सूर्य से सबसे दूर की आकाशगंगाओं तक उड़ें';

  @override
  String get uniHint => 'घुमाने के लिए खींचें · ज़ूम के लिए चुटकी · किसी भी चीज़ पर टैप करें';

  @override
  String get uniLevelSolar => 'सौर मंडल';

  @override
  String get uniLevelStars => 'पास के तारे';

  @override
  String get uniLevelMilkyWay => 'आकाशगंगा (मिल्की वे)';

  @override
  String get uniLevelLocal => 'स्थानीय समूह';

  @override
  String get uniLevelGalaxies => 'आकाशगंगाएँ';

  @override
  String get uniLevelUniverse => 'ब्रह्मांड';

  @override
  String get uniGoTo => 'यहाँ जाएँ';

  @override
  String get uniSearchHint => 'तारे, आकाशगंगाएँ, ब्लैक होल खोजें';

  @override
  String get uniNothing => 'कुछ नहीं मिला';

  @override
  String get uniSpeedReal => 'असली समय';

  @override
  String get uniSpeedDay => '1 दिन प्रति सेकंड';

  @override
  String get uniSpeedYear => '1 साल प्रति सेकंड';

  @override
  String get uniSpeedMillion => '10 लाख साल प्रति सेकंड';

  @override
  String get uniSpeedFast => '2.5 करोड़ साल प्रति सेकंड';

  @override
  String get uniNow => 'अभी';

  @override
  String uniAhead(String value) {
    return 'अब से $value बाद';
  }

  @override
  String get uniBackToNow => 'अभी पर लौटें';

  @override
  String get uniSpedUp => 'तेज़ किया गया: असली समय में यह चाल इतनी धीमी है कि दिखती नहीं।';

  @override
  String get uniKindStar => 'तारा';

  @override
  String get uniKindPlanet => 'ग्रह';

  @override
  String get uniKindBlackHole => 'ब्लैक होल';

  @override
  String get uniKindGalaxyCluster => 'आकाशगंगाओं का समूह';

  @override
  String get uniShapeSpiral => 'सर्पिल आकाशगंगा';

  @override
  String get uniShapeBarred => 'दंड-सर्पिल आकाशगंगा';

  @override
  String get uniShapeElliptical => 'दीर्घवृत्ताकार आकाशगंगा';

  @override
  String get uniShapeLenticular => 'लेंसाकार आकाशगंगा';

  @override
  String get uniShapeIrregular => 'अनियमित आकाशगंगा';

  @override
  String get uniDistance => 'पृथ्वी से दूरी';

  @override
  String get uniDistanceNow => 'आज की दूरी';

  @override
  String get uniLightTime => 'इसकी रोशनी ने सफ़र किया';

  @override
  String get uniWidth => 'चौड़ाई';

  @override
  String get uniMass => 'द्रव्यमान';

  @override
  String get uniHorizon => 'घटना क्षितिज की त्रिज्या';

  @override
  String get uniEstimated => 'दूरी इसके रेडशिफ़्ट से आँकी गई है।';

  @override
  String get uniFlyHere => 'यहाँ उड़ें';

  @override
  String uniScreen(String value) {
    return 'स्क्रीन की चौड़ाई ≈ $value';
  }

  @override
  String get uniEdge => 'दिखने वाले ब्रह्मांड का किनारा';

  @override
  String uniLy(String value) {
    return '$value प्रकाश-वर्ष';
  }

  @override
  String uniLyK(String value) {
    return '$value हज़ार प्रकाश-वर्ष';
  }

  @override
  String uniLyM(String value) {
    return '$value मिलियन प्रकाश-वर्ष';
  }

  @override
  String uniLyB(String value) {
    return '$value अरब प्रकाश-वर्ष';
  }

  @override
  String uniDays(String value) {
    return '$value दिन';
  }

  @override
  String uniYr(String value) {
    return '$value साल';
  }

  @override
  String uniYrK(String value) {
    return '$value हज़ार साल';
  }

  @override
  String uniYrM(String value) {
    return '$value मिलियन साल';
  }

  @override
  String uniYrB(String value) {
    return '$value अरब साल';
  }

  @override
  String uniSuns(String value) {
    return '$value सूर्य';
  }

  @override
  String uniSunsM(String value) {
    return '$value मिलियन सूर्य';
  }

  @override
  String uniSunsB(String value) {
    return '$value अरब सूर्य';
  }

  @override
  String issBelowBy(String direction, String degrees) {
    return '$direction, क्षितिज से $degrees° नीचे';
  }

  @override
  String get issLight => 'रोशनी';

  @override
  String get issInSun => 'धूप में';

  @override
  String get issInShadow => 'पृथ्वी की छाया में';

  @override
  String issNextVisible(String wait, String time) {
    return 'अगली आसानी से दिखने वाली उड़ान $wait में, $time बजे';
  }

  @override
  String issNextPass(String wait, String time) {
    return 'अगली उड़ान $wait में, $time बजे';
  }

  @override
  String get issTrackPast => 'जहाँ से आया';

  @override
  String get issTrackNext => 'जहाँ जाएगा';

  @override
  String get issNight => 'पृथ्वी पर रात';

  @override
  String issDataAge(String time) {
    return 'ऑर्बिट डेटा $time पहले का';
  }

  @override
  String issDays(String value) {
    return '$value दिन';
  }

  @override
  String get issOnlyVisible => 'सिर्फ़ आसानी से दिखने वाली उड़ानें';

  @override
  String get issNoVisible => 'अगले 5 दिनों में कोई आसानी से दिखने वाली उड़ान नहीं है।';
}
