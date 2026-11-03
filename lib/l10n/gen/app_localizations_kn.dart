// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get appTitle => 'Heliora';

  @override
  String get tagline => 'ಸೌರವ್ಯೂಹವನ್ನು ಅನ್ವೇಷಿಸಿ, ಸಂಪೂರ್ಣ ಆಫ್‌ಲೈನ್';

  @override
  String get navExplore => 'ಅನ್ವೇಷಿಸಿ';

  @override
  String get navCompare => 'ಹೋಲಿಕೆ';

  @override
  String get navWeight => 'ತೂಕ';

  @override
  String get navQuiz => 'ರಸಪ್ರಶ್ನೆ';

  @override
  String get viewMode => 'ವೀಕ್ಷಣೆ ಮೋಡ್';

  @override
  String get settings => 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು';

  @override
  String get notToScale =>
      'ಅಳತೆಗೆ ತಕ್ಕಂತೆ ಇಲ್ಲ · ತೆರೆಯಲು ಗ್ರಹವನ್ನು ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get dragToRotate => 'ತಿರುಗಿಸಲು ಎಳೆಯಿರಿ · ಜೂಮ್‌ಗೆ ಪಿಂಚ್ ಮಾಡಿ';

  @override
  String get planetsTitle => 'ಗ್ರಹಗಳು';

  @override
  String get planetMercury => 'ಬುಧ';

  @override
  String get planetVenus => 'ಶುಕ್ರ';

  @override
  String get planetEarth => 'ಭೂಮಿ';

  @override
  String get planetMars => 'ಮಂಗಳ';

  @override
  String get planetJupiter => 'ಗುರು';

  @override
  String get planetSaturn => 'ಶನಿ';

  @override
  String get planetUranus => 'ಯುರೇನಸ್';

  @override
  String get planetNeptune => 'ನೆಪ್ಚೂನ್';

  @override
  String planetOrder(int n) {
    return 'ಸೂರ್ಯನಿಂದ ಗ್ರಹ ಸಂಖ್ಯೆ $n';
  }

  @override
  String get openDetails => 'ವಿವರಗಳನ್ನು ತೆರೆಯಿರಿ';

  @override
  String get diameter => 'ವ್ಯಾಸ';

  @override
  String get gravity => 'ಗುರುತ್ವಾಕರ್ಷಣೆ';

  @override
  String get avgTemp => 'ಸರಾಸರಿ ತಾಪಮಾನ';

  @override
  String get avgTempShort => 'ಸರಾಸರಿ ತಾಪಮಾನ';

  @override
  String get dayLength => 'ದಿನ';

  @override
  String get yearLength => 'ವರ್ಷ';

  @override
  String get moons => 'ತಿಳಿದಿರುವ ಚಂದ್ರರು';

  @override
  String get moonsShort => 'ಚಂದ್ರರು';

  @override
  String get distance => 'ಸೂರ್ಯನಿಂದ ದೂರ';

  @override
  String get pressure => 'ಮೇಲ್ಮೈ ಒತ್ತಡ';

  @override
  String get noSurface => 'ಗಟ್ಟಿ ಮೇಲ್ಮೈ ಇಲ್ಲ';

  @override
  String valueKm(String value) {
    return '$value ಕಿಮೀ';
  }

  @override
  String valueMillionKm(String value) {
    return '$value ಮಿಲಿಯನ್ ಕಿಮೀ';
  }

  @override
  String valueHours(String value) {
    return '$value ಗಂಟೆ';
  }

  @override
  String valueDays(String value) {
    return '$value ದಿನಗಳು';
  }

  @override
  String valueYears(String value) {
    return '$value ವರ್ಷಗಳು';
  }

  @override
  String get atmosphere => 'ವಾತಾವರಣ';

  @override
  String get thinAtmosphere =>
      'ಬಹುತೇಕ ವಾತಾವರಣವಿಲ್ಲ. ಈ ಅನಿಲಗಳು ಎಕ್ಸೋಸ್ಫಿಯರ್ ಎಂಬ ತುಂಬಾ ತೆಳುವಾದ ಪದರ ಮಾಡುತ್ತವೆ.';

  @override
  String get oxygen => 'ಆಮ್ಲಜನಕ';

  @override
  String get oxygenVsEarth => 'ಆಮ್ಲಜನಕ: ಭೂಮಿಯೊಂದಿಗೆ ಹೋಲಿಕೆ';

  @override
  String get breathable => 'ಮನುಷ್ಯರು ಉಸಿರಾಡಲು ಯೋಗ್ಯ';

  @override
  String get notBreathable => 'ಉಸಿರಾಡಲು ಯೋಗ್ಯವಲ್ಲ, ಬಾಹ್ಯಾಕಾಶ ಉಡುಪು ಬೇಕು';

  @override
  String weightFeelsLike(String weight) {
    return 'ಭೂಮಿಯ $weight ಕೆಜಿ ಇಲ್ಲಿ ಇಷ್ಟು ಅನಿಸುತ್ತದೆ';
  }

  @override
  String get gasCo2 => 'ಕಾರ್ಬನ್ ಡೈಆಕ್ಸೈಡ್';

  @override
  String get gasN2 => 'ಸಾರಜನಕ';

  @override
  String get gasO2 => 'ಆಮ್ಲಜನಕ';

  @override
  String get gasAr => 'ಆರ್ಗಾನ್';

  @override
  String get gasH2 => 'ಜಲಜನಕ';

  @override
  String get gasHe => 'ಹೀಲಿಯಂ';

  @override
  String get gasCh4 => 'ಮೀಥೇನ್';

  @override
  String get gasNa => 'ಸೋಡಿಯಂ';

  @override
  String get gasK => 'ಪೊಟ್ಯಾಸಿಯಂ';

  @override
  String get compareTitle => 'ಗ್ರಹಗಳ ಹೋಲಿಕೆ';

  @override
  String get compareHint => 'ಅಕ್ಕಪಕ್ಕ ನೋಡಲು ಎರಡು ಗ್ರಹಗಳನ್ನು ಆರಿಸಿ.';

  @override
  String get weightTitle => 'ಬೇರೆ ಗ್ರಹಗಳಲ್ಲಿ ನಿಮ್ಮ ತೂಕ';

  @override
  String get weightInput => 'ಭೂಮಿಯ ಮೇಲೆ ನಿಮ್ಮ ತೂಕ (ಕೆಜಿ)';

  @override
  String gravityTimes(String factor) {
    return 'ಭೂಮಿಯ ಗುರುತ್ವಾಕರ್ಷಣೆಯ $factor×';
  }

  @override
  String get quizTitle => 'ಗ್ರಹ ರಸಪ್ರಶ್ನೆ';

  @override
  String get quizIntro =>
      'ಗ್ರಹಗಳು ಮತ್ತು ಚಂದ್ರಗಳ ಬಗ್ಗೆ 10 ಪ್ರಶ್ನೆಗಳು. ನೀವು ಎಷ್ಟು ಸರಿ ಮಾಡಬಲ್ಲಿರಿ?';

  @override
  String get quizStart => 'ರಸಪ್ರಶ್ನೆ ಆರಂಭಿಸಿ';

  @override
  String quizProgress(int current, int total) {
    return 'ಪ್ರಶ್ನೆ $current / $total';
  }

  @override
  String get quizNext => 'ಮುಂದೆ';

  @override
  String get quizSeeResult => 'ಫಲಿತಾಂಶ ನೋಡಿ';

  @override
  String get quizCorrect => 'ಸರಿ!';

  @override
  String quizWrong(String answer) {
    return 'ಅಲ್ಲ. ಸರಿಯಾದ ಉತ್ತರ $answer.';
  }

  @override
  String quizScore(int score, int total) {
    return '$total ರಲ್ಲಿ $score ಸರಿ';
  }

  @override
  String quizBest(int score) {
    return 'ಅತ್ಯುತ್ತಮ ಸ್ಕೋರ್: $score';
  }

  @override
  String get quizNewBest => 'ಹೊಸ ಅತ್ಯುತ್ತಮ ಸ್ಕೋರ್!';

  @override
  String get quizAgain => 'ಮತ್ತೆ ಆಡಿ';

  @override
  String get qLargest => 'ಅತಿ ದೊಡ್ಡ ಗ್ರಹ ಯಾವುದು?';

  @override
  String get qSmallest => 'ಅತಿ ಚಿಕ್ಕ ಗ್ರಹ ಯಾವುದು?';

  @override
  String get qHottest => 'ಅತಿ ಬಿಸಿಯಾದ ಗ್ರಹ ಯಾವುದು?';

  @override
  String get qColdest => 'ಅತಿ ತಂಪಾದ ಗ್ರಹ ಯಾವುದು?';

  @override
  String get qMostMoons => 'ಯಾವ ಗ್ರಹಕ್ಕೆ ಅತಿ ಹೆಚ್ಚು ತಿಳಿದಿರುವ ಚಂದ್ರರಿದ್ದಾರೆ?';

  @override
  String get qBreathable => 'ಯಾವ ಗ್ರಹದಲ್ಲಿ ಮನುಷ್ಯರು ಗಾಳಿಯನ್ನು ಉಸಿರಾಡಬಹುದು?';

  @override
  String get qClosest => 'ಸೂರ್ಯನಿಗೆ ಅತಿ ಹತ್ತಿರದ ಗ್ರಹ ಯಾವುದು?';

  @override
  String get qFarthest => 'ಸೂರ್ಯನಿಂದ ಅತಿ ದೂರದ ಗ್ರಹ ಯಾವುದು?';

  @override
  String get qStrongestGravity => 'ಯಾವ ಗ್ರಹದ ಗುರುತ್ವಾಕರ್ಷಣೆ ಅತಿ ಹೆಚ್ಚು?';

  @override
  String get qShortestDay => 'ಯಾವ ಗ್ರಹದ ದಿನ ಅತಿ ಚಿಕ್ಕದು?';

  @override
  String get qLongestDay => 'ಯಾವ ಗ್ರಹದ ದಿನ ಅತಿ ಉದ್ದ?';

  @override
  String get appearance => 'ನೋಟ';

  @override
  String get theme => 'ಥೀಮ್';

  @override
  String get themeSystem => 'ಸಿಸ್ಟಮ್';

  @override
  String get themeLight => 'ಲೈಟ್';

  @override
  String get themeDark => 'ಡಾರ್ಕ್';

  @override
  String get language => 'ಭಾಷೆ';

  @override
  String get appLanguage => 'ಆ್ಯಪ್ ಭಾಷೆ';

  @override
  String get languageNote => '20 ಭಾಷೆಗಳು · ಗ್ರಹಗಳ ಹೆಸರುಗಳೂ';

  @override
  String get phoneLanguage => 'ಫೋನ್ ಭಾಷೆ';

  @override
  String get updates => 'ಅಪ್‌ಡೇಟ್‌ಗಳು';

  @override
  String get version => 'ಆವೃತ್ತಿ';

  @override
  String get checkForUpdates => 'ಅಪ್‌ಡೇಟ್ ಪರಿಶೀಲಿಸಿ';

  @override
  String get checking => 'ಪರಿಶೀಲಿಸಲಾಗುತ್ತಿದೆ…';

  @override
  String get autoUpdateCheck => 'ದಿನಕ್ಕೆ ಒಮ್ಮೆ ಸ್ವಯಂಚಾಲಿತವಾಗಿ ಪರಿಶೀಲಿಸಿ';

  @override
  String get updateNote =>
      'ಅಪ್‌ಡೇಟ್‌ಗಳು GitHub Releases ನಿಂದ ಬರುತ್ತವೆ. ನಿಮ್ಮ ಸೆಟ್ಟಿಂಗ್‌ಗಳು ಫೋನ್‌ನಲ್ಲೇ ಇರುತ್ತವೆ.';

  @override
  String get upToDate => 'ನಿಮ್ಮ ಬಳಿ ಇತ್ತೀಚಿನ ಆವೃತ್ತಿ ಇದೆ.';

  @override
  String get updateFailed =>
      'GitHub ತಲುಪಲು ಆಗಲಿಲ್ಲ. ಇಂಟರ್ನೆಟ್ ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get updateAvailable => 'ಅಪ್‌ಡೇಟ್ ಲಭ್ಯವಿದೆ';

  @override
  String updateReady(String version) {
    return 'ಆವೃತ್ತಿ $version ಡೌನ್‌ಲೋಡ್‌ಗೆ ಸಿದ್ಧವಾಗಿದೆ.';
  }

  @override
  String get download => 'ಡೌನ್‌ಲೋಡ್';

  @override
  String get later => 'ನಂತರ';

  @override
  String get about => 'ಕುರಿತು';

  @override
  String get sourceCode => 'GitHub ನಲ್ಲಿ ಸೋರ್ಸ್ ಕೋಡ್';

  @override
  String get privacyLine => 'ಆಫ್‌ಲೈನ್ · ಜಾಹೀರಾತು ಇಲ್ಲ · ಟ್ರ್ಯಾಕಿಂಗ್ ಇಲ್ಲ';

  @override
  String get dataSource => 'ಮಾಹಿತಿ: NASA Planetary Fact Sheet';

  @override
  String get openFailed => 'ಲಿಂಕ್ ತೆರೆಯಲು ಆಗಲಿಲ್ಲ.';

  @override
  String get bodySun => 'ಸೂರ್ಯ';

  @override
  String get bodyMoon => 'ಚಂದ್ರ';

  @override
  String get bodyPluto => 'ಪ್ಲೂಟೊ';

  @override
  String get moonIo => 'ಅಯೋ';

  @override
  String get moonEuropa => 'ಯುರೋಪಾ';

  @override
  String get moonGanymede => 'ಗ್ಯಾನಿಮೀಡ್';

  @override
  String get moonCallisto => 'ಕ್ಯಾಲಿಸ್ಟೊ';

  @override
  String get moonTitan => 'ಟೈಟಾನ್';

  @override
  String get moonEnceladus => 'ಎನ್ಸೆಲಾಡಸ್';

  @override
  String get moonTriton => 'ಟ್ರೈಟನ್';

  @override
  String get kindStar => 'ನಮ್ಮ ನಕ್ಷತ್ರ, ಸೌರವ್ಯೂಹದ ಕೇಂದ್ರ';

  @override
  String get kindDwarf => 'ಕುಬ್ಜ ಗ್ರಹ';

  @override
  String moonOf(String planet) {
    return '$planet ನ ಚಂದ್ರ';
  }

  @override
  String get orbitPeriod => 'ಒಂದು ಪರಿಭ್ರಮಣ';

  @override
  String distanceFrom(String body) {
    return '$body ನಿಂದ ದೂರ';
  }

  @override
  String get composition => 'ಇದು ಯಾವುದರಿಂದ ಮಾಡಲ್ಪಟ್ಟಿದೆ';

  @override
  String get noAtmosphere => 'ನಿಜವಾದ ವಾತಾವರಣವಿಲ್ಲ, ಬಹುತೇಕ ನಿರ್ವಾತ.';

  @override
  String get majorMoons => 'ಮುಖ್ಯ ಚಂದ್ರರು';

  @override
  String get lifeTitle => 'ಮನುಷ್ಯರು ಇಲ್ಲಿ ಬದುಕಬಹುದೇ?';

  @override
  String get lifeScoreShort => 'ಜೀವ ಸ್ಕೋರ್';

  @override
  String get lifeNote =>
      'ತಾಪಮಾನ, ಗಾಳಿಯ ಒತ್ತಡ, ಆಮ್ಲಜನಕ, ನೀರು, ಮೇಲ್ಮೈ ಮತ್ತು ಗುರುತ್ವದಿಂದ ಲೆಕ್ಕ. ಭೂಮಿಯ ಸ್ಕೋರ್ 10.';

  @override
  String get water => 'ನೀರು';

  @override
  String get waterLiquid => 'ದ್ರವ ನೀರು';

  @override
  String get waterIce => 'ಮಂಜುಗಡ್ಡೆ';

  @override
  String get waterOcean => 'ಮಂಜಿನ ಕೆಳಗೆ ಸಾಗರ';

  @override
  String get waterNone => 'ನೀರಿಲ್ಲ';

  @override
  String get surface => 'ಮೇಲ್ಮೈ';

  @override
  String get solidSurface => 'ಗಟ್ಟಿ ಮೇಲ್ಮೈ';

  @override
  String get lifeHome => 'ಸಂಪೂರ್ಣ ಮನೆಯಂತೆ';

  @override
  String get lifeHard => 'ತುಂಬಾ ಕಷ್ಟ, ಮುಚ್ಚಿದ ನೆಲೆ ಮತ್ತು ಬಾಹ್ಯಾಕಾಶ ಉಡುಪು ಬೇಕು';

  @override
  String get lifeNo => 'ಮನುಷ್ಯರಿಗೆ ಅಸಾಧ್ಯ';

  @override
  String get downloadInstall => 'ಡೌನ್‌ಲೋಡ್ ಮಾಡಿ ಇನ್‌ಸ್ಟಾಲ್ ಮಾಡಿ';

  @override
  String downloadingPercent(String percent) {
    return 'ಡೌನ್‌ಲೋಡ್ ಆಗುತ್ತಿದೆ… $percent%';
  }

  @override
  String get installNow => 'ಇನ್‌ಸ್ಟಾಲ್';

  @override
  String get allowInstalls =>
      'ತೆರೆದ ಪರದೆಯಲ್ಲಿ Heliora ಗೆ ಆ್ಯಪ್ ಇನ್‌ಸ್ಟಾಲ್ ಮಾಡಲು ಅನುಮತಿ ನೀಡಿ, ನಂತರ ಹಿಂದಿರುಗಿ ಇನ್‌ಸ್ಟಾಲ್ ಒತ್ತಿ.';

  @override
  String get downloadFailed =>
      'ಡೌನ್‌ಲೋಡ್ ಪೂರ್ಣವಾಗಲಿಲ್ಲ. ಇಂಟರ್ನೆಟ್ ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get tryAgain => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get today => 'ಇಂದು';

  @override
  String get play => 'ಚಾಲನೆ';

  @override
  String get pause => 'ವಿರಾಮ';

  @override
  String get monthBack => '30 ದಿನ ಹಿಂದೆ';

  @override
  String get monthForward => '30 ದಿನ ಮುಂದೆ';

  @override
  String get positionsNote =>
      'ಈ ದಿನಾಂಕದ ನಿಜವಾದ ಸ್ಥಾನಗಳು · ಗಾತ್ರ ಮತ್ತು ದೂರ ಅಳತೆಗೆ ತಕ್ಕಂತೆ ಇಲ್ಲ · ಗ್ರಹವನ್ನು ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get navYou => 'ನೀವು';

  @override
  String get ageTitle => 'ಬೇರೆ ಗ್ರಹಗಳಲ್ಲಿ ನಿಮ್ಮ ವಯಸ್ಸು';

  @override
  String get setBirthDate => 'ನಿಮ್ಮ ಜನ್ಮದಿನಾಂಕ ಹಾಕಿ';

  @override
  String get changeBirthDate => 'ಬದಲಿಸಿ';

  @override
  String nextBirthday(String days) {
    return 'ಮುಂದಿನ ಹುಟ್ಟುಹಬ್ಬ $days ದಿನಗಳಲ್ಲಿ';
  }

  @override
  String get ageNote => 'ನಿಮ್ಮ ಜನ್ಮದಿನಾಂಕ ಈ ಫೋನ್‌ನಲ್ಲಿ ಮಾತ್ರ ಉಳಿಯುತ್ತದೆ.';

  @override
  String get share => 'ಹಂಚಿ';

  @override
  String shareText(String planet) {
    return 'Heliora ದಲ್ಲಿ $planet, ಉಚಿತ ಆಫ್‌ಲೈನ್ ಸೌರವ್ಯೂಹ ಆ್ಯಪ್: https://github.com/lumio-apps/heliora';
  }

  @override
  String get shareFailed => 'ಚಿತ್ರ ಹಂಚಲು ಆಗಲಿಲ್ಲ.';

  @override
  String get travelTitle => 'ಎಷ್ಟು ದೂರ?';

  @override
  String get distanceFromEarth => 'ಇಂದು ಭೂಮಿಯಿಂದ ದೂರ';

  @override
  String get lightTime => 'ಬೆಳಕಿಗೆ ಬೇಕಾಗುವ ಸಮಯ';

  @override
  String get bySpacecraft => 'ಗಂಟೆಗೆ 60,000 ಕಿಮೀ ಬಾಹ್ಯಾಕಾಶ ನೌಕೆಯಲ್ಲಿ';

  @override
  String get byCar => 'ಗಂಟೆಗೆ 100 ಕಿಮೀ ಕಾರಿನಲ್ಲಿ';

  @override
  String valueSeconds(String value) {
    return '$value ಸೆ';
  }

  @override
  String valueMinutes(String value) {
    return '$value ನಿಮಿಷ';
  }

  @override
  String get sizeTitle => 'ಗಾತ್ರ';

  @override
  String sizeTimes(String big, String times, String small) {
    return '$big ಅಗಲದಲ್ಲಿ $small ಗಿಂತ $times× ದೊಡ್ಡದು.';
  }

  @override
  String sizeSimilar(String a, String b) {
    return '$a ಮತ್ತು $b ಬಹುತೇಕ ಒಂದೇ ಗಾತ್ರ.';
  }

  @override
  String get navSky => 'ಆಕಾಶ';

  @override
  String get skyTitle => 'ಇಂದು ರಾತ್ರಿಯ ಆಕಾಶ';

  @override
  String get chooseCity => 'ನಿಮ್ಮ ನಗರ ಆರಿಸಿ';

  @override
  String get chooseCityHint =>
      'ಚಂದ್ರ ಮತ್ತು ಇಂದು ರಾತ್ರಿ ಕಾಣುವ ಗ್ರಹಗಳನ್ನು ನೋಡಲು ಹತ್ತಿರದ ನಗರ ಆರಿಸಿ. ಸ್ಥಳದ ಅನುಮತಿ ಬೇಡ, ಇದು ಫೋನ್‌ನಲ್ಲೇ ಉಳಿಯುತ್ತದೆ.';

  @override
  String get searchCity => 'ನಗರ ಹುಡುಕಿ';

  @override
  String get noCityFound => 'ಯಾವ ನಗರವೂ ಸಿಗಲಿಲ್ಲ';

  @override
  String get cityNote =>
      'ಸಮಯ ನಿಮ್ಮ ಫೋನ್‌ನ ಟೈಮ್ ಝೋನ್‌ನಲ್ಲಿದೆ. ಕತ್ತಲ ಆಕಾಶದಲ್ಲಿ ದಿಗಂತದಿಂದ ಕನಿಷ್ಠ 5° ಮೇಲಿದ್ದರೆ ಗ್ರಹ ಕಾಣುತ್ತದೆ ಎಂದು ಪರಿಗಣಿಸಲಾಗುತ್ತದೆ.';

  @override
  String illuminated(String percent) {
    return '$percent% ಬೆಳಕು';
  }

  @override
  String get moonrise => 'ಚಂದ್ರೋದಯ';

  @override
  String get moonset => 'ಚಂದ್ರಾಸ್ತ';

  @override
  String get sunset => 'ಸೂರ್ಯಾಸ್ತ';

  @override
  String get sunrise => 'ಸೂರ್ಯೋದಯ';

  @override
  String get nextFull => 'ಮುಂದಿನ ಹುಣ್ಣಿಮೆ';

  @override
  String get nextNew => 'ಮುಂದಿನ ಅಮಾವಾಸ್ಯೆ';

  @override
  String get phaseNew => 'ಅಮಾವಾಸ್ಯೆ';

  @override
  String get phaseWaxingCrescent => 'ಬೆಳೆಯುವ ಬಿದಿಗೆ ಚಂದ್ರ';

  @override
  String get phaseFirstQuarter => 'ಶುಕ್ಲ ಅಷ್ಟಮಿ';

  @override
  String get phaseWaxingGibbous => 'ಬೆಳೆಯುವ ಚಂದ್ರ';

  @override
  String get phaseFull => 'ಹುಣ್ಣಿಮೆ';

  @override
  String get phaseWaningGibbous => 'ಕರಗುವ ಚಂದ್ರ';

  @override
  String get phaseLastQuarter => 'ಕೃಷ್ಣ ಅಷ್ಟಮಿ';

  @override
  String get phaseWaningCrescent => 'ಕರಗುವ ಬಿದಿಗೆ ಚಂದ್ರ';

  @override
  String get planetsTonight => 'ಇಂದು ರಾತ್ರಿಯ ಗ್ರಹಗಳು';

  @override
  String get statusVisible => 'ಇಂದು ರಾತ್ರಿ ಕಾಣುತ್ತದೆ';

  @override
  String get statusEvening => 'ಸಂಜೆ, ಸೂರ್ಯಾಸ್ತದ ನಂತರ';

  @override
  String get statusMorning => 'ಬೆಳಿಗ್ಗೆ, ಸೂರ್ಯೋದಯಕ್ಕೆ ಮೊದಲು';

  @override
  String get statusNotVisible => 'ಇಂದು ರಾತ್ರಿ ಕಾಣುವುದಿಲ್ಲ';

  @override
  String bestAt(String time) {
    return 'ಉತ್ತಮ ಸಮಯ $time';
  }

  @override
  String altitudeDir(String direction, String degrees) {
    return '$direction, $degrees° ಎತ್ತರ';
  }

  @override
  String riseSet(String rise, String set) {
    return 'ಉದಯ $rise · ಅಸ್ತ $set';
  }

  @override
  String get needsTelescope => 'ಬೈನಾಕ್ಯುಲರ್ ಅಥವಾ ದೂರದರ್ಶಕ ಬೇಕು';

  @override
  String get dirN => 'ಉತ್ತರ';

  @override
  String get dirNE => 'ಈಶಾನ್ಯ';

  @override
  String get dirE => 'ಪೂರ್ವ';

  @override
  String get dirSE => 'ಆಗ್ನೇಯ';

  @override
  String get dirS => 'ದಕ್ಷಿಣ';

  @override
  String get dirSW => 'ನೈಋತ್ಯ';

  @override
  String get dirW => 'ಪಶ್ಚಿಮ';

  @override
  String get dirNW => 'ವಾಯವ್ಯ';

  @override
  String get findPlanet => 'ಆಕಾಶದಲ್ಲಿ ಹುಡುಕಿ';

  @override
  String finderTitle(String name) {
    return '$name ಹುಡುಕಿ';
  }

  @override
  String get pointPhone => 'ಫೋನ್ ಮೇಲೆತ್ತಿ ನಿಧಾನವಾಗಿ ತಿರುಗಿಸಿ.';

  @override
  String turnRight(String degrees) {
    return '$degrees° ಬಲಕ್ಕೆ ತಿರುಗಿ';
  }

  @override
  String turnLeft(String degrees) {
    return '$degrees° ಎಡಕ್ಕೆ ತಿರುಗಿ';
  }

  @override
  String tiltUp(String degrees) {
    return '$degrees° ಮೇಲಕ್ಕೆ ಎತ್ತಿ';
  }

  @override
  String tiltDown(String degrees) {
    return '$degrees° ಕೆಳಗೆ ಇಳಿಸಿ';
  }

  @override
  String onTarget(String name) {
    return '$name ಅಲ್ಲೇ ಇದೆ!';
  }

  @override
  String belowHorizon(String name) {
    return '$name ಈಗ ದಿಗಂತದ ಕೆಳಗಿದೆ.';
  }

  @override
  String risesAt(String time) {
    return 'ಇದು $timeಕ್ಕೆ ಉದಯಿಸುತ್ತದೆ.';
  }

  @override
  String get noSensor =>
      'ಈ ಫೋನ್‌ನಲ್ಲಿ ದಿಕ್ಸೂಚಿ ಸೆನ್ಸರ್ ಇಲ್ಲ, ಆದ್ದರಿಂದ ಹುಡುಕುವ ಸೌಲಭ್ಯ ಕೆಲಸ ಮಾಡುವುದಿಲ್ಲ.';

  @override
  String get calibrate =>
      'ದಿಕ್ಸೂಚಿಯನ್ನು ಕ್ಯಾಲಿಬ್ರೇಟ್ ಮಾಡಬೇಕು: ಫೋನ್ ಅನ್ನು ಕೆಲವು ಬಾರಿ 8 ಆಕಾರದಲ್ಲಿ ತಿರುಗಿಸಿ.';

  @override
  String get phoneNow => 'ನಿಮ್ಮ ಫೋನ್ ಈ ಕಡೆ ತೋರಿಸುತ್ತಿದೆ';

  @override
  String get finderNote =>
      'ಫೋನ್‌ನ ಹಿಂಭಾಗವನ್ನು ಆಕಾಶದ ಕಡೆಗೆ ಇರಿಸಿ ಮತ್ತು ಆಯಸ್ಕಾಂತ ಹಾಗೂ ಲೋಹದಿಂದ ದೂರವಿಡಿ. ಸೂರ್ಯನನ್ನು ಎಂದೂ ನೋಡಬೇಡಿ.';

  @override
  String get eventsTitle => 'ಬಾಹ್ಯಾಕಾಶ ಘಟನೆಗಳು';

  @override
  String get eventsSubtitle => 'ಮುಂದಿನ 12 ತಿಂಗಳಲ್ಲಿ ಆಕಾಶದಲ್ಲಿ ಏನು ನೋಡಬೇಕು.';

  @override
  String eventsNext(String event, String when) {
    return 'ಮುಂದೆ: $event · $when';
  }

  @override
  String get eventFullMoon => 'ಹುಣ್ಣಿಮೆ';

  @override
  String get eventNewMoon => 'ಅಮಾವಾಸ್ಯೆ';

  @override
  String eventOpposition(String planet) {
    return '$planet ಪ್ರತಿಯುತಿಯಲ್ಲಿ';
  }

  @override
  String eventEveningElongation(String planet) {
    return '$planet: ಸಂಜೆ ನೋಡಲು ಉತ್ತಮ ಸಮಯ';
  }

  @override
  String eventMorningElongation(String planet) {
    return '$planet: ಬೆಳಗ್ಗೆ ನೋಡಲು ಉತ್ತಮ ಸಮಯ';
  }

  @override
  String eventConjunction(String a, String b) {
    return '$a ಮತ್ತು $b ಹತ್ತಿರ ಬರುತ್ತವೆ';
  }

  @override
  String get eventMarchEquinox => 'ಮಾರ್ಚ್ ವಿಷುವ';

  @override
  String get eventJuneSolstice => 'ಜೂನ್ ಅಯನ ಸಂಕ್ರಾಂತಿ';

  @override
  String get eventSeptemberEquinox => 'ಸೆಪ್ಟೆಂಬರ್ ವಿಷುವ';

  @override
  String get eventDecemberSolstice => 'ಡಿಸೆಂಬರ್ ಅಯನ ಸಂಕ್ರಾಂತಿ';

  @override
  String get eventFullMoonDesc =>
      'ಚಂದ್ರನ ಇಡೀ ಮುಖ ಬೆಳಗುತ್ತದೆ. ಇದು ಸೂರ್ಯಾಸ್ತದ ಸುಮಾರಿಗೆ ಉದಯಿಸುತ್ತದೆ.';

  @override
  String get eventNewMoonDesc =>
      'ಚಂದ್ರ ಕಾಣುವುದಿಲ್ಲ. ನಕ್ಷತ್ರ ಮತ್ತು ಗ್ರಹಗಳನ್ನು ನೋಡಲು ತಿಂಗಳ ಅತ್ಯಂತ ಕತ್ತಲೆಯ ಆಕಾಶ.';

  @override
  String eventOppositionDesc(String planet) {
    return '$planet ಸೂರ್ಯನ ನೇರ ಎದುರಿಗಿದೆ. ಈ ವರ್ಷ ಇದು ಅತ್ಯಂತ ಪ್ರಕಾಶಮಾನ ಮತ್ತು ರಾತ್ರಿಯಿಡೀ ಕಾಣುತ್ತದೆ.';
  }

  @override
  String eventEveningDesc(String planet, String degrees) {
    return '$planet ಸೂರ್ಯನಿಂದ $degrees° ದೂರದಲ್ಲಿದೆ, ಅತ್ಯಧಿಕ ದೂರ. ಸೂರ್ಯಾಸ್ತದ ನಂತರ ಪಶ್ಚಿಮದಲ್ಲಿ ಕೆಳಗೆ ನೋಡಿ.';
  }

  @override
  String eventMorningDesc(String planet, String degrees) {
    return '$planet ಸೂರ್ಯನಿಂದ $degrees° ದೂರದಲ್ಲಿದೆ, ಅತ್ಯಧಿಕ ದೂರ. ಸೂರ್ಯೋದಯದ ಮೊದಲು ಪೂರ್ವದಲ್ಲಿ ಕೆಳಗೆ ನೋಡಿ.';
  }

  @override
  String eventConjunctionDesc(String degrees) {
    return 'ಆಕಾಶದಲ್ಲಿ ಇವು ಕೇವಲ $degrees° ಅಂತರದಲ್ಲಿ ಹಾದುಹೋಗುತ್ತವೆ.';
  }

  @override
  String get eventEquinoxDesc =>
      'ಭೂಮಿಯಲ್ಲಿ ಎಲ್ಲೆಡೆ ಹಗಲು ಮತ್ತು ರಾತ್ರಿ ಬಹುತೇಕ ಸಮಾನ.';

  @override
  String get eventJuneSolsticeDesc =>
      'ಉತ್ತರದಲ್ಲಿ ಅತಿ ದೀರ್ಘ ಹಗಲು, ದಕ್ಷಿಣದಲ್ಲಿ ಅತಿ ಚಿಕ್ಕ ಹಗಲು.';

  @override
  String get eventDecemberSolsticeDesc =>
      'ಉತ್ತರದಲ್ಲಿ ಅತಿ ಚಿಕ್ಕ ಹಗಲು, ದಕ್ಷಿಣದಲ್ಲಿ ಅತಿ ದೀರ್ಘ ಹಗಲು.';

  @override
  String eventMeteorShower(String shower) {
    return '$shower ಉಲ್ಕಾವೃಷ್ಟಿ';
  }

  @override
  String eventMeteorDesc(String rate, String percent) {
    return 'ಕತ್ತಲೆ ಆಕಾಶದಲ್ಲಿ ಗಂಟೆಗೆ ಸುಮಾರು $rate ವರೆಗೆ ಉಲ್ಕೆಗಳು. ಚಂದ್ರ $percent% ಬೆಳಗಿರುತ್ತದೆ.';
  }

  @override
  String get showerQuadrantids => 'ಕ್ವಾಡ್ರಾಂಟಿಡ್ಸ್';

  @override
  String get showerLyrids => 'ಲೈರಿಡ್ಸ್';

  @override
  String get showerEtaAquariids => 'ಎಟಾ ಅಕ್ವೇರಿಡ್ಸ್';

  @override
  String get showerPerseids => 'ಪರ್ಸಿಡ್ಸ್';

  @override
  String get showerOrionids => 'ಓರಿಯೊನಿಡ್ಸ್';

  @override
  String get showerLeonids => 'ಲಿಯೊನಿಡ್ಸ್';

  @override
  String get showerGeminids => 'ಜೆಮಿನಿಡ್ಸ್';

  @override
  String get showerUrsids => 'ಅರ್ಸಿಡ್ಸ್';

  @override
  String get eventToday => 'ಇಂದು';

  @override
  String get eventTomorrow => 'ನಾಳೆ';

  @override
  String eventInDays(String days) {
    return '$days ದಿನಗಳಲ್ಲಿ';
  }

  @override
  String get eventsNote =>
      'ದಿನಾಂಕಗಳನ್ನು ನಿಮ್ಮ ಫೋನ್‌ನಲ್ಲೇ ಲೆಕ್ಕಹಾಕಿ ಅದರ ಟೈಮ್ ಜೋನ್‌ನಲ್ಲಿ ತೋರಿಸಲಾಗುತ್ತದೆ. ಉಲ್ಕಾವೃಷ್ಟಿಯ ಉತ್ತುಂಗ ದಿನಗಳು ಪ್ರತಿ ವರ್ಷದ ಸಾಮಾನ್ಯ ದಿನಗಳು, ಒಂದು ದಿನ ಹೆಚ್ಚು ಕಡಿಮೆ ಆಗಬಹುದು. ರಿಮೈಂಡರ್‌ಗಳು ನಿಮ್ಮ ಫೋನ್‌ನಲ್ಲೇ ಇರುತ್ತವೆ.';

  @override
  String get remindMe => 'ನನಗೆ ನೆನಪಿಸಿ';

  @override
  String reminderSet(String date) {
    return 'ಸರಿ, ನಾನು ನಿಮಗೆ $date ರಂದು ನೆನಪಿಸುತ್ತೇನೆ.';
  }

  @override
  String get reminderOff => 'ರಿಮೈಂಡರ್ ತೆಗೆದುಹಾಕಲಾಗಿದೆ.';

  @override
  String get reminderTooLate =>
      'ಈ ಘಟನೆ ತುಂಬಾ ಹತ್ತಿರವಿದೆ, ರಿಮೈಂಡರ್ ಹೊಂದಿಸಲಾಗದು.';

  @override
  String get notificationsOff =>
      'Heliora ಅಧಿಸೂಚನೆಗಳು ಆಫ್ ಆಗಿವೆ. Android ಸೆಟ್ಟಿಂಗ್‌ಗಳಲ್ಲಿ ಆನ್ ಮಾಡಿ.';

  @override
  String get reminderTomorrow => 'ನಾಳೆ ನಡೆಯಲಿದೆ';

  @override
  String get reminderToday => 'ಇಂದು ನಡೆಯುತ್ತಿದೆ';

  @override
  String get onlineTitle => 'ಆನ್‌ಲೈನ್ ಸೌಲಭ್ಯಗಳು';

  @override
  String get onlineSubtitle =>
      'ಬಾಹ್ಯಾಕಾಶ ನಿಲ್ದಾಣ ಮತ್ತು ರಾಕೆಟ್ ಉಡಾವಣೆಗಳನ್ನು ತೋರಿಸಿ. ಆಗ Heliora ಕೇವಲ wheretheiss.at, Celestrak ಮತ್ತು Launch Library 2 ಜೊತೆ ಸಂಪರ್ಕಿಸುತ್ತದೆ; ಅವು ನಿಮ್ಮ ಫೋನ್‌ನ ಇಂಟರ್ನೆಟ್ ವಿಳಾಸ ನೋಡಬಹುದು. ಬೇರೇನೂ ಕಳುಹಿಸುವುದಿಲ್ಲ. ಆರಂಭದಲ್ಲಿ ಆಫ್ ಆಗಿರುತ್ತದೆ.';

  @override
  String get turnOnOnline => 'ಆನ್‌ಲೈನ್ ಸೌಲಭ್ಯಗಳನ್ನು ಆನ್ ಮಾಡಿ';

  @override
  String get issTitle => 'ಬಾಹ್ಯಾಕಾಶ ನಿಲ್ದಾಣ';

  @override
  String get issCardHint => 'ಈಗ ಎಲ್ಲಿದೆ ಮತ್ತು ನಿಮ್ಮ ಮೇಲೆ ಯಾವಾಗ ಹಾದುಹೋಗುತ್ತದೆ';

  @override
  String get issNeedsOnline =>
      'ನಿಲ್ದಾಣ ತೋರಿಸಲು Heliora ಗೆ ಇಂಟರ್ನೆಟ್‌ನಿಂದ ಅದರ ಕಕ್ಷೆಯ ಡೇಟಾ ಬೇಕು. ಒಮ್ಮೆ ಡೌನ್‌ಲೋಡ್ ಆದರೆ ಹಲವು ದಿನ ಆಫ್‌ಲೈನ್‌ನಲ್ಲಿ ಕೆಲಸ ಮಾಡುತ್ತದೆ.';

  @override
  String get issLoading => 'ಕಕ್ಷೆಯ ಡೇಟಾ ತರಲಾಗುತ್ತಿದೆ…';

  @override
  String get issFailed =>
      'ಕಕ್ಷೆಯ ಡೇಟಾ ಸಿಗಲಿಲ್ಲ. ಇಂಟರ್ನೆಟ್ ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String issStale(String days) {
    return 'ಕಕ್ಷೆಯ ಡೇಟಾ $days ದಿನ ಹಳೆಯದು, ಆದ್ದರಿಂದ ಸ್ಥಾನ ಸ್ವಲ್ಪ ತಪ್ಪಾಗಿರಬಹುದು. ಹೊಸದನ್ನು ಪಡೆಯಲು ಇಂಟರ್ನೆಟ್‌ಗೆ ಸಂಪರ್ಕಿಸಿ.';
  }

  @override
  String get issHeight => 'ಎತ್ತರ';

  @override
  String get issSpeed => 'ವೇಗ';

  @override
  String get issFromYou => 'ನಿಮ್ಮಿಂದ ದೂರ';

  @override
  String valueKmh(String value) {
    return '$value ಕಿಮೀ/ಗಂ';
  }

  @override
  String issAboveHorizon(String direction, String degrees) {
    return 'ಈಗ ನಿಮ್ಮ ದಿಗಂತದ ಮೇಲಿದೆ! $direction ಕಡೆ ನೋಡಿ, $degrees° ಎತ್ತರ.';
  }

  @override
  String get issBelowHorizon => 'ಈಗ ನಿಮ್ಮ ದಿಗಂತದ ಕೆಳಗಿದೆ.';

  @override
  String issPassesTitle(String city) {
    return '$city ಮೇಲೆ ಮುಂದಿನ ಹಾರಾಟಗಳು';
  }

  @override
  String get issNoPasses => 'ಮುಂದಿನ 5 ದಿನಗಳಲ್ಲಿ ಉತ್ತಮ ಹಾರಾಟಗಳಿಲ್ಲ.';

  @override
  String issMaxHigh(String degrees) {
    return '$degrees° ವರೆಗೆ ಎತ್ತರ';
  }

  @override
  String issFromTo(String start, String end) {
    return '$start ಇಂದ $end ವರೆಗೆ';
  }

  @override
  String get issVisible => 'ಸುಲಭವಾಗಿ ಕಾಣುತ್ತದೆ';

  @override
  String get issHidden => 'ಕಾಣುವುದು ಕಷ್ಟ';

  @override
  String get issPassTitle => 'ಬಾಹ್ಯಾಕಾಶ ನಿಲ್ದಾಣ ನಿಮ್ಮ ಮೇಲೆ ಹಾದುಹೋಗುತ್ತಿದೆ';

  @override
  String issPassBody(String degrees, String direction) {
    return '10 ನಿಮಿಷದಲ್ಲಿ ಉದಯಿಸುತ್ತದೆ, $degrees° ವರೆಗೆ ಎತ್ತರ. $direction ಕಡೆ ನೋಡಿ.';
  }

  @override
  String get issNote =>
      'ಸ್ಥಾನಗಳನ್ನು ನಿಮ್ಮ ಫೋನ್‌ನಲ್ಲೇ ನಿಲ್ದಾಣದ ಕಕ್ಷೆಯ ಡೇಟಾದಿಂದ ಲೆಕ್ಕ ಹಾಕಲಾಗುತ್ತದೆ. ಆಕಾಶ ಕತ್ತಲಾಗಿದ್ದು ನಿಲ್ದಾಣಕ್ಕೆ ಸೂರ್ಯನ ಬೆಳಕು ಬಿದ್ದಾಗ ಸುಲಭವಾಗಿ ಕಾಣುತ್ತದೆ: ಪ್ರಕಾಶಮಾನ, ವೇಗದ ನಕ್ಷತ್ರದಂತೆ.';

  @override
  String get launchesNeedOnline =>
      'ಮುಂಬರುವ ರಾಕೆಟ್ ಉಡಾವಣೆಗಳನ್ನು ಇಲ್ಲಿ ನೋಡಲು ಆನ್‌ಲೈನ್ ಸೌಲಭ್ಯಗಳನ್ನು ಆನ್ ಮಾಡಿ.';

  @override
  String get launchesFailed =>
      'ಉಡಾವಣೆ ಪಟ್ಟಿಯನ್ನು ನವೀಕರಿಸಲಾಗಲಿಲ್ಲ. ಉಳಿಸಿದ ಪಟ್ಟಿಯನ್ನು ತೋರಿಸಲಾಗುತ್ತಿದೆ.';

  @override
  String get launchesNote =>
      'ಉಡಾವಣೆ ಸಮಯ Launch Library 2 ನಿಂದ ಬರುತ್ತದೆ ಮತ್ತು ಆಗಾಗ ಬದಲಾಗುತ್ತದೆ. ಹೆಸರು ಮತ್ತು ಸ್ಥಳಗಳು ಇಂಗ್ಲಿಷ್‌ನಲ್ಲಿವೆ.';

  @override
  String get launchReminderBody =>
      'ಸುಮಾರು ಒಂದು ಗಂಟೆಯಲ್ಲಿ ಉಡಾವಣೆ. ಸಮಯ ಬದಲಾಗಬಹುದು.';

  @override
  String get launchTimeTbd => 'ಸಮಯ ಇನ್ನೂ ನಿಗದಿಯಾಗಿಲ್ಲ';

  @override
  String get quizChoose => 'ಹಂತವನ್ನು ಆರಿಸಿ';

  @override
  String get levelEasy => 'ಸುಲಭ';

  @override
  String get levelMedium => 'ಮಧ್ಯಮ';

  @override
  String get levelHard => 'ಕಠಿಣ';

  @override
  String get levelEasyHint => 'ಗ್ರಹಗಳ ಬಗ್ಗೆ ಮೂಲ ವಿಷಯಗಳು';

  @override
  String get levelMediumHint => 'ಗ್ರಹಗಳು ಮತ್ತು ಚಂದ್ರಗಳು';

  @override
  String get levelHardHint => 'ಕಠಿಣ ಹೋಲಿಕೆಗಳು ಮತ್ತು ಕ್ರಮ';

  @override
  String get qStar => 'ಇವುಗಳಲ್ಲಿ ಯಾವುದು ನಕ್ಷತ್ರ, ಗ್ರಹವಲ್ಲ?';

  @override
  String get qDwarf => 'ಇವುಗಳಲ್ಲಿ ಯಾವುದು ಕುಬ್ಜ ಗ್ರಹ?';

  @override
  String get qMoonVisited => 'ಯಾವ ಚಂದ್ರನ ಮೇಲೆ ಮನುಷ್ಯರು ನಡೆದಿದ್ದಾರೆ?';

  @override
  String get qLargestMoon => 'ಈ ಚಂದ್ರಗಳಲ್ಲಿ ಅತಿ ದೊಡ್ಡದು ಯಾವುದು?';

  @override
  String get qSmallestMoon => 'ಈ ಚಂದ್ರಗಳಲ್ಲಿ ಅತಿ ಚಿಕ್ಕದು ಯಾವುದು?';

  @override
  String get qThickAirMoon => 'ಈ ಚಂದ್ರಗಳಲ್ಲಿ ಯಾವುದಕ್ಕೆ ದಟ್ಟ ವಾತಾವರಣ ಇದೆ?';

  @override
  String get qGeyserMoon =>
      'ಯಾವ ಚಂದ್ರ ನೀರಿನ ಚಿಲುಮೆಗಳನ್ನು ಬಾಹ್ಯಾಕಾಶಕ್ಕೆ ಚಿಮ್ಮುತ್ತದೆ?';

  @override
  String get qVolcanicMoon =>
      'ಯಾವ ಚಂದ್ರನಲ್ಲಿ ಅತಿ ಹೆಚ್ಚು ಸಕ್ರಿಯ ಜ್ವಾಲಾಮುಖಿಗಳಿವೆ?';

  @override
  String get qBackwardsMoon =>
      'ಯಾವ ಚಂದ್ರ ತನ್ನ ಗ್ರಹವನ್ನು ಹಿಮ್ಮುಖವಾಗಿ ಸುತ್ತುತ್ತದೆ?';

  @override
  String get qBiggestRocky => 'ನಾಲ್ಕು ಬಂಡೆ ಗ್ರಹಗಳಲ್ಲಿ ಅತಿ ದೊಡ್ಡದು ಯಾವುದು?';

  @override
  String get qColdestRocky => 'ನಾಲ್ಕು ಬಂಡೆ ಗ್ರಹಗಳಲ್ಲಿ ಅತಿ ತಂಪಾದದ್ದು ಯಾವುದು?';

  @override
  String get qHighestPressure =>
      'ಯಾವ ಗ್ರಹದ ಮೇಲ್ಮೈಯಲ್ಲಿ ಗಾಳಿಯ ಒತ್ತಡ ಅತಿ ಹೆಚ್ಚು?';

  @override
  String get qSecondLargest => 'ಯಾವ ಗ್ರಹ ಎರಡನೇ ಅತಿ ದೊಡ್ಡದು?';

  @override
  String get qLongestYear => 'ಯಾವ ಗ್ರಹದ ವರ್ಷ ಅತಿ ಉದ್ದ?';

  @override
  String get qShortestYear => 'ಯಾವ ಗ್ರಹದ ವರ್ಷ ಅತಿ ಚಿಕ್ಕದು?';

  @override
  String get qSmallestGiant => 'ನಾಲ್ಕು ದೈತ್ಯ ಗ್ರಹಗಳಲ್ಲಿ ಅತಿ ಚಿಕ್ಕದು ಯಾವುದು?';

  @override
  String get qRockyLongestYear =>
      'ನಾಲ್ಕು ಬಂಡೆ ಗ್ರಹಗಳಲ್ಲಿ ಯಾವುದರ ವರ್ಷ ಅತಿ ಉದ್ದ?';

  @override
  String get qFastestMoon =>
      'ಈ ಚಂದ್ರಗಳಲ್ಲಿ ಯಾವುದು ತನ್ನ ಗ್ರಹವನ್ನು ಅತಿ ವೇಗವಾಗಿ ಸುತ್ತುತ್ತದೆ?';

  @override
  String get qSlowestMoon =>
      'ಈ ಚಂದ್ರಗಳಲ್ಲಿ ಯಾವುದು ತನ್ನ ಗ್ರಹವನ್ನು ಸುತ್ತಲು ಅತಿ ಹೆಚ್ಚು ಸಮಯ ತೆಗೆದುಕೊಳ್ಳುತ್ತದೆ?';

  @override
  String get qStrongestMoonGravity =>
      'ಈ ಚಂದ್ರಗಳಲ್ಲಿ ಯಾವುದರ ಗುರುತ್ವ ಅತಿ ಹೆಚ್ಚು?';

  @override
  String get qColdestMoon => 'ಈ ಚಂದ್ರಗಳಲ್ಲಿ ಅತಿ ತಂಪಾದದ್ದು ಯಾವುದು?';

  @override
  String get qSecondLargestMoon => 'ಈ ಚಂದ್ರಗಳಲ್ಲಿ ಎರಡನೇ ಅತಿ ದೊಡ್ಡದು ಯಾವುದು?';

  @override
  String get factTitle => 'ನಿಮಗೆ ಗೊತ್ತೇ?';

  @override
  String get factTap => 'ಇನ್ನೊಂದು ವಿಷಯ ನೋಡಲು ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get factSun1 => 'ಸೌರವ್ಯೂಹದ ಒಟ್ಟು ದ್ರವ್ಯರಾಶಿಯ 99.8% ಸೂರ್ಯನಲ್ಲಿದೆ.';

  @override
  String get factSun2 =>
      'ಸೂರ್ಯನ ಬೆಳಕು ಭೂಮಿಯನ್ನು ತಲುಪಲು ಸುಮಾರು 8 ನಿಮಿಷ 20 ಸೆಕೆಂಡ್ ತೆಗೆದುಕೊಳ್ಳುತ್ತದೆ.';

  @override
  String get factMercury1 =>
      'ಬುಧದಲ್ಲಿ ಒಂದು ದಿನ, ಅಂದರೆ ಒಂದು ಸೂರ್ಯೋದಯದಿಂದ ಮುಂದಿನ ಸೂರ್ಯೋದಯದವರೆಗೆ, ಸುಮಾರು 176 ಭೂಮಿ-ದಿನಗಳಷ್ಟು. ಅದು ಅದರ ವರ್ಷದ ಎರಡರಷ್ಟು ಉದ್ದ.';

  @override
  String get factMercury2 =>
      'ಬುಧದಲ್ಲಿ ಗಾಳಿ ಬಹುತೇಕ ಇಲ್ಲ, ಆದ್ದರಿಂದ ಹಗಲಿನಲ್ಲೂ ಅದರ ಆಕಾಶ ಕಪ್ಪಾಗಿರುತ್ತದೆ ಮತ್ತು ರಾತ್ರಿಗಳು ಹೆಪ್ಪುಗಟ್ಟುವಷ್ಟು ತಂಪು.';

  @override
  String get factVenus1 =>
      'ಶುಕ್ರ ಹಿಮ್ಮುಖವಾಗಿ ತಿರುಗುತ್ತದೆ, ಆದ್ದರಿಂದ ಅಲ್ಲಿ ಸೂರ್ಯ ಪಶ್ಚಿಮದಲ್ಲಿ ಉದಯಿಸುತ್ತಾನೆ.';

  @override
  String get factVenus2 =>
      'ಸೂರ್ಯನಿಂದ ಹೆಚ್ಚು ದೂರದಲ್ಲಿದ್ದರೂ ಶುಕ್ರ ಬುಧಕ್ಕಿಂತ ಬಿಸಿ, ಏಕೆಂದರೆ ಅದರ ದಟ್ಟ ಗಾಳಿ ಶಾಖವನ್ನು ಹಿಡಿದಿಡುತ್ತದೆ.';

  @override
  String get factEarth1 =>
      'ಜೀವ ಇದೆ ಎಂದು ನಮಗೆ ಗೊತ್ತಿರುವ ಏಕೈಕ ಸ್ಥಳ ಭೂಮಿ, ಮತ್ತು ಅದರ ಮೇಲ್ಮೈಯ ಸುಮಾರು 71% ನೀರಿನಿಂದ ಆವೃತ.';

  @override
  String get factEarth2 =>
      'ಭೂಮಿ ಪರಿಪೂರ್ಣ ಚೆಂಡಲ್ಲ. ತಿರುಗುವುದರಿಂದ ಅದು ಸಮಭಾಜಕ ವೃತ್ತದ ಬಳಿ ಸ್ವಲ್ಪ ಉಬ್ಬಿದೆ.';

  @override
  String get factMars1 =>
      'ಮಂಗಳದ ಒಲಿಂಪಸ್ ಮಾನ್ಸ್ ಸೌರವ್ಯೂಹದ ಅತಿ ಎತ್ತರದ ಜ್ವಾಲಾಮುಖಿ, ಮೌಂಟ್ ಎವರೆಸ್ಟ್‌ಗಿಂತ ಸುಮಾರು ಎರಡೂವರೆ ಪಟ್ಟು ಎತ್ತರ.';

  @override
  String get factMars2 => 'ಮಂಗಳದಲ್ಲಿ ಸೂರ್ಯಾಸ್ತ ನೀಲಿಯಾಗಿ ಕಾಣುತ್ತದೆ.';

  @override
  String get factJupiter1 =>
      'ಗುರುವಿನ ದ್ರವ್ಯರಾಶಿ ಉಳಿದ ಎಲ್ಲ ಗ್ರಹಗಳ ಒಟ್ಟು ದ್ರವ್ಯರಾಶಿಯ ಎರಡರಷ್ಟಕ್ಕಿಂತ ಹೆಚ್ಚು.';

  @override
  String get factJupiter2 =>
      'ಗ್ರೇಟ್ ರೆಡ್ ಸ್ಪಾಟ್ ಭೂಮಿಗಿಂತ ದೊಡ್ಡ ಬಿರುಗಾಳಿ, ಅದನ್ನು ಜನರು 150 ವರ್ಷಗಳಿಗಿಂತ ಹೆಚ್ಚು ಕಾಲದಿಂದ ನೋಡುತ್ತಿದ್ದಾರೆ.';

  @override
  String get factSaturn1 =>
      'ಶನಿ ತನ್ನ ಗಾತ್ರಕ್ಕೆ ಎಷ್ಟು ಹಗುರ ಎಂದರೆ ಸಾಕಷ್ಟು ದೊಡ್ಡ ಟಬ್ ಸಿಕ್ಕರೆ ನೀರಿನಲ್ಲಿ ತೇಲುತ್ತದೆ.';

  @override
  String get factSaturn2 =>
      'ಶನಿಯ ಉಂಗುರಗಳು ತುಂಬ ಅಗಲ ಆದರೆ ತುಂಬ ತೆಳು: ಕೆಲವೆಡೆ ಕೇವಲ ಸುಮಾರು ಹತ್ತು ಮೀಟರ್ ದಪ್ಪ.';

  @override
  String get factUranus1 =>
      'ಯುರೇನಸ್ ಪಕ್ಕಕ್ಕೆ ಉರುಳುತ್ತಾ ಸೂರ್ಯನನ್ನು ಸುತ್ತುತ್ತದೆ, ಅದರ ಅಕ್ಷ ಸುಮಾರು 98 ಡಿಗ್ರಿ ಓರೆಯಾಗಿದೆ.';

  @override
  String get factUranus2 =>
      'ಯುರೇನಸ್ ದೂರದರ್ಶಕದಿಂದ ಕಂಡುಹಿಡಿದ ಮೊದಲ ಗ್ರಹ. ವಿಲಿಯಂ ಹರ್ಷಲ್ 1781ರಲ್ಲಿ ಅದನ್ನು ಗುರುತಿಸಿದರು.';

  @override
  String get factNeptune1 =>
      'ನೆಪ್ಚೂನ್‌ನಲ್ಲಿ ಯಾವ ಗ್ರಹಕ್ಕಿಂತಲೂ ವೇಗದ ಗಾಳಿ ಬೀಸುತ್ತದೆ, ಗಂಟೆಗೆ 2,000 ಕಿಮೀಗಿಂತ ಹೆಚ್ಚು.';

  @override
  String get factNeptune2 =>
      'ನೆಪ್ಚೂನ್ ಯಾರೂ ನೋಡುವ ಮೊದಲೇ ಗಣಿತದಿಂದ ಪತ್ತೆಯಾಯಿತು: 1846ರಲ್ಲಿ ಖಗೋಳಶಾಸ್ತ್ರಜ್ಞರು ಅದು ಎಲ್ಲಿರಬೇಕು ಎಂದು ಲೆಕ್ಕ ಹಾಕಿದರು.';

  @override
  String get factMoon1 =>
      'ಚಂದ್ರ ಪ್ರತಿ ವರ್ಷ ಭೂಮಿಯಿಂದ ಸುಮಾರು 3.8 ಸೆಂಟಿಮೀಟರ್ ಇನ್ನಷ್ಟು ದೂರ ಸರಿಯುತ್ತಾನೆ.';

  @override
  String get factMoon2 =>
      'ನಮಗೆ ಚಂದ್ರನ ಒಂದೇ ಬದಿ ಯಾವಾಗಲೂ ಕಾಣುತ್ತದೆ, ಏಕೆಂದರೆ ಭೂಮಿಯನ್ನು ಒಮ್ಮೆ ಸುತ್ತುವಾಗ ಅವನು ಸರಿಯಾಗಿ ಒಮ್ಮೆ ತಿರುಗುತ್ತಾನೆ.';

  @override
  String get factPluto1 => 'ಪ್ಲೂಟೊದಲ್ಲಿ ಒಂದು ವರ್ಷ ಸುಮಾರು 248 ಭೂಮಿ-ವರ್ಷಗಳಷ್ಟು.';

  @override
  String get factPluto2 =>
      'ಪ್ಲೂಟೊದಲ್ಲಿ ಹೆಪ್ಪುಗಟ್ಟಿದ ನೈಟ್ರೋಜನ್‌ನ ಹೃದಯಾಕಾರದ ಬೃಹತ್ ಬಯಲು ಇದೆ.';

  @override
  String get factIo1 =>
      'ಅಯೋ ನಮಗೆ ಗೊತ್ತಿರುವ ಅತಿ ಹೆಚ್ಚು ಜ್ವಾಲಾಮುಖಿಗಳಿರುವ ಲೋಕ, ಅಲ್ಲಿ ನೂರಾರು ಸಕ್ರಿಯ ಜ್ವಾಲಾಮುಖಿಗಳಿವೆ.';

  @override
  String get factIo2 =>
      'ಗುರುವಿನ ಗುರುತ್ವ ಅಯೋವನ್ನು ಅದುಮಿ ಎಳೆಯುತ್ತದೆ, ಮತ್ತು ಅದರಿಂದ ಹುಟ್ಟುವ ಶಾಖ ಅದರ ಜ್ವಾಲಾಮುಖಿಗಳಿಗೆ ಶಕ್ತಿ ನೀಡುತ್ತದೆ.';

  @override
  String get factEuropa1 =>
      'ಮಂಜುಗಡ್ಡೆಯ ಕವಚದ ಕೆಳಗೆ ಯುರೋಪಾದಲ್ಲಿ ಬಹುಶಃ ಭೂಮಿಯ ಎಲ್ಲ ಸಾಗರಗಳಿಗಿಂತ ಸುಮಾರು ಎರಡರಷ್ಟು ನೀರಿದೆ.';

  @override
  String get factEuropa2 =>
      'ಭೂಮಿಯಾಚೆ ಜೀವ ಹುಡುಕಲು ಯುರೋಪಾ ಅತ್ಯುತ್ತಮ ಸ್ಥಳಗಳಲ್ಲಿ ಒಂದು. ಯುರೋಪಾ ಕ್ಲಿಪ್ಪರ್ ನೌಕೆ ಅಲ್ಲಿಗೆ ಹೋಗುತ್ತಿದೆ.';

  @override
  String get factGanymede1 =>
      'ಗ್ಯಾನಿಮೀಡ್ ಸೌರವ್ಯೂಹದ ಅತಿ ದೊಡ್ಡ ಚಂದ್ರ. ಅದು ಬುಧಕ್ಕಿಂತಲೂ ದೊಡ್ಡದು.';

  @override
  String get factGanymede2 =>
      'ತನ್ನದೇ ಆದ ಕಾಂತಕ್ಷೇತ್ರ ಇರುವ ಏಕೈಕ ಚಂದ್ರ ಎಂದು ಗ್ಯಾನಿಮೀಡ್ ಗೊತ್ತಾಗಿದೆ.';

  @override
  String get factCallisto1 =>
      'ಕ್ಯಾಲಿಸ್ಟೊ ಸೌರವ್ಯೂಹದ ಅತಿ ಹೆಚ್ಚು ಕುಳಿಗಳಿರುವ ಸ್ಥಳಗಳಲ್ಲಿ ಒಂದು, ಮತ್ತು ಅದರ ಮೇಲ್ಮೈ ತುಂಬ ಹಳೆಯದು.';

  @override
  String get factCallisto2 =>
      'ಕ್ಯಾಲಿಸ್ಟೊ ಗುರುವಿನಿಂದ ಸಾಕಷ್ಟು ದೂರ ಇರುವುದರಿಂದ ಅದರ ಕಠಿಣ ವಿಕಿರಣ ಕಡಿಮೆ ತಗುಲುತ್ತದೆ, ಆದ್ದರಿಂದ ವಿಜ್ಞಾನಿಗಳು ಭವಿಷ್ಯದ ನೆಲೆಗೆ ಅದನ್ನು ಸೂಚಿಸಿದ್ದಾರೆ.';

  @override
  String get factTitan1 =>
      'ಟೈಟಾನ್ ದಟ್ಟ ವಾತಾವರಣ ಇರುವ ಏಕೈಕ ಚಂದ್ರ. ಅದರ ಮೇಲ್ಮೈಯಲ್ಲಿ ಗಾಳಿಯ ಒತ್ತಡ ಭೂಮಿಗಿಂತ ಹೆಚ್ಚು.';

  @override
  String get factTitan2 =>
      'ಟೈಟಾನ್‌ನಲ್ಲಿ ನದಿಗಳು ಮತ್ತು ಸರೋವರಗಳಿವೆ, ಆದರೆ ಅವುಗಳಲ್ಲಿ ನೀರಲ್ಲ, ದ್ರವ ಮೀಥೇನ್ ಮತ್ತು ಈಥೇನ್ ಇದೆ.';

  @override
  String get factEnceladus1 =>
      'ಎನ್ಸೆಲಾಡಸ್ ತನ್ನ ದಕ್ಷಿಣ ಧ್ರುವದ ಬಳಿಯ ಬಿರುಕುಗಳಿಂದ ಮಂಜುಗಡ್ಡೆ ಮತ್ತು ನೀರಿನ ಆವಿಯ ಧಾರೆಗಳನ್ನು ಬಾಹ್ಯಾಕಾಶಕ್ಕೆ ಚಿಮ್ಮುತ್ತದೆ.';

  @override
  String get factEnceladus2 =>
      'ಎನ್ಸೆಲಾಡಸ್‌ನ ಈ ಧಾರೆಗಳು ಶನಿಯ E ಉಂಗುರವನ್ನು ತುಂಬುತ್ತವೆ.';

  @override
  String get factTriton1 =>
      'ಟ್ರೈಟನ್ ನೆಪ್ಚೂನ್ ಅನ್ನು ಹಿಮ್ಮುಖವಾಗಿ ಸುತ್ತುತ್ತದೆ, ಆದ್ದರಿಂದ ಅದು ನೆಪ್ಚೂನ್ ಸೆರೆಹಿಡಿದ ಕುಬ್ಜ ಗ್ರಹ ಆಗಿದ್ದಿರಬಹುದು.';

  @override
  String get factTriton2 =>
      'ಸುಮಾರು −235 °C ನಲ್ಲಿ ಟ್ರೈಟನ್ ಸೌರವ್ಯೂಹದಲ್ಲಿ ತಾಪಮಾನ ಅಳೆದಿರುವ ಅತಿ ತಂಪಾದ ಸ್ಥಳಗಳಲ್ಲಿ ಒಂದು.';

  @override
  String get jumpInput => 'ಭೂಮಿಯ ಮೇಲೆ ನಿಮ್ಮ ಜಿಗಿತದ ಎತ್ತರ (ಸೆಂ.ಮೀ)';

  @override
  String jumpHigh(String height) {
    return 'ಜಿಗಿತ: $height';
  }

  @override
  String jumpFeelsLike(String height) {
    return 'ಭೂಮಿಯ ಮೇಲಿನ $height ಜಿಗಿತ ಇಲ್ಲಿ ಆಗುತ್ತದೆ';
  }

  @override
  String get jumpNote =>
      'ತಳ್ಳುವ ಶಕ್ತಿ ಭೂಮಿಯಲ್ಲಿರುವಷ್ಟೇ. ಸೂರ್ಯ ಮತ್ತು ಅನಿಲ ದೈತ್ಯ ಗ್ರಹಗಳ ಮೇಲೆ ನಿಲ್ಲಲು ನೆಲವೇ ಇಲ್ಲ, ಆದ್ದರಿಂದ ಇದು ಕೇವಲ ಕಲ್ಪನೆಯ ಆಟ.';

  @override
  String valueCm(String value) {
    return '$value ಸೆಂ.ಮೀ';
  }

  @override
  String valueM(String value) {
    return '$value ಮೀ';
  }

  @override
  String get eclipseTotalLunar => 'ಪೂರ್ಣ ಚಂದ್ರಗ್ರಹಣ';

  @override
  String get eclipsePartialLunar => 'ಭಾಗಶಃ ಚಂದ್ರಗ್ರಹಣ';

  @override
  String get eclipsePenumbralLunar => 'ಉಪಛಾಯಾ ಚಂದ್ರಗ್ರಹಣ';

  @override
  String get eclipseTotalSolar => 'ಪೂರ್ಣ ಸೂರ್ಯಗ್ರಹಣ';

  @override
  String get eclipseAnnularSolar => 'ಕಂಕಣ ಸೂರ್ಯಗ್ರಹಣ';

  @override
  String get eclipseHybridSolar => 'ಮಿಶ್ರ ಸೂರ್ಯಗ್ರಹಣ';

  @override
  String get eclipsePartialSolar => 'ಭಾಗಶಃ ಸೂರ್ಯಗ್ರಹಣ';

  @override
  String get eclipseTotalLunarDesc =>
      'ಚಂದ್ರ ಸಂಪೂರ್ಣವಾಗಿ ಭೂಮಿಯ ನೆರಳಿನೊಳಗೆ ಹೋಗಿ ಹೆಚ್ಚಾಗಿ ಮಂದ ಕೆಂಪಾಗಿ ಕಾಣುತ್ತದೆ. ಭೂಮಿಯ ರಾತ್ರಿಯ ಬದಿಯಲ್ಲಿರುವ ಎಲ್ಲರೂ ಇದನ್ನು ನೋಡಬಹುದು, ಮತ್ತು ಕಣ್ಣಿನಿಂದ ನೋಡುವುದು ಸುರಕ್ಷಿತ.';

  @override
  String eclipsePartialLunarDesc(String percent) {
    return 'ಚಂದ್ರನ ಒಂದು ಭಾಗ (ಅಗಲದ $percent%) ಭೂಮಿಯ ಗಾಢ ನೆರಳಿನೊಳಗೆ ಹೋಗುತ್ತದೆ. ಕಣ್ಣಿನಿಂದ ನೋಡುವುದು ಸುರಕ್ಷಿತ.';
  }

  @override
  String get eclipsePenumbralLunarDesc =>
      'ಚಂದ್ರ ಭೂಮಿಯ ಮಸುಕಾದ ಹೊರ ನೆರಳಿನ ಮೂಲಕ ಹಾದುಹೋಗುತ್ತದೆ. ಸ್ವಲ್ಪ ಮಾತ್ರ ಮಂದವಾಗುವುದರಿಂದ ಗಮನಿಸುವುದು ಕಷ್ಟ.';

  @override
  String get eclipseTotalSolarDesc =>
      'ಭೂಮಿಯ ಮೇಲೆ ಒಂದು ಕಿರಿದಾದ ಪಟ್ಟಿಯಲ್ಲಿ ಚಂದ್ರ ಸೂರ್ಯನನ್ನು ಸಂಪೂರ್ಣವಾಗಿ ಮುಚ್ಚುತ್ತಾನೆ. ಆ ಪಟ್ಟಿಯ ಹೊರಗೆ ಭಾಗಶಃ ಗ್ರಹಣ ಕಾಣುತ್ತದೆ.';

  @override
  String get eclipseAnnularSolarDesc =>
      'ಚಂದ್ರ ಸ್ವಲ್ಪ ಹೆಚ್ಚು ದೂರದಲ್ಲಿರುವುದರಿಂದ ಸೂರ್ಯನನ್ನು ಪೂರ್ಣ ಮುಚ್ಚಲಾರ, ಹೊಳೆಯುವ ಉಂಗುರ ಉಳಿಯುತ್ತದೆ. ಉಂಗುರ ಕಿರಿದಾದ ಪಟ್ಟಿಯಲ್ಲಿ ಕಾಣುತ್ತದೆ; ಅದರ ಹೊರಗೆ ಗ್ರಹಣ ಭಾಗಶಃ.';

  @override
  String get eclipseHybridSolarDesc =>
      'ತನ್ನ ಪಟ್ಟಿಯಲ್ಲಿ ಈ ಗ್ರಹಣ ಕೆಲವೆಡೆ ಪೂರ್ಣವಾಗಿಯೂ ಕೆಲವೆಡೆ ಉಂಗುರದಂತೆಯೂ ಕಾಣುತ್ತದೆ. ಪಟ್ಟಿಯ ಹೊರಗೆ ಇದು ಭಾಗಶಃ.';

  @override
  String get eclipsePartialSolarDesc =>
      'ಚಂದ್ರ ಸೂರ್ಯನ ಒಂದು ಭಾಗವನ್ನು ಮಾತ್ರ ಮುಚ್ಚುತ್ತಾನೆ, ಮತ್ತು ಭೂಮಿಯ ಮೇಲೆ ಎಲ್ಲಿಯೂ ಸೂರ್ಯ ಪೂರ್ಣ ಮುಚ್ಚುವುದಿಲ್ಲ.';

  @override
  String get eclipseNoCity =>
      'Heliora ದಲ್ಲಿ ಒಂದು ನಗರವನ್ನು ಆರಿಸಿ, ಅಲ್ಲಿಂದ ಇದನ್ನು ನೋಡಬಹುದೇ ಎಂದು ತಿಳಿಯಲು.';

  @override
  String eclipseLunarUp(String city) {
    return 'ಗ್ರಹಣದ ಮಧ್ಯದಲ್ಲಿ $city ನಲ್ಲಿ ಚಂದ್ರ ದಿಗಂತದ ಮೇಲಿರುತ್ತಾನೆ.';
  }

  @override
  String eclipseLunarPartly(String city) {
    return '$city ನಲ್ಲಿ ಚಂದ್ರ ಗ್ರಹಣದ ಸ್ವಲ್ಪ ಭಾಗದಲ್ಲಿ ಮಾತ್ರ ದಿಗಂತದ ಮೇಲಿರುತ್ತಾನೆ.';
  }

  @override
  String eclipseLunarDown(String city) {
    return '$city ನಲ್ಲಿ ಚಂದ್ರ ದಿಗಂತದ ಕೆಳಗೇ ಇರುತ್ತಾನೆ, ಹಾಗಾಗಿ ಅಲ್ಲಿಂದ ಕಾಣುವುದಿಲ್ಲ.';
  }

  @override
  String eclipseSolarNone(String city) {
    return '$city ನಿಂದ ಕಾಣುವುದಿಲ್ಲ: ಚಂದ್ರನ ನೆರಳು ಅಲ್ಲಿಗೆ ತಲುಪುವುದಿಲ್ಲ, ಅಥವಾ ಸೂರ್ಯ ದಿಗಂತದ ಕೆಳಗಿರುತ್ತಾನೆ.';
  }

  @override
  String eclipseSolarSlight(String city) {
    return '$city ನಿಂದ ಹೆಚ್ಚೆಂದರೆ ಬಹಳ ಸಣ್ಣ ಭಾಗಶಃ ಗ್ರಹಣ ಕಾಣುತ್ತದೆ, ಗಮನಿಸುವುದು ಕಷ್ಟ.';
  }

  @override
  String eclipseSolarPartial(String city, String percent) {
    return '$city ಗಾಗಿ ಸ್ಥೂಲ ಅಂದಾಜು: ಚಂದ್ರ ಹೆಚ್ಚೆಂದರೆ ಸೂರ್ಯನ ಅಗಲದ ಸುಮಾರು $percent% ಮುಚ್ಚುತ್ತಾನೆ.';
  }

  @override
  String eclipseSolarNear(String city) {
    return '$city ಸೂರ್ಯ ಬಹುತೇಕ ಅಥವಾ ಪೂರ್ತಿ ಮುಚ್ಚುವ ಪಟ್ಟಿಯ ಹತ್ತಿರವಿದೆ. ಗ್ರಹಣದ ನಕ್ಷೆ ನೋಡಿ; ಈ ಅಂದಾಜು ಸ್ಥೂಲವಾದದ್ದು.';
  }

  @override
  String get eclipseSolarSafety =>
      'ಸರಿಯಾದ ಗ್ರಹಣ ಕನ್ನಡಕವಿಲ್ಲದೆ ಎಂದಿಗೂ ಸೂರ್ಯನನ್ನು ನೋಡಬೇಡಿ.';

  @override
  String get alertsTitle => 'ಎಚ್ಚರಿಕೆಗಳು';

  @override
  String get tonightAlertSwitch => 'ಪ್ರತಿ ಸಂಜೆ ಇಂದು ರಾತ್ರಿಯ ಆಕಾಶ';

  @override
  String get tonightAlertTime => 'ಸಮಯ';

  @override
  String get tonightAlertNote =>
      'ನೀವು ಆರಿಸಿದ ಸಮಯದಲ್ಲಿ ಚಂದ್ರ ಮತ್ತು ಕಾಣುವ ಗ್ರಹಗಳ ಬಗ್ಗೆ ಒಂದು ಚಿಕ್ಕ ಸಂದೇಶ. ಇದು ನಿಮ್ಮ ಫೋನ್‌ನಲ್ಲೇ ಲೆಕ್ಕ ಹಾಕಲ್ಪಡುತ್ತದೆ, ಇಂಟರ್ನೆಟ್ ಬೇಡ. Android Heliora ಗೆ ಮುಂಚಿತವಾಗಿ ಸುಮಾರು ಎರಡು ವಾರಗಳ ಸಂದೇಶಗಳನ್ನು ಮಾತ್ರ ತಯಾರಿಸಲು ಬಿಡುತ್ತದೆ, ಹಾಗಾಗಿ ಆಗಾಗ ಆ್ಯಪ್ ತೆರೆಯಿರಿ.';

  @override
  String get tonightNotifTitle => 'ಇಂದು ರಾತ್ರಿಯ ಆಕಾಶ';

  @override
  String tonightMoon(String phase, String percent) {
    return 'ಚಂದ್ರ: $phase, $percent% ಬೆಳಕು.';
  }

  @override
  String tonightPlanets(String planets) {
    return 'ಹುಡುಕಿ: $planets.';
  }

  @override
  String get tonightNoPlanets => 'ಸಂಜೆಯ ಆಕಾಶದಲ್ಲಿ ಪ್ರಕಾಶಮಾನ ಗ್ರಹಗಳಿಲ್ಲ.';

  @override
  String get tonightNoCity => 'ಗ್ರಹಗಳನ್ನು ನೋಡಲು Heliora ದಲ್ಲಿ ನಗರ ಆರಿಸಿ.';

  @override
  String get birthdayTitle => 'ನನ್ನ ಹುಟ್ಟುಹಬ್ಬದ ಆಕಾಶ';

  @override
  String get birthdaySubtitle =>
      'ನೀವು ಹುಟ್ಟಿದ ದಿನ ಚಂದ್ರ ಮತ್ತು ಗ್ರಹಗಳು ಎಲ್ಲಿದ್ದವು, ಮತ್ತು ನಿಮ್ಮ ಜೀವನದ ವಿಶೇಷ ದಿನಗಳು.';

  @override
  String get birthdayCardHint => 'ಚಂದ್ರನ ಕಲೆ, ಗ್ರಹಗಳು ಮತ್ತು ಮೈಲಿಗಲ್ಲುಗಳು';

  @override
  String get birthdayNeedDate => 'ನಿಮ್ಮ ಜನ್ಮದಿನಾಂಕ ಹಾಕಿ';

  @override
  String get birthdayMoon => 'ನಿಮ್ಮ ಹುಟ್ಟುಹಬ್ಬದಂದು ಚಂದ್ರ';

  @override
  String get birthdayPlanets => 'ಆ ದಿನ ಗ್ರಹಗಳು';

  @override
  String birthdayDaysOld(String count) {
    return 'ಇಂದು ನಿಮಗೆ $count ದಿನಗಳಾಗಿವೆ.';
  }

  @override
  String get birthdayMilestones => 'ಮೈಲಿಗಲ್ಲುಗಳು';

  @override
  String birthdayDayN(String count) {
    return 'ದಿನ $count';
  }

  @override
  String get birthdayBillion => '100 ಕೋಟಿ ಸೆಕೆಂಡುಗಳ ವಯಸ್ಸು';

  @override
  String get birthdayPassed => 'ಆಯಿತು';

  @override
  String get birthdayNote =>
      'Heliora ದ ಉಳಿದ ಭಾಗದಂತೆಯೇ ಅದೇ ಕಕ್ಷೆಗಳಿಂದ ನಿಮ್ಮ ಫೋನ್‌ನಲ್ಲೇ ಲೆಕ್ಕ ಹಾಕಲಾಗುತ್ತದೆ. ನಿಮ್ಮ ಜನ್ಮದಿನಾಂಕ ಫೋನ್‌ನಿಂದ ಹೊರಗೆ ಹೋಗುವುದಿಲ್ಲ.';

  @override
  String get missionsTitle => 'ಬಾಹ್ಯಾಕಾಶ ಯಾನಗಳು';

  @override
  String get missionsSubtitle =>
      'ಬಾಹ್ಯಾಕಾಶ ಅನ್ವೇಷಣೆಯ ಪ್ರಸಿದ್ಧ ಕ್ಷಣಗಳು, ಹಳೆಯದು ಮೊದಲು.';

  @override
  String get missionsCardHint => 'ಕಾಲದಲ್ಲಿ ಪ್ರಸಿದ್ಧ ಯಾನಗಳು';

  @override
  String get missionSputnik1 =>
      'ಮೊದಲ ಕೃತಕ ಉಪಗ್ರಹ. ಬೀಚ್ ಬಾಲ್ ಗಾತ್ರದ ಈ ಲೋಹದ ಚೆಂಡು ಸುಮಾರು ಮೂರು ತಿಂಗಳು ಭೂಮಿಯನ್ನು ಸುತ್ತಿತು. ಅದರ ಬೀಪ್ ಶಬ್ದ ರೇಡಿಯೊದಲ್ಲಿ ಕೇಳಿಸುತ್ತಿತ್ತು, ಮತ್ತು ಇಲ್ಲಿಂದ ಬಾಹ್ಯಾಕಾಶ ಯುಗ ಶುರುವಾಯಿತು.';

  @override
  String get missionVostok1 =>
      'ಯೂರಿ ಗಗಾರಿನ್ ಬಾಹ್ಯಾಕಾಶಕ್ಕೆ ಹೋದ ಮೊದಲ ವ್ಯಕ್ತಿಯಾದರು. ಅವರು ಸುಮಾರು 108 ನಿಮಿಷಗಳಲ್ಲಿ ಭೂಮಿಯನ್ನು ಒಮ್ಮೆ ಸುತ್ತಿದರು.';

  @override
  String get missionApollo11 =>
      'ನೀಲ್ ಆರ್ಮ್‌ಸ್ಟ್ರಾಂಗ್ ಮತ್ತು ಬಜ್ ಆಲ್ಡ್ರಿನ್ ಶಾಂತಿ ಸಾಗರದಲ್ಲಿ ಇಳಿದು ಚಂದ್ರನ ಮೇಲೆ ನಡೆದ ಮೊದಲ ಮನುಷ್ಯರಾದರು. ಮೈಕೇಲ್ ಕಾಲಿನ್ಸ್ ಕಕ್ಷೆಯಲ್ಲಿ ಅವರಿಗಾಗಿ ಕಾದರು.';

  @override
  String get missionVenera7 =>
      'ಬೇರೊಂದು ಗ್ರಹದಲ್ಲಿ ಇಳಿದು ಸಂಕೇತ ಕಳುಹಿಸಿದ ಮೊದಲ ನೌಕೆ. ಶುಕ್ರನ ಜಜ್ಜುವ ಬಿಸಿಯಲ್ಲಿ ಅದು ಸುಮಾರು 23 ನಿಮಿಷ ಮಾಹಿತಿ ಕಳುಹಿಸಿತು.';

  @override
  String get missionViking1 =>
      'ಇದು ಮಂಗಳದಲ್ಲಿ ಇಳಿದು ಆರು ವರ್ಷಗಳಿಗಿಂತ ಹೆಚ್ಚು ಕೆಲಸ ಮಾಡಿತು, ಮತ್ತು ಬೇರೊಂದು ಗ್ರಹದ ನೆಲದಿಂದ ಫೋಟೋ ಹಾಗೂ ಹವಾಮಾನ ವರದಿಗಳ ಮೊದಲ ದೀರ್ಘ ಸರಣಿಯನ್ನು ಕಳುಹಿಸಿತು.';

  @override
  String get missionVoyager1 =>
      '1977 ರಲ್ಲಿ ಉಡಾಯಿಸಲಾಯಿತು, ಗುರು ಮತ್ತು ಶನಿಯ ಬಳಿ ಹಾದು 2012 ರಲ್ಲಿ ನಕ್ಷತ್ರಗಳ ನಡುವಿನ ಬಾಹ್ಯಾಕಾಶ ಪ್ರವೇಶಿಸಿತು. ಭೂಮಿಯಿಂದ ಅತಿ ದೂರದಲ್ಲಿರುವ ಮಾನವ ನಿರ್ಮಿತ ವಸ್ತು ಇದು.';

  @override
  String get missionHubble =>
      '1990 ರಲ್ಲಿ ಉಡಾಯಿಸಲಾಯಿತು, ಭೂಮಿಯ ಗಾಳಿಯ ಮೇಲಿನಿಂದ ವಿಶ್ವವನ್ನು ನೋಡುತ್ತದೆ. ಇದರ ಸ್ಪಷ್ಟ ಚಿತ್ರಗಳು ವಿಶ್ವದ ವಯಸ್ಸನ್ನು ಅಳೆಯಲು ಸಹಾಯ ಮಾಡಿದವು ಮತ್ತು ಸಾವಿರಾರು ದೂರದ ಗ್ಯಾಲಕ್ಸಿಗಳನ್ನು ತೋರಿಸಿದವು.';

  @override
  String get missionHuygens =>
      'ಕ್ಯಾಸಿನಿ ಜೊತೆ ಹೋದ ನೌಕೆ ಹೈಜೆನ್ಸ್ ಪ್ಯಾರಾಚೂಟ್‌ನಿಂದ ಶನಿಯ ಚಂದ್ರ ಟೈಟಾನ್‌ನಲ್ಲಿ ಇಳಿಯಿತು. ಹೊರ ಸೌರವ್ಯೂಹದಲ್ಲಿ ಇದು ಮೊದಲ ಇಳಿಯುವಿಕೆ, ಮತ್ತು ಅದು ನೆಲದಿಂದ ಚಿತ್ರಗಳನ್ನು ಕಳುಹಿಸಿತು.';

  @override
  String get missionCuriosity =>
      'ಕಾರಿನ ಗಾತ್ರದ ಈ ರೋವರ್ ರಾಕೆಟ್ ಚಾಲಿತ ’ಸ್ಕೈ ಕ್ರೇನ್’ ಬಳಸಿ ಗೇಲ್ ಕುಳಿಯಲ್ಲಿ ಇಳಿಯಿತು. ಮಂಗಳದಲ್ಲಿ ಒಮ್ಮೆ ಜೀವಕ್ಕೆ ಸೂಕ್ತ ಪರಿಸ್ಥಿತಿ ಇತ್ತು ಎಂದು ಅದು ಕಂಡುಹಿಡಿಯಿತು.';

  @override
  String get missionMangalyaan =>
      'ಭಾರತದ ಮಾರ್ಸ್ ಆರ್ಬಿಟರ್ ಮಿಷನ್ ಮೊದಲ ಪ್ರಯತ್ನದಲ್ಲೇ ಮಂಗಳದ ಕಕ್ಷೆ ತಲುಪಿತು. ಯಾವುದೇ ದೇಶಕ್ಕೆ ಇದು ಮೊದಲ ಬಾರಿ, ಮತ್ತು ವೆಚ್ಚವೂ ಬಹಳ ಕಡಿಮೆ.';

  @override
  String get missionRosetta =>
      'ರೊಸೆಟ್ಟಾದ ಲ್ಯಾಂಡರ್ ಫೈಲಿ ಧೂಮಕೇತು 67P/ಚುರ್ಯುಮೋವ್–ಗೆರಾಸಿಮೆಂಕೊ ಮೇಲೆ ಇಳಿಯಿತು, ಧೂಮಕೇತುವಿನ ಮೇಲೆ ಮೊದಲ ಇಳಿಯುವಿಕೆ. ರೊಸೆಟ್ಟಾ ಎರಡು ವರ್ಷ ಧೂಮಕೇತುವನ್ನು ಸುತ್ತಿತು.';

  @override
  String get missionNewhorizons =>
      'ಒಂಬತ್ತು ವರ್ಷಗಳ ಪ್ರಯಾಣದ ನಂತರ ಅದು ಪ್ಲೂಟೋ ಬಳಿ ಹಾದು, ಮೊದಲ ಬಾರಿಗೆ ಹಿಮದ ಪರ್ವತಗಳನ್ನು ಮತ್ತು ಹೃದಯಾಕಾರದ ದೊಡ್ಡ ಬಯಲನ್ನು ತೋರಿಸಿತು.';

  @override
  String get missionPerseverance =>
      'ಪರ್ಸಿವರೆನ್ಸ್ ರೋವರ್ ಹಳೆಯ ಜೀವದ ಕುರುಹುಗಳನ್ನು ಹುಡುಕಲು ಮತ್ತು ಬಂಡೆಗಳ ಮಾದರಿ ಸಂಗ್ರಹಿಸಲು ಜೆಜೆರೊ ಕುಳಿಯಲ್ಲಿ ಇಳಿಯಿತು. ಅದರ ಹೆಲಿಕಾಪ್ಟರ್ ಇಂಜೆನ್ಯುಯಿಟಿ ಬೇರೊಂದು ಗ್ರಹದಲ್ಲಿ ಮೊದಲ ಚಾಲಿತ ಹಾರಾಟ ಮಾಡಿತು.';

  @override
  String get missionJwst =>
      'ಅತಿ ದೊಡ್ಡ ಬಾಹ್ಯಾಕಾಶ ದೂರದರ್ಶಕಕ್ಕೆ 6.5 ಮೀಟರ್‌ನ ಚಿನ್ನದ ಕನ್ನಡಿ ಇದೆ, ಮತ್ತು ಅದು 15 ಲಕ್ಷ ಕಿಮೀ ದೂರದಿಂದ ಅತಿಗೆಂಪು ಬೆಳಕಿನಲ್ಲಿ ಆಕಾಶ ನೋಡುತ್ತದೆ. ಅದು ಮೊದಲ ಗ್ಯಾಲಕ್ಸಿಗಳಲ್ಲಿ ಕೆಲವನ್ನು ಕಾಣುತ್ತದೆ.';

  @override
  String get missionChandrayaan3 =>
      'ಭಾರತ ಚಂದ್ರನ ಮೇಲೆ ಸುರಕ್ಷಿತವಾಗಿ ಇಳಿದ ನಾಲ್ಕನೇ ದೇಶವಾಯಿತು, ಮತ್ತು ದಕ್ಷಿಣ ಧ್ರುವದ ಬಳಿ ಇಳಿದ ಮೊದಲ ದೇಶ. ವಿಕ್ರಮ್ ಲ್ಯಾಂಡರ್ ಪ್ರಜ್ಞಾನ್ ರೋವರ್ ಅನ್ನು ಹೊತ್ತೊಯ್ದಿತ್ತು.';

  @override
  String get spacecraftTitle => 'ಬಾಹ್ಯಾಕಾಶ ನೌಕೆಗಳು ಈಗ';

  @override
  String get spacecraftSubtitle =>
      'ಕೆಲವು ಪ್ರಸಿದ್ಧ ಬಾಹ್ಯಾಕಾಶ ನೌಕೆಗಳು ಈಗ ಭೂಮಿಯಿಂದ ಎಷ್ಟು ದೂರದಲ್ಲಿವೆ.';

  @override
  String get spacecraftCardHint =>
      'ವಾಯೇಜರ್, JWST, ಮಂಗಳದ ರೋವರ್‌ಗಳು ಮತ್ತು ಇನ್ನಷ್ಟು';

  @override
  String get spacecraftDistance => 'ಭೂಮಿಯಿಂದ ದೂರ';

  @override
  String get spacecraftAltitude => 'ಭೂಮಿಯಿಂದ ಎತ್ತರ';

  @override
  String get spacecraftInAu => 'ಖಗೋಳ ಏಕಮಾನದಲ್ಲಿ';

  @override
  String get spacecraftSpeed => 'ವೇಗ';

  @override
  String get spacecraftSignal => 'ರೇಡಿಯೊ ಸಂಕೇತಕ್ಕೆ ಬೇಕಾಗುವ ಸಮಯ';

  @override
  String get spacecraftNote =>
      'ದೂರಗಳು ಅಂದಾಜು. ದೂರದ ನೌಕೆಗಳಿಗೆ ಇವನ್ನು ಸರಾಸರಿ ವೇಗದಿಂದ ಲೆಕ್ಕಿಸಲಾಗಿದೆ; ಭೂಮಿ ಸೂರ್ಯನ ಸುತ್ತ ಚಲಿಸುವುದರಿಂದ ಸುಮಾರು 1% ತಪ್ಪಾಗಬಹುದು. ಮಂಗಳದ ದೂರವನ್ನು ಇಂದಿನ ದಿನಕ್ಕೆ ಲೆಕ್ಕಿಸಲಾಗಿದೆ. ಒಂದು AU (ಖಗೋಳ ಏಕಮಾನ) ಎಂದರೆ ಭೂಮಿಯಿಂದ ಸೂರ್ಯನಿಗೆ ಇರುವ ದೂರ.';

  @override
  String valueBillionKm(String value) {
    return '$value ಬಿಲಿಯನ್ ಕಿಮೀ';
  }

  @override
  String valueAu(String value) {
    return '$value AU';
  }

  @override
  String valueKmS(String value) {
    return '$value ಕಿಮೀ/ಸೆ';
  }

  @override
  String get spacecraftVoyager1 =>
      '1977ರಲ್ಲಿ ಉಡಾಯಿಸಲಾಯಿತು. 2012ರಲ್ಲಿ ನಕ್ಷತ್ರಗಳ ನಡುವಿನ ಬಾಹ್ಯಾಕಾಶ ಪ್ರವೇಶಿಸಿದ ಮೊದಲ ನೌಕೆ ಇದು. ಇದರ ರೇಡಿಯೊ ಸಂಕೇತ ನಮ್ಮನ್ನು ತಲುಪುವಾಗ ಸುಮಾರು ಒಂದು ದಿನದಷ್ಟು ಹಳೆಯದಾಗಿರುತ್ತದೆ.';

  @override
  String get spacecraftVoyager2 =>
      '1977ರಲ್ಲಿ ಉಡಾಯಿಸಲಾಯಿತು. ಯುರೇನಸ್ ಮತ್ತು ನೆಪ್ಚೂನ್‌ಗೆ ಭೇಟಿ ನೀಡಿದ ಏಕೈಕ ನೌಕೆ ಇದು, ಮತ್ತು 2018ರಲ್ಲಿ ನಕ್ಷತ್ರಗಳ ನಡುವಿನ ಬಾಹ್ಯಾಕಾಶ ಪ್ರವೇಶಿಸಿತು.';

  @override
  String get spacecraftNewHorizons =>
      '2015ರಲ್ಲಿ ಪ್ಲೂಟೊ ಬಳಿ ಮತ್ತು 2019ರಲ್ಲಿ ಕೈಪರ್ ಪಟ್ಟಿಯ ಕಾಯ ಅರೋಕೋತ್ ಬಳಿ ಹಾದುಹೋಯಿತು. ಇದು ಈಗಲೂ ಹೊರಗಡೆ ಸಾಗುತ್ತಿದೆ ಮತ್ತು ಈಗಲೂ ಮಾಹಿತಿ ಕಳುಹಿಸುತ್ತಿದೆ.';

  @override
  String get spacecraftJwst =>
      'ಅತಿ ದೊಡ್ಡ ಬಾಹ್ಯಾಕಾಶ ದೂರದರ್ಶಕ, 2021ರಲ್ಲಿ ಉಡಾಯಿಸಲಾಯಿತು. ಇದು L2 ಎಂಬ ಬಿಂದುವಿನ ಬಳಿ, ಭೂಮಿಯಿಂದ ಸುಮಾರು 15 ಲಕ್ಷ ಕಿಮೀ ದೂರದಲ್ಲಿದೆ, ಮತ್ತು ಇದರ ಸೂರ್ಯ-ಕವಚ ಯಾವಾಗಲೂ ಸೂರ್ಯನ ಕಡೆಗೆ ಇರುತ್ತದೆ.';

  @override
  String get spacecraftIss =>
      'ಸುಮಾರು ಪ್ರತಿ 90 ನಿಮಿಷಕ್ಕೆ ಭೂಮಿಯನ್ನು ಒಮ್ಮೆ ಸುತ್ತುತ್ತದೆ. 2000ರಿಂದ ಇದರಲ್ಲಿ ಜನರು ಅಡೆತಡೆಯಿಲ್ಲದೆ ವಾಸಿಸುತ್ತಿದ್ದಾರೆ.';

  @override
  String get spacecraftHubble =>
      '1990ರಲ್ಲಿ ಉಡಾಯಿಸಲಾಯಿತು, ಈಗಲೂ ಕೆಲಸ ಮಾಡುತ್ತಿದೆ. ಚಿತ್ರವನ್ನು ಮಂಜುಗೊಳಿಸುವ ಗಾಳಿಯ ಮೇಲೆ ಭೂಮಿಯನ್ನು ಸುತ್ತುತ್ತದೆ, ಆದ್ದರಿಂದ ಇದರ ಚಿತ್ರಗಳು ತುಂಬಾ ಸ್ಪಷ್ಟ.';

  @override
  String get spacecraftMarsRovers =>
      'ಕ್ಯೂರಿಯಾಸಿಟಿ (2012ರಲ್ಲಿ ಇಳಿಯಿತು) ಮತ್ತು ಪರ್ಸೆವರೆನ್ಸ್ (2021ರಲ್ಲಿ ಇಳಿಯಿತು) ಮಂಗಳದಲ್ಲಿ ಚಲಿಸುತ್ತಿವೆ. ಮಂಗಳದ ದೂರ ಸುಮಾರು 5.5 ಕೋಟಿ ಕಿಮೀಯಿಂದ 40 ಕೋಟಿ ಕಿಮೀಗಿಂತ ಹೆಚ್ಚಿನವರೆಗೆ ಬದಲಾಗುತ್ತದೆ.';

  @override
  String get searchTooltip => 'ಹುಡುಕಿ';

  @override
  String get searchHint => 'ಗ್ರಹ, ಚಂದ್ರ, ಯಾನಗಳನ್ನು ಹುಡುಕಿ…';

  @override
  String get searchClear => 'ಅಳಿಸಿ';

  @override
  String searchEmpty(String query) {
    return '“$query” ಗಾಗಿ ಏನೂ ಸಿಗಲಿಲ್ಲ.';
  }

  @override
  String get searchBodies => 'ಗ್ರಹಗಳು ಮತ್ತು ಚಂದ್ರರು';

  @override
  String get searchMissions => 'ಯಾನಗಳು';

  @override
  String get searchSpacecraft => 'ಬಾಹ್ಯಾಕಾಶ ನೌಕೆಗಳು';

  @override
  String get favoritesTitle => 'ಮೆಚ್ಚಿನವುಗಳು';

  @override
  String get favoritesEmpty =>
      'ಗ್ರಹ, ಯಾನ ಅಥವಾ ನೌಕೆಯ ಮೇಲಿರುವ ನಕ್ಷತ್ರವನ್ನು ಒತ್ತಿ, ಅದು ಇಲ್ಲಿ ಉಳಿಯುತ್ತದೆ.';

  @override
  String get favoriteAdd => 'ಮೆಚ್ಚಿನವುಗಳಿಗೆ ಸೇರಿಸಿ';

  @override
  String get favoriteRemove => 'ಮೆಚ್ಚಿನವುಗಳಿಂದ ತೆಗೆಯಿರಿ';

  @override
  String get textSize => 'ಅಕ್ಷರದ ಗಾತ್ರ';

  @override
  String get textSizeNormal => 'ಸಾಮಾನ್ಯ';

  @override
  String get textSizeLarge => 'ದೊಡ್ಡದು';

  @override
  String get textSizeLarger => 'ಇನ್ನೂ ದೊಡ್ಡದು';

  @override
  String get textSizeNote =>
      'Heliora ದ ಅಕ್ಷರಗಳನ್ನು ದೊಡ್ಡದಾಗಿಸುತ್ತದೆ. ಇದು ನಿಮ್ಮ ಫೋನಿನ ಸ್ವಂತ ಅಕ್ಷರ ಗಾತ್ರಕ್ಕಿಂತ ಎಂದಿಗೂ ಚಿಕ್ಕದಾಗುವುದಿಲ್ಲ.';

  @override
  String get skyOtherNight => 'ರಾತ್ರಿಯ ಆಕಾಶ';

  @override
  String get planetsThatNight => 'ಆ ರಾತ್ರಿಯ ಗ್ರಹಗಳು';

  @override
  String get previousDay => 'ಹಿಂದಿನ ದಿನ';

  @override
  String get nextDay => 'ಮುಂದಿನ ದಿನ';

  @override
  String get pickDate => 'ದಿನಾಂಕ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get backToTonight => 'ಇಂದು ರಾತ್ರಿಗೆ ಹಿಂತಿರುಗಿ';

  @override
  String get moonCalendar => 'ಚಂದ್ರ ಕ್ಯಾಲೆಂಡರ್';

  @override
  String get moonCalendarHint => 'ಪ್ರತಿ ದಿನ ಚಂದ್ರನ ಕಲೆ';

  @override
  String get previousMonth => 'ಹಿಂದಿನ ತಿಂಗಳು';

  @override
  String get nextMonth => 'ಮುಂದಿನ ತಿಂಗಳು';

  @override
  String get keyMoonDates => 'ಈ ತಿಂಗಳ ಮುಖ್ಯ ಕಲೆಗಳು';

  @override
  String get moonCalendarNote =>
      'ಕಲೆಗಳ ದಿನಾಂಕ ಮತ್ತು ಸಮಯ ನಿಮ್ಮ ಫೋನಿನ ಸಮಯ ವಲಯದಲ್ಲಿ ತೋರಿಸಲಾಗಿದೆ ಮತ್ತು ಸುಮಾರು ಒಂದು ಗಂಟೆಯ ಒಳಗೆ ಸರಿಯಾಗಿವೆ.';

  @override
  String get seeSkyThatDay => 'ಈ ದಿನದ ಆಕಾಶ ನೋಡಿ';

  @override
  String get sunLightTitle => 'ಸೂರ್ಯ ಮತ್ತು ಬೆಳಕು';

  @override
  String get firstLight => 'ಮೊದಲ ಬೆಳಕು';

  @override
  String get goldenMorningEnds => 'ಬೆಳಗಿನ ಚಿನ್ನದ ಸಮಯ ಮುಕ್ತಾಯ';

  @override
  String get solarNoon => 'ಸೂರ್ಯ ಅತ್ಯಂತ ಎತ್ತರದಲ್ಲಿ';

  @override
  String get goldenEveningStarts => 'ಸಂಜೆಯ ಚಿನ್ನದ ಸಮಯ ಆರಂಭ';

  @override
  String get lastLight => 'ಕೊನೆಯ ಬೆಳಕು';

  @override
  String get darkSky => 'ಸಂಪೂರ್ಣ ಕತ್ತಲೆಯ ಆಕಾಶ';

  @override
  String get sunDayLength => 'ಹಗಲಿನ ಅವಧಿ';

  @override
  String durationHm(String hours, String minutes) {
    return '$hours ಗಂಟೆ $minutes ನಿಮಿಷ';
  }

  @override
  String get sunNote =>
      'ಸೂರ್ಯ ಕ್ಷಿತಿಜದಿಂದ 6° ಗಿಂತ ಕಡಿಮೆ ಎತ್ತರದಲ್ಲಿರುವಾಗ ಚಿನ್ನದ ಸಮಯ. ಅದು 6° ಕೆಳಗಿರುವಾಗ ಮೊದಲ ಮತ್ತು ಕೊನೆಯ ಬೆಳಕು, 18° ಕೆಳಗಿರುವಾಗ ಆಕಾಶ ಸಂಪೂರ್ಣ ಕತ್ತಲೆ. ಸಮಯಗಳನ್ನು ನೀವು ಆರಿಸಿದ ದಿನಾಂಕಕ್ಕೆ ಲೆಕ್ಕಹಾಕಲಾಗಿದೆ.';

  @override
  String get sunStaysUp => 'ಈ ದಿನ ಸೂರ್ಯ ಮುಳುಗುವುದಿಲ್ಲ.';

  @override
  String get sunStaysDown => 'ಈ ದಿನ ಸೂರ್ಯ ಉದಯಿಸುವುದಿಲ್ಲ.';
}
