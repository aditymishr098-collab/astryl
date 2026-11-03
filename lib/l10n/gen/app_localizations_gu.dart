// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appTitle => 'Heliora';

  @override
  String get tagline => 'સૂર્યમંડળની સફર, સંપૂર્ણ ઑફલાઇન';

  @override
  String get navExplore => 'શોધો';

  @override
  String get navCompare => 'સરખામણી';

  @override
  String get navWeight => 'વજન';

  @override
  String get navQuiz => 'ક્વિઝ';

  @override
  String get viewMode => 'દૃશ્ય મોડ';

  @override
  String get settings => 'સેટિંગ્સ';

  @override
  String get notToScale => 'માપ પ્રમાણે નથી · ખોલવા માટે ગ્રહ પર ટૅપ કરો';

  @override
  String get dragToRotate => 'ફેરવવા ખેંચો · ઝૂમ કરવા પિંચ કરો';

  @override
  String get planetsTitle => 'ગ્રહો';

  @override
  String get planetMercury => 'બુધ';

  @override
  String get planetVenus => 'શુક્ર';

  @override
  String get planetEarth => 'પૃથ્વી';

  @override
  String get planetMars => 'મંગળ';

  @override
  String get planetJupiter => 'ગુરુ';

  @override
  String get planetSaturn => 'શનિ';

  @override
  String get planetUranus => 'યુરેનસ';

  @override
  String get planetNeptune => 'નેપ્ચ્યુન';

  @override
  String planetOrder(int n) {
    return 'સૂર્યથી ગ્રહ ક્રમાંક $n';
  }

  @override
  String get openDetails => 'વિગતો ખોલો';

  @override
  String get diameter => 'વ્યાસ';

  @override
  String get gravity => 'ગુરુત્વાકર્ષણ';

  @override
  String get avgTemp => 'સરેરાશ તાપમાન';

  @override
  String get avgTempShort => 'સરેરાશ તાપમાન';

  @override
  String get dayLength => 'દિવસ';

  @override
  String get yearLength => 'વર્ષ';

  @override
  String get moons => 'જાણીતા ચંદ્રો';

  @override
  String get moonsShort => 'ચંદ્રો';

  @override
  String get distance => 'સૂર્યથી અંતર';

  @override
  String get pressure => 'સપાટીનું દબાણ';

  @override
  String get noSurface => 'કોઈ નક્કર સપાટી નથી';

  @override
  String valueKm(String value) {
    return '$value કિમી';
  }

  @override
  String valueMillionKm(String value) {
    return '$value મિલિયન કિમી';
  }

  @override
  String valueHours(String value) {
    return '$value કલાક';
  }

  @override
  String valueDays(String value) {
    return '$value દિવસ';
  }

  @override
  String valueYears(String value) {
    return '$value વર્ષ';
  }

  @override
  String get atmosphere => 'વાતાવરણ';

  @override
  String get thinAtmosphere =>
      'લગભગ કોઈ વાતાવરણ નથી. આ વાયુઓ એક્ઝોસ્ફિયર નામનું ખૂબ પાતળું સ્તર બનાવે છે.';

  @override
  String get oxygen => 'ઑક્સિજન';

  @override
  String get oxygenVsEarth => 'ઑક્સિજન: પૃથ્વી સાથે સરખામણી';

  @override
  String get breathable => 'માણસો માટે શ્વાસ લેવા યોગ્ય';

  @override
  String get notBreathable => 'શ્વાસ લેવા યોગ્ય નથી, સ્પેસસૂટ જરૂરી છે';

  @override
  String weightFeelsLike(String weight) {
    return 'પૃથ્વીના $weight કિલો અહીં આટલા લાગશે';
  }

  @override
  String get gasCo2 => 'કાર્બન ડાયોક્સાઇડ';

  @override
  String get gasN2 => 'નાઇટ્રોજન';

  @override
  String get gasO2 => 'ઑક્સિજન';

  @override
  String get gasAr => 'આર્ગન';

  @override
  String get gasH2 => 'હાઇડ્રોજન';

  @override
  String get gasHe => 'હિલિયમ';

  @override
  String get gasCh4 => 'મિથેન';

  @override
  String get gasNa => 'સોડિયમ';

  @override
  String get gasK => 'પોટેશિયમ';

  @override
  String get compareTitle => 'ગ્રહોની સરખામણી';

  @override
  String get compareHint => 'બે ગ્રહ પસંદ કરો અને સાથે-સાથે જુઓ.';

  @override
  String get weightTitle => 'બીજા ગ્રહો પર તમારું વજન';

  @override
  String get weightInput => 'પૃથ્વી પર તમારું વજન (કિલો)';

  @override
  String gravityTimes(String factor) {
    return 'પૃથ્વીના ગુરુત્વાકર્ષણનું $factor×';
  }

  @override
  String get quizTitle => 'ગ્રહ ક્વિઝ';

  @override
  String get quizIntro =>
      'ગ્રહો અને ચંદ્રો વિશે 10 પ્રશ્નો. તમે કેટલા સાચા કરી શકો?';

  @override
  String get quizStart => 'ક્વિઝ શરૂ કરો';

  @override
  String quizProgress(int current, int total) {
    return 'પ્રશ્ન $current / $total';
  }

  @override
  String get quizNext => 'આગળ';

  @override
  String get quizSeeResult => 'પરિણામ જુઓ';

  @override
  String get quizCorrect => 'સાચું!';

  @override
  String quizWrong(String answer) {
    return 'નહીં. સાચો જવાબ $answer છે.';
  }

  @override
  String quizScore(int score, int total) {
    return '$total માંથી $score સાચા';
  }

  @override
  String quizBest(int score) {
    return 'શ્રેષ્ઠ સ્કોર: $score';
  }

  @override
  String get quizNewBest => 'નવો શ્રેષ્ઠ સ્કોર!';

  @override
  String get quizAgain => 'ફરી રમો';

  @override
  String get qLargest => 'સૌથી મોટો ગ્રહ કયો છે?';

  @override
  String get qSmallest => 'સૌથી નાનો ગ્રહ કયો છે?';

  @override
  String get qHottest => 'સૌથી ગરમ ગ્રહ કયો છે?';

  @override
  String get qColdest => 'સૌથી ઠંડો ગ્રહ કયો છે?';

  @override
  String get qMostMoons => 'કયા ગ્રહને સૌથી વધુ જાણીતા ચંદ્રો છે?';

  @override
  String get qBreathable => 'કયા ગ્રહ પર માણસો હવામાં શ્વાસ લઈ શકે છે?';

  @override
  String get qClosest => 'સૂર્યની સૌથી નજીક કયો ગ્રહ છે?';

  @override
  String get qFarthest => 'સૂર્યથી સૌથી દૂર કયો ગ્રહ છે?';

  @override
  String get qStrongestGravity => 'કયા ગ્રહનું ગુરુત્વાકર્ષણ સૌથી વધુ છે?';

  @override
  String get qShortestDay => 'કયા ગ્રહનો દિવસ સૌથી ટૂંકો છે?';

  @override
  String get qLongestDay => 'કયા ગ્રહનો દિવસ સૌથી લાંબો છે?';

  @override
  String get appearance => 'દેખાવ';

  @override
  String get theme => 'થીમ';

  @override
  String get themeSystem => 'સિસ્ટમ';

  @override
  String get themeLight => 'લાઇટ';

  @override
  String get themeDark => 'ડાર્ક';

  @override
  String get language => 'ભાષા';

  @override
  String get appLanguage => 'ઍપની ભાષા';

  @override
  String get languageNote => '20 ભાષાઓ · ગ્રહોના નામ પણ';

  @override
  String get phoneLanguage => 'ફોનની ભાષા';

  @override
  String get updates => 'અપડેટ';

  @override
  String get version => 'વર્ઝન';

  @override
  String get checkForUpdates => 'અપડેટ તપાસો';

  @override
  String get checking => 'તપાસી રહ્યા છીએ…';

  @override
  String get autoUpdateCheck => 'દિવસમાં એક વાર આપમેળે તપાસો';

  @override
  String get updateNote =>
      'અપડેટ GitHub Releases પરથી આવે છે. તમારી સેટિંગ્સ તમારા ફોનમાં જ રહે છે.';

  @override
  String get upToDate => 'તમારી પાસે નવીનતમ વર્ઝન છે.';

  @override
  String get updateFailed =>
      'GitHub સુધી પહોંચી શકાયું નહીં. ઇન્ટરનેટ તપાસીને ફરી પ્રયાસ કરો.';

  @override
  String get updateAvailable => 'અપડેટ ઉપલબ્ધ છે';

  @override
  String updateReady(String version) {
    return 'વર્ઝન $version ડાઉનલોડ માટે તૈયાર છે.';
  }

  @override
  String get download => 'ડાઉનલોડ';

  @override
  String get later => 'પછી';

  @override
  String get about => 'વિશે';

  @override
  String get sourceCode => 'GitHub પર સોર્સ કોડ';

  @override
  String get privacyLine => 'ઑફલાઇન · કોઈ જાહેરાત નહીં · કોઈ ટ્રૅકિંગ નહીં';

  @override
  String get dataSource => 'તથ્યો: NASA Planetary Fact Sheet';

  @override
  String get openFailed => 'લિંક ખોલી શકાઈ નહીં.';

  @override
  String get bodySun => 'સૂર્ય';

  @override
  String get bodyMoon => 'ચંદ્ર';

  @override
  String get bodyPluto => 'પ્લૂટો';

  @override
  String get moonIo => 'આયો';

  @override
  String get moonEuropa => 'યુરોપા';

  @override
  String get moonGanymede => 'ગેનિમીડ';

  @override
  String get moonCallisto => 'કૅલિસ્ટો';

  @override
  String get moonTitan => 'ટાઇટન';

  @override
  String get moonEnceladus => 'એન્સેલેડસ';

  @override
  String get moonTriton => 'ટ્રાઇટન';

  @override
  String get kindStar => 'આપણો તારો, સૂર્યમંડળનું કેન્દ્ર';

  @override
  String get kindDwarf => 'વામન ગ્રહ';

  @override
  String moonOf(String planet) {
    return '$planetનો ચંદ્ર';
  }

  @override
  String get orbitPeriod => 'એક પરિક્રમા';

  @override
  String distanceFrom(String body) {
    return '$bodyથી અંતર';
  }

  @override
  String get composition => 'તે શેનાથી બનેલું છે';

  @override
  String get noAtmosphere => 'ખરું વાતાવરણ નથી, લગભગ શૂન્યાવકાશ છે.';

  @override
  String get majorMoons => 'મુખ્ય ચંદ્રો';

  @override
  String get lifeTitle => 'શું માણસો અહીં રહી શકે?';

  @override
  String get lifeScoreShort => 'જીવન સ્કોર';

  @override
  String get lifeNote =>
      'તાપમાન, હવાનું દબાણ, ઑક્સિજન, પાણી, સપાટી અને ગુરુત્વાકર્ષણ પરથી ગણાયું. પૃથ્વીનો સ્કોર 10 છે.';

  @override
  String get water => 'પાણી';

  @override
  String get waterLiquid => 'પ્રવાહી પાણી';

  @override
  String get waterIce => 'બરફ';

  @override
  String get waterOcean => 'બરફ નીચે સમુદ્ર';

  @override
  String get waterNone => 'પાણી નથી';

  @override
  String get surface => 'સપાટી';

  @override
  String get solidSurface => 'નક્કર સપાટી';

  @override
  String get lifeHome => 'બિલકુલ ઘર જેવું';

  @override
  String get lifeHard => 'ખૂબ મુશ્કેલ, બંધ બેઝ અને સ્પેસસૂટ જોઈએ';

  @override
  String get lifeNo => 'માણસો માટે અશક્ય';

  @override
  String get downloadInstall => 'ડાઉનલોડ કરી ઇન્સ્ટોલ કરો';

  @override
  String downloadingPercent(String percent) {
    return 'ડાઉનલોડ થઈ રહ્યું છે… $percent%';
  }

  @override
  String get installNow => 'ઇન્સ્ટોલ કરો';

  @override
  String get allowInstalls =>
      'ખુલેલી સ્ક્રીનમાં Heliora ને ઍપ ઇન્સ્ટોલ કરવાની મંજૂરી આપો, પછી પાછા આવીને ઇન્સ્ટોલ દબાવો.';

  @override
  String get downloadFailed =>
      'ડાઉનલોડ પૂરું ન થયું. ઇન્ટરનેટ તપાસીને ફરી પ્રયાસ કરો.';

  @override
  String get tryAgain => 'ફરી પ્રયાસ કરો';

  @override
  String get today => 'આજે';

  @override
  String get play => 'ચલાવો';

  @override
  String get pause => 'રોકો';

  @override
  String get monthBack => '30 દિવસ પહેલાં';

  @override
  String get monthForward => '30 દિવસ પછી';

  @override
  String get positionsNote =>
      'આ તારીખે ખરી સ્થિતિ · કદ અને અંતર માપ પ્રમાણે નથી · ગ્રહ પર ટૅપ કરો';

  @override
  String get navYou => 'તમે';

  @override
  String get ageTitle => 'બીજા ગ્રહો પર તમારી ઉંમર';

  @override
  String get setBirthDate => 'તમારી જન્મતારીખ નાખો';

  @override
  String get changeBirthDate => 'બદલો';

  @override
  String nextBirthday(String days) {
    return 'આગલો જન્મદિવસ $days દિવસમાં';
  }

  @override
  String get ageNote => 'તમારી જન્મતારીખ ફક્ત આ ફોનમાં જ સેવ થાય છે.';

  @override
  String get share => 'શેર કરો';

  @override
  String shareText(String planet) {
    return 'Heliora માં $planet, મફત ઑફલાઇન સૂર્યમંડળ ઍપ: https://github.com/lumio-apps/heliora';
  }

  @override
  String get shareFailed => 'ચિત્ર શેર ન થઈ શક્યું.';

  @override
  String get travelTitle => 'કેટલું દૂર છે?';

  @override
  String get distanceFromEarth => 'આજે પૃથ્વીથી અંતર';

  @override
  String get lightTime => 'પ્રકાશને લાગે';

  @override
  String get bySpacecraft => '60,000 કિમી/કલાકના અવકાશયાનથી';

  @override
  String get byCar => '100 કિમી/કલાકની કારથી';

  @override
  String valueSeconds(String value) {
    return '$value સેકન્ડ';
  }

  @override
  String valueMinutes(String value) {
    return '$value મિનિટ';
  }

  @override
  String get sizeTitle => 'કદ';

  @override
  String sizeTimes(String big, String times, String small) {
    return '$big પહોળાઈમાં $small કરતાં $times× મોટું છે.';
  }

  @override
  String sizeSimilar(String a, String b) {
    return '$a અને $b લગભગ સરખા કદના છે.';
  }

  @override
  String get navSky => 'આકાશ';

  @override
  String get skyTitle => 'આજ રાતનું આકાશ';

  @override
  String get chooseCity => 'તમારું શહેર પસંદ કરો';

  @override
  String get chooseCityHint =>
      'ચંદ્ર અને આજ રાતે દેખાતા ગ્રહો જોવા નજીકનું શહેર પસંદ કરો. લોકેશન પરવાનગી જોઈતી નથી, અને તે ફોનમાં જ રહે છે.';

  @override
  String get searchCity => 'શહેર શોધો';

  @override
  String get noCityFound => 'કોઈ શહેર મળ્યું નથી';

  @override
  String get cityNote =>
      'સમય તમારા ફોનના ટાઇમ ઝોનમાં છે. અંધારા આકાશમાં ક્ષિતિજથી ઓછામાં ઓછું 5° ઉપર હોય તો ગ્રહ દેખાતો ગણાય.';

  @override
  String illuminated(String percent) {
    return '$percent% પ્રકાશિત';
  }

  @override
  String get moonrise => 'ચંદ્રોદય';

  @override
  String get moonset => 'ચંદ્રાસ્ત';

  @override
  String get sunset => 'સૂર્યાસ્ત';

  @override
  String get sunrise => 'સૂર્યોદય';

  @override
  String get nextFull => 'આગલી પૂનમ';

  @override
  String get nextNew => 'આગલી અમાસ';

  @override
  String get phaseNew => 'અમાસ';

  @override
  String get phaseWaxingCrescent => 'વધતો બીજનો ચંદ્ર';

  @override
  String get phaseFirstQuarter => 'સુદ આઠમ';

  @override
  String get phaseWaxingGibbous => 'વધતો ચંદ્ર';

  @override
  String get phaseFull => 'પૂનમ';

  @override
  String get phaseWaningGibbous => 'ઘટતો ચંદ્ર';

  @override
  String get phaseLastQuarter => 'વદ આઠમ';

  @override
  String get phaseWaningCrescent => 'ઘટતો બીજનો ચંદ્ર';

  @override
  String get planetsTonight => 'આજ રાતના ગ્રહો';

  @override
  String get statusVisible => 'આજ રાતે દેખાશે';

  @override
  String get statusEvening => 'સાંજે, સૂર્યાસ્ત પછી';

  @override
  String get statusMorning => 'સવારે, સૂર્યોદય પહેલાં';

  @override
  String get statusNotVisible => 'આજ રાતે નહીં દેખાય';

  @override
  String bestAt(String time) {
    return 'શ્રેષ્ઠ સમય $time';
  }

  @override
  String altitudeDir(String direction, String degrees) {
    return '$direction, $degrees° ઊંચે';
  }

  @override
  String riseSet(String rise, String set) {
    return 'ઉદય $rise · અસ્ત $set';
  }

  @override
  String get needsTelescope => 'દૂરબીન કે ટેલિસ્કોપ જોઈએ';

  @override
  String get dirN => 'ઉત્તર';

  @override
  String get dirNE => 'ઈશાન';

  @override
  String get dirE => 'પૂર્વ';

  @override
  String get dirSE => 'અગ્નિ';

  @override
  String get dirS => 'દક્ષિણ';

  @override
  String get dirSW => 'નૈઋત્ય';

  @override
  String get dirW => 'પશ્ચિમ';

  @override
  String get dirNW => 'વાયવ્ય';

  @override
  String get findPlanet => 'આકાશમાં શોધો';

  @override
  String finderTitle(String name) {
    return '$name શોધો';
  }

  @override
  String get pointPhone => 'ફોન ઊંચો કરીને ધીમે ધીમે ફેરવો.';

  @override
  String turnRight(String degrees) {
    return '$degrees° જમણે વળો';
  }

  @override
  String turnLeft(String degrees) {
    return '$degrees° ડાબે વળો';
  }

  @override
  String tiltUp(String degrees) {
    return '$degrees° ઉપર કરો';
  }

  @override
  String tiltDown(String degrees) {
    return '$degrees° નીચે કરો';
  }

  @override
  String onTarget(String name) {
    return '$name બરાબર ત્યાં જ છે!';
  }

  @override
  String belowHorizon(String name) {
    return '$name અત્યારે ક્ષિતિજની નીચે છે.';
  }

  @override
  String risesAt(String time) {
    return 'તે $time વાગ્યે ઊગશે.';
  }

  @override
  String get noSensor =>
      'આ ફોનમાં હોકાયંત્ર સેન્સર નથી, તેથી શોધક કામ નહીં કરે.';

  @override
  String get calibrate =>
      'હોકાયંત્ર કેલિબ્રેટ કરવું પડશે: ફોનને થોડી વાર 8 ના આકારમાં ફેરવો.';

  @override
  String get phoneNow => 'તમારો ફોન આ તરફ છે';

  @override
  String get finderNote =>
      'ફોનનો પાછળનો ભાગ આકાશ તરફ રાખો અને ચુંબક તથા ધાતુથી દૂર રાખો. સૂર્ય તરફ ક્યારેય ન જુઓ.';

  @override
  String get eventsTitle => 'અવકાશની ઘટનાઓ';

  @override
  String get eventsSubtitle => 'આગામી 12 મહિનામાં આકાશમાં શું જોવું.';

  @override
  String eventsNext(String event, String when) {
    return 'હવે પછી: $event · $when';
  }

  @override
  String get eventFullMoon => 'પૂનમ';

  @override
  String get eventNewMoon => 'અમાસ';

  @override
  String eventOpposition(String planet) {
    return '$planet પ્રતિયુતિમાં';
  }

  @override
  String eventEveningElongation(String planet) {
    return '$planet: સાંજે જોવાનો શ્રેષ્ઠ સમય';
  }

  @override
  String eventMorningElongation(String planet) {
    return '$planet: સવારે જોવાનો શ્રેષ્ઠ સમય';
  }

  @override
  String eventConjunction(String a, String b) {
    return '$a અને $b નજીક આવે છે';
  }

  @override
  String get eventMarchEquinox => 'માર્ચ વિષુવ';

  @override
  String get eventJuneSolstice => 'જૂન અયનાંત';

  @override
  String get eventSeptemberEquinox => 'સપ્ટેમ્બર વિષુવ';

  @override
  String get eventDecemberSolstice => 'ડિસેમ્બર અયનાંત';

  @override
  String get eventFullMoonDesc =>
      'ચંદ્રનો આખો ચહેરો પ્રકાશિત હોય છે. તે સૂર્યાસ્ત આસપાસ ઊગે છે.';

  @override
  String get eventNewMoonDesc =>
      'ચંદ્ર દેખાતો નથી. તારા અને ગ્રહો જોવા માટે મહિનાનું સૌથી અંધારું આકાશ.';

  @override
  String eventOppositionDesc(String planet) {
    return '$planet સૂર્યની બરાબર સામે છે. આ વર્ષે તે સૌથી તેજસ્વી છે અને આખી રાત દેખાય છે.';
  }

  @override
  String eventEveningDesc(String planet, String degrees) {
    return '$planet સૂર્યથી $degrees° દૂર છે, સૌથી વધુ દૂર. સૂર્યાસ્ત પછી પશ્ચિમમાં નીચે જુઓ.';
  }

  @override
  String eventMorningDesc(String planet, String degrees) {
    return '$planet સૂર્યથી $degrees° દૂર છે, સૌથી વધુ દૂર. સૂર્યોદય પહેલાં પૂર્વમાં નીચે જુઓ.';
  }

  @override
  String eventConjunctionDesc(String degrees) {
    return 'આકાશમાં તેઓ માત્ર $degrees°ના અંતરે પસાર થાય છે.';
  }

  @override
  String get eventEquinoxDesc => 'પૃથ્વી પર બધે દિવસ અને રાત લગભગ સરખા હોય છે.';

  @override
  String get eventJuneSolsticeDesc =>
      'ઉત્તરમાં સૌથી લાંબો દિવસ, દક્ષિણમાં સૌથી ટૂંકો.';

  @override
  String get eventDecemberSolsticeDesc =>
      'ઉત્તરમાં સૌથી ટૂંકો દિવસ, દક્ષિણમાં સૌથી લાંબો.';

  @override
  String eventMeteorShower(String shower) {
    return '$shower ઉલ્કાવર્ષા';
  }

  @override
  String eventMeteorDesc(String rate, String percent) {
    return 'અંધારા આકાશમાં કલાકે લગભગ $rate સુધી ઉલ્કાઓ. ચંદ્ર $percent% પ્રકાશિત હશે.';
  }

  @override
  String get showerQuadrantids => 'ક્વાડ્રેન્ટિડ્સ';

  @override
  String get showerLyrids => 'લાયરિડ્સ';

  @override
  String get showerEtaAquariids => 'ઇટા એક્વેરિડ્સ';

  @override
  String get showerPerseids => 'પર્સિડ્સ';

  @override
  String get showerOrionids => 'ઓરાયોનિડ્સ';

  @override
  String get showerLeonids => 'લિયોનિડ્સ';

  @override
  String get showerGeminids => 'જેમિનિડ્સ';

  @override
  String get showerUrsids => 'અર્સિડ્સ';

  @override
  String get eventToday => 'આજે';

  @override
  String get eventTomorrow => 'કાલે';

  @override
  String eventInDays(String days) {
    return '$days દિવસમાં';
  }

  @override
  String get eventsNote =>
      'તારીખો તમારા ફોનમાં જ ગણાય છે અને તેના ટાઇમ ઝોનમાં દેખાય છે. ઉલ્કાવર્ષાના શિખરના દિવસો દર વર્ષના સામાન્ય દિવસો છે, એક દિવસનો ફેર પડી શકે. રિમાઇન્ડર તમારા ફોનમાં જ રહે છે.';

  @override
  String get remindMe => 'મને યાદ અપાવો';

  @override
  String reminderSet(String date) {
    return 'ઠીક છે, હું તમને $date એ યાદ અપાવીશ.';
  }

  @override
  String get reminderOff => 'રિમાઇન્ડર દૂર કર્યું.';

  @override
  String get reminderTooLate =>
      'આ ઘટના બહુ નજીક છે, રિમાઇન્ડર સેટ થઈ શકે નહીં.';

  @override
  String get notificationsOff =>
      'Heliora ના નોટિફિકેશન બંધ છે. Android સેટિંગમાં ચાલુ કરો.';

  @override
  String get reminderTomorrow => 'કાલે થવાનું છે';

  @override
  String get reminderToday => 'આજે થઈ રહ્યું છે';

  @override
  String get onlineTitle => 'ઓનલાઇન સુવિધાઓ';

  @override
  String get onlineSubtitle =>
      'અવકાશ સ્ટેશન અને રોકેટ લોન્ચ બતાવો. ત્યારે Heliora ફક્ત wheretheiss.at, Celestrak અને Launch Library 2 સાથે જોડાય છે, જે તમારા ફોનનું ઇન્ટરનેટ સરનામું જોઈ શકે છે. બીજું કંઈ મોકલાતું નથી. શરૂઆતમાં બંધ હોય છે.';

  @override
  String get turnOnOnline => 'ઓનલાઇન સુવિધાઓ ચાલુ કરો';

  @override
  String get issTitle => 'અવકાશ સ્ટેશન';

  @override
  String get issCardHint => 'હમણાં ક્યાં છે અને તમારા ઉપરથી ક્યારે પસાર થશે';

  @override
  String get issNeedsOnline =>
      'સ્ટેશન બતાવવા Heliora ને ઇન્ટરનેટથી તેનો ભ્રમણકક્ષા ડેટા જોઈએ. તે એક વાર ડાઉનલોડ થાય છે અને પછી ઘણા દિવસ ઓફલાઇન ચાલે છે.';

  @override
  String get issLoading => 'ભ્રમણકક્ષા ડેટા લાવી રહ્યા છીએ…';

  @override
  String get issFailed =>
      'ભ્રમણકક્ષા ડેટા મળ્યો નહીં. ઇન્ટરનેટ તપાસો અને ફરી પ્રયાસ કરો.';

  @override
  String issStale(String days) {
    return 'ભ્રમણકક્ષા ડેટા $days દિવસ જૂનો છે, તેથી સ્થાન થોડું ખોટું હોઈ શકે. નવો લેવા ઇન્ટરનેટ સાથે જોડાઓ.';
  }

  @override
  String get issHeight => 'ઊંચાઈ';

  @override
  String get issSpeed => 'ઝડપ';

  @override
  String get issFromYou => 'તમારાથી અંતર';

  @override
  String valueKmh(String value) {
    return '$value કિમી/કલાક';
  }

  @override
  String issAboveHorizon(String direction, String degrees) {
    return 'હમણાં તમારી ક્ષિતિજની ઉપર છે! $direction તરફ જુઓ, $degrees° ઊંચે.';
  }

  @override
  String get issBelowHorizon => 'હમણાં તમારી ક્ષિતિજની નીચે છે.';

  @override
  String issPassesTitle(String city) {
    return '$city ઉપરથી હવે પછીની ઉડાનો';
  }

  @override
  String get issNoPasses => 'આગામી 5 દિવસમાં કોઈ સારી ઉડાન નથી.';

  @override
  String issMaxHigh(String degrees) {
    return '$degrees° સુધી ઊંચે';
  }

  @override
  String issFromTo(String start, String end) {
    return '$start થી $end';
  }

  @override
  String get issVisible => 'સરળતાથી દેખાશે';

  @override
  String get issHidden => 'જોવું મુશ્કેલ';

  @override
  String get issPassTitle => 'અવકાશ સ્ટેશન તમારા ઉપરથી પસાર થઈ રહ્યું છે';

  @override
  String issPassBody(String degrees, String direction) {
    return '10 મિનિટમાં ઊગશે, $degrees° સુધી ઊંચે. $direction તરફ જુઓ.';
  }

  @override
  String get issNote =>
      'સ્થાન તમારા ફોનમાં જ સ્ટેશનના ભ્રમણકક્ષા ડેટા પરથી ગણાય છે. આકાશ અંધારું હોય અને સ્ટેશન પર સૂર્યપ્રકાશ પડતો હોય ત્યારે તે સરળતાથી દેખાય છે: ચમકતા, ઝડપી તારા જેવું.';

  @override
  String get launchesNeedOnline =>
      'આવનારા રોકેટ લોન્ચ અહીં જોવા ઓનલાઇન સુવિધાઓ ચાલુ કરો.';

  @override
  String get launchesFailed =>
      'લોન્ચ યાદી અપડેટ થઈ શકી નહીં. સાચવેલી યાદી બતાવી રહ્યા છીએ.';

  @override
  String get launchesNote =>
      'લોન્ચનો સમય Launch Library 2 પરથી આવે છે અને ઘણી વાર બદલાય છે. નામ અને સ્થળો અંગ્રેજીમાં છે.';

  @override
  String get launchReminderBody => 'લગભગ એક કલાકમાં ઉડાન ભરશે. સમય બદલાઈ શકે.';

  @override
  String get launchTimeTbd => 'સમય હજી નક્કી નથી';

  @override
  String get quizChoose => 'સ્તર પસંદ કરો';

  @override
  String get levelEasy => 'સરળ';

  @override
  String get levelMedium => 'મધ્યમ';

  @override
  String get levelHard => 'અઘરું';

  @override
  String get levelEasyHint => 'ગ્રહો વિશે પાયાની વાતો';

  @override
  String get levelMediumHint => 'ગ્રહો અને ચંદ્રો';

  @override
  String get levelHardHint => 'અઘરી સરખામણીઓ અને ક્રમ';

  @override
  String get qStar => 'આમાંથી કયો તારો છે, ગ્રહ નહીં?';

  @override
  String get qDwarf => 'આમાંથી કયો વામન ગ્રહ છે?';

  @override
  String get qMoonVisited => 'કયા ચંદ્ર પર માણસો ચાલ્યા છે?';

  @override
  String get qLargestMoon => 'આ ચંદ્રોમાં સૌથી મોટો કયો છે?';

  @override
  String get qSmallestMoon => 'આ ચંદ્રોમાં સૌથી નાનો કયો છે?';

  @override
  String get qThickAirMoon => 'આ ચંદ્રોમાંથી કોનું વાતાવરણ ઘટ્ટ છે?';

  @override
  String get qGeyserMoon => 'કયો ચંદ્ર પાણીના ફુવારા અવકાશમાં ફેંકે છે?';

  @override
  String get qVolcanicMoon => 'કયા ચંદ્ર પર સૌથી વધુ સક્રિય જ્વાળામુખી છે?';

  @override
  String get qBackwardsMoon =>
      'કયો ચંદ્ર પોતાના ગ્રહની ફરતે ઊલટી દિશામાં ફરે છે?';

  @override
  String get qBiggestRocky => 'ચાર ખડકાળ ગ્રહોમાં સૌથી મોટો કયો છે?';

  @override
  String get qColdestRocky => 'ચાર ખડકાળ ગ્રહોમાં સૌથી ઠંડો કયો છે?';

  @override
  String get qHighestPressure => 'કયા ગ્રહની સપાટી પર હવાનું દબાણ સૌથી વધુ છે?';

  @override
  String get qSecondLargest => 'કયો ગ્રહ બીજો સૌથી મોટો છે?';

  @override
  String get qLongestYear => 'કયા ગ્રહનું વર્ષ સૌથી લાંબું છે?';

  @override
  String get qShortestYear => 'કયા ગ્રહનું વર્ષ સૌથી ટૂંકું છે?';

  @override
  String get qSmallestGiant => 'ચાર વિશાળ ગ્રહોમાં સૌથી નાનો કયો છે?';

  @override
  String get qRockyLongestYear =>
      'ચાર ખડકાળ ગ્રહોમાંથી કોનું વર્ષ સૌથી લાંબું છે?';

  @override
  String get qFastestMoon =>
      'આ ચંદ્રોમાંથી કયો પોતાના ગ્રહની ફરતે સૌથી ઝડપથી ફરે છે?';

  @override
  String get qSlowestMoon =>
      'આ ચંદ્રોમાંથી કયાને પોતાના ગ્રહની ફરતે ફરતાં સૌથી વધુ સમય લાગે છે?';

  @override
  String get qStrongestMoonGravity =>
      'આ ચંદ્રોમાંથી કોનું ગુરુત્વાકર્ષણ સૌથી વધુ છે?';

  @override
  String get qColdestMoon => 'આ ચંદ્રોમાં સૌથી ઠંડો કયો છે?';

  @override
  String get qSecondLargestMoon => 'આ ચંદ્રોમાં બીજો સૌથી મોટો કયો છે?';

  @override
  String get factTitle => 'શું તમે જાણો છો?';

  @override
  String get factTap => 'બીજી હકીકત જોવા ટૅપ કરો';

  @override
  String get factSun1 => 'સૌરમંડળના કુલ દળનો 99.8% ભાગ સૂર્યમાં છે.';

  @override
  String get factSun2 =>
      'સૂર્યના પ્રકાશને પૃથ્વી સુધી પહોંચતાં લગભગ 8 મિનિટ 20 સેકન્ડ લાગે છે.';

  @override
  String get factMercury1 =>
      'બુધ પર એક દિવસ, એટલે એક સૂર્યોદયથી બીજા સૂર્યોદય સુધી, લગભગ 176 પૃથ્વી-દિવસ જેટલો હોય છે. તે તેના વર્ષ કરતાં બમણો લાંબો છે.';

  @override
  String get factMercury2 =>
      'બુધ પર હવા લગભગ નથી, તેથી દિવસે પણ તેનું આકાશ કાળું રહે છે અને રાતો થીજવી દેતી ઠંડી હોય છે.';

  @override
  String get factVenus1 =>
      'શુક્ર ઊલટી દિશામાં ફરે છે, તેથી ત્યાં સૂર્ય પશ્ચિમમાં ઊગે છે.';

  @override
  String get factVenus2 =>
      'સૂર્યથી વધુ દૂર હોવા છતાં શુક્ર બુધ કરતાં વધુ ગરમ છે, કારણ કે તેની ઘટ્ટ હવા ગરમીને રોકી રાખે છે.';

  @override
  String get factEarth1 =>
      'પૃથ્વી એકમાત્ર એવી જગ્યા છે જ્યાં જીવન હોવાનું આપણે જાણીએ છીએ, અને તેની સપાટીનો લગભગ 71% ભાગ પાણીથી ઢંકાયેલો છે.';

  @override
  String get factEarth2 =>
      'પૃથ્વી સંપૂર્ણ ગોળ નથી. ફરવાને કારણે તે વિષુવવૃત્ત પાસે થોડી ઉપસેલી છે.';

  @override
  String get factMars1 =>
      'મંગળનો ઓલિમ્પસ મોન્સ સૌરમંડળનો સૌથી ઊંચો જ્વાળામુખી છે, માઉન્ટ એવરેસ્ટ કરતાં લગભગ અઢી ગણો ઊંચો.';

  @override
  String get factMars2 => 'મંગળ પર સૂર્યાસ્ત વાદળી દેખાય છે.';

  @override
  String get factJupiter1 =>
      'ગુરુનું દળ બાકીના બધા ગ્રહોના કુલ દળ કરતાં બમણાથી પણ વધુ છે.';

  @override
  String get factJupiter2 =>
      'ગ્રેટ રેડ સ્પોટ પૃથ્વી કરતાં મોટું તોફાન છે, જેને લોકો 150 વર્ષથી વધુ સમયથી જોઈ રહ્યા છે.';

  @override
  String get factSaturn1 =>
      'શનિ પોતાના કદ પ્રમાણે એટલો હલકો છે કે પાણીમાં તરે, જો એટલો મોટો ટબ મળે.';

  @override
  String get factSaturn2 =>
      'શનિની વલયો બહુ પહોળી પણ બહુ પાતળી છે: ક્યાંક ક્યાંક માત્ર લગભગ દસ મીટર જાડી.';

  @override
  String get factUranus1 =>
      'યુરેનસ પડખાભેર ગબડતો સૂર્યની આસપાસ ફરે છે, તેની ધરી લગભગ 98 ડિગ્રી નમેલી છે.';

  @override
  String get factUranus2 =>
      'યુરેનસ દૂરબીનથી શોધાયેલો પહેલો ગ્રહ હતો. વિલિયમ હર્શલે તેને 1781માં જોયો.';

  @override
  String get factNeptune1 =>
      'નેપ્ચ્યુન પર કોઈ પણ ગ્રહ કરતાં ઝડપી પવનો ફૂંકાય છે, 2,000 કિમી/કલાકથી પણ વધુ.';

  @override
  String get factNeptune2 =>
      'નેપ્ચ્યુન કોઈએ જોયો તે પહેલાં ગણિતથી શોધાયો: 1846માં ખગોળશાસ્ત્રીઓએ ગણતરી કરી કે તે ક્યાં હોવો જોઈએ.';

  @override
  String get factMoon1 =>
      'ચંદ્ર દર વર્ષે પૃથ્વીથી લગભગ 3.8 સેન્ટિમીટર વધુ દૂર જાય છે.';

  @override
  String get factMoon2 =>
      'આપણને ચંદ્રની હંમેશાં એક જ બાજુ દેખાય છે, કારણ કે પૃથ્વીના દરેક ચક્કર દરમ્યાન તે બરાબર એક વાર પોતાની ધરી પર ફરે છે.';

  @override
  String get factPluto1 =>
      'પ્લૂટો પર એક વર્ષ લગભગ 248 પૃથ્વી-વર્ષ જેટલું હોય છે.';

  @override
  String get factPluto2 =>
      'પ્લૂટો પર થીજી ગયેલા નાઇટ્રોજનનું હૃદયના આકારનું વિશાળ મેદાન છે.';

  @override
  String get factIo1 =>
      'આયો આપણે જાણીએ છીએ તે સૌથી વધુ જ્વાળામુખીવાળી દુનિયા છે, જ્યાં સેંકડો સક્રિય જ્વાળામુખી છે.';

  @override
  String get factIo2 =>
      'ગુરુનું ગુરુત્વાકર્ષણ આયોને દબાવે અને ખેંચે છે, અને તેનાથી પેદા થતી ગરમી તેના જ્વાળામુખીઓને ચલાવે છે.';

  @override
  String get factEuropa1 =>
      'બરફીલા પોપડા નીચે યુરોપામાં કદાચ પૃથ્વીના બધા મહાસાગરો કરતાં લગભગ બમણું પાણી છે.';

  @override
  String get factEuropa2 =>
      'પૃથ્વીની બહાર જીવન શોધવા માટેની શ્રેષ્ઠ જગ્યાઓમાંની એક યુરોપા છે. યુરોપા ક્લિપર યાન ત્યાં જઈ રહ્યું છે.';

  @override
  String get factGanymede1 =>
      'ગેનિમીડ સૌરમંડળનો સૌથી મોટો ચંદ્ર છે. તે બુધ કરતાં પણ મોટો છે.';

  @override
  String get factGanymede2 =>
      'ગેનિમીડ એકમાત્ર ચંદ્ર છે જેનું પોતાનું ચુંબકીય ક્ષેત્ર હોવાનું જાણવા મળ્યું છે.';

  @override
  String get factCallisto1 =>
      'કૅલિસ્ટો સૌરમંડળની સૌથી વધુ ખાડાવાળી જગ્યાઓમાંની એક છે, અને તેની સપાટી બહુ જૂની છે.';

  @override
  String get factCallisto2 =>
      'કૅલિસ્ટો ગુરુથી એટલો દૂર છે કે તેને તેનું કઠોર વિકિરણ ઓછું મળે છે, તેથી વૈજ્ઞાનિકોએ ભવિષ્યના મથક માટે તેનું સૂચન કર્યું છે.';

  @override
  String get factTitan1 =>
      'ટાઇટન એકમાત્ર ચંદ્ર છે જેનું વાતાવરણ ઘટ્ટ છે. તેની સપાટી પર હવાનું દબાણ પૃથ્વી કરતાં વધુ છે.';

  @override
  String get factTitan2 =>
      'ટાઇટન પર નદીઓ અને સરોવરો છે, પણ તેમાં પાણી નહીં, પ્રવાહી મિથેન અને ઇથેન છે.';

  @override
  String get factEnceladus1 =>
      'એન્સેલેડસ પોતાના દક્ષિણ ધ્રુવ પાસેની તિરાડોમાંથી બરફ અને પાણીની વરાળના ફુવારા અવકાશમાં ફેંકે છે.';

  @override
  String get factEnceladus2 => 'એન્સેલેડસના આ ફુવારા શનિની E વલયને ભરે છે.';

  @override
  String get factTriton1 =>
      'ટ્રાઇટન નેપ્ચ્યુનની ફરતે ઊલટી દિશામાં ફરે છે, તેથી કદાચ તે એક વામન ગ્રહ હતો જેને નેપ્ચ્યુને પકડી લીધો.';

  @override
  String get factTriton2 =>
      'લગભગ −235 °C પર ટ્રાઇટન સૌરમંડળની સૌથી ઠંડી જગ્યાઓમાંની એક છે જ્યાં તાપમાન મપાયું છે.';

  @override
  String get jumpInput => 'પૃથ્વી પર તમારી કૂદની ઊંચાઈ (સેમી)';

  @override
  String jumpHigh(String height) {
    return 'કૂદ: $height';
  }

  @override
  String jumpFeelsLike(String height) {
    return 'પૃથ્વી પર $heightની કૂદ અહીં બની જાય છે';
  }

  @override
  String get jumpNote =>
      'ધક્કો પૃથ્વી જેટલો જ રહે છે. સૂર્ય અને વાયુના વિશાળ ગ્રહો પર ઊભા રહેવાની જમીન નથી, તેથી આ માત્ર કલ્પનાની રમત છે.';

  @override
  String valueCm(String value) {
    return '$value સેમી';
  }

  @override
  String valueM(String value) {
    return '$value મી';
  }

  @override
  String get eclipseTotalLunar => 'પૂર્ણ ચંદ્રગ્રહણ';

  @override
  String get eclipsePartialLunar => 'આંશિક ચંદ્રગ્રહણ';

  @override
  String get eclipsePenumbralLunar => 'ઉપચ્છાયા ચંદ્રગ્રહણ';

  @override
  String get eclipseTotalSolar => 'પૂર્ણ સૂર્યગ્રહણ';

  @override
  String get eclipseAnnularSolar => 'કંકણાકાર સૂર્યગ્રહણ';

  @override
  String get eclipseHybridSolar => 'સંકર સૂર્યગ્રહણ';

  @override
  String get eclipsePartialSolar => 'આંશિક સૂર્યગ્રહણ';

  @override
  String get eclipseTotalLunarDesc =>
      'ચંદ્ર પૂરેપૂરો પૃથ્વીના પડછાયામાં જતો રહે છે અને ઘણી વાર આછો લાલ દેખાય છે. પૃથ્વીની રાતની બાજુએ બધા તેને જોઈ શકે છે, અને આંખોથી જોવું સુરક્ષિત છે.';

  @override
  String eclipsePartialLunarDesc(String percent) {
    return 'ચંદ્રનો એક ભાગ (પહોળાઈના $percent%) પૃથ્વીના ઘેરા પડછાયામાં જાય છે. આંખોથી જોવું સુરક્ષિત છે.';
  }

  @override
  String get eclipsePenumbralLunarDesc =>
      'ચંદ્ર પૃથ્વીના આછા બહારના પડછાયામાંથી પસાર થાય છે. તે થોડો જ ઝાંખો પડે છે, એટલે ખ્યાલ આવવો મુશ્કેલ છે.';

  @override
  String get eclipseTotalSolarDesc =>
      'પૃથ્વી પર એક સાંકડી પટ્ટીમાં ચંદ્ર સૂર્યને પૂરેપૂરો ઢાંકી દે છે. એ પટ્ટીની બહાર આંશિક ગ્રહણ દેખાય છે.';

  @override
  String get eclipseAnnularSolarDesc =>
      'ચંદ્ર થોડો વધારે દૂર હોવાથી સૂર્યને પૂરો ઢાંકી શકતો નથી, અને એક ચમકતી વીંટી રહી જાય છે. વીંટી એક સાંકડી પટ્ટીમાં દેખાય છે; તેની બહાર ગ્રહણ આંશિક હોય છે.';

  @override
  String get eclipseHybridSolarDesc =>
      'પોતાની પટ્ટીમાં આ ગ્રહણ કેટલીક જગ્યાએ પૂર્ણ અને કેટલીક જગ્યાએ વીંટી જેવું દેખાય છે. પટ્ટીની બહાર તે આંશિક હોય છે.';

  @override
  String get eclipsePartialSolarDesc =>
      'ચંદ્ર સૂર્યના માત્ર એક ભાગને ઢાંકે છે, અને પૃથ્વી પર ક્યાંય સૂર્ય પૂરો ઢંકાતો નથી.';

  @override
  String get eclipseNoCity =>
      'Heliora માં એક શહેર પસંદ કરો, જેથી ખબર પડે કે ત્યાંથી તે જોઈ શકાશે કે નહીં.';

  @override
  String eclipseLunarUp(String city) {
    return 'ગ્રહણની વચ્ચે $city માં ચંદ્ર ક્ષિતિજની ઉપર હોય છે.';
  }

  @override
  String eclipseLunarPartly(String city) {
    return '$city માં ચંદ્ર ગ્રહણના માત્ર થોડા ભાગમાં ક્ષિતિજની ઉપર હોય છે.';
  }

  @override
  String eclipseLunarDown(String city) {
    return '$city માં ચંદ્ર ક્ષિતિજની નીચે રહે છે, એટલે ત્યાંથી દેખાશે નહીં.';
  }

  @override
  String eclipseSolarNone(String city) {
    return '$city થી દેખાશે નહીં: ચંદ્રનો પડછાયો ત્યાં પહોંચતો નથી, અથવા સૂર્ય ક્ષિતિજની નીચે હોય છે.';
  }

  @override
  String eclipseSolarSlight(String city) {
    return '$city થી વધુમાં વધુ ખૂબ હળવું આંશિક ગ્રહણ દેખાશે, જે ઓળખવું મુશ્કેલ છે.';
  }

  @override
  String eclipseSolarPartial(String city, String percent) {
    return '$city માટે અંદાજે: ચંદ્ર વધુમાં વધુ સૂર્યની પહોળાઈના લગભગ $percent% ઢાંકે છે.';
  }

  @override
  String eclipseSolarNear(String city) {
    return '$city એ પટ્ટીની નજીક છે જ્યાં સૂર્ય લગભગ અથવા પૂરેપૂરો ઢંકાય છે. ગ્રહણનો નકશો જુઓ; આ અંદાજ આશરે છે.';
  }

  @override
  String get eclipseSolarSafety =>
      'યોગ્ય ગ્રહણ-ચશ્મા વિના ક્યારેય સૂર્ય સામે ન જુઓ.';

  @override
  String get alertsTitle => 'એલર્ટ';

  @override
  String get tonightAlertSwitch => 'દરરોજ સાંજે આજની રાતનું આકાશ';

  @override
  String get tonightAlertTime => 'સમય';

  @override
  String get tonightAlertNote =>
      'તમે પસંદ કરેલા સમયે ચંદ્ર અને દેખાતા ગ્રહો વિશે એક નાનો સંદેશ. તે તમારા ફોનમાં જ બને છે, ઇન્ટરનેટ જોઈતું નથી. Android Heliora ને અગાઉથી માત્ર લગભગ બે અઠવાડિયાના સંદેશ તૈયાર કરવા દે છે, એટલે એપ વચ્ચે વચ્ચે ખોલતા રહો.';

  @override
  String get tonightNotifTitle => 'આજની રાતનું આકાશ';

  @override
  String tonightMoon(String phase, String percent) {
    return 'ચંદ્ર: $phase, $percent% પ્રકાશિત.';
  }

  @override
  String tonightPlanets(String planets) {
    return 'શોધો: $planets.';
  }

  @override
  String get tonightNoPlanets => 'સાંજના આકાશમાં કોઈ તેજસ્વી ગ્રહ નથી.';

  @override
  String get tonightNoCity => 'ગ્રહો જોવા માટે Heliora માં શહેર પસંદ કરો.';

  @override
  String get birthdayTitle => 'મારા જન્મદિવસનું આકાશ';

  @override
  String get birthdaySubtitle =>
      'તમે જન્મ્યા તે દિવસે ચંદ્ર અને ગ્રહો ક્યાં હતા, અને તમારા જીવનના ખાસ દિવસો.';

  @override
  String get birthdayCardHint => 'ચંદ્રની કળા, ગ્રહો અને સીમાચિહ્નો';

  @override
  String get birthdayNeedDate => 'તમારી જન્મતારીખ નાખો';

  @override
  String get birthdayMoon => 'તમારા જન્મદિવસે ચંદ્ર';

  @override
  String get birthdayPlanets => 'તે દિવસે ગ્રહો';

  @override
  String birthdayDaysOld(String count) {
    return 'આજે તમે $count દિવસના છો.';
  }

  @override
  String get birthdayMilestones => 'સીમાચિહ્નો';

  @override
  String birthdayDayN(String count) {
    return 'દિવસ $count';
  }

  @override
  String get birthdayBillion => '100 કરોડ સેકન્ડના';

  @override
  String get birthdayPassed => 'થઈ ગયું';

  @override
  String get birthdayNote =>
      'Heliora ની બાકીની બાબતોની જેમ જ કક્ષાઓ પરથી તમારા ફોનમાં ગણતરી થાય છે. તમારી જન્મતારીખ ફોનની બહાર જતી નથી.';

  @override
  String get missionsTitle => 'અવકાશ મિશન';

  @override
  String get missionsSubtitle => 'અવકાશની શોધના જાણીતા પળો, સૌથી જૂના પહેલા.';

  @override
  String get missionsCardHint => 'સમય સાથે જાણીતા મિશન';

  @override
  String get missionSputnik1 =>
      'પહેલો કૃત્રિમ ઉપગ્રહ. બીચ બોલ જેવડો આ ધાતુનો ગોળો લગભગ ત્રણ મહિના પૃથ્વીની આસપાસ ફરતો રહ્યો. તેના બીપ રેડિયો પર સંભળાતા હતા, અને અહીંથી અવકાશ યુગ શરૂ થયો.';

  @override
  String get missionVostok1 =>
      'યુરી ગાગારિન અવકાશમાં જનારા પહેલા માણસ બન્યા. તેમણે લગભગ 108 મિનિટમાં પૃથ્વીનો એક ચક્કર લગાવ્યો.';

  @override
  String get missionApollo11 =>
      'નીલ આર્મસ્ટ્રોંગ અને બઝ ઓલ્ડ્રિન શાંતિના સમુદ્રમાં ઉતર્યા અને ચંદ્ર પર ચાલનારા પહેલા માણસો બન્યા. માઇકલ કૉલિન્સ ભ્રમણકક્ષામાં તેમની રાહ જોતા રહ્યા.';

  @override
  String get missionVenera7 =>
      'બીજા ગ્રહ પર ઉતરીને સંકેત મોકલનાર પહેલું યાન. તેણે શુક્રની કચડી નાખે એવી ગરમીમાં લગભગ 23 મિનિટ સુધી માહિતી મોકલી.';

  @override
  String get missionViking1 =>
      'તે મંગળ પર ઉતર્યું અને છ વર્ષથી વધુ કામ કરતું રહ્યું. તેણે બીજા ગ્રહની સપાટી પરથી ફોટા અને હવામાનના અહેવાલોની પહેલી લાંબી શ્રેણી મોકલી.';

  @override
  String get missionVoyager1 =>
      '1977 માં છોડાયેલું, તે ગુરુ અને શનિ પાસેથી પસાર થયું અને 2012 માં તારાઓ વચ્ચેની જગ્યામાં પહોંચ્યું. પૃથ્વીથી સૌથી દૂર માણસે બનાવેલી વસ્તુ આ જ છે.';

  @override
  String get missionHubble =>
      '1990 માં છોડાયેલી, તે પૃથ્વીની હવાની ઉપરથી બ્રહ્માંડને જુએ છે. તેના સ્પષ્ટ ચિત્રોથી બ્રહ્માંડની ઉંમર માપવામાં મદદ મળી અને હજારો દૂરની આકાશગંગાઓ દેખાઈ.';

  @override
  String get missionHuygens =>
      'કેસિની સાથે ગયેલું યાન હ્યુજન્સ પેરાશૂટથી શનિના ચંદ્ર ટાઇટન પર ઉતર્યું. બાહ્ય સૌરમંડળમાં આ પહેલું ઉતરાણ હતું, અને તેણે સપાટી પરથી ચિત્રો મોકલ્યા.';

  @override
  String get missionCuriosity =>
      'કાર જેવડું આ રોવર રોકેટથી ચાલતી ’સ્કાય ક્રેન’ની મદદથી ગેલ ક્રેટરમાં ઉતર્યું. તેણે શોધ્યું કે મંગળ પર એક સમયે જીવન માટે યોગ્ય સ્થિતિ હતી.';

  @override
  String get missionMangalyaan =>
      'ભારતનું માર્સ ઓર્બિટર મિશન પહેલા જ પ્રયત્ને મંગળની ભ્રમણકક્ષામાં પહોંચ્યું. કોઈ પણ દેશ માટે આ પહેલી વાર હતું, અને ખર્ચ પણ ખૂબ ઓછો.';

  @override
  String get missionRosetta =>
      'રોસેટાના લેન્ડર ફાઇલીએ ધૂમકેતુ 67P/ચુર્યુમોવ–ગેરાસિમેન્કો પર ઉતરીને ધૂમકેતુ પર પહેલું ઉતરાણ કર્યું. રોસેટા પોતે બે વર્ષ ધૂમકેતુની આસપાસ ફરતું રહ્યું.';

  @override
  String get missionNewhorizons =>
      'નવ વર્ષની સફર પછી તે પ્લૂટો પાસેથી પસાર થયું અને પહેલી વાર આપણને બરફીલા પર્વતો અને હૃદય આકારનું વિશાળ મેદાન બતાવ્યું.';

  @override
  String get missionPerseverance =>
      'પર્સિવરન્સ રોવર જૂના જીવનના નિશાન શોધવા અને ખડકોના નમૂના એકઠા કરવા જેઝેરો ક્રેટરમાં ઉતર્યું. તેના હેલિકૉપ્ટર ઇન્જેન્યુઇટીએ બીજા ગ્રહ પર પહેલી સંચાલિત ઉડાન ભરી.';

  @override
  String get missionJwst =>
      'સૌથી મોટા અવકાશ દૂરબીનમાં 6.5 મીટરનો સોનેરી અરીસો છે, અને તે 15 લાખ કિમી દૂરથી ઇન્ફ્રારેડ પ્રકાશમાં આકાશ જુએ છે. તે સૌથી પહેલી આકાશગંગાઓમાંની કેટલીક જોઈ શકે છે.';

  @override
  String get missionChandrayaan3 =>
      'ભારત ચંદ્ર પર સલામત રીતે ઉતરનાર ચોથો દેશ બન્યો, અને દક્ષિણ ધ્રુવ પાસે ઉતરનાર પહેલો. વિક્રમ લેન્ડર પોતાની સાથે પ્રજ્ઞાન રોવર લઈ ગયું હતું.';

  @override
  String get spacecraftTitle => 'અવકાશયાન અત્યારે';

  @override
  String get spacecraftSubtitle =>
      'કેટલાંક જાણીતાં અવકાશયાન અત્યારે પૃથ્વીથી કેટલાં દૂર છે.';

  @override
  String get spacecraftCardHint => 'વોયેજર, JWST, મંગળના રોવર અને બીજું ઘણું';

  @override
  String get spacecraftDistance => 'પૃથ્વીથી અંતર';

  @override
  String get spacecraftAltitude => 'પૃથ્વીથી ઊંચાઈ';

  @override
  String get spacecraftInAu => 'ખગોળીય એકમમાં';

  @override
  String get spacecraftSpeed => 'ઝડપ';

  @override
  String get spacecraftSignal => 'રેડિયો સંકેતને લાગે છે';

  @override
  String get spacecraftNote =>
      'અંતર અંદાજ છે. દૂરનાં યાન માટે તે સરેરાશ ઝડપ પરથી ગણેલું છે અને પૃથ્વી સૂર્યની આસપાસ ફરતી હોવાથી લગભગ 1% જેટલું ખોટું હોઈ શકે. મંગળનું અંતર આજ માટે ગણેલું છે. એક AU (ખગોળીય એકમ) એટલે પૃથ્વીથી સૂર્યનું અંતર.';

  @override
  String valueBillionKm(String value) {
    return '$value અબજ કિમી';
  }

  @override
  String valueAu(String value) {
    return '$value AU';
  }

  @override
  String valueKmS(String value) {
    return '$value કિમી/સેકન્ડ';
  }

  @override
  String get spacecraftVoyager1 =>
      '1977માં છોડાયું. 2012માં તે તારાઓ વચ્ચેની અવકાશમાં પહોંચનારું પહેલું યાન બન્યું. તેનો રેડિયો સંકેત આપણા સુધી પહોંચે ત્યાં સુધીમાં લગભગ એક દિવસ જૂનો થઈ ગયો હોય છે.';

  @override
  String get spacecraftVoyager2 =>
      '1977માં છોડાયું. યુરેનસ અને નેપ્ચ્યુન સુધી પહોંચનારું તે એકમાત્ર યાન છે, અને 2018માં તે તારાઓ વચ્ચેની અવકાશમાં પહોંચ્યું.';

  @override
  String get spacecraftNewHorizons =>
      '2015માં પ્લૂટો પાસેથી અને 2019માં કાઇપર પટ્ટાના પિંડ એરોકોથ પાસેથી પસાર થયું. તે હજી બહાર તરફ આગળ વધી રહ્યું છે અને હજી ડેટા મોકલે છે.';

  @override
  String get spacecraftJwst =>
      'સૌથી મોટું અવકાશ ટેલિસ્કોપ, 2021માં છોડાયું. તે L2 નામના બિંદુ પાસે, પૃથ્વીથી લગભગ 15 લાખ કિમી દૂર છે, અને તેની સૂર્યઢાલ હંમેશાં સૂર્ય તરફ રહે છે.';

  @override
  String get spacecraftIss =>
      'લગભગ દર 90 મિનિટે પૃથ્વીનું એક ચક્કર લગાવે છે. 2000થી તેમાં લોકો અટક્યા વિના રહે છે.';

  @override
  String get spacecraftHubble =>
      '1990માં છોડાયું અને હજી કામ કરે છે. તે ઝાંખપ લાવતી હવાની ઉપરથી પૃથ્વીની પરિક્રમા કરે છે, એટલે તેની તસવીરો ખૂબ સ્પષ્ટ હોય છે.';

  @override
  String get spacecraftMarsRovers =>
      'ક્યુરિયોસિટી (2012માં ઊતર્યું) અને પર્સિવરન્સ (2021માં ઊતર્યું) મંગળ પર ચાલી રહ્યાં છે. મંગળનું અંતર લગભગ 5.5 કરોડ કિમીથી બદલાઈને 40 કરોડ કિમીથી પણ વધુ થઈ જાય છે.';

  @override
  String get searchTooltip => 'શોધો';

  @override
  String get searchHint => 'ગ્રહ, ચંદ્ર, મિશન શોધો…';

  @override
  String get searchClear => 'સાફ કરો';

  @override
  String searchEmpty(String query) {
    return '“$query” માટે કંઈ મળ્યું નહીં.';
  }

  @override
  String get searchBodies => 'ગ્રહો અને ચંદ્રો';

  @override
  String get searchMissions => 'મિશન';

  @override
  String get searchSpacecraft => 'અવકાશયાન';

  @override
  String get favoritesTitle => 'મનપસંદ';

  @override
  String get favoritesEmpty =>
      'કોઈ ગ્રહ, મિશન કે અવકાશયાન પરના તારા પર દબાવો, તે અહીં રહેશે.';

  @override
  String get favoriteAdd => 'મનપસંદમાં ઉમેરો';

  @override
  String get favoriteRemove => 'મનપસંદમાંથી કાઢો';

  @override
  String get textSize => 'અક્ષરોનું કદ';

  @override
  String get textSizeNormal => 'સામાન્ય';

  @override
  String get textSizeLarge => 'મોટું';

  @override
  String get textSizeLarger => 'વધુ મોટું';

  @override
  String get textSizeNote =>
      'Heliora ના અક્ષરો મોટા કરે છે. તે તમારા ફોનના પોતાના અક્ષર-કદથી ક્યારેય નાનું થતું નથી.';

  @override
  String get skyOtherNight => 'રાતનું આકાશ';

  @override
  String get planetsThatNight => 'તે રાતના ગ્રહો';

  @override
  String get previousDay => 'પાછલો દિવસ';

  @override
  String get nextDay => 'આગલો દિવસ';

  @override
  String get pickDate => 'તારીખ પસંદ કરો';

  @override
  String get backToTonight => 'આજ રાત પર પાછા';

  @override
  String get moonCalendar => 'ચંદ્ર કેલેન્ડર';

  @override
  String get moonCalendarHint => 'દરરોજ ચંદ્રની કળા';

  @override
  String get previousMonth => 'પાછલો મહિનો';

  @override
  String get nextMonth => 'આગલો મહિનો';

  @override
  String get keyMoonDates => 'આ મહિનાની મુખ્ય કળાઓ';

  @override
  String get moonCalendarNote =>
      'કળાઓની તારીખ અને સમય તમારા ફોનના સમય ઝોનમાં બતાવ્યા છે અને લગભગ એક કલાકની અંદર સાચા છે.';

  @override
  String get seeSkyThatDay => 'આ દિવસનું આકાશ જુઓ';

  @override
  String get sunLightTitle => 'સૂર્ય અને પ્રકાશ';

  @override
  String get firstLight => 'પહેલો પ્રકાશ';

  @override
  String get goldenMorningEnds => 'સવારનો સોનેરી સમય પૂરો';

  @override
  String get solarNoon => 'સૂર્ય સૌથી ઊંચે';

  @override
  String get goldenEveningStarts => 'સાંજનો સોનેરી સમય શરૂ';

  @override
  String get lastLight => 'છેલ્લો પ્રકાશ';

  @override
  String get darkSky => 'સંપૂર્ણ અંધારું આકાશ';

  @override
  String get sunDayLength => 'દિવસની લંબાઈ';

  @override
  String durationHm(String hours, String minutes) {
    return '$hours કલાક $minutes મિનિટ';
  }

  @override
  String get sunNote =>
      'સોનેરી સમય એટલે સૂર્ય ક્ષિતિજથી 6° કરતાં ઓછો ઊંચે હોય ત્યારે. પહેલો અને છેલ્લો પ્રકાશ ત્યારે હોય જ્યારે તે 6° નીચે હોય, અને આકાશ સંપૂર્ણ અંધારું ત્યારે હોય જ્યારે તે 18° નીચે હોય. સમય તમે પસંદ કરેલી તારીખ માટે ગણેલા છે.';

  @override
  String get sunStaysUp => 'આ દિવસે સૂર્ય આથમતો નથી.';

  @override
  String get sunStaysDown => 'આ દિવસે સૂર્ય ઊગતો નથી.';

  @override
  String get solarSystemTitle => 'સૌરમંડળ';
}
