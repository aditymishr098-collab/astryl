// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'Heliora';

  @override
  String get tagline => 'సౌర కుటుంబాన్ని అన్వేషించండి, పూర్తిగా ఆఫ్‌లైన్‌లో';

  @override
  String get navExplore => 'అన్వేషించు';

  @override
  String get navCompare => 'పోలిక';

  @override
  String get navWeight => 'బరువు';

  @override
  String get navQuiz => 'క్విజ్';

  @override
  String get viewMode => 'వీక్షణ మోడ్';

  @override
  String get settings => 'సెట్టింగ్‌లు';

  @override
  String get notToScale => 'స్కేల్ ప్రకారం కాదు · తెరవడానికి గ్రహంపై నొక్కండి';

  @override
  String get dragToRotate => 'తిప్పడానికి లాగండి · జూమ్ కోసం పించ్ చేయండి';

  @override
  String get planetsTitle => 'గ్రహాలు';

  @override
  String get planetMercury => 'బుధుడు';

  @override
  String get planetVenus => 'శుక్రుడు';

  @override
  String get planetEarth => 'భూమి';

  @override
  String get planetMars => 'అంగారకుడు';

  @override
  String get planetJupiter => 'బృహస్పతి';

  @override
  String get planetSaturn => 'శని';

  @override
  String get planetUranus => 'యురేనస్';

  @override
  String get planetNeptune => 'నెప్ట్యూన్';

  @override
  String planetOrder(int n) {
    return 'సూర్యుని నుండి గ్రహం సంఖ్య $n';
  }

  @override
  String get openDetails => 'వివరాలు తెరవండి';

  @override
  String get diameter => 'వ్యాసం';

  @override
  String get gravity => 'గురుత్వాకర్షణ';

  @override
  String get avgTemp => 'సగటు ఉష్ణోగ్రత';

  @override
  String get avgTempShort => 'సగటు ఉష్ణం';

  @override
  String get dayLength => 'రోజు';

  @override
  String get yearLength => 'సంవత్సరం';

  @override
  String get moons => 'తెలిసిన చంద్రులు';

  @override
  String get moonsShort => 'చంద్రులు';

  @override
  String get distance => 'సూర్యుని నుండి దూరం';

  @override
  String get pressure => 'ఉపరితల పీడనం';

  @override
  String get noSurface => 'ఘన ఉపరితలం లేదు';

  @override
  String valueKm(String value) {
    return '$value కి.మీ';
  }

  @override
  String valueMillionKm(String value) {
    return '$value మిలియన్ కి.మీ';
  }

  @override
  String valueHours(String value) {
    return '$value గంటలు';
  }

  @override
  String valueDays(String value) {
    return '$value రోజులు';
  }

  @override
  String valueYears(String value) {
    return '$value సంవత్సరాలు';
  }

  @override
  String get atmosphere => 'వాతావరణం';

  @override
  String get thinAtmosphere =>
      'దాదాపు వాతావరణం లేదు. ఈ వాయువులు ఎక్సోస్ఫియర్ అనే చాలా పలుచని పొరను ఏర్పరుస్తాయి.';

  @override
  String get oxygen => 'ఆక్సిజన్';

  @override
  String get oxygenVsEarth => 'ఆక్సిజన్: భూమితో పోలిక';

  @override
  String get breathable => 'మనుషులు శ్వాసించడానికి అనుకూలం';

  @override
  String get notBreathable => 'శ్వాసించడానికి అనుకూలం కాదు, స్పేస్‌సూట్ అవసరం';

  @override
  String weightFeelsLike(String weight) {
    return 'భూమిపై $weight కిలోలు ఇక్కడ ఇంత అనిపిస్తుంది';
  }

  @override
  String get gasCo2 => 'కార్బన్ డయాక్సైడ్';

  @override
  String get gasN2 => 'నైట్రోజన్';

  @override
  String get gasO2 => 'ఆక్సిజన్';

  @override
  String get gasAr => 'ఆర్గాన్';

  @override
  String get gasH2 => 'హైడ్రోజన్';

  @override
  String get gasHe => 'హీలియం';

  @override
  String get gasCh4 => 'మీథేన్';

  @override
  String get gasNa => 'సోడియం';

  @override
  String get gasK => 'పొటాషియం';

  @override
  String get compareTitle => 'గ్రహాల పోలిక';

  @override
  String get compareHint => 'పక్కపక్కనే చూడటానికి రెండు గ్రహాలను ఎంచుకోండి.';

  @override
  String get weightTitle => 'ఇతర గ్రహాలపై మీ బరువు';

  @override
  String get weightInput => 'భూమిపై మీ బరువు (కిలో)';

  @override
  String gravityTimes(String factor) {
    return 'భూమి గురుత్వాకర్షణకు $factor×';
  }

  @override
  String get quizTitle => 'గ్రహ క్విజ్';

  @override
  String get quizIntro =>
      'గ్రహాలు, చంద్రుల గురించి 10 ప్రశ్నలు. మీరు ఎన్ని సరిగ్గా చెప్పగలరు?';

  @override
  String get quizStart => 'క్విజ్ ప్రారంభించండి';

  @override
  String quizProgress(int current, int total) {
    return 'ప్రశ్న $current / $total';
  }

  @override
  String get quizNext => 'తదుపరి';

  @override
  String get quizSeeResult => 'ఫలితం చూడండి';

  @override
  String get quizCorrect => 'సరైనది!';

  @override
  String quizWrong(String answer) {
    return 'కాదు. సరైన జవాబు $answer.';
  }

  @override
  String quizScore(int score, int total) {
    return '$total లో $score సరైనవి';
  }

  @override
  String quizBest(int score) {
    return 'ఉత్తమ స్కోరు: $score';
  }

  @override
  String get quizNewBest => 'కొత్త ఉత్తమ స్కోరు!';

  @override
  String get quizAgain => 'మళ్లీ ఆడండి';

  @override
  String get qLargest => 'అతిపెద్ద గ్రహం ఏది?';

  @override
  String get qSmallest => 'అతిచిన్న గ్రహం ఏది?';

  @override
  String get qHottest => 'అత్యంత వేడి గ్రహం ఏది?';

  @override
  String get qColdest => 'అత్యంత చల్లని గ్రహం ఏది?';

  @override
  String get qMostMoons => 'ఏ గ్రహానికి ఎక్కువ తెలిసిన చంద్రులు ఉన్నారు?';

  @override
  String get qBreathable => 'ఏ గ్రహంపై మనుషులు గాలిని శ్వాసించగలరు?';

  @override
  String get qClosest => 'సూర్యునికి అత్యంత దగ్గరి గ్రహం ఏది?';

  @override
  String get qFarthest => 'సూర్యుని నుండి అత్యంత దూరపు గ్రహం ఏది?';

  @override
  String get qStrongestGravity => 'ఏ గ్రహానికి అత్యధిక గురుత్వాకర్షణ ఉంది?';

  @override
  String get qShortestDay => 'ఏ గ్రహం రోజు అతి తక్కువ?';

  @override
  String get qLongestDay => 'ఏ గ్రహం రోజు అతి పొడవు?';

  @override
  String get appearance => 'రూపం';

  @override
  String get theme => 'థీమ్';

  @override
  String get themeSystem => 'సిస్టమ్';

  @override
  String get themeLight => 'లైట్';

  @override
  String get themeDark => 'డార్క్';

  @override
  String get language => 'భాష';

  @override
  String get appLanguage => 'యాప్ భాష';

  @override
  String get languageNote => '20 భాషలు · గ్రహాల పేర్లు కూడా';

  @override
  String get phoneLanguage => 'ఫోన్ భాష';

  @override
  String get updates => 'అప్‌డేట్‌లు';

  @override
  String get version => 'వెర్షన్';

  @override
  String get checkForUpdates => 'అప్‌డేట్‌ల కోసం చూడండి';

  @override
  String get checking => 'తనిఖీ చేస్తోంది…';

  @override
  String get autoUpdateCheck => 'రోజుకు ఒకసారి ఆటోమేటిక్‌గా చూడండి';

  @override
  String get updateNote =>
      'అప్‌డేట్‌లు GitHub Releases నుండి వస్తాయి. మీ సెట్టింగ్‌లు మీ ఫోన్‌లోనే ఉంటాయి.';

  @override
  String get upToDate => 'మీ దగ్గర తాజా వెర్షన్ ఉంది.';

  @override
  String get updateFailed =>
      'GitHub ని చేరుకోలేకపోయాం. ఇంటర్నెట్ చూసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get updateAvailable => 'అప్‌డేట్ అందుబాటులో ఉంది';

  @override
  String updateReady(String version) {
    return 'వెర్షన్ $version డౌన్‌లోడ్‌కు సిద్ధంగా ఉంది.';
  }

  @override
  String get download => 'డౌన్‌లోడ్';

  @override
  String get later => 'తర్వాత';

  @override
  String get about => 'గురించి';

  @override
  String get sourceCode => 'GitHub లో సోర్స్ కోడ్';

  @override
  String get privacyLine => 'ఆఫ్‌లైన్ · ప్రకటనలు లేవు · ట్రాకింగ్ లేదు';

  @override
  String get dataSource => 'వాస్తవాలు: NASA Planetary Fact Sheet';

  @override
  String get openFailed => 'లింక్ తెరవలేకపోయాం.';

  @override
  String get bodySun => 'సూర్యుడు';

  @override
  String get bodyMoon => 'చంద్రుడు';

  @override
  String get bodyPluto => 'ప్లూటో';

  @override
  String get moonIo => 'అయో';

  @override
  String get moonEuropa => 'యూరోపా';

  @override
  String get moonGanymede => 'గానిమీడ్';

  @override
  String get moonCallisto => 'కాలిస్టో';

  @override
  String get moonTitan => 'టైటాన్';

  @override
  String get moonEnceladus => 'ఎన్సెలాడస్';

  @override
  String get moonTriton => 'ట్రైటాన్';

  @override
  String get kindStar => 'మన నక్షత్రం, సౌర కుటుంబ కేంద్రం';

  @override
  String get kindDwarf => 'మరుగుజ్జు గ్రహం';

  @override
  String moonOf(String planet) {
    return '$planet చంద్రుడు';
  }

  @override
  String get orbitPeriod => 'ఒక పరిభ్రమణం';

  @override
  String distanceFrom(String body) {
    return '$body నుండి దూరం';
  }

  @override
  String get composition => 'ఇది దేనితో తయారైంది';

  @override
  String get noAtmosphere => 'నిజమైన వాతావరణం లేదు, దాదాపు శూన్యం.';

  @override
  String get majorMoons => 'ముఖ్య చంద్రులు';

  @override
  String get lifeTitle => 'మనుషులు ఇక్కడ జీవించగలరా?';

  @override
  String get lifeScoreShort => 'జీవ స్కోరు';

  @override
  String get lifeNote =>
      'ఉష్ణోగ్రత, గాలి పీడనం, ఆక్సిజన్, నీరు, ఉపరితలం, గురుత్వాకర్షణ ఆధారంగా లెక్క. భూమికి 10.';

  @override
  String get water => 'నీరు';

  @override
  String get waterLiquid => 'ద్రవ నీరు';

  @override
  String get waterIce => 'మంచు';

  @override
  String get waterOcean => 'మంచు కింద సముద్రం';

  @override
  String get waterNone => 'నీరు లేదు';

  @override
  String get surface => 'ఉపరితలం';

  @override
  String get solidSurface => 'ఘన ఉపరితలం';

  @override
  String get lifeHome => 'అచ్చం ఇంటిలాగే';

  @override
  String get lifeHard => 'చాలా కష్టం, మూసి ఉన్న స్థావరం, స్పేస్‌సూట్ అవసరం';

  @override
  String get lifeNo => 'మనుషులకు అసాధ్యం';

  @override
  String get downloadInstall => 'డౌన్‌లోడ్ చేసి ఇన్‌స్టాల్ చేయండి';

  @override
  String downloadingPercent(String percent) {
    return 'డౌన్‌లోడ్ అవుతోంది… $percent%';
  }

  @override
  String get installNow => 'ఇన్‌స్టాల్';

  @override
  String get allowInstalls =>
      'తెరిచిన స్క్రీన్‌లో Heliora కు యాప్‌లు ఇన్‌స్టాల్ చేసే అనుమతి ఇవ్వండి, తర్వాత తిరిగి వచ్చి ఇన్‌స్టాల్ నొక్కండి.';

  @override
  String get downloadFailed =>
      'డౌన్‌లోడ్ పూర్తి కాలేదు. ఇంటర్నెట్ చూసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get tryAgain => 'మళ్లీ ప్రయత్నించండి';

  @override
  String get today => 'ఈరోజు';

  @override
  String get play => 'ప్లే';

  @override
  String get pause => 'ఆపు';

  @override
  String get monthBack => '30 రోజుల ముందు';

  @override
  String get monthForward => '30 రోజుల తర్వాత';

  @override
  String get positionsNote =>
      'ఈ తేదీన నిజమైన స్థానాలు · పరిమాణం, దూరం స్కేల్ ప్రకారం కాదు · గ్రహంపై నొక్కండి';

  @override
  String get navYou => 'మీరు';

  @override
  String get ageTitle => 'ఇతర గ్రహాలపై మీ వయసు';

  @override
  String get setBirthDate => 'మీ పుట్టిన తేదీ ఇవ్వండి';

  @override
  String get changeBirthDate => 'మార్చు';

  @override
  String nextBirthday(String days) {
    return 'తదుపరి పుట్టినరోజు $days రోజుల్లో';
  }

  @override
  String get ageNote => 'మీ పుట్టిన తేదీ ఈ ఫోన్‌లో మాత్రమే సేవ్ అవుతుంది.';

  @override
  String get share => 'షేర్ చేయండి';

  @override
  String shareText(String planet) {
    return 'Heliora లో $planet, ఉచిత ఆఫ్‌లైన్ సౌర కుటుంబ యాప్: https://github.com/lumio-apps/heliora';
  }

  @override
  String get shareFailed => 'చిత్రాన్ని షేర్ చేయలేకపోయాం.';

  @override
  String get travelTitle => 'ఎంత దూరం?';

  @override
  String get distanceFromEarth => 'ఈరోజు భూమి నుండి దూరం';

  @override
  String get lightTime => 'కాంతికి పట్టే సమయం';

  @override
  String get bySpacecraft => 'గంటకు 60,000 కి.మీ అంతరిక్ష నౌకలో';

  @override
  String get byCar => 'గంటకు 100 కి.మీ కారులో';

  @override
  String valueSeconds(String value) {
    return '$value సె';
  }

  @override
  String valueMinutes(String value) {
    return '$value నిమి';
  }

  @override
  String get sizeTitle => 'పరిమాణం';

  @override
  String sizeTimes(String big, String times, String small) {
    return '$big వెడల్పులో $small కంటే $times× పెద్దది.';
  }

  @override
  String sizeSimilar(String a, String b) {
    return '$a, $b దాదాపు ఒకే పరిమాణం.';
  }

  @override
  String get navSky => 'ఆకాశం';

  @override
  String get skyTitle => 'ఈరాత్రి ఆకాశం';

  @override
  String get chooseCity => 'మీ నగరాన్ని ఎంచుకోండి';

  @override
  String get chooseCityHint =>
      'చంద్రుడిని, ఈరాత్రి కనిపించే గ్రహాలను చూడటానికి దగ్గరి నగరాన్ని ఎంచుకోండి. లొకేషన్ అనుమతి అవసరం లేదు, ఇది ఫోన్‌లోనే ఉంటుంది.';

  @override
  String get searchCity => 'నగరం వెతకండి';

  @override
  String get noCityFound => 'నగరం దొరకలేదు';

  @override
  String get cityNote =>
      'సమయం మీ ఫోన్ టైమ్ జోన్‌లో ఉంది. చీకటి ఆకాశంలో క్షితిజం నుండి కనీసం 5° పైన ఉంటే గ్రహం కనిపిస్తుందని లెక్క.';

  @override
  String illuminated(String percent) {
    return '$percent% వెలుగు';
  }

  @override
  String get moonrise => 'చంద్రోదయం';

  @override
  String get moonset => 'చంద్రాస్తమయం';

  @override
  String get sunset => 'సూర్యాస్తమయం';

  @override
  String get sunrise => 'సూర్యోదయం';

  @override
  String get nextFull => 'తదుపరి పౌర్ణమి';

  @override
  String get nextNew => 'తదుపరి అమావాస్య';

  @override
  String get phaseNew => 'అమావాస్య';

  @override
  String get phaseWaxingCrescent => 'పెరుగుతున్న నెలవంక';

  @override
  String get phaseFirstQuarter => 'శుక్ల అష్టమి';

  @override
  String get phaseWaxingGibbous => 'పెరుగుతున్న చంద్రుడు';

  @override
  String get phaseFull => 'పౌర్ణమి';

  @override
  String get phaseWaningGibbous => 'తరుగుతున్న చంద్రుడు';

  @override
  String get phaseLastQuarter => 'కృష్ణ అష్టమి';

  @override
  String get phaseWaningCrescent => 'తరుగుతున్న నెలవంక';

  @override
  String get planetsTonight => 'ఈరాత్రి గ్రహాలు';

  @override
  String get statusVisible => 'ఈరాత్రి కనిపిస్తుంది';

  @override
  String get statusEvening => 'సాయంత్రం, సూర్యాస్తమయం తర్వాత';

  @override
  String get statusMorning => 'ఉదయం, సూర్యోదయానికి ముందు';

  @override
  String get statusNotVisible => 'ఈరాత్రి కనిపించదు';

  @override
  String bestAt(String time) {
    return 'ఉత్తమ సమయం $time';
  }

  @override
  String altitudeDir(String direction, String degrees) {
    return '$direction, $degrees° ఎత్తులో';
  }

  @override
  String riseSet(String rise, String set) {
    return 'ఉదయం $rise · అస్తమయం $set';
  }

  @override
  String get needsTelescope => 'బైనాక్యులర్ లేదా టెలిస్కోప్ అవసరం';

  @override
  String get dirN => 'ఉత్తరం';

  @override
  String get dirNE => 'ఈశాన్యం';

  @override
  String get dirE => 'తూర్పు';

  @override
  String get dirSE => 'ఆగ్నేయం';

  @override
  String get dirS => 'దక్షిణం';

  @override
  String get dirSW => 'నైరుతి';

  @override
  String get dirW => 'పడమర';

  @override
  String get dirNW => 'వాయువ్యం';

  @override
  String get findPlanet => 'ఆకాశంలో వెతకండి';

  @override
  String finderTitle(String name) {
    return '$name వెతకండి';
  }

  @override
  String get pointPhone => 'ఫోన్‌ను పైకెత్తి నెమ్మదిగా తిప్పండి.';

  @override
  String turnRight(String degrees) {
    return '$degrees° కుడివైపు తిరగండి';
  }

  @override
  String turnLeft(String degrees) {
    return '$degrees° ఎడమవైపు తిరగండి';
  }

  @override
  String tiltUp(String degrees) {
    return '$degrees° పైకి ఎత్తండి';
  }

  @override
  String tiltDown(String degrees) {
    return '$degrees° కిందకు దించండి';
  }

  @override
  String onTarget(String name) {
    return '$name సరిగ్గా అక్కడే ఉంది!';
  }

  @override
  String belowHorizon(String name) {
    return '$name ఇప్పుడు క్షితిజం కింద ఉంది.';
  }

  @override
  String risesAt(String time) {
    return 'ఇది $timeకి ఉదయిస్తుంది.';
  }

  @override
  String get noSensor =>
      'ఈ ఫోన్‌లో దిక్సూచి సెన్సర్ లేదు, కాబట్టి ఫైండర్ పనిచేయదు.';

  @override
  String get calibrate =>
      'దిక్సూచిని క్యాలిబ్రేట్ చేయాలి: ఫోన్‌ను కొన్నిసార్లు 8 ఆకారంలో తిప్పండి.';

  @override
  String get phoneNow => 'మీ ఫోన్ చూపుతున్న దిశ';

  @override
  String get finderNote =>
      'ఫోన్ వెనుక భాగాన్ని ఆకాశం వైపు ఉంచి, అయస్కాంతాలకు, లోహానికి దూరంగా ఉంచండి. సూర్యుడిని ఎప్పుడూ చూడకండి.';

  @override
  String get eventsTitle => 'అంతరిక్ష సంఘటనలు';

  @override
  String get eventsSubtitle => 'రాబోయే 12 నెలల్లో ఆకాశంలో ఏం చూడాలి.';

  @override
  String eventsNext(String event, String when) {
    return 'తదుపరి: $event · $when';
  }

  @override
  String get eventFullMoon => 'పౌర్ణమి';

  @override
  String get eventNewMoon => 'అమావాస్య';

  @override
  String eventOpposition(String planet) {
    return '$planet ప్రతియుతిలో';
  }

  @override
  String eventEveningElongation(String planet) {
    return '$planet: సాయంత్రం చూడటానికి ఉత్తమ సమయం';
  }

  @override
  String eventMorningElongation(String planet) {
    return '$planet: ఉదయం చూడటానికి ఉత్తమ సమయం';
  }

  @override
  String eventConjunction(String a, String b) {
    return '$a, $b దగ్గరగా వస్తాయి';
  }

  @override
  String get eventMarchEquinox => 'మార్చి విషువం';

  @override
  String get eventJuneSolstice => 'జూన్ అయనాంతం';

  @override
  String get eventSeptemberEquinox => 'సెప్టెంబర్ విషువం';

  @override
  String get eventDecemberSolstice => 'డిసెంబర్ అయనాంతం';

  @override
  String get eventFullMoonDesc =>
      'చంద్రుడి ముఖం మొత్తం వెలుగుతుంది. సూర్యాస్తమయం సమయంలో ఉదయిస్తుంది.';

  @override
  String get eventNewMoonDesc =>
      'చంద్రుడు కనిపించడు. నక్షత్రాలు, గ్రహాలు చూడటానికి నెలలో అత్యంత చీకటి ఆకాశం.';

  @override
  String eventOppositionDesc(String planet) {
    return '$planet సూర్యుడికి సరిగ్గా ఎదురుగా ఉంది. ఈ ఏడాది ఇది అత్యంత ప్రకాశవంతంగా ఉంటుంది, రాత్రంతా కనిపిస్తుంది.';
  }

  @override
  String eventEveningDesc(String planet, String degrees) {
    return '$planet సూర్యుడి నుండి $degrees° దూరంలో, అత్యధిక దూరంలో ఉంది. సూర్యాస్తమయం తర్వాత పడమర దిగువన చూడండి.';
  }

  @override
  String eventMorningDesc(String planet, String degrees) {
    return '$planet సూర్యుడి నుండి $degrees° దూరంలో, అత్యధిక దూరంలో ఉంది. సూర్యోదయానికి ముందు తూర్పు దిగువన చూడండి.';
  }

  @override
  String eventConjunctionDesc(String degrees) {
    return 'ఆకాశంలో ఇవి కేవలం $degrees° దూరంలో దాటుతాయి.';
  }

  @override
  String get eventEquinoxDesc =>
      'భూమి మీద అన్ని చోట్ల పగలు, రాత్రి దాదాపు సమానం.';

  @override
  String get eventJuneSolsticeDesc =>
      'ఉత్తరంలో అత్యంత పొడవైన పగలు, దక్షిణంలో అత్యంత చిన్న పగలు.';

  @override
  String get eventDecemberSolsticeDesc =>
      'ఉత్తరంలో అత్యంత చిన్న పగలు, దక్షిణంలో అత్యంత పొడవైన పగలు.';

  @override
  String eventMeteorShower(String shower) {
    return '$shower ఉల్కావర్షం';
  }

  @override
  String eventMeteorDesc(String rate, String percent) {
    return 'చీకటి ఆకాశంలో గంటకు సుమారు $rate వరకు ఉల్కలు. చంద్రుడు $percent% వెలుగుతూ ఉంటాడు.';
  }

  @override
  String get showerQuadrantids => 'క్వాడ్రాంటిడ్స్';

  @override
  String get showerLyrids => 'లైరిడ్స్';

  @override
  String get showerEtaAquariids => 'ఈటా అక్వేరిడ్స్';

  @override
  String get showerPerseids => 'పెర్సీడ్స్';

  @override
  String get showerOrionids => 'ఓరియోనిడ్స్';

  @override
  String get showerLeonids => 'లియోనిడ్స్';

  @override
  String get showerGeminids => 'జెమినిడ్స్';

  @override
  String get showerUrsids => 'అర్సిడ్స్';

  @override
  String get eventToday => 'ఈ రోజు';

  @override
  String get eventTomorrow => 'రేపు';

  @override
  String eventInDays(String days) {
    return '$days రోజుల్లో';
  }

  @override
  String get eventsNote =>
      'తేదీలు మీ ఫోన్‌లోనే లెక్కించి దాని టైమ్ జోన్‌లో చూపిస్తారు. ఉల్కావర్షం గరిష్ఠ రోజులు ప్రతి సంవత్సరం సాధారణ రోజులు, ఒక రోజు అటూ ఇటూ కావచ్చు. రిమైండర్లు మీ ఫోన్‌లోనే ఉంటాయి.';

  @override
  String get remindMe => 'నాకు గుర్తు చేయండి';

  @override
  String reminderSet(String date) {
    return 'సరే, $date న మీకు గుర్తు చేస్తాను.';
  }

  @override
  String get reminderOff => 'రిమైండర్ తొలగించబడింది.';

  @override
  String get reminderTooLate =>
      'ఈ సంఘటన చాలా దగ్గరగా ఉంది, రిమైండర్ పెట్టలేము.';

  @override
  String get notificationsOff =>
      'Heliora నోటిఫికేషన్లు ఆఫ్‌లో ఉన్నాయి. Android సెట్టింగ్‌లలో ఆన్ చేయండి.';

  @override
  String get reminderTomorrow => 'రేపు జరుగుతుంది';

  @override
  String get reminderToday => 'ఈ రోజు జరుగుతోంది';

  @override
  String get onlineTitle => 'ఆన్‌లైన్ సౌకర్యాలు';

  @override
  String get onlineSubtitle =>
      'అంతరిక్ష కేంద్రం, రాకెట్ ప్రయోగాలను చూపించండి. అప్పుడు Heliora wheretheiss.at, Celestrak, Launch Library 2 లతో మాత్రమే సంప్రదిస్తుంది; అవి మీ ఫోన్ ఇంటర్నెట్ చిరునామాను చూడగలవు. ఇంకేమీ పంపబడదు. మొదట ఆఫ్‌లో ఉంటుంది.';

  @override
  String get turnOnOnline => 'ఆన్‌లైన్ సౌకర్యాలను ఆన్ చేయండి';

  @override
  String get issTitle => 'అంతరిక్ష కేంద్రం';

  @override
  String get issCardHint => 'ఇప్పుడు ఎక్కడ ఉంది, మీ పైనుంచి ఎప్పుడు వెళ్తుంది';

  @override
  String get issNeedsOnline =>
      'కేంద్రాన్ని చూపడానికి Heliora కు ఇంటర్నెట్ నుండి దాని కక్ష్య డేటా కావాలి. ఒకసారి డౌన్‌లోడ్ అయితే కొన్ని రోజులు ఆఫ్‌లైన్‌లో పనిచేస్తుంది.';

  @override
  String get issLoading => 'కక్ష్య డేటా తెస్తోంది…';

  @override
  String get issFailed =>
      'కక్ష్య డేటా దొరకలేదు. ఇంటర్నెట్ చూసి మళ్లీ ప్రయత్నించండి.';

  @override
  String issStale(String days) {
    return 'కక్ష్య డేటా $days రోజుల పాతది, కాబట్టి స్థానం కొంచెం తప్పు కావచ్చు. కొత్తది తెచ్చుకోడానికి ఇంటర్నెట్‌కు కనెక్ట్ చేయండి.';
  }

  @override
  String get issHeight => 'ఎత్తు';

  @override
  String get issSpeed => 'వేగం';

  @override
  String get issFromYou => 'మీ నుండి దూరం';

  @override
  String valueKmh(String value) {
    return '$value కిమీ/గం';
  }

  @override
  String issAboveHorizon(String direction, String degrees) {
    return 'ఇప్పుడు మీ క్షితిజం పైన ఉంది! $direction వైపు చూడండి, $degrees° ఎత్తులో.';
  }

  @override
  String get issBelowHorizon => 'ఇప్పుడు మీ క్షితిజం కింద ఉంది.';

  @override
  String issPassesTitle(String city) {
    return '$city పైనుంచి తదుపరి ప్రయాణాలు';
  }

  @override
  String get issNoPasses => 'తదుపరి 5 రోజుల్లో మంచి ప్రయాణాలు లేవు.';

  @override
  String issMaxHigh(String degrees) {
    return '$degrees° వరకు ఎత్తు';
  }

  @override
  String issFromTo(String start, String end) {
    return '$start నుండి $end వరకు';
  }

  @override
  String get issVisible => 'సులభంగా కనిపిస్తుంది';

  @override
  String get issHidden => 'చూడటం కష్టం';

  @override
  String get issPassTitle => 'అంతరిక్ష కేంద్రం మీ పైనుంచి వెళ్తోంది';

  @override
  String issPassBody(String degrees, String direction) {
    return '10 నిమిషాల్లో ఉదయిస్తుంది, $degrees° వరకు ఎత్తు. $direction వైపు చూడండి.';
  }

  @override
  String get issNote =>
      'స్థానాలు మీ ఫోన్‌లోనే కేంద్రం కక్ష్య డేటా నుండి లెక్కించబడతాయి. ఆకాశం చీకటిగా ఉండి కేంద్రంపై సూర్యకాంతి పడినప్పుడు సులభంగా కనిపిస్తుంది: మెరుస్తున్న, వేగంగా కదిలే నక్షత్రంలా.';

  @override
  String get launchesNeedOnline =>
      'రాబోయే రాకెట్ ప్రయోగాలను ఇక్కడ చూడటానికి ఆన్‌లైన్ సౌకర్యాలను ఆన్ చేయండి.';

  @override
  String get launchesFailed =>
      'ప్రయోగ జాబితాను అప్‌డేట్ చేయలేకపోయాం. సేవ్ చేసిన జాబితా చూపుతున్నాం.';

  @override
  String get launchesNote =>
      'ప్రయోగ సమయాలు Launch Library 2 నుండి వస్తాయి, తరచూ మారతాయి. పేర్లు, ప్రదేశాలు ఇంగ్లీషులో ఉన్నాయి.';

  @override
  String get launchReminderBody => 'సుమారు ఒక గంటలో ప్రయోగం. సమయం మారవచ్చు.';

  @override
  String get launchTimeTbd => 'సమయం ఇంకా నిర్ణయం కాలేదు';

  @override
  String get quizChoose => 'స్థాయిని ఎంచుకోండి';

  @override
  String get levelEasy => 'సులభం';

  @override
  String get levelMedium => 'మధ్యస్థం';

  @override
  String get levelHard => 'కఠినం';

  @override
  String get levelEasyHint => 'గ్రహాల గురించి ప్రాథమిక విషయాలు';

  @override
  String get levelMediumHint => 'గ్రహాలు మరియు చంద్రులు';

  @override
  String get levelHardHint => 'కష్టమైన పోలికలు మరియు వరుస';

  @override
  String get qStar => 'వీటిలో ఏది నక్షత్రం, గ్రహం కాదు?';

  @override
  String get qDwarf => 'వీటిలో ఏది మరుగుజ్జు గ్రహం?';

  @override
  String get qMoonVisited => 'ఏ చంద్రుడిపై మనుషులు నడిచారు?';

  @override
  String get qLargestMoon => 'ఈ చంద్రులలో అతి పెద్దది ఏది?';

  @override
  String get qSmallestMoon => 'ఈ చంద్రులలో అతి చిన్నది ఏది?';

  @override
  String get qThickAirMoon => 'ఈ చంద్రులలో దేనికి దట్టమైన వాతావరణం ఉంది?';

  @override
  String get qGeyserMoon =>
      'ఏ చంద్రుడు నీటి ఫౌంటెన్లను అంతరిక్షంలోకి చిమ్ముతాడు?';

  @override
  String get qVolcanicMoon =>
      'ఏ చంద్రుడిపై అత్యధిక చురుకైన అగ్నిపర్వతాలు ఉన్నాయి?';

  @override
  String get qBackwardsMoon => 'ఏ చంద్రుడు తన గ్రహం చుట్టూ వెనుకకు తిరుగుతాడు?';

  @override
  String get qBiggestRocky => 'నాలుగు రాతి గ్రహాలలో అతి పెద్దది ఏది?';

  @override
  String get qColdestRocky => 'నాలుగు రాతి గ్రహాలలో అతి చల్లనిది ఏది?';

  @override
  String get qHighestPressure => 'ఏ గ్రహం ఉపరితలంపై గాలి పీడనం అత్యధికం?';

  @override
  String get qSecondLargest => 'ఏ గ్రహం రెండో అతి పెద్దది?';

  @override
  String get qLongestYear => 'ఏ గ్రహానికి అతి పొడవైన సంవత్సరం ఉంది?';

  @override
  String get qShortestYear => 'ఏ గ్రహానికి అతి చిన్న సంవత్సరం ఉంది?';

  @override
  String get qSmallestGiant => 'నాలుగు భారీ గ్రహాలలో అతి చిన్నది ఏది?';

  @override
  String get qRockyLongestYear =>
      'నాలుగు రాతి గ్రహాలలో దేనికి అతి పొడవైన సంవత్సరం ఉంది?';

  @override
  String get qFastestMoon =>
      'ఈ చంద్రులలో ఏది తన గ్రహం చుట్టూ అతి వేగంగా తిరుగుతుంది?';

  @override
  String get qSlowestMoon =>
      'ఈ చంద్రులలో ఏది తన గ్రహం చుట్టూ తిరగడానికి అతి ఎక్కువ సమయం తీసుకుంటుంది?';

  @override
  String get qStrongestMoonGravity =>
      'ఈ చంద్రులలో దేని గురుత్వాకర్షణ అత్యధికం?';

  @override
  String get qColdestMoon => 'ఈ చంద్రులలో అతి చల్లనిది ఏది?';

  @override
  String get qSecondLargestMoon => 'ఈ చంద్రులలో రెండో అతి పెద్దది ఏది?';

  @override
  String get factTitle => 'మీకు తెలుసా?';

  @override
  String get factTap => 'మరో విషయం చూడటానికి తాకండి';

  @override
  String get factSun1 =>
      'సౌరకుటుంబం మొత్తం ద్రవ్యరాశిలో 99.8% సూర్యుడిలోనే ఉంది.';

  @override
  String get factSun2 =>
      'సూర్యకాంతి భూమిని చేరడానికి సుమారు 8 నిమిషాల 20 సెకన్లు పడుతుంది.';

  @override
  String get factMercury1 =>
      'బుధుడిపై ఒక రోజు, అంటే ఒక సూర్యోదయం నుండి మరో సూర్యోదయం వరకు, సుమారు 176 భూమి రోజులు. అది దాని సంవత్సరం కంటే రెట్టింపు పొడవు.';

  @override
  String get factMercury2 =>
      'బుధుడిపై గాలి దాదాపు లేదు, అందుకే పగటిపూట కూడా దాని ఆకాశం నల్లగా ఉంటుంది, రాత్రులు గడ్డకట్టేంత చల్లగా ఉంటాయి.';

  @override
  String get factVenus1 =>
      'శుక్రుడు వెనుకకు తిరుగుతాడు, అందుకే అక్కడ సూర్యుడు పడమర ఉదయిస్తాడు.';

  @override
  String get factVenus2 =>
      'సూర్యుడికి ఎక్కువ దూరంగా ఉన్నా శుక్రుడు బుధుడి కంటే వేడిగా ఉంటాడు, ఎందుకంటే దాని దట్టమైన గాలి వేడిని బంధిస్తుంది.';

  @override
  String get factEarth1 =>
      'జీవం ఉందని మనకు తెలిసిన ఏకైక చోటు భూమి, దాని ఉపరితలంలో సుమారు 71% నీటితో కప్పబడి ఉంది.';

  @override
  String get factEarth2 =>
      'భూమి పరిపూర్ణమైన బంతి కాదు. తిరగడం వల్ల భూమధ్యరేఖ వద్ద కొంచెం ఉబ్బి ఉంటుంది.';

  @override
  String get factMars1 =>
      'అంగారకుడిపై ఒలింపస్ మాన్స్ సౌరకుటుంబంలోనే అతి ఎత్తైన అగ్నిపర్వతం, ఎవరెస్ట్ శిఖరం కంటే సుమారు రెండున్నర రెట్లు ఎత్తు.';

  @override
  String get factMars2 => 'అంగారకుడిపై సూర్యాస్తమయాలు నీలంగా కనిపిస్తాయి.';

  @override
  String get factJupiter1 =>
      'బృహస్పతి ద్రవ్యరాశి మిగతా అన్ని గ్రహాల మొత్తం ద్రవ్యరాశి కంటే రెట్టింపుకు మించి ఉంది.';

  @override
  String get factJupiter2 =>
      'గ్రేట్ రెడ్ స్పాట్ భూమి కంటే పెద్ద తుఫాను, దీనిని ప్రజలు 150 ఏళ్లకు పైగా గమనిస్తున్నారు.';

  @override
  String get factSaturn1 =>
      'శని తన పరిమాణానికి చాలా తేలికైనది; తగినంత పెద్ద స్నానపు తొట్టి దొరికితే అది నీటిపై తేలుతుంది.';

  @override
  String get factSaturn2 =>
      'శని వలయాలు చాలా వెడల్పైనవి కానీ చాలా పలుచనివి: కొన్ని చోట్ల సుమారు పది మీటర్ల మందం మాత్రమే.';

  @override
  String get factUranus1 =>
      'యురేనస్ పక్కకు దొర్లుతూ సూర్యుడి చుట్టూ తిరుగుతుంది, దాని అక్షం సుమారు 98 డిగ్రీలు వంగి ఉంది.';

  @override
  String get factUranus2 =>
      'దూరదర్శినితో కనుగొన్న మొదటి గ్రహం యురేనస్. విలియం హర్షెల్ దానిని 1781లో గుర్తించారు.';

  @override
  String get factNeptune1 =>
      'ఏ గ్రహంలోనైనా కంటే నెప్ట్యూన్‌పై గాలులు వేగవంతమైనవి, గంటకు 2,000 కి.మీ.కు పైగా.';

  @override
  String get factNeptune2 =>
      'ఎవరైనా చూడకముందే నెప్ట్యూన్ గణితంతో కనుగొనబడింది: 1846లో ఖగోళశాస్త్రజ్ఞులు అది ఎక్కడ ఉండాలో లెక్కించారు.';

  @override
  String get factMoon1 =>
      'చంద్రుడు ప్రతి సంవత్సరం భూమి నుండి సుమారు 3.8 సెంటీమీటర్లు మరింత దూరం జరుగుతున్నాడు.';

  @override
  String get factMoon2 =>
      'మనకు చంద్రుడి ఒకే వైపు ఎప్పుడూ కనిపిస్తుంది, ఎందుకంటే భూమిని ఒకసారి చుట్టి రావడంలో అతను సరిగ్గా ఒకసారి తనచుట్టూ తిరుగుతాడు.';

  @override
  String get factPluto1 => 'ప్లూటోపై ఒక సంవత్సరం సుమారు 248 భూమి సంవత్సరాలు.';

  @override
  String get factPluto2 =>
      'ప్లూటోపై గడ్డకట్టిన నైట్రోజన్‌తో ఏర్పడిన గుండె ఆకారపు పెద్ద మైదానం ఉంది.';

  @override
  String get factIo1 =>
      'మనకు తెలిసిన అత్యధిక అగ్నిపర్వతాలున్న లోకం అయో, అక్కడ వందలాది చురుకైన అగ్నిపర్వతాలు ఉన్నాయి.';

  @override
  String get factIo2 =>
      'బృహస్పతి గురుత్వాకర్షణ అయోను నొక్కి లాగుతుంది, దాని వల్ల పుట్టే వేడి దాని అగ్నిపర్వతాలకు శక్తినిస్తుంది.';

  @override
  String get factEuropa1 =>
      'మంచు పొర కింద యూరోపాలో బహుశా భూమిలోని అన్ని మహాసముద్రాల కంటే సుమారు రెట్టింపు నీరు ఉంది.';

  @override
  String get factEuropa2 =>
      'భూమికి ఆవల జీవాన్ని వెతకడానికి అత్యుత్తమ చోట్లలో యూరోపా ఒకటి. యూరోపా క్లిప్పర్ వ్యోమనౌక అక్కడికి వెళ్తోంది.';

  @override
  String get factGanymede1 =>
      'గానిమీడ్ సౌరకుటుంబంలో అతి పెద్ద చంద్రుడు. అది బుధుడి కంటే కూడా పెద్దది.';

  @override
  String get factGanymede2 =>
      'సొంత అయస్కాంత క్షేత్రం ఉన్నట్లు తెలిసిన ఏకైక చంద్రుడు గానిమీడ్.';

  @override
  String get factCallisto1 =>
      'కాలిస్టో సౌరకుటుంబంలో అత్యధిక బిలాలున్న చోట్లలో ఒకటి, దాని ఉపరితలం చాలా పురాతనమైనది.';

  @override
  String get factCallisto2 =>
      'కాలిస్టో బృహస్పతికి తగినంత దూరంలో ఉండటం వల్ల దాని తీవ్ర వికిరణం తక్కువగా తగులుతుంది, అందుకే శాస్త్రవేత్తలు భవిష్యత్ స్థావరానికి దీన్ని సూచించారు.';

  @override
  String get factTitan1 =>
      'దట్టమైన వాతావరణం ఉన్న ఏకైక చంద్రుడు టైటాన్. దాని ఉపరితలంపై గాలి పీడనం భూమి కంటే ఎక్కువ.';

  @override
  String get factTitan2 =>
      'టైటాన్‌పై నదులు, సరస్సులు ఉన్నాయి, కానీ వాటిలో నీరు కాదు, ద్రవ మీథేన్, ఈథేన్ ఉన్నాయి.';

  @override
  String get factEnceladus1 =>
      'ఎన్సెలాడస్ తన దక్షిణ ధ్రువం దగ్గరి పగుళ్ల నుండి మంచు, నీటి ఆవిరి ధారలను అంతరిక్షంలోకి చిమ్ముతుంది.';

  @override
  String get factEnceladus2 => 'ఎన్సెలాడస్ ఈ ధారలు శని E వలయాన్ని నింపుతాయి.';

  @override
  String get factTriton1 =>
      'ట్రైటాన్ నెప్ట్యూన్ చుట్టూ వెనుకకు తిరుగుతుంది, కాబట్టి అది నెప్ట్యూన్ పట్టుకున్న మరుగుజ్జు గ్రహం అయి ఉండవచ్చు.';

  @override
  String get factTriton2 =>
      'సుమారు −235 °C వద్ద, సౌరకుటుంబంలో ఉష్ణోగ్రత కొలిచిన అత్యంత చల్లని చోట్లలో ట్రైటాన్ ఒకటి.';

  @override
  String get jumpInput => 'భూమిపై మీ దూకు ఎత్తు (సెం.మీ)';

  @override
  String jumpHigh(String height) {
    return 'దూకు: $height';
  }

  @override
  String jumpFeelsLike(String height) {
    return 'భూమిపై $height దూకు ఇక్కడ అవుతుంది';
  }

  @override
  String get jumpNote =>
      'నెట్టే బలం భూమిపై ఉన్నంతే. సూర్యుడిపై, వాయు భారీ గ్రహాలపై నిలబడటానికి నేలే లేదు, కాబట్టి ఇది కేవలం ఊహల ఆట.';

  @override
  String valueCm(String value) {
    return '$value సెం.మీ';
  }

  @override
  String valueM(String value) {
    return '$value మీ';
  }

  @override
  String get eclipseTotalLunar => 'సంపూర్ణ చంద్రగ్రహణం';

  @override
  String get eclipsePartialLunar => 'పాక్షిక చంద్రగ్రహణం';

  @override
  String get eclipsePenumbralLunar => 'ఉపఛాయా చంద్రగ్రహణం';

  @override
  String get eclipseTotalSolar => 'సంపూర్ణ సూర్యగ్రహణం';

  @override
  String get eclipseAnnularSolar => 'కంకణ సూర్యగ్రహణం';

  @override
  String get eclipseHybridSolar => 'సంకర సూర్యగ్రహణం';

  @override
  String get eclipsePartialSolar => 'పాక్షిక సూర్యగ్రహణం';

  @override
  String get eclipseTotalLunarDesc =>
      'చంద్రుడు పూర్తిగా భూమి నీడలోకి వెళ్తాడు, తరచుగా మసక ఎరుపుగా కనిపిస్తాడు. భూమి రాత్రి వైపు ఉన్న అందరూ దీన్ని చూడవచ్చు, కళ్లతో చూడటం సురక్షితం.';

  @override
  String eclipsePartialLunarDesc(String percent) {
    return 'చంద్రుడిలో ఒక భాగం (వెడల్పులో $percent%) భూమి చీకటి నీడలోకి వెళ్తుంది. కళ్లతో చూడటం సురక్షితం.';
  }

  @override
  String get eclipsePenumbralLunarDesc =>
      'చంద్రుడు భూమి మసక బయటి నీడ గుండా వెళ్తాడు. కొంచెం మాత్రమే మసకబారుతాడు, అందువల్ల గమనించడం కష్టం.';

  @override
  String get eclipseTotalSolarDesc =>
      'భూమిపై ఒక ఇరుకైన మార్గంలో చంద్రుడు సూర్యుడిని పూర్తిగా కప్పేస్తాడు. ఆ మార్గం బయట పాక్షిక గ్రహణం కనిపిస్తుంది.';

  @override
  String get eclipseAnnularSolarDesc =>
      'చంద్రుడు కొంచెం దూరంగా ఉండటంతో సూర్యుడిని పూర్తిగా కప్పలేడు, మెరిసే ఉంగరం మిగులుతుంది. ఉంగరం ఇరుకైన మార్గంలో కనిపిస్తుంది; దాని బయట గ్రహణం పాక్షికం.';

  @override
  String get eclipseHybridSolarDesc =>
      'తన మార్గంలో ఈ గ్రహణం కొన్నిచోట్ల సంపూర్ణంగా, కొన్నిచోట్ల ఉంగరంలా కనిపిస్తుంది. మార్గం బయట ఇది పాక్షికం.';

  @override
  String get eclipsePartialSolarDesc =>
      'చంద్రుడు సూర్యుడిలో ఒక భాగాన్ని మాత్రమే కప్పుతాడు, భూమిపై ఎక్కడా సూర్యుడు పూర్తిగా కప్పబడడు.';

  @override
  String get eclipseNoCity =>
      'అక్కడినుంచి చూడగలరో లేదో తెలుసుకోవడానికి Heliora లో ఒక నగరాన్ని ఎంచుకోండి.';

  @override
  String eclipseLunarUp(String city) {
    return 'గ్రహణం మధ్యలో $city లో చంద్రుడు క్షితిజానికి పైన ఉంటాడు.';
  }

  @override
  String eclipseLunarPartly(String city) {
    return '$city లో గ్రహణంలో కొంత భాగంలో మాత్రమే చంద్రుడు క్షితిజానికి పైన ఉంటాడు.';
  }

  @override
  String eclipseLunarDown(String city) {
    return '$city లో చంద్రుడు క్షితిజానికి కింద ఉండిపోతాడు, కాబట్టి అక్కడినుంచి కనిపించదు.';
  }

  @override
  String eclipseSolarNone(String city) {
    return '$city నుంచి కనిపించదు: చంద్రుడి నీడ అక్కడ పడదు, లేదా సూర్యుడు క్షితిజానికి కింద ఉంటాడు.';
  }

  @override
  String eclipseSolarSlight(String city) {
    return '$city నుంచి గరిష్ఠంగా చాలా స్వల్ప పాక్షిక గ్రహణం మాత్రమే, గమనించడం కష్టం.';
  }

  @override
  String eclipseSolarPartial(String city, String percent) {
    return '$city కోసం ఉజ్జాయింపు అంచనా: చంద్రుడు గరిష్ఠంగా సూర్యుడి వెడల్పులో సుమారు $percent% కప్పుతాడు.';
  }

  @override
  String eclipseSolarNear(String city) {
    return 'సూర్యుడు దాదాపు లేదా పూర్తిగా కప్పబడే మార్గానికి $city దగ్గరగా ఉంది. గ్రహణ పటం చూడండి; ఈ అంచనా ఉజ్జాయింపు మాత్రమే.';
  }

  @override
  String get eclipseSolarSafety =>
      'సరైన గ్రహణ కళ్లద్దాలు లేకుండా ఎప్పుడూ సూర్యుడిని చూడకండి.';

  @override
  String get alertsTitle => 'అలర్ట్‌లు';

  @override
  String get tonightAlertSwitch => 'ప్రతి సాయంత్రం ఈ రాత్రి ఆకాశం';

  @override
  String get tonightAlertTime => 'సమయం';

  @override
  String get tonightAlertNote =>
      'మీరు ఎంచుకున్న సమయంలో చంద్రుడు, కనిపించే గ్రహాల గురించి ఒక చిన్న సందేశం. ఇది మీ ఫోన్‌లోనే లెక్కించబడుతుంది, ఇంటర్నెట్ అవసరం లేదు. Android, Heliora ను ముందుగా సుమారు రెండు వారాల సందేశాలను మాత్రమే సిద్ధం చేయనిస్తుంది, కాబట్టి అప్పుడప్పుడు యాప్ తెరవండి.';

  @override
  String get tonightNotifTitle => 'ఈ రాత్రి ఆకాశం';

  @override
  String tonightMoon(String phase, String percent) {
    return 'చంద్రుడు: $phase, $percent% వెలుగు.';
  }

  @override
  String tonightPlanets(String planets) {
    return 'వెతకండి: $planets.';
  }

  @override
  String get tonightNoPlanets => 'సాయంత్రం ఆకాశంలో ప్రకాశవంతమైన గ్రహాలు లేవు.';

  @override
  String get tonightNoCity =>
      'గ్రహాలను చూడటానికి Heliora లో ఒక నగరాన్ని ఎంచుకోండి.';

  @override
  String get birthdayTitle => 'నా పుట్టినరోజు ఆకాశం';

  @override
  String get birthdaySubtitle =>
      'మీరు పుట్టిన రోజున చంద్రుడు, గ్రహాలు ఎక్కడ ఉన్నాయి, మరియు మీ జీవితంలోని ప్రత్యేక రోజులు.';

  @override
  String get birthdayCardHint => 'చంద్రకళ, గ్రహాలు, మైలురాళ్లు';

  @override
  String get birthdayNeedDate => 'మీ పుట్టిన తేదీ ఇవ్వండి';

  @override
  String get birthdayMoon => 'మీ పుట్టినరోజున చంద్రుడు';

  @override
  String get birthdayPlanets => 'ఆ రోజున గ్రహాలు';

  @override
  String birthdayDaysOld(String count) {
    return 'ఈ రోజు మీకు $count రోజులు.';
  }

  @override
  String get birthdayMilestones => 'మైలురాళ్లు';

  @override
  String birthdayDayN(String count) {
    return 'రోజు $count';
  }

  @override
  String get birthdayBillion => '100 కోట్ల సెకన్ల వయసు';

  @override
  String get birthdayPassed => 'అయిపోయింది';

  @override
  String get birthdayNote =>
      'Heliora లోని మిగతా వాటికి వాడే అవే కక్ష్యల నుంచి మీ ఫోన్‌లోనే లెక్కించబడుతుంది. మీ పుట్టిన తేదీ ఫోన్ దాటి వెళ్లదు.';

  @override
  String get missionsTitle => 'అంతరిక్ష యాత్రలు';

  @override
  String get missionsSubtitle =>
      'అంతరిక్ష అన్వేషణలోని ప్రసిద్ధ క్షణాలు, పాతవి మొదట.';

  @override
  String get missionsCardHint => 'కాలంలో ప్రసిద్ధ యాత్రలు';

  @override
  String get missionSputnik1 =>
      'మొదటి కృత్రిమ ఉపగ్రహం. బీచ్ బాల్ అంత పరిమాణం ఉన్న ఈ లోహపు గోళం సుమారు మూడు నెలలు భూమిని చుట్టింది. దాని బీప్ శబ్దం రేడియోలో వినిపించేది, అంతరిక్ష యుగం ఇక్కడే మొదలైంది.';

  @override
  String get missionVostok1 =>
      'యూరీ గగారిన్ అంతరిక్షంలోకి వెళ్ళిన మొదటి మనిషి అయ్యారు. ఆయన సుమారు 108 నిమిషాల్లో భూమిని ఒకసారి చుట్టారు.';

  @override
  String get missionApollo11 =>
      'నీల్ ఆర్మ్‌స్ట్రాంగ్, బజ్ ఆల్డ్రిన్ శాంతి సముద్రంలో దిగి చంద్రుడిపై నడిచిన మొదటి మనుషులు అయ్యారు. మైఖేల్ కాలిన్స్ కక్ష్యలో వారి కోసం వేచి ఉన్నారు.';

  @override
  String get missionVenera7 =>
      'మరో గ్రహంపై దిగి సంకేతం పంపిన మొదటి వ్యోమనౌక. శుక్రుడి నలిపేసే వేడిలో అది సుమారు 23 నిమిషాలు సమాచారం పంపింది.';

  @override
  String get missionViking1 =>
      'ఇది అంగారకుడిపై దిగి ఆరేళ్లకు పైగా పనిచేసింది, మరో గ్రహం ఉపరితలం నుంచి ఫోటోలు, వాతావరణ నివేదికల మొదటి పొడవైన వరుసను పంపింది.';

  @override
  String get missionVoyager1 =>
      '1977 లో ప్రయోగించబడి, గురుడు, శని దగ్గర నుంచి వెళ్లి 2012 లో నక్షత్రాల మధ్య అంతరిక్షంలోకి ప్రవేశించింది. భూమి నుంచి అత్యంత దూరంలో ఉన్న మానవ నిర్మిత వస్తువు ఇదే.';

  @override
  String get missionHubble =>
      '1990 లో ప్రయోగించబడింది, భూమి గాలికి పైనుంచి విశ్వాన్ని చూస్తుంది. దాని స్పష్టమైన చిత్రాలు విశ్వం వయసును కొలవడానికి సహాయపడ్డాయి, వేలాది దూరపు గెలాక్సీలను చూపించాయి.';

  @override
  String get missionHuygens =>
      'కాసిని మోసుకెళ్లిన వ్యోమనౌక హైజెన్స్ పారాచూట్‌తో శని చంద్రుడు టైటాన్‌పై దిగింది. బయటి సౌర కుటుంబంలో ఇదే మొదటి ల్యాండింగ్, అది ఉపరితలం నుంచి చిత్రాలు పంపింది.';

  @override
  String get missionCuriosity =>
      'కారు అంత పరిమాణం ఉన్న ఈ రోవర్ రాకెట్‌తో నడిచే ’స్కై క్రేన్’ సహాయంతో గేల్ బిలంలో దిగింది. అంగారకుడిపై ఒకప్పుడు జీవానికి తగిన పరిస్థితులు ఉండేవని అది కనుగొంది.';

  @override
  String get missionMangalyaan =>
      'భారతదేశపు మార్స్ ఆర్బిటర్ మిషన్ మొదటి ప్రయత్నంలోనే అంగారకుడి కక్ష్యకు చేరింది. ఏ దేశానికైనా ఇది మొదటిసారి, అదీ చాలా తక్కువ ఖర్చుతో.';

  @override
  String get missionRosetta =>
      'రోసెట్టా ల్యాండర్ ఫిలే తోకచుక్క 67P/చురియుమోవ్–గెరసిమెంకోపై దిగింది, తోకచుక్కపై మొదటి ల్యాండింగ్. రోసెట్టా రెండు సంవత్సరాలు ఆ తోకచుక్కను చుట్టింది.';

  @override
  String get missionNewhorizons =>
      'తొమ్మిదేళ్ల ప్రయాణం తర్వాత అది ప్లూటో దగ్గర నుంచి వెళ్లి, మొదటిసారి మంచు పర్వతాలను, హృదయాకార పెద్ద మైదానాన్ని చూపించింది.';

  @override
  String get missionPerseverance =>
      'పురాతన జీవ సూచనలు వెతకడానికి, రాతి నమూనాలు సేకరించడానికి పర్సెవరెన్స్ రోవర్ జెజెరో బిలంలో దిగింది. దాని హెలికాప్టర్ ఇన్‌జెన్యూటీ మరో గ్రహంపై మొదటి నియంత్రిత ఎగరడం చేసింది.';

  @override
  String get missionJwst =>
      'అతిపెద్ద అంతరిక్ష టెలిస్కోప్‌కు 6.5 మీటర్ల బంగారు అద్దం ఉంది, ఇది 15 లక్షల కి.మీ దూరం నుంచి పరారుణ కాంతిలో ఆకాశాన్ని చూస్తుంది. తొలి గెలాక్సీలలో కొన్నింటిని అది చూడగలదు.';

  @override
  String get missionChandrayaan3 =>
      'చంద్రుడిపై సురక్షితంగా దిగిన నాలుగో దేశంగా భారతదేశం నిలిచింది, దక్షిణ ధ్రువం దగ్గర దిగిన మొదటి దేశంగా కూడా. విక్రమ్ ల్యాండర్ ప్రజ్ఞాన్ రోవర్‌ను తీసుకెళ్లింది.';

  @override
  String get spacecraftTitle => 'అంతరిక్ష నౌకలు ఇప్పుడు';

  @override
  String get spacecraftSubtitle =>
      'కొన్ని ప్రసిద్ధ అంతరిక్ష నౌకలు ఇప్పుడు భూమి నుండి ఎంత దూరంలో ఉన్నాయి.';

  @override
  String get spacecraftCardHint => 'వాయేజర్, JWST, అంగారక రోవర్లు ఇంకా మరెన్నో';

  @override
  String get spacecraftDistance => 'భూమి నుండి దూరం';

  @override
  String get spacecraftAltitude => 'భూమి నుండి ఎత్తు';

  @override
  String get spacecraftInAu => 'ఖగోళ ప్రమాణాలలో';

  @override
  String get spacecraftSpeed => 'వేగం';

  @override
  String get spacecraftSignal => 'రేడియో సంకేతానికి పట్టే సమయం';

  @override
  String get spacecraftNote =>
      'దూరాలు అంచనాలు. దూరపు నౌకలకు ఇవి సగటు వేగం నుండి లెక్కించినవి; భూమి సూర్యుని చుట్టూ తిరగడం వల్ల సుమారు 1% వరకు తేడా ఉండవచ్చు. అంగారకుడికి దూరం ఈ రోజుకు లెక్కించినది. ఒక AU (ఖగోళ ప్రమాణం) అంటే భూమి నుండి సూర్యునికి ఉన్న దూరం.';

  @override
  String valueBillionKm(String value) {
    return '$value బిలియన్ కి.మీ';
  }

  @override
  String valueAu(String value) {
    return '$value AU';
  }

  @override
  String valueKmS(String value) {
    return '$value కి.మీ/సె';
  }

  @override
  String get spacecraftVoyager1 =>
      '1977లో ప్రయోగించారు. 2012లో నక్షత్రాల మధ్య అంతరిక్షంలోకి ప్రవేశించిన మొదటి నౌక ఇది. దీని రేడియో సంకేతం మనకు చేరేసరికి దాదాపు ఒక రోజు పాతదై ఉంటుంది.';

  @override
  String get spacecraftVoyager2 =>
      '1977లో ప్రయోగించారు. యురేనస్, నెప్ట్యూన్ రెండింటినీ దర్శించిన ఏకైక నౌక ఇదే; 2018లో నక్షత్రాల మధ్య అంతరిక్షంలోకి ప్రవేశించింది.';

  @override
  String get spacecraftNewHorizons =>
      '2015లో ప్లూటో దగ్గర, 2019లో కైపర్ పట్టీలోని అరోకోత్ దగ్గర దూసుకెళ్లింది. ఇది ఇంకా బయటికి ప్రయాణిస్తూ, ఇంకా డేటా పంపుతోంది.';

  @override
  String get spacecraftJwst =>
      'అతి పెద్ద అంతరిక్ష టెలిస్కోప్, 2021లో ప్రయోగించారు. ఇది L2 అనే బిందువు దగ్గర, భూమి నుండి సుమారు 15 లక్షల కి.మీ దూరంలో ఉంది; దీని సూర్య కవచం ఎల్లప్పుడూ సూర్యుని వైపు ఉంటుంది.';

  @override
  String get spacecraftIss =>
      'సుమారు ప్రతి 90 నిమిషాలకు భూమిని ఒకసారి చుట్టి వస్తుంది. 2000 నుండి ఇందులో ప్రజలు ఆగకుండా నివసిస్తున్నారు.';

  @override
  String get spacecraftHubble =>
      '1990లో ప్రయోగించారు, ఇప్పటికీ పనిచేస్తోంది. చిత్రాలను మసకబార్చే గాలికి పైన భూమిని చుట్టి వస్తుంది, అందుకే దీని చిత్రాలు చాలా స్పష్టంగా ఉంటాయి.';

  @override
  String get spacecraftMarsRovers =>
      'క్యూరియాసిటీ (2012లో దిగింది), పెర్సివరెన్స్ (2021లో దిగింది) అంగారకుడిపై తిరుగుతున్నాయి. అంగారకుడికి దూరం సుమారు 5.5 కోట్ల కి.మీ నుండి 40 కోట్ల కి.మీ కంటే ఎక్కువ వరకు మారుతుంది.';

  @override
  String get searchTooltip => 'వెతకండి';

  @override
  String get searchHint => 'గ్రహాలు, చంద్రులు, యాత్రలు వెతకండి…';

  @override
  String get searchClear => 'తుడిచివేయి';

  @override
  String searchEmpty(String query) {
    return '“$query” కోసం ఏమీ దొరకలేదు.';
  }

  @override
  String get searchBodies => 'గ్రహాలు, చంద్రులు';

  @override
  String get searchMissions => 'యాత్రలు';

  @override
  String get searchSpacecraft => 'అంతరిక్ష నౌకలు';

  @override
  String get favoritesTitle => 'ఇష్టమైనవి';

  @override
  String get favoritesEmpty =>
      'ఒక గ్రహం, యాత్ర లేదా నౌకపై ఉన్న నక్షత్రాన్ని నొక్కండి, అది ఇక్కడ ఉంటుంది.';

  @override
  String get favoriteAdd => 'ఇష్టమైనవిలో చేర్చండి';

  @override
  String get favoriteRemove => 'ఇష్టమైనవి నుండి తొలగించండి';

  @override
  String get textSize => 'అక్షరాల పరిమాణం';

  @override
  String get textSizeNormal => 'సాధారణం';

  @override
  String get textSizeLarge => 'పెద్దది';

  @override
  String get textSizeLarger => 'ఇంకా పెద్దది';

  @override
  String get textSizeNote =>
      'Heliora లోని అక్షరాలను పెద్దవి చేస్తుంది. ఇది మీ ఫోన్ సొంత అక్షర పరిమాణం కంటే ఎప్పుడూ చిన్నది కాదు.';

  @override
  String get skyOtherNight => 'రాత్రి ఆకాశం';

  @override
  String get planetsThatNight => 'ఆ రాత్రి గ్రహాలు';

  @override
  String get previousDay => 'ముందు రోజు';

  @override
  String get nextDay => 'తర్వాతి రోజు';

  @override
  String get pickDate => 'తేదీని ఎంచుకోండి';

  @override
  String get backToTonight => 'ఈరాత్రికి తిరిగి వెళ్ళండి';

  @override
  String get moonCalendar => 'చంద్ర క్యాలెండర్';

  @override
  String get moonCalendarHint => 'ప్రతిరోజూ చంద్రుని కళ';

  @override
  String get previousMonth => 'గత నెల';

  @override
  String get nextMonth => 'తర్వాతి నెల';

  @override
  String get keyMoonDates => 'ఈ నెల ప్రధాన కళలు';

  @override
  String get moonCalendarNote =>
      'కళల తేదీలు, సమయాలు మీ ఫోన్ టైమ్ జోన్‌లో చూపబడ్డాయి; సుమారు ఒక గంటలోపు ఖచ్చితంగా ఉంటాయి.';

  @override
  String get seeSkyThatDay => 'ఈ రోజు ఆకాశం చూడండి';

  @override
  String get sunLightTitle => 'సూర్యుడు మరియు వెలుగు';

  @override
  String get firstLight => 'మొదటి వెలుగు';

  @override
  String get goldenMorningEnds => 'ఉదయపు బంగారు సమయం ముగుస్తుంది';

  @override
  String get solarNoon => 'సూర్యుడు అత్యంత ఎత్తులో';

  @override
  String get goldenEveningStarts => 'సాయంత్రపు బంగారు సమయం మొదలవుతుంది';

  @override
  String get lastLight => 'చివరి వెలుగు';

  @override
  String get darkSky => 'పూర్తిగా చీకటి ఆకాశం';

  @override
  String get sunDayLength => 'పగటి నిడివి';

  @override
  String durationHm(String hours, String minutes) {
    return '$hours గంటలు $minutes నిమిషాలు';
  }

  @override
  String get sunNote =>
      'సూర్యుడు హోరిజోన్ నుండి 6° కంటే తక్కువ ఎత్తులో ఉన్నప్పుడు బంగారు సమయం. అది 6° కింద ఉన్నప్పుడు మొదటి, చివరి వెలుగు; 18° కింద ఉన్నప్పుడు ఆకాశం పూర్తిగా చీకటిగా ఉంటుంది. సమయాలు మీరు ఎంచుకున్న తేదీకి లెక్కించినవి.';

  @override
  String get sunStaysUp => 'ఈ రోజు సూర్యుడు అస్తమించడు.';

  @override
  String get sunStaysDown => 'ఈ రోజు సూర్యుడు ఉదయించడు.';
}
