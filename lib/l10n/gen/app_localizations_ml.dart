// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appTitle => 'Heliora';

  @override
  String get tagline => 'സൗരയൂഥം കണ്ടെത്താം, പൂർണ്ണമായും ഓഫ്‌ലൈനിൽ';

  @override
  String get navExplore => 'കണ്ടെത്തുക';

  @override
  String get navCompare => 'താരതമ്യം';

  @override
  String get navWeight => 'ഭാരം';

  @override
  String get navQuiz => 'ക്വിസ്';

  @override
  String get viewMode => 'കാഴ്ച മോഡ്';

  @override
  String get settings => 'ക്രമീകരണങ്ങൾ';

  @override
  String get notToScale =>
      'അളവിന് അനുസരിച്ചല്ല · തുറക്കാൻ ഗ്രഹത്തിൽ ടാപ്പ് ചെയ്യുക';

  @override
  String get dragToRotate => 'തിരിക്കാൻ വലിക്കുക · സൂം ചെയ്യാൻ പിഞ്ച് ചെയ്യുക';

  @override
  String get planetsTitle => 'ഗ്രഹങ്ങൾ';

  @override
  String get planetMercury => 'ബുധൻ';

  @override
  String get planetVenus => 'ശുക്രൻ';

  @override
  String get planetEarth => 'ഭൂമി';

  @override
  String get planetMars => 'ചൊവ്വ';

  @override
  String get planetJupiter => 'വ്യാഴം';

  @override
  String get planetSaturn => 'ശനി';

  @override
  String get planetUranus => 'യുറാനസ്';

  @override
  String get planetNeptune => 'നെപ്റ്റ്യൂൺ';

  @override
  String planetOrder(int n) {
    return 'സൂര്യനിൽ നിന്ന് $n-ാമത്തെ ഗ്രഹം';
  }

  @override
  String get openDetails => 'വിശദാംശങ്ങൾ തുറക്കുക';

  @override
  String get diameter => 'വ്യാസം';

  @override
  String get gravity => 'ഗുരുത്വാകർഷണം';

  @override
  String get avgTemp => 'ശരാശരി താപനില';

  @override
  String get avgTempShort => 'ശരാശരി താപനില';

  @override
  String get dayLength => 'ദിവസം';

  @override
  String get yearLength => 'വർഷം';

  @override
  String get moons => 'അറിയപ്പെടുന്ന ഉപഗ്രഹങ്ങൾ';

  @override
  String get moonsShort => 'ഉപഗ്രഹങ്ങൾ';

  @override
  String get distance => 'സൂര്യനിൽ നിന്നുള്ള ദൂരം';

  @override
  String get pressure => 'ഉപരിതല മർദ്ദം';

  @override
  String get noSurface => 'ഉറച്ച ഉപരിതലമില്ല';

  @override
  String valueKm(String value) {
    return '$value കി.മീ';
  }

  @override
  String valueMillionKm(String value) {
    return '$value ദശലക്ഷം കി.മീ';
  }

  @override
  String valueHours(String value) {
    return '$value മണിക്കൂർ';
  }

  @override
  String valueDays(String value) {
    return '$value ദിവസം';
  }

  @override
  String valueYears(String value) {
    return '$value വർഷം';
  }

  @override
  String get atmosphere => 'അന്തരീക്ഷം';

  @override
  String get thinAtmosphere =>
      'ഏകദേശം അന്തരീക്ഷമില്ല. ഈ വാതകങ്ങൾ എക്സോസ്ഫിയർ എന്ന വളരെ നേർത്ത പാളി ഉണ്ടാക്കുന്നു.';

  @override
  String get oxygen => 'ഓക്സിജൻ';

  @override
  String get oxygenVsEarth => 'ഓക്സിജൻ: ഭൂമിയുമായി താരതമ്യം';

  @override
  String get breathable => 'മനുഷ്യർക്ക് ശ്വസിക്കാൻ കഴിയും';

  @override
  String get notBreathable => 'ശ്വസിക്കാൻ കഴിയില്ല, സ്പേസ് സ്യൂട്ട് വേണം';

  @override
  String weightFeelsLike(String weight) {
    return 'ഭൂമിയിലെ $weight കിലോ ഇവിടെ ഇത്രയാകും';
  }

  @override
  String get gasCo2 => 'കാർബൺ ഡയോക്സൈഡ്';

  @override
  String get gasN2 => 'നൈട്രജൻ';

  @override
  String get gasO2 => 'ഓക്സിജൻ';

  @override
  String get gasAr => 'ആർഗൺ';

  @override
  String get gasH2 => 'ഹൈഡ്രജൻ';

  @override
  String get gasHe => 'ഹീലിയം';

  @override
  String get gasCh4 => 'മീഥെയ്ൻ';

  @override
  String get gasNa => 'സോഡിയം';

  @override
  String get gasK => 'പൊട്ടാസ്യം';

  @override
  String get compareTitle => 'ഗ്രഹങ്ങളുടെ താരതമ്യം';

  @override
  String get compareHint => 'അടുത്തടുത്ത് കാണാൻ രണ്ട് ഗ്രഹങ്ങൾ തിരഞ്ഞെടുക്കുക.';

  @override
  String get weightTitle => 'മറ്റ് ഗ്രഹങ്ങളിൽ നിങ്ങളുടെ ഭാരം';

  @override
  String get weightInput => 'ഭൂമിയിലെ നിങ്ങളുടെ ഭാരം (കിലോ)';

  @override
  String gravityTimes(String factor) {
    return 'ഭൂമിയുടെ ഗുരുത്വാകർഷണത്തിന്റെ $factor×';
  }

  @override
  String get quizTitle => 'ഗ്രഹ ക്വിസ്';

  @override
  String get quizIntro =>
      'ഗ്രഹങ്ങളെയും ഉപഗ്രഹങ്ങളെയും കുറിച്ച് 10 ചോദ്യങ്ങൾ. എത്രയെണ്ണം ശരിയാക്കാം?';

  @override
  String get quizStart => 'ക്വിസ് തുടങ്ങുക';

  @override
  String quizProgress(int current, int total) {
    return 'ചോദ്യം $current / $total';
  }

  @override
  String get quizNext => 'അടുത്തത്';

  @override
  String get quizSeeResult => 'ഫലം കാണുക';

  @override
  String get quizCorrect => 'ശരി!';

  @override
  String quizWrong(String answer) {
    return 'അല്ല. ശരിയായ ഉത്തരം $answer.';
  }

  @override
  String quizScore(int score, int total) {
    return '$total-ൽ $score ശരി';
  }

  @override
  String quizBest(int score) {
    return 'മികച്ച സ്കോർ: $score';
  }

  @override
  String get quizNewBest => 'പുതിയ മികച്ച സ്കോർ!';

  @override
  String get quizAgain => 'വീണ്ടും കളിക്കുക';

  @override
  String get qLargest => 'ഏറ്റവും വലിയ ഗ്രഹം ഏത്?';

  @override
  String get qSmallest => 'ഏറ്റവും ചെറിയ ഗ്രഹം ഏത്?';

  @override
  String get qHottest => 'ഏറ്റവും ചൂടുള്ള ഗ്രഹം ഏത്?';

  @override
  String get qColdest => 'ഏറ്റവും തണുത്ത ഗ്രഹം ഏത്?';

  @override
  String get qMostMoons =>
      'ഏറ്റവും കൂടുതൽ അറിയപ്പെടുന്ന ഉപഗ്രഹങ്ങൾ ഉള്ള ഗ്രഹം ഏത്?';

  @override
  String get qBreathable =>
      'ഏത് ഗ്രഹത്തിലാണ് മനുഷ്യർക്ക് വായു ശ്വസിക്കാൻ കഴിയുന്നത്?';

  @override
  String get qClosest => 'സൂര്യനോട് ഏറ്റവും അടുത്ത ഗ്രഹം ഏത്?';

  @override
  String get qFarthest => 'സൂര്യനിൽ നിന്ന് ഏറ്റവും അകലെയുള്ള ഗ്രഹം ഏത്?';

  @override
  String get qStrongestGravity =>
      'ഏറ്റവും ശക്തമായ ഗുരുത്വാകർഷണം ഉള്ള ഗ്രഹം ഏത്?';

  @override
  String get qShortestDay => 'ഏറ്റവും ചെറിയ ദിവസമുള്ള ഗ്രഹം ഏത്?';

  @override
  String get qLongestDay => 'ഏറ്റവും നീണ്ട ദിവസമുള്ള ഗ്രഹം ഏത്?';

  @override
  String get appearance => 'രൂപം';

  @override
  String get theme => 'തീം';

  @override
  String get themeSystem => 'സിസ്റ്റം';

  @override
  String get themeLight => 'ലൈറ്റ്';

  @override
  String get themeDark => 'ഡാർക്ക്';

  @override
  String get language => 'ഭാഷ';

  @override
  String get appLanguage => 'ആപ്പ് ഭാഷ';

  @override
  String get languageNote => '20 ഭാഷകൾ · ഗ്രഹങ്ങളുടെ പേരുകളും';

  @override
  String get phoneLanguage => 'ഫോണിന്റെ ഭാഷ';

  @override
  String get updates => 'അപ്ഡേറ്റുകൾ';

  @override
  String get version => 'പതിപ്പ്';

  @override
  String get checkForUpdates => 'അപ്ഡേറ്റ് പരിശോധിക്കുക';

  @override
  String get checking => 'പരിശോധിക്കുന്നു…';

  @override
  String get autoUpdateCheck => 'ദിവസം ഒരിക്കൽ സ്വയം പരിശോധിക്കുക';

  @override
  String get updateNote =>
      'അപ്ഡേറ്റുകൾ GitHub Releases-ൽ നിന്നാണ് വരുന്നത്. നിങ്ങളുടെ ക്രമീകരണങ്ങൾ ഫോണിൽ തന്നെ നിൽക്കും.';

  @override
  String get upToDate => 'നിങ്ങളുടെ കൈവശം ഏറ്റവും പുതിയ പതിപ്പാണ്.';

  @override
  String get updateFailed =>
      'GitHub-ൽ എത്താനായില്ല. ഇന്റർനെറ്റ് പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get updateAvailable => 'അപ്ഡേറ്റ് ലഭ്യമാണ്';

  @override
  String updateReady(String version) {
    return 'പതിപ്പ് $version ഡൗൺലോഡിന് തയ്യാറാണ്.';
  }

  @override
  String get download => 'ഡൗൺലോഡ്';

  @override
  String get later => 'പിന്നീട്';

  @override
  String get about => 'വിവരം';

  @override
  String get sourceCode => 'GitHub-ൽ സോഴ്സ് കോഡ്';

  @override
  String get privacyLine => 'ഓഫ്‌ലൈൻ · പരസ്യങ്ങളില്ല · ട്രാക്കിംഗ് ഇല്ല';

  @override
  String get dataSource => 'വിവരങ്ങൾ: NASA Planetary Fact Sheet';

  @override
  String get openFailed => 'ലിങ്ക് തുറക്കാനായില്ല.';

  @override
  String get bodySun => 'സൂര്യൻ';

  @override
  String get bodyMoon => 'ചന്ദ്രൻ';

  @override
  String get bodyPluto => 'പ്ലൂട്ടോ';

  @override
  String get moonIo => 'അയോ';

  @override
  String get moonEuropa => 'യൂറോപ്പ';

  @override
  String get moonGanymede => 'ഗാനിമീഡ്';

  @override
  String get moonCallisto => 'കാലിസ്റ്റോ';

  @override
  String get moonTitan => 'ടൈറ്റൻ';

  @override
  String get moonEnceladus => 'എൻസെലാഡസ്';

  @override
  String get moonTriton => 'ട്രൈറ്റൺ';

  @override
  String get kindStar => 'നമ്മുടെ നക്ഷത്രം, സൗരയൂഥത്തിന്റെ കേന്ദ്രം';

  @override
  String get kindDwarf => 'കുള്ളൻ ഗ്രഹം';

  @override
  String moonOf(String planet) {
    return '$planet-ന്റെ ഉപഗ്രഹം';
  }

  @override
  String get orbitPeriod => 'ഒരു ഭ്രമണം';

  @override
  String distanceFrom(String body) {
    return '$body-ൽ നിന്നുള്ള ദൂരം';
  }

  @override
  String get composition => 'ഇത് എന്തുകൊണ്ട് നിർമ്മിച്ചതാണ്';

  @override
  String get noAtmosphere => 'യഥാർത്ഥ അന്തരീക്ഷമില്ല, ഏകദേശം ശൂന്യത.';

  @override
  String get majorMoons => 'പ്രധാന ഉപഗ്രഹങ്ങൾ';

  @override
  String get lifeTitle => 'മനുഷ്യർക്ക് ഇവിടെ ജീവിക്കാനാകുമോ?';

  @override
  String get lifeScoreShort => 'ജീവൻ സ്കോർ';

  @override
  String get lifeNote =>
      'താപനില, വായുമർദ്ദം, ഓക്സിജൻ, വെള്ളം, ഉപരിതലം, ഗുരുത്വാകർഷണം എന്നിവയിൽ നിന്ന് കണക്കാക്കിയത്. ഭൂമിക്ക് 10.';

  @override
  String get water => 'വെള്ളം';

  @override
  String get waterLiquid => 'ദ്രാവക ജലം';

  @override
  String get waterIce => 'ഐസ്';

  @override
  String get waterOcean => 'ഐസിനടിയിൽ സമുദ്രം';

  @override
  String get waterNone => 'വെള്ളമില്ല';

  @override
  String get surface => 'ഉപരിതലം';

  @override
  String get solidSurface => 'ഉറച്ച ഉപരിതലം';

  @override
  String get lifeHome => 'വീട് പോലെ തന്നെ';

  @override
  String get lifeHard =>
      'വളരെ ബുദ്ധിമുട്ട്, അടച്ച താവളവും സ്പേസ് സ്യൂട്ടും വേണം';

  @override
  String get lifeNo => 'മനുഷ്യർക്ക് അസാധ്യം';

  @override
  String get downloadInstall => 'ഡൗൺലോഡ് ചെയ്ത് ഇൻസ്റ്റാൾ ചെയ്യുക';

  @override
  String downloadingPercent(String percent) {
    return 'ഡൗൺലോഡ് ചെയ്യുന്നു… $percent%';
  }

  @override
  String get installNow => 'ഇൻസ്റ്റാൾ';

  @override
  String get allowInstalls =>
      'തുറന്ന സ്ക്രീനിൽ Heliora-യ്ക്ക് ആപ്പുകൾ ഇൻസ്റ്റാൾ ചെയ്യാൻ അനുവാദം നൽകുക, തിരികെ വന്ന് ഇൻസ്റ്റാൾ അമർത്തുക.';

  @override
  String get downloadFailed =>
      'ഡൗൺലോഡ് പൂർത്തിയായില്ല. ഇന്റർനെറ്റ് പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get tryAgain => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get today => 'ഇന്ന്';

  @override
  String get play => 'പ്ലേ';

  @override
  String get pause => 'നിർത്തുക';

  @override
  String get monthBack => '30 ദിവസം മുമ്പ്';

  @override
  String get monthForward => '30 ദിവസം കഴിഞ്ഞ്';

  @override
  String get positionsNote =>
      'ഈ തീയതിയിലെ യഥാർത്ഥ സ്ഥാനങ്ങൾ · വലിപ്പവും ദൂരവും അളവിനനുസരിച്ചല്ല · ഗ്രഹത്തിൽ ടാപ്പ് ചെയ്യുക';

  @override
  String get navYou => 'നിങ്ങൾ';

  @override
  String get ageTitle => 'മറ്റ് ഗ്രഹങ്ങളിൽ നിങ്ങളുടെ പ്രായം';

  @override
  String get setBirthDate => 'നിങ്ങളുടെ ജനനത്തീയതി നൽകുക';

  @override
  String get changeBirthDate => 'മാറ്റുക';

  @override
  String nextBirthday(String days) {
    return 'അടുത്ത ജന്മദിനം $days ദിവസത്തിൽ';
  }

  @override
  String get ageNote => 'നിങ്ങളുടെ ജനനത്തീയതി ഈ ഫോണിൽ മാത്രം സൂക്ഷിക്കും.';

  @override
  String get share => 'പങ്കിടുക';

  @override
  String shareText(String planet) {
    return 'Heliora-യിൽ $planet, സൗജന്യ ഓഫ്‌ലൈൻ സൗരയൂഥ ആപ്പ്: https://github.com/lumio-apps/heliora';
  }

  @override
  String get shareFailed => 'ചിത്രം പങ്കിടാനായില്ല.';

  @override
  String get travelTitle => 'എത്ര ദൂരെയാണ്?';

  @override
  String get distanceFromEarth => 'ഇന്ന് ഭൂമിയിൽ നിന്നുള്ള ദൂരം';

  @override
  String get lightTime => 'പ്രകാശത്തിന് വേണ്ട സമയം';

  @override
  String get bySpacecraft => 'മണിക്കൂറിൽ 60,000 കി.മീ ബഹിരാകാശ പേടകത്തിൽ';

  @override
  String get byCar => 'മണിക്കൂറിൽ 100 കി.മീ കാറിൽ';

  @override
  String valueSeconds(String value) {
    return '$value സെ';
  }

  @override
  String valueMinutes(String value) {
    return '$value മിനിറ്റ്';
  }

  @override
  String get sizeTitle => 'വലിപ്പം';

  @override
  String sizeTimes(String big, String times, String small) {
    return '$big വീതിയിൽ $small-നെക്കാൾ $times× വലുതാണ്.';
  }

  @override
  String sizeSimilar(String a, String b) {
    return '$a-യും $b-യും ഏകദേശം ഒരേ വലിപ്പം.';
  }

  @override
  String get navSky => 'ആകാശം';

  @override
  String get skyTitle => 'ഇന്ന് രാത്രിയിലെ ആകാശം';

  @override
  String get chooseCity => 'നിങ്ങളുടെ നഗരം തിരഞ്ഞെടുക്കുക';

  @override
  String get chooseCityHint =>
      'ചന്ദ്രനെയും ഇന്ന് രാത്രി കാണാവുന്ന ഗ്രഹങ്ങളെയും അറിയാൻ അടുത്തുള്ള നഗരം തിരഞ്ഞെടുക്കുക. ലൊക്കേഷൻ അനുമതി വേണ്ട, ഇത് ഫോണിൽ തന്നെ നിൽക്കും.';

  @override
  String get searchCity => 'നഗരം തിരയുക';

  @override
  String get noCityFound => 'നഗരം കണ്ടെത്തിയില്ല';

  @override
  String get cityNote =>
      'സമയം ഫോണിന്റെ ടൈം സോണിലാണ്. ഇരുണ്ട ആകാശത്ത് ചക്രവാളത്തിൽ നിന്ന് കുറഞ്ഞത് 5° ഉയരത്തിലാണെങ്കിൽ ഗ്രഹം കാണാമെന്ന് കണക്കാക്കുന്നു.';

  @override
  String illuminated(String percent) {
    return '$percent% പ്രകാശിതം';
  }

  @override
  String get moonrise => 'ചന്ദ്രോദയം';

  @override
  String get moonset => 'ചന്ദ്രാസ്തമയം';

  @override
  String get sunset => 'സൂര്യാസ്തമയം';

  @override
  String get sunrise => 'സൂര്യോദയം';

  @override
  String get nextFull => 'അടുത്ത പൗർണ്ണമി';

  @override
  String get nextNew => 'അടുത്ത അമാവാസി';

  @override
  String get phaseNew => 'അമാവാസി';

  @override
  String get phaseWaxingCrescent => 'വളരുന്ന ചന്ദ്രക്കല';

  @override
  String get phaseFirstQuarter => 'ശുക്ലപക്ഷ അഷ്ടമി';

  @override
  String get phaseWaxingGibbous => 'വളരുന്ന ചന്ദ്രൻ';

  @override
  String get phaseFull => 'പൗർണ്ണമി';

  @override
  String get phaseWaningGibbous => 'കുറയുന്ന ചന്ദ്രൻ';

  @override
  String get phaseLastQuarter => 'കൃഷ്ണപക്ഷ അഷ്ടമി';

  @override
  String get phaseWaningCrescent => 'കുറയുന്ന ചന്ദ്രക്കല';

  @override
  String get planetsTonight => 'ഇന്ന് രാത്രിയിലെ ഗ്രഹങ്ങൾ';

  @override
  String get statusVisible => 'ഇന്ന് രാത്രി കാണാം';

  @override
  String get statusEvening => 'വൈകുന്നേരം, സൂര്യാസ്തമയത്തിന് ശേഷം';

  @override
  String get statusMorning => 'രാവിലെ, സൂര്യോദയത്തിന് മുമ്പ്';

  @override
  String get statusNotVisible => 'ഇന്ന് രാത്രി കാണില്ല';

  @override
  String bestAt(String time) {
    return 'ഏറ്റവും നല്ല സമയം $time';
  }

  @override
  String altitudeDir(String direction, String degrees) {
    return '$direction, $degrees° ഉയരത്തിൽ';
  }

  @override
  String riseSet(String rise, String set) {
    return 'ഉദയം $rise · അസ്തമയം $set';
  }

  @override
  String get needsTelescope => 'ബൈനോക്കുലറോ ടെലിസ്കോപ്പോ വേണം';

  @override
  String get dirN => 'വടക്ക്';

  @override
  String get dirNE => 'വടക്കുകിഴക്ക്';

  @override
  String get dirE => 'കിഴക്ക്';

  @override
  String get dirSE => 'തെക്കുകിഴക്ക്';

  @override
  String get dirS => 'തെക്ക്';

  @override
  String get dirSW => 'തെക്കുപടിഞ്ഞാറ്';

  @override
  String get dirW => 'പടിഞ്ഞാറ്';

  @override
  String get dirNW => 'വടക്കുപടിഞ്ഞാറ്';

  @override
  String get findPlanet => 'ആകാശത്ത് കണ്ടെത്തുക';

  @override
  String finderTitle(String name) {
    return '$name കണ്ടെത്തുക';
  }

  @override
  String get pointPhone => 'ഫോൺ ഉയർത്തി പതുക്കെ ചുറ്റും നീക്കുക.';

  @override
  String turnRight(String degrees) {
    return '$degrees° വലത്തേക്ക് തിരിയുക';
  }

  @override
  String turnLeft(String degrees) {
    return '$degrees° ഇടത്തേക്ക് തിരിയുക';
  }

  @override
  String tiltUp(String degrees) {
    return '$degrees° മുകളിലേക്ക് ഉയർത്തുക';
  }

  @override
  String tiltDown(String degrees) {
    return '$degrees° താഴേക്ക് താഴ്ത്തുക';
  }

  @override
  String onTarget(String name) {
    return '$name അവിടെത്തന്നെയുണ്ട്!';
  }

  @override
  String belowHorizon(String name) {
    return '$name ഇപ്പോൾ ചക്രവാളത്തിന് താഴെയാണ്.';
  }

  @override
  String risesAt(String time) {
    return 'ഇത് $time-ന് ഉദിക്കും.';
  }

  @override
  String get noSensor =>
      'ഈ ഫോണിൽ കോമ്പസ് സെൻസർ ഇല്ല, അതിനാൽ ഫൈൻഡർ പ്രവർത്തിക്കില്ല.';

  @override
  String get calibrate =>
      'കോമ്പസ് കാലിബ്രേറ്റ് ചെയ്യണം: ഫോൺ കുറച്ചുതവണ 8 ആകൃതിയിൽ ചലിപ്പിക്കുക.';

  @override
  String get phoneNow => 'നിങ്ങളുടെ ഫോൺ ചൂണ്ടുന്നത്';

  @override
  String get finderNote =>
      'ഫോണിന്റെ പിൻഭാഗം ആകാശത്തേക്ക് പിടിക്കുക, കാന്തത്തിൽനിന്നും ലോഹത്തിൽനിന്നും അകറ്റി വയ്ക്കുക. ഒരിക്കലും സൂര്യനെ നോക്കരുത്.';

  @override
  String get eventsTitle => 'ബഹിരാകാശ സംഭവങ്ങൾ';

  @override
  String get eventsSubtitle => 'അടുത്ത 12 മാസത്തിൽ ആകാശത്ത് എന്തൊക്കെ കാണാം.';

  @override
  String eventsNext(String event, String when) {
    return 'അടുത്തത്: $event · $when';
  }

  @override
  String get eventFullMoon => 'പൗർണമി';

  @override
  String get eventNewMoon => 'അമാവാസി';

  @override
  String eventOpposition(String planet) {
    return '$planet പ്രതിയോഗത്തിൽ';
  }

  @override
  String eventEveningElongation(String planet) {
    return '$planet: സന്ധ്യയ്ക്ക് കാണാൻ ഏറ്റവും നല്ല സമയം';
  }

  @override
  String eventMorningElongation(String planet) {
    return '$planet: പുലർച്ചെ കാണാൻ ഏറ്റവും നല്ല സമയം';
  }

  @override
  String eventConjunction(String a, String b) {
    return '$aയും $bയും അടുത്തെത്തുന്നു';
  }

  @override
  String get eventMarchEquinox => 'മാർച്ച് വിഷുവം';

  @override
  String get eventJuneSolstice => 'ജൂൺ അയനാന്തം';

  @override
  String get eventSeptemberEquinox => 'സെപ്റ്റംബർ വിഷുവം';

  @override
  String get eventDecemberSolstice => 'ഡിസംബർ അയനാന്തം';

  @override
  String get eventFullMoonDesc =>
      'ചന്ദ്രന്റെ മുഖം മുഴുവൻ പ്രകാശിക്കുന്നു. സൂര്യാസ്തമയത്തോടടുത്ത് ഉദിക്കും.';

  @override
  String get eventNewMoonDesc =>
      'ചന്ദ്രൻ കാണില്ല. നക്ഷത്രങ്ങളെയും ഗ്രഹങ്ങളെയും കാണാൻ മാസത്തിലെ ഏറ്റവും ഇരുണ്ട ആകാശം.';

  @override
  String eventOppositionDesc(String planet) {
    return '$planet സൂര്യന് നേർ എതിർവശത്താണ്. ഈ വർഷം ഇത് ഏറ്റവും തിളക്കമുള്ളതും രാത്രി മുഴുവൻ കാണുന്നതുമാണ്.';
  }

  @override
  String eventEveningDesc(String planet, String degrees) {
    return '$planet സൂര്യനിൽ നിന്ന് $degrees° അകലെ, ഏറ്റവും കൂടുതൽ അകലം. സൂര്യാസ്തമയത്തിനു ശേഷം പടിഞ്ഞാറ് താഴെ നോക്കൂ.';
  }

  @override
  String eventMorningDesc(String planet, String degrees) {
    return '$planet സൂര്യനിൽ നിന്ന് $degrees° അകലെ, ഏറ്റവും കൂടുതൽ അകലം. സൂര്യോദയത്തിനു മുമ്പ് കിഴക്ക് താഴെ നോക്കൂ.';
  }

  @override
  String eventConjunctionDesc(String degrees) {
    return 'ആകാശത്ത് ഇവ വെറും $degrees° അകലത്തിലൂടെ കടന്നുപോകുന്നു.';
  }

  @override
  String get eventEquinoxDesc =>
      'ഭൂമിയിൽ എല്ലായിടത്തും പകലും രാത്രിയും ഏകദേശം തുല്യം.';

  @override
  String get eventJuneSolsticeDesc =>
      'വടക്ക് ഏറ്റവും നീണ്ട പകൽ, തെക്ക് ഏറ്റവും ചെറിയ പകൽ.';

  @override
  String get eventDecemberSolsticeDesc =>
      'വടക്ക് ഏറ്റവും ചെറിയ പകൽ, തെക്ക് ഏറ്റവും നീണ്ട പകൽ.';

  @override
  String eventMeteorShower(String shower) {
    return '$shower ഉൽക്കാവർഷം';
  }

  @override
  String eventMeteorDesc(String rate, String percent) {
    return 'ഇരുണ്ട ആകാശത്ത് മണിക്കൂറിൽ ഏകദേശം $rate ഉൽക്കകൾ വരെ. ചന്ദ്രൻ $percent% പ്രകാശിച്ചിരിക്കും.';
  }

  @override
  String get showerQuadrantids => 'ക്വാഡ്രാന്റിഡ്സ്';

  @override
  String get showerLyrids => 'ലൈറിഡ്സ്';

  @override
  String get showerEtaAquariids => 'എറ്റ അക്വേറിഡ്സ്';

  @override
  String get showerPerseids => 'പെർസിഡ്സ്';

  @override
  String get showerOrionids => 'ഓറിയോണിഡ്സ്';

  @override
  String get showerLeonids => 'ലിയോണിഡ്സ്';

  @override
  String get showerGeminids => 'ജെമിനിഡ്സ്';

  @override
  String get showerUrsids => 'അർസിഡ്സ്';

  @override
  String get eventToday => 'ഇന്ന്';

  @override
  String get eventTomorrow => 'നാളെ';

  @override
  String eventInDays(String days) {
    return '$days ദിവസത്തിൽ';
  }

  @override
  String get eventsNote =>
      'തീയതികൾ നിങ്ങളുടെ ഫോണിൽത്തന്നെ കണക്കാക്കി അതിന്റെ ടൈം സോണിൽ കാണിക്കുന്നു. ഉൽക്കാവർഷത്തിന്റെ ഉച്ചസ്ഥായി ദിവസങ്ങൾ ഓരോ വർഷത്തെയും സാധാരണ തീയതികളാണ്, ഒരു ദിവസം മാറിയേക്കാം. റിമൈൻഡറുകൾ നിങ്ങളുടെ ഫോണിൽത്തന്നെ ഇരിക്കും.';

  @override
  String get remindMe => 'എന്നെ ഓർമിപ്പിക്കൂ';

  @override
  String reminderSet(String date) {
    return 'ശരി, $date-ന് ഞാൻ ഓർമിപ്പിക്കാം.';
  }

  @override
  String get reminderOff => 'റിമൈൻഡർ നീക്കി.';

  @override
  String get reminderTooLate =>
      'ഈ സംഭവം വളരെ അടുത്താണ്, റിമൈൻഡർ വയ്ക്കാനാകില്ല.';

  @override
  String get notificationsOff =>
      'Heliora-യുടെ അറിയിപ്പുകൾ ഓഫാണ്. Android ക്രമീകരണത്തിൽ ഓണാക്കൂ.';

  @override
  String get reminderTomorrow => 'നാളെ നടക്കും';

  @override
  String get reminderToday => 'ഇന്ന് നടക്കുന്നു';

  @override
  String get onlineTitle => 'ഓൺലൈൻ സൗകര്യങ്ങൾ';

  @override
  String get onlineSubtitle =>
      'ബഹിരാകാശ നിലയവും റോക്കറ്റ് വിക്ഷേപണങ്ങളും കാണിക്കുക. അപ്പോൾ Heliora wheretheiss.at, Celestrak, Launch Library 2 എന്നിവയുമായി മാത്രമേ ബന്ധപ്പെടൂ; അവയ്ക്ക് നിങ്ങളുടെ ഫോണിന്റെ ഇന്റർനെറ്റ് വിലാസം കാണാം. മറ്റൊന്നും അയയ്ക്കില്ല. തുടക്കത്തിൽ ഓഫ് ആണ്.';

  @override
  String get turnOnOnline => 'ഓൺലൈൻ സൗകര്യങ്ങൾ ഓണാക്കുക';

  @override
  String get issTitle => 'ബഹിരാകാശ നിലയം';

  @override
  String get issCardHint =>
      'ഇപ്പോൾ എവിടെയാണ്, നിങ്ങളുടെ മുകളിലൂടെ എപ്പോൾ പോകും';

  @override
  String get issNeedsOnline =>
      'നിലയം കാണിക്കാൻ Heliora-യ്ക്ക് ഇന്റർനെറ്റിൽ നിന്ന് അതിന്റെ ഭ്രമണപഥ വിവരം വേണം. ഒരിക്കൽ ഡൗൺലോഡ് ചെയ്താൽ ദിവസങ്ങളോളം ഓഫ്‌ലൈനായി പ്രവർത്തിക്കും.';

  @override
  String get issLoading => 'ഭ്രമണപഥ വിവരം എടുക്കുന്നു…';

  @override
  String get issFailed =>
      'ഭ്രമണപഥ വിവരം കിട്ടിയില്ല. ഇന്റർനെറ്റ് പരിശോധിച്ച് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String issStale(String days) {
    return 'ഭ്രമണപഥ വിവരത്തിന് $days ദിവസം പഴക്കമുണ്ട്, അതിനാൽ സ്ഥാനം അല്പം തെറ്റാം. പുതുക്കാൻ ഇന്റർനെറ്റിൽ ബന്ധിപ്പിക്കുക.';
  }

  @override
  String get issHeight => 'ഉയരം';

  @override
  String get issSpeed => 'വേഗം';

  @override
  String get issFromYou => 'നിങ്ങളിൽ നിന്നുള്ള ദൂരം';

  @override
  String valueKmh(String value) {
    return '$value കിമീ/മണിക്കൂർ';
  }

  @override
  String issAboveHorizon(String direction, String degrees) {
    return 'ഇപ്പോൾ നിങ്ങളുടെ ചക്രവാളത്തിന് മുകളിലാണ്! $direction ഭാഗത്തേക്ക് നോക്കൂ, $degrees° ഉയരത്തിൽ.';
  }

  @override
  String get issBelowHorizon => 'ഇപ്പോൾ നിങ്ങളുടെ ചക്രവാളത്തിന് താഴെയാണ്.';

  @override
  String issPassesTitle(String city) {
    return '$city-ന് മുകളിലൂടെ അടുത്ത യാത്രകൾ';
  }

  @override
  String get issNoPasses => 'അടുത്ത 5 ദിവസത്തിൽ നല്ല യാത്രകളില്ല.';

  @override
  String issMaxHigh(String degrees) {
    return '$degrees° വരെ ഉയരത്തിൽ';
  }

  @override
  String issFromTo(String start, String end) {
    return '$start മുതൽ $end വരെ';
  }

  @override
  String get issVisible => 'എളുപ്പത്തിൽ കാണാം';

  @override
  String get issHidden => 'കാണാൻ ബുദ്ധിമുട്ട്';

  @override
  String get issPassTitle =>
      'ബഹിരാകാശ നിലയം നിങ്ങളുടെ മുകളിലൂടെ കടന്നുപോകുന്നു';

  @override
  String issPassBody(String degrees, String direction) {
    return '10 മിനിറ്റിൽ ഉദിക്കും, $degrees° വരെ ഉയരത്തിൽ. $direction ഭാഗത്തേക്ക് നോക്കൂ.';
  }

  @override
  String get issNote =>
      'സ്ഥാനങ്ങൾ നിങ്ങളുടെ ഫോണിൽത്തന്നെ നിലയത്തിന്റെ ഭ്രമണപഥ വിവരത്തിൽ നിന്ന് കണക്കാക്കുന്നു. ആകാശം ഇരുണ്ടതും നിലയത്തിൽ സൂര്യപ്രകാശം പതിക്കുന്നതുമാകുമ്പോൾ എളുപ്പത്തിൽ കാണാം: തിളങ്ങുന്ന വേഗമേറിയ നക്ഷത്രം പോലെ.';

  @override
  String get launchesNeedOnline =>
      'വരാനിരിക്കുന്ന റോക്കറ്റ് വിക്ഷേപണങ്ങൾ ഇവിടെ കാണാൻ ഓൺലൈൻ സൗകര്യങ്ങൾ ഓണാക്കുക.';

  @override
  String get launchesFailed =>
      'വിക്ഷേപണ പട്ടിക പുതുക്കാനായില്ല. സേവ് ചെയ്ത പട്ടിക കാണിക്കുന്നു.';

  @override
  String get launchesNote =>
      'വിക്ഷേപണ സമയം Launch Library 2-ൽ നിന്നാണ്, അത് പലപ്പോഴും മാറും. പേരുകളും സ്ഥലങ്ങളും ഇംഗ്ലീഷിലാണ്.';

  @override
  String get launchReminderBody =>
      'ഏകദേശം ഒരു മണിക്കൂറിൽ വിക്ഷേപിക്കും. സമയം മാറാം.';

  @override
  String get launchTimeTbd => 'സമയം ഇതുവരെ നിശ്ചയിച്ചിട്ടില്ല';

  @override
  String get quizChoose => 'ഒരു ലെവൽ തിരഞ്ഞെടുക്കുക';

  @override
  String get levelEasy => 'എളുപ്പം';

  @override
  String get levelMedium => 'ഇടത്തരം';

  @override
  String get levelHard => 'കഠിനം';

  @override
  String get levelEasyHint => 'ഗ്രഹങ്ങളെക്കുറിച്ചുള്ള അടിസ്ഥാന കാര്യങ്ങൾ';

  @override
  String get levelMediumHint => 'ഗ്രഹങ്ങളും ഉപഗ്രഹങ്ങളും';

  @override
  String get levelHardHint => 'കടുപ്പമുള്ള താരതമ്യങ്ങളും ക്രമവും';

  @override
  String get qStar => 'ഇവയിൽ ഏതാണ് നക്ഷത്രം, ഗ്രഹമല്ല?';

  @override
  String get qDwarf => 'ഇവയിൽ ഏതാണ് കുള്ളൻ ഗ്രഹം?';

  @override
  String get qMoonVisited => 'ഏത് ഉപഗ്രഹത്തിലാണ് മനുഷ്യർ നടന്നിട്ടുള്ളത്?';

  @override
  String get qLargestMoon => 'ഈ ഉപഗ്രഹങ്ങളിൽ ഏറ്റവും വലുത് ഏതാണ്?';

  @override
  String get qSmallestMoon => 'ഈ ഉപഗ്രഹങ്ങളിൽ ഏറ്റവും ചെറുത് ഏതാണ്?';

  @override
  String get qThickAirMoon =>
      'ഈ ഉപഗ്രഹങ്ങളിൽ ഏതിനാണ് കട്ടിയുള്ള അന്തരീക്ഷം ഉള്ളത്?';

  @override
  String get qGeyserMoon =>
      'ഏത് ഉപഗ്രഹമാണ് വെള്ളത്തിന്റെ ഉറവകൾ ബഹിരാകാശത്തേക്ക് ചീറ്റുന്നത്?';

  @override
  String get qVolcanicMoon =>
      'ഏത് ഉപഗ്രഹത്തിലാണ് ഏറ്റവും കൂടുതൽ സജീവ അഗ്നിപർവതങ്ങളുള്ളത്?';

  @override
  String get qBackwardsMoon =>
      'ഏത് ഉപഗ്രഹമാണ് തന്റെ ഗ്രഹത്തെ എതിർദിശയിൽ ചുറ്റുന്നത്?';

  @override
  String get qBiggestRocky => 'നാല് പാറഗ്രഹങ്ങളിൽ ഏറ്റവും വലുത് ഏതാണ്?';

  @override
  String get qColdestRocky => 'നാല് പാറഗ്രഹങ്ങളിൽ ഏറ്റവും തണുത്തത് ഏതാണ്?';

  @override
  String get qHighestPressure =>
      'ഏത് ഗ്രഹത്തിന്റെ പ്രതലത്തിലാണ് വായുമർദ്ദം ഏറ്റവും കൂടുതൽ?';

  @override
  String get qSecondLargest => 'ഏത് ഗ്രഹമാണ് രണ്ടാമത്തെ ഏറ്റവും വലുത്?';

  @override
  String get qLongestYear => 'ഏത് ഗ്രഹത്തിനാണ് ഏറ്റവും നീളമുള്ള വർഷം?';

  @override
  String get qShortestYear => 'ഏത് ഗ്രഹത്തിനാണ് ഏറ്റവും ചെറിയ വർഷം?';

  @override
  String get qSmallestGiant => 'നാല് ഭീമൻ ഗ്രഹങ്ങളിൽ ഏറ്റവും ചെറുത് ഏതാണ്?';

  @override
  String get qRockyLongestYear =>
      'നാല് പാറഗ്രഹങ്ങളിൽ ഏതിനാണ് ഏറ്റവും നീളമുള്ള വർഷം?';

  @override
  String get qFastestMoon =>
      'ഈ ഉപഗ്രഹങ്ങളിൽ ഏതാണ് തന്റെ ഗ്രഹത്തെ ഏറ്റവും വേഗത്തിൽ ചുറ്റുന്നത്?';

  @override
  String get qSlowestMoon =>
      'ഈ ഉപഗ്രഹങ്ങളിൽ ഏതാണ് തന്റെ ഗ്രഹത്തെ ചുറ്റാൻ ഏറ്റവും കൂടുതൽ സമയം എടുക്കുന്നത്?';

  @override
  String get qStrongestMoonGravity =>
      'ഈ ഉപഗ്രഹങ്ങളിൽ ഏതിനാണ് ഏറ്റവും ശക്തമായ ഗുരുത്വാകർഷണം?';

  @override
  String get qColdestMoon => 'ഈ ഉപഗ്രഹങ്ങളിൽ ഏറ്റവും തണുത്തത് ഏതാണ്?';

  @override
  String get qSecondLargestMoon =>
      'ഈ ഉപഗ്രഹങ്ങളിൽ രണ്ടാമത്തെ ഏറ്റവും വലുത് ഏതാണ്?';

  @override
  String get factTitle => 'നിങ്ങൾക്കറിയാമോ?';

  @override
  String get factTap => 'മറ്റൊരു വിവരം കാണാൻ ടാപ്പ് ചെയ്യുക';

  @override
  String get factSun1 => 'സൗരയൂഥത്തിലെ ആകെ പിണ്ഡത്തിന്റെ 99.8% സൂര്യനിലാണ്.';

  @override
  String get factSun2 =>
      'സൂര്യപ്രകാശം ഭൂമിയിലെത്താൻ ഏകദേശം 8 മിനിറ്റ് 20 സെക്കൻഡ് എടുക്കും.';

  @override
  String get factMercury1 =>
      'ബുധനിൽ ഒരു ദിവസം, അതായത് ഒരു സൂര്യോദയം മുതൽ അടുത്ത സൂര്യോദയം വരെ, ഏകദേശം 176 ഭൗമദിനങ്ങളാണ്. അത് അതിന്റെ വർഷത്തിന്റെ ഇരട്ടി നീളമാണ്.';

  @override
  String get factMercury2 =>
      'ബുധനിൽ വായു ഏതാണ്ട് ഇല്ല, അതിനാൽ പകലും അതിന്റെ ആകാശം കറുത്തതാണ്, രാത്രികൾ മരവിപ്പിക്കുന്ന തണുപ്പും.';

  @override
  String get factVenus1 =>
      'ശുക്രൻ എതിർദിശയിൽ കറങ്ങുന്നു, അതിനാൽ അവിടെ സൂര്യൻ പടിഞ്ഞാറ് ഉദിക്കുന്നു.';

  @override
  String get factVenus2 =>
      'സൂര്യനിൽ നിന്ന് കൂടുതൽ അകലെയാണെങ്കിലും ശുക്രൻ ബുധനെക്കാൾ ചൂടുള്ളതാണ്, കാരണം അതിന്റെ കട്ടിയുള്ള വായു ചൂടിനെ പിടിച്ചുനിർത്തുന്നു.';

  @override
  String get factEarth1 =>
      'ജീവനുണ്ടെന്ന് നമുക്കറിയാവുന്ന ഒരേയൊരു സ്ഥലം ഭൂമിയാണ്, അതിന്റെ പ്രതലത്തിന്റെ ഏകദേശം 71% വെള്ളത്താൽ മൂടപ്പെട്ടിരിക്കുന്നു.';

  @override
  String get factEarth2 =>
      'ഭൂമി പൂർണമായ ഗോളമല്ല. കറങ്ങുന്നതുകൊണ്ട് മധ്യരേഖയ്ക്ക് അടുത്ത് അല്പം വീർത്തിരിക്കുന്നു.';

  @override
  String get factMars1 =>
      'ചൊവ്വയിലെ ഒളിമ്പസ് മോൺസ് സൗരയൂഥത്തിലെ ഏറ്റവും ഉയരമുള്ള അഗ്നിപർവതമാണ്, എവറസ്റ്റ് കൊടുമുടിയെക്കാൾ ഏകദേശം രണ്ടര മടങ്ങ് ഉയരം.';

  @override
  String get factMars2 => 'ചൊവ്വയിൽ സൂര്യാസ്തമയം നീലനിറത്തിൽ കാണപ്പെടുന്നു.';

  @override
  String get factJupiter1 =>
      'വ്യാഴത്തിന്റെ പിണ്ഡം മറ്റെല്ലാ ഗ്രഹങ്ങളുടെയും ആകെ പിണ്ഡത്തിന്റെ ഇരട്ടിയിലധികമാണ്.';

  @override
  String get factJupiter2 =>
      'ഗ്രേറ്റ് റെഡ് സ്പോട്ട് ഭൂമിയെക്കാൾ വലിയ ഒരു കൊടുങ്കാറ്റാണ്, ആളുകൾ അത് 150 വർഷത്തിലേറെയായി നിരീക്ഷിക്കുന്നു.';

  @override
  String get factSaturn1 =>
      'ശനി തന്റെ വലിപ്പത്തിനൊത്ത് അത്രയും ഭാരം കുറഞ്ഞതാണ്, മതിയായ വലിയ ഒരു ബാത്ത്ടബ് കിട്ടിയാൽ അത് വെള്ളത്തിൽ പൊങ്ങിക്കിടക്കും.';

  @override
  String get factSaturn2 =>
      'ശനിയുടെ വലയങ്ങൾ വളരെ വീതിയുള്ളതും എന്നാൽ വളരെ കനം കുറഞ്ഞതുമാണ്: ചിലയിടത്ത് ഏകദേശം പത്ത് മീറ്റർ മാത്രം കനം.';

  @override
  String get factUranus1 =>
      'യുറാനസ് വശം ചരിഞ്ഞ് ഉരുണ്ടുകൊണ്ട് സൂര്യനെ ചുറ്റുന്നു, അതിന്റെ അച്ചുതണ്ട് ഏകദേശം 98 ഡിഗ്രി ചരിഞ്ഞിരിക്കുന്നു.';

  @override
  String get factUranus2 =>
      'ദൂരദർശിനി ഉപയോഗിച്ച് കണ്ടെത്തിയ ആദ്യ ഗ്രഹമാണ് യുറാനസ്. വില്യം ഹെർഷൽ 1781-ൽ അതിനെ കണ്ടെത്തി.';

  @override
  String get factNeptune1 =>
      'ഏതു ഗ്രഹത്തിലേതിനെക്കാളും വേഗമേറിയ കാറ്റ് നെപ്റ്റ്യൂണിലാണ്, മണിക്കൂറിൽ 2,000 കിലോമീറ്ററിലധികം.';

  @override
  String get factNeptune2 =>
      'ആരും കാണുന്നതിനു മുമ്പേ നെപ്റ്റ്യൂണിനെ കണക്കുകൂട്ടി കണ്ടെത്തി: 1846-ൽ ജ്യോതിശാസ്ത്രജ്ഞർ അത് എവിടെയായിരിക്കണമെന്ന് കണക്കാക്കി.';

  @override
  String get factMoon1 =>
      'ചന്ദ്രൻ ഓരോ വർഷവും ഭൂമിയിൽ നിന്ന് ഏകദേശം 3.8 സെന്റീമീറ്റർ കൂടി അകലുന്നു.';

  @override
  String get factMoon2 =>
      'ചന്ദ്രന്റെ ഒരേ വശം തന്നെയാണ് നാം എപ്പോഴും കാണുന്നത്, കാരണം ഭൂമിയെ ഒരു തവണ ചുറ്റുമ്പോൾ അത് കൃത്യം ഒരു തവണ സ്വയം കറങ്ങുന്നു.';

  @override
  String get factPluto1 => 'പ്ലൂട്ടോയിൽ ഒരു വർഷം ഏകദേശം 248 ഭൗമവർഷങ്ങളാണ്.';

  @override
  String get factPluto2 =>
      'പ്ലൂട്ടോയിൽ മരവിച്ച നൈട്രജന്റെ ഹൃദയാകൃതിയിലുള്ള ഒരു വലിയ സമതലമുണ്ട്.';

  @override
  String get factIo1 =>
      'നമുക്കറിയാവുന്നതിൽ ഏറ്റവുമധികം അഗ്നിപർവതങ്ങളുള്ള ലോകമാണ് അയോ, അവിടെ നൂറുകണക്കിന് സജീവ അഗ്നിപർവതങ്ങളുണ്ട്.';

  @override
  String get factIo2 =>
      'വ്യാഴത്തിന്റെ ഗുരുത്വാകർഷണം അയോയെ ഞെരുക്കുകയും വലിച്ചുനീട്ടുകയും ചെയ്യുന്നു, അതിൽ നിന്നുണ്ടാകുന്ന ചൂടാണ് അതിന്റെ അഗ്നിപർവതങ്ങളെ പ്രവർത്തിപ്പിക്കുന്നത്.';

  @override
  String get factEuropa1 =>
      'മഞ്ഞുപാളിക്ക് അടിയിൽ യൂറോപ്പയിൽ ഭൂമിയിലെ എല്ലാ സമുദ്രങ്ങളിലുമുള്ളതിന്റെ ഏകദേശം ഇരട്ടി വെള്ളം ഉണ്ടാകാനിടയുണ്ട്.';

  @override
  String get factEuropa2 =>
      'ഭൂമിക്കപ്പുറം ജീവൻ തിരയാൻ ഏറ്റവും നല്ല സ്ഥലങ്ങളിൽ ഒന്നാണ് യൂറോപ്പ. യൂറോപ്പ ക്ലിപ്പർ പേടകം അവിടേക്കുള്ള യാത്രയിലാണ്.';

  @override
  String get factGanymede1 =>
      'സൗരയൂഥത്തിലെ ഏറ്റവും വലിയ ഉപഗ്രഹമാണ് ഗാനിമീഡ്. അത് ബുധനെക്കാളും വലുതാണ്.';

  @override
  String get factGanymede2 =>
      'സ്വന്തമായി കാന്തികമണ്ഡലമുള്ളതായി അറിയപ്പെടുന്ന ഒരേയൊരു ഉപഗ്രഹമാണ് ഗാനിമീഡ്.';

  @override
  String get factCallisto1 =>
      'സൗരയൂഥത്തിൽ ഏറ്റവുമധികം ഗർത്തങ്ങളുള്ള സ്ഥലങ്ങളിൽ ഒന്നാണ് കാലിസ്റ്റോ, അതിന്റെ പ്രതലം വളരെ പഴക്കമുള്ളതാണ്.';

  @override
  String get factCallisto2 =>
      'കാലിസ്റ്റോ വ്യാഴത്തിൽ നിന്ന് ആവശ്യത്തിന് അകലെയായതിനാൽ അതിന്റെ കഠിന വികിരണം കുറവേ ഏൽക്കൂ, അതിനാൽ ശാസ്ത്രജ്ഞർ ഭാവിയിലെ താവളത്തിനായി അതിനെ നിർദേശിച്ചിട്ടുണ്ട്.';

  @override
  String get factTitan1 =>
      'കട്ടിയുള്ള അന്തരീക്ഷമുള്ള ഒരേയൊരു ഉപഗ്രഹമാണ് ടൈറ്റൻ. അതിന്റെ പ്രതലത്തിലെ വായുമർദ്ദം ഭൂമിയിലേതിനെക്കാൾ കൂടുതലാണ്.';

  @override
  String get factTitan2 =>
      'ടൈറ്റനിൽ നദികളും തടാകങ്ങളുമുണ്ട്, പക്ഷേ അവയിൽ വെള്ളമല്ല, ദ്രാവക മീഥെയ്‌നും ഈഥെയ്‌നുമാണ്.';

  @override
  String get factEnceladus1 =>
      'എൻസെലാഡസ് തന്റെ ദക്ഷിണധ്രുവത്തിനടുത്തുള്ള വിള്ളലുകളിലൂടെ മഞ്ഞിന്റെയും നീരാവിയുടെയും ധാരകൾ ബഹിരാകാശത്തേക്ക് ചീറ്റുന്നു.';

  @override
  String get factEnceladus2 =>
      'എൻസെലാഡസിന്റെ ഈ ധാരകൾ ശനിയുടെ E വലയത്തെ നിറയ്ക്കുന്നു.';

  @override
  String get factTriton1 =>
      'ട്രൈറ്റൺ നെപ്റ്റ്യൂണിനെ എതിർദിശയിൽ ചുറ്റുന്നു, അതിനാൽ അത് നെപ്റ്റ്യൂൺ പിടിച്ചെടുത്ത ഒരു കുള്ളൻ ഗ്രഹമായിരുന്നിരിക്കാം.';

  @override
  String get factTriton2 =>
      'ഏകദേശം −235 °C താപനിലയിൽ, സൗരയൂഥത്തിൽ താപനില അളന്നിട്ടുള്ള ഏറ്റവും തണുത്ത സ്ഥലങ്ങളിൽ ഒന്നാണ് ട്രൈറ്റൺ.';

  @override
  String get jumpInput => 'ഭൂമിയിൽ നിങ്ങളുടെ ചാട്ടത്തിന്റെ ഉയരം (സെ.മീ)';

  @override
  String jumpHigh(String height) {
    return 'ചാട്ടം: $height';
  }

  @override
  String jumpFeelsLike(String height) {
    return 'ഭൂമിയിലെ $height ചാട്ടം ഇവിടെ ആകുന്നു';
  }

  @override
  String get jumpNote =>
      'തള്ളൽ ഭൂമിയിലേതുപോലെ തന്നെ. സൂര്യനിലും വാതക ഭീമൻ ഗ്രഹങ്ങളിലും നിൽക്കാൻ നിലമില്ല, അതിനാൽ ഇത് വെറുമൊരു ഭാവനാ കളിയാണ്.';

  @override
  String valueCm(String value) {
    return '$value സെ.മീ';
  }

  @override
  String valueM(String value) {
    return '$value മീ';
  }

  @override
  String get eclipseTotalLunar => 'സമ്പൂർണ ചന്ദ്രഗ്രഹണം';

  @override
  String get eclipsePartialLunar => 'ഭാഗിക ചന്ദ്രഗ്രഹണം';

  @override
  String get eclipsePenumbralLunar => 'ഉപഛായ ചന്ദ്രഗ്രഹണം';

  @override
  String get eclipseTotalSolar => 'സമ്പൂർണ സൂര്യഗ്രഹണം';

  @override
  String get eclipseAnnularSolar => 'വലയ സൂര്യഗ്രഹണം';

  @override
  String get eclipseHybridSolar => 'സങ്കര സൂര്യഗ്രഹണം';

  @override
  String get eclipsePartialSolar => 'ഭാഗിക സൂര്യഗ്രഹണം';

  @override
  String get eclipseTotalLunarDesc =>
      'ചന്ദ്രൻ പൂർണമായി ഭൂമിയുടെ നിഴലിലേക്ക് നീങ്ങുകയും പലപ്പോഴും മങ്ങിയ ചുവപ്പായി കാണപ്പെടുകയും ചെയ്യും. ഭൂമിയുടെ രാത്രിഭാഗത്തുള്ള എല്ലാവർക്കും ഇത് കാണാം, കണ്ണുകൊണ്ട് കാണുന്നത് സുരക്ഷിതവുമാണ്.';

  @override
  String eclipsePartialLunarDesc(String percent) {
    return 'ചന്ദ്രന്റെ ഒരു ഭാഗം (വീതിയുടെ $percent%) ഭൂമിയുടെ ഇരുണ്ട നിഴലിലേക്ക് നീങ്ങുന്നു. കണ്ണുകൊണ്ട് കാണുന്നത് സുരക്ഷിതമാണ്.';
  }

  @override
  String get eclipsePenumbralLunarDesc =>
      'ചന്ദ്രൻ ഭൂമിയുടെ മങ്ങിയ പുറം നിഴലിലൂടെ കടന്നുപോകുന്നു. അല്പം മാത്രം മങ്ങുന്നതിനാൽ ശ്രദ്ധിക്കാൻ പ്രയാസമാണ്.';

  @override
  String get eclipseTotalSolarDesc =>
      'ഭൂമിയിലെ ഒരു ഇടുങ്ങിയ പാതയിൽ ചന്ദ്രൻ സൂര്യനെ പൂർണമായി മറയ്ക്കുന്നു. ആ പാതയ്ക്ക് പുറത്ത് ഭാഗിക ഗ്രഹണമാണ് കാണുക.';

  @override
  String get eclipseAnnularSolarDesc =>
      'ചന്ദ്രൻ അല്പം കൂടുതൽ അകലെയായതിനാൽ സൂര്യനെ പൂർണമായി മറയ്ക്കാനാകില്ല, തിളങ്ങുന്ന ഒരു വളയം ബാക്കിയാകും. വളയം ഇടുങ്ങിയ പാതയിൽ കാണാം; അതിനു പുറത്ത് ഗ്രഹണം ഭാഗികമാണ്.';

  @override
  String get eclipseHybridSolarDesc =>
      'ഈ ഗ്രഹണം അതിന്റെ പാതയിൽ ചിലയിടത്ത് സമ്പൂർണവും ചിലയിടത്ത് വളയരൂപവുമായിരിക്കും. പാതയ്ക്ക് പുറത്ത് ഭാഗികമാണ്.';

  @override
  String get eclipsePartialSolarDesc =>
      'ചന്ദ്രൻ സൂര്യന്റെ ഒരു ഭാഗം മാത്രം മറയ്ക്കുന്നു, ഭൂമിയിൽ ഒരിടത്തും സൂര്യൻ പൂർണമായി മറയുന്നില്ല.';

  @override
  String get eclipseNoCity =>
      'അവിടെ നിന്ന് കാണാനാകുമോ എന്നറിയാൻ Heliora-യിൽ ഒരു നഗരം തിരഞ്ഞെടുക്കൂ.';

  @override
  String eclipseLunarUp(String city) {
    return 'ഗ്രഹണത്തിന്റെ മധ്യത്തിൽ $city-ൽ ചന്ദ്രൻ ചക്രവാളത്തിന് മുകളിലാണ്.';
  }

  @override
  String eclipseLunarPartly(String city) {
    return '$city-ൽ ഗ്രഹണത്തിന്റെ ഒരു ഭാഗത്ത് മാത്രമേ ചന്ദ്രൻ ചക്രവാളത്തിന് മുകളിലുണ്ടാകൂ.';
  }

  @override
  String eclipseLunarDown(String city) {
    return '$city-ൽ ചന്ദ്രൻ ചക്രവാളത്തിന് താഴെത്തന്നെയാണ്, അതിനാൽ അവിടെ നിന്ന് കാണാനാകില്ല.';
  }

  @override
  String eclipseSolarNone(String city) {
    return '$city-ൽ നിന്ന് കാണാനാകില്ല: ചന്ദ്രന്റെ നിഴൽ അവിടെ എത്തില്ല, അല്ലെങ്കിൽ സൂര്യൻ ചക്രവാളത്തിന് താഴെയാണ്.';
  }

  @override
  String eclipseSolarSlight(String city) {
    return '$city-ൽ നിന്ന് പരമാവധി വളരെ ചെറിയ ഭാഗിക ഗ്രഹണം മാത്രം, ശ്രദ്ധിക്കാൻ പ്രയാസം.';
  }

  @override
  String eclipseSolarPartial(String city, String percent) {
    return '$city-ന് ഏകദേശ കണക്ക്: ചന്ദ്രൻ പരമാവധി സൂര്യന്റെ വീതിയുടെ ഏകദേശം $percent% മറയ്ക്കുന്നു.';
  }

  @override
  String eclipseSolarNear(String city) {
    return 'സൂര്യൻ ഏതാണ്ടോ പൂർണമായോ മറയുന്ന പാതയ്ക്ക് അടുത്താണ് $city. ഗ്രഹണ ഭൂപടം പരിശോധിക്കൂ; ഈ കണക്ക് ഏകദേശമാണ്.';
  }

  @override
  String get eclipseSolarSafety =>
      'ശരിയായ ഗ്രഹണ കണ്ണടയില്ലാതെ ഒരിക്കലും സൂര്യനെ നോക്കരുത്.';

  @override
  String get alertsTitle => 'അലേർട്ടുകൾ';

  @override
  String get tonightAlertSwitch => 'എല്ലാ വൈകുന്നേരവും ഇന്നത്തെ രാത്രിയാകാശം';

  @override
  String get tonightAlertTime => 'സമയം';

  @override
  String get tonightAlertNote =>
      'നിങ്ങൾ തിരഞ്ഞെടുത്ത സമയത്ത് ചന്ദ്രനെയും കാണാവുന്ന ഗ്രഹങ്ങളെയും കുറിച്ചുള്ള ഒരു ചെറിയ സന്ദേശം. ഇത് നിങ്ങളുടെ ഫോണിൽ തന്നെ കണക്കാക്കുന്നു, ഇന്റർനെറ്റ് വേണ്ട. മുൻകൂട്ടി ഏകദേശം രണ്ടാഴ്ചത്തെ സന്ദേശങ്ങൾ മാത്രമേ Android Heliora-യെ തയ്യാറാക്കാൻ അനുവദിക്കൂ, അതിനാൽ ഇടയ്ക്കിടെ ആപ്പ് തുറക്കൂ.';

  @override
  String get tonightNotifTitle => 'ഇന്നത്തെ രാത്രിയാകാശം';

  @override
  String tonightMoon(String phase, String percent) {
    return 'ചന്ദ്രൻ: $phase, $percent% പ്രകാശിതം.';
  }

  @override
  String tonightPlanets(String planets) {
    return 'നോക്കൂ: $planets.';
  }

  @override
  String get tonightNoPlanets => 'സന്ധ്യാകാശത്ത് തിളക്കമുള്ള ഗ്രഹങ്ങളില്ല.';

  @override
  String get tonightNoCity =>
      'ഗ്രഹങ്ങളെ കാണാൻ Heliora-യിൽ ഒരു നഗരം തിരഞ്ഞെടുക്കൂ.';

  @override
  String get birthdayTitle => 'എന്റെ ജന്മദിന ആകാശം';

  @override
  String get birthdaySubtitle =>
      'നിങ്ങൾ ജനിച്ച ദിവസം ചന്ദ്രനും ഗ്രഹങ്ങളും എവിടെയായിരുന്നു, കൂടാതെ നിങ്ങളുടെ ജീവിതത്തിലെ വലിയ ദിവസങ്ങളും.';

  @override
  String get birthdayCardHint => 'ചന്ദ്രകല, ഗ്രഹങ്ങൾ, നാഴികക്കല്ലുകൾ';

  @override
  String get birthdayNeedDate => 'നിങ്ങളുടെ ജനനത്തീയതി നൽകുക';

  @override
  String get birthdayMoon => 'നിങ്ങളുടെ ജന്മദിനത്തിലെ ചന്ദ്രൻ';

  @override
  String get birthdayPlanets => 'ആ ദിവസത്തെ ഗ്രഹങ്ങൾ';

  @override
  String birthdayDaysOld(String count) {
    return 'ഇന്ന് നിങ്ങൾക്ക് $count ദിവസം പ്രായമായി.';
  }

  @override
  String get birthdayMilestones => 'നാഴികക്കല്ലുകൾ';

  @override
  String birthdayDayN(String count) {
    return 'ദിവസം $count';
  }

  @override
  String get birthdayBillion => '100 കോടി സെക്കൻഡ് പ്രായം';

  @override
  String get birthdayPassed => 'കഴിഞ്ഞു';

  @override
  String get birthdayNote =>
      'Heliora-യിലെ ബാക്കിയെല്ലാത്തിനും ഉപയോഗിക്കുന്ന അതേ ഭ്രമണപഥങ്ങളിൽ നിന്ന് നിങ്ങളുടെ ഫോണിൽ തന്നെ കണക്കാക്കുന്നു. നിങ്ങളുടെ ജനനത്തീയതി ഫോണിന് പുറത്തുപോകില്ല.';

  @override
  String get missionsTitle => 'ബഹിരാകാശ ദൗത്യങ്ങൾ';

  @override
  String get missionsSubtitle =>
      'ബഹിരാകാശ പര്യവേക്ഷണത്തിലെ പ്രശസ്ത നിമിഷങ്ങൾ, ഏറ്റവും പഴയത് ആദ്യം.';

  @override
  String get missionsCardHint => 'കാലത്തിലൂടെ പ്രശസ്ത ദൗത്യങ്ങൾ';

  @override
  String get missionSputnik1 =>
      'ആദ്യത്തെ കൃത്രിമോപഗ്രഹം. ബീച്ച് ബോളിന്റെ വലിപ്പമുള്ള ഈ ലോഹഗോളം ഏകദേശം മൂന്ന് മാസം ഭൂമിയെ ചുറ്റി. അതിന്റെ ബീപ് ശബ്ദം റേഡിയോയിൽ കേൾക്കാമായിരുന്നു, ബഹിരാകാശ യുഗത്തിന് ഇവിടെ തുടക്കമായി.';

  @override
  String get missionVostok1 =>
      'യൂറി ഗഗാറിൻ ബഹിരാകാശത്തെത്തിയ ആദ്യ മനുഷ്യനായി. അദ്ദേഹം ഏകദേശം 108 മിനിറ്റിൽ ഭൂമിയെ ഒരു തവണ ചുറ്റി.';

  @override
  String get missionApollo11 =>
      'നീൽ ആംസ്ട്രോങ്ങും ബസ് ആൽഡ്രിനും ശാന്തിസമുദ്രത്തിൽ ഇറങ്ങി ചന്ദ്രനിൽ നടന്ന ആദ്യ മനുഷ്യരായി. മൈക്കൽ കോളിൻസ് ഭ്രമണപഥത്തിൽ അവർക്കായി കാത്തിരുന്നു.';

  @override
  String get missionVenera7 =>
      'മറ്റൊരു ഗ്രഹത്തിലിറങ്ങി സിഗ്നൽ അയച്ച ആദ്യ പേടകം. ശുക്രന്റെ തകർക്കുന്ന ചൂടിൽ അത് ഏകദേശം 23 മിനിറ്റ് വിവരങ്ങൾ അയച്ചു.';

  @override
  String get missionViking1 =>
      'ഇത് ചൊവ്വയിൽ ഇറങ്ങി ആറ് വർഷത്തിലേറെ പ്രവർത്തിച്ചു, മറ്റൊരു ഗ്രഹത്തിന്റെ ഉപരിതലത്തിൽ നിന്നുള്ള ചിത്രങ്ങളുടെയും കാലാവസ്ഥാ റിപ്പോർട്ടുകളുടെയും ആദ്യ ദീർഘ പരമ്പര അയച്ചു.';

  @override
  String get missionVoyager1 =>
      '1977-ൽ വിക്ഷേപിച്ചു, വ്യാഴത്തിനും ശനിക്കും അരികിലൂടെ കടന്നുപോയി 2012-ൽ നക്ഷത്രാന്തര ബഹിരാകാശത്തെത്തി. ഭൂമിയിൽ നിന്ന് ഏറ്റവും അകലെയുള്ള മനുഷ്യനിർമിത വസ്തുവാണിത്.';

  @override
  String get missionHubble =>
      '1990-ൽ വിക്ഷേപിച്ചു, ഭൂമിയുടെ വായുവിന് മുകളിൽ നിന്ന് പ്രപഞ്ചത്തെ നോക്കുന്നു. അതിന്റെ വ്യക്തമായ ചിത്രങ്ങൾ പ്രപഞ്ചത്തിന്റെ പ്രായം അളക്കാൻ സഹായിച്ചു, ആയിരക്കണക്കിന് അകലെയുള്ള ഗാലക്സികളെ കാണിച്ചു.';

  @override
  String get missionHuygens =>
      'കാസിനി വഹിച്ച പേടകമായ ഹൈജൻസ് പാരച്യൂട്ടിൽ ശനിയുടെ ചന്ദ്രനായ ടൈറ്റനിൽ ഇറങ്ങി. പുറം സൗരയൂഥത്തിലെ ആദ്യ ഇറക്കമായിരുന്നു ഇത്, ഉപരിതലത്തിൽ നിന്ന് ചിത്രങ്ങൾ അയച്ചു.';

  @override
  String get missionCuriosity =>
      'കാറിന്റെ വലിപ്പമുള്ള ഈ റോവർ റോക്കറ്റ് ശക്തിയുള്ള ’സ്കൈ ക്രെയിൻ’ ഉപയോഗിച്ച് ഗെയ്ൽ ഗർത്തത്തിൽ ഇറങ്ങി. ചൊവ്വയിൽ ഒരിക്കൽ ജീവന് അനുയോജ്യമായ സാഹചര്യം ഉണ്ടായിരുന്നെന്ന് അത് കണ്ടെത്തി.';

  @override
  String get missionMangalyaan =>
      'ഇന്ത്യയുടെ മാർസ് ഓർബിറ്റർ മിഷൻ ആദ്യ ശ്രമത്തിൽ തന്നെ ചൊവ്വയുടെ ഭ്രമണപഥത്തിലെത്തി. ഒരു രാജ്യത്തിനും ഇത് ആദ്യമായിരുന്നു, ചെലവും വളരെ കുറവ്.';

  @override
  String get missionRosetta =>
      'റോസറ്റയുടെ ലാൻഡർ ഫിലെ 67P/ചുര്യുമോവ്–ഗരാസിമെങ്കോ ധൂമകേതുവിൽ ഇറങ്ങി, ഒരു ധൂമകേതുവിലെ ആദ്യ ഇറക്കം. റോസറ്റ തന്നെ രണ്ട് വർഷം ധൂമകേതുവിനെ ചുറ്റി.';

  @override
  String get missionNewhorizons =>
      'ഒൻപത് വർഷത്തെ യാത്രയ്ക്കു ശേഷം അത് പ്ലൂട്ടോയ്ക്ക് അരികിലൂടെ പറന്ന്, ആദ്യമായി മഞ്ഞുമലകളും ഹൃദയാകൃതിയിലുള്ള വലിയ സമതലവും കാണിച്ചുതന്നു.';

  @override
  String get missionPerseverance =>
      'പഴയ ജീവന്റെ അടയാളങ്ങൾ തേടാനും പാറ സാമ്പിളുകൾ ശേഖരിക്കാനും പെർസിവിയറൻസ് റോവർ ജെസീറോ ഗർത്തത്തിൽ ഇറങ്ങി. അതിന്റെ ഹെലികോപ്റ്റർ ഇൻജെന്യൂയിറ്റി മറ്റൊരു ഗ്രഹത്തിലെ ആദ്യ നിയന്ത്രിത പറക്കൽ നടത്തി.';

  @override
  String get missionJwst =>
      'ഏറ്റവും വലിയ ബഹിരാകാശ ദൂരദർശിനിക്ക് 6.5 മീറ്റർ സ്വർണ കണ്ണാടിയുണ്ട്, 15 ലക്ഷം കിലോമീറ്റർ അകലെ നിന്ന് ഇൻഫ്രാറെഡ് പ്രകാശത്തിൽ ആകാശം നോക്കുന്നു. ആദ്യകാല ഗാലക്സികളിൽ ചിലതിനെ അത് കാണുന്നു.';

  @override
  String get missionChandrayaan3 =>
      'ചന്ദ്രനിൽ സുരക്ഷിതമായി ഇറങ്ങിയ നാലാമത്തെ രാജ്യമായി ഇന്ത്യ, ദക്ഷിണ ധ്രുവത്തിന് അടുത്ത് ഇറങ്ങിയ ആദ്യ രാജ്യവും. വിക്രം ലാൻഡർ പ്രജ്ഞാൻ റോവറിനെ വഹിച്ചിരുന്നു.';

  @override
  String get spacecraftTitle => 'ബഹിരാകാശ പേടകങ്ങൾ ഇപ്പോൾ';

  @override
  String get spacecraftSubtitle =>
      'പ്രശസ്തമായ ചില ബഹിരാകാശ പേടകങ്ങൾ ഇപ്പോൾ ഭൂമിയിൽ നിന്ന് എത്ര ദൂരത്താണ്.';

  @override
  String get spacecraftCardHint =>
      'വോയേജർ, JWST, ചൊവ്വയിലെ റോവറുകൾ തുടങ്ങി പലതും';

  @override
  String get spacecraftDistance => 'ഭൂമിയിൽ നിന്നുള്ള ദൂരം';

  @override
  String get spacecraftAltitude => 'ഭൂമിയിൽ നിന്നുള്ള ഉയരം';

  @override
  String get spacecraftInAu => 'ജ്യോതിശാസ്ത്ര യൂണിറ്റിൽ';

  @override
  String get spacecraftSpeed => 'വേഗം';

  @override
  String get spacecraftSignal => 'റേഡിയോ സിഗ്നലിന് വേണ്ട സമയം';

  @override
  String get spacecraftNote =>
      'ദൂരങ്ങൾ ഏകദേശ കണക്കുകളാണ്. ദൂരെയുള്ള പേടകങ്ങൾക്ക് ഇവ ശരാശരി വേഗത്തിൽ നിന്ന് കണക്കാക്കിയതാണ്; ഭൂമി സൂര്യനെ ചുറ്റുന്നതിനാൽ ഏകദേശം 1% വരെ തെറ്റാകാം. ചൊവ്വയിലേക്കുള്ള ദൂരം ഇന്നത്തേക്ക് കണക്കാക്കിയതാണ്. ഒരു AU (ജ്യോതിശാസ്ത്ര യൂണിറ്റ്) എന്നത് ഭൂമിയിൽ നിന്ന് സൂര്യനിലേക്കുള്ള ദൂരമാണ്.';

  @override
  String valueBillionKm(String value) {
    return '$value ശതകോടി കി.മീ';
  }

  @override
  String valueAu(String value) {
    return '$value AU';
  }

  @override
  String valueKmS(String value) {
    return '$value കി.മീ/സെക്കൻഡ്';
  }

  @override
  String get spacecraftVoyager1 =>
      '1977-ൽ വിക്ഷേപിച്ചു. 2012-ൽ നക്ഷത്രാന്തര ബഹിരാകാശത്തേക്ക് കടന്ന ആദ്യ പേടകമായി. ഇതിന്റെ റേഡിയോ സിഗ്നൽ നമ്മുടെ അടുത്തെത്തുമ്പോഴേക്കും ഏകദേശം ഒരു ദിവസം പഴക്കമുള്ളതാകും.';

  @override
  String get spacecraftVoyager2 =>
      '1977-ൽ വിക്ഷേപിച്ചു. യുറാനസിലും നെപ്റ്റ്യൂണിലും എത്തിയ ഒരേയൊരു പേടകമാണിത്; 2018-ൽ നക്ഷത്രാന്തര ബഹിരാകാശത്തേക്ക് കടന്നു.';

  @override
  String get spacecraftNewHorizons =>
      '2015-ൽ പ്ലൂട്ടോയുടെ അടുത്തുകൂടിയും 2019-ൽ കൈപ്പർ വലയത്തിലെ അരോക്കോത്തിന്റെ അടുത്തുകൂടിയും കടന്നുപോയി. ഇപ്പോഴും പുറത്തേക്ക് സഞ്ചരിക്കുകയും വിവരങ്ങൾ അയയ്ക്കുകയും ചെയ്യുന്നു.';

  @override
  String get spacecraftJwst =>
      'ഏറ്റവും വലിയ ബഹിരാകാശ ടെലിസ്കോപ്പ്, 2021-ൽ വിക്ഷേപിച്ചു. ഇത് L2 എന്ന ബിന്ദുവിന് സമീപം, ഭൂമിയിൽ നിന്ന് ഏകദേശം 15 ലക്ഷം കി.മീ അകലെയാണ്; ഇതിന്റെ സൂര്യകവചം എപ്പോഴും സൂര്യന് നേരെയാണ്.';

  @override
  String get spacecraftIss =>
      'ഏകദേശം ഓരോ 90 മിനിറ്റിലും ഭൂമിയെ ഒരു തവണ ചുറ്റുന്നു. 2000 മുതൽ ഇതിൽ ആളുകൾ ഇടവേളയില്ലാതെ താമസിക്കുന്നു.';

  @override
  String get spacecraftHubble =>
      '1990-ൽ വിക്ഷേപിച്ചു, ഇപ്പോഴും പ്രവർത്തിക്കുന്നു. ചിത്രം മങ്ങിക്കുന്ന വായുവിന് മുകളിലൂടെ ഭൂമിയെ ചുറ്റുന്നതിനാൽ ഇതിന്റെ ചിത്രങ്ങൾ വളരെ വ്യക്തമാണ്.';

  @override
  String get spacecraftMarsRovers =>
      'ക്യൂരിയോസിറ്റിയും (2012-ൽ ഇറങ്ങി) പെർസെവറൻസും (2021-ൽ ഇറങ്ങി) ചൊവ്വയിൽ സഞ്ചരിക്കുന്നു. ചൊവ്വയിലേക്കുള്ള ദൂരം ഏകദേശം 5.5 കോടി കി.മീ മുതൽ 40 കോടി കി.മീറ്ററിലധികം വരെ മാറുന്നു.';

  @override
  String get searchTooltip => 'തിരയുക';

  @override
  String get searchHint => 'ഗ്രഹങ്ങൾ, ഉപഗ്രഹങ്ങൾ, ദൗത്യങ്ങൾ തിരയുക…';

  @override
  String get searchClear => 'മായ്ക്കുക';

  @override
  String searchEmpty(String query) {
    return '“$query” എന്നതിന് ഒന്നും കണ്ടെത്തിയില്ല.';
  }

  @override
  String get searchBodies => 'ഗ്രഹങ്ങളും ഉപഗ്രഹങ്ങളും';

  @override
  String get searchMissions => 'ദൗത്യങ്ങൾ';

  @override
  String get searchSpacecraft => 'ബഹിരാകാശ പേടകങ്ങൾ';

  @override
  String get favoritesTitle => 'പ്രിയപ്പെട്ടവ';

  @override
  String get favoritesEmpty =>
      'ഒരു ഗ്രഹത്തിലോ ദൗത്യത്തിലോ പേടകത്തിലോ ഉള്ള നക്ഷത്രത്തിൽ തൊടുക, അത് ഇവിടെ സൂക്ഷിക്കും.';

  @override
  String get favoriteAdd => 'പ്രിയപ്പെട്ടവയിൽ ചേർക്കുക';

  @override
  String get favoriteRemove => 'പ്രിയപ്പെട്ടവയിൽ നിന്ന് നീക്കുക';

  @override
  String get textSize => 'അക്ഷര വലുപ്പം';

  @override
  String get textSizeNormal => 'സാധാരണ';

  @override
  String get textSizeLarge => 'വലുത്';

  @override
  String get textSizeLarger => 'കൂടുതൽ വലുത്';

  @override
  String get textSizeNote =>
      'Heliora-യിലെ അക്ഷരങ്ങൾ വലുതാക്കുന്നു. നിങ്ങളുടെ ഫോണിന്റെ സ്വന്തം അക്ഷര വലുപ്പത്തിന് താഴെ ഇത് ഒരിക്കലും പോകില്ല.';

  @override
  String get skyOtherNight => 'രാത്രിയിലെ ആകാശം';

  @override
  String get planetsThatNight => 'ആ രാത്രിയിലെ ഗ്രഹങ്ങൾ';

  @override
  String get previousDay => 'മുമ്പത്തെ ദിവസം';

  @override
  String get nextDay => 'അടുത്ത ദിവസം';

  @override
  String get pickDate => 'തീയതി തിരഞ്ഞെടുക്കുക';

  @override
  String get backToTonight => 'ഇന്ന് രാത്രിയിലേക്ക് മടങ്ങുക';

  @override
  String get moonCalendar => 'ചന്ദ്ര കലണ്ടർ';

  @override
  String get moonCalendarHint => 'ഓരോ ദിവസത്തെയും ചന്ദ്രക്കല';

  @override
  String get previousMonth => 'മുമ്പത്തെ മാസം';

  @override
  String get nextMonth => 'അടുത്ത മാസം';

  @override
  String get keyMoonDates => 'ഈ മാസത്തെ പ്രധാന കലകൾ';

  @override
  String get moonCalendarNote =>
      'കലകളുടെ തീയതിയും സമയവും നിങ്ങളുടെ ഫോണിന്റെ സമയ മേഖലയിലാണ് കാണിക്കുന്നത്; ഏകദേശം ഒരു മണിക്കൂറിനുള്ളിൽ കൃത്യമാണ്.';

  @override
  String get seeSkyThatDay => 'ഈ ദിവസത്തെ ആകാശം കാണുക';

  @override
  String get sunLightTitle => 'സൂര്യനും വെളിച്ചവും';

  @override
  String get firstLight => 'ആദ്യ വെളിച്ചം';

  @override
  String get goldenMorningEnds => 'രാവിലത്തെ സ്വർണ്ണ സമയം അവസാനിക്കുന്നു';

  @override
  String get solarNoon => 'സൂര്യൻ ഏറ്റവും ഉയരത്തിൽ';

  @override
  String get goldenEveningStarts => 'വൈകുന്നേരത്തെ സ്വർണ്ണ സമയം തുടങ്ങുന്നു';

  @override
  String get lastLight => 'അവസാന വെളിച്ചം';

  @override
  String get darkSky => 'പൂർണ്ണമായി ഇരുണ്ട ആകാശം';

  @override
  String get sunDayLength => 'പകലിന്റെ ദൈർഘ്യം';

  @override
  String durationHm(String hours, String minutes) {
    return '$hours മണിക്കൂർ $minutes മിനിറ്റ്';
  }

  @override
  String get sunNote =>
      'സൂര്യൻ ചക്രവാളത്തിൽ നിന്ന് 6° ൽ താഴെ ഉയരത്തിലായിരിക്കുമ്പോഴാണ് സ്വർണ്ണ സമയം. 6° താഴെയാകുമ്പോൾ ആദ്യവും അവസാനവുമുള്ള വെളിച്ചം, 18° താഴെയാകുമ്പോൾ ആകാശം പൂർണ്ണമായി ഇരുണ്ടതാകും. സമയങ്ങൾ നിങ്ങൾ തിരഞ്ഞെടുത്ത തീയതിക്കായി കണക്കാക്കിയതാണ്.';

  @override
  String get sunStaysUp => 'ഈ ദിവസം സൂര്യൻ അസ്തമിക്കുന്നില്ല.';

  @override
  String get sunStaysDown => 'ഈ ദിവസം സൂര്യൻ ഉദിക്കുന്നില്ല.';

  @override
  String get solarSystemTitle => 'സൗരയൂഥം';
}
