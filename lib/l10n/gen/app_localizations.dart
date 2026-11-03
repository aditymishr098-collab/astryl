import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Heliora'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Explore the Solar System, fully offline'**
  String get tagline;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get navCompare;

  /// No description provided for @navWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get navWeight;

  /// No description provided for @navQuiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get navQuiz;

  /// No description provided for @viewMode.
  ///
  /// In en, this message translates to:
  /// **'View mode'**
  String get viewMode;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notToScale.
  ///
  /// In en, this message translates to:
  /// **'Not to scale · Tap a planet to open it'**
  String get notToScale;

  /// No description provided for @dragToRotate.
  ///
  /// In en, this message translates to:
  /// **'Drag to rotate · Pinch to zoom'**
  String get dragToRotate;

  /// No description provided for @planetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Planets'**
  String get planetsTitle;

  /// No description provided for @planetMercury.
  ///
  /// In en, this message translates to:
  /// **'Mercury'**
  String get planetMercury;

  /// No description provided for @planetVenus.
  ///
  /// In en, this message translates to:
  /// **'Venus'**
  String get planetVenus;

  /// No description provided for @planetEarth.
  ///
  /// In en, this message translates to:
  /// **'Earth'**
  String get planetEarth;

  /// No description provided for @planetMars.
  ///
  /// In en, this message translates to:
  /// **'Mars'**
  String get planetMars;

  /// No description provided for @planetJupiter.
  ///
  /// In en, this message translates to:
  /// **'Jupiter'**
  String get planetJupiter;

  /// No description provided for @planetSaturn.
  ///
  /// In en, this message translates to:
  /// **'Saturn'**
  String get planetSaturn;

  /// No description provided for @planetUranus.
  ///
  /// In en, this message translates to:
  /// **'Uranus'**
  String get planetUranus;

  /// No description provided for @planetNeptune.
  ///
  /// In en, this message translates to:
  /// **'Neptune'**
  String get planetNeptune;

  /// No description provided for @planetOrder.
  ///
  /// In en, this message translates to:
  /// **'Planet {n} from the Sun'**
  String planetOrder(int n);

  /// No description provided for @openDetails.
  ///
  /// In en, this message translates to:
  /// **'Open details'**
  String get openDetails;

  /// No description provided for @diameter.
  ///
  /// In en, this message translates to:
  /// **'Diameter'**
  String get diameter;

  /// No description provided for @gravity.
  ///
  /// In en, this message translates to:
  /// **'Gravity'**
  String get gravity;

  /// No description provided for @avgTemp.
  ///
  /// In en, this message translates to:
  /// **'Average temperature'**
  String get avgTemp;

  /// No description provided for @avgTempShort.
  ///
  /// In en, this message translates to:
  /// **'Avg temp'**
  String get avgTempShort;

  /// No description provided for @dayLength.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dayLength;

  /// No description provided for @yearLength.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get yearLength;

  /// No description provided for @moons.
  ///
  /// In en, this message translates to:
  /// **'Known moons'**
  String get moons;

  /// No description provided for @moonsShort.
  ///
  /// In en, this message translates to:
  /// **'Moons'**
  String get moonsShort;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance from the Sun'**
  String get distance;

  /// No description provided for @pressure.
  ///
  /// In en, this message translates to:
  /// **'Surface pressure'**
  String get pressure;

  /// No description provided for @noSurface.
  ///
  /// In en, this message translates to:
  /// **'No solid surface'**
  String get noSurface;

  /// No description provided for @valueKm.
  ///
  /// In en, this message translates to:
  /// **'{value} km'**
  String valueKm(String value);

  /// No description provided for @valueMillionKm.
  ///
  /// In en, this message translates to:
  /// **'{value} million km'**
  String valueMillionKm(String value);

  /// No description provided for @valueHours.
  ///
  /// In en, this message translates to:
  /// **'{value} h'**
  String valueHours(String value);

  /// No description provided for @valueDays.
  ///
  /// In en, this message translates to:
  /// **'{value} days'**
  String valueDays(String value);

  /// No description provided for @valueYears.
  ///
  /// In en, this message translates to:
  /// **'{value} years'**
  String valueYears(String value);

  /// No description provided for @atmosphere.
  ///
  /// In en, this message translates to:
  /// **'Atmosphere'**
  String get atmosphere;

  /// No description provided for @thinAtmosphere.
  ///
  /// In en, this message translates to:
  /// **'Almost no atmosphere. These gases form a very thin layer called an exosphere.'**
  String get thinAtmosphere;

  /// No description provided for @oxygen.
  ///
  /// In en, this message translates to:
  /// **'Oxygen'**
  String get oxygen;

  /// No description provided for @oxygenVsEarth.
  ///
  /// In en, this message translates to:
  /// **'Oxygen vs Earth'**
  String get oxygenVsEarth;

  /// No description provided for @breathable.
  ///
  /// In en, this message translates to:
  /// **'Breathable for humans'**
  String get breathable;

  /// No description provided for @notBreathable.
  ///
  /// In en, this message translates to:
  /// **'Not breathable, a spacesuit is needed'**
  String get notBreathable;

  /// No description provided for @weightFeelsLike.
  ///
  /// In en, this message translates to:
  /// **'{weight} kg on Earth feels like'**
  String weightFeelsLike(String weight);

  /// No description provided for @gasCo2.
  ///
  /// In en, this message translates to:
  /// **'Carbon dioxide'**
  String get gasCo2;

  /// No description provided for @gasN2.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen'**
  String get gasN2;

  /// No description provided for @gasO2.
  ///
  /// In en, this message translates to:
  /// **'Oxygen'**
  String get gasO2;

  /// No description provided for @gasAr.
  ///
  /// In en, this message translates to:
  /// **'Argon'**
  String get gasAr;

  /// No description provided for @gasH2.
  ///
  /// In en, this message translates to:
  /// **'Hydrogen'**
  String get gasH2;

  /// No description provided for @gasHe.
  ///
  /// In en, this message translates to:
  /// **'Helium'**
  String get gasHe;

  /// No description provided for @gasCh4.
  ///
  /// In en, this message translates to:
  /// **'Methane'**
  String get gasCh4;

  /// No description provided for @gasNa.
  ///
  /// In en, this message translates to:
  /// **'Sodium'**
  String get gasNa;

  /// No description provided for @gasK.
  ///
  /// In en, this message translates to:
  /// **'Potassium'**
  String get gasK;

  /// No description provided for @compareTitle.
  ///
  /// In en, this message translates to:
  /// **'Compare planets'**
  String get compareTitle;

  /// No description provided for @compareHint.
  ///
  /// In en, this message translates to:
  /// **'Pick two planets to see them side by side.'**
  String get compareHint;

  /// No description provided for @weightTitle.
  ///
  /// In en, this message translates to:
  /// **'Your weight on other planets'**
  String get weightTitle;

  /// No description provided for @weightInput.
  ///
  /// In en, this message translates to:
  /// **'Your weight on Earth (kg)'**
  String get weightInput;

  /// No description provided for @gravityTimes.
  ///
  /// In en, this message translates to:
  /// **'{factor}× Earth\'s gravity'**
  String gravityTimes(String factor);

  /// No description provided for @quizTitle.
  ///
  /// In en, this message translates to:
  /// **'Planet quiz'**
  String get quizTitle;

  /// No description provided for @quizIntro.
  ///
  /// In en, this message translates to:
  /// **'10 questions about the planets and moons. How many can you get right?'**
  String get quizIntro;

  /// No description provided for @quizStart.
  ///
  /// In en, this message translates to:
  /// **'Start quiz'**
  String get quizStart;

  /// No description provided for @quizProgress.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String quizProgress(int current, int total);

  /// No description provided for @quizNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get quizNext;

  /// No description provided for @quizSeeResult.
  ///
  /// In en, this message translates to:
  /// **'See result'**
  String get quizSeeResult;

  /// No description provided for @quizCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get quizCorrect;

  /// No description provided for @quizWrong.
  ///
  /// In en, this message translates to:
  /// **'Not quite. The answer is {answer}.'**
  String quizWrong(String answer);

  /// No description provided for @quizScore.
  ///
  /// In en, this message translates to:
  /// **'You got {score} of {total}'**
  String quizScore(int score, int total);

  /// No description provided for @quizBest.
  ///
  /// In en, this message translates to:
  /// **'Best score: {score}'**
  String quizBest(int score);

  /// No description provided for @quizNewBest.
  ///
  /// In en, this message translates to:
  /// **'New best score!'**
  String get quizNewBest;

  /// No description provided for @quizAgain.
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get quizAgain;

  /// No description provided for @qLargest.
  ///
  /// In en, this message translates to:
  /// **'Which planet is the largest?'**
  String get qLargest;

  /// No description provided for @qSmallest.
  ///
  /// In en, this message translates to:
  /// **'Which planet is the smallest?'**
  String get qSmallest;

  /// No description provided for @qHottest.
  ///
  /// In en, this message translates to:
  /// **'Which planet is the hottest?'**
  String get qHottest;

  /// No description provided for @qColdest.
  ///
  /// In en, this message translates to:
  /// **'Which planet is the coldest?'**
  String get qColdest;

  /// No description provided for @qMostMoons.
  ///
  /// In en, this message translates to:
  /// **'Which planet has the most known moons?'**
  String get qMostMoons;

  /// No description provided for @qBreathable.
  ///
  /// In en, this message translates to:
  /// **'On which planet can humans breathe the air?'**
  String get qBreathable;

  /// No description provided for @qClosest.
  ///
  /// In en, this message translates to:
  /// **'Which planet is closest to the Sun?'**
  String get qClosest;

  /// No description provided for @qFarthest.
  ///
  /// In en, this message translates to:
  /// **'Which planet is farthest from the Sun?'**
  String get qFarthest;

  /// No description provided for @qStrongestGravity.
  ///
  /// In en, this message translates to:
  /// **'Which planet has the strongest gravity?'**
  String get qStrongestGravity;

  /// No description provided for @qShortestDay.
  ///
  /// In en, this message translates to:
  /// **'Which planet has the shortest day?'**
  String get qShortestDay;

  /// No description provided for @qLongestDay.
  ///
  /// In en, this message translates to:
  /// **'Which planet has the longest day?'**
  String get qLongestDay;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguage;

  /// No description provided for @languageNote.
  ///
  /// In en, this message translates to:
  /// **'20 languages · planet names too'**
  String get languageNote;

  /// No description provided for @phoneLanguage.
  ///
  /// In en, this message translates to:
  /// **'Phone language'**
  String get phoneLanguage;

  /// No description provided for @updates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get updates;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get checkForUpdates;

  /// No description provided for @checking.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get checking;

  /// No description provided for @autoUpdateCheck.
  ///
  /// In en, this message translates to:
  /// **'Check automatically once a day'**
  String get autoUpdateCheck;

  /// No description provided for @updateNote.
  ///
  /// In en, this message translates to:
  /// **'Updates come from GitHub Releases. Your settings stay on your phone.'**
  String get updateNote;

  /// No description provided for @upToDate.
  ///
  /// In en, this message translates to:
  /// **'You have the latest version.'**
  String get upToDate;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not reach GitHub. Check your internet and try again.'**
  String get updateFailed;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get updateAvailable;

  /// No description provided for @updateReady.
  ///
  /// In en, this message translates to:
  /// **'Version {version} is ready to download.'**
  String updateReady(String version);

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @sourceCode.
  ///
  /// In en, this message translates to:
  /// **'Source code on GitHub'**
  String get sourceCode;

  /// No description provided for @privacyLine.
  ///
  /// In en, this message translates to:
  /// **'Offline · No ads · No tracking'**
  String get privacyLine;

  /// No description provided for @dataSource.
  ///
  /// In en, this message translates to:
  /// **'Facts: NASA Planetary Fact Sheet'**
  String get dataSource;

  /// No description provided for @openFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link.'**
  String get openFailed;

  /// No description provided for @bodySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get bodySun;

  /// No description provided for @bodyMoon.
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get bodyMoon;

  /// No description provided for @bodyPluto.
  ///
  /// In en, this message translates to:
  /// **'Pluto'**
  String get bodyPluto;

  /// No description provided for @moonIo.
  ///
  /// In en, this message translates to:
  /// **'Io'**
  String get moonIo;

  /// No description provided for @moonEuropa.
  ///
  /// In en, this message translates to:
  /// **'Europa'**
  String get moonEuropa;

  /// No description provided for @moonGanymede.
  ///
  /// In en, this message translates to:
  /// **'Ganymede'**
  String get moonGanymede;

  /// No description provided for @moonCallisto.
  ///
  /// In en, this message translates to:
  /// **'Callisto'**
  String get moonCallisto;

  /// No description provided for @moonTitan.
  ///
  /// In en, this message translates to:
  /// **'Titan'**
  String get moonTitan;

  /// No description provided for @moonEnceladus.
  ///
  /// In en, this message translates to:
  /// **'Enceladus'**
  String get moonEnceladus;

  /// No description provided for @moonTriton.
  ///
  /// In en, this message translates to:
  /// **'Triton'**
  String get moonTriton;

  /// No description provided for @kindStar.
  ///
  /// In en, this message translates to:
  /// **'Our star, the centre of the Solar System'**
  String get kindStar;

  /// No description provided for @kindDwarf.
  ///
  /// In en, this message translates to:
  /// **'Dwarf planet'**
  String get kindDwarf;

  /// No description provided for @moonOf.
  ///
  /// In en, this message translates to:
  /// **'Moon of {planet}'**
  String moonOf(String planet);

  /// No description provided for @orbitPeriod.
  ///
  /// In en, this message translates to:
  /// **'One orbit'**
  String get orbitPeriod;

  /// No description provided for @distanceFrom.
  ///
  /// In en, this message translates to:
  /// **'Distance from {body}'**
  String distanceFrom(String body);

  /// No description provided for @composition.
  ///
  /// In en, this message translates to:
  /// **'What it is made of'**
  String get composition;

  /// No description provided for @noAtmosphere.
  ///
  /// In en, this message translates to:
  /// **'No real atmosphere, it is almost a vacuum.'**
  String get noAtmosphere;

  /// No description provided for @majorMoons.
  ///
  /// In en, this message translates to:
  /// **'Major moons'**
  String get majorMoons;

  /// No description provided for @lifeTitle.
  ///
  /// In en, this message translates to:
  /// **'Could humans live here?'**
  String get lifeTitle;

  /// No description provided for @lifeScoreShort.
  ///
  /// In en, this message translates to:
  /// **'Life score'**
  String get lifeScoreShort;

  /// No description provided for @lifeNote.
  ///
  /// In en, this message translates to:
  /// **'Scored from temperature, air pressure, oxygen, water, surface and gravity. Earth scores 10.'**
  String get lifeNote;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @waterLiquid.
  ///
  /// In en, this message translates to:
  /// **'Liquid water'**
  String get waterLiquid;

  /// No description provided for @waterIce.
  ///
  /// In en, this message translates to:
  /// **'Ice'**
  String get waterIce;

  /// No description provided for @waterOcean.
  ///
  /// In en, this message translates to:
  /// **'Ocean under the ice'**
  String get waterOcean;

  /// No description provided for @waterNone.
  ///
  /// In en, this message translates to:
  /// **'No water'**
  String get waterNone;

  /// No description provided for @surface.
  ///
  /// In en, this message translates to:
  /// **'Surface'**
  String get surface;

  /// No description provided for @solidSurface.
  ///
  /// In en, this message translates to:
  /// **'Solid surface'**
  String get solidSurface;

  /// No description provided for @lifeHome.
  ///
  /// In en, this message translates to:
  /// **'Just like home'**
  String get lifeHome;

  /// No description provided for @lifeHard.
  ///
  /// In en, this message translates to:
  /// **'Very hard, people would need a closed base and spacesuits'**
  String get lifeHard;

  /// No description provided for @lifeNo.
  ///
  /// In en, this message translates to:
  /// **'Impossible for humans'**
  String get lifeNo;

  /// No description provided for @downloadInstall.
  ///
  /// In en, this message translates to:
  /// **'Download and install'**
  String get downloadInstall;

  /// No description provided for @downloadingPercent.
  ///
  /// In en, this message translates to:
  /// **'Downloading… {percent}%'**
  String downloadingPercent(String percent);

  /// No description provided for @installNow.
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get installNow;

  /// No description provided for @allowInstalls.
  ///
  /// In en, this message translates to:
  /// **'Allow Heliora to install apps on the screen that opened, then come back and tap Install.'**
  String get allowInstalls;

  /// No description provided for @downloadFailed.
  ///
  /// In en, this message translates to:
  /// **'The download did not finish. Check your internet and try again.'**
  String get downloadFailed;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @monthBack.
  ///
  /// In en, this message translates to:
  /// **'30 days earlier'**
  String get monthBack;

  /// No description provided for @monthForward.
  ///
  /// In en, this message translates to:
  /// **'30 days later'**
  String get monthForward;

  /// No description provided for @positionsNote.
  ///
  /// In en, this message translates to:
  /// **'Real positions on this date · Sizes and distances not to scale · Tap a planet'**
  String get positionsNote;

  /// No description provided for @navYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get navYou;

  /// No description provided for @ageTitle.
  ///
  /// In en, this message translates to:
  /// **'Your age on other planets'**
  String get ageTitle;

  /// No description provided for @setBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Set your birth date'**
  String get setBirthDate;

  /// No description provided for @changeBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeBirthDate;

  /// No description provided for @nextBirthday.
  ///
  /// In en, this message translates to:
  /// **'Next birthday in {days} days'**
  String nextBirthday(String days);

  /// No description provided for @ageNote.
  ///
  /// In en, this message translates to:
  /// **'Your birth date is saved only on this phone.'**
  String get ageNote;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareText.
  ///
  /// In en, this message translates to:
  /// **'{planet} in Heliora, the free offline Solar System app: https://github.com/lumio-apps/heliora'**
  String shareText(String planet);

  /// No description provided for @shareFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not share the picture.'**
  String get shareFailed;

  /// No description provided for @travelTitle.
  ///
  /// In en, this message translates to:
  /// **'How far is it?'**
  String get travelTitle;

  /// No description provided for @distanceFromEarth.
  ///
  /// In en, this message translates to:
  /// **'Distance from Earth today'**
  String get distanceFromEarth;

  /// No description provided for @lightTime.
  ///
  /// In en, this message translates to:
  /// **'Light takes'**
  String get lightTime;

  /// No description provided for @bySpacecraft.
  ///
  /// In en, this message translates to:
  /// **'By spacecraft at 60,000 km/h'**
  String get bySpacecraft;

  /// No description provided for @byCar.
  ///
  /// In en, this message translates to:
  /// **'By car at 100 km/h'**
  String get byCar;

  /// No description provided for @valueSeconds.
  ///
  /// In en, this message translates to:
  /// **'{value} s'**
  String valueSeconds(String value);

  /// No description provided for @valueMinutes.
  ///
  /// In en, this message translates to:
  /// **'{value} min'**
  String valueMinutes(String value);

  /// No description provided for @sizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get sizeTitle;

  /// No description provided for @sizeTimes.
  ///
  /// In en, this message translates to:
  /// **'{big} is {times}× as wide as {small}.'**
  String sizeTimes(String big, String times, String small);

  /// No description provided for @sizeSimilar.
  ///
  /// In en, this message translates to:
  /// **'{a} and {b} are about the same size.'**
  String sizeSimilar(String a, String b);

  /// No description provided for @navSky.
  ///
  /// In en, this message translates to:
  /// **'Sky'**
  String get navSky;

  /// No description provided for @skyTitle.
  ///
  /// In en, this message translates to:
  /// **'Tonight\'s sky'**
  String get skyTitle;

  /// No description provided for @chooseCity.
  ///
  /// In en, this message translates to:
  /// **'Choose your city'**
  String get chooseCity;

  /// No description provided for @chooseCityHint.
  ///
  /// In en, this message translates to:
  /// **'Pick the city nearest to you to see the Moon and which planets you can spot tonight. No location permission is needed, and it stays on your phone.'**
  String get chooseCityHint;

  /// No description provided for @searchCity.
  ///
  /// In en, this message translates to:
  /// **'Search city'**
  String get searchCity;

  /// No description provided for @noCityFound.
  ///
  /// In en, this message translates to:
  /// **'No city found'**
  String get noCityFound;

  /// No description provided for @cityNote.
  ///
  /// In en, this message translates to:
  /// **'Times are in your phone\'s time zone. A planet counts as visible when it is at least 5° above the horizon in a dark sky.'**
  String get cityNote;

  /// No description provided for @illuminated.
  ///
  /// In en, this message translates to:
  /// **'{percent}% lit'**
  String illuminated(String percent);

  /// No description provided for @moonrise.
  ///
  /// In en, this message translates to:
  /// **'Moonrise'**
  String get moonrise;

  /// No description provided for @moonset.
  ///
  /// In en, this message translates to:
  /// **'Moonset'**
  String get moonset;

  /// No description provided for @sunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get sunset;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @nextFull.
  ///
  /// In en, this message translates to:
  /// **'Next full moon'**
  String get nextFull;

  /// No description provided for @nextNew.
  ///
  /// In en, this message translates to:
  /// **'Next new moon'**
  String get nextNew;

  /// No description provided for @phaseNew.
  ///
  /// In en, this message translates to:
  /// **'New moon'**
  String get phaseNew;

  /// No description provided for @phaseWaxingCrescent.
  ///
  /// In en, this message translates to:
  /// **'Waxing crescent'**
  String get phaseWaxingCrescent;

  /// No description provided for @phaseFirstQuarter.
  ///
  /// In en, this message translates to:
  /// **'First quarter'**
  String get phaseFirstQuarter;

  /// No description provided for @phaseWaxingGibbous.
  ///
  /// In en, this message translates to:
  /// **'Waxing gibbous'**
  String get phaseWaxingGibbous;

  /// No description provided for @phaseFull.
  ///
  /// In en, this message translates to:
  /// **'Full moon'**
  String get phaseFull;

  /// No description provided for @phaseWaningGibbous.
  ///
  /// In en, this message translates to:
  /// **'Waning gibbous'**
  String get phaseWaningGibbous;

  /// No description provided for @phaseLastQuarter.
  ///
  /// In en, this message translates to:
  /// **'Last quarter'**
  String get phaseLastQuarter;

  /// No description provided for @phaseWaningCrescent.
  ///
  /// In en, this message translates to:
  /// **'Waning crescent'**
  String get phaseWaningCrescent;

  /// No description provided for @planetsTonight.
  ///
  /// In en, this message translates to:
  /// **'Planets tonight'**
  String get planetsTonight;

  /// No description provided for @statusVisible.
  ///
  /// In en, this message translates to:
  /// **'Visible tonight'**
  String get statusVisible;

  /// No description provided for @statusEvening.
  ///
  /// In en, this message translates to:
  /// **'In the evening, after sunset'**
  String get statusEvening;

  /// No description provided for @statusMorning.
  ///
  /// In en, this message translates to:
  /// **'In the morning, before sunrise'**
  String get statusMorning;

  /// No description provided for @statusNotVisible.
  ///
  /// In en, this message translates to:
  /// **'Not visible tonight'**
  String get statusNotVisible;

  /// No description provided for @bestAt.
  ///
  /// In en, this message translates to:
  /// **'Best at {time}'**
  String bestAt(String time);

  /// No description provided for @altitudeDir.
  ///
  /// In en, this message translates to:
  /// **'{direction}, {degrees}° high'**
  String altitudeDir(String direction, String degrees);

  /// No description provided for @riseSet.
  ///
  /// In en, this message translates to:
  /// **'Rises {rise} · Sets {set}'**
  String riseSet(String rise, String set);

  /// No description provided for @needsTelescope.
  ///
  /// In en, this message translates to:
  /// **'Needs binoculars or a telescope'**
  String get needsTelescope;

  /// No description provided for @dirN.
  ///
  /// In en, this message translates to:
  /// **'North'**
  String get dirN;

  /// No description provided for @dirNE.
  ///
  /// In en, this message translates to:
  /// **'North-east'**
  String get dirNE;

  /// No description provided for @dirE.
  ///
  /// In en, this message translates to:
  /// **'East'**
  String get dirE;

  /// No description provided for @dirSE.
  ///
  /// In en, this message translates to:
  /// **'South-east'**
  String get dirSE;

  /// No description provided for @dirS.
  ///
  /// In en, this message translates to:
  /// **'South'**
  String get dirS;

  /// No description provided for @dirSW.
  ///
  /// In en, this message translates to:
  /// **'South-west'**
  String get dirSW;

  /// No description provided for @dirW.
  ///
  /// In en, this message translates to:
  /// **'West'**
  String get dirW;

  /// No description provided for @dirNW.
  ///
  /// In en, this message translates to:
  /// **'North-west'**
  String get dirNW;

  /// No description provided for @findPlanet.
  ///
  /// In en, this message translates to:
  /// **'Find in the sky'**
  String get findPlanet;

  /// No description provided for @finderTitle.
  ///
  /// In en, this message translates to:
  /// **'Find {name}'**
  String finderTitle(String name);

  /// No description provided for @pointPhone.
  ///
  /// In en, this message translates to:
  /// **'Hold your phone up and move it slowly around.'**
  String get pointPhone;

  /// No description provided for @turnRight.
  ///
  /// In en, this message translates to:
  /// **'Turn right {degrees}°'**
  String turnRight(String degrees);

  /// No description provided for @turnLeft.
  ///
  /// In en, this message translates to:
  /// **'Turn left {degrees}°'**
  String turnLeft(String degrees);

  /// No description provided for @tiltUp.
  ///
  /// In en, this message translates to:
  /// **'Tilt up {degrees}°'**
  String tiltUp(String degrees);

  /// No description provided for @tiltDown.
  ///
  /// In en, this message translates to:
  /// **'Tilt down {degrees}°'**
  String tiltDown(String degrees);

  /// No description provided for @onTarget.
  ///
  /// In en, this message translates to:
  /// **'{name} is right there!'**
  String onTarget(String name);

  /// No description provided for @belowHorizon.
  ///
  /// In en, this message translates to:
  /// **'{name} is below the horizon right now.'**
  String belowHorizon(String name);

  /// No description provided for @risesAt.
  ///
  /// In en, this message translates to:
  /// **'It rises at {time}.'**
  String risesAt(String time);

  /// No description provided for @noSensor.
  ///
  /// In en, this message translates to:
  /// **'This phone has no compass sensor, so the finder cannot work.'**
  String get noSensor;

  /// No description provided for @calibrate.
  ///
  /// In en, this message translates to:
  /// **'The compass needs calibrating: move your phone in a figure 8 a few times.'**
  String get calibrate;

  /// No description provided for @phoneNow.
  ///
  /// In en, this message translates to:
  /// **'Your phone points to'**
  String get phoneNow;

  /// No description provided for @finderNote.
  ///
  /// In en, this message translates to:
  /// **'Hold the phone with its back towards the sky and keep it away from magnets and metal. Never look at the Sun.'**
  String get finderNote;

  /// No description provided for @eventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Space events'**
  String get eventsTitle;

  /// No description provided for @eventsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What to look for in the sky over the next 12 months.'**
  String get eventsSubtitle;

  /// No description provided for @eventsNext.
  ///
  /// In en, this message translates to:
  /// **'Next: {event} · {when}'**
  String eventsNext(String event, String when);

  /// No description provided for @eventFullMoon.
  ///
  /// In en, this message translates to:
  /// **'Full Moon'**
  String get eventFullMoon;

  /// No description provided for @eventNewMoon.
  ///
  /// In en, this message translates to:
  /// **'New Moon'**
  String get eventNewMoon;

  /// No description provided for @eventOpposition.
  ///
  /// In en, this message translates to:
  /// **'{planet} at opposition'**
  String eventOpposition(String planet);

  /// No description provided for @eventEveningElongation.
  ///
  /// In en, this message translates to:
  /// **'{planet}: best evening view'**
  String eventEveningElongation(String planet);

  /// No description provided for @eventMorningElongation.
  ///
  /// In en, this message translates to:
  /// **'{planet}: best morning view'**
  String eventMorningElongation(String planet);

  /// No description provided for @eventConjunction.
  ///
  /// In en, this message translates to:
  /// **'{a} and {b} meet'**
  String eventConjunction(String a, String b);

  /// No description provided for @eventMarchEquinox.
  ///
  /// In en, this message translates to:
  /// **'March equinox'**
  String get eventMarchEquinox;

  /// No description provided for @eventJuneSolstice.
  ///
  /// In en, this message translates to:
  /// **'June solstice'**
  String get eventJuneSolstice;

  /// No description provided for @eventSeptemberEquinox.
  ///
  /// In en, this message translates to:
  /// **'September equinox'**
  String get eventSeptemberEquinox;

  /// No description provided for @eventDecemberSolstice.
  ///
  /// In en, this message translates to:
  /// **'December solstice'**
  String get eventDecemberSolstice;

  /// No description provided for @eventFullMoonDesc.
  ///
  /// In en, this message translates to:
  /// **'The Moon\'s whole face is lit. It rises around sunset.'**
  String get eventFullMoonDesc;

  /// No description provided for @eventNewMoonDesc.
  ///
  /// In en, this message translates to:
  /// **'The Moon is hidden. The darkest skies of the month for stars and planets.'**
  String get eventNewMoonDesc;

  /// No description provided for @eventOppositionDesc.
  ///
  /// In en, this message translates to:
  /// **'{planet} is opposite the Sun. It is at its brightest this year and up all night.'**
  String eventOppositionDesc(String planet);

  /// No description provided for @eventEveningDesc.
  ///
  /// In en, this message translates to:
  /// **'{planet} is {degrees}° from the Sun, as far as it gets. Look low in the west after sunset.'**
  String eventEveningDesc(String planet, String degrees);

  /// No description provided for @eventMorningDesc.
  ///
  /// In en, this message translates to:
  /// **'{planet} is {degrees}° from the Sun, as far as it gets. Look low in the east before sunrise.'**
  String eventMorningDesc(String planet, String degrees);

  /// No description provided for @eventConjunctionDesc.
  ///
  /// In en, this message translates to:
  /// **'They pass only {degrees}° apart in the sky.'**
  String eventConjunctionDesc(String degrees);

  /// No description provided for @eventEquinoxDesc.
  ///
  /// In en, this message translates to:
  /// **'Day and night are almost equal everywhere on Earth.'**
  String get eventEquinoxDesc;

  /// No description provided for @eventJuneSolsticeDesc.
  ///
  /// In en, this message translates to:
  /// **'Longest day in the north, shortest day in the south.'**
  String get eventJuneSolsticeDesc;

  /// No description provided for @eventDecemberSolsticeDesc.
  ///
  /// In en, this message translates to:
  /// **'Shortest day in the north, longest day in the south.'**
  String get eventDecemberSolsticeDesc;

  /// No description provided for @eventMeteorShower.
  ///
  /// In en, this message translates to:
  /// **'{shower} meteor shower'**
  String eventMeteorShower(String shower);

  /// No description provided for @eventMeteorDesc.
  ///
  /// In en, this message translates to:
  /// **'Up to about {rate} meteors an hour under a dark sky. The Moon will be {percent}% lit.'**
  String eventMeteorDesc(String rate, String percent);

  /// No description provided for @showerQuadrantids.
  ///
  /// In en, this message translates to:
  /// **'Quadrantids'**
  String get showerQuadrantids;

  /// No description provided for @showerLyrids.
  ///
  /// In en, this message translates to:
  /// **'Lyrids'**
  String get showerLyrids;

  /// No description provided for @showerEtaAquariids.
  ///
  /// In en, this message translates to:
  /// **'Eta Aquariids'**
  String get showerEtaAquariids;

  /// No description provided for @showerPerseids.
  ///
  /// In en, this message translates to:
  /// **'Perseids'**
  String get showerPerseids;

  /// No description provided for @showerOrionids.
  ///
  /// In en, this message translates to:
  /// **'Orionids'**
  String get showerOrionids;

  /// No description provided for @showerLeonids.
  ///
  /// In en, this message translates to:
  /// **'Leonids'**
  String get showerLeonids;

  /// No description provided for @showerGeminids.
  ///
  /// In en, this message translates to:
  /// **'Geminids'**
  String get showerGeminids;

  /// No description provided for @showerUrsids.
  ///
  /// In en, this message translates to:
  /// **'Ursids'**
  String get showerUrsids;

  /// No description provided for @eventToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get eventToday;

  /// No description provided for @eventTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get eventTomorrow;

  /// No description provided for @eventInDays.
  ///
  /// In en, this message translates to:
  /// **'In {days} days'**
  String eventInDays(String days);

  /// No description provided for @eventsNote.
  ///
  /// In en, this message translates to:
  /// **'Dates are worked out on your phone and shown in its time zone. Meteor shower peaks are typical yearly dates and can shift by a day. Reminders stay on your phone.'**
  String get eventsNote;

  /// No description provided for @remindMe.
  ///
  /// In en, this message translates to:
  /// **'Remind me'**
  String get remindMe;

  /// No description provided for @reminderSet.
  ///
  /// In en, this message translates to:
  /// **'Okay, I will remind you on {date}.'**
  String reminderSet(String date);

  /// No description provided for @reminderOff.
  ///
  /// In en, this message translates to:
  /// **'Reminder removed.'**
  String get reminderOff;

  /// No description provided for @reminderTooLate.
  ///
  /// In en, this message translates to:
  /// **'This event is too close to set a reminder.'**
  String get reminderTooLate;

  /// No description provided for @notificationsOff.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off for Heliora. Turn them on in Android settings.'**
  String get notificationsOff;

  /// No description provided for @reminderTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Coming up tomorrow'**
  String get reminderTomorrow;

  /// No description provided for @reminderToday.
  ///
  /// In en, this message translates to:
  /// **'Happening today'**
  String get reminderToday;

  /// No description provided for @onlineTitle.
  ///
  /// In en, this message translates to:
  /// **'Online features'**
  String get onlineTitle;

  /// No description provided for @onlineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show the space station, Tiangong, Hubble, rocket launches and space news. Heliora then contacts only wheretheiss.at, Celestrak, Launch Library 2 and the Spaceflight News API, which can see your phone’s internet address. Nothing else is sent. Off by default.'**
  String get onlineSubtitle;

  /// No description provided for @turnOnOnline.
  ///
  /// In en, this message translates to:
  /// **'Turn on online features'**
  String get turnOnOnline;

  /// No description provided for @issTitle.
  ///
  /// In en, this message translates to:
  /// **'Space station'**
  String get issTitle;

  /// No description provided for @issCardHint.
  ///
  /// In en, this message translates to:
  /// **'Where it is now and when it passes over you'**
  String get issCardHint;

  /// No description provided for @issNeedsOnline.
  ///
  /// In en, this message translates to:
  /// **'To show the station, Heliora needs its orbit data from the internet. It is downloaded once and then works offline for days.'**
  String get issNeedsOnline;

  /// No description provided for @issLoading.
  ///
  /// In en, this message translates to:
  /// **'Getting the orbit data…'**
  String get issLoading;

  /// No description provided for @issFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not get the orbit data. Check your internet and try again.'**
  String get issFailed;

  /// No description provided for @issStale.
  ///
  /// In en, this message translates to:
  /// **'The orbit data is {days} days old, so positions may be off. Connect to the internet to refresh it.'**
  String issStale(String days);

  /// No description provided for @issHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get issHeight;

  /// No description provided for @issSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get issSpeed;

  /// No description provided for @issFromYou.
  ///
  /// In en, this message translates to:
  /// **'Distance from you'**
  String get issFromYou;

  /// No description provided for @valueKmh.
  ///
  /// In en, this message translates to:
  /// **'{value} km/h'**
  String valueKmh(String value);

  /// No description provided for @issAboveHorizon.
  ///
  /// In en, this message translates to:
  /// **'Above your horizon now! Look {direction}, {degrees}° high.'**
  String issAboveHorizon(String direction, String degrees);

  /// No description provided for @issBelowHorizon.
  ///
  /// In en, this message translates to:
  /// **'Below your horizon right now.'**
  String get issBelowHorizon;

  /// No description provided for @issPassesTitle.
  ///
  /// In en, this message translates to:
  /// **'Next passes over {city}'**
  String issPassesTitle(String city);

  /// No description provided for @issNoPasses.
  ///
  /// In en, this message translates to:
  /// **'No good passes in the next 5 days.'**
  String get issNoPasses;

  /// No description provided for @issMaxHigh.
  ///
  /// In en, this message translates to:
  /// **'Up to {degrees}° high'**
  String issMaxHigh(String degrees);

  /// No description provided for @issFromTo.
  ///
  /// In en, this message translates to:
  /// **'{start} to {end}'**
  String issFromTo(String start, String end);

  /// No description provided for @issVisible.
  ///
  /// In en, this message translates to:
  /// **'Easy to see'**
  String get issVisible;

  /// No description provided for @issHidden.
  ///
  /// In en, this message translates to:
  /// **'Hard to see'**
  String get issHidden;

  /// No description provided for @issPassTitle.
  ///
  /// In en, this message translates to:
  /// **'Space station passing over you'**
  String get issPassTitle;

  /// No description provided for @issPassBody.
  ///
  /// In en, this message translates to:
  /// **'Rises in 10 minutes, up to {degrees}° high. Look {direction}.'**
  String issPassBody(String degrees, String direction);

  /// No description provided for @issNote.
  ///
  /// In en, this message translates to:
  /// **'Positions are worked out on your phone from the station\'s orbit data. A pass is easy to see when the sky is dark and the station is lit by the Sun: it looks like a bright, fast star.'**
  String get issNote;

  /// No description provided for @launchesNeedOnline.
  ///
  /// In en, this message translates to:
  /// **'Turn on online features to see upcoming rocket launches here.'**
  String get launchesNeedOnline;

  /// No description provided for @launchesFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the launch list. Showing the saved one.'**
  String get launchesFailed;

  /// No description provided for @launchesNote.
  ///
  /// In en, this message translates to:
  /// **'Launch times come from Launch Library 2 and often change. Names and places are in English.'**
  String get launchesNote;

  /// No description provided for @launchReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Lifts off in about an hour. Times can change.'**
  String get launchReminderBody;

  /// No description provided for @launchTimeTbd.
  ///
  /// In en, this message translates to:
  /// **'Time not set yet'**
  String get launchTimeTbd;

  /// No description provided for @quizChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose a level'**
  String get quizChoose;

  /// No description provided for @levelEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get levelEasy;

  /// No description provided for @levelMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get levelMedium;

  /// No description provided for @levelHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get levelHard;

  /// No description provided for @levelEasyHint.
  ///
  /// In en, this message translates to:
  /// **'The basics about the planets'**
  String get levelEasyHint;

  /// No description provided for @levelMediumHint.
  ///
  /// In en, this message translates to:
  /// **'Planets and moons'**
  String get levelMediumHint;

  /// No description provided for @levelHardHint.
  ///
  /// In en, this message translates to:
  /// **'Tricky comparisons and rankings'**
  String get levelHardHint;

  /// No description provided for @qStar.
  ///
  /// In en, this message translates to:
  /// **'Which of these is a star, not a planet?'**
  String get qStar;

  /// No description provided for @qDwarf.
  ///
  /// In en, this message translates to:
  /// **'Which of these is a dwarf planet?'**
  String get qDwarf;

  /// No description provided for @qMoonVisited.
  ///
  /// In en, this message translates to:
  /// **'Which moon have people walked on?'**
  String get qMoonVisited;

  /// No description provided for @qLargestMoon.
  ///
  /// In en, this message translates to:
  /// **'Which of these moons is the largest?'**
  String get qLargestMoon;

  /// No description provided for @qSmallestMoon.
  ///
  /// In en, this message translates to:
  /// **'Which of these moons is the smallest?'**
  String get qSmallestMoon;

  /// No description provided for @qThickAirMoon.
  ///
  /// In en, this message translates to:
  /// **'Which of these moons has a thick atmosphere?'**
  String get qThickAirMoon;

  /// No description provided for @qGeyserMoon.
  ///
  /// In en, this message translates to:
  /// **'Which moon shoots geysers of water into space?'**
  String get qGeyserMoon;

  /// No description provided for @qVolcanicMoon.
  ///
  /// In en, this message translates to:
  /// **'Which moon has the most active volcanoes?'**
  String get qVolcanicMoon;

  /// No description provided for @qBackwardsMoon.
  ///
  /// In en, this message translates to:
  /// **'Which moon goes around its planet backwards?'**
  String get qBackwardsMoon;

  /// No description provided for @qBiggestRocky.
  ///
  /// In en, this message translates to:
  /// **'Which of the four rocky planets is the biggest?'**
  String get qBiggestRocky;

  /// No description provided for @qColdestRocky.
  ///
  /// In en, this message translates to:
  /// **'Which of the four rocky planets is the coldest?'**
  String get qColdestRocky;

  /// No description provided for @qHighestPressure.
  ///
  /// In en, this message translates to:
  /// **'Which planet has the heaviest air pressure at its surface?'**
  String get qHighestPressure;

  /// No description provided for @qSecondLargest.
  ///
  /// In en, this message translates to:
  /// **'Which planet is the second largest?'**
  String get qSecondLargest;

  /// No description provided for @qLongestYear.
  ///
  /// In en, this message translates to:
  /// **'Which planet has the longest year?'**
  String get qLongestYear;

  /// No description provided for @qShortestYear.
  ///
  /// In en, this message translates to:
  /// **'Which planet has the shortest year?'**
  String get qShortestYear;

  /// No description provided for @qSmallestGiant.
  ///
  /// In en, this message translates to:
  /// **'Which of the four giant planets is the smallest?'**
  String get qSmallestGiant;

  /// No description provided for @qRockyLongestYear.
  ///
  /// In en, this message translates to:
  /// **'Which of the four rocky planets has the longest year?'**
  String get qRockyLongestYear;

  /// No description provided for @qFastestMoon.
  ///
  /// In en, this message translates to:
  /// **'Which of these moons goes around its planet the fastest?'**
  String get qFastestMoon;

  /// No description provided for @qSlowestMoon.
  ///
  /// In en, this message translates to:
  /// **'Which of these moons takes the longest to go around its planet?'**
  String get qSlowestMoon;

  /// No description provided for @qStrongestMoonGravity.
  ///
  /// In en, this message translates to:
  /// **'Which of these moons has the strongest gravity?'**
  String get qStrongestMoonGravity;

  /// No description provided for @qColdestMoon.
  ///
  /// In en, this message translates to:
  /// **'Which of these moons is the coldest?'**
  String get qColdestMoon;

  /// No description provided for @qSecondLargestMoon.
  ///
  /// In en, this message translates to:
  /// **'Which of these moons is the second largest?'**
  String get qSecondLargestMoon;

  /// No description provided for @factTitle.
  ///
  /// In en, this message translates to:
  /// **'Did you know?'**
  String get factTitle;

  /// No description provided for @factTap.
  ///
  /// In en, this message translates to:
  /// **'Tap for another fact'**
  String get factTap;

  /// No description provided for @factSun1.
  ///
  /// In en, this message translates to:
  /// **'The Sun holds 99.8% of all the mass in the solar system.'**
  String get factSun1;

  /// No description provided for @factSun2.
  ///
  /// In en, this message translates to:
  /// **'Sunlight takes about 8 minutes and 20 seconds to reach Earth.'**
  String get factSun2;

  /// No description provided for @factMercury1.
  ///
  /// In en, this message translates to:
  /// **'One day on Mercury, from sunrise to the next sunrise, lasts about 176 Earth days. That is twice as long as its year.'**
  String get factMercury1;

  /// No description provided for @factMercury2.
  ///
  /// In en, this message translates to:
  /// **'Mercury has almost no air, so its sky is black even by day, and its nights are freezing cold.'**
  String get factMercury2;

  /// No description provided for @factVenus1.
  ///
  /// In en, this message translates to:
  /// **'Venus spins backwards, so on Venus the Sun rises in the west.'**
  String get factVenus1;

  /// No description provided for @factVenus2.
  ///
  /// In en, this message translates to:
  /// **'Venus is hotter than Mercury, even though it is farther from the Sun, because its thick air traps the heat.'**
  String get factVenus2;

  /// No description provided for @factEarth1.
  ///
  /// In en, this message translates to:
  /// **'Earth is the only place we know with life, and about 71% of its surface is covered by water.'**
  String get factEarth1;

  /// No description provided for @factEarth2.
  ///
  /// In en, this message translates to:
  /// **'Earth is not a perfect ball. It bulges a little at the equator because it spins.'**
  String get factEarth2;

  /// No description provided for @factMars1.
  ///
  /// In en, this message translates to:
  /// **'Olympus Mons on Mars is the tallest volcano in the solar system, about two and a half times as tall as Mount Everest.'**
  String get factMars1;

  /// No description provided for @factMars2.
  ///
  /// In en, this message translates to:
  /// **'Sunsets on Mars look blue.'**
  String get factMars2;

  /// No description provided for @factJupiter1.
  ///
  /// In en, this message translates to:
  /// **'Jupiter has more than twice the mass of all the other planets put together.'**
  String get factJupiter1;

  /// No description provided for @factJupiter2.
  ///
  /// In en, this message translates to:
  /// **'The Great Red Spot is a storm bigger than Earth, and people have watched it for more than 150 years.'**
  String get factJupiter2;

  /// No description provided for @factSaturn1.
  ///
  /// In en, this message translates to:
  /// **'Saturn is so light for its size that it would float in water, if you could find a bathtub big enough.'**
  String get factSaturn1;

  /// No description provided for @factSaturn2.
  ///
  /// In en, this message translates to:
  /// **'Saturn\'s rings are very wide but very thin: in places only about ten metres thick.'**
  String get factSaturn2;

  /// No description provided for @factUranus1.
  ///
  /// In en, this message translates to:
  /// **'Uranus rolls around the Sun on its side, tilted by about 98 degrees.'**
  String get factUranus1;

  /// No description provided for @factUranus2.
  ///
  /// In en, this message translates to:
  /// **'Uranus was the first planet found with a telescope. William Herschel spotted it in 1781.'**
  String get factUranus2;

  /// No description provided for @factNeptune1.
  ///
  /// In en, this message translates to:
  /// **'Neptune has the fastest winds of any planet, more than 2,000 km/h.'**
  String get factNeptune1;

  /// No description provided for @factNeptune2.
  ///
  /// In en, this message translates to:
  /// **'Neptune was found with maths before anyone saw it: in 1846 astronomers worked out where it had to be.'**
  String get factNeptune2;

  /// No description provided for @factMoon1.
  ///
  /// In en, this message translates to:
  /// **'The Moon moves about 3.8 centimetres farther from Earth every year.'**
  String get factMoon1;

  /// No description provided for @factMoon2.
  ///
  /// In en, this message translates to:
  /// **'We always see the same side of the Moon, because it turns exactly once for each trip around Earth.'**
  String get factMoon2;

  /// No description provided for @factPluto1.
  ///
  /// In en, this message translates to:
  /// **'A year on Pluto lasts about 248 Earth years.'**
  String get factPluto1;

  /// No description provided for @factPluto2.
  ///
  /// In en, this message translates to:
  /// **'Pluto has a huge heart-shaped plain of frozen nitrogen.'**
  String get factPluto2;

  /// No description provided for @factIo1.
  ///
  /// In en, this message translates to:
  /// **'Io is the most volcanic world we know, with hundreds of active volcanoes.'**
  String get factIo1;

  /// No description provided for @factIo2.
  ///
  /// In en, this message translates to:
  /// **'Jupiter\'s gravity squeezes and stretches Io, and the heat from this powers its volcanoes.'**
  String get factIo2;

  /// No description provided for @factEuropa1.
  ///
  /// In en, this message translates to:
  /// **'Under its icy shell, Europa probably holds about twice as much water as all of Earth\'s oceans.'**
  String get factEuropa1;

  /// No description provided for @factEuropa2.
  ///
  /// In en, this message translates to:
  /// **'Europa is one of the best places to look for life beyond Earth. The Europa Clipper spacecraft is on its way there.'**
  String get factEuropa2;

  /// No description provided for @factGanymede1.
  ///
  /// In en, this message translates to:
  /// **'Ganymede is the largest moon in the solar system. It is even bigger than Mercury.'**
  String get factGanymede1;

  /// No description provided for @factGanymede2.
  ///
  /// In en, this message translates to:
  /// **'Ganymede is the only moon known to have a magnetic field of its own.'**
  String get factGanymede2;

  /// No description provided for @factCallisto1.
  ///
  /// In en, this message translates to:
  /// **'Callisto is one of the most heavily cratered places in the solar system, and its surface is very old.'**
  String get factCallisto1;

  /// No description provided for @factCallisto2.
  ///
  /// In en, this message translates to:
  /// **'Callisto is far enough from Jupiter to get less of its harsh radiation, so scientists have suggested it for a future base.'**
  String get factCallisto2;

  /// No description provided for @factTitan1.
  ///
  /// In en, this message translates to:
  /// **'Titan is the only moon with a thick atmosphere. Its air pressure at the surface is higher than on Earth.'**
  String get factTitan1;

  /// No description provided for @factTitan2.
  ///
  /// In en, this message translates to:
  /// **'Titan has rivers and lakes, but they hold liquid methane and ethane, not water.'**
  String get factTitan2;

  /// No description provided for @factEnceladus1.
  ///
  /// In en, this message translates to:
  /// **'Enceladus shoots jets of ice and water vapour into space through cracks near its south pole.'**
  String get factEnceladus1;

  /// No description provided for @factEnceladus2.
  ///
  /// In en, this message translates to:
  /// **'The jets of Enceladus feed Saturn\'s E ring.'**
  String get factEnceladus2;

  /// No description provided for @factTriton1.
  ///
  /// In en, this message translates to:
  /// **'Triton goes around Neptune backwards, so it was probably a dwarf planet that Neptune captured.'**
  String get factTriton1;

  /// No description provided for @factTriton2.
  ///
  /// In en, this message translates to:
  /// **'At about −235 °C, Triton is one of the coldest places anyone has measured in the solar system.'**
  String get factTriton2;

  /// No description provided for @jumpInput.
  ///
  /// In en, this message translates to:
  /// **'Your jump height on Earth (cm)'**
  String get jumpInput;

  /// No description provided for @jumpHigh.
  ///
  /// In en, this message translates to:
  /// **'Jump: {height}'**
  String jumpHigh(String height);

  /// No description provided for @jumpFeelsLike.
  ///
  /// In en, this message translates to:
  /// **'A {height} jump on Earth becomes'**
  String jumpFeelsLike(String height);

  /// No description provided for @jumpNote.
  ///
  /// In en, this message translates to:
  /// **'Same push-off as on Earth. On the Sun and the gas giants there is no ground to stand on, so this is only a thought game.'**
  String get jumpNote;

  /// No description provided for @valueCm.
  ///
  /// In en, this message translates to:
  /// **'{value} cm'**
  String valueCm(String value);

  /// No description provided for @valueM.
  ///
  /// In en, this message translates to:
  /// **'{value} m'**
  String valueM(String value);

  /// No description provided for @eclipseTotalLunar.
  ///
  /// In en, this message translates to:
  /// **'Total lunar eclipse'**
  String get eclipseTotalLunar;

  /// No description provided for @eclipsePartialLunar.
  ///
  /// In en, this message translates to:
  /// **'Partial lunar eclipse'**
  String get eclipsePartialLunar;

  /// No description provided for @eclipsePenumbralLunar.
  ///
  /// In en, this message translates to:
  /// **'Penumbral lunar eclipse'**
  String get eclipsePenumbralLunar;

  /// No description provided for @eclipseTotalSolar.
  ///
  /// In en, this message translates to:
  /// **'Total solar eclipse'**
  String get eclipseTotalSolar;

  /// No description provided for @eclipseAnnularSolar.
  ///
  /// In en, this message translates to:
  /// **'Annular solar eclipse'**
  String get eclipseAnnularSolar;

  /// No description provided for @eclipseHybridSolar.
  ///
  /// In en, this message translates to:
  /// **'Hybrid solar eclipse'**
  String get eclipseHybridSolar;

  /// No description provided for @eclipsePartialSolar.
  ///
  /// In en, this message translates to:
  /// **'Partial solar eclipse'**
  String get eclipsePartialSolar;

  /// No description provided for @eclipseTotalLunarDesc.
  ///
  /// In en, this message translates to:
  /// **'The Moon moves fully into Earth\'s shadow and often turns a dim red. Everyone on the night side of Earth can see it, and it is safe to watch with your eyes.'**
  String get eclipseTotalLunarDesc;

  /// No description provided for @eclipsePartialLunarDesc.
  ///
  /// In en, this message translates to:
  /// **'Part of the Moon ({percent}% of its width) moves into Earth\'s dark shadow. It is safe to watch with your eyes.'**
  String eclipsePartialLunarDesc(String percent);

  /// No description provided for @eclipsePenumbralLunarDesc.
  ///
  /// In en, this message translates to:
  /// **'The Moon passes through the faint outer shadow of Earth. It only dims a little, so it is hard to notice.'**
  String get eclipsePenumbralLunarDesc;

  /// No description provided for @eclipseTotalSolarDesc.
  ///
  /// In en, this message translates to:
  /// **'The Moon completely covers the Sun along a narrow path across Earth. Outside that path you see a partial eclipse.'**
  String get eclipseTotalSolarDesc;

  /// No description provided for @eclipseAnnularSolarDesc.
  ///
  /// In en, this message translates to:
  /// **'The Moon is a little too far away to cover the Sun fully, so a bright ring is left. The ring shows along a narrow path; outside it the eclipse is partial.'**
  String get eclipseAnnularSolarDesc;

  /// No description provided for @eclipseHybridSolarDesc.
  ///
  /// In en, this message translates to:
  /// **'Along its path this eclipse is total in some places and ring-shaped in others. Outside the path it is partial.'**
  String get eclipseHybridSolarDesc;

  /// No description provided for @eclipsePartialSolarDesc.
  ///
  /// In en, this message translates to:
  /// **'The Moon covers only a part of the Sun, and nowhere on Earth is the Sun fully covered.'**
  String get eclipsePartialSolarDesc;

  /// No description provided for @eclipseNoCity.
  ///
  /// In en, this message translates to:
  /// **'Choose a city in Heliora to see if you can watch it from there.'**
  String get eclipseNoCity;

  /// No description provided for @eclipseLunarUp.
  ///
  /// In en, this message translates to:
  /// **'The Moon is above the horizon in {city} at the middle of the eclipse.'**
  String eclipseLunarUp(String city);

  /// No description provided for @eclipseLunarPartly.
  ///
  /// In en, this message translates to:
  /// **'In {city} the Moon is above the horizon for only part of the eclipse.'**
  String eclipseLunarPartly(String city);

  /// No description provided for @eclipseLunarDown.
  ///
  /// In en, this message translates to:
  /// **'In {city} the Moon stays below the horizon, so you cannot see it from there.'**
  String eclipseLunarDown(String city);

  /// No description provided for @eclipseSolarNone.
  ///
  /// In en, this message translates to:
  /// **'Not visible from {city}: the Moon\'s shadow misses it, or the Sun is below the horizon.'**
  String eclipseSolarNone(String city);

  /// No description provided for @eclipseSolarSlight.
  ///
  /// In en, this message translates to:
  /// **'From {city} at most a very slight partial eclipse, hard to notice.'**
  String eclipseSolarSlight(String city);

  /// No description provided for @eclipseSolarPartial.
  ///
  /// In en, this message translates to:
  /// **'Rough estimate for {city}: the Moon covers about {percent}% of the Sun\'s width at best.'**
  String eclipseSolarPartial(String city, String percent);

  /// No description provided for @eclipseSolarNear.
  ///
  /// In en, this message translates to:
  /// **'{city} is close to the path where the Sun is almost or fully covered. Check an eclipse map; this estimate is rough.'**
  String eclipseSolarNear(String city);

  /// No description provided for @eclipseSolarSafety.
  ///
  /// In en, this message translates to:
  /// **'Never look at the Sun without proper eclipse glasses.'**
  String get eclipseSolarSafety;

  /// No description provided for @alertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alertsTitle;

  /// No description provided for @tonightAlertSwitch.
  ///
  /// In en, this message translates to:
  /// **'Tonight in the sky, every evening'**
  String get tonightAlertSwitch;

  /// No description provided for @tonightAlertTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get tonightAlertTime;

  /// No description provided for @tonightAlertNote.
  ///
  /// In en, this message translates to:
  /// **'A short note about the Moon and the planets you can see, at the time you choose. It is worked out on your phone, with no internet. Android only lets Heliora prepare about two weeks of notes ahead, so open the app now and then.'**
  String get tonightAlertNote;

  /// No description provided for @tonightNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Tonight in the sky'**
  String get tonightNotifTitle;

  /// No description provided for @tonightMoon.
  ///
  /// In en, this message translates to:
  /// **'Moon: {phase}, {percent}% lit.'**
  String tonightMoon(String phase, String percent);

  /// No description provided for @tonightPlanets.
  ///
  /// In en, this message translates to:
  /// **'Look for: {planets}.'**
  String tonightPlanets(String planets);

  /// No description provided for @tonightNoPlanets.
  ///
  /// In en, this message translates to:
  /// **'No bright planets in the evening sky.'**
  String get tonightNoPlanets;

  /// No description provided for @tonightNoCity.
  ///
  /// In en, this message translates to:
  /// **'Choose a city in Heliora to see the planets.'**
  String get tonightNoCity;

  /// No description provided for @birthdayTitle.
  ///
  /// In en, this message translates to:
  /// **'My birthday sky'**
  String get birthdayTitle;

  /// No description provided for @birthdaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'The Moon and the planets on the day you were born, and the big days of your life.'**
  String get birthdaySubtitle;

  /// No description provided for @birthdayCardHint.
  ///
  /// In en, this message translates to:
  /// **'Moon phase, planets and milestones'**
  String get birthdayCardHint;

  /// No description provided for @birthdayNeedDate.
  ///
  /// In en, this message translates to:
  /// **'Set your birth date'**
  String get birthdayNeedDate;

  /// No description provided for @birthdayMoon.
  ///
  /// In en, this message translates to:
  /// **'Moon on your birthday'**
  String get birthdayMoon;

  /// No description provided for @birthdayPlanets.
  ///
  /// In en, this message translates to:
  /// **'Planets on that day'**
  String get birthdayPlanets;

  /// No description provided for @birthdayDaysOld.
  ///
  /// In en, this message translates to:
  /// **'You are {count} days old today.'**
  String birthdayDaysOld(String count);

  /// No description provided for @birthdayMilestones.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get birthdayMilestones;

  /// No description provided for @birthdayDayN.
  ///
  /// In en, this message translates to:
  /// **'Day {count}'**
  String birthdayDayN(String count);

  /// No description provided for @birthdayBillion.
  ///
  /// In en, this message translates to:
  /// **'1 billion seconds old'**
  String get birthdayBillion;

  /// No description provided for @birthdayPassed.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get birthdayPassed;

  /// No description provided for @birthdayNote.
  ///
  /// In en, this message translates to:
  /// **'Worked out on your phone from the same orbits as the rest of Heliora. Your birth date never leaves it.'**
  String get birthdayNote;

  /// No description provided for @missionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Space missions'**
  String get missionsTitle;

  /// No description provided for @missionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Famous moments in the exploration of space, oldest first.'**
  String get missionsSubtitle;

  /// No description provided for @missionsCardHint.
  ///
  /// In en, this message translates to:
  /// **'Famous missions through time'**
  String get missionsCardHint;

  /// No description provided for @missionSputnik1.
  ///
  /// In en, this message translates to:
  /// **'The first artificial satellite. This metal ball, about the size of a beach ball, circled Earth for about three months. Its beeping could be heard on radios and it started the space age.'**
  String get missionSputnik1;

  /// No description provided for @missionVostok1.
  ///
  /// In en, this message translates to:
  /// **'Yuri Gagarin became the first person in space. He circled Earth once, in about 108 minutes.'**
  String get missionVostok1;

  /// No description provided for @missionApollo11.
  ///
  /// In en, this message translates to:
  /// **'Neil Armstrong and Buzz Aldrin landed in the Sea of Tranquility and became the first people to walk on the Moon. Michael Collins waited for them in orbit.'**
  String get missionApollo11;

  /// No description provided for @missionVenera7.
  ///
  /// In en, this message translates to:
  /// **'The first spacecraft to land on another planet and send a signal back. It sent data from Venus for about 23 minutes in the crushing heat.'**
  String get missionVenera7;

  /// No description provided for @missionViking1.
  ///
  /// In en, this message translates to:
  /// **'It landed on Mars and worked there for more than six years, sending the first long series of photos and weather reports from the surface of another planet.'**
  String get missionViking1;

  /// No description provided for @missionVoyager1.
  ///
  /// In en, this message translates to:
  /// **'Launched in 1977, it flew past Jupiter and Saturn and entered interstellar space in 2012. It is the farthest human-made object from Earth.'**
  String get missionVoyager1;

  /// No description provided for @missionHubble.
  ///
  /// In en, this message translates to:
  /// **'Launched in 1990, it looks at the universe from above Earth\'s air. Its sharp pictures helped measure the age of the universe and showed thousands of faraway galaxies.'**
  String get missionHubble;

  /// No description provided for @missionHuygens.
  ///
  /// In en, this message translates to:
  /// **'Huygens, a probe carried by Cassini, parachuted down to Saturn\'s moon Titan. It was the first landing in the outer solar system, and it sent pictures from the surface.'**
  String get missionHuygens;

  /// No description provided for @missionCuriosity.
  ///
  /// In en, this message translates to:
  /// **'This car-sized rover landed in Gale Crater using a rocket-powered sky crane. It found that Mars once had the right conditions for life.'**
  String get missionCuriosity;

  /// No description provided for @missionMangalyaan.
  ///
  /// In en, this message translates to:
  /// **'India\'s Mars Orbiter Mission reached Mars orbit on its first try, a first for any country, and at a very low cost.'**
  String get missionMangalyaan;

  /// No description provided for @missionRosetta.
  ///
  /// In en, this message translates to:
  /// **'Rosetta\'s lander Philae touched down on comet 67P/Churyumov–Gerasimenko, the first landing on a comet. Rosetta itself circled the comet for two years.'**
  String get missionRosetta;

  /// No description provided for @missionNewhorizons.
  ///
  /// In en, this message translates to:
  /// **'After a nine-year trip, it flew past Pluto and showed us icy mountains and a huge heart-shaped plain for the first time.'**
  String get missionNewhorizons;

  /// No description provided for @missionPerseverance.
  ///
  /// In en, this message translates to:
  /// **'The Perseverance rover landed in Jezero Crater to look for signs of old life and collect rock samples. Its helicopter Ingenuity made the first powered flight on another planet.'**
  String get missionPerseverance;

  /// No description provided for @missionJwst.
  ///
  /// In en, this message translates to:
  /// **'The largest space telescope has a 6.5-metre gold mirror and watches the sky in infrared light from 1.5 million km away. It sees some of the first galaxies.'**
  String get missionJwst;

  /// No description provided for @missionChandrayaan3.
  ///
  /// In en, this message translates to:
  /// **'India became the fourth country to land softly on the Moon, and the first near its south pole. The Vikram lander carried the Pragyan rover.'**
  String get missionChandrayaan3;

  /// No description provided for @spacecraftTitle.
  ///
  /// In en, this message translates to:
  /// **'Spacecraft now'**
  String get spacecraftTitle;

  /// No description provided for @spacecraftSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How far some famous spacecraft are from Earth right now.'**
  String get spacecraftSubtitle;

  /// No description provided for @spacecraftCardHint.
  ///
  /// In en, this message translates to:
  /// **'Voyager, JWST, Mars rovers and more'**
  String get spacecraftCardHint;

  /// No description provided for @spacecraftDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance from Earth'**
  String get spacecraftDistance;

  /// No description provided for @spacecraftAltitude.
  ///
  /// In en, this message translates to:
  /// **'Height above Earth'**
  String get spacecraftAltitude;

  /// No description provided for @spacecraftInAu.
  ///
  /// In en, this message translates to:
  /// **'In astronomical units'**
  String get spacecraftInAu;

  /// No description provided for @spacecraftSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get spacecraftSpeed;

  /// No description provided for @spacecraftSignal.
  ///
  /// In en, this message translates to:
  /// **'Radio signal takes'**
  String get spacecraftSignal;

  /// No description provided for @spacecraftNote.
  ///
  /// In en, this message translates to:
  /// **'Distances are estimates. For the far probes they are worked out from average speed and can be off by about 1%, because Earth moves round the Sun. The Mars distance is calculated for today. One AU (astronomical unit) is the distance from Earth to the Sun.'**
  String get spacecraftNote;

  /// No description provided for @valueBillionKm.
  ///
  /// In en, this message translates to:
  /// **'{value} billion km'**
  String valueBillionKm(String value);

  /// No description provided for @valueAu.
  ///
  /// In en, this message translates to:
  /// **'{value} AU'**
  String valueAu(String value);

  /// No description provided for @valueKmS.
  ///
  /// In en, this message translates to:
  /// **'{value} km/s'**
  String valueKmS(String value);

  /// No description provided for @spacecraftVoyager1.
  ///
  /// In en, this message translates to:
  /// **'Launched in 1977. In 2012 it became the first spacecraft to enter interstellar space. Its radio signal is already about a day old when it reaches us.'**
  String get spacecraftVoyager1;

  /// No description provided for @spacecraftVoyager2.
  ///
  /// In en, this message translates to:
  /// **'Launched in 1977. It is the only spacecraft that has visited Uranus and Neptune, and it entered interstellar space in 2018.'**
  String get spacecraftVoyager2;

  /// No description provided for @spacecraftNewHorizons.
  ///
  /// In en, this message translates to:
  /// **'Flew past Pluto in 2015 and the Kuiper Belt object Arrokoth in 2019. It is still travelling outward and still sending data.'**
  String get spacecraftNewHorizons;

  /// No description provided for @spacecraftJwst.
  ///
  /// In en, this message translates to:
  /// **'The largest space telescope, launched in 2021. It sits near a point called L2, about 1.5 million km from Earth, with its sunshield always facing the Sun.'**
  String get spacecraftJwst;

  /// No description provided for @spacecraftIss.
  ///
  /// In en, this message translates to:
  /// **'Circles Earth about every 90 minutes. People have lived on board without a break since 2000.'**
  String get spacecraftIss;

  /// No description provided for @spacecraftHubble.
  ///
  /// In en, this message translates to:
  /// **'Launched in 1990 and still working. It circles Earth above the blurring air, so its pictures are very sharp.'**
  String get spacecraftHubble;

  /// No description provided for @spacecraftMarsRovers.
  ///
  /// In en, this message translates to:
  /// **'Curiosity (landed 2012) and Perseverance (landed 2021) are driving on Mars. The distance to Mars changes from about 55 million km to over 400 million km.'**
  String get spacecraftMarsRovers;

  /// No description provided for @searchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTooltip;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search planets, moons, missions…'**
  String get searchHint;

  /// No description provided for @searchClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get searchClear;

  /// No description provided for @searchEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing found for “{query}”.'**
  String searchEmpty(String query);

  /// No description provided for @searchBodies.
  ///
  /// In en, this message translates to:
  /// **'Planets and moons'**
  String get searchBodies;

  /// No description provided for @searchMissions.
  ///
  /// In en, this message translates to:
  /// **'Missions'**
  String get searchMissions;

  /// No description provided for @searchSpacecraft.
  ///
  /// In en, this message translates to:
  /// **'Spacecraft'**
  String get searchSpacecraft;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Tap the star on a planet, mission or spacecraft to keep it here.'**
  String get favoritesEmpty;

  /// No description provided for @favoriteAdd.
  ///
  /// In en, this message translates to:
  /// **'Add to favourites'**
  String get favoriteAdd;

  /// No description provided for @favoriteRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from favourites'**
  String get favoriteRemove;

  /// No description provided for @textSize.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get textSize;

  /// No description provided for @textSizeNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get textSizeNormal;

  /// No description provided for @textSizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get textSizeLarge;

  /// No description provided for @textSizeLarger.
  ///
  /// In en, this message translates to:
  /// **'Larger'**
  String get textSizeLarger;

  /// No description provided for @textSizeNote.
  ///
  /// In en, this message translates to:
  /// **'Makes the text in Heliora bigger. It never goes below your phone\'s own text size.'**
  String get textSizeNote;

  /// No description provided for @skyOtherNight.
  ///
  /// In en, this message translates to:
  /// **'The night sky'**
  String get skyOtherNight;

  /// No description provided for @planetsThatNight.
  ///
  /// In en, this message translates to:
  /// **'Planets that night'**
  String get planetsThatNight;

  /// No description provided for @previousDay.
  ///
  /// In en, this message translates to:
  /// **'Previous day'**
  String get previousDay;

  /// No description provided for @nextDay.
  ///
  /// In en, this message translates to:
  /// **'Next day'**
  String get nextDay;

  /// No description provided for @pickDate.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get pickDate;

  /// No description provided for @backToTonight.
  ///
  /// In en, this message translates to:
  /// **'Back to tonight'**
  String get backToTonight;

  /// No description provided for @moonCalendar.
  ///
  /// In en, this message translates to:
  /// **'Moon calendar'**
  String get moonCalendar;

  /// No description provided for @moonCalendarHint.
  ///
  /// In en, this message translates to:
  /// **'The phase of the Moon on every day'**
  String get moonCalendarHint;

  /// No description provided for @previousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

  /// No description provided for @keyMoonDates.
  ///
  /// In en, this message translates to:
  /// **'Main phases this month'**
  String get keyMoonDates;

  /// No description provided for @moonCalendarNote.
  ///
  /// In en, this message translates to:
  /// **'Phase dates and times are shown in your phone\'s time zone and are accurate to within about an hour.'**
  String get moonCalendarNote;

  /// No description provided for @seeSkyThatDay.
  ///
  /// In en, this message translates to:
  /// **'See the sky on this day'**
  String get seeSkyThatDay;

  /// No description provided for @sunLightTitle.
  ///
  /// In en, this message translates to:
  /// **'Sun and light'**
  String get sunLightTitle;

  /// No description provided for @firstLight.
  ///
  /// In en, this message translates to:
  /// **'First light'**
  String get firstLight;

  /// No description provided for @goldenMorningEnds.
  ///
  /// In en, this message translates to:
  /// **'Morning golden hour ends'**
  String get goldenMorningEnds;

  /// No description provided for @solarNoon.
  ///
  /// In en, this message translates to:
  /// **'Solar noon'**
  String get solarNoon;

  /// No description provided for @goldenEveningStarts.
  ///
  /// In en, this message translates to:
  /// **'Evening golden hour starts'**
  String get goldenEveningStarts;

  /// No description provided for @lastLight.
  ///
  /// In en, this message translates to:
  /// **'Last light'**
  String get lastLight;

  /// No description provided for @darkSky.
  ///
  /// In en, this message translates to:
  /// **'Fully dark sky'**
  String get darkSky;

  /// No description provided for @sunDayLength.
  ///
  /// In en, this message translates to:
  /// **'Day length'**
  String get sunDayLength;

  /// No description provided for @durationHm.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String durationHm(String hours, String minutes);

  /// No description provided for @sunNote.
  ///
  /// In en, this message translates to:
  /// **'Golden hour is when the Sun is less than 6° above the horizon. First and last light are when it is 6° below, and the sky is fully dark when it is 18° below. Times are worked out for the date you choose.'**
  String get sunNote;

  /// No description provided for @sunStaysUp.
  ///
  /// In en, this message translates to:
  /// **'On this day the Sun does not set.'**
  String get sunStaysUp;

  /// No description provided for @sunStaysDown.
  ///
  /// In en, this message translates to:
  /// **'On this day the Sun does not rise.'**
  String get sunStaysDown;

  /// No description provided for @solarSystemTitle.
  ///
  /// In en, this message translates to:
  /// **'Solar system'**
  String get solarSystemTitle;

  /// No description provided for @starMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Star map'**
  String get starMapTitle;

  /// No description provided for @starMapCardHint.
  ///
  /// In en, this message translates to:
  /// **'Stars and constellations in your sky'**
  String get starMapCardHint;

  /// No description provided for @starMapHint.
  ///
  /// In en, this message translates to:
  /// **'Drag to look around, pinch to zoom, tap a star or a constellation.'**
  String get starMapHint;

  /// No description provided for @starsLabel.
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get starsLabel;

  /// No description provided for @constellationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Constellations'**
  String get constellationsLabel;

  /// No description provided for @starMapFind.
  ///
  /// In en, this message translates to:
  /// **'Find it'**
  String get starMapFind;

  /// No description provided for @constellationsList.
  ///
  /// In en, this message translates to:
  /// **'All constellations'**
  String get constellationsList;

  /// No description provided for @magnitudeValue.
  ///
  /// In en, this message translates to:
  /// **'Magnitude {value}'**
  String magnitudeValue(String value);

  /// No description provided for @starBelowHorizon.
  ///
  /// In en, this message translates to:
  /// **'Below the horizon at this time'**
  String get starBelowHorizon;

  /// No description provided for @starMapNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get starMapNow;

  /// No description provided for @starUnnamed.
  ///
  /// In en, this message translates to:
  /// **'Star'**
  String get starUnnamed;

  /// No description provided for @binocularsTitle.
  ///
  /// In en, this message translates to:
  /// **'Binocular guide'**
  String get binocularsTitle;

  /// No description provided for @binocularsHint.
  ///
  /// In en, this message translates to:
  /// **'What to look for with ordinary binoculars'**
  String get binocularsHint;

  /// No description provided for @binocularsIntro.
  ///
  /// In en, this message translates to:
  /// **'Hold the binoculars steady, for example with your elbows on a wall or a car roof. Away from city lights, look for dim, fuzzy patches rather than sharp stars.'**
  String get binocularsIntro;

  /// No description provided for @binocularsNote.
  ///
  /// In en, this message translates to:
  /// **'Times show when each object is highest during the dark part of the night in your chosen city. Object names are the ones used worldwide. Tap one to see it on the star map.'**
  String get binocularsNote;

  /// No description provided for @dsoCluster.
  ///
  /// In en, this message translates to:
  /// **'Star cluster'**
  String get dsoCluster;

  /// No description provided for @dsoGalaxy.
  ///
  /// In en, this message translates to:
  /// **'Galaxy'**
  String get dsoGalaxy;

  /// No description provided for @dsoNebula.
  ///
  /// In en, this message translates to:
  /// **'Nebula'**
  String get dsoNebula;

  /// No description provided for @storyOri.
  ///
  /// In en, this message translates to:
  /// **'Orion the Hunter is easy to find: three stars in a short straight line make his belt. Above the belt, orange Betelgeuse marks one shoulder; below it, blue-white Rigel marks one foot. Under the belt hangs a faint fuzzy patch, the Orion Nebula, a cloud where new stars are being born. Orion is an evening sight in winter in the north and in summer in the south.'**
  String get storyOri;

  /// No description provided for @storyUMa.
  ///
  /// In en, this message translates to:
  /// **'The seven bright stars of the Big Dipper, also called the Plough, are part of the Great Bear. The two stars at the end of the bowl, Dubhe and Merak, point the way to Polaris: follow the line upward for about five times the gap between them. From much of the north, the Big Dipper circles Polaris all night and never sets.'**
  String get storyUMa;

  /// No description provided for @storyUMi.
  ///
  /// In en, this message translates to:
  /// **'Polaris, the North Star, sits at the tip of the Little Bear’s tail. It hardly moves because it lies almost exactly above Earth’s north pole, so the whole sky seems to turn around it. Its height above the horizon equals your latitude. It is not a very bright star, but it is the most useful one for finding north. It cannot be seen from the southern half of the world.'**
  String get storyUMi;

  /// No description provided for @storyCas.
  ///
  /// In en, this message translates to:
  /// **'Cassiopeia is a W or an M, depending on the hour and the season, made of five fairly bright stars. It lies on the opposite side of Polaris from the Big Dipper, so when one is low the other is high. In the old story she was a queen who boasted of her beauty.'**
  String get storyCas;

  /// No description provided for @storyCyg.
  ///
  /// In en, this message translates to:
  /// **'Cygnus the Swan flies along the Milky Way. Its brightest stars form the Northern Cross, with Deneb at the top, the tail of the swan. Away from city lights the Milky Way looks like a pale river of light running through the swan, and binoculars show that it is made of countless faint stars. Summer and autumn evenings are the best time.'**
  String get storyCyg;

  /// No description provided for @storySco.
  ///
  /// In en, this message translates to:
  /// **'Scorpius looks like a scorpion with a curved tail ending in a hook. Its heart is red Antares, whose name means rival of Mars because the two look alike in colour. It is a summer constellation in the north, low in the south, and it passes high overhead for people in the southern half of the world.'**
  String get storySco;

  /// No description provided for @storyLeo.
  ///
  /// In en, this message translates to:
  /// **'Leo the Lion is one of the few constellations that really looks like its animal. A backward question mark of stars, the Sickle, forms the head and chest and ends at bright Regulus, the lion’s heart. The triangle of stars to the east is its hindquarters. Spring evenings are the best time in the north.'**
  String get storyLeo;

  /// No description provided for @storyTau.
  ///
  /// In en, this message translates to:
  /// **'Taurus the Bull has a V-shaped face, the Hyades cluster, with orange Aldebaran as its eye. Aldebaran looks as if it belongs to the cluster, but it is much closer to us. Higher up, the Pleiades, or Seven Sisters, is a tiny group of blue stars that most people see as six or seven. The Pleiades are known all over the world and appear in the stories of many cultures.'**
  String get storyTau;

  /// No description provided for @storyGem.
  ///
  /// In en, this message translates to:
  /// **'Gemini the Twins are marked by two bright stars, Castor and Pollux, standing side by side like the heads of two brothers. Pollux is the brighter one and has an orange tint. Castor is really a system of six stars. Look for them high in the sky on winter and spring evenings in the north.'**
  String get storyGem;

  /// No description provided for @storyLyr.
  ///
  /// In en, this message translates to:
  /// **'Lyra the Lyre is small but holds Vega, one of the brightest stars of the northern sky. Vega is blue-white and, together with Deneb in Cygnus and Altair in Aquila, forms the Summer Triangle. Right next to Vega, a small parallelogram of stars makes the body of the lyre.'**
  String get storyLyr;

  /// No description provided for @storyCru.
  ///
  /// In en, this message translates to:
  /// **'Crux, the Southern Cross, is the smallest of all the constellations but one of the most famous. Four bright stars make a cross, and the two stars of its long arm point towards the south celestial pole, so it helps travellers find south. It cannot be seen from most of the northern half of the world.'**
  String get storyCru;

  /// No description provided for @satellitesTitle.
  ///
  /// In en, this message translates to:
  /// **'Tiangong and Hubble'**
  String get satellitesTitle;

  /// No description provided for @satellitesCardHint.
  ///
  /// In en, this message translates to:
  /// **'When they fly over your city'**
  String get satellitesCardHint;

  /// No description provided for @tiangongName.
  ///
  /// In en, this message translates to:
  /// **'Tiangong'**
  String get tiangongName;

  /// No description provided for @hubbleName.
  ///
  /// In en, this message translates to:
  /// **'Hubble'**
  String get hubbleName;

  /// No description provided for @satNeedsOnline.
  ///
  /// In en, this message translates to:
  /// **'To show {name}, Heliora needs its orbit data from the internet. It is downloaded once and then works offline for days.'**
  String satNeedsOnline(String name);

  /// No description provided for @satPassTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} passing over you'**
  String satPassTitle(String name);

  /// No description provided for @satNote.
  ///
  /// In en, this message translates to:
  /// **'Positions are worked out on your phone from the orbit data. A pass is easy to see when the sky is dark and the satellite is lit by the Sun. Tiangong is bright, like a fast star. Hubble is much fainter, so binoculars help.'**
  String get satNote;

  /// No description provided for @newsTitle.
  ///
  /// In en, this message translates to:
  /// **'Space news'**
  String get newsTitle;

  /// No description provided for @newsCardHint.
  ///
  /// In en, this message translates to:
  /// **'The latest articles from space news sites'**
  String get newsCardHint;

  /// No description provided for @newsNeedsOnline.
  ///
  /// In en, this message translates to:
  /// **'Turn on online features to read the latest space news.'**
  String get newsNeedsOnline;

  /// No description provided for @newsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the news. Showing the saved articles.'**
  String get newsFailed;

  /// No description provided for @newsNone.
  ///
  /// In en, this message translates to:
  /// **'No news could be loaded. Check your internet and try again.'**
  String get newsNone;

  /// No description provided for @newsNote.
  ///
  /// In en, this message translates to:
  /// **'Articles come from the Spaceflight News API and are in English. Tapping one opens the publisher’s website in your browser. Heliora downloads no pictures.'**
  String get newsNote;

  /// No description provided for @newsOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link.'**
  String get newsOpenFailed;

  /// No description provided for @tonightShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share tonight’s sky'**
  String get tonightShareTitle;

  /// No description provided for @tonightShareHint.
  ///
  /// In en, this message translates to:
  /// **'A picture of the Moon and planets for your friends'**
  String get tonightShareHint;

  /// No description provided for @tonightShareText.
  ///
  /// In en, this message translates to:
  /// **'The sky over {city}, made with Heliora, the free offline Solar System app: https://github.com/lumio-apps/heliora'**
  String tonightShareText(String city);

  /// No description provided for @skyOverCity.
  ///
  /// In en, this message translates to:
  /// **'The sky over {city}'**
  String skyOverCity(String city);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
