// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class AppLocalizationsPa extends AppLocalizations {
  AppLocalizationsPa([String locale = 'pa']) : super(locale);

  @override
  String get appTitle => 'Heliora';

  @override
  String get tagline => 'ਸੂਰਜੀ ਮੰਡਲ ਦੀ ਸੈਰ, ਪੂਰੀ ਤਰ੍ਹਾਂ ਆਫ਼ਲਾਈਨ';

  @override
  String get navExplore => 'ਖੋਜੋ';

  @override
  String get navCompare => 'ਤੁਲਨਾ';

  @override
  String get navWeight => 'ਭਾਰ';

  @override
  String get navQuiz => 'ਕੁਇਜ਼';

  @override
  String get viewMode => 'ਦ੍ਰਿਸ਼ ਮੋਡ';

  @override
  String get settings => 'ਸੈਟਿੰਗਾਂ';

  @override
  String get notToScale => 'ਪੈਮਾਨੇ ਮੁਤਾਬਕ ਨਹੀਂ · ਖੋਲ੍ਹਣ ਲਈ ਗ੍ਰਹਿ ’ਤੇ ਟੈਪ ਕਰੋ';

  @override
  String get dragToRotate => 'ਘੁਮਾਉਣ ਲਈ ਖਿੱਚੋ · ਜ਼ੂਮ ਲਈ ਪਿੰਚ ਕਰੋ';

  @override
  String get planetsTitle => 'ਗ੍ਰਹਿ';

  @override
  String get planetMercury => 'ਬੁੱਧ';

  @override
  String get planetVenus => 'ਸ਼ੁੱਕਰ';

  @override
  String get planetEarth => 'ਧਰਤੀ';

  @override
  String get planetMars => 'ਮੰਗਲ';

  @override
  String get planetJupiter => 'ਬ੍ਰਹਿਸਪਤੀ';

  @override
  String get planetSaturn => 'ਸ਼ਨੀ';

  @override
  String get planetUranus => 'ਯੂਰੇਨਸ';

  @override
  String get planetNeptune => 'ਨੈਪਚਿਊਨ';

  @override
  String planetOrder(int n) {
    return 'ਸੂਰਜ ਤੋਂ ਗ੍ਰਹਿ ਨੰਬਰ $n';
  }

  @override
  String get openDetails => 'ਵੇਰਵੇ ਖੋਲ੍ਹੋ';

  @override
  String get diameter => 'ਵਿਆਸ';

  @override
  String get gravity => 'ਗੁਰੂਤਾ';

  @override
  String get avgTemp => 'ਔਸਤ ਤਾਪਮਾਨ';

  @override
  String get avgTempShort => 'ਔਸਤ ਤਾਪਮਾਨ';

  @override
  String get dayLength => 'ਦਿਨ';

  @override
  String get yearLength => 'ਸਾਲ';

  @override
  String get moons => 'ਜਾਣੇ-ਪਛਾਣੇ ਚੰਦਰਮਾ';

  @override
  String get moonsShort => 'ਚੰਦਰਮਾ';

  @override
  String get distance => 'ਸੂਰਜ ਤੋਂ ਦੂਰੀ';

  @override
  String get pressure => 'ਸਤ੍ਹਾ ਦਾ ਦਬਾਅ';

  @override
  String get noSurface => 'ਕੋਈ ਠੋਸ ਸਤ੍ਹਾ ਨਹੀਂ';

  @override
  String valueKm(String value) {
    return '$value ਕਿਮੀ';
  }

  @override
  String valueMillionKm(String value) {
    return '$value ਮਿਲੀਅਨ ਕਿਮੀ';
  }

  @override
  String valueHours(String value) {
    return '$value ਘੰਟੇ';
  }

  @override
  String valueDays(String value) {
    return '$value ਦਿਨ';
  }

  @override
  String valueYears(String value) {
    return '$value ਸਾਲ';
  }

  @override
  String get atmosphere => 'ਵਾਯੂਮੰਡਲ';

  @override
  String get thinAtmosphere =>
      'ਲਗਭਗ ਕੋਈ ਵਾਯੂਮੰਡਲ ਨਹੀਂ। ਇਹ ਗੈਸਾਂ ਐਕਸੋਸਫੀਅਰ ਨਾਂ ਦੀ ਬਹੁਤ ਪਤਲੀ ਪਰਤ ਬਣਾਉਂਦੀਆਂ ਹਨ।';

  @override
  String get oxygen => 'ਆਕਸੀਜਨ';

  @override
  String get oxygenVsEarth => 'ਆਕਸੀਜਨ: ਧਰਤੀ ਨਾਲ ਤੁਲਨਾ';

  @override
  String get breathable => 'ਮਨੁੱਖਾਂ ਦੇ ਸਾਹ ਲੈਣ ਯੋਗ';

  @override
  String get notBreathable => 'ਸਾਹ ਲੈਣ ਯੋਗ ਨਹੀਂ, ਸਪੇਸਸੂਟ ਲੋੜੀਂਦਾ ਹੈ';

  @override
  String weightFeelsLike(String weight) {
    return 'ਧਰਤੀ ਦੇ $weight ਕਿਲੋ ਇੱਥੇ ਇੰਨੇ ਲੱਗਣਗੇ';
  }

  @override
  String get gasCo2 => 'ਕਾਰਬਨ ਡਾਈਆਕਸਾਈਡ';

  @override
  String get gasN2 => 'ਨਾਈਟ੍ਰੋਜਨ';

  @override
  String get gasO2 => 'ਆਕਸੀਜਨ';

  @override
  String get gasAr => 'ਆਰਗਨ';

  @override
  String get gasH2 => 'ਹਾਈਡ੍ਰੋਜਨ';

  @override
  String get gasHe => 'ਹੀਲੀਅਮ';

  @override
  String get gasCh4 => 'ਮੀਥੇਨ';

  @override
  String get gasNa => 'ਸੋਡੀਅਮ';

  @override
  String get gasK => 'ਪੋਟਾਸ਼ੀਅਮ';

  @override
  String get compareTitle => 'ਗ੍ਰਹਿਆਂ ਦੀ ਤੁਲਨਾ';

  @override
  String get compareHint => 'ਨਾਲ-ਨਾਲ ਦੇਖਣ ਲਈ ਦੋ ਗ੍ਰਹਿ ਚੁਣੋ।';

  @override
  String get weightTitle => 'ਹੋਰ ਗ੍ਰਹਿਆਂ ’ਤੇ ਤੁਹਾਡਾ ਭਾਰ';

  @override
  String get weightInput => 'ਧਰਤੀ ’ਤੇ ਤੁਹਾਡਾ ਭਾਰ (ਕਿਲੋ)';

  @override
  String gravityTimes(String factor) {
    return 'ਧਰਤੀ ਦੀ ਗੁਰੂਤਾ ਦਾ $factor×';
  }

  @override
  String get quizTitle => 'ਗ੍ਰਹਿ ਕੁਇਜ਼';

  @override
  String get quizIntro =>
      'ਗ੍ਰਹਿਆਂ ਅਤੇ ਚੰਦਰਮਿਆਂ ਬਾਰੇ 10 ਸਵਾਲ। ਤੁਸੀਂ ਕਿੰਨੇ ਸਹੀ ਕਰ ਸਕਦੇ ਹੋ?';

  @override
  String get quizStart => 'ਕੁਇਜ਼ ਸ਼ੁਰੂ ਕਰੋ';

  @override
  String quizProgress(int current, int total) {
    return 'ਸਵਾਲ $current / $total';
  }

  @override
  String get quizNext => 'ਅੱਗੇ';

  @override
  String get quizSeeResult => 'ਨਤੀਜਾ ਦੇਖੋ';

  @override
  String get quizCorrect => 'ਸਹੀ!';

  @override
  String quizWrong(String answer) {
    return 'ਨਹੀਂ। ਸਹੀ ਜਵਾਬ $answer ਹੈ।';
  }

  @override
  String quizScore(int score, int total) {
    return '$total ਵਿੱਚੋਂ $score ਸਹੀ';
  }

  @override
  String quizBest(int score) {
    return 'ਸਭ ਤੋਂ ਵਧੀਆ ਸਕੋਰ: $score';
  }

  @override
  String get quizNewBest => 'ਨਵਾਂ ਸਭ ਤੋਂ ਵਧੀਆ ਸਕੋਰ!';

  @override
  String get quizAgain => 'ਮੁੜ ਖੇਡੋ';

  @override
  String get qLargest => 'ਸਭ ਤੋਂ ਵੱਡਾ ਗ੍ਰਹਿ ਕਿਹੜਾ ਹੈ?';

  @override
  String get qSmallest => 'ਸਭ ਤੋਂ ਛੋਟਾ ਗ੍ਰਹਿ ਕਿਹੜਾ ਹੈ?';

  @override
  String get qHottest => 'ਸਭ ਤੋਂ ਗਰਮ ਗ੍ਰਹਿ ਕਿਹੜਾ ਹੈ?';

  @override
  String get qColdest => 'ਸਭ ਤੋਂ ਠੰਢਾ ਗ੍ਰਹਿ ਕਿਹੜਾ ਹੈ?';

  @override
  String get qMostMoons => 'ਕਿਸ ਗ੍ਰਹਿ ਦੇ ਸਭ ਤੋਂ ਵੱਧ ਜਾਣੇ-ਪਛਾਣੇ ਚੰਦਰਮਾ ਹਨ?';

  @override
  String get qBreathable => 'ਕਿਸ ਗ੍ਰਹਿ ’ਤੇ ਮਨੁੱਖ ਹਵਾ ਵਿੱਚ ਸਾਹ ਲੈ ਸਕਦੇ ਹਨ?';

  @override
  String get qClosest => 'ਸੂਰਜ ਦੇ ਸਭ ਤੋਂ ਨੇੜੇ ਕਿਹੜਾ ਗ੍ਰਹਿ ਹੈ?';

  @override
  String get qFarthest => 'ਸੂਰਜ ਤੋਂ ਸਭ ਤੋਂ ਦੂਰ ਕਿਹੜਾ ਗ੍ਰਹਿ ਹੈ?';

  @override
  String get qStrongestGravity => 'ਕਿਸ ਗ੍ਰਹਿ ਦੀ ਗੁਰੂਤਾ ਸਭ ਤੋਂ ਵੱਧ ਹੈ?';

  @override
  String get qShortestDay => 'ਕਿਸ ਗ੍ਰਹਿ ਦਾ ਦਿਨ ਸਭ ਤੋਂ ਛੋਟਾ ਹੈ?';

  @override
  String get qLongestDay => 'ਕਿਸ ਗ੍ਰਹਿ ਦਾ ਦਿਨ ਸਭ ਤੋਂ ਲੰਬਾ ਹੈ?';

  @override
  String get appearance => 'ਦਿੱਖ';

  @override
  String get theme => 'ਥੀਮ';

  @override
  String get themeSystem => 'ਸਿਸਟਮ';

  @override
  String get themeLight => 'ਲਾਈਟ';

  @override
  String get themeDark => 'ਡਾਰਕ';

  @override
  String get language => 'ਭਾਸ਼ਾ';

  @override
  String get appLanguage => 'ਐਪ ਦੀ ਭਾਸ਼ਾ';

  @override
  String get languageNote => '20 ਭਾਸ਼ਾਵਾਂ · ਗ੍ਰਹਿਆਂ ਦੇ ਨਾਂ ਵੀ';

  @override
  String get phoneLanguage => 'ਫ਼ੋਨ ਦੀ ਭਾਸ਼ਾ';

  @override
  String get updates => 'ਅੱਪਡੇਟ';

  @override
  String get version => 'ਵਰਜ਼ਨ';

  @override
  String get checkForUpdates => 'ਅੱਪਡੇਟ ਜਾਂਚੋ';

  @override
  String get checking => 'ਜਾਂਚ ਹੋ ਰਹੀ ਹੈ…';

  @override
  String get autoUpdateCheck => 'ਦਿਨ ਵਿੱਚ ਇੱਕ ਵਾਰ ਆਪਣੇ-ਆਪ ਜਾਂਚੋ';

  @override
  String get updateNote =>
      'ਅੱਪਡੇਟ GitHub Releases ਤੋਂ ਆਉਂਦੇ ਹਨ। ਤੁਹਾਡੀਆਂ ਸੈਟਿੰਗਾਂ ਤੁਹਾਡੇ ਫ਼ੋਨ ਵਿੱਚ ਹੀ ਰਹਿੰਦੀਆਂ ਹਨ।';

  @override
  String get upToDate => 'ਤੁਹਾਡੇ ਕੋਲ ਨਵਾਂ ਵਰਜ਼ਨ ਹੈ।';

  @override
  String get updateFailed =>
      'GitHub ਤੱਕ ਨਹੀਂ ਪਹੁੰਚ ਸਕੇ। ਇੰਟਰਨੈੱਟ ਜਾਂਚ ਕੇ ਮੁੜ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get updateAvailable => 'ਅੱਪਡੇਟ ਉਪਲਬਧ ਹੈ';

  @override
  String updateReady(String version) {
    return 'ਵਰਜ਼ਨ $version ਡਾਊਨਲੋਡ ਲਈ ਤਿਆਰ ਹੈ।';
  }

  @override
  String get download => 'ਡਾਊਨਲੋਡ';

  @override
  String get later => 'ਬਾਅਦ ਵਿੱਚ';

  @override
  String get about => 'ਬਾਰੇ';

  @override
  String get sourceCode => 'GitHub ’ਤੇ ਸੋਰਸ ਕੋਡ';

  @override
  String get privacyLine => 'ਆਫ਼ਲਾਈਨ · ਕੋਈ ਇਸ਼ਤਿਹਾਰ ਨਹੀਂ · ਕੋਈ ਟਰੈਕਿੰਗ ਨਹੀਂ';

  @override
  String get dataSource => 'ਤੱਥ: NASA Planetary Fact Sheet';

  @override
  String get openFailed => 'ਲਿੰਕ ਨਹੀਂ ਖੁੱਲ੍ਹ ਸਕਿਆ।';

  @override
  String get bodySun => 'ਸੂਰਜ';

  @override
  String get bodyMoon => 'ਚੰਦਰਮਾ';

  @override
  String get bodyPluto => 'ਪਲੂਟੋ';

  @override
  String get moonIo => 'ਆਇਓ';

  @override
  String get moonEuropa => 'ਯੂਰੋਪਾ';

  @override
  String get moonGanymede => 'ਗੈਨੀਮੀਡ';

  @override
  String get moonCallisto => 'ਕੈਲਿਸਟੋ';

  @override
  String get moonTitan => 'ਟਾਈਟਨ';

  @override
  String get moonEnceladus => 'ਐਨਸੇਲਾਡਸ';

  @override
  String get moonTriton => 'ਟ੍ਰਾਈਟਨ';

  @override
  String get kindStar => 'ਸਾਡਾ ਤਾਰਾ, ਸੂਰਜੀ ਮੰਡਲ ਦਾ ਕੇਂਦਰ';

  @override
  String get kindDwarf => 'ਬੌਣਾ ਗ੍ਰਹਿ';

  @override
  String moonOf(String planet) {
    return '$planet ਦਾ ਚੰਦਰਮਾ';
  }

  @override
  String get orbitPeriod => 'ਇੱਕ ਚੱਕਰ';

  @override
  String distanceFrom(String body) {
    return '$body ਤੋਂ ਦੂਰੀ';
  }

  @override
  String get composition => 'ਇਹ ਕਿਸ ਚੀਜ਼ ਦਾ ਬਣਿਆ ਹੈ';

  @override
  String get noAtmosphere => 'ਅਸਲ ਵਾਯੂਮੰਡਲ ਨਹੀਂ, ਲਗਭਗ ਖਲਾਅ ਹੈ।';

  @override
  String get majorMoons => 'ਮੁੱਖ ਚੰਦਰਮਾ';

  @override
  String get lifeTitle => 'ਕੀ ਮਨੁੱਖ ਇੱਥੇ ਰਹਿ ਸਕਦੇ ਹਨ?';

  @override
  String get lifeScoreShort => 'ਜੀਵਨ ਸਕੋਰ';

  @override
  String get lifeNote =>
      'ਤਾਪਮਾਨ, ਹਵਾ ਦੇ ਦਬਾਅ, ਆਕਸੀਜਨ, ਪਾਣੀ, ਸਤ੍ਹਾ ਅਤੇ ਗੁਰੂਤਾ ਤੋਂ ਗਿਣਿਆ। ਧਰਤੀ ਦਾ ਸਕੋਰ 10 ਹੈ।';

  @override
  String get water => 'ਪਾਣੀ';

  @override
  String get waterLiquid => 'ਤਰਲ ਪਾਣੀ';

  @override
  String get waterIce => 'ਬਰਫ਼';

  @override
  String get waterOcean => 'ਬਰਫ਼ ਹੇਠ ਸਮੁੰਦਰ';

  @override
  String get waterNone => 'ਪਾਣੀ ਨਹੀਂ';

  @override
  String get surface => 'ਸਤ੍ਹਾ';

  @override
  String get solidSurface => 'ਠੋਸ ਸਤ੍ਹਾ';

  @override
  String get lifeHome => 'ਬਿਲਕੁਲ ਘਰ ਵਰਗਾ';

  @override
  String get lifeHard => 'ਬਹੁਤ ਔਖਾ, ਬੰਦ ਬੇਸ ਅਤੇ ਸਪੇਸਸੂਟ ਚਾਹੀਦੇ ਹਨ';

  @override
  String get lifeNo => 'ਮਨੁੱਖਾਂ ਲਈ ਅਸੰਭਵ';

  @override
  String get downloadInstall => 'ਡਾਊਨਲੋਡ ਕਰਕੇ ਇੰਸਟਾਲ ਕਰੋ';

  @override
  String downloadingPercent(String percent) {
    return 'ਡਾਊਨਲੋਡ ਹੋ ਰਿਹਾ ਹੈ… $percent%';
  }

  @override
  String get installNow => 'ਇੰਸਟਾਲ ਕਰੋ';

  @override
  String get allowInstalls =>
      'ਖੁੱਲ੍ਹੀ ਸਕ੍ਰੀਨ ਵਿੱਚ Heliora ਨੂੰ ਐਪ ਇੰਸਟਾਲ ਕਰਨ ਦੀ ਇਜਾਜ਼ਤ ਦਿਓ, ਫਿਰ ਵਾਪਸ ਆ ਕੇ ਇੰਸਟਾਲ ਦਬਾਓ।';

  @override
  String get downloadFailed =>
      'ਡਾਊਨਲੋਡ ਪੂਰਾ ਨਹੀਂ ਹੋਇਆ। ਇੰਟਰਨੈੱਟ ਜਾਂਚ ਕੇ ਮੁੜ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String get tryAgain => 'ਮੁੜ ਕੋਸ਼ਿਸ਼ ਕਰੋ';

  @override
  String get today => 'ਅੱਜ';

  @override
  String get play => 'ਚਲਾਓ';

  @override
  String get pause => 'ਰੋਕੋ';

  @override
  String get monthBack => '30 ਦਿਨ ਪਹਿਲਾਂ';

  @override
  String get monthForward => '30 ਦਿਨ ਬਾਅਦ';

  @override
  String get positionsNote =>
      'ਇਸ ਤਾਰੀਖ਼ ਦੀ ਅਸਲ ਸਥਿਤੀ · ਆਕਾਰ ਅਤੇ ਦੂਰੀ ਪੈਮਾਨੇ ਮੁਤਾਬਕ ਨਹੀਂ · ਗ੍ਰਹਿ ’ਤੇ ਟੈਪ ਕਰੋ';

  @override
  String get navYou => 'ਤੁਸੀਂ';

  @override
  String get ageTitle => 'ਹੋਰ ਗ੍ਰਹਿਆਂ ’ਤੇ ਤੁਹਾਡੀ ਉਮਰ';

  @override
  String get setBirthDate => 'ਆਪਣੀ ਜਨਮ ਤਾਰੀਖ਼ ਪਾਓ';

  @override
  String get changeBirthDate => 'ਬਦਲੋ';

  @override
  String nextBirthday(String days) {
    return 'ਅਗਲਾ ਜਨਮਦਿਨ $days ਦਿਨਾਂ ਵਿੱਚ';
  }

  @override
  String get ageNote => 'ਤੁਹਾਡੀ ਜਨਮ ਤਾਰੀਖ਼ ਸਿਰਫ਼ ਇਸ ਫ਼ੋਨ ਵਿੱਚ ਸੇਵ ਹੁੰਦੀ ਹੈ।';

  @override
  String get share => 'ਸਾਂਝਾ ਕਰੋ';

  @override
  String shareText(String planet) {
    return 'Heliora ਵਿੱਚ $planet, ਮੁਫ਼ਤ ਆਫ਼ਲਾਈਨ ਸੂਰਜੀ ਮੰਡਲ ਐਪ: https://github.com/lumio-apps/heliora';
  }

  @override
  String get shareFailed => 'ਤਸਵੀਰ ਸਾਂਝੀ ਨਹੀਂ ਹੋ ਸਕੀ।';

  @override
  String get travelTitle => 'ਕਿੰਨੀ ਦੂਰ ਹੈ?';

  @override
  String get distanceFromEarth => 'ਅੱਜ ਧਰਤੀ ਤੋਂ ਦੂਰੀ';

  @override
  String get lightTime => 'ਰੋਸ਼ਨੀ ਨੂੰ ਲੱਗਦਾ ਹੈ';

  @override
  String get bySpacecraft => '60,000 ਕਿਮੀ/ਘੰਟਾ ਵਾਲੇ ਪੁਲਾੜ ਯਾਨ ਨਾਲ';

  @override
  String get byCar => '100 ਕਿਮੀ/ਘੰਟਾ ਵਾਲੀ ਕਾਰ ਨਾਲ';

  @override
  String valueSeconds(String value) {
    return '$value ਸਕਿੰਟ';
  }

  @override
  String valueMinutes(String value) {
    return '$value ਮਿੰਟ';
  }

  @override
  String get sizeTitle => 'ਆਕਾਰ';

  @override
  String sizeTimes(String big, String times, String small) {
    return '$big ਚੌੜਾਈ ਵਿੱਚ $small ਤੋਂ $times× ਵੱਡਾ ਹੈ।';
  }

  @override
  String sizeSimilar(String a, String b) {
    return '$a ਅਤੇ $b ਲਗਭਗ ਇੱਕੋ ਆਕਾਰ ਦੇ ਹਨ।';
  }

  @override
  String get navSky => 'ਅਸਮਾਨ';

  @override
  String get skyTitle => 'ਅੱਜ ਰਾਤ ਦਾ ਅਸਮਾਨ';

  @override
  String get chooseCity => 'ਆਪਣਾ ਸ਼ਹਿਰ ਚੁਣੋ';

  @override
  String get chooseCityHint =>
      'ਚੰਦਰਮਾ ਅਤੇ ਅੱਜ ਰਾਤ ਦਿਸਣ ਵਾਲੇ ਗ੍ਰਹਿ ਦੇਖਣ ਲਈ ਨੇੜਲਾ ਸ਼ਹਿਰ ਚੁਣੋ। ਲੋਕੇਸ਼ਨ ਦੀ ਇਜਾਜ਼ਤ ਨਹੀਂ ਚਾਹੀਦੀ, ਅਤੇ ਇਹ ਫ਼ੋਨ ਵਿੱਚ ਹੀ ਰਹਿੰਦਾ ਹੈ।';

  @override
  String get searchCity => 'ਸ਼ਹਿਰ ਲੱਭੋ';

  @override
  String get noCityFound => 'ਕੋਈ ਸ਼ਹਿਰ ਨਹੀਂ ਮਿਲਿਆ';

  @override
  String get cityNote =>
      'ਸਮਾਂ ਤੁਹਾਡੇ ਫ਼ੋਨ ਦੇ ਟਾਈਮ ਜ਼ੋਨ ਵਿੱਚ ਹੈ। ਹਨੇਰੇ ਅਸਮਾਨ ਵਿੱਚ ਦਿਸਹੱਦੇ ਤੋਂ ਘੱਟੋ-ਘੱਟ 5° ਉੱਪਰ ਹੋਣ ’ਤੇ ਗ੍ਰਹਿ ਦਿਸਦਾ ਮੰਨਿਆ ਜਾਂਦਾ ਹੈ।';

  @override
  String illuminated(String percent) {
    return '$percent% ਰੌਸ਼ਨ';
  }

  @override
  String get moonrise => 'ਚੰਦਰਮਾ ਚੜ੍ਹਨਾ';

  @override
  String get moonset => 'ਚੰਦਰਮਾ ਛਿਪਣਾ';

  @override
  String get sunset => 'ਸੂਰਜ ਛਿਪਣਾ';

  @override
  String get sunrise => 'ਸੂਰਜ ਚੜ੍ਹਨਾ';

  @override
  String get nextFull => 'ਅਗਲੀ ਪੂਰਨਮਾਸ਼ੀ';

  @override
  String get nextNew => 'ਅਗਲੀ ਮੱਸਿਆ';

  @override
  String get phaseNew => 'ਮੱਸਿਆ';

  @override
  String get phaseWaxingCrescent => 'ਵਧਦਾ ਅੱਧ-ਚੰਨ';

  @override
  String get phaseFirstQuarter => 'ਸ਼ੁਕਲ ਅਸ਼ਟਮੀ';

  @override
  String get phaseWaxingGibbous => 'ਵਧਦਾ ਚੰਨ';

  @override
  String get phaseFull => 'ਪੂਰਨਮਾਸ਼ੀ';

  @override
  String get phaseWaningGibbous => 'ਘਟਦਾ ਚੰਨ';

  @override
  String get phaseLastQuarter => 'ਕ੍ਰਿਸ਼ਨ ਅਸ਼ਟਮੀ';

  @override
  String get phaseWaningCrescent => 'ਘਟਦਾ ਅੱਧ-ਚੰਨ';

  @override
  String get planetsTonight => 'ਅੱਜ ਰਾਤ ਦੇ ਗ੍ਰਹਿ';

  @override
  String get statusVisible => 'ਅੱਜ ਰਾਤ ਦਿਸੇਗਾ';

  @override
  String get statusEvening => 'ਸ਼ਾਮ ਨੂੰ, ਸੂਰਜ ਛਿਪਣ ਤੋਂ ਬਾਅਦ';

  @override
  String get statusMorning => 'ਸਵੇਰੇ, ਸੂਰਜ ਚੜ੍ਹਨ ਤੋਂ ਪਹਿਲਾਂ';

  @override
  String get statusNotVisible => 'ਅੱਜ ਰਾਤ ਨਹੀਂ ਦਿਸੇਗਾ';

  @override
  String bestAt(String time) {
    return 'ਸਭ ਤੋਂ ਵਧੀਆ ਸਮਾਂ $time';
  }

  @override
  String altitudeDir(String direction, String degrees) {
    return '$direction, $degrees° ਉੱਚਾ';
  }

  @override
  String riseSet(String rise, String set) {
    return 'ਚੜ੍ਹਦਾ $rise · ਛਿਪਦਾ $set';
  }

  @override
  String get needsTelescope => 'ਦੂਰਬੀਨ ਜਾਂ ਟੈਲੀਸਕੋਪ ਚਾਹੀਦੀ ਹੈ';

  @override
  String get dirN => 'ਉੱਤਰ';

  @override
  String get dirNE => 'ਉੱਤਰ-ਪੂਰਬ';

  @override
  String get dirE => 'ਪੂਰਬ';

  @override
  String get dirSE => 'ਦੱਖਣ-ਪੂਰਬ';

  @override
  String get dirS => 'ਦੱਖਣ';

  @override
  String get dirSW => 'ਦੱਖਣ-ਪੱਛਮ';

  @override
  String get dirW => 'ਪੱਛਮ';

  @override
  String get dirNW => 'ਉੱਤਰ-ਪੱਛਮ';

  @override
  String get findPlanet => 'ਅਸਮਾਨ ਵਿੱਚ ਲੱਭੋ';

  @override
  String finderTitle(String name) {
    return '$name ਲੱਭੋ';
  }

  @override
  String get pointPhone => 'ਫ਼ੋਨ ਉੱਪਰ ਚੁੱਕ ਕੇ ਹੌਲੀ-ਹੌਲੀ ਘੁਮਾਓ।';

  @override
  String turnRight(String degrees) {
    return '$degrees° ਸੱਜੇ ਮੁੜੋ';
  }

  @override
  String turnLeft(String degrees) {
    return '$degrees° ਖੱਬੇ ਮੁੜੋ';
  }

  @override
  String tiltUp(String degrees) {
    return '$degrees° ਉੱਪਰ ਕਰੋ';
  }

  @override
  String tiltDown(String degrees) {
    return '$degrees° ਹੇਠਾਂ ਕਰੋ';
  }

  @override
  String onTarget(String name) {
    return '$name ਬਿਲਕੁਲ ਉੱਥੇ ਹੀ ਹੈ!';
  }

  @override
  String belowHorizon(String name) {
    return '$name ਇਸ ਵੇਲੇ ਦਿਸਹੱਦੇ ਤੋਂ ਹੇਠਾਂ ਹੈ।';
  }

  @override
  String risesAt(String time) {
    return 'ਇਹ $time ਵਜੇ ਚੜ੍ਹੇਗਾ।';
  }

  @override
  String get noSensor =>
      'ਇਸ ਫ਼ੋਨ ਵਿੱਚ ਕੰਪਾਸ ਸੈਂਸਰ ਨਹੀਂ ਹੈ, ਇਸ ਲਈ ਖੋਜਕ ਕੰਮ ਨਹੀਂ ਕਰੇਗਾ।';

  @override
  String get calibrate =>
      'ਕੰਪਾਸ ਨੂੰ ਕੈਲੀਬ੍ਰੇਟ ਕਰਨਾ ਹੈ: ਫ਼ੋਨ ਨੂੰ ਕੁਝ ਵਾਰ 8 ਦੀ ਸ਼ਕਲ ਵਿੱਚ ਘੁਮਾਓ।';

  @override
  String get phoneNow => 'ਤੁਹਾਡਾ ਫ਼ੋਨ ਇਸ ਪਾਸੇ ਹੈ';

  @override
  String get finderNote =>
      'ਫ਼ੋਨ ਦਾ ਪਿਛਲਾ ਹਿੱਸਾ ਅਸਮਾਨ ਵੱਲ ਰੱਖੋ ਅਤੇ ਚੁੰਬਕ ਤੇ ਧਾਤ ਤੋਂ ਦੂਰ ਰੱਖੋ। ਸੂਰਜ ਵੱਲ ਕਦੇ ਨਾ ਦੇਖੋ।';

  @override
  String get eventsTitle => 'ਪੁਲਾੜ ਦੀਆਂ ਘਟਨਾਵਾਂ';

  @override
  String get eventsSubtitle => 'ਅਗਲੇ 12 ਮਹੀਨਿਆਂ ਵਿੱਚ ਅਸਮਾਨ ਵਿੱਚ ਕੀ ਦੇਖਣਾ ਹੈ।';

  @override
  String eventsNext(String event, String when) {
    return 'ਅਗਲੀ: $event · $when';
  }

  @override
  String get eventFullMoon => 'ਪੂਰਨਮਾਸ਼ੀ';

  @override
  String get eventNewMoon => 'ਮੱਸਿਆ';

  @override
  String eventOpposition(String planet) {
    return '$planet ਪ੍ਰਤੀਯੁਤੀ ਵਿੱਚ';
  }

  @override
  String eventEveningElongation(String planet) {
    return '$planet: ਸ਼ਾਮ ਨੂੰ ਦੇਖਣ ਦਾ ਸਭ ਤੋਂ ਵਧੀਆ ਸਮਾਂ';
  }

  @override
  String eventMorningElongation(String planet) {
    return '$planet: ਸਵੇਰੇ ਦੇਖਣ ਦਾ ਸਭ ਤੋਂ ਵਧੀਆ ਸਮਾਂ';
  }

  @override
  String eventConjunction(String a, String b) {
    return '$a ਅਤੇ $b ਨੇੜੇ ਆਉਂਦੇ ਹਨ';
  }

  @override
  String get eventMarchEquinox => 'ਮਾਰਚ ਸਮਰਾਤ';

  @override
  String get eventJuneSolstice => 'ਜੂਨ ਸੰਕ੍ਰਾਂਤੀ';

  @override
  String get eventSeptemberEquinox => 'ਸਤੰਬਰ ਸਮਰਾਤ';

  @override
  String get eventDecemberSolstice => 'ਦਸੰਬਰ ਸੰਕ੍ਰਾਂਤੀ';

  @override
  String get eventFullMoonDesc =>
      'ਚੰਦ ਦਾ ਪੂਰਾ ਚਿਹਰਾ ਰੌਸ਼ਨ ਹੁੰਦਾ ਹੈ। ਇਹ ਸੂਰਜ ਛਿਪਣ ਦੇ ਆਸ-ਪਾਸ ਚੜ੍ਹਦਾ ਹੈ।';

  @override
  String get eventNewMoonDesc =>
      'ਚੰਦ ਦਿਖਾਈ ਨਹੀਂ ਦਿੰਦਾ। ਤਾਰੇ ਅਤੇ ਗ੍ਰਹਿ ਦੇਖਣ ਲਈ ਮਹੀਨੇ ਦਾ ਸਭ ਤੋਂ ਹਨੇਰਾ ਅਸਮਾਨ।';

  @override
  String eventOppositionDesc(String planet) {
    return '$planet ਸੂਰਜ ਦੇ ਬਿਲਕੁਲ ਸਾਹਮਣੇ ਹੈ। ਇਸ ਸਾਲ ਇਹ ਸਭ ਤੋਂ ਚਮਕੀਲਾ ਹੈ ਅਤੇ ਸਾਰੀ ਰਾਤ ਦਿਸਦਾ ਹੈ।';
  }

  @override
  String eventEveningDesc(String planet, String degrees) {
    return '$planet ਸੂਰਜ ਤੋਂ $degrees° ਦੂਰ ਹੈ, ਸਭ ਤੋਂ ਵੱਧ ਦੂਰ। ਸੂਰਜ ਛਿਪਣ ਤੋਂ ਬਾਅਦ ਪੱਛਮ ਵਿੱਚ ਨੀਵਾਂ ਦੇਖੋ।';
  }

  @override
  String eventMorningDesc(String planet, String degrees) {
    return '$planet ਸੂਰਜ ਤੋਂ $degrees° ਦੂਰ ਹੈ, ਸਭ ਤੋਂ ਵੱਧ ਦੂਰ। ਸੂਰਜ ਚੜ੍ਹਨ ਤੋਂ ਪਹਿਲਾਂ ਪੂਰਬ ਵਿੱਚ ਨੀਵਾਂ ਦੇਖੋ।';
  }

  @override
  String eventConjunctionDesc(String degrees) {
    return 'ਅਸਮਾਨ ਵਿੱਚ ਇਹ ਸਿਰਫ਼ $degrees° ਦੇ ਫ਼ਾਸਲੇ ਤੋਂ ਲੰਘਦੇ ਹਨ।';
  }

  @override
  String get eventEquinoxDesc =>
      'ਧਰਤੀ ਉੱਤੇ ਹਰ ਥਾਂ ਦਿਨ ਅਤੇ ਰਾਤ ਲਗਭਗ ਬਰਾਬਰ ਹੁੰਦੇ ਹਨ।';

  @override
  String get eventJuneSolsticeDesc =>
      'ਉੱਤਰ ਵਿੱਚ ਸਭ ਤੋਂ ਲੰਮਾ ਦਿਨ, ਦੱਖਣ ਵਿੱਚ ਸਭ ਤੋਂ ਛੋਟਾ।';

  @override
  String get eventDecemberSolsticeDesc =>
      'ਉੱਤਰ ਵਿੱਚ ਸਭ ਤੋਂ ਛੋਟਾ ਦਿਨ, ਦੱਖਣ ਵਿੱਚ ਸਭ ਤੋਂ ਲੰਮਾ।';

  @override
  String eventMeteorShower(String shower) {
    return '$shower ਉਲਕਾ ਵਰਖਾ';
  }

  @override
  String eventMeteorDesc(String rate, String percent) {
    return 'ਹਨੇਰੇ ਅਸਮਾਨ ਵਿੱਚ ਘੰਟੇ ਵਿੱਚ ਲਗਭਗ $rate ਤੱਕ ਉਲਕਾਵਾਂ। ਚੰਦ $percent% ਰੌਸ਼ਨ ਹੋਵੇਗਾ।';
  }

  @override
  String get showerQuadrantids => 'ਕੁਆਡ੍ਰੈਂਟਿਡਜ਼';

  @override
  String get showerLyrids => 'ਲਾਇਰਿਡਜ਼';

  @override
  String get showerEtaAquariids => 'ਏਟਾ ਐਕੁਏਰਿਡਜ਼';

  @override
  String get showerPerseids => 'ਪਰਸੀਡਜ਼';

  @override
  String get showerOrionids => 'ਓਰਾਇਓਨਿਡਜ਼';

  @override
  String get showerLeonids => 'ਲਿਓਨਿਡਜ਼';

  @override
  String get showerGeminids => 'ਜੈਮਿਨਿਡਜ਼';

  @override
  String get showerUrsids => 'ਅਰਸਿਡਜ਼';

  @override
  String get eventToday => 'ਅੱਜ';

  @override
  String get eventTomorrow => 'ਕੱਲ੍ਹ';

  @override
  String eventInDays(String days) {
    return '$days ਦਿਨਾਂ ਵਿੱਚ';
  }

  @override
  String get eventsNote =>
      'ਤਾਰੀਖ਼ਾਂ ਤੁਹਾਡੇ ਫ਼ੋਨ ਵਿੱਚ ਹੀ ਕੱਢੀਆਂ ਜਾਂਦੀਆਂ ਹਨ ਅਤੇ ਉਸਦੇ ਟਾਈਮ ਜ਼ੋਨ ਵਿੱਚ ਦਿਖਦੀਆਂ ਹਨ। ਉਲਕਾ ਵਰਖਾ ਦੇ ਸਿਖਰ ਦਿਨ ਹਰ ਸਾਲ ਦੇ ਆਮ ਦਿਨ ਹਨ, ਇੱਕ ਦਿਨ ਦਾ ਫ਼ਰਕ ਪੈ ਸਕਦਾ ਹੈ। ਰੀਮਾਈਂਡਰ ਤੁਹਾਡੇ ਫ਼ੋਨ ਵਿੱਚ ਹੀ ਰਹਿੰਦੇ ਹਨ।';

  @override
  String get remindMe => 'ਮੈਨੂੰ ਯਾਦ ਕਰਵਾਓ';

  @override
  String reminderSet(String date) {
    return 'ਠੀਕ ਹੈ, ਮੈਂ ਤੁਹਾਨੂੰ $date ਨੂੰ ਯਾਦ ਕਰਵਾਵਾਂਗਾ।';
  }

  @override
  String get reminderOff => 'ਰੀਮਾਈਂਡਰ ਹਟਾ ਦਿੱਤਾ।';

  @override
  String get reminderTooLate => 'ਇਹ ਘਟਨਾ ਬਹੁਤ ਨੇੜੇ ਹੈ, ਰੀਮਾਈਂਡਰ ਨਹੀਂ ਲੱਗ ਸਕਦਾ।';

  @override
  String get notificationsOff =>
      'Heliora ਦੀਆਂ ਸੂਚਨਾਵਾਂ ਬੰਦ ਹਨ। Android ਸੈਟਿੰਗਾਂ ਵਿੱਚ ਚਾਲੂ ਕਰੋ।';

  @override
  String get reminderTomorrow => 'ਕੱਲ੍ਹ ਹੋਵੇਗਾ';

  @override
  String get reminderToday => 'ਅੱਜ ਹੋ ਰਿਹਾ ਹੈ';

  @override
  String get onlineTitle => 'ਔਨਲਾਈਨ ਸੁਵਿਧਾਵਾਂ';

  @override
  String get onlineSubtitle =>
      'ਪੁਲਾੜ ਸਟੇਸ਼ਨ ਅਤੇ ਰਾਕੇਟ ਲਾਂਚ ਦਿਖਾਓ। ਫਿਰ Heliora ਸਿਰਫ਼ wheretheiss.at, Celestrak ਅਤੇ Launch Library 2 ਨਾਲ ਜੁੜਦਾ ਹੈ, ਜੋ ਤੁਹਾਡੇ ਫ਼ੋਨ ਦਾ ਇੰਟਰਨੈੱਟ ਪਤਾ ਦੇਖ ਸਕਦੇ ਹਨ। ਹੋਰ ਕੁਝ ਨਹੀਂ ਭੇਜਿਆ ਜਾਂਦਾ। ਸ਼ੁਰੂ ਵਿੱਚ ਬੰਦ ਰਹਿੰਦਾ ਹੈ।';

  @override
  String get turnOnOnline => 'ਔਨਲਾਈਨ ਸੁਵਿਧਾਵਾਂ ਚਾਲੂ ਕਰੋ';

  @override
  String get issTitle => 'ਪੁਲਾੜ ਸਟੇਸ਼ਨ';

  @override
  String get issCardHint => 'ਹੁਣ ਕਿੱਥੇ ਹੈ ਅਤੇ ਤੁਹਾਡੇ ਉੱਪਰੋਂ ਕਦੋਂ ਲੰਘੇਗਾ';

  @override
  String get issNeedsOnline =>
      'ਸਟੇਸ਼ਨ ਦਿਖਾਉਣ ਲਈ Heliora ਨੂੰ ਇੰਟਰਨੈੱਟ ਤੋਂ ਉਸਦਾ ਪੰਧ ਡੇਟਾ ਚਾਹੀਦਾ ਹੈ। ਇਹ ਇੱਕ ਵਾਰ ਡਾਊਨਲੋਡ ਹੁੰਦਾ ਹੈ ਅਤੇ ਫਿਰ ਕਈ ਦਿਨ ਔਫਲਾਈਨ ਚੱਲਦਾ ਹੈ।';

  @override
  String get issLoading => 'ਪੰਧ ਡੇਟਾ ਲਿਆ ਜਾ ਰਿਹਾ ਹੈ…';

  @override
  String get issFailed =>
      'ਪੰਧ ਡੇਟਾ ਨਹੀਂ ਮਿਲਿਆ। ਇੰਟਰਨੈੱਟ ਜਾਂਚੋ ਅਤੇ ਫਿਰ ਕੋਸ਼ਿਸ਼ ਕਰੋ।';

  @override
  String issStale(String days) {
    return 'ਪੰਧ ਡੇਟਾ $days ਦਿਨ ਪੁਰਾਣਾ ਹੈ, ਇਸ ਲਈ ਥਾਂ ਥੋੜ੍ਹੀ ਗ਼ਲਤ ਹੋ ਸਕਦੀ ਹੈ। ਨਵਾਂ ਲੈਣ ਲਈ ਇੰਟਰਨੈੱਟ ਨਾਲ ਜੁੜੋ।';
  }

  @override
  String get issHeight => 'ਉਚਾਈ';

  @override
  String get issSpeed => 'ਰਫ਼ਤਾਰ';

  @override
  String get issFromYou => 'ਤੁਹਾਡੇ ਤੋਂ ਦੂਰੀ';

  @override
  String valueKmh(String value) {
    return '$value ਕਿਮੀ/ਘੰਟਾ';
  }

  @override
  String issAboveHorizon(String direction, String degrees) {
    return 'ਹੁਣ ਤੁਹਾਡੇ ਦਿਸਹੱਦੇ ਤੋਂ ਉੱਪਰ ਹੈ! $direction ਵੱਲ ਦੇਖੋ, $degrees° ਉੱਚਾ।';
  }

  @override
  String get issBelowHorizon => 'ਹੁਣ ਤੁਹਾਡੇ ਦਿਸਹੱਦੇ ਤੋਂ ਹੇਠਾਂ ਹੈ।';

  @override
  String issPassesTitle(String city) {
    return '$city ਉੱਪਰੋਂ ਅਗਲੀਆਂ ਉਡਾਣਾਂ';
  }

  @override
  String get issNoPasses => 'ਅਗਲੇ 5 ਦਿਨਾਂ ਵਿੱਚ ਕੋਈ ਚੰਗੀ ਉਡਾਣ ਨਹੀਂ।';

  @override
  String issMaxHigh(String degrees) {
    return '$degrees° ਤੱਕ ਉੱਚਾ';
  }

  @override
  String issFromTo(String start, String end) {
    return '$start ਤੋਂ $end ਤੱਕ';
  }

  @override
  String get issVisible => 'ਆਸਾਨੀ ਨਾਲ ਦਿਸੇਗਾ';

  @override
  String get issHidden => 'ਦੇਖਣਾ ਔਖਾ';

  @override
  String get issPassTitle => 'ਪੁਲਾੜ ਸਟੇਸ਼ਨ ਤੁਹਾਡੇ ਉੱਪਰੋਂ ਲੰਘ ਰਿਹਾ ਹੈ';

  @override
  String issPassBody(String degrees, String direction) {
    return '10 ਮਿੰਟ ਵਿੱਚ ਚੜ੍ਹੇਗਾ, $degrees° ਤੱਕ ਉੱਚਾ। $direction ਵੱਲ ਦੇਖੋ।';
  }

  @override
  String get issNote =>
      'ਥਾਵਾਂ ਤੁਹਾਡੇ ਫ਼ੋਨ ਵਿੱਚ ਹੀ ਸਟੇਸ਼ਨ ਦੇ ਪੰਧ ਡੇਟਾ ਤੋਂ ਕੱਢੀਆਂ ਜਾਂਦੀਆਂ ਹਨ। ਜਦੋਂ ਅਸਮਾਨ ਹਨੇਰਾ ਹੋਵੇ ਅਤੇ ਸਟੇਸ਼ਨ ਉੱਤੇ ਸੂਰਜ ਦੀ ਰੌਸ਼ਨੀ ਪੈਂਦੀ ਹੋਵੇ ਤਾਂ ਇਹ ਆਸਾਨੀ ਨਾਲ ਦਿਸਦਾ ਹੈ: ਚਮਕਦੇ, ਤੇਜ਼ ਤਾਰੇ ਵਰਗਾ।';

  @override
  String get launchesNeedOnline =>
      'ਆਉਣ ਵਾਲੇ ਰਾਕੇਟ ਲਾਂਚ ਇੱਥੇ ਦੇਖਣ ਲਈ ਔਨਲਾਈਨ ਸੁਵਿਧਾਵਾਂ ਚਾਲੂ ਕਰੋ।';

  @override
  String get launchesFailed =>
      'ਲਾਂਚ ਸੂਚੀ ਅੱਪਡੇਟ ਨਹੀਂ ਹੋ ਸਕੀ। ਸੰਭਾਲੀ ਹੋਈ ਸੂਚੀ ਦਿਖਾ ਰਹੇ ਹਾਂ।';

  @override
  String get launchesNote =>
      'ਲਾਂਚ ਦਾ ਸਮਾਂ Launch Library 2 ਤੋਂ ਆਉਂਦਾ ਹੈ ਅਤੇ ਅਕਸਰ ਬਦਲਦਾ ਹੈ। ਨਾਮ ਅਤੇ ਥਾਵਾਂ ਅੰਗਰੇਜ਼ੀ ਵਿੱਚ ਹਨ।';

  @override
  String get launchReminderBody =>
      'ਲਗਭਗ ਇੱਕ ਘੰਟੇ ਵਿੱਚ ਉਡਾਣ ਭਰੇਗਾ। ਸਮਾਂ ਬਦਲ ਸਕਦਾ ਹੈ।';

  @override
  String get launchTimeTbd => 'ਸਮਾਂ ਅਜੇ ਤੈਅ ਨਹੀਂ';

  @override
  String get quizChoose => 'ਪੱਧਰ ਚੁਣੋ';

  @override
  String get levelEasy => 'ਸੌਖਾ';

  @override
  String get levelMedium => 'ਦਰਮਿਆਨਾ';

  @override
  String get levelHard => 'ਔਖਾ';

  @override
  String get levelEasyHint => 'ਗ੍ਰਹਿਆਂ ਬਾਰੇ ਮੁੱਢਲੀਆਂ ਗੱਲਾਂ';

  @override
  String get levelMediumHint => 'ਗ੍ਰਹਿ ਅਤੇ ਚੰਦਰਮਾ';

  @override
  String get levelHardHint => 'ਔਖੀਆਂ ਤੁਲਨਾਵਾਂ ਅਤੇ ਕ੍ਰਮ';

  @override
  String get qStar => 'ਇਨ੍ਹਾਂ ਵਿੱਚੋਂ ਕਿਹੜਾ ਤਾਰਾ ਹੈ, ਗ੍ਰਹਿ ਨਹੀਂ?';

  @override
  String get qDwarf => 'ਇਨ੍ਹਾਂ ਵਿੱਚੋਂ ਕਿਹੜਾ ਬੌਣਾ ਗ੍ਰਹਿ ਹੈ?';

  @override
  String get qMoonVisited => 'ਕਿਸ ਚੰਦਰਮਾ ਉੱਤੇ ਇਨਸਾਨ ਤੁਰ ਚੁੱਕੇ ਹਨ?';

  @override
  String get qLargestMoon => 'ਇਨ੍ਹਾਂ ਚੰਦਰਮਿਆਂ ਵਿੱਚੋਂ ਸਭ ਤੋਂ ਵੱਡਾ ਕਿਹੜਾ ਹੈ?';

  @override
  String get qSmallestMoon => 'ਇਨ੍ਹਾਂ ਚੰਦਰਮਿਆਂ ਵਿੱਚੋਂ ਸਭ ਤੋਂ ਛੋਟਾ ਕਿਹੜਾ ਹੈ?';

  @override
  String get qThickAirMoon =>
      'ਇਨ੍ਹਾਂ ਚੰਦਰਮਿਆਂ ਵਿੱਚੋਂ ਕਿਸ ਦਾ ਵਾਯੂਮੰਡਲ ਸੰਘਣਾ ਹੈ?';

  @override
  String get qGeyserMoon => 'ਕਿਹੜਾ ਚੰਦਰਮਾ ਪਾਣੀ ਦੇ ਫੁਹਾਰੇ ਪੁਲਾੜ ਵਿੱਚ ਛੱਡਦਾ ਹੈ?';

  @override
  String get qVolcanicMoon => 'ਕਿਸ ਚੰਦਰਮਾ ਉੱਤੇ ਸਭ ਤੋਂ ਵੱਧ ਸਰਗਰਮ ਜਵਾਲਾਮੁਖੀ ਹਨ?';

  @override
  String get qBackwardsMoon =>
      'ਕਿਹੜਾ ਚੰਦਰਮਾ ਆਪਣੇ ਗ੍ਰਹਿ ਦੁਆਲੇ ਉਲਟੀ ਦਿਸ਼ਾ ਵਿੱਚ ਘੁੰਮਦਾ ਹੈ?';

  @override
  String get qBiggestRocky => 'ਚਾਰ ਚੱਟਾਨੀ ਗ੍ਰਹਿਆਂ ਵਿੱਚੋਂ ਸਭ ਤੋਂ ਵੱਡਾ ਕਿਹੜਾ ਹੈ?';

  @override
  String get qColdestRocky => 'ਚਾਰ ਚੱਟਾਨੀ ਗ੍ਰਹਿਆਂ ਵਿੱਚੋਂ ਸਭ ਤੋਂ ਠੰਢਾ ਕਿਹੜਾ ਹੈ?';

  @override
  String get qHighestPressure =>
      'ਕਿਸ ਗ੍ਰਹਿ ਦੀ ਸਤ੍ਹਾ ਉੱਤੇ ਹਵਾ ਦਾ ਦਬਾਅ ਸਭ ਤੋਂ ਵੱਧ ਹੈ?';

  @override
  String get qSecondLargest => 'ਕਿਹੜਾ ਗ੍ਰਹਿ ਦੂਜਾ ਸਭ ਤੋਂ ਵੱਡਾ ਹੈ?';

  @override
  String get qLongestYear => 'ਕਿਸ ਗ੍ਰਹਿ ਦਾ ਸਾਲ ਸਭ ਤੋਂ ਲੰਮਾ ਹੈ?';

  @override
  String get qShortestYear => 'ਕਿਸ ਗ੍ਰਹਿ ਦਾ ਸਾਲ ਸਭ ਤੋਂ ਛੋਟਾ ਹੈ?';

  @override
  String get qSmallestGiant =>
      'ਚਾਰ ਵਿਸ਼ਾਲ ਗ੍ਰਹਿਆਂ ਵਿੱਚੋਂ ਸਭ ਤੋਂ ਛੋਟਾ ਕਿਹੜਾ ਹੈ?';

  @override
  String get qRockyLongestYear =>
      'ਚਾਰ ਚੱਟਾਨੀ ਗ੍ਰਹਿਆਂ ਵਿੱਚੋਂ ਕਿਸ ਦਾ ਸਾਲ ਸਭ ਤੋਂ ਲੰਮਾ ਹੈ?';

  @override
  String get qFastestMoon =>
      'ਇਨ੍ਹਾਂ ਚੰਦਰਮਿਆਂ ਵਿੱਚੋਂ ਕਿਹੜਾ ਆਪਣੇ ਗ੍ਰਹਿ ਦੁਆਲੇ ਸਭ ਤੋਂ ਤੇਜ਼ ਘੁੰਮਦਾ ਹੈ?';

  @override
  String get qSlowestMoon =>
      'ਇਨ੍ਹਾਂ ਚੰਦਰਮਿਆਂ ਵਿੱਚੋਂ ਕਿਸ ਨੂੰ ਆਪਣੇ ਗ੍ਰਹਿ ਦਾ ਚੱਕਰ ਲਾਉਣ ਵਿੱਚ ਸਭ ਤੋਂ ਵੱਧ ਸਮਾਂ ਲੱਗਦਾ ਹੈ?';

  @override
  String get qStrongestMoonGravity =>
      'ਇਨ੍ਹਾਂ ਚੰਦਰਮਿਆਂ ਵਿੱਚੋਂ ਕਿਸ ਦੀ ਗੁਰੂਤਾ ਸਭ ਤੋਂ ਵੱਧ ਹੈ?';

  @override
  String get qColdestMoon => 'ਇਨ੍ਹਾਂ ਚੰਦਰਮਿਆਂ ਵਿੱਚੋਂ ਸਭ ਤੋਂ ਠੰਢਾ ਕਿਹੜਾ ਹੈ?';

  @override
  String get qSecondLargestMoon =>
      'ਇਨ੍ਹਾਂ ਚੰਦਰਮਿਆਂ ਵਿੱਚੋਂ ਦੂਜਾ ਸਭ ਤੋਂ ਵੱਡਾ ਕਿਹੜਾ ਹੈ?';

  @override
  String get factTitle => 'ਕੀ ਤੁਸੀਂ ਜਾਣਦੇ ਹੋ?';

  @override
  String get factTap => 'ਹੋਰ ਤੱਥ ਦੇਖਣ ਲਈ ਟੈਪ ਕਰੋ';

  @override
  String get factSun1 => 'ਸੂਰਜੀ ਮੰਡਲ ਦੇ ਕੁੱਲ ਪੁੰਜ ਦਾ 99.8% ਹਿੱਸਾ ਸੂਰਜ ਵਿੱਚ ਹੈ।';

  @override
  String get factSun2 =>
      'ਸੂਰਜ ਦੀ ਰੌਸ਼ਨੀ ਨੂੰ ਧਰਤੀ ਤੱਕ ਪਹੁੰਚਣ ਵਿੱਚ ਲਗਭਗ 8 ਮਿੰਟ 20 ਸਕਿੰਟ ਲੱਗਦੇ ਹਨ।';

  @override
  String get factMercury1 =>
      'ਬੁੱਧ ਉੱਤੇ ਇੱਕ ਦਿਨ, ਯਾਨੀ ਇੱਕ ਸੂਰਜ ਚੜ੍ਹਨ ਤੋਂ ਅਗਲੇ ਸੂਰਜ ਚੜ੍ਹਨ ਤੱਕ, ਲਗਭਗ 176 ਧਰਤੀ-ਦਿਨਾਂ ਦਾ ਹੁੰਦਾ ਹੈ। ਇਹ ਉਸ ਦੇ ਸਾਲ ਤੋਂ ਦੁੱਗਣਾ ਲੰਮਾ ਹੈ।';

  @override
  String get factMercury2 =>
      'ਬੁੱਧ ਉੱਤੇ ਹਵਾ ਲਗਭਗ ਨਹੀਂ ਹੈ, ਇਸ ਲਈ ਦਿਨ ਵੇਲੇ ਵੀ ਉਸ ਦਾ ਅਸਮਾਨ ਕਾਲਾ ਰਹਿੰਦਾ ਹੈ ਅਤੇ ਰਾਤਾਂ ਜਮਾ ਦੇਣ ਵਾਲੀਆਂ ਠੰਢੀਆਂ ਹੁੰਦੀਆਂ ਹਨ।';

  @override
  String get factVenus1 =>
      'ਸ਼ੁੱਕਰ ਉਲਟੀ ਦਿਸ਼ਾ ਵਿੱਚ ਘੁੰਮਦਾ ਹੈ, ਇਸ ਲਈ ਉੱਥੇ ਸੂਰਜ ਪੱਛਮ ਵਿੱਚ ਚੜ੍ਹਦਾ ਹੈ।';

  @override
  String get factVenus2 =>
      'ਸੂਰਜ ਤੋਂ ਵੱਧ ਦੂਰ ਹੋਣ ਦੇ ਬਾਵਜੂਦ ਸ਼ੁੱਕਰ ਬੁੱਧ ਤੋਂ ਵੱਧ ਗਰਮ ਹੈ, ਕਿਉਂਕਿ ਉਸ ਦੀ ਸੰਘਣੀ ਹਵਾ ਗਰਮੀ ਨੂੰ ਰੋਕ ਲੈਂਦੀ ਹੈ।';

  @override
  String get factEarth1 =>
      'ਧਰਤੀ ਇਕੱਲੀ ਅਜਿਹੀ ਥਾਂ ਹੈ ਜਿੱਥੇ ਸਾਨੂੰ ਜੀਵਨ ਦਾ ਪਤਾ ਹੈ, ਅਤੇ ਉਸ ਦੀ ਸਤ੍ਹਾ ਦਾ ਲਗਭਗ 71% ਹਿੱਸਾ ਪਾਣੀ ਨਾਲ ਢਕਿਆ ਹੋਇਆ ਹੈ।';

  @override
  String get factEarth2 =>
      'ਧਰਤੀ ਪੂਰੀ ਤਰ੍ਹਾਂ ਗੋਲ ਨਹੀਂ ਹੈ। ਘੁੰਮਣ ਕਾਰਨ ਇਹ ਭੂਮੱਧ ਰੇਖਾ ਕੋਲ ਥੋੜ੍ਹੀ ਉੱਭਰੀ ਹੋਈ ਹੈ।';

  @override
  String get factMars1 =>
      'ਮੰਗਲ ਦਾ ਓਲੰਪਸ ਮੌਨਜ਼ ਸੂਰਜੀ ਮੰਡਲ ਦਾ ਸਭ ਤੋਂ ਉੱਚਾ ਜਵਾਲਾਮੁਖੀ ਹੈ, ਮਾਊਂਟ ਐਵਰੈਸਟ ਤੋਂ ਲਗਭਗ ਢਾਈ ਗੁਣਾ ਉੱਚਾ।';

  @override
  String get factMars2 => 'ਮੰਗਲ ਉੱਤੇ ਸੂਰਜ ਡੁੱਬਣਾ ਨੀਲਾ ਦਿਸਦਾ ਹੈ।';

  @override
  String get factJupiter1 =>
      'ਬ੍ਰਹਿਸਪਤੀ ਦਾ ਪੁੰਜ ਬਾਕੀ ਸਾਰੇ ਗ੍ਰਹਿਆਂ ਦੇ ਕੁੱਲ ਪੁੰਜ ਤੋਂ ਦੁੱਗਣੇ ਤੋਂ ਵੀ ਵੱਧ ਹੈ।';

  @override
  String get factJupiter2 =>
      'ਗ੍ਰੇਟ ਰੈੱਡ ਸਪੌਟ ਧਰਤੀ ਤੋਂ ਵੱਡਾ ਇੱਕ ਤੂਫ਼ਾਨ ਹੈ, ਜਿਸ ਨੂੰ ਲੋਕ 150 ਸਾਲ ਤੋਂ ਵੱਧ ਸਮੇਂ ਤੋਂ ਦੇਖ ਰਹੇ ਹਨ।';

  @override
  String get factSaturn1 =>
      'ਸ਼ਨੀ ਆਪਣੇ ਆਕਾਰ ਮੁਤਾਬਕ ਇੰਨਾ ਹਲਕਾ ਹੈ ਕਿ ਪਾਣੀ ਵਿੱਚ ਤੈਰ ਜਾਵੇ, ਜੇ ਇੰਨਾ ਵੱਡਾ ਟੱਬ ਮਿਲ ਜਾਵੇ।';

  @override
  String get factSaturn2 =>
      'ਸ਼ਨੀ ਦੇ ਛੱਲੇ ਬਹੁਤ ਚੌੜੇ ਪਰ ਬਹੁਤ ਪਤਲੇ ਹਨ: ਕਈ ਥਾਵਾਂ ਉੱਤੇ ਸਿਰਫ਼ ਲਗਭਗ ਦਸ ਮੀਟਰ ਮੋਟੇ।';

  @override
  String get factUranus1 =>
      'ਯੂਰੇਨਸ ਪਾਸੇ ਭਾਰ ਰੁੜ੍ਹਦਾ ਹੋਇਆ ਸੂਰਜ ਦੁਆਲੇ ਘੁੰਮਦਾ ਹੈ, ਉਸ ਦੀ ਧੁਰੀ ਲਗਭਗ 98 ਡਿਗਰੀ ਝੁਕੀ ਹੋਈ ਹੈ।';

  @override
  String get factUranus2 =>
      'ਯੂਰੇਨਸ ਦੂਰਬੀਨ ਨਾਲ ਲੱਭਿਆ ਗਿਆ ਪਹਿਲਾ ਗ੍ਰਹਿ ਸੀ। ਵਿਲੀਅਮ ਹਰਸ਼ਲ ਨੇ ਉਸ ਨੂੰ 1781 ਵਿੱਚ ਦੇਖਿਆ।';

  @override
  String get factNeptune1 =>
      'ਨੈਪਚਿਊਨ ਉੱਤੇ ਕਿਸੇ ਵੀ ਗ੍ਰਹਿ ਤੋਂ ਤੇਜ਼ ਹਵਾਵਾਂ ਚੱਲਦੀਆਂ ਹਨ, 2,000 ਕਿਮੀ/ਘੰਟਾ ਤੋਂ ਵੀ ਵੱਧ।';

  @override
  String get factNeptune2 =>
      'ਨੈਪਚਿਊਨ ਨੂੰ ਕਿਸੇ ਦੇ ਦੇਖਣ ਤੋਂ ਪਹਿਲਾਂ ਹੀ ਗਣਿਤ ਨਾਲ ਲੱਭਿਆ ਗਿਆ: 1846 ਵਿੱਚ ਖਗੋਲ-ਵਿਗਿਆਨੀਆਂ ਨੇ ਹਿਸਾਬ ਲਾਇਆ ਕਿ ਉਹ ਕਿੱਥੇ ਹੋਣਾ ਚਾਹੀਦਾ ਹੈ।';

  @override
  String get factMoon1 =>
      'ਚੰਦਰਮਾ ਹਰ ਸਾਲ ਧਰਤੀ ਤੋਂ ਲਗਭਗ 3.8 ਸੈਂਟੀਮੀਟਰ ਹੋਰ ਦੂਰ ਚਲਾ ਜਾਂਦਾ ਹੈ।';

  @override
  String get factMoon2 =>
      'ਸਾਨੂੰ ਚੰਦਰਮਾ ਦਾ ਹਮੇਸ਼ਾ ਇੱਕੋ ਪਾਸਾ ਦਿਸਦਾ ਹੈ, ਕਿਉਂਕਿ ਧਰਤੀ ਦੁਆਲੇ ਹਰ ਚੱਕਰ ਵਿੱਚ ਉਹ ਠੀਕ ਇੱਕ ਵਾਰ ਆਪਣੇ ਆਪ ਦੁਆਲੇ ਘੁੰਮਦਾ ਹੈ।';

  @override
  String get factPluto1 =>
      'ਪਲੂਟੋ ਉੱਤੇ ਇੱਕ ਸਾਲ ਲਗਭਗ 248 ਧਰਤੀ-ਸਾਲਾਂ ਦਾ ਹੁੰਦਾ ਹੈ।';

  @override
  String get factPluto2 =>
      'ਪਲੂਟੋ ਉੱਤੇ ਜੰਮੀ ਹੋਈ ਨਾਈਟ੍ਰੋਜਨ ਦਾ ਦਿਲ ਦੇ ਆਕਾਰ ਦਾ ਇੱਕ ਵਿਸ਼ਾਲ ਮੈਦਾਨ ਹੈ।';

  @override
  String get factIo1 =>
      'ਆਇਓ ਸਾਡੀ ਜਾਣੀ ਸਭ ਤੋਂ ਵੱਧ ਜਵਾਲਾਮੁਖੀਆਂ ਵਾਲੀ ਦੁਨੀਆ ਹੈ, ਜਿੱਥੇ ਸੈਂਕੜੇ ਸਰਗਰਮ ਜਵਾਲਾਮੁਖੀ ਹਨ।';

  @override
  String get factIo2 =>
      'ਬ੍ਰਹਿਸਪਤੀ ਦੀ ਗੁਰੂਤਾ ਆਇਓ ਨੂੰ ਦਬਾਉਂਦੀ ਅਤੇ ਖਿੱਚਦੀ ਹੈ, ਅਤੇ ਇਸ ਤੋਂ ਪੈਦਾ ਹੋਈ ਗਰਮੀ ਉਸ ਦੇ ਜਵਾਲਾਮੁਖੀਆਂ ਨੂੰ ਚਲਾਉਂਦੀ ਹੈ।';

  @override
  String get factEuropa1 =>
      'ਬਰਫ਼ੀਲੀ ਪਰਤ ਹੇਠਾਂ ਯੂਰੋਪਾ ਵਿੱਚ ਸ਼ਾਇਦ ਧਰਤੀ ਦੇ ਸਾਰੇ ਮਹਾਂਸਾਗਰਾਂ ਤੋਂ ਲਗਭਗ ਦੁੱਗਣਾ ਪਾਣੀ ਹੈ।';

  @override
  String get factEuropa2 =>
      'ਧਰਤੀ ਤੋਂ ਪਰੇ ਜੀਵਨ ਲੱਭਣ ਦੀਆਂ ਸਭ ਤੋਂ ਚੰਗੀਆਂ ਥਾਵਾਂ ਵਿੱਚੋਂ ਇੱਕ ਯੂਰੋਪਾ ਹੈ। ਯੂਰੋਪਾ ਕਲਿੱਪਰ ਯਾਨ ਉੱਥੇ ਜਾ ਰਿਹਾ ਹੈ।';

  @override
  String get factGanymede1 =>
      'ਗੈਨੀਮੀਡ ਸੂਰਜੀ ਮੰਡਲ ਦਾ ਸਭ ਤੋਂ ਵੱਡਾ ਚੰਦਰਮਾ ਹੈ। ਇਹ ਬੁੱਧ ਤੋਂ ਵੀ ਵੱਡਾ ਹੈ।';

  @override
  String get factGanymede2 =>
      'ਗੈਨੀਮੀਡ ਇਕੱਲਾ ਚੰਦਰਮਾ ਹੈ ਜਿਸ ਦਾ ਆਪਣਾ ਚੁੰਬਕੀ ਖੇਤਰ ਮਿਲਿਆ ਹੈ।';

  @override
  String get factCallisto1 =>
      'ਕੈਲਿਸਟੋ ਸੂਰਜੀ ਮੰਡਲ ਦੀਆਂ ਸਭ ਤੋਂ ਵੱਧ ਟੋਇਆਂ ਵਾਲੀਆਂ ਥਾਵਾਂ ਵਿੱਚੋਂ ਇੱਕ ਹੈ, ਅਤੇ ਉਸ ਦੀ ਸਤ੍ਹਾ ਬਹੁਤ ਪੁਰਾਣੀ ਹੈ।';

  @override
  String get factCallisto2 =>
      'ਕੈਲਿਸਟੋ ਬ੍ਰਹਿਸਪਤੀ ਤੋਂ ਇੰਨਾ ਦੂਰ ਹੈ ਕਿ ਉਸ ਨੂੰ ਉਸ ਦੀ ਤਿੱਖੀ ਵਿਕਿਰਣ ਘੱਟ ਮਿਲਦੀ ਹੈ, ਇਸ ਲਈ ਵਿਗਿਆਨੀਆਂ ਨੇ ਭਵਿੱਖ ਦੇ ਅੱਡੇ ਲਈ ਉਸ ਦਾ ਸੁਝਾਅ ਦਿੱਤਾ ਹੈ।';

  @override
  String get factTitan1 =>
      'ਟਾਈਟਨ ਇਕੱਲਾ ਚੰਦਰਮਾ ਹੈ ਜਿਸ ਦਾ ਵਾਯੂਮੰਡਲ ਸੰਘਣਾ ਹੈ। ਉਸ ਦੀ ਸਤ੍ਹਾ ਉੱਤੇ ਹਵਾ ਦਾ ਦਬਾਅ ਧਰਤੀ ਤੋਂ ਵੱਧ ਹੈ।';

  @override
  String get factTitan2 =>
      'ਟਾਈਟਨ ਉੱਤੇ ਨਦੀਆਂ ਅਤੇ ਝੀਲਾਂ ਹਨ, ਪਰ ਉਨ੍ਹਾਂ ਵਿੱਚ ਪਾਣੀ ਨਹੀਂ, ਤਰਲ ਮੀਥੇਨ ਅਤੇ ਈਥੇਨ ਹੈ।';

  @override
  String get factEnceladus1 =>
      'ਐਨਸੇਲਾਡਸ ਆਪਣੇ ਦੱਖਣੀ ਧਰੁਵ ਕੋਲ ਦੀਆਂ ਤਰੇੜਾਂ ਵਿੱਚੋਂ ਬਰਫ਼ ਅਤੇ ਪਾਣੀ ਦੀ ਭਾਫ਼ ਦੀਆਂ ਧਾਰਾਂ ਪੁਲਾੜ ਵਿੱਚ ਛੱਡਦਾ ਹੈ।';

  @override
  String get factEnceladus2 =>
      'ਐਨਸੇਲਾਡਸ ਦੀਆਂ ਇਹ ਧਾਰਾਂ ਸ਼ਨੀ ਦੇ E ਛੱਲੇ ਨੂੰ ਭਰਦੀਆਂ ਹਨ।';

  @override
  String get factTriton1 =>
      'ਟ੍ਰਾਈਟਨ ਨੈਪਚਿਊਨ ਦੁਆਲੇ ਉਲਟੀ ਦਿਸ਼ਾ ਵਿੱਚ ਘੁੰਮਦਾ ਹੈ, ਇਸ ਲਈ ਸ਼ਾਇਦ ਉਹ ਇੱਕ ਬੌਣਾ ਗ੍ਰਹਿ ਸੀ ਜਿਸ ਨੂੰ ਨੈਪਚਿਊਨ ਨੇ ਫੜ ਲਿਆ।';

  @override
  String get factTriton2 =>
      'ਲਗਭਗ −235 °C ਉੱਤੇ ਟ੍ਰਾਈਟਨ ਸੂਰਜੀ ਮੰਡਲ ਦੀਆਂ ਸਭ ਤੋਂ ਠੰਢੀਆਂ ਥਾਵਾਂ ਵਿੱਚੋਂ ਹੈ ਜਿੱਥੇ ਤਾਪਮਾਨ ਮਾਪਿਆ ਗਿਆ ਹੈ।';

  @override
  String get jumpInput => 'ਧਰਤੀ ਉੱਤੇ ਤੁਹਾਡੀ ਛਾਲ ਦੀ ਉਚਾਈ (ਸੈਮੀ)';

  @override
  String jumpHigh(String height) {
    return 'ਛਾਲ: $height';
  }

  @override
  String jumpFeelsLike(String height) {
    return 'ਧਰਤੀ ਉੱਤੇ $height ਦੀ ਛਾਲ ਇੱਥੇ ਬਣ ਜਾਂਦੀ ਹੈ';
  }

  @override
  String get jumpNote =>
      'ਧੱਕਾ ਉਹੀ ਰਹਿੰਦਾ ਹੈ ਜੋ ਧਰਤੀ ਉੱਤੇ ਹੁੰਦਾ ਹੈ। ਸੂਰਜ ਅਤੇ ਗੈਸ ਵਾਲੇ ਵਿਸ਼ਾਲ ਗ੍ਰਹਿਆਂ ਉੱਤੇ ਖੜ੍ਹਨ ਲਈ ਜ਼ਮੀਨ ਨਹੀਂ ਹੈ, ਇਸ ਲਈ ਇਹ ਸਿਰਫ਼ ਕਲਪਨਾ ਦੀ ਖੇਡ ਹੈ।';

  @override
  String valueCm(String value) {
    return '$value ਸੈਮੀ';
  }

  @override
  String valueM(String value) {
    return '$value ਮੀ';
  }

  @override
  String get eclipseTotalLunar => 'ਪੂਰਨ ਚੰਦਰ ਗ੍ਰਹਿਣ';

  @override
  String get eclipsePartialLunar => 'ਅੰਸ਼ਕ ਚੰਦਰ ਗ੍ਰਹਿਣ';

  @override
  String get eclipsePenumbralLunar => 'ਉਪਛਾਇਆ ਚੰਦਰ ਗ੍ਰਹਿਣ';

  @override
  String get eclipseTotalSolar => 'ਪੂਰਨ ਸੂਰਜ ਗ੍ਰਹਿਣ';

  @override
  String get eclipseAnnularSolar => 'ਕੰਗਣਾਕਾਰ ਸੂਰਜ ਗ੍ਰਹਿਣ';

  @override
  String get eclipseHybridSolar => 'ਸੰਕਰ ਸੂਰਜ ਗ੍ਰਹਿਣ';

  @override
  String get eclipsePartialSolar => 'ਅੰਸ਼ਕ ਸੂਰਜ ਗ੍ਰਹਿਣ';

  @override
  String get eclipseTotalLunarDesc =>
      'ਚੰਨ ਪੂਰੀ ਤਰ੍ਹਾਂ ਧਰਤੀ ਦੇ ਪਰਛਾਵੇਂ ਵਿੱਚ ਚਲਾ ਜਾਂਦਾ ਹੈ ਅਤੇ ਅਕਸਰ ਫਿੱਕਾ ਲਾਲ ਦਿਸਦਾ ਹੈ। ਧਰਤੀ ਦੇ ਰਾਤ ਵਾਲੇ ਪਾਸੇ ਸਾਰੇ ਇਸਨੂੰ ਦੇਖ ਸਕਦੇ ਹਨ, ਅਤੇ ਅੱਖਾਂ ਨਾਲ ਦੇਖਣਾ ਸੁਰੱਖਿਅਤ ਹੈ।';

  @override
  String eclipsePartialLunarDesc(String percent) {
    return 'ਚੰਨ ਦਾ ਇੱਕ ਹਿੱਸਾ (ਚੌੜਾਈ ਦਾ $percent%) ਧਰਤੀ ਦੇ ਗੂੜ੍ਹੇ ਪਰਛਾਵੇਂ ਵਿੱਚ ਜਾਂਦਾ ਹੈ। ਅੱਖਾਂ ਨਾਲ ਦੇਖਣਾ ਸੁਰੱਖਿਅਤ ਹੈ।';
  }

  @override
  String get eclipsePenumbralLunarDesc =>
      'ਚੰਨ ਧਰਤੀ ਦੇ ਹਲਕੇ ਬਾਹਰੀ ਪਰਛਾਵੇਂ ਵਿੱਚੋਂ ਲੰਘਦਾ ਹੈ। ਉਹ ਸਿਰਫ਼ ਥੋੜ੍ਹਾ ਮੱਧਮ ਹੁੰਦਾ ਹੈ, ਇਸ ਲਈ ਪਛਾਣਨਾ ਔਖਾ ਹੈ।';

  @override
  String get eclipseTotalSolarDesc =>
      'ਧਰਤੀ ਉੱਤੇ ਇੱਕ ਤੰਗ ਪੱਟੀ ਵਿੱਚ ਚੰਨ ਸੂਰਜ ਨੂੰ ਪੂਰੀ ਤਰ੍ਹਾਂ ਢੱਕ ਲੈਂਦਾ ਹੈ। ਉਸ ਪੱਟੀ ਤੋਂ ਬਾਹਰ ਅੰਸ਼ਕ ਗ੍ਰਹਿਣ ਦਿਸਦਾ ਹੈ।';

  @override
  String get eclipseAnnularSolarDesc =>
      'ਚੰਨ ਥੋੜ੍ਹਾ ਜ਼ਿਆਦਾ ਦੂਰ ਹੋਣ ਕਰਕੇ ਸੂਰਜ ਨੂੰ ਪੂਰਾ ਨਹੀਂ ਢੱਕ ਸਕਦਾ, ਤੇ ਇੱਕ ਚਮਕਦਾ ਛੱਲਾ ਬਚ ਜਾਂਦਾ ਹੈ। ਛੱਲਾ ਇੱਕ ਤੰਗ ਪੱਟੀ ਵਿੱਚ ਦਿਸਦਾ ਹੈ; ਉਸ ਤੋਂ ਬਾਹਰ ਗ੍ਰਹਿਣ ਅੰਸ਼ਕ ਹੁੰਦਾ ਹੈ।';

  @override
  String get eclipseHybridSolarDesc =>
      'ਆਪਣੀ ਪੱਟੀ ਵਿੱਚ ਇਹ ਗ੍ਰਹਿਣ ਕੁਝ ਥਾਵਾਂ ਉੱਤੇ ਪੂਰਨ ਅਤੇ ਕੁਝ ਥਾਵਾਂ ਉੱਤੇ ਛੱਲੇ ਵਰਗਾ ਦਿਸਦਾ ਹੈ। ਪੱਟੀ ਤੋਂ ਬਾਹਰ ਇਹ ਅੰਸ਼ਕ ਹੁੰਦਾ ਹੈ।';

  @override
  String get eclipsePartialSolarDesc =>
      'ਚੰਨ ਸੂਰਜ ਦੇ ਸਿਰਫ਼ ਇੱਕ ਹਿੱਸੇ ਨੂੰ ਢੱਕਦਾ ਹੈ, ਅਤੇ ਧਰਤੀ ਉੱਤੇ ਕਿਤੇ ਵੀ ਸੂਰਜ ਪੂਰਾ ਨਹੀਂ ਢੱਕਿਆ ਜਾਂਦਾ।';

  @override
  String get eclipseNoCity =>
      'Heliora ਵਿੱਚ ਇੱਕ ਸ਼ਹਿਰ ਚੁਣੋ, ਤਾਂ ਜੋ ਪਤਾ ਲੱਗੇ ਕਿ ਉੱਥੋਂ ਇਹ ਦਿਸੇਗਾ ਜਾਂ ਨਹੀਂ।';

  @override
  String eclipseLunarUp(String city) {
    return 'ਗ੍ਰਹਿਣ ਦੇ ਵਿਚਕਾਰ $city ਵਿੱਚ ਚੰਨ ਦਿਸਹੱਦੇ ਤੋਂ ਉੱਪਰ ਹੁੰਦਾ ਹੈ।';
  }

  @override
  String eclipseLunarPartly(String city) {
    return '$city ਵਿੱਚ ਚੰਨ ਗ੍ਰਹਿਣ ਦੇ ਸਿਰਫ਼ ਕੁਝ ਹਿੱਸੇ ਵਿੱਚ ਦਿਸਹੱਦੇ ਤੋਂ ਉੱਪਰ ਹੁੰਦਾ ਹੈ।';
  }

  @override
  String eclipseLunarDown(String city) {
    return '$city ਵਿੱਚ ਚੰਨ ਦਿਸਹੱਦੇ ਤੋਂ ਹੇਠਾਂ ਹੀ ਰਹਿੰਦਾ ਹੈ, ਇਸ ਲਈ ਉੱਥੋਂ ਨਹੀਂ ਦਿਸੇਗਾ।';
  }

  @override
  String eclipseSolarNone(String city) {
    return '$city ਤੋਂ ਨਹੀਂ ਦਿਸੇਗਾ: ਚੰਨ ਦਾ ਪਰਛਾਵਾਂ ਉੱਥੇ ਨਹੀਂ ਪਹੁੰਚਦਾ, ਜਾਂ ਸੂਰਜ ਦਿਸਹੱਦੇ ਤੋਂ ਹੇਠਾਂ ਹੁੰਦਾ ਹੈ।';
  }

  @override
  String eclipseSolarSlight(String city) {
    return '$city ਤੋਂ ਵੱਧ ਤੋਂ ਵੱਧ ਬਹੁਤ ਹਲਕਾ ਅੰਸ਼ਕ ਗ੍ਰਹਿਣ ਦਿਸੇਗਾ, ਜਿਸਨੂੰ ਪਛਾਣਨਾ ਔਖਾ ਹੈ।';
  }

  @override
  String eclipseSolarPartial(String city, String percent) {
    return '$city ਲਈ ਮੋਟਾ ਅੰਦਾਜ਼ਾ: ਚੰਨ ਵੱਧ ਤੋਂ ਵੱਧ ਸੂਰਜ ਦੀ ਚੌੜਾਈ ਦਾ ਲਗਭਗ $percent% ਢੱਕਦਾ ਹੈ।';
  }

  @override
  String eclipseSolarNear(String city) {
    return '$city ਉਸ ਪੱਟੀ ਦੇ ਨੇੜੇ ਹੈ ਜਿੱਥੇ ਸੂਰਜ ਲਗਭਗ ਜਾਂ ਪੂਰਾ ਢੱਕਿਆ ਜਾਂਦਾ ਹੈ। ਗ੍ਰਹਿਣ ਦਾ ਨਕਸ਼ਾ ਦੇਖੋ; ਇਹ ਅੰਦਾਜ਼ਾ ਮੋਟਾ ਹੈ।';
  }

  @override
  String get eclipseSolarSafety =>
      'ਸਹੀ ਗ੍ਰਹਿਣ-ਐਨਕਾਂ ਤੋਂ ਬਿਨਾਂ ਕਦੇ ਵੀ ਸੂਰਜ ਵੱਲ ਨਾ ਦੇਖੋ।';

  @override
  String get alertsTitle => 'ਅਲਰਟ';

  @override
  String get tonightAlertSwitch => 'ਹਰ ਸ਼ਾਮ ਅੱਜ ਰਾਤ ਦਾ ਆਸਮਾਨ';

  @override
  String get tonightAlertTime => 'ਸਮਾਂ';

  @override
  String get tonightAlertNote =>
      'ਤੁਹਾਡੇ ਚੁਣੇ ਸਮੇਂ ਉੱਤੇ ਚੰਨ ਅਤੇ ਦਿਸਣ ਵਾਲੇ ਗ੍ਰਹਿਆਂ ਬਾਰੇ ਇੱਕ ਛੋਟਾ ਸੁਨੇਹਾ। ਇਹ ਤੁਹਾਡੇ ਫ਼ੋਨ ਉੱਤੇ ਹੀ ਬਣਦਾ ਹੈ, ਇੰਟਰਨੈੱਟ ਨਹੀਂ ਚਾਹੀਦਾ। Android Heliora ਨੂੰ ਪਹਿਲਾਂ ਤੋਂ ਸਿਰਫ਼ ਲਗਭਗ ਦੋ ਹਫ਼ਤਿਆਂ ਦੇ ਸੁਨੇਹੇ ਤਿਆਰ ਕਰਨ ਦਿੰਦਾ ਹੈ, ਇਸ ਲਈ ਐਪ ਵਿਚ-ਵਿਚਾਲੇ ਖੋਲ੍ਹਦੇ ਰਹੋ।';

  @override
  String get tonightNotifTitle => 'ਅੱਜ ਰਾਤ ਦਾ ਆਸਮਾਨ';

  @override
  String tonightMoon(String phase, String percent) {
    return 'ਚੰਨ: $phase, $percent% ਰੌਸ਼ਨ।';
  }

  @override
  String tonightPlanets(String planets) {
    return 'ਲੱਭੋ: $planets।';
  }

  @override
  String get tonightNoPlanets => 'ਸ਼ਾਮ ਦੇ ਆਸਮਾਨ ਵਿੱਚ ਕੋਈ ਚਮਕਦਾਰ ਗ੍ਰਹਿ ਨਹੀਂ।';

  @override
  String get tonightNoCity => 'ਗ੍ਰਹਿ ਦੇਖਣ ਲਈ Heliora ਵਿੱਚ ਸ਼ਹਿਰ ਚੁਣੋ।';

  @override
  String get birthdayTitle => 'ਮੇਰੇ ਜਨਮਦਿਨ ਦਾ ਆਸਮਾਨ';

  @override
  String get birthdaySubtitle =>
      'ਜਿਸ ਦਿਨ ਤੁਸੀਂ ਜੰਮੇ, ਉਸ ਦਿਨ ਚੰਨ ਅਤੇ ਗ੍ਰਹਿ ਕਿੱਥੇ ਸਨ, ਅਤੇ ਤੁਹਾਡੀ ਜ਼ਿੰਦਗੀ ਦੇ ਖ਼ਾਸ ਦਿਨ।';

  @override
  String get birthdayCardHint => 'ਚੰਨ ਦੀ ਕਲਾ, ਗ੍ਰਹਿ ਅਤੇ ਪੜਾਅ';

  @override
  String get birthdayNeedDate => 'ਆਪਣੀ ਜਨਮ ਤਾਰੀਖ਼ ਪਾਓ';

  @override
  String get birthdayMoon => 'ਤੁਹਾਡੇ ਜਨਮਦਿਨ ਉੱਤੇ ਚੰਨ';

  @override
  String get birthdayPlanets => 'ਉਸ ਦਿਨ ਗ੍ਰਹਿ';

  @override
  String birthdayDaysOld(String count) {
    return 'ਅੱਜ ਤੁਸੀਂ $count ਦਿਨਾਂ ਦੇ ਹੋ।';
  }

  @override
  String get birthdayMilestones => 'ਪੜਾਅ';

  @override
  String birthdayDayN(String count) {
    return 'ਦਿਨ $count';
  }

  @override
  String get birthdayBillion => '100 ਕਰੋੜ ਸਕਿੰਟਾਂ ਦੇ';

  @override
  String get birthdayPassed => 'ਹੋ ਚੁੱਕਾ';

  @override
  String get birthdayNote =>
      'Heliora ਦੀਆਂ ਬਾਕੀ ਚੀਜ਼ਾਂ ਵਾਂਗ ਉਹੀ ਪੰਧਾਂ ਤੋਂ ਤੁਹਾਡੇ ਫ਼ੋਨ ਉੱਤੇ ਹੀ ਹਿਸਾਬ ਲਾਇਆ ਜਾਂਦਾ ਹੈ। ਤੁਹਾਡੀ ਜਨਮ ਤਾਰੀਖ਼ ਫ਼ੋਨ ਤੋਂ ਬਾਹਰ ਨਹੀਂ ਜਾਂਦੀ।';

  @override
  String get missionsTitle => 'ਪੁਲਾੜ ਮਿਸ਼ਨ';

  @override
  String get missionsSubtitle =>
      'ਪੁਲਾੜ ਦੀ ਖੋਜ ਦੇ ਮਸ਼ਹੂਰ ਪਲ, ਸਭ ਤੋਂ ਪੁਰਾਣਾ ਪਹਿਲਾਂ।';

  @override
  String get missionsCardHint => 'ਸਮੇਂ ਦੇ ਨਾਲ ਮਸ਼ਹੂਰ ਮਿਸ਼ਨ';

  @override
  String get missionSputnik1 =>
      'ਪਹਿਲਾ ਨਕਲੀ ਉਪਗ੍ਰਹਿ। ਬੀਚ ਬਾਲ ਜਿੱਡਾ ਇਹ ਧਾਤ ਦਾ ਗੋਲਾ ਲਗਭਗ ਤਿੰਨ ਮਹੀਨੇ ਧਰਤੀ ਦੁਆਲੇ ਘੁੰਮਦਾ ਰਿਹਾ। ਇਸਦੀ ਬੀਪ ਰੇਡੀਓ ਉੱਤੇ ਸੁਣੀ ਜਾ ਸਕਦੀ ਸੀ, ਅਤੇ ਇੱਥੋਂ ਹੀ ਪੁਲਾੜ ਯੁੱਗ ਸ਼ੁਰੂ ਹੋਇਆ।';

  @override
  String get missionVostok1 =>
      'ਯੂਰੀ ਗਾਗਾਰਿਨ ਪੁਲਾੜ ਵਿੱਚ ਜਾਣ ਵਾਲੇ ਪਹਿਲੇ ਇਨਸਾਨ ਬਣੇ। ਉਨ੍ਹਾਂ ਨੇ ਲਗਭਗ 108 ਮਿੰਟਾਂ ਵਿੱਚ ਧਰਤੀ ਦਾ ਇੱਕ ਚੱਕਰ ਲਾਇਆ।';

  @override
  String get missionApollo11 =>
      'ਨੀਲ ਆਰਮਸਟ੍ਰਾਂਗ ਅਤੇ ਬਜ਼ ਓਲਡ੍ਰਿਨ ਸ਼ਾਂਤੀ ਦੇ ਸਾਗਰ ਵਿੱਚ ਉਤਰੇ ਅਤੇ ਚੰਨ ਉੱਤੇ ਤੁਰਨ ਵਾਲੇ ਪਹਿਲੇ ਇਨਸਾਨ ਬਣੇ। ਮਾਈਕਲ ਕਾਲਿਨਜ਼ ਪੰਧ ਵਿੱਚ ਉਨ੍ਹਾਂ ਦੀ ਉਡੀਕ ਕਰਦੇ ਰਹੇ।';

  @override
  String get missionVenera7 =>
      'ਕਿਸੇ ਹੋਰ ਗ੍ਰਹਿ ਉੱਤੇ ਉਤਰ ਕੇ ਸੰਕੇਤ ਭੇਜਣ ਵਾਲਾ ਪਹਿਲਾ ਯਾਨ। ਇਸਨੇ ਸ਼ੁੱਕਰ ਦੀ ਕੁਚਲ ਦੇਣ ਵਾਲੀ ਗਰਮੀ ਵਿੱਚ ਲਗਭਗ 23 ਮਿੰਟ ਡਾਟਾ ਭੇਜਿਆ।';

  @override
  String get missionViking1 =>
      'ਇਹ ਮੰਗਲ ਉੱਤੇ ਉਤਰਿਆ ਅਤੇ ਛੇ ਸਾਲ ਤੋਂ ਵੱਧ ਕੰਮ ਕਰਦਾ ਰਿਹਾ। ਇਸਨੇ ਕਿਸੇ ਹੋਰ ਗ੍ਰਹਿ ਦੀ ਸਤ੍ਹਾ ਤੋਂ ਤਸਵੀਰਾਂ ਅਤੇ ਮੌਸਮ ਦੀਆਂ ਰਿਪੋਰਟਾਂ ਦੀ ਪਹਿਲੀ ਲੰਮੀ ਲੜੀ ਭੇਜੀ।';

  @override
  String get missionVoyager1 =>
      '1977 ਵਿੱਚ ਛੱਡਿਆ ਗਿਆ, ਇਹ ਬ੍ਰਹਿਸਪਤੀ ਅਤੇ ਸ਼ਨੀ ਕੋਲੋਂ ਲੰਘਿਆ ਅਤੇ 2012 ਵਿੱਚ ਤਾਰਿਆਂ ਵਿਚਕਾਰਲੇ ਪੁਲਾੜ ਵਿੱਚ ਪਹੁੰਚਿਆ। ਧਰਤੀ ਤੋਂ ਸਭ ਤੋਂ ਦੂਰ ਇਨਸਾਨ ਦੀ ਬਣਾਈ ਚੀਜ਼ ਇਹੀ ਹੈ।';

  @override
  String get missionHubble =>
      '1990 ਵਿੱਚ ਛੱਡਿਆ ਗਿਆ, ਇਹ ਧਰਤੀ ਦੀ ਹਵਾ ਤੋਂ ਉੱਪਰੋਂ ਬ੍ਰਹਿਮੰਡ ਨੂੰ ਦੇਖਦਾ ਹੈ। ਇਸਦੀਆਂ ਸਾਫ਼ ਤਸਵੀਰਾਂ ਨੇ ਬ੍ਰਹਿਮੰਡ ਦੀ ਉਮਰ ਮਾਪਣ ਵਿੱਚ ਮਦਦ ਕੀਤੀ ਅਤੇ ਹਜ਼ਾਰਾਂ ਦੂਰ ਦੀਆਂ ਆਕਾਸ਼ਗੰਗਾਵਾਂ ਦਿਖਾਈਆਂ।';

  @override
  String get missionHuygens =>
      'ਕੈਸੀਨੀ ਨਾਲ ਗਿਆ ਯਾਨ ਹਾਈਗਨਜ਼ ਪੈਰਾਸ਼ੂਟ ਨਾਲ ਸ਼ਨੀ ਦੇ ਚੰਨ ਟਾਈਟਨ ਉੱਤੇ ਉਤਰਿਆ। ਬਾਹਰੀ ਸੂਰਜ ਮੰਡਲ ਵਿੱਚ ਇਹ ਪਹਿਲਾ ਉਤਰਨਾ ਸੀ, ਅਤੇ ਇਸਨੇ ਸਤ੍ਹਾ ਤੋਂ ਤਸਵੀਰਾਂ ਭੇਜੀਆਂ।';

  @override
  String get missionCuriosity =>
      'ਕਾਰ ਜਿੱਡਾ ਇਹ ਰੋਵਰ ਰਾਕੇਟ ਨਾਲ ਚੱਲਣ ਵਾਲੀ ’ਸਕਾਈ ਕਰੇਨ’ ਦੀ ਮਦਦ ਨਾਲ ਗੇਲ ਕ੍ਰੇਟਰ ਵਿੱਚ ਉਤਰਿਆ। ਇਸਨੇ ਪਤਾ ਲਾਇਆ ਕਿ ਮੰਗਲ ਉੱਤੇ ਕਦੇ ਜੀਵਨ ਲਈ ਠੀਕ ਹਾਲਾਤ ਸਨ।';

  @override
  String get missionMangalyaan =>
      'ਭਾਰਤ ਦਾ ਮਾਰਸ ਆਰਬਿਟਰ ਮਿਸ਼ਨ ਪਹਿਲੀ ਹੀ ਕੋਸ਼ਿਸ਼ ਵਿੱਚ ਮੰਗਲ ਦੇ ਪੰਧ ਵਿੱਚ ਪਹੁੰਚ ਗਿਆ। ਕਿਸੇ ਵੀ ਦੇਸ਼ ਲਈ ਇਹ ਪਹਿਲੀ ਵਾਰ ਸੀ, ਅਤੇ ਖ਼ਰਚਾ ਵੀ ਬਹੁਤ ਘੱਟ।';

  @override
  String get missionRosetta =>
      'ਰੋਜ਼ੇਟਾ ਦੇ ਲੈਂਡਰ ਫ਼ਾਈਲੀ ਨੇ ਧੂਮਕੇਤੂ 67P/ਚੁਰਯੂਮੋਵ–ਗੇਰਾਸਿਮੇਂਕੋ ਉੱਤੇ ਉਤਰ ਕੇ ਧੂਮਕੇਤੂ ਉੱਤੇ ਪਹਿਲਾ ਉਤਰਨਾ ਕੀਤਾ। ਰੋਜ਼ੇਟਾ ਆਪ ਦੋ ਸਾਲ ਧੂਮਕੇਤੂ ਦੁਆਲੇ ਘੁੰਮਦਾ ਰਿਹਾ।';

  @override
  String get missionNewhorizons =>
      'ਨੌਂ ਸਾਲਾਂ ਦੇ ਸਫ਼ਰ ਮਗਰੋਂ ਇਹ ਪਲੂਟੋ ਕੋਲੋਂ ਲੰਘਿਆ ਅਤੇ ਪਹਿਲੀ ਵਾਰ ਸਾਨੂੰ ਬਰਫ਼ੀਲੇ ਪਹਾੜ ਅਤੇ ਦਿਲ ਦੀ ਸ਼ਕਲ ਦਾ ਵੱਡਾ ਮੈਦਾਨ ਦਿਖਾਇਆ।';

  @override
  String get missionPerseverance =>
      'ਪਰਸੀਵਰੈਂਸ ਰੋਵਰ ਪੁਰਾਣੇ ਜੀਵਨ ਦੇ ਨਿਸ਼ਾਨ ਲੱਭਣ ਅਤੇ ਚੱਟਾਨਾਂ ਦੇ ਨਮੂਨੇ ਇਕੱਠੇ ਕਰਨ ਲਈ ਜੇਜ਼ੇਰੋ ਕ੍ਰੇਟਰ ਵਿੱਚ ਉਤਰਿਆ। ਇਸਦੇ ਹੈਲੀਕਾਪਟਰ ਇੰਜੀਨਿਊਟੀ ਨੇ ਕਿਸੇ ਹੋਰ ਗ੍ਰਹਿ ਉੱਤੇ ਪਹਿਲੀ ਚਲਾਈ ਹੋਈ ਉਡਾਣ ਭਰੀ।';

  @override
  String get missionJwst =>
      'ਸਭ ਤੋਂ ਵੱਡੀ ਪੁਲਾੜ ਦੂਰਬੀਨ ਵਿੱਚ 6.5 ਮੀਟਰ ਦਾ ਸੁਨਹਿਰੀ ਸ਼ੀਸ਼ਾ ਹੈ, ਅਤੇ ਇਹ 15 ਲੱਖ ਕਿਲੋਮੀਟਰ ਦੂਰੋਂ ਇਨਫ਼ਰਾਰੈੱਡ ਰੌਸ਼ਨੀ ਵਿੱਚ ਆਸਮਾਨ ਦੇਖਦੀ ਹੈ। ਇਹ ਸਭ ਤੋਂ ਪਹਿਲੀਆਂ ਆਕਾਸ਼ਗੰਗਾਵਾਂ ਵਿੱਚੋਂ ਕੁਝ ਦੇਖ ਸਕਦੀ ਹੈ।';

  @override
  String get missionChandrayaan3 =>
      'ਭਾਰਤ ਚੰਨ ਉੱਤੇ ਸੁਰੱਖਿਅਤ ਉਤਰਨ ਵਾਲਾ ਚੌਥਾ ਦੇਸ਼ ਬਣਿਆ, ਅਤੇ ਦੱਖਣੀ ਧਰੁਵ ਦੇ ਨੇੜੇ ਉਤਰਨ ਵਾਲਾ ਪਹਿਲਾ। ਵਿਕਰਮ ਲੈਂਡਰ ਆਪਣੇ ਨਾਲ ਪ੍ਰਗਿਆਨ ਰੋਵਰ ਲੈ ਗਿਆ ਸੀ।';

  @override
  String get spacecraftTitle => 'ਪੁਲਾੜ ਯਾਨ ਹੁਣ';

  @override
  String get spacecraftSubtitle =>
      'ਕੁਝ ਮਸ਼ਹੂਰ ਪੁਲਾੜ ਯਾਨ ਇਸ ਵੇਲੇ ਧਰਤੀ ਤੋਂ ਕਿੰਨੇ ਦੂਰ ਹਨ।';

  @override
  String get spacecraftCardHint => 'ਵੋਇਜਰ, JWST, ਮੰਗਲ ਦੇ ਰੋਵਰ ਅਤੇ ਹੋਰ ਬਹੁਤ ਕੁਝ';

  @override
  String get spacecraftDistance => 'ਧਰਤੀ ਤੋਂ ਦੂਰੀ';

  @override
  String get spacecraftAltitude => 'ਧਰਤੀ ਤੋਂ ਉਚਾਈ';

  @override
  String get spacecraftInAu => 'ਖਗੋਲੀ ਇਕਾਈ ਵਿੱਚ';

  @override
  String get spacecraftSpeed => 'ਰਫ਼ਤਾਰ';

  @override
  String get spacecraftSignal => 'ਰੇਡੀਓ ਸੰਕੇਤ ਨੂੰ ਲੱਗਦਾ ਹੈ';

  @override
  String get spacecraftNote =>
      'ਦੂਰੀਆਂ ਅੰਦਾਜ਼ੇ ਹਨ। ਦੂਰ ਦੇ ਯਾਨਾਂ ਲਈ ਇਹ ਔਸਤ ਰਫ਼ਤਾਰ ਤੋਂ ਕੱਢੀਆਂ ਗਈਆਂ ਹਨ ਅਤੇ ਧਰਤੀ ਦੇ ਸੂਰਜ ਦੁਆਲੇ ਘੁੰਮਣ ਕਰਕੇ ਲਗਭਗ 1% ਤੱਕ ਗਲਤ ਹੋ ਸਕਦੀਆਂ ਹਨ। ਮੰਗਲ ਦੀ ਦੂਰੀ ਅੱਜ ਲਈ ਗਿਣੀ ਗਈ ਹੈ। ਇੱਕ AU (ਖਗੋਲੀ ਇਕਾਈ) ਧਰਤੀ ਤੋਂ ਸੂਰਜ ਦੀ ਦੂਰੀ ਹੈ।';

  @override
  String valueBillionKm(String value) {
    return '$value ਅਰਬ ਕਿਮੀ';
  }

  @override
  String valueAu(String value) {
    return '$value AU';
  }

  @override
  String valueKmS(String value) {
    return '$value ਕਿਮੀ/ਸਕਿੰਟ';
  }

  @override
  String get spacecraftVoyager1 =>
      '1977 ਵਿੱਚ ਛੱਡਿਆ ਗਿਆ। 2012 ਵਿੱਚ ਇਹ ਤਾਰਿਆਂ ਵਿਚਕਾਰਲੇ ਪੁਲਾੜ ਵਿੱਚ ਪਹੁੰਚਣ ਵਾਲਾ ਪਹਿਲਾ ਯਾਨ ਬਣਿਆ। ਇਸ ਦਾ ਰੇਡੀਓ ਸੰਕੇਤ ਸਾਡੇ ਤੱਕ ਪਹੁੰਚਦਿਆਂ ਲਗਭਗ ਇੱਕ ਦਿਨ ਪੁਰਾਣਾ ਹੋ ਚੁੱਕਾ ਹੁੰਦਾ ਹੈ।';

  @override
  String get spacecraftVoyager2 =>
      '1977 ਵਿੱਚ ਛੱਡਿਆ ਗਿਆ। ਇਹ ਇਕੱਲਾ ਯਾਨ ਹੈ ਜੋ ਯੂਰੇਨਸ ਅਤੇ ਨੈਪਚਿਊਨ ਤੱਕ ਗਿਆ, ਅਤੇ 2018 ਵਿੱਚ ਤਾਰਿਆਂ ਵਿਚਕਾਰਲੇ ਪੁਲਾੜ ਵਿੱਚ ਪਹੁੰਚਿਆ।';

  @override
  String get spacecraftNewHorizons =>
      '2015 ਵਿੱਚ ਪਲੂਟੋ ਕੋਲੋਂ ਅਤੇ 2019 ਵਿੱਚ ਕੁਇਪਰ ਪੱਟੀ ਦੀ ਵਸਤੂ ਅਰੋਕੋਥ ਕੋਲੋਂ ਲੰਘਿਆ। ਇਹ ਹਾਲੇ ਵੀ ਬਾਹਰ ਵੱਲ ਵਧ ਰਿਹਾ ਹੈ ਅਤੇ ਹਾਲੇ ਵੀ ਡੇਟਾ ਭੇਜ ਰਿਹਾ ਹੈ।';

  @override
  String get spacecraftJwst =>
      'ਸਭ ਤੋਂ ਵੱਡੀ ਪੁਲਾੜ ਦੂਰਬੀਨ, 2021 ਵਿੱਚ ਛੱਡੀ ਗਈ। ਇਹ L2 ਨਾਂ ਦੇ ਬਿੰਦੂ ਕੋਲ, ਧਰਤੀ ਤੋਂ ਲਗਭਗ 15 ਲੱਖ ਕਿਮੀ ਦੂਰ ਹੈ, ਅਤੇ ਇਸ ਦੀ ਸੂਰਜ-ਢਾਲ ਹਮੇਸ਼ਾ ਸੂਰਜ ਵੱਲ ਰਹਿੰਦੀ ਹੈ।';

  @override
  String get spacecraftIss =>
      'ਲਗਭਗ ਹਰ 90 ਮਿੰਟ ਵਿੱਚ ਧਰਤੀ ਦਾ ਇੱਕ ਚੱਕਰ ਲਾਉਂਦਾ ਹੈ। 2000 ਤੋਂ ਇਸ ਵਿੱਚ ਲੋਕ ਬਿਨਾਂ ਰੁਕੇ ਰਹਿ ਰਹੇ ਹਨ।';

  @override
  String get spacecraftHubble =>
      '1990 ਵਿੱਚ ਛੱਡਿਆ ਗਿਆ ਅਤੇ ਹਾਲੇ ਵੀ ਕੰਮ ਕਰ ਰਿਹਾ ਹੈ। ਇਹ ਤਸਵੀਰਾਂ ਧੁੰਦਲੀਆਂ ਕਰਨ ਵਾਲੀ ਹਵਾ ਤੋਂ ਉੱਪਰ ਧਰਤੀ ਦੁਆਲੇ ਘੁੰਮਦਾ ਹੈ, ਇਸ ਲਈ ਇਸ ਦੀਆਂ ਤਸਵੀਰਾਂ ਬਹੁਤ ਸਾਫ਼ ਹੁੰਦੀਆਂ ਹਨ।';

  @override
  String get spacecraftMarsRovers =>
      'ਕਿਊਰੀਓਸਿਟੀ (2012 ਵਿੱਚ ਉਤਰਿਆ) ਅਤੇ ਪਰਸੀਵਰੈਂਸ (2021 ਵਿੱਚ ਉਤਰਿਆ) ਮੰਗਲ ਉੱਤੇ ਚੱਲ ਰਹੇ ਹਨ। ਮੰਗਲ ਦੀ ਦੂਰੀ ਲਗਭਗ 5.5 ਕਰੋੜ ਕਿਮੀ ਤੋਂ ਬਦਲ ਕੇ 40 ਕਰੋੜ ਕਿਮੀ ਤੋਂ ਵੀ ਵੱਧ ਹੋ ਜਾਂਦੀ ਹੈ।';

  @override
  String get searchTooltip => 'ਖੋਜੋ';

  @override
  String get searchHint => 'ਗ੍ਰਹਿ, ਚੰਦਰਮਾ, ਮਿਸ਼ਨ ਖੋਜੋ…';

  @override
  String get searchClear => 'ਮਿਟਾਓ';

  @override
  String searchEmpty(String query) {
    return '“$query” ਲਈ ਕੁਝ ਨਹੀਂ ਮਿਲਿਆ।';
  }

  @override
  String get searchBodies => 'ਗ੍ਰਹਿ ਅਤੇ ਚੰਦਰਮਾ';

  @override
  String get searchMissions => 'ਮਿਸ਼ਨ';

  @override
  String get searchSpacecraft => 'ਪੁਲਾੜ ਯਾਨ';

  @override
  String get favoritesTitle => 'ਪਸੰਦੀਦਾ';

  @override
  String get favoritesEmpty =>
      'ਕਿਸੇ ਗ੍ਰਹਿ, ਮਿਸ਼ਨ ਜਾਂ ਪੁਲਾੜ ਯਾਨ ਉੱਤੇ ਤਾਰੇ ਨੂੰ ਦਬਾਓ, ਉਹ ਇੱਥੇ ਰਹੇਗਾ।';

  @override
  String get favoriteAdd => 'ਪਸੰਦੀਦਾ ਵਿੱਚ ਜੋੜੋ';

  @override
  String get favoriteRemove => 'ਪਸੰਦੀਦਾ ਵਿੱਚੋਂ ਹਟਾਓ';

  @override
  String get textSize => 'ਅੱਖਰਾਂ ਦਾ ਆਕਾਰ';

  @override
  String get textSizeNormal => 'ਆਮ';

  @override
  String get textSizeLarge => 'ਵੱਡਾ';

  @override
  String get textSizeLarger => 'ਹੋਰ ਵੱਡਾ';

  @override
  String get textSizeNote =>
      'Heliora ਦੇ ਅੱਖਰ ਵੱਡੇ ਕਰਦਾ ਹੈ। ਇਹ ਤੁਹਾਡੇ ਫ਼ੋਨ ਦੇ ਆਪਣੇ ਅੱਖਰ-ਆਕਾਰ ਤੋਂ ਕਦੇ ਛੋਟਾ ਨਹੀਂ ਹੁੰਦਾ।';

  @override
  String get skyOtherNight => 'ਰਾਤ ਦਾ ਅਸਮਾਨ';

  @override
  String get planetsThatNight => 'ਉਸ ਰਾਤ ਦੇ ਗ੍ਰਹਿ';

  @override
  String get previousDay => 'ਪਿਛਲਾ ਦਿਨ';

  @override
  String get nextDay => 'ਅਗਲਾ ਦਿਨ';

  @override
  String get pickDate => 'ਤਾਰੀਖ਼ ਚੁਣੋ';

  @override
  String get backToTonight => 'ਅੱਜ ਰਾਤ ਲਈ ਵਾਪਸ';

  @override
  String get moonCalendar => 'ਚੰਦਰ ਕੈਲੰਡਰ';

  @override
  String get moonCalendarHint => 'ਹਰ ਦਿਨ ਚੰਦਰਮਾ ਦੀ ਕਲਾ';

  @override
  String get previousMonth => 'ਪਿਛਲਾ ਮਹੀਨਾ';

  @override
  String get nextMonth => 'ਅਗਲਾ ਮਹੀਨਾ';

  @override
  String get keyMoonDates => 'ਇਸ ਮਹੀਨੇ ਦੀਆਂ ਮੁੱਖ ਕਲਾਵਾਂ';

  @override
  String get moonCalendarNote =>
      'ਕਲਾਵਾਂ ਦੀਆਂ ਤਾਰੀਖ਼ਾਂ ਅਤੇ ਸਮਾਂ ਤੁਹਾਡੇ ਫ਼ੋਨ ਦੇ ਸਮਾਂ ਖੇਤਰ ਵਿੱਚ ਦਿਖਾਏ ਗਏ ਹਨ ਅਤੇ ਲਗਭਗ ਇੱਕ ਘੰਟੇ ਦੇ ਅੰਦਰ ਸਹੀ ਹਨ।';

  @override
  String get seeSkyThatDay => 'ਇਸ ਦਿਨ ਦਾ ਅਸਮਾਨ ਵੇਖੋ';

  @override
  String get sunLightTitle => 'ਸੂਰਜ ਅਤੇ ਰੌਸ਼ਨੀ';

  @override
  String get firstLight => 'ਪਹਿਲੀ ਰੌਸ਼ਨੀ';

  @override
  String get goldenMorningEnds => 'ਸਵੇਰ ਦਾ ਸੁਨਹਿਰੀ ਸਮਾਂ ਖ਼ਤਮ';

  @override
  String get solarNoon => 'ਸੂਰਜ ਸਭ ਤੋਂ ਉੱਚਾ';

  @override
  String get goldenEveningStarts => 'ਸ਼ਾਮ ਦਾ ਸੁਨਹਿਰੀ ਸਮਾਂ ਸ਼ੁਰੂ';

  @override
  String get lastLight => 'ਆਖ਼ਰੀ ਰੌਸ਼ਨੀ';

  @override
  String get darkSky => 'ਪੂਰੀ ਤਰ੍ਹਾਂ ਹਨੇਰਾ ਅਸਮਾਨ';

  @override
  String get sunDayLength => 'ਦਿਨ ਦੀ ਲੰਬਾਈ';

  @override
  String durationHm(String hours, String minutes) {
    return '$hours ਘੰਟੇ $minutes ਮਿੰਟ';
  }

  @override
  String get sunNote =>
      'ਸੁਨਹਿਰੀ ਸਮਾਂ ਉਹ ਹੈ ਜਦੋਂ ਸੂਰਜ ਦੂਰੀ ਤੋਂ 6° ਤੋਂ ਘੱਟ ਉੱਚਾ ਹੋਵੇ। ਪਹਿਲੀ ਅਤੇ ਆਖ਼ਰੀ ਰੌਸ਼ਨੀ ਉਦੋਂ ਹੁੰਦੀ ਹੈ ਜਦੋਂ ਉਹ 6° ਹੇਠਾਂ ਹੋਵੇ, ਅਤੇ ਅਸਮਾਨ ਪੂਰੀ ਤਰ੍ਹਾਂ ਹਨੇਰਾ ਉਦੋਂ ਹੁੰਦਾ ਹੈ ਜਦੋਂ ਉਹ 18° ਹੇਠਾਂ ਹੋਵੇ। ਸਮੇਂ ਤੁਹਾਡੀ ਚੁਣੀ ਤਾਰੀਖ਼ ਲਈ ਕੱਢੇ ਗਏ ਹਨ।';

  @override
  String get sunStaysUp => 'ਇਸ ਦਿਨ ਸੂਰਜ ਨਹੀਂ ਛਿਪਦਾ।';

  @override
  String get sunStaysDown => 'ਇਸ ਦਿਨ ਸੂਰਜ ਨਹੀਂ ਚੜ੍ਹਦਾ।';

  @override
  String get solarSystemTitle => 'ਸੌਰ ਮੰਡਲ';

  @override
  String get starMapTitle => 'ਤਾਰਿਆਂ ਦਾ ਨਕਸ਼ਾ';

  @override
  String get starMapCardHint => 'ਤੁਹਾਡੇ ਅਸਮਾਨ ਦੇ ਤਾਰੇ ਅਤੇ ਤਾਰਾਮੰਡਲ';

  @override
  String get starMapHint =>
      'ਆਲੇ-ਦੁਆਲੇ ਦੇਖਣ ਲਈ ਖਿੱਚੋ, ਜ਼ੂਮ ਕਰਨ ਲਈ ਦੋ ਉਂਗਲਾਂ ਨਾਲ ਫੈਲਾਓ, ਕਿਸੇ ਤਾਰੇ ਜਾਂ ਤਾਰਾਮੰਡਲ ’ਤੇ ਟੈਪ ਕਰੋ।';

  @override
  String get starsLabel => 'ਤਾਰੇ';

  @override
  String get constellationsLabel => 'ਤਾਰਾਮੰਡਲ';

  @override
  String get starMapFind => 'ਲੱਭੋ';

  @override
  String get constellationsList => 'ਸਾਰੇ ਤਾਰਾਮੰਡਲ';

  @override
  String magnitudeValue(String value) {
    return 'ਚਮਕ $value';
  }

  @override
  String get starBelowHorizon => 'ਇਸ ਸਮੇਂ ਖਿਤਿਜ ਤੋਂ ਹੇਠਾਂ';

  @override
  String get starMapNow => 'ਹੁਣ';

  @override
  String get starUnnamed => 'ਤਾਰਾ';

  @override
  String get binocularsTitle => 'ਬਾਈਨੋਕੂਲਰ ਗਾਈਡ';

  @override
  String get binocularsHint => 'ਆਮ ਬਾਈਨੋਕੂਲਰ ਨਾਲ ਕੀ ਦੇਖਣਾ ਹੈ';

  @override
  String get binocularsIntro =>
      'ਬਾਈਨੋਕੂਲਰ ਨੂੰ ਟਿਕਾ ਕੇ ਫੜੋ, ਜਿਵੇਂ ਕੂਹਣੀਆਂ ਕੰਧ ਜਾਂ ਕਾਰ ਦੀ ਛੱਤ ’ਤੇ ਟਿਕਾ ਕੇ। ਸ਼ਹਿਰ ਦੀਆਂ ਲਾਈਟਾਂ ਤੋਂ ਦੂਰ, ਤਿੱਖੇ ਤਾਰਿਆਂ ਦੀ ਥਾਂ ਮੱਧਮ, ਧੁੰਦਲੇ ਧੱਬੇ ਲੱਭੋ।';

  @override
  String get binocularsNote =>
      'ਸਮੇਂ ਦੱਸਦੇ ਹਨ ਕਿ ਤੁਹਾਡੇ ਚੁਣੇ ਸ਼ਹਿਰ ਵਿੱਚ ਰਾਤ ਦੇ ਹਨੇਰੇ ਹਿੱਸੇ ਦੌਰਾਨ ਹਰ ਚੀਜ਼ ਕਦੋਂ ਸਭ ਤੋਂ ਉੱਚੀ ਹੁੰਦੀ ਹੈ। ਚੀਜ਼ਾਂ ਦੇ ਨਾਮ ਉਹੀ ਹਨ ਜੋ ਦੁਨੀਆ ਭਰ ਵਿੱਚ ਵਰਤੇ ਜਾਂਦੇ ਹਨ। ਤਾਰਿਆਂ ਦੇ ਨਕਸ਼ੇ ’ਤੇ ਦੇਖਣ ਲਈ ਕਿਸੇ ’ਤੇ ਟੈਪ ਕਰੋ।';

  @override
  String get dsoCluster => 'ਤਾਰਾ ਝੁੰਡ';

  @override
  String get dsoGalaxy => 'ਗਲੈਕਸੀ';

  @override
  String get dsoNebula => 'ਨੀਹਾਰਿਕਾ';

  @override
  String get storyOri =>
      'ਸ਼ਿਕਾਰੀ ਓਰਾਇਨ (ਮ੍ਰਿਗ) ਨੂੰ ਲੱਭਣਾ ਆਸਾਨ ਹੈ: ਛੋਟੀ ਸਿੱਧੀ ਲਕੀਰ ਵਿੱਚ ਤਿੰਨ ਤਾਰੇ ਉਸ ਦੀ ਪੇਟੀ ਬਣਾਉਂਦੇ ਹਨ। ਪੇਟੀ ਦੇ ਉੱਪਰ ਸੰਤਰੀ ਬੇਟਲਜੂਸ ਇੱਕ ਮੋਢਾ ਅਤੇ ਹੇਠਾਂ ਨੀਲਾ-ਚਿੱਟਾ ਰਿਜੇਲ ਇੱਕ ਪੈਰ ਦਰਸਾਉਂਦਾ ਹੈ। ਪੇਟੀ ਦੇ ਹੇਠਾਂ ਮੱਧਮ ਧੱਬਾ ਲਟਕਦਾ ਹੈ, ਓਰਾਇਨ ਨੀਹਾਰਿਕਾ, ਇੱਕ ਬੱਦਲ ਜਿੱਥੇ ਨਵੇਂ ਤਾਰੇ ਜਨਮ ਲੈ ਰਹੇ ਹਨ। ਓਰਾਇਨ ਉੱਤਰ ਵਿੱਚ ਸਰਦੀਆਂ ਦੀ ਸ਼ਾਮ ਅਤੇ ਦੱਖਣ ਵਿੱਚ ਗਰਮੀਆਂ ਦੀ ਸ਼ਾਮ ਨੂੰ ਦਿਸਦਾ ਹੈ।';

  @override
  String get storyUMa =>
      'ਬਿੱਗ ਡਿੱਪਰ ਜਾਂ ਹਲ ਕਹੇ ਜਾਂਦੇ ਸਪਤਰਿਸ਼ੀ ਦੇ ਸੱਤ ਚਮਕਦਾਰ ਤਾਰੇ ਵੱਡੇ ਰਿੱਛ ਦਾ ਹਿੱਸਾ ਹਨ। ਕੌਲੀ ਦੇ ਸਿਰੇ ਦੇ ਦੋ ਤਾਰੇ, ਦੁਬਹੇ ਅਤੇ ਮੇਰਾਕ, ਧਰੁਵ ਤਾਰੇ ਵੱਲ ਰਾਹ ਦਿਖਾਉਂਦੇ ਹਨ: ਉਨ੍ਹਾਂ ਵਿਚਕਾਰਲੀ ਦੂਰੀ ਤੋਂ ਲਗਭਗ ਪੰਜ ਗੁਣਾ ਦੂਰੀ ਤੱਕ ਲਕੀਰ ਨੂੰ ਉੱਪਰ ਵੱਲ ਵਧਾਓ। ਉੱਤਰ ਦੇ ਕਈ ਹਿੱਸਿਆਂ ਤੋਂ ਸਪਤਰਿਸ਼ੀ ਸਾਰੀ ਰਾਤ ਧਰੁਵ ਤਾਰੇ ਦੁਆਲੇ ਘੁੰਮਦਾ ਹੈ ਅਤੇ ਕਦੇ ਡੁੱਬਦਾ ਨਹੀਂ।';

  @override
  String get storyUMi =>
      'ਧਰੁਵ ਤਾਰਾ (ਪੋਲਾਰਿਸ) ਛੋਟੇ ਰਿੱਛ ਦੀ ਪੂਛ ਦੀ ਨੋਕ ’ਤੇ ਹੈ। ਇਹ ਧਰਤੀ ਦੇ ਉੱਤਰੀ ਧਰੁਵ ਦੇ ਲਗਭਗ ਐਨ ਉੱਪਰ ਹੋਣ ਕਰਕੇ ਮੁਸ਼ਕਿਲ ਨਾਲ ਹਿੱਲਦਾ ਹੈ, ਇਸ ਲਈ ਸਾਰਾ ਅਸਮਾਨ ਇਸ ਦੁਆਲੇ ਘੁੰਮਦਾ ਜਾਪਦਾ ਹੈ। ਖਿਤਿਜ ਤੋਂ ਇਸ ਦੀ ਉਚਾਈ ਤੁਹਾਡੇ ਅਕਸ਼ਾਂਸ਼ ਦੇ ਬਰਾਬਰ ਹੁੰਦੀ ਹੈ। ਇਹ ਬਹੁਤ ਚਮਕਦਾਰ ਤਾਰਾ ਨਹੀਂ, ਪਰ ਉੱਤਰ ਲੱਭਣ ਲਈ ਸਭ ਤੋਂ ਕੰਮ ਦਾ ਹੈ। ਦੁਨੀਆ ਦੇ ਦੱਖਣੀ ਅੱਧ ਤੋਂ ਇਹ ਨਹੀਂ ਦਿਸਦਾ।';

  @override
  String get storyCas =>
      'ਕੈਸੀਓਪੀਆ ਸਮੇਂ ਅਤੇ ਰੁੱਤ ਮੁਤਾਬਕ W ਜਾਂ M ਵਰਗਾ ਦਿਸਦਾ ਹੈ ਅਤੇ ਪੰਜ ਕਾਫ਼ੀ ਚਮਕਦਾਰ ਤਾਰਿਆਂ ਦਾ ਬਣਿਆ ਹੈ। ਇਹ ਧਰੁਵ ਤਾਰੇ ਦੇ ਪਾਰ, ਸਪਤਰਿਸ਼ੀ ਦੇ ਉਲਟ ਪਾਸੇ ਹੈ, ਇਸ ਲਈ ਇੱਕ ਹੇਠਾਂ ਹੋਵੇ ਤਾਂ ਦੂਜਾ ਉੱਪਰ ਹੁੰਦਾ ਹੈ। ਪੁਰਾਣੀ ਕਹਾਣੀ ਵਿੱਚ ਉਹ ਇੱਕ ਰਾਣੀ ਸੀ ਜੋ ਆਪਣੀ ਸੁੰਦਰਤਾ ’ਤੇ ਹੰਕਾਰ ਕਰਦੀ ਸੀ।';

  @override
  String get storyCyg =>
      'ਹੰਸ (ਸਿਗਨਸ) ਆਕਾਸ਼ ਗੰਗਾ ਦੇ ਨਾਲ-ਨਾਲ ਉੱਡਦਾ ਹੈ। ਇਸ ਦੇ ਸਭ ਤੋਂ ਚਮਕਦਾਰ ਤਾਰੇ ਉੱਤਰੀ ਕਰਾਸ ਬਣਾਉਂਦੇ ਹਨ, ਜਿਸ ਦੇ ਸਿਰੇ ’ਤੇ ਡੇਨੇਬ ਹੈ, ਯਾਨੀ ਹੰਸ ਦੀ ਪੂਛ। ਸ਼ਹਿਰ ਦੀਆਂ ਲਾਈਟਾਂ ਤੋਂ ਦੂਰ ਆਕਾਸ਼ ਗੰਗਾ ਹੰਸ ਵਿੱਚੋਂ ਲੰਘਦੀ ਫਿੱਕੀ ਰੌਸ਼ਨੀ ਦੀ ਨਦੀ ਵਰਗੀ ਦਿਸਦੀ ਹੈ, ਅਤੇ ਬਾਈਨੋਕੂਲਰ ਦੱਸਦੇ ਹਨ ਕਿ ਇਹ ਅਣਗਿਣਤ ਮੱਧਮ ਤਾਰਿਆਂ ਦੀ ਬਣੀ ਹੈ। ਗਰਮੀਆਂ ਅਤੇ ਪੱਤਝੜ ਦੀਆਂ ਸ਼ਾਮਾਂ ਸਭ ਤੋਂ ਵਧੀਆ ਸਮਾਂ ਹਨ।';

  @override
  String get storySco =>
      'ਵ੍ਰਿਸ਼ਚਿਕ (ਸਕਾਰਪੀਅਸ) ਮੁੜੀ ਹੋਈ ਪੂਛ ਅਤੇ ਕੁੰਡੀ ਵਰਗੇ ਸਿਰੇ ਵਾਲੇ ਬਿੱਛੂ ਵਰਗਾ ਦਿਸਦਾ ਹੈ। ਇਸ ਦਾ ਦਿਲ ਲਾਲ ਜਯੇਸ਼ਠਾ (ਐਂਟਾਰੀਜ਼) ਹੈ, ਜਿਸ ਦੇ ਨਾਮ ਦਾ ਮਤਲਬ ਮੰਗਲ ਦਾ ਵਿਰੋਧੀ ਹੈ ਕਿਉਂਕਿ ਦੋਵੇਂ ਰੰਗ ਵਿੱਚ ਇੱਕੋ ਜਿਹੇ ਦਿਸਦੇ ਹਨ। ਉੱਤਰ ਵਿੱਚ ਇਹ ਗਰਮੀਆਂ ਦਾ ਤਾਰਾਮੰਡਲ ਹੈ ਅਤੇ ਦੱਖਣ ਵੱਲ ਨੀਵਾਂ ਦਿਸਦਾ ਹੈ, ਜਦਕਿ ਦੁਨੀਆ ਦੇ ਦੱਖਣੀ ਅੱਧ ਦੇ ਲੋਕਾਂ ਦੇ ਸਿਰ ਉੱਤੋਂ ਉੱਚਾ ਲੰਘਦਾ ਹੈ।';

  @override
  String get storyLeo =>
      'ਸਿੰਘ (ਲੀਓ) ਉਨ੍ਹਾਂ ਥੋੜ੍ਹੇ ਤਾਰਾਮੰਡਲਾਂ ਵਿੱਚੋਂ ਹੈ ਜੋ ਸੱਚਮੁੱਚ ਆਪਣੇ ਜਾਨਵਰ ਵਰਗੇ ਦਿਸਦੇ ਹਨ। ਤਾਰਿਆਂ ਦਾ ਉਲਟਾ ਸਵਾਲੀਆ ਨਿਸ਼ਾਨ, ਦਾਤੀ, ਸਿਰ ਅਤੇ ਛਾਤੀ ਬਣਾਉਂਦਾ ਹੈ ਅਤੇ ਚਮਕਦਾਰ ਮਘਾ (ਰੇਗੂਲਸ), ਸ਼ੇਰ ਦੇ ਦਿਲ ’ਤੇ ਖ਼ਤਮ ਹੁੰਦਾ ਹੈ। ਪੂਰਬ ਵੱਲ ਤਾਰਿਆਂ ਦਾ ਤਿਕੋਣ ਉਸ ਦਾ ਪਿਛਲਾ ਹਿੱਸਾ ਹੈ। ਉੱਤਰ ਵਿੱਚ ਬਸੰਤ ਦੀਆਂ ਸ਼ਾਮਾਂ ਸਭ ਤੋਂ ਵਧੀਆ ਸਮਾਂ ਹਨ।';

  @override
  String get storyTau =>
      'ਵ੍ਰਿਸ਼ਭ (ਟੌਰਸ) ਦਾ ਚਿਹਰਾ V ਆਕਾਰ ਦਾ ਹੈ, ਇਹ ਹਾਈਡੀਜ਼ ਝੁੰਡ ਹੈ, ਅਤੇ ਸੰਤਰੀ ਰੋਹਿਣੀ (ਐਲਡੇਬਰਾਨ) ਉਸ ਦੀ ਅੱਖ ਹੈ। ਰੋਹਿਣੀ ਝੁੰਡ ਦਾ ਹਿੱਸਾ ਜਾਪਦੀ ਹੈ, ਪਰ ਅਸਲ ਵਿੱਚ ਉਹ ਸਾਡੇ ਬਹੁਤ ਨੇੜੇ ਹੈ। ਉੱਪਰ ਕ੍ਰਿਤਿਕਾ (ਪਲੀਆਡੀਜ਼), ਯਾਨੀ ਸੱਤ ਭੈਣਾਂ, ਨੀਲੇ ਤਾਰਿਆਂ ਦਾ ਛੋਟਾ ਸਮੂਹ ਹੈ ਜਿਸ ਵਿੱਚ ਬਹੁਤੇ ਲੋਕ ਛੇ ਜਾਂ ਸੱਤ ਤਾਰੇ ਦੇਖਦੇ ਹਨ। ਕ੍ਰਿਤਿਕਾ ਦੁਨੀਆ ਭਰ ਵਿੱਚ ਜਾਣੀ ਜਾਂਦੀ ਹੈ ਅਤੇ ਕਈ ਸੱਭਿਆਚਾਰਾਂ ਦੀਆਂ ਕਹਾਣੀਆਂ ਵਿੱਚ ਆਉਂਦੀ ਹੈ।';

  @override
  String get storyGem =>
      'ਮਿਥੁਨ (ਜੈਮਿਨੀ) ਨੂੰ ਦੋ ਚਮਕਦਾਰ ਤਾਰੇ, ਕੈਸਟਰ ਅਤੇ ਪੋਲਕਸ, ਦਰਸਾਉਂਦੇ ਹਨ, ਜੋ ਦੋ ਭਰਾਵਾਂ ਦੇ ਸਿਰਾਂ ਵਾਂਗ ਨਾਲ-ਨਾਲ ਖੜ੍ਹੇ ਹਨ। ਪੋਲਕਸ ਵੱਧ ਚਮਕਦਾਰ ਹੈ ਅਤੇ ਉਸ ਵਿੱਚ ਸੰਤਰੀ ਝਲਕ ਹੈ। ਕੈਸਟਰ ਅਸਲ ਵਿੱਚ ਛੇ ਤਾਰਿਆਂ ਦਾ ਪ੍ਰਬੰਧ ਹੈ। ਉੱਤਰ ਵਿੱਚ ਸਰਦੀਆਂ ਅਤੇ ਬਸੰਤ ਦੀਆਂ ਸ਼ਾਮਾਂ ਨੂੰ ਅਸਮਾਨ ਵਿੱਚ ਉੱਚੇ ਉਨ੍ਹਾਂ ਨੂੰ ਲੱਭੋ।';

  @override
  String get storyLyr =>
      'ਵੀਣਾ (ਲਾਇਰਾ) ਛੋਟੀ ਹੈ, ਪਰ ਉੱਤਰੀ ਅਸਮਾਨ ਦੇ ਸਭ ਤੋਂ ਚਮਕਦਾਰ ਤਾਰਿਆਂ ਵਿੱਚੋਂ ਇੱਕ ਅਭਿਜੀਤ (ਵੇਗਾ) ਇਸ ਵਿੱਚ ਹੈ। ਅਭਿਜੀਤ ਨੀਲਾ-ਚਿੱਟਾ ਹੈ ਅਤੇ ਸਿਗਨਸ ਦੇ ਡੇਨੇਬ ਤੇ ਐਕਵਿਲਾ ਦੇ ਅਲਟੇਅਰ ਨਾਲ ਮਿਲ ਕੇ ਗਰਮੀਆਂ ਦਾ ਤਿਕੋਣ ਬਣਾਉਂਦਾ ਹੈ। ਅਭਿਜੀਤ ਦੇ ਬਿਲਕੁਲ ਕੋਲ ਤਾਰਿਆਂ ਦਾ ਛੋਟਾ ਸਮਾਂਤਰ ਚਤੁਰਭੁਜ ਵੀਣਾ ਦਾ ਸਰੀਰ ਬਣਾਉਂਦਾ ਹੈ।';

  @override
  String get storyCru =>
      'ਕ੍ਰਕਸ, ਦੱਖਣੀ ਕਰਾਸ, ਸਾਰੇ ਤਾਰਾਮੰਡਲਾਂ ਵਿੱਚੋਂ ਸਭ ਤੋਂ ਛੋਟਾ ਹੈ, ਪਰ ਸਭ ਤੋਂ ਮਸ਼ਹੂਰਾਂ ਵਿੱਚੋਂ ਇੱਕ। ਚਾਰ ਚਮਕਦਾਰ ਤਾਰੇ ਕਰਾਸ ਬਣਾਉਂਦੇ ਹਨ ਅਤੇ ਉਸ ਦੀ ਲੰਮੀ ਬਾਂਹ ਦੇ ਦੋ ਤਾਰੇ ਦੱਖਣੀ ਖਗੋਲੀ ਧਰੁਵ ਵੱਲ ਇਸ਼ਾਰਾ ਕਰਦੇ ਹਨ, ਇਸ ਲਈ ਇਹ ਮੁਸਾਫ਼ਰਾਂ ਨੂੰ ਦੱਖਣ ਲੱਭਣ ਵਿੱਚ ਮਦਦ ਕਰਦਾ ਹੈ। ਦੁਨੀਆ ਦੇ ਉੱਤਰੀ ਅੱਧ ਦੇ ਬਹੁਤੇ ਹਿੱਸਿਆਂ ਤੋਂ ਇਹ ਨਹੀਂ ਦਿਸਦਾ।';
}
