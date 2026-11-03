// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'Heliora';

  @override
  String get tagline => 'சூரியக் குடும்பத்தை ஆராயுங்கள், முழுவதும் ஆஃப்லைனில்';

  @override
  String get navExplore => 'ஆராய்';

  @override
  String get navCompare => 'ஒப்பீடு';

  @override
  String get navWeight => 'எடை';

  @override
  String get navQuiz => 'வினாடி வினா';

  @override
  String get viewMode => 'பார்வை முறை';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get notToScale => 'அளவுப்படி இல்லை · திறக்க கிரகத்தைத் தட்டவும்';

  @override
  String get dragToRotate => 'சுழற்ற இழுக்கவும் · பெரிதாக்க பிஞ்ச் செய்யவும்';

  @override
  String get planetsTitle => 'கிரகங்கள்';

  @override
  String get planetMercury => 'புதன்';

  @override
  String get planetVenus => 'வெள்ளி';

  @override
  String get planetEarth => 'பூமி';

  @override
  String get planetMars => 'செவ்வாய்';

  @override
  String get planetJupiter => 'வியாழன்';

  @override
  String get planetSaturn => 'சனி';

  @override
  String get planetUranus => 'யுரேனஸ்';

  @override
  String get planetNeptune => 'நெப்டியூன்';

  @override
  String planetOrder(int n) {
    return 'சூரியனிலிருந்து கிரகம் எண் $n';
  }

  @override
  String get openDetails => 'விவரங்களைத் திற';

  @override
  String get diameter => 'விட்டம்';

  @override
  String get gravity => 'ஈர்ப்பு விசை';

  @override
  String get avgTemp => 'சராசரி வெப்பநிலை';

  @override
  String get avgTempShort => 'சராசரி வெப்பம்';

  @override
  String get dayLength => 'நாள்';

  @override
  String get yearLength => 'ஆண்டு';

  @override
  String get moons => 'அறியப்பட்ட நிலவுகள்';

  @override
  String get moonsShort => 'நிலவுகள்';

  @override
  String get distance => 'சூரியனிலிருந்து தூரம்';

  @override
  String get pressure => 'மேற்பரப்பு அழுத்தம்';

  @override
  String get noSurface => 'திடமான மேற்பரப்பு இல்லை';

  @override
  String valueKm(String value) {
    return '$value கி.மீ';
  }

  @override
  String valueMillionKm(String value) {
    return '$value மில்லியன் கி.மீ';
  }

  @override
  String valueHours(String value) {
    return '$value மணி';
  }

  @override
  String valueDays(String value) {
    return '$value நாட்கள்';
  }

  @override
  String valueYears(String value) {
    return '$value ஆண்டுகள்';
  }

  @override
  String get atmosphere => 'வளிமண்டலம்';

  @override
  String get thinAtmosphere =>
      'ஏறக்குறைய வளிமண்டலம் இல்லை. இந்த வாயுக்கள் எக்ஸோஸ்பியர் எனும் மிக மெல்லிய அடுக்கை உருவாக்குகின்றன.';

  @override
  String get oxygen => 'ஆக்சிஜன்';

  @override
  String get oxygenVsEarth => 'ஆக்சிஜன்: பூமியுடன் ஒப்பீடு';

  @override
  String get breathable => 'மனிதர்கள் சுவாசிக்க ஏற்றது';

  @override
  String get notBreathable => 'சுவாசிக்க ஏற்றதல்ல, விண்வெளி உடை தேவை';

  @override
  String weightFeelsLike(String weight) {
    return 'பூமியில் $weight கிலோ இங்கே இவ்வளவாக இருக்கும்';
  }

  @override
  String get gasCo2 => 'கார்பன் டை ஆக்சைடு';

  @override
  String get gasN2 => 'நைட்ரஜன்';

  @override
  String get gasO2 => 'ஆக்சிஜன்';

  @override
  String get gasAr => 'ஆர்கான்';

  @override
  String get gasH2 => 'ஹைட்ரஜன்';

  @override
  String get gasHe => 'ஹீலியம்';

  @override
  String get gasCh4 => 'மீத்தேன்';

  @override
  String get gasNa => 'சோடியம்';

  @override
  String get gasK => 'பொட்டாசியம்';

  @override
  String get compareTitle => 'கிரகங்களை ஒப்பிடுக';

  @override
  String get compareHint =>
      'அருகருகே பார்க்க இரண்டு கிரகங்களைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get weightTitle => 'மற்ற கிரகங்களில் உங்கள் எடை';

  @override
  String get weightInput => 'பூமியில் உங்கள் எடை (கிலோ)';

  @override
  String gravityTimes(String factor) {
    return 'பூமியின் ஈர்ப்பில் $factor×';
  }

  @override
  String get quizTitle => 'கிரக வினாடி வினா';

  @override
  String get quizIntro =>
      'கிரகங்கள் மற்றும் துணைக்கோள்கள் பற்றி 10 கேள்விகள். எத்தனை சரியாகச் சொல்வீர்கள்?';

  @override
  String get quizStart => 'வினாடி வினாவைத் தொடங்கு';

  @override
  String quizProgress(int current, int total) {
    return 'கேள்வி $current / $total';
  }

  @override
  String get quizNext => 'அடுத்து';

  @override
  String get quizSeeResult => 'முடிவைப் பார்';

  @override
  String get quizCorrect => 'சரி!';

  @override
  String quizWrong(String answer) {
    return 'இல்லை. சரியான விடை $answer.';
  }

  @override
  String quizScore(int score, int total) {
    return '$total இல் $score சரி';
  }

  @override
  String quizBest(int score) {
    return 'சிறந்த மதிப்பெண்: $score';
  }

  @override
  String get quizNewBest => 'புதிய சிறந்த மதிப்பெண்!';

  @override
  String get quizAgain => 'மீண்டும் விளையாடு';

  @override
  String get qLargest => 'மிகப் பெரிய கிரகம் எது?';

  @override
  String get qSmallest => 'மிகச் சிறிய கிரகம் எது?';

  @override
  String get qHottest => 'மிக வெப்பமான கிரகம் எது?';

  @override
  String get qColdest => 'மிகக் குளிரான கிரகம் எது?';

  @override
  String get qMostMoons =>
      'எந்தக் கிரகத்திற்கு அதிக அறியப்பட்ட நிலவுகள் உள்ளன?';

  @override
  String get qBreathable =>
      'எந்தக் கிரகத்தில் மனிதர்கள் காற்றைச் சுவாசிக்க முடியும்?';

  @override
  String get qClosest => 'சூரியனுக்கு மிக அருகில் உள்ள கிரகம் எது?';

  @override
  String get qFarthest => 'சூரியனிலிருந்து மிகத் தொலைவில் உள்ள கிரகம் எது?';

  @override
  String get qStrongestGravity =>
      'எந்தக் கிரகத்திற்கு அதிக ஈர்ப்பு விசை உள்ளது?';

  @override
  String get qShortestDay => 'எந்தக் கிரகத்தின் நாள் மிகக் குறுகியது?';

  @override
  String get qLongestDay => 'எந்தக் கிரகத்தின் நாள் மிக நீளமானது?';

  @override
  String get appearance => 'தோற்றம்';

  @override
  String get theme => 'தீம்';

  @override
  String get themeSystem => 'சிஸ்டம்';

  @override
  String get themeLight => 'லைட்';

  @override
  String get themeDark => 'டார்க்';

  @override
  String get language => 'மொழி';

  @override
  String get appLanguage => 'ஆப்ஸ் மொழி';

  @override
  String get languageNote => '20 மொழிகள் · கிரகப் பெயர்களும்';

  @override
  String get phoneLanguage => 'ஃபோன் மொழி';

  @override
  String get updates => 'புதுப்பிப்புகள்';

  @override
  String get version => 'பதிப்பு';

  @override
  String get checkForUpdates => 'புதுப்பிப்பைச் சரிபார்';

  @override
  String get checking => 'சரிபார்க்கிறது…';

  @override
  String get autoUpdateCheck => 'தினமும் ஒருமுறை தானாகச் சரிபார்';

  @override
  String get updateNote =>
      'புதுப்பிப்புகள் GitHub Releases இலிருந்து வருகின்றன. உங்கள் அமைப்புகள் ஃபோனிலேயே இருக்கும்.';

  @override
  String get upToDate => 'உங்களிடம் சமீபத்திய பதிப்பு உள்ளது.';

  @override
  String get updateFailed =>
      'GitHub ஐ அடைய முடியவில்லை. இணையத்தைச் சரிபார்த்து மீண்டும் முயலவும்.';

  @override
  String get updateAvailable => 'புதுப்பிப்பு கிடைக்கிறது';

  @override
  String updateReady(String version) {
    return 'பதிப்பு $version பதிவிறக்கத் தயார்.';
  }

  @override
  String get download => 'பதிவிறக்கு';

  @override
  String get later => 'பின்னர்';

  @override
  String get about => 'பற்றி';

  @override
  String get sourceCode => 'GitHub இல் மூலக் குறியீடு';

  @override
  String get privacyLine => 'ஆஃப்லைன் · விளம்பரம் இல்லை · கண்காணிப்பு இல்லை';

  @override
  String get dataSource => 'தகவல்: NASA Planetary Fact Sheet';

  @override
  String get openFailed => 'இணைப்பைத் திறக்க முடியவில்லை.';

  @override
  String get bodySun => 'சூரியன்';

  @override
  String get bodyMoon => 'நிலவு';

  @override
  String get bodyPluto => 'புளூட்டோ';

  @override
  String get moonIo => 'ஐயோ';

  @override
  String get moonEuropa => 'யூரோப்பா';

  @override
  String get moonGanymede => 'கனிமீடு';

  @override
  String get moonCallisto => 'காலிஸ்டோ';

  @override
  String get moonTitan => 'டைட்டன்';

  @override
  String get moonEnceladus => 'என்செலடஸ்';

  @override
  String get moonTriton => 'ட்ரைட்டன்';

  @override
  String get kindStar => 'நமது நட்சத்திரம், சூரியக் குடும்பத்தின் மையம்';

  @override
  String get kindDwarf => 'குள்ளக் கிரகம்';

  @override
  String moonOf(String planet) {
    return '$planet இன் நிலவு';
  }

  @override
  String get orbitPeriod => 'ஒரு சுற்று';

  @override
  String distanceFrom(String body) {
    return '$body இலிருந்து தூரம்';
  }

  @override
  String get composition => 'இது எதனால் ஆனது';

  @override
  String get noAtmosphere => 'உண்மையான வளிமண்டலம் இல்லை, ஏறக்குறைய வெற்றிடம்.';

  @override
  String get majorMoons => 'முக்கிய நிலவுகள்';

  @override
  String get lifeTitle => 'மனிதர்கள் இங்கே வாழ முடியுமா?';

  @override
  String get lifeScoreShort => 'வாழ்க்கை மதிப்பெண்';

  @override
  String get lifeNote =>
      'வெப்பநிலை, காற்றழுத்தம், ஆக்சிஜன், நீர், மேற்பரப்பு, ஈர்ப்பு ஆகியவற்றிலிருந்து கணக்கிடப்பட்டது. பூமிக்கு 10.';

  @override
  String get water => 'நீர்';

  @override
  String get waterLiquid => 'திரவ நீர்';

  @override
  String get waterIce => 'பனிக்கட்டி';

  @override
  String get waterOcean => 'பனிக்கு அடியில் கடல்';

  @override
  String get waterNone => 'நீர் இல்லை';

  @override
  String get surface => 'மேற்பரப்பு';

  @override
  String get solidSurface => 'திடமான மேற்பரப்பு';

  @override
  String get lifeHome => 'அப்படியே வீடு போல';

  @override
  String get lifeHard => 'மிகக் கடினம், மூடிய தளமும் விண்வெளி உடையும் தேவை';

  @override
  String get lifeNo => 'மனிதர்களுக்குச் சாத்தியமில்லை';

  @override
  String get downloadInstall => 'பதிவிறக்கி நிறுவு';

  @override
  String downloadingPercent(String percent) {
    return 'பதிவிறக்குகிறது… $percent%';
  }

  @override
  String get installNow => 'நிறுவு';

  @override
  String get allowInstalls =>
      'திறந்த திரையில் Heliora ஆப்ஸ்களை நிறுவ அனுமதி கொடுத்து, திரும்பி வந்து நிறுவு என்பதைத் தட்டவும்.';

  @override
  String get downloadFailed =>
      'பதிவிறக்கம் முடியவில்லை. இணையத்தைச் சரிபார்த்து மீண்டும் முயலவும்.';

  @override
  String get tryAgain => 'மீண்டும் முயல்';

  @override
  String get today => 'இன்று';

  @override
  String get play => 'இயக்கு';

  @override
  String get pause => 'நிறுத்து';

  @override
  String get monthBack => '30 நாள் முன்';

  @override
  String get monthForward => '30 நாள் பின்';

  @override
  String get positionsNote =>
      'இந்தத் தேதியில் உண்மையான இடங்கள் · அளவும் தூரமும் அளவுப்படி இல்லை · கிரகத்தைத் தட்டவும்';

  @override
  String get navYou => 'நீங்கள்';

  @override
  String get ageTitle => 'மற்ற கிரகங்களில் உங்கள் வயது';

  @override
  String get setBirthDate => 'உங்கள் பிறந்த தேதியை அமை';

  @override
  String get changeBirthDate => 'மாற்று';

  @override
  String nextBirthday(String days) {
    return 'அடுத்த பிறந்தநாள் $days நாளில்';
  }

  @override
  String get ageNote =>
      'உங்கள் பிறந்த தேதி இந்த ஃபோனில் மட்டுமே சேமிக்கப்படும்.';

  @override
  String get share => 'பகிர்';

  @override
  String shareText(String planet) {
    return 'Heliora இல் $planet, இலவச ஆஃப்லைன் சூரியக் குடும்ப ஆப்: https://github.com/lumio-apps/heliora';
  }

  @override
  String get shareFailed => 'படத்தைப் பகிர முடியவில்லை.';

  @override
  String get travelTitle => 'எவ்வளவு தூரம்?';

  @override
  String get distanceFromEarth => 'இன்று பூமியிலிருந்து தூரம்';

  @override
  String get lightTime => 'ஒளிக்கு ஆகும் நேரம்';

  @override
  String get bySpacecraft => 'மணிக்கு 60,000 கி.மீ விண்கலத்தில்';

  @override
  String get byCar => 'மணிக்கு 100 கி.மீ காரில்';

  @override
  String valueSeconds(String value) {
    return '$value வி';
  }

  @override
  String valueMinutes(String value) {
    return '$value நிமி';
  }

  @override
  String get sizeTitle => 'அளவு';

  @override
  String sizeTimes(String big, String times, String small) {
    return '$big அகலத்தில் $small ஐ விட $times× பெரியது.';
  }

  @override
  String sizeSimilar(String a, String b) {
    return '$a மற்றும் $b ஏறக்குறைய ஒரே அளவு.';
  }

  @override
  String get navSky => 'வானம்';

  @override
  String get skyTitle => 'இன்றிரவு வானம்';

  @override
  String get chooseCity => 'உங்கள் நகரத்தைத் தேர்ந்தெடு';

  @override
  String get chooseCityHint =>
      'நிலவையும் இன்றிரவு தெரியும் கிரகங்களையும் காண அருகிலுள்ள நகரத்தைத் தேர்ந்தெடுக்கவும். இருப்பிட அனுமதி தேவையில்லை, இது ஃபோனிலேயே இருக்கும்.';

  @override
  String get searchCity => 'நகரத்தைத் தேடு';

  @override
  String get noCityFound => 'நகரம் கிடைக்கவில்லை';

  @override
  String get cityNote =>
      'நேரம் உங்கள் ஃபோனின் நேர மண்டலத்தில் உள்ளது. இருண்ட வானில் அடிவானத்திலிருந்து குறைந்தது 5° மேலே இருந்தால் கிரகம் தெரியும் என்று கொள்ளப்படும்.';

  @override
  String illuminated(String percent) {
    return '$percent% ஒளிர்வு';
  }

  @override
  String get moonrise => 'நிலவு உதயம்';

  @override
  String get moonset => 'நிலவு மறைவு';

  @override
  String get sunset => 'சூரிய மறைவு';

  @override
  String get sunrise => 'சூரிய உதயம்';

  @override
  String get nextFull => 'அடுத்த பௌர்ணமி';

  @override
  String get nextNew => 'அடுத்த அமாவாசை';

  @override
  String get phaseNew => 'அமாவாசை';

  @override
  String get phaseWaxingCrescent => 'வளர்பிறைப் பிறை';

  @override
  String get phaseFirstQuarter => 'வளர்பிறை அஷ்டமி';

  @override
  String get phaseWaxingGibbous => 'வளர்பிறை நிலவு';

  @override
  String get phaseFull => 'பௌர்ணமி';

  @override
  String get phaseWaningGibbous => 'தேய்பிறை நிலவு';

  @override
  String get phaseLastQuarter => 'தேய்பிறை அஷ்டமி';

  @override
  String get phaseWaningCrescent => 'தேய்பிறைப் பிறை';

  @override
  String get planetsTonight => 'இன்றிரவு கிரகங்கள்';

  @override
  String get statusVisible => 'இன்றிரவு தெரியும்';

  @override
  String get statusEvening => 'மாலையில், சூரிய மறைவுக்குப் பின்';

  @override
  String get statusMorning => 'காலையில், சூரிய உதயத்துக்கு முன்';

  @override
  String get statusNotVisible => 'இன்றிரவு தெரியாது';

  @override
  String bestAt(String time) {
    return 'சிறந்த நேரம் $time';
  }

  @override
  String altitudeDir(String direction, String degrees) {
    return '$direction, $degrees° உயரத்தில்';
  }

  @override
  String riseSet(String rise, String set) {
    return 'உதயம் $rise · மறைவு $set';
  }

  @override
  String get needsTelescope => 'தொலைநோக்கி தேவை';

  @override
  String get dirN => 'வடக்கு';

  @override
  String get dirNE => 'வடகிழக்கு';

  @override
  String get dirE => 'கிழக்கு';

  @override
  String get dirSE => 'தென்கிழக்கு';

  @override
  String get dirS => 'தெற்கு';

  @override
  String get dirSW => 'தென்மேற்கு';

  @override
  String get dirW => 'மேற்கு';

  @override
  String get dirNW => 'வடமேற்கு';

  @override
  String get findPlanet => 'வானில் கண்டுபிடி';

  @override
  String finderTitle(String name) {
    return '$name கண்டுபிடி';
  }

  @override
  String get pointPhone => 'ஃபோனை உயர்த்தி மெதுவாகச் சுற்றவும்.';

  @override
  String turnRight(String degrees) {
    return '$degrees° வலப்புறம் திரும்பு';
  }

  @override
  String turnLeft(String degrees) {
    return '$degrees° இடப்புறம் திரும்பு';
  }

  @override
  String tiltUp(String degrees) {
    return '$degrees° மேலே உயர்த்து';
  }

  @override
  String tiltDown(String degrees) {
    return '$degrees° கீழே இறக்கு';
  }

  @override
  String onTarget(String name) {
    return '$name அங்கேயே இருக்கிறது!';
  }

  @override
  String belowHorizon(String name) {
    return '$name இப்போது அடிவானத்துக்குக் கீழே உள்ளது.';
  }

  @override
  String risesAt(String time) {
    return 'இது $time மணிக்கு உதிக்கும்.';
  }

  @override
  String get noSensor =>
      'இந்த ஃபோனில் திசைகாட்டி சென்சார் இல்லை, எனவே கண்டுபிடிப்பான் வேலை செய்யாது.';

  @override
  String get calibrate =>
      'திசைகாட்டியை அளவீடு செய்ய வேண்டும்: ஃபோனை சில முறை 8 வடிவில் அசைக்கவும்.';

  @override
  String get phoneNow => 'உங்கள் ஃபோன் காட்டும் திசை';

  @override
  String get finderNote =>
      'ஃபோனின் பின்புறத்தை வானை நோக்கிப் பிடித்து, காந்தம், உலோகத்திலிருந்து விலக்கி வைக்கவும். சூரியனை ஒருபோதும் பார்க்காதீர்கள்.';

  @override
  String get eventsTitle => 'விண்வெளி நிகழ்வுகள்';

  @override
  String get eventsSubtitle => 'அடுத்த 12 மாதங்களில் வானில் என்ன பார்க்கலாம்.';

  @override
  String eventsNext(String event, String when) {
    return 'அடுத்தது: $event · $when';
  }

  @override
  String get eventFullMoon => 'பௌர்ணமி';

  @override
  String get eventNewMoon => 'அமாவாசை';

  @override
  String eventOpposition(String planet) {
    return '$planet எதிர்நிலையில்';
  }

  @override
  String eventEveningElongation(String planet) {
    return '$planet: மாலையில் பார்க்க சிறந்த நேரம்';
  }

  @override
  String eventMorningElongation(String planet) {
    return '$planet: காலையில் பார்க்க சிறந்த நேரம்';
  }

  @override
  String eventConjunction(String a, String b) {
    return '$a மற்றும் $b அருகருகே வருகின்றன';
  }

  @override
  String get eventMarchEquinox => 'மார்ச் சம இரவு நாள்';

  @override
  String get eventJuneSolstice => 'ஜூன் கதிர்த்திருப்பம்';

  @override
  String get eventSeptemberEquinox => 'செப்டம்பர் சம இரவு நாள்';

  @override
  String get eventDecemberSolstice => 'டிசம்பர் கதிர்த்திருப்பம்';

  @override
  String get eventFullMoonDesc =>
      'நிலவின் முழு முகமும் ஒளிர்கிறது. சூரிய மறைவையொட்டி உதிக்கும்.';

  @override
  String get eventNewMoonDesc =>
      'நிலவு தெரியாது. விண்மீன்களையும் கிரகங்களையும் காண மாதத்தின் மிக இருண்ட வானம்.';

  @override
  String eventOppositionDesc(String planet) {
    return '$planet சூரியனுக்கு நேர் எதிரே உள்ளது. இந்த ஆண்டில் மிகப் பிரகாசமாக இருக்கும், இரவு முழுவதும் தெரியும்.';
  }

  @override
  String eventEveningDesc(String planet, String degrees) {
    return '$planet சூரியனிலிருந்து $degrees° தொலைவில், அதிகபட்ச தூரத்தில் உள்ளது. சூரிய மறைவுக்குப் பின் மேற்கில் தாழ்வாகப் பாருங்கள்.';
  }

  @override
  String eventMorningDesc(String planet, String degrees) {
    return '$planet சூரியனிலிருந்து $degrees° தொலைவில், அதிகபட்ச தூரத்தில் உள்ளது. சூரிய உதயத்துக்கு முன் கிழக்கில் தாழ்வாகப் பாருங்கள்.';
  }

  @override
  String eventConjunctionDesc(String degrees) {
    return 'வானில் இவை வெறும் $degrees° இடைவெளியில் கடக்கின்றன.';
  }

  @override
  String get eventEquinoxDesc => 'பூமியெங்கும் பகலும் இரவும் கிட்டத்தட்ட சமம்.';

  @override
  String get eventJuneSolsticeDesc =>
      'வடக்கில் மிக நீண்ட பகல், தெற்கில் மிகச் சிறிய பகல்.';

  @override
  String get eventDecemberSolsticeDesc =>
      'வடக்கில் மிகச் சிறிய பகல், தெற்கில் மிக நீண்ட பகல்.';

  @override
  String eventMeteorShower(String shower) {
    return '$shower எரிகற்கள் மழை';
  }

  @override
  String eventMeteorDesc(String rate, String percent) {
    return 'இருண்ட வானில் மணிக்கு சுமார் $rate வரை எரிகற்கள். நிலவு $percent% ஒளிரும்.';
  }

  @override
  String get showerQuadrantids => 'குவாட்ரான்டிட்ஸ்';

  @override
  String get showerLyrids => 'லைரிட்ஸ்';

  @override
  String get showerEtaAquariids => 'எட்டா அக்வாரிட்ஸ்';

  @override
  String get showerPerseids => 'பெர்சீட்ஸ்';

  @override
  String get showerOrionids => 'ஓரியோனிட்ஸ்';

  @override
  String get showerLeonids => 'லியோனிட்ஸ்';

  @override
  String get showerGeminids => 'ஜெமினிட்ஸ்';

  @override
  String get showerUrsids => 'அர்சிட்ஸ்';

  @override
  String get eventToday => 'இன்று';

  @override
  String get eventTomorrow => 'நாளை';

  @override
  String eventInDays(String days) {
    return '$days நாளில்';
  }

  @override
  String get eventsNote =>
      'தேதிகள் உங்கள் ஃபோனிலேயே கணக்கிடப்பட்டு அதன் நேர மண்டலத்தில் காட்டப்படும். எரிகற்கள் மழையின் உச்ச நாட்கள் ஆண்டுதோறும் வழக்கமான நாட்கள், ஒரு நாள் முன்பின் ஆகலாம். நினைவூட்டல்கள் உங்கள் ஃபோனிலேயே இருக்கும்.';

  @override
  String get remindMe => 'எனக்கு நினைவூட்டு';

  @override
  String reminderSet(String date) {
    return 'சரி, $date அன்று நினைவூட்டுகிறேன்.';
  }

  @override
  String get reminderOff => 'நினைவூட்டல் நீக்கப்பட்டது.';

  @override
  String get reminderTooLate =>
      'இந்த நிகழ்வு மிக அருகில் உள்ளது, நினைவூட்டல் அமைக்க முடியாது.';

  @override
  String get notificationsOff =>
      'Heliora அறிவிப்புகள் அணைக்கப்பட்டுள்ளன. Android அமைப்புகளில் இயக்கவும்.';

  @override
  String get reminderTomorrow => 'நாளை நடக்கும்';

  @override
  String get reminderToday => 'இன்று நடக்கிறது';

  @override
  String get onlineTitle => 'ஆன்லைன் வசதிகள்';

  @override
  String get onlineSubtitle =>
      'விண்வெளி நிலையத்தையும் ராக்கெட் ஏவுதல்களையும் காட்டு. அப்போது Heliora, wheretheiss.at, Celestrak, Launch Library 2 ஆகியவற்றுடன் மட்டுமே தொடர்பு கொள்ளும்; அவை உங்கள் ஃபோனின் இணைய முகவரியைப் பார்க்கலாம். வேறு எதுவும் அனுப்பப்படாது. தொடக்கத்தில் அணைந்திருக்கும்.';

  @override
  String get turnOnOnline => 'ஆன்லைன் வசதிகளை இயக்கு';

  @override
  String get issTitle => 'விண்வெளி நிலையம்';

  @override
  String get issCardHint => 'இப்போது எங்கே, உங்கள் மேல் எப்போது கடக்கும்';

  @override
  String get issNeedsOnline =>
      'நிலையத்தைக் காட்ட Heliora-வுக்கு இணையத்திலிருந்து அதன் சுற்றுப்பாதைத் தரவு தேவை. ஒருமுறை பதிவிறக்கினால் சில நாட்கள் ஆஃப்லைனில் வேலை செய்யும்.';

  @override
  String get issLoading => 'சுற்றுப்பாதைத் தரவைப் பெறுகிறது…';

  @override
  String get issFailed =>
      'சுற்றுப்பாதைத் தரவு கிடைக்கவில்லை. இணையத்தைச் சரிபார்த்து மீண்டும் முயலவும்.';

  @override
  String issStale(String days) {
    return 'சுற்றுப்பாதைத் தரவு $days நாட்கள் பழையது, எனவே இடம் சற்று தவறாக இருக்கலாம். புதுப்பிக்க இணையத்துடன் இணையவும்.';
  }

  @override
  String get issHeight => 'உயரம்';

  @override
  String get issSpeed => 'வேகம்';

  @override
  String get issFromYou => 'உங்களிடமிருந்து தூரம்';

  @override
  String valueKmh(String value) {
    return '$value கிமீ/மணி';
  }

  @override
  String issAboveHorizon(String direction, String degrees) {
    return 'இப்போது உங்கள் அடிவானத்துக்கு மேலே உள்ளது! $direction பக்கம் பாருங்கள், $degrees° உயரத்தில்.';
  }

  @override
  String get issBelowHorizon => 'இப்போது உங்கள் அடிவானத்துக்குக் கீழே உள்ளது.';

  @override
  String issPassesTitle(String city) {
    return '$city மேல் அடுத்த பயணங்கள்';
  }

  @override
  String get issNoPasses => 'அடுத்த 5 நாட்களில் நல்ல பயணங்கள் இல்லை.';

  @override
  String issMaxHigh(String degrees) {
    return '$degrees° வரை உயரம்';
  }

  @override
  String issFromTo(String start, String end) {
    return '$start இலிருந்து $end வரை';
  }

  @override
  String get issVisible => 'எளிதில் தெரியும்';

  @override
  String get issHidden => 'பார்க்க கடினம்';

  @override
  String get issPassTitle => 'விண்வெளி நிலையம் உங்கள் மேல் கடக்கிறது';

  @override
  String issPassBody(String degrees, String direction) {
    return '10 நிமிடத்தில் உதிக்கும், $degrees° வரை உயரம். $direction பக்கம் பாருங்கள்.';
  }

  @override
  String get issNote =>
      'இடங்கள் உங்கள் ஃபோனிலேயே நிலையத்தின் சுற்றுப்பாதைத் தரவிலிருந்து கணக்கிடப்படுகின்றன. வானம் இருண்டும் நிலையத்தின் மீது சூரிய ஒளி படும்போதும் எளிதில் தெரியும்: பிரகாசமான, வேகமான விண்மீன் போல.';

  @override
  String get launchesNeedOnline =>
      'வரவிருக்கும் ராக்கெட் ஏவுதல்களை இங்கே காண ஆன்லைன் வசதிகளை இயக்கவும்.';

  @override
  String get launchesFailed =>
      'ஏவுதல் பட்டியலைப் புதுப்பிக்க முடியவில்லை. சேமித்த பட்டியலைக் காட்டுகிறது.';

  @override
  String get launchesNote =>
      'ஏவுதல் நேரம் Launch Library 2-இலிருந்து வருகிறது, அடிக்கடி மாறும். பெயர்களும் இடங்களும் ஆங்கிலத்தில் உள்ளன.';

  @override
  String get launchReminderBody =>
      'ஏறத்தாழ ஒரு மணி நேரத்தில் ஏவப்படும். நேரம் மாறலாம்.';

  @override
  String get launchTimeTbd => 'நேரம் இன்னும் முடிவாகவில்லை';

  @override
  String get quizChoose => 'நிலையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get levelEasy => 'எளிது';

  @override
  String get levelMedium => 'நடுத்தரம்';

  @override
  String get levelHard => 'கடினம்';

  @override
  String get levelEasyHint => 'கிரகங்கள் பற்றிய அடிப்படை விஷயங்கள்';

  @override
  String get levelMediumHint => 'கிரகங்களும் துணைக்கோள்களும்';

  @override
  String get levelHardHint => 'சிக்கலான ஒப்பீடுகளும் வரிசையும்';

  @override
  String get qStar => 'இவற்றில் எது நட்சத்திரம், கிரகம் அல்ல?';

  @override
  String get qDwarf => 'இவற்றில் எது குள்ளக் கிரகம்?';

  @override
  String get qMoonVisited => 'எந்த துணைக்கோளில் மனிதர்கள் நடந்திருக்கிறார்கள்?';

  @override
  String get qLargestMoon => 'இந்த துணைக்கோள்களில் மிகப் பெரியது எது?';

  @override
  String get qSmallestMoon => 'இந்த துணைக்கோள்களில் மிகச் சிறியது எது?';

  @override
  String get qThickAirMoon =>
      'இந்த துணைக்கோள்களில் எதற்கு அடர்த்தியான வளிமண்டலம் உள்ளது?';

  @override
  String get qGeyserMoon =>
      'எந்த துணைக்கோள் நீர் ஊற்றுகளை விண்வெளியில் பீய்ச்சுகிறது?';

  @override
  String get qVolcanicMoon =>
      'எந்த துணைக்கோளில் மிக அதிக செயல்படும் எரிமலைகள் உள்ளன?';

  @override
  String get qBackwardsMoon =>
      'எந்த துணைக்கோள் தன் கிரகத்தை எதிர்த்திசையில் சுற்றுகிறது?';

  @override
  String get qBiggestRocky => 'நான்கு பாறைக் கிரகங்களில் மிகப் பெரியது எது?';

  @override
  String get qColdestRocky =>
      'நான்கு பாறைக் கிரகங்களில் மிகக் குளிர்ந்தது எது?';

  @override
  String get qHighestPressure =>
      'எந்த கிரகத்தின் மேற்பரப்பில் காற்றழுத்தம் மிக அதிகம்?';

  @override
  String get qSecondLargest => 'எந்த கிரகம் இரண்டாவது பெரியது?';

  @override
  String get qLongestYear => 'எந்த கிரகத்தின் ஆண்டு மிக நீளமானது?';

  @override
  String get qShortestYear => 'எந்த கிரகத்தின் ஆண்டு மிகக் குறுகியது?';

  @override
  String get qSmallestGiant => 'நான்கு பெருங்கிரகங்களில் மிகச் சிறியது எது?';

  @override
  String get qRockyLongestYear =>
      'நான்கு பாறைக் கிரகங்களில் எதன் ஆண்டு மிக நீளமானது?';

  @override
  String get qFastestMoon =>
      'இந்த துணைக்கோள்களில் எது தன் கிரகத்தை மிக வேகமாகச் சுற்றுகிறது?';

  @override
  String get qSlowestMoon =>
      'இந்த துணைக்கோள்களில் எது தன் கிரகத்தைச் சுற்ற மிக அதிக நேரம் எடுக்கிறது?';

  @override
  String get qStrongestMoonGravity =>
      'இந்த துணைக்கோள்களில் எதன் ஈர்ப்பு மிக வலிமையானது?';

  @override
  String get qColdestMoon => 'இந்த துணைக்கோள்களில் மிகக் குளிர்ந்தது எது?';

  @override
  String get qSecondLargestMoon =>
      'இந்த துணைக்கோள்களில் இரண்டாவது பெரியது எது?';

  @override
  String get factTitle => 'உங்களுக்குத் தெரியுமா?';

  @override
  String get factTap => 'மற்றொரு தகவலைப் பார்க்கத் தட்டவும்';

  @override
  String get factSun1 =>
      'சூரியக் குடும்பத்தின் மொத்த நிறையில் 99.8% சூரியனில் உள்ளது.';

  @override
  String get factSun2 =>
      'சூரிய ஒளி பூமியை அடைய சுமார் 8 நிமிடம் 20 வினாடி ஆகும்.';

  @override
  String get factMercury1 =>
      'புதனில் ஒரு நாள், அதாவது ஒரு சூரிய உதயத்திலிருந்து அடுத்த சூரிய உதயம் வரை, சுமார் 176 பூமி நாட்கள். அது அதன் ஆண்டை விட இரு மடங்கு நீளம்.';

  @override
  String get factMercury2 =>
      'புதனில் காற்று கிட்டத்தட்ட இல்லை, எனவே பகலிலும் அதன் வானம் கருப்பாக இருக்கும், இரவுகள் உறைய வைக்கும் குளிராக இருக்கும்.';

  @override
  String get factVenus1 =>
      'வெள்ளி எதிர்த்திசையில் சுழல்கிறது, எனவே அங்கே சூரியன் மேற்கில் உதிக்கிறது.';

  @override
  String get factVenus2 =>
      'சூரியனிலிருந்து தொலைவில் இருந்தாலும் வெள்ளி புதனை விடச் சூடானது, ஏனெனில் அதன் அடர்ந்த காற்று வெப்பத்தைத் தடுத்து வைக்கிறது.';

  @override
  String get factEarth1 =>
      'உயிர் இருப்பது நமக்குத் தெரிந்த ஒரே இடம் பூமி, அதன் மேற்பரப்பில் சுமார் 71% நீரால் மூடப்பட்டுள்ளது.';

  @override
  String get factEarth2 =>
      'பூமி முழுமையான பந்து அல்ல. சுழல்வதால் அது நடுக்கோட்டுக்கு அருகில் சற்று புடைத்திருக்கிறது.';

  @override
  String get factMars1 =>
      'செவ்வாயின் ஒலிம்பஸ் மான்ஸ் சூரியக் குடும்பத்தின் மிக உயரமான எரிமலை, எவரெஸ்ட் சிகரத்தை விடச் சுமார் இரண்டரை மடங்கு உயரம்.';

  @override
  String get factMars2 => 'செவ்வாயில் சூரிய மறைவு நீல நிறத்தில் தெரியும்.';

  @override
  String get factJupiter1 =>
      'வியாழனின் நிறை மற்ற எல்லாக் கிரகங்களின் மொத்த நிறையை விட இரு மடங்குக்கும் அதிகம்.';

  @override
  String get factJupiter2 =>
      'பெரும் சிவப்புப் புள்ளி பூமியை விடப் பெரிய புயல்; மக்கள் அதை 150 ஆண்டுகளுக்கும் மேலாகப் பார்த்து வருகிறார்கள்.';

  @override
  String get factSaturn1 =>
      'சனி தன் அளவுக்கு மிக இலகுவானது; போதுமான பெரிய குளியல் தொட்டி கிடைத்தால் அது நீரில் மிதக்கும்.';

  @override
  String get factSaturn2 =>
      'சனியின் வளையங்கள் மிக அகலமானவை ஆனால் மிக மெல்லியவை: சில இடங்களில் சுமார் பத்து மீட்டர் தடிமன் மட்டுமே.';

  @override
  String get factUranus1 =>
      'யுரேனஸ் பக்கவாட்டில் உருண்டபடி சூரியனைச் சுற்றுகிறது, அதன் அச்சு சுமார் 98 டிகிரி சாய்ந்துள்ளது.';

  @override
  String get factUranus2 =>
      'தொலைநோக்கியால் கண்டுபிடிக்கப்பட்ட முதல் கிரகம் யுரேனஸ். வில்லியம் ஹெர்ஷல் 1781-இல் அதைக் கண்டார்.';

  @override
  String get factNeptune1 =>
      'எந்தக் கிரகத்தையும் விட நெப்டியூனில் காற்று வேகமானது, மணிக்கு 2,000 கி.மீ-க்கும் அதிகம்.';

  @override
  String get factNeptune2 =>
      'யாரும் பார்ப்பதற்கு முன்பே நெப்டியூன் கணிதத்தால் கண்டுபிடிக்கப்பட்டது: 1846-இல் வானியலாளர்கள் அது எங்கே இருக்க வேண்டும் எனக் கணக்கிட்டனர்.';

  @override
  String get factMoon1 =>
      'நிலவு ஒவ்வொரு ஆண்டும் பூமியிலிருந்து சுமார் 3.8 சென்டிமீட்டர் மேலும் விலகிச் செல்கிறது.';

  @override
  String get factMoon2 =>
      'நாம் நிலவின் ஒரே பக்கத்தையே எப்போதும் பார்க்கிறோம், ஏனெனில் பூமியை ஒரு முறை சுற்றும்போது அது சரியாக ஒரு முறை தன்னைத்தானே சுற்றிக்கொள்கிறது.';

  @override
  String get factPluto1 => 'புளூட்டோவில் ஒரு ஆண்டு சுமார் 248 பூமி ஆண்டுகள்.';

  @override
  String get factPluto2 =>
      'புளூட்டோவில் உறைந்த நைட்ரஜனால் ஆன இதய வடிவ பெரிய சமவெளி உள்ளது.';

  @override
  String get factIo1 =>
      'நமக்குத் தெரிந்த மிக அதிக எரிமலைகள் உள்ள உலகம் ஐயோ; அங்கே நூற்றுக்கணக்கான செயல்படும் எரிமலைகள் உள்ளன.';

  @override
  String get factIo2 =>
      'வியாழனின் ஈர்ப்பு ஐயோவை அழுத்தி இழுக்கிறது, அதனால் உண்டாகும் வெப்பம் அதன் எரிமலைகளை இயக்குகிறது.';

  @override
  String get factEuropa1 =>
      'பனிக்கட்டி ஓட்டின் கீழே யூரோப்பாவில் பூமியின் எல்லாக் கடல்களையும் விடச் சுமார் இரு மடங்கு நீர் இருக்கலாம்.';

  @override
  String get factEuropa2 =>
      'பூமிக்கு அப்பால் உயிரைத் தேட மிகச் சிறந்த இடங்களில் ஒன்று யூரோப்பா. யூரோப்பா கிளிப்பர் விண்கலம் அங்கே சென்று கொண்டிருக்கிறது.';

  @override
  String get factGanymede1 =>
      'கனிமீடு சூரியக் குடும்பத்தின் மிகப் பெரிய துணைக்கோள். அது புதனை விடவும் பெரியது.';

  @override
  String get factGanymede2 =>
      'தனக்கென சொந்த காந்தப்புலம் உள்ளதாக அறியப்படும் ஒரே துணைக்கோள் கனிமீடு.';

  @override
  String get factCallisto1 =>
      'காலிஸ்டோ சூரியக் குடும்பத்தில் மிக அதிகக் குழிகள் உள்ள இடங்களில் ஒன்று, அதன் மேற்பரப்பு மிகப் பழமையானது.';

  @override
  String get factCallisto2 =>
      'காலிஸ்டோ வியாழனிலிருந்து போதிய தொலைவில் இருப்பதால் அதன் கடுமையான கதிர்வீச்சு குறைவாகவே படுகிறது; எனவே விஞ்ஞானிகள் எதிர்காலத் தளத்துக்கு அதைப் பரிந்துரைத்துள்ளனர்.';

  @override
  String get factTitan1 =>
      'அடர்ந்த வளிமண்டலம் உள்ள ஒரே துணைக்கோள் டைட்டன். அதன் மேற்பரப்பில் காற்றழுத்தம் பூமியை விட அதிகம்.';

  @override
  String get factTitan2 =>
      'டைட்டனில் ஆறுகளும் ஏரிகளும் உள்ளன, ஆனால் அவற்றில் நீர் அல்ல, திரவ மீத்தேனும் ஈத்தேனும் உள்ளன.';

  @override
  String get factEnceladus1 =>
      'என்செலடஸ் தன் தென் துருவத்துக்கு அருகிலுள்ள பிளவுகள் வழியாக பனியும் நீராவியும் கலந்த பீச்சுகளை விண்வெளியில் வீசுகிறது.';

  @override
  String get factEnceladus2 =>
      'என்செலடஸின் இந்தப் பீச்சுகள் சனியின் E வளையத்தை நிரப்புகின்றன.';

  @override
  String get factTriton1 =>
      'ட்ரைட்டன் நெப்டியூனை எதிர்த்திசையில் சுற்றுகிறது, எனவே அது நெப்டியூன் பிடித்துக்கொண்ட குள்ளக் கிரகமாக இருக்கலாம்.';

  @override
  String get factTriton2 =>
      'சுமார் −235 °C வெப்பநிலையில், சூரியக் குடும்பத்தில் வெப்பநிலை அளக்கப்பட்ட மிகக் குளிரான இடங்களில் ட்ரைட்டன் ஒன்று.';

  @override
  String get jumpInput => 'பூமியில் உங்கள் தாவலின் உயரம் (செ.மீ)';

  @override
  String jumpHigh(String height) {
    return 'தாவல்: $height';
  }

  @override
  String jumpFeelsLike(String height) {
    return 'பூமியில் $height தாவல் இங்கே ஆகிறது';
  }

  @override
  String get jumpNote =>
      'உந்துதல் பூமியில் உள்ளதே. சூரியனிலும் வாயுப் பெருங்கிரகங்களிலும் நிற்க நிலமே இல்லை, எனவே இது வெறும் கற்பனை விளையாட்டு.';

  @override
  String valueCm(String value) {
    return '$value செ.மீ';
  }

  @override
  String valueM(String value) {
    return '$value மீ';
  }

  @override
  String get eclipseTotalLunar => 'முழு சந்திர கிரகணம்';

  @override
  String get eclipsePartialLunar => 'பகுதி சந்திர கிரகணம்';

  @override
  String get eclipsePenumbralLunar => 'புறநிழல் சந்திர கிரகணம்';

  @override
  String get eclipseTotalSolar => 'முழு சூரிய கிரகணம்';

  @override
  String get eclipseAnnularSolar => 'வளைய சூரிய கிரகணம்';

  @override
  String get eclipseHybridSolar => 'கலப்பு சூரிய கிரகணம்';

  @override
  String get eclipsePartialSolar => 'பகுதி சூரிய கிரகணம்';

  @override
  String get eclipseTotalLunarDesc =>
      'நிலா முழுவதும் பூமியின் நிழலுக்குள் செல்கிறது, அடிக்கடி மங்கிய சிவப்பாகத் தெரியும். பூமியின் இரவுப் பக்கத்தில் உள்ள அனைவரும் இதைப் பார்க்கலாம்; கண்ணால் பார்ப்பது பாதுகாப்பானது.';

  @override
  String eclipsePartialLunarDesc(String percent) {
    return 'நிலாவின் ஒரு பகுதி (அகலத்தின் $percent%) பூமியின் அடர் நிழலுக்குள் செல்கிறது. கண்ணால் பார்ப்பது பாதுகாப்பானது.';
  }

  @override
  String get eclipsePenumbralLunarDesc =>
      'நிலா பூமியின் மங்கலான வெளிப்புற நிழல் வழியாகச் செல்கிறது. சிறிதளவு மட்டுமே மங்குவதால் கவனிப்பது கடினம்.';

  @override
  String get eclipseTotalSolarDesc =>
      'பூமியின் மீது ஒரு குறுகிய பாதையில் நிலா சூரியனை முழுவதுமாக மறைக்கிறது. அந்தப் பாதைக்கு வெளியே பகுதி கிரகணம் தெரியும்.';

  @override
  String get eclipseAnnularSolarDesc =>
      'நிலா சற்றுத் தொலைவில் இருப்பதால் சூரியனை முழுவதும் மறைக்க முடியாது; ஒளிரும் வளையம் மிஞ்சும். வளையம் ஒரு குறுகிய பாதையில் தெரியும்; அதற்கு வெளியே கிரகணம் பகுதியாக இருக்கும்.';

  @override
  String get eclipseHybridSolarDesc =>
      'தன் பாதையில் இந்த கிரகணம் சில இடங்களில் முழுமையாகவும் சில இடங்களில் வளையமாகவும் தெரியும். பாதைக்கு வெளியே அது பகுதியாக இருக்கும்.';

  @override
  String get eclipsePartialSolarDesc =>
      'நிலா சூரியனின் ஒரு பகுதியை மட்டுமே மறைக்கிறது; பூமியில் எங்கும் சூரியன் முழுவதும் மறையாது.';

  @override
  String get eclipseNoCity =>
      'அங்கிருந்து பார்க்க முடியுமா என்று அறிய Heliora-வில் ஒரு நகரத்தைத் தேர்ந்தெடுக்கவும்.';

  @override
  String eclipseLunarUp(String city) {
    return 'கிரகணத்தின் நடுவில் $city-ல் நிலா அடிவானத்துக்கு மேலே இருக்கும்.';
  }

  @override
  String eclipseLunarPartly(String city) {
    return '$city-ல் கிரகணத்தின் ஒரு பகுதியில் மட்டுமே நிலா அடிவானத்துக்கு மேலே இருக்கும்.';
  }

  @override
  String eclipseLunarDown(String city) {
    return '$city-ல் நிலா அடிவானத்துக்குக் கீழேயே இருக்கும், அதனால் அங்கிருந்து தெரியாது.';
  }

  @override
  String eclipseSolarNone(String city) {
    return '$city-ல் இருந்து தெரியாது: நிலாவின் நிழல் அங்கே விழாது, அல்லது சூரியன் அடிவானத்துக்குக் கீழே இருக்கும்.';
  }

  @override
  String eclipseSolarSlight(String city) {
    return '$city-ல் இருந்து அதிகபட்சம் மிகச் சிறிய பகுதி கிரகணம் மட்டுமே, கவனிப்பது கடினம்.';
  }

  @override
  String eclipseSolarPartial(String city, String percent) {
    return '$city-க்கான தோராய மதிப்பீடு: நிலா அதிகபட்சம் சூரியனின் அகலத்தில் சுமார் $percent% மறைக்கிறது.';
  }

  @override
  String eclipseSolarNear(String city) {
    return 'சூரியன் கிட்டத்தட்ட அல்லது முழுவதும் மறையும் பாதைக்கு $city அருகில் உள்ளது. கிரகண வரைபடத்தைப் பாருங்கள்; இந்த மதிப்பீடு தோராயமானது.';
  }

  @override
  String get eclipseSolarSafety =>
      'சரியான கிரகணக் கண்ணாடி இல்லாமல் சூரியனை ஒருபோதும் பார்க்காதீர்கள்.';

  @override
  String get alertsTitle => 'எச்சரிக்கைகள்';

  @override
  String get tonightAlertSwitch => 'ஒவ்வொரு மாலையும் இன்றிரவு வானம்';

  @override
  String get tonightAlertTime => 'நேரம்';

  @override
  String get tonightAlertNote =>
      'நீங்கள் தேர்ந்தெடுத்த நேரத்தில் நிலா மற்றும் தெரியும் கோள்கள் பற்றிய ஒரு சிறு செய்தி. இது உங்கள் தொலைபேசியிலேயே கணக்கிடப்படும், இணையம் தேவையில்லை. Android, Heliora-வை முன்கூட்டியே சுமார் இரண்டு வாரச் செய்திகளை மட்டுமே தயாரிக்க அனுமதிக்கிறது, எனவே ஆப்பை அவ்வப்போது திறங்கள்.';

  @override
  String get tonightNotifTitle => 'இன்றிரவு வானம்';

  @override
  String tonightMoon(String phase, String percent) {
    return 'நிலா: $phase, $percent% ஒளிர்வு.';
  }

  @override
  String tonightPlanets(String planets) {
    return 'தேடுங்கள்: $planets.';
  }

  @override
  String get tonightNoPlanets => 'மாலை வானில் பிரகாசமான கோள்கள் இல்லை.';

  @override
  String get tonightNoCity =>
      'கோள்களைப் பார்க்க Heliora-வில் ஒரு நகரத்தைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get birthdayTitle => 'என் பிறந்தநாள் வானம்';

  @override
  String get birthdaySubtitle =>
      'நீங்கள் பிறந்த நாளில் நிலாவும் கோள்களும் எங்கே இருந்தன, மேலும் உங்கள் வாழ்க்கையின் சிறப்பு நாட்கள்.';

  @override
  String get birthdayCardHint => 'நிலா நிலை, கோள்கள், மைல்கற்கள்';

  @override
  String get birthdayNeedDate => 'உங்கள் பிறந்த தேதியை அமை';

  @override
  String get birthdayMoon => 'உங்கள் பிறந்தநாளில் நிலா';

  @override
  String get birthdayPlanets => 'அந்த நாளில் கோள்கள்';

  @override
  String birthdayDaysOld(String count) {
    return 'இன்று உங்களுக்கு $count நாட்கள் ஆகின்றன.';
  }

  @override
  String get birthdayMilestones => 'மைல்கற்கள்';

  @override
  String birthdayDayN(String count) {
    return 'நாள் $count';
  }

  @override
  String get birthdayBillion => '100 கோடி வினாடிகள்';

  @override
  String get birthdayPassed => 'முடிந்தது';

  @override
  String get birthdayNote =>
      'Heliora-வின் மற்ற பகுதிகளில் பயன்படுத்தும் அதே சுற்றுப்பாதைகளிலிருந்து உங்கள் தொலைபேசியிலேயே கணக்கிடப்படுகிறது. உங்கள் பிறந்த தேதி தொலைபேசியை விட்டு வெளியே செல்லாது.';

  @override
  String get missionsTitle => 'விண்வெளிப் பயணங்கள்';

  @override
  String get missionsSubtitle =>
      'விண்வெளி ஆய்வின் புகழ்பெற்ற தருணங்கள், பழையது முதலில்.';

  @override
  String get missionsCardHint => 'காலம் முழுவதும் புகழ்பெற்ற பயணங்கள்';

  @override
  String get missionSputnik1 =>
      'முதல் செயற்கைக்கோள். கடற்கரைப் பந்து அளவுள்ள இந்த உலோக உருண்டை சுமார் மூன்று மாதங்கள் பூமியைச் சுற்றியது. அதன் பீப் ஒலி வானொலியில் கேட்டது, விண்வெளி யுகம் இங்கிருந்தே தொடங்கியது.';

  @override
  String get missionVostok1 =>
      'யூரி ககாரின் விண்வெளிக்குச் சென்ற முதல் மனிதர் ஆனார். அவர் சுமார் 108 நிமிடங்களில் பூமியை ஒருமுறை சுற்றினார்.';

  @override
  String get missionApollo11 =>
      'நீல் ஆம்ஸ்ட்ராங்கும் பஸ் ஆல்ட்ரினும் அமைதிக் கடலில் இறங்கி நிலவில் நடந்த முதல் மனிதர்கள் ஆனார்கள். மைக்கேல் காலின்ஸ் சுற்றுப்பாதையில் அவர்களுக்காகக் காத்திருந்தார்.';

  @override
  String get missionVenera7 =>
      'வேறொரு கோளில் இறங்கி சமிக்ஞை அனுப்பிய முதல் விண்கலம். வெள்ளியின் நசுக்கும் வெப்பத்தில் அது சுமார் 23 நிமிடங்கள் தரவு அனுப்பியது.';

  @override
  String get missionViking1 =>
      'இது செவ்வாயில் இறங்கி ஆறு ஆண்டுகளுக்கு மேல் செயல்பட்டது; வேறொரு கோளின் மேற்பரப்பிலிருந்து படங்கள் மற்றும் வானிலை அறிக்கைகளின் முதல் நீண்ட தொடரை அனுப்பியது.';

  @override
  String get missionVoyager1 =>
      '1977-ல் ஏவப்பட்டு, வியாழன் மற்றும் சனி அருகே கடந்து 2012-ல் விண்மீன்களுக்கு இடையிலான விண்வெளியில் நுழைந்தது. பூமியிலிருந்து மிகத் தொலைவில் உள்ள மனிதன் உருவாக்கிய பொருள் இதுவே.';

  @override
  String get missionHubble =>
      '1990-ல் ஏவப்பட்டது, பூமியின் காற்றுக்கு மேலிருந்து பிரபஞ்சத்தைப் பார்க்கிறது. அதன் தெளிவான படங்கள் பிரபஞ்சத்தின் வயதை அளக்க உதவின, ஆயிரக்கணக்கான தொலைதூர விண்மீன் திரள்களைக் காட்டின.';

  @override
  String get missionHuygens =>
      'காசினியுடன் சென்ற விண்கலம் ஹைஜென்ஸ் பாராசூட்டில் சனியின் நிலவு டைட்டனில் இறங்கியது. வெளிப்புற சூரிய மண்டலத்தில் இதுவே முதல் தரையிறக்கம்; அது மேற்பரப்பிலிருந்து படங்கள் அனுப்பியது.';

  @override
  String get missionCuriosity =>
      'கார் அளவுள்ள இந்த ரோவர் ராக்கெட்டால் இயங்கும் ’ஸ்கை கிரேன்’ மூலம் கேல் பள்ளத்தில் இறங்கியது. செவ்வாயில் ஒரு காலத்தில் உயிருக்கு ஏற்ற சூழல் இருந்ததாக அது கண்டறிந்தது.';

  @override
  String get missionMangalyaan =>
      'இந்தியாவின் மார்ஸ் ஆர்பிட்டர் மிஷன் முதல் முயற்சியிலேயே செவ்வாயின் சுற்றுப்பாதையை அடைந்தது. எந்த நாட்டுக்கும் இது முதல் முறை, மிகக் குறைந்த செலவில்.';

  @override
  String get missionRosetta =>
      'ரோசெட்டாவின் தரையிறங்கி பிலே, 67P/சுர்யுமோவ்–கெராசிமென்கோ வால்மீனில் இறங்கியது; வால்மீனில் முதல் தரையிறக்கம். ரோசெட்டா இரண்டு ஆண்டுகள் வால்மீனைச் சுற்றியது.';

  @override
  String get missionNewhorizons =>
      'ஒன்பது ஆண்டுப் பயணத்துக்குப் பிறகு அது புளூட்டோவைக் கடந்து, முதல் முறையாக பனி மலைகளையும் இதய வடிவ பெரிய சமவெளியையும் காட்டியது.';

  @override
  String get missionPerseverance =>
      'பழைய உயிரின் அடையாளங்களைத் தேடவும் பாறை மாதிரிகளைச் சேகரிக்கவும் பெர்சிவரன்ஸ் ரோவர் ஜெஸெரோ பள்ளத்தில் இறங்கியது. அதன் ஹெலிகாப்டர் இன்ஜெனுயிட்டி வேறொரு கோளில் முதல் இயக்கப்பட்ட பறப்பை நிகழ்த்தியது.';

  @override
  String get missionJwst =>
      'மிகப்பெரிய விண்வெளித் தொலைநோக்கியில் 6.5 மீட்டர் தங்க நிறக் கண்ணாடி உள்ளது; 15 லட்சம் கி.மீ தொலைவிலிருந்து அகச்சிவப்பு ஒளியில் வானைப் பார்க்கிறது. முதல் விண்மீன் திரள்களில் சிலவற்றை அது காண்கிறது.';

  @override
  String get missionChandrayaan3 =>
      'நிலவில் பாதுகாப்பாக இறங்கிய நான்காவது நாடாக இந்தியா ஆனது, தென் துருவம் அருகே இறங்கிய முதல் நாடும். விக்ரம் லேண்டர் பிரக்யான் ரோவரைச் சுமந்து சென்றது.';

  @override
  String get spacecraftTitle => 'விண்கலங்கள் இப்போது';

  @override
  String get spacecraftSubtitle =>
      'சில புகழ்பெற்ற விண்கலங்கள் இப்போது பூமியிலிருந்து எவ்வளவு தொலைவில் உள்ளன.';

  @override
  String get spacecraftCardHint =>
      'வாயேஜர், JWST, செவ்வாய் ரோவர்கள் மற்றும் பல';

  @override
  String get spacecraftDistance => 'பூமியிலிருந்து தொலைவு';

  @override
  String get spacecraftAltitude => 'பூமியிலிருந்து உயரம்';

  @override
  String get spacecraftInAu => 'வானியல் அலகில்';

  @override
  String get spacecraftSpeed => 'வேகம்';

  @override
  String get spacecraftSignal => 'ரேடியோ சமிக்ஞைக்கு ஆகும் நேரம்';

  @override
  String get spacecraftNote =>
      'தொலைவுகள் மதிப்பீடுகள். தொலைதூர விண்கலங்களுக்கு இவை சராசரி வேகத்திலிருந்து கணக்கிடப்பட்டவை; பூமி சூரியனைச் சுற்றுவதால் சுமார் 1% வரை தவறாக இருக்கலாம். செவ்வாய்க்கான தொலைவு இன்றைக்குக் கணக்கிடப்பட்டது. ஒரு AU (வானியல் அலகு) என்பது பூமியிலிருந்து சூரியனுக்கான தொலைவு.';

  @override
  String valueBillionKm(String value) {
    return '$value பில்லியன் கி.மீ';
  }

  @override
  String valueAu(String value) {
    return '$value AU';
  }

  @override
  String valueKmS(String value) {
    return '$value கி.மீ/வி';
  }

  @override
  String get spacecraftVoyager1 =>
      '1977-இல் ஏவப்பட்டது. 2012-இல் விண்மீன்களுக்கு இடையிலான விண்வெளிக்குள் நுழைந்த முதல் விண்கலமானது. இதன் ரேடியோ சமிக்ஞை நம்மை அடையும்போது ஏறக்குறைய ஒரு நாள் பழையதாகியிருக்கும்.';

  @override
  String get spacecraftVoyager2 =>
      '1977-இல் ஏவப்பட்டது. யுரேனஸ், நெப்டியூன் இரண்டுக்கும் சென்ற ஒரே விண்கலம் இதுதான்; 2018-இல் விண்மீன்களுக்கு இடையிலான விண்வெளிக்குள் நுழைந்தது.';

  @override
  String get spacecraftNewHorizons =>
      '2015-இல் புளூட்டோவையும் 2019-இல் கைப்பர் பட்டையிலுள்ள அரோகோத்தையும் கடந்து சென்றது. இன்னும் வெளிநோக்கிப் பயணித்து, இன்னும் தரவுகளை அனுப்புகிறது.';

  @override
  String get spacecraftJwst =>
      'மிகப் பெரிய விண்வெளி தொலைநோக்கி, 2021-இல் ஏவப்பட்டது. இது L2 என்ற புள்ளிக்கு அருகில், பூமியிலிருந்து சுமார் 15 லட்சம் கி.மீ தொலைவில் உள்ளது; இதன் சூரியக் கவசம் எப்போதும் சூரியனை நோக்கியிருக்கும்.';

  @override
  String get spacecraftIss =>
      'ஏறக்குறைய ஒவ்வொரு 90 நிமிடத்துக்கும் பூமியை ஒரு முறை சுற்றுகிறது. 2000 முதல் இதில் மனிதர்கள் இடைவிடாமல் வசித்து வருகிறார்கள்.';

  @override
  String get spacecraftHubble =>
      '1990-இல் ஏவப்பட்டு இன்னும் செயல்படுகிறது. படத்தை மங்கச் செய்யும் காற்றுக்கு மேலே பூமியைச் சுற்றுவதால் இதன் படங்கள் மிகத் தெளிவானவை.';

  @override
  String get spacecraftMarsRovers =>
      'கியூரியாசிட்டி (2012-இல் இறங்கியது), பெர்சிவியரன்ஸ் (2021-இல் இறங்கியது) இரண்டும் செவ்வாயில் ஓடிக்கொண்டிருக்கின்றன. செவ்வாய்க்கான தொலைவு சுமார் 5.5 கோடி கி.மீ முதல் 40 கோடி கி.மீக்கும் மேல் வரை மாறுகிறது.';

  @override
  String get searchTooltip => 'தேடு';

  @override
  String get searchHint => 'கோள்கள், நிலவுகள், பயணங்களைத் தேடுங்கள்…';

  @override
  String get searchClear => 'அழி';

  @override
  String searchEmpty(String query) {
    return '“$query” க்கு எதுவும் கிடைக்கவில்லை.';
  }

  @override
  String get searchBodies => 'கோள்களும் நிலவுகளும்';

  @override
  String get searchMissions => 'பயணங்கள்';

  @override
  String get searchSpacecraft => 'விண்கலங்கள்';

  @override
  String get favoritesTitle => 'பிடித்தவை';

  @override
  String get favoritesEmpty =>
      'ஒரு கோள், பயணம் அல்லது விண்கலத்தில் உள்ள நட்சத்திரத்தைத் தொடுங்கள்; அது இங்கே இருக்கும்.';

  @override
  String get favoriteAdd => 'பிடித்தவையில் சேர்';

  @override
  String get favoriteRemove => 'பிடித்தவையிலிருந்து நீக்கு';

  @override
  String get textSize => 'எழுத்து அளவு';

  @override
  String get textSizeNormal => 'இயல்பு';

  @override
  String get textSizeLarge => 'பெரியது';

  @override
  String get textSizeLarger => 'இன்னும் பெரியது';

  @override
  String get textSizeNote =>
      'Heliora-வின் எழுத்துகளைப் பெரிதாக்குகிறது. உங்கள் தொலைபேசியின் சொந்த எழுத்து அளவுக்குக் கீழே இது ஒருபோதும் செல்லாது.';

  @override
  String get skyOtherNight => 'இரவு வானம்';

  @override
  String get planetsThatNight => 'அந்த இரவின் கிரகங்கள்';

  @override
  String get previousDay => 'முந்தைய நாள்';

  @override
  String get nextDay => 'அடுத்த நாள்';

  @override
  String get pickDate => 'தேதியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get backToTonight => 'இன்றிரவுக்குத் திரும்பு';

  @override
  String get moonCalendar => 'நிலவு நாட்காட்டி';

  @override
  String get moonCalendarHint => 'ஒவ்வொரு நாளும் நிலவின் கட்டம்';

  @override
  String get previousMonth => 'முந்தைய மாதம்';

  @override
  String get nextMonth => 'அடுத்த மாதம்';

  @override
  String get keyMoonDates => 'இந்த மாதத்தின் முக்கிய கட்டங்கள்';

  @override
  String get moonCalendarNote =>
      'கட்டங்களின் தேதிகளும் நேரங்களும் உங்கள் தொலைபேசியின் நேர மண்டலத்தில் காட்டப்படுகின்றன; ஏறக்குறைய ஒரு மணி நேரத்திற்குள் துல்லியமானவை.';

  @override
  String get seeSkyThatDay => 'இந்த நாளின் வானத்தைப் பார்';

  @override
  String get sunLightTitle => 'சூரியனும் ஒளியும்';

  @override
  String get firstLight => 'முதல் ஒளி';

  @override
  String get goldenMorningEnds => 'காலைப் பொன் நேரம் முடிகிறது';

  @override
  String get solarNoon => 'சூரியன் உச்சத்தில்';

  @override
  String get goldenEveningStarts => 'மாலைப் பொன் நேரம் தொடங்குகிறது';

  @override
  String get lastLight => 'கடைசி ஒளி';

  @override
  String get darkSky => 'முழுவதும் இருண்ட வானம்';

  @override
  String get sunDayLength => 'பகல் நீளம்';

  @override
  String durationHm(String hours, String minutes) {
    return '$hours மணி $minutes நிமிடம்';
  }

  @override
  String get sunNote =>
      'சூரியன் அடிவானத்திலிருந்து 6°க்கும் குறைவாக உயரத்தில் இருக்கும்போது பொன் நேரம். அது 6° கீழே இருக்கும்போது முதல் மற்றும் கடைசி ஒளி, 18° கீழே இருக்கும்போது வானம் முழுவதும் இருண்டிருக்கும். நேரங்கள் நீங்கள் தேர்ந்தெடுத்த தேதிக்காகக் கணக்கிடப்பட்டவை.';

  @override
  String get sunStaysUp => 'இந்த நாளில் சூரியன் மறைவதில்லை.';

  @override
  String get sunStaysDown => 'இந்த நாளில் சூரியன் உதிப்பதில்லை.';

  @override
  String get solarSystemTitle => 'சூரியக் குடும்பம்';

  @override
  String get starMapTitle => 'நட்சத்திர வரைபடம்';

  @override
  String get starMapCardHint =>
      'உங்கள் வானில் உள்ள நட்சத்திரங்களும் விண்மீன் குழுக்களும்';

  @override
  String get starMapHint =>
      'சுற்றிப் பார்க்க இழுக்கவும், பெரிதாக்க இரு விரல்களால் விரிக்கவும், ஒரு நட்சத்திரம் அல்லது விண்மீன் குழுவைத் தொடவும்.';

  @override
  String get starsLabel => 'நட்சத்திரங்கள்';

  @override
  String get constellationsLabel => 'விண்மீன் குழுக்கள்';

  @override
  String get starMapFind => 'கண்டுபிடி';

  @override
  String get constellationsList => 'அனைத்து விண்மீன் குழுக்கள்';

  @override
  String magnitudeValue(String value) {
    return 'ஒளிர்வு $value';
  }

  @override
  String get starBelowHorizon => 'இந்த நேரத்தில் தொடுவானுக்குக் கீழே';

  @override
  String get starMapNow => 'இப்போது';

  @override
  String get starUnnamed => 'நட்சத்திரம்';

  @override
  String get binocularsTitle => 'பைனாகுலர் வழிகாட்டி';

  @override
  String get binocularsHint => 'சாதாரண பைனாகுலரில் என்ன பார்க்கலாம்';

  @override
  String get binocularsIntro =>
      'பைனாகுலரை நிலையாகப் பிடியுங்கள், எடுத்துக்காட்டாக முழங்கைகளைச் சுவரிலோ காரின் மேற்கூரையிலோ வைத்து. நகர விளக்குகளிலிருந்து விலகி, கூர்மையான நட்சத்திரங்களுக்குப் பதிலாக மங்கலான, பரவிய திட்டுகளைத் தேடுங்கள்.';

  @override
  String get binocularsNote =>
      'நீங்கள் தேர்ந்த நகரில் இரவின் இருண்ட பகுதியில் ஒவ்வொரு பொருளும் எப்போது மிக உயரத்தில் இருக்கும் என்பதை நேரங்கள் காட்டுகின்றன. பொருட்களின் பெயர்கள் உலகெங்கும் பயன்படுத்தப்படும் பெயர்கள். நட்சத்திர வரைபடத்தில் பார்க்க ஒன்றைத் தொடவும்.';

  @override
  String get dsoCluster => 'நட்சத்திரக் கொத்து';

  @override
  String get dsoGalaxy => 'அண்டம் (கேலக்ஸி)';

  @override
  String get dsoNebula => 'நெபுலா';

  @override
  String get storyOri =>
      'வேட்டைக்காரன் ஓரியன் (மிருகசீரிடம்) எளிதில் கண்டுபிடிக்கலாம்: ஒரு குறுகிய நேர்கோட்டில் உள்ள மூன்று நட்சத்திரங்கள் அவன் இடுப்புப் பட்டை. பட்டைக்கு மேலே ஆரஞ்சு நிற பெட்டல்ஜூஸ் ஒரு தோளையும், கீழே நீல-வெள்ளை ரைஜெல் ஒரு காலையும் குறிக்கின்றன. பட்டைக்குக் கீழே மங்கலான ஒரு திட்டு தொங்குகிறது, ஓரியன் நெபுலா, புதிய நட்சத்திரங்கள் பிறக்கும் ஒரு மேகம். ஓரியன் வடக்கில் குளிர்கால மாலையிலும் தெற்கில் கோடை மாலையிலும் தெரியும்.';

  @override
  String get storyUMa =>
      'பிக் டிப்பர் அல்லது கலப்பை என்றும் அழைக்கப்படும் சப்தரிஷி மண்டலத்தின் ஏழு பிரகாசமான நட்சத்திரங்கள் பெரிய கரடியின் பகுதி. கிண்ணத்தின் முனையில் உள்ள இரு நட்சத்திரங்கள், துப்ஹே மற்றும் மெராக், துருவ நட்சத்திரத்துக்கு வழி காட்டுகின்றன: அவற்றுக்கு இடையிலான தூரத்தின் ஏறக்குறைய ஐந்து மடங்கு தூரம் வரை கோட்டை மேலே நீட்டுங்கள். வடக்கின் பல இடங்களிலிருந்து சப்தரிஷி மண்டலம் இரவு முழுவதும் துருவ நட்சத்திரத்தைச் சுற்றி வரும், ஒருபோதும் மறையாது.';

  @override
  String get storyUMi =>
      'துருவ நட்சத்திரம் (போலாரிஸ்) சிறிய கரடியின் வால் நுனியில் உள்ளது. இது பூமியின் வட துருவத்துக்கு கிட்டத்தட்ட நேர் மேலே இருப்பதால் அரிதாகவே நகர்கிறது, எனவே வானம் முழுவதும் இதைச் சுற்றித் திரும்புவது போலத் தோன்றும். தொடுவானிலிருந்து இதன் உயரம் உங்கள் அட்சரேகைக்குச் சமம். இது மிகப் பிரகாசமான நட்சத்திரம் அல்ல, ஆனால் வடக்கைக் கண்டறிய மிகவும் பயனுள்ளது. உலகின் தெற்குப் பாதியிலிருந்து இதைப் பார்க்க முடியாது.';

  @override
  String get storyCas =>
      'கசியோபியா நேரம் மற்றும் பருவத்தைப் பொறுத்து W அல்லது M போலத் தோன்றும், ஐந்து ஓரளவு பிரகாசமான நட்சத்திரங்களால் ஆனது. இது துருவ நட்சத்திரத்தின் மறுபக்கம், சப்தரிஷி மண்டலத்துக்கு எதிர்ப்புறம் உள்ளது, எனவே ஒன்று தாழ்வாக இருக்கும்போது மற்றது உயரத்தில் இருக்கும். பழைய கதையில் அவள் தன் அழகைப் பற்றிப் பெருமை பேசிய ஓர் அரசி.';

  @override
  String get storyCyg =>
      'அன்னம் (சிக்னஸ்) பால்வழி வழியே பறக்கிறது. அதன் மிகப் பிரகாசமான நட்சத்திரங்கள் வடக்கு சிலுவையை உருவாக்குகின்றன; உச்சியில் டெனெப், அதாவது அன்னத்தின் வால். நகர விளக்குகளிலிருந்து விலகினால் பால்வழி அன்னத்தின் ஊடே ஓடும் வெளிறிய ஒளி ஆறு போலத் தெரியும், அது எண்ணற்ற மங்கலான நட்சத்திரங்களால் ஆனது என்பதை பைனாகுலர் காட்டும். கோடை மற்றும் இலையுதிர் கால மாலைகள் சிறந்த நேரம்.';

  @override
  String get storySco =>
      'விருச்சிகம் (ஸ்கார்பியஸ்) வளைந்த வாலும் கொக்கி போன்ற முனையும் கொண்ட தேளைப் போலத் தோன்றும். அதன் இதயம் சிவந்த கேட்டை (ஆன்டாரஸ்); அந்தப் பெயரின் பொருள் செவ்வாயின் போட்டியாளர், ஏனெனில் இரண்டும் நிறத்தில் ஒன்று போலத் தெரியும். வடக்கில் இது கோடைக்கால விண்மீன் குழு, தெற்கில் தாழ்வாகத் தெரியும், உலகின் தெற்குப் பாதியில் உள்ளவர்களின் தலைக்கு மேல் உயரமாகக் கடந்து செல்லும்.';

  @override
  String get storyLeo =>
      'சிம்மம் (லியோ) தன் விலங்கைப் போலவே உண்மையில் தோன்றும் சில விண்மீன் குழுக்களில் ஒன்று. நட்சத்திரங்களின் தலைகீழ் கேள்விக்குறி, அரிவாள், தலையையும் மார்பையும் உருவாக்கி, பிரகாசமான மகம் (ரெகுலஸ்), சிங்கத்தின் இதயத்தில் முடிகிறது. கிழக்கே உள்ள நட்சத்திர முக்கோணம் அதன் பின்புறம். வடக்கில் வசந்த கால மாலைகள் சிறந்த நேரம்.';

  @override
  String get storyTau =>
      'ரிஷபம் (டாரஸ்) முகம் V வடிவம், அது ஹையடிஸ் கொத்து, ஆரஞ்சு நிற ரோகிணி (ஆல்டிபரான்) அதன் கண். ரோகிணி கொத்தின் பகுதி போலத் தெரியும், ஆனால் உண்மையில் அது நமக்கு மிக அருகில் உள்ளது. மேலே கார்த்திகை (பிளியாடீஸ்), அதாவது ஏழு சகோதரிகள், நீல நட்சத்திரங்களின் சிறிய கூட்டம்; பெரும்பாலானோர் ஆறு அல்லது ஏழு நட்சத்திரங்களைக் காண்கிறார்கள். கார்த்திகை உலகெங்கும் அறியப்பட்டது, பல கலாச்சாரக் கதைகளில் வருகிறது.';

  @override
  String get storyGem =>
      'மிதுனம் (ஜெமினி) இரு பிரகாசமான நட்சத்திரங்களான காஸ்டர் மற்றும் பொலக்ஸ் மூலம் அடையாளம் காணப்படுகிறது; அவை இரு சகோதரர்களின் தலைகள் போல அருகருகே நிற்கின்றன. பொலக்ஸ் அதிகப் பிரகாசமானது, ஆரஞ்சு சாயல் கொண்டது. காஸ்டர் உண்மையில் ஆறு நட்சத்திரங்களின் அமைப்பு. வடக்கில் குளிர்கால, வசந்த கால மாலைகளில் வானில் உயரத்தில் அவற்றைத் தேடுங்கள்.';

  @override
  String get storyLyr =>
      'வீணை (லைரா) சிறியது, ஆனால் வட வானின் மிகப் பிரகாசமான நட்சத்திரங்களில் ஒன்றான அபிஜித் (வேகா) அதில் உள்ளது. அபிஜித் நீல-வெள்ளை நிறம்; சிக்னஸின் டெனெப், அக்விலாவின் அல்டேர் ஆகியவற்றுடன் சேர்ந்து கோடை முக்கோணத்தை உருவாக்குகிறது. அபிஜித்துக்கு அருகிலேயே நட்சத்திரங்களின் சிறிய இணைகரம் வீணையின் உடலை உருவாக்குகிறது.';

  @override
  String get storyCru =>
      'க்ரக்ஸ், தெற்கு சிலுவை, அனைத்து விண்மீன் குழுக்களிலும் மிகச் சிறியது, ஆனால் மிகப் பிரபலமானவற்றில் ஒன்று. நான்கு பிரகாசமான நட்சத்திரங்கள் சிலுவையை உருவாக்குகின்றன, அதன் நீண்ட கையின் இரு நட்சத்திரங்கள் தெற்கு வான் துருவத்தை நோக்கிச் சுட்டுகின்றன, எனவே பயணிகள் தெற்கைக் கண்டறிய இது உதவுகிறது. உலகின் வடக்குப் பாதியின் பெரும்பாலான இடங்களிலிருந்து இதைப் பார்க்க முடியாது.';
}
