// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Astryl';

  @override
  String get tagline => 'Know your space';

  @override
  String get navExplore => 'Explore';

  @override
  String get navCompare => 'Compare';

  @override
  String get navWeight => 'Weight';

  @override
  String get navQuiz => 'Quiz';

  @override
  String get viewMode => 'View mode';

  @override
  String get settings => 'Settings';

  @override
  String get notToScale => 'Not to scale · Tap a planet to open it';

  @override
  String get dragToRotate => 'Drag to rotate · Pinch to zoom';

  @override
  String get planetsTitle => 'Planets';

  @override
  String get planetMercury => 'Mercury';

  @override
  String get planetVenus => 'Venus';

  @override
  String get planetEarth => 'Earth';

  @override
  String get planetMars => 'Mars';

  @override
  String get planetJupiter => 'Jupiter';

  @override
  String get planetSaturn => 'Saturn';

  @override
  String get planetUranus => 'Uranus';

  @override
  String get planetNeptune => 'Neptune';

  @override
  String planetOrder(int n) {
    return 'Planet $n from the Sun';
  }

  @override
  String get openDetails => 'Open details';

  @override
  String get diameter => 'Diameter';

  @override
  String get gravity => 'Gravity';

  @override
  String get avgTemp => 'Average temperature';

  @override
  String get avgTempShort => 'Avg temp';

  @override
  String get dayLength => 'Day';

  @override
  String get yearLength => 'Year';

  @override
  String get moons => 'Known moons';

  @override
  String get moonsShort => 'Moons';

  @override
  String get distance => 'Distance from the Sun';

  @override
  String get pressure => 'Surface pressure';

  @override
  String get noSurface => 'No solid surface';

  @override
  String valueKm(String value) {
    return '$value km';
  }

  @override
  String valueMillionKm(String value) {
    return '$value million km';
  }

  @override
  String valueHours(String value) {
    return '$value h';
  }

  @override
  String valueDays(String value) {
    return '$value days';
  }

  @override
  String valueYears(String value) {
    return '$value years';
  }

  @override
  String get atmosphere => 'Atmosphere';

  @override
  String get thinAtmosphere =>
      'Almost no atmosphere. These gases form a very thin layer called an exosphere.';

  @override
  String get oxygen => 'Oxygen';

  @override
  String get oxygenVsEarth => 'Oxygen vs Earth';

  @override
  String get breathable => 'Breathable for humans';

  @override
  String get notBreathable => 'Not breathable, a spacesuit is needed';

  @override
  String weightFeelsLike(String weight) {
    return '$weight kg on Earth feels like';
  }

  @override
  String get gasCo2 => 'Carbon dioxide';

  @override
  String get gasN2 => 'Nitrogen';

  @override
  String get gasO2 => 'Oxygen';

  @override
  String get gasAr => 'Argon';

  @override
  String get gasH2 => 'Hydrogen';

  @override
  String get gasHe => 'Helium';

  @override
  String get gasCh4 => 'Methane';

  @override
  String get gasNa => 'Sodium';

  @override
  String get gasK => 'Potassium';

  @override
  String get compareTitle => 'Compare planets';

  @override
  String get compareHint => 'Pick two planets to see them side by side.';

  @override
  String get weightTitle => 'Your weight on other planets';

  @override
  String get weightInput => 'Your weight on Earth (kg)';

  @override
  String gravityTimes(String factor) {
    return '$factor× Earth\'s gravity';
  }

  @override
  String get quizTitle => 'Planet quiz';

  @override
  String get quizIntro =>
      '10 questions about the planets and moons. How many can you get right?';

  @override
  String get quizStart => 'Start quiz';

  @override
  String quizProgress(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get quizNext => 'Next';

  @override
  String get quizSeeResult => 'See result';

  @override
  String get quizCorrect => 'Correct!';

  @override
  String quizWrong(String answer) {
    return 'Not quite. The answer is $answer.';
  }

  @override
  String quizScore(int score, int total) {
    return 'You got $score of $total';
  }

  @override
  String quizBest(int score) {
    return 'Best score: $score';
  }

  @override
  String get quizNewBest => 'New best score!';

  @override
  String get quizAgain => 'Play again';

  @override
  String get qLargest => 'Which planet is the largest?';

  @override
  String get qSmallest => 'Which planet is the smallest?';

  @override
  String get qHottest => 'Which planet is the hottest?';

  @override
  String get qColdest => 'Which planet is the coldest?';

  @override
  String get qMostMoons => 'Which planet has the most known moons?';

  @override
  String get qBreathable => 'On which planet can humans breathe the air?';

  @override
  String get qClosest => 'Which planet is closest to the Sun?';

  @override
  String get qFarthest => 'Which planet is farthest from the Sun?';

  @override
  String get qStrongestGravity => 'Which planet has the strongest gravity?';

  @override
  String get qShortestDay => 'Which planet has the shortest day?';

  @override
  String get qLongestDay => 'Which planet has the longest day?';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get appLanguage => 'App language';

  @override
  String get languageNote => '20 languages · planet names too';

  @override
  String get phoneLanguage => 'Phone language';

  @override
  String get updates => 'Updates';

  @override
  String get version => 'Version';

  @override
  String get checkForUpdates => 'Check for updates';

  @override
  String get checking => 'Checking…';

  @override
  String get autoUpdateCheck => 'Check automatically once a day';

  @override
  String get updateNote =>
      'Each time Astryl opens, it asks GitHub for a newer version and offers it first (you can skip). Nothing about you is sent. Your settings stay on your phone.';

  @override
  String get upToDate => 'You have the latest version.';

  @override
  String get updateFailed =>
      'Could not reach GitHub. Check your internet and try again.';

  @override
  String get updateAvailable => 'Update available';

  @override
  String updateReady(String version) {
    return 'Version $version is ready to download.';
  }

  @override
  String get download => 'Download';

  @override
  String get later => 'Later';

  @override
  String get reportBug => 'Report a bug';

  @override
  String get updateSkip => 'Skip';

  @override
  String get crashReportsTitle => 'Send crash reports';

  @override
  String get crashReportsNote =>
      'If the app crashes, a small report (the error text, the app version and the Android version) is sent to the Astryl server so the bug can be fixed. It has no name, account or location. Turn this off any time.';

  @override
  String get about => 'About';

  @override
  String get sourceCode => 'Source code on GitHub';

  @override
  String get websiteLink => 'Website: astryl.space';

  @override
  String get privacyLine => 'Free · Open source · No ads · Account optional';

  @override
  String get dataSource => 'Facts: NASA Planetary Fact Sheet';

  @override
  String get openFailed => 'Could not open the link.';

  @override
  String get bodySun => 'Sun';

  @override
  String get bodyMoon => 'Moon';

  @override
  String get bodyPluto => 'Pluto';

  @override
  String get moonIo => 'Io';

  @override
  String get moonEuropa => 'Europa';

  @override
  String get moonGanymede => 'Ganymede';

  @override
  String get moonCallisto => 'Callisto';

  @override
  String get moonTitan => 'Titan';

  @override
  String get moonEnceladus => 'Enceladus';

  @override
  String get moonTriton => 'Triton';

  @override
  String get kindStar => 'Our star, the centre of the Solar System';

  @override
  String get kindDwarf => 'Dwarf planet';

  @override
  String moonOf(String planet) {
    return 'Moon of $planet';
  }

  @override
  String get orbitPeriod => 'One orbit';

  @override
  String distanceFrom(String body) {
    return 'Distance from $body';
  }

  @override
  String get composition => 'What it is made of';

  @override
  String get noAtmosphere => 'No real atmosphere, it is almost a vacuum.';

  @override
  String get majorMoons => 'Major moons';

  @override
  String get lifeTitle => 'Could humans live here?';

  @override
  String get lifeScoreShort => 'Life score';

  @override
  String get lifeNote =>
      'Scored from temperature, air pressure, oxygen, water, surface and gravity. Earth scores 10.';

  @override
  String get water => 'Water';

  @override
  String get waterLiquid => 'Liquid water';

  @override
  String get waterIce => 'Ice';

  @override
  String get waterOcean => 'Ocean under the ice';

  @override
  String get waterNone => 'No water';

  @override
  String get surface => 'Surface';

  @override
  String get solidSurface => 'Solid surface';

  @override
  String get lifeHome => 'Just like home';

  @override
  String get lifeHard =>
      'Very hard, people would need a closed base and spacesuits';

  @override
  String get lifeNo => 'Impossible for humans';

  @override
  String get downloadInstall => 'Download and install';

  @override
  String downloadingPercent(String percent) {
    return 'Downloading… $percent%';
  }

  @override
  String get installNow => 'Install';

  @override
  String get allowInstalls =>
      'Allow Astryl to install apps on the screen that opened, then come back and tap Install.';

  @override
  String get downloadFailed =>
      'The download did not finish. Check your internet and try again.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get today => 'Today';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get monthBack => '30 days earlier';

  @override
  String get monthForward => '30 days later';

  @override
  String get positionsNote =>
      'Real positions on this date · Sizes and distances not to scale · Tap a planet';

  @override
  String get navYou => 'You';

  @override
  String get ageTitle => 'Your age on other planets';

  @override
  String get setBirthDate => 'Set your birth date';

  @override
  String get changeBirthDate => 'Change';

  @override
  String nextBirthday(String days) {
    return 'Next birthday in $days days';
  }

  @override
  String get ageNote => 'Your birth date is saved only on this phone.';

  @override
  String get share => 'Share';

  @override
  String shareText(String planet) {
    return '$planet in Astryl, the free Solar System app: https://github.com/aditymishr098-collab/astryl';
  }

  @override
  String get shareFailed => 'Could not share the picture.';

  @override
  String get travelTitle => 'How far is it?';

  @override
  String get distanceFromEarth => 'Distance from Earth today';

  @override
  String get lightTime => 'Light takes';

  @override
  String get bySpacecraft => 'By spacecraft at 60,000 km/h';

  @override
  String get byCar => 'By car at 100 km/h';

  @override
  String valueSeconds(String value) {
    return '$value s';
  }

  @override
  String valueMinutes(String value) {
    return '$value min';
  }

  @override
  String get sizeTitle => 'Size';

  @override
  String sizeTimes(String big, String times, String small) {
    return '$big is $times× as wide as $small.';
  }

  @override
  String sizeSimilar(String a, String b) {
    return '$a and $b are about the same size.';
  }

  @override
  String get navSky => 'Sky';

  @override
  String get skyTitle => 'Tonight\'s sky';

  @override
  String get chooseCity => 'Choose your city';

  @override
  String get chooseCityHint =>
      'Pick the city nearest to you to see the Moon and which planets you can spot tonight. No location permission is needed, and it stays on your phone.';

  @override
  String get searchCity => 'Search city';

  @override
  String get noCityFound => 'No city found';

  @override
  String get cityNote =>
      'Times are in your phone\'s time zone. A planet counts as visible when it is at least 5° above the horizon in a dark sky.';

  @override
  String illuminated(String percent) {
    return '$percent% lit';
  }

  @override
  String get moonrise => 'Moonrise';

  @override
  String get moonset => 'Moonset';

  @override
  String get sunset => 'Sunset';

  @override
  String get sunrise => 'Sunrise';

  @override
  String get nextFull => 'Next full moon';

  @override
  String get nextNew => 'Next new moon';

  @override
  String get phaseNew => 'New moon';

  @override
  String get phaseWaxingCrescent => 'Waxing crescent';

  @override
  String get phaseFirstQuarter => 'First quarter';

  @override
  String get phaseWaxingGibbous => 'Waxing gibbous';

  @override
  String get phaseFull => 'Full moon';

  @override
  String get phaseWaningGibbous => 'Waning gibbous';

  @override
  String get phaseLastQuarter => 'Last quarter';

  @override
  String get phaseWaningCrescent => 'Waning crescent';

  @override
  String get planetsTonight => 'Planets tonight';

  @override
  String get statusVisible => 'Visible tonight';

  @override
  String get statusEvening => 'In the evening, after sunset';

  @override
  String get statusMorning => 'In the morning, before sunrise';

  @override
  String get statusNotVisible => 'Not visible tonight';

  @override
  String bestAt(String time) {
    return 'Best at $time';
  }

  @override
  String altitudeDir(String direction, String degrees) {
    return '$direction, $degrees° high';
  }

  @override
  String riseSet(String rise, String set) {
    return 'Rises $rise · Sets $set';
  }

  @override
  String get needsTelescope => 'Needs binoculars or a telescope';

  @override
  String get dirN => 'North';

  @override
  String get dirNE => 'North-east';

  @override
  String get dirE => 'East';

  @override
  String get dirSE => 'South-east';

  @override
  String get dirS => 'South';

  @override
  String get dirSW => 'South-west';

  @override
  String get dirW => 'West';

  @override
  String get dirNW => 'North-west';

  @override
  String get findPlanet => 'Find in the sky';

  @override
  String finderTitle(String name) {
    return 'Find $name';
  }

  @override
  String get pointPhone => 'Hold your phone up and move it slowly around.';

  @override
  String turnRight(String degrees) {
    return 'Turn right $degrees°';
  }

  @override
  String turnLeft(String degrees) {
    return 'Turn left $degrees°';
  }

  @override
  String tiltUp(String degrees) {
    return 'Tilt up $degrees°';
  }

  @override
  String tiltDown(String degrees) {
    return 'Tilt down $degrees°';
  }

  @override
  String onTarget(String name) {
    return '$name is right there!';
  }

  @override
  String belowHorizon(String name) {
    return '$name is below the horizon right now.';
  }

  @override
  String risesAt(String time) {
    return 'It rises at $time.';
  }

  @override
  String get noSensor =>
      'This phone has no compass sensor, so the finder cannot work.';

  @override
  String get calibrate =>
      'The compass needs calibrating: move your phone in a figure 8 a few times.';

  @override
  String get phoneNow => 'Your phone points to';

  @override
  String get finderNote =>
      'Hold the phone with its back towards the sky and keep it away from magnets and metal. Never look at the Sun.';

  @override
  String get eventsTitle => 'Space events';

  @override
  String get eventsSubtitle =>
      'What to look for in the sky over the next 12 months.';

  @override
  String eventsNext(String event, String when) {
    return 'Next: $event · $when';
  }

  @override
  String get eventFullMoon => 'Full Moon';

  @override
  String get eventNewMoon => 'New Moon';

  @override
  String eventOpposition(String planet) {
    return '$planet at opposition';
  }

  @override
  String eventEveningElongation(String planet) {
    return '$planet: best evening view';
  }

  @override
  String eventMorningElongation(String planet) {
    return '$planet: best morning view';
  }

  @override
  String eventConjunction(String a, String b) {
    return '$a and $b meet';
  }

  @override
  String get eventMarchEquinox => 'March equinox';

  @override
  String get eventJuneSolstice => 'June solstice';

  @override
  String get eventSeptemberEquinox => 'September equinox';

  @override
  String get eventDecemberSolstice => 'December solstice';

  @override
  String get eventFullMoonDesc =>
      'The Moon\'s whole face is lit. It rises around sunset.';

  @override
  String get eventNewMoonDesc =>
      'The Moon is hidden. The darkest skies of the month for stars and planets.';

  @override
  String eventOppositionDesc(String planet) {
    return '$planet is opposite the Sun. It is at its brightest this year and up all night.';
  }

  @override
  String eventEveningDesc(String planet, String degrees) {
    return '$planet is $degrees° from the Sun, as far as it gets. Look low in the west after sunset.';
  }

  @override
  String eventMorningDesc(String planet, String degrees) {
    return '$planet is $degrees° from the Sun, as far as it gets. Look low in the east before sunrise.';
  }

  @override
  String eventConjunctionDesc(String degrees) {
    return 'They pass only $degrees° apart in the sky.';
  }

  @override
  String get eventEquinoxDesc =>
      'Day and night are almost equal everywhere on Earth.';

  @override
  String get eventJuneSolsticeDesc =>
      'Longest day in the north, shortest day in the south.';

  @override
  String get eventDecemberSolsticeDesc =>
      'Shortest day in the north, longest day in the south.';

  @override
  String eventMeteorShower(String shower) {
    return '$shower meteor shower';
  }

  @override
  String eventMeteorDesc(String rate, String percent) {
    return 'Up to about $rate meteors an hour under a dark sky. The Moon will be $percent% lit.';
  }

  @override
  String get showerQuadrantids => 'Quadrantids';

  @override
  String get showerLyrids => 'Lyrids';

  @override
  String get showerEtaAquariids => 'Eta Aquariids';

  @override
  String get showerPerseids => 'Perseids';

  @override
  String get showerOrionids => 'Orionids';

  @override
  String get showerLeonids => 'Leonids';

  @override
  String get showerGeminids => 'Geminids';

  @override
  String get showerUrsids => 'Ursids';

  @override
  String get eventToday => 'Today';

  @override
  String get eventTomorrow => 'Tomorrow';

  @override
  String eventInDays(String days) {
    return 'In $days days';
  }

  @override
  String get eventsNote =>
      'Dates are worked out on your phone and shown in its time zone. Meteor shower peaks are typical yearly dates and can shift by a day. Reminders stay on your phone.';

  @override
  String get remindMe => 'Remind me';

  @override
  String reminderSet(String date) {
    return 'Okay, I will remind you on $date.';
  }

  @override
  String get reminderOff => 'Reminder removed.';

  @override
  String get reminderTooLate => 'This event is too close to set a reminder.';

  @override
  String get notificationsOff =>
      'Notifications are off for Astryl. Turn them on in Android settings.';

  @override
  String get reminderTomorrow => 'Coming up tomorrow';

  @override
  String get reminderToday => 'Happening today';

  @override
  String get onlineTitle => 'Online features';

  @override
  String get onlineSubtitle =>
      'Show the space station, Tiangong, Hubble, rocket launches and space news. Astryl then contacts only wheretheiss.at, Celestrak, Launch Library 2 and the Spaceflight News API, which can see your phone’s internet address. Nothing else is sent. Off by default.';

  @override
  String get turnOnOnline => 'Turn on online features';

  @override
  String get issTitle => 'Space station';

  @override
  String get issCardHint => 'Where it is now and when it passes over you';

  @override
  String get issNeedsOnline =>
      'To show the station, Astryl needs its orbit data from the internet. It is downloaded once and then works offline for days.';

  @override
  String get issLoading => 'Getting the orbit data…';

  @override
  String get issFailed =>
      'Could not get the orbit data. Check your internet and try again.';

  @override
  String issStale(String days) {
    return 'The orbit data is $days days old, so positions may be off. Connect to the internet to refresh it.';
  }

  @override
  String get issHeight => 'Height';

  @override
  String get issSpeed => 'Speed';

  @override
  String get issFromYou => 'Distance from you';

  @override
  String valueKmh(String value) {
    return '$value km/h';
  }

  @override
  String issAboveHorizon(String direction, String degrees) {
    return 'Above your horizon now! Look $direction, $degrees° high.';
  }

  @override
  String get issBelowHorizon => 'Below your horizon right now.';

  @override
  String issPassesTitle(String city) {
    return 'Next passes over $city';
  }

  @override
  String get issNoPasses => 'No good passes in the next 5 days.';

  @override
  String issMaxHigh(String degrees) {
    return 'Up to $degrees° high';
  }

  @override
  String issFromTo(String start, String end) {
    return '$start to $end';
  }

  @override
  String get issVisible => 'Easy to see';

  @override
  String get issHidden => 'Hard to see';

  @override
  String get issPassTitle => 'Space station passing over you';

  @override
  String issPassBody(String degrees, String direction) {
    return 'Rises in 10 minutes, up to $degrees° high. Look $direction.';
  }

  @override
  String get issNote =>
      'Positions are worked out on your phone from the station\'s orbit data. A pass is easy to see when the sky is dark and the station is lit by the Sun: it looks like a bright, fast star.';

  @override
  String get launchesNeedOnline =>
      'Turn on online features to see upcoming rocket launches here.';

  @override
  String get launchesFailed =>
      'Could not update the launch list. Showing the saved one.';

  @override
  String get launchesNote =>
      'Launch times come from Launch Library 2 and often change. Names and places are in English.';

  @override
  String get launchReminderBody =>
      'Lifts off in about an hour. Times can change.';

  @override
  String get launchTimeTbd => 'Time not set yet';

  @override
  String get quizChoose => 'Choose a level';

  @override
  String get levelEasy => 'Easy';

  @override
  String get levelMedium => 'Medium';

  @override
  String get levelHard => 'Hard';

  @override
  String get levelEasyHint => 'The basics about the planets';

  @override
  String get levelMediumHint => 'Planets and moons';

  @override
  String get levelHardHint => 'Tricky comparisons and rankings';

  @override
  String get qStar => 'Which of these is a star, not a planet?';

  @override
  String get qDwarf => 'Which of these is a dwarf planet?';

  @override
  String get qMoonVisited => 'Which moon have people walked on?';

  @override
  String get qLargestMoon => 'Which of these moons is the largest?';

  @override
  String get qSmallestMoon => 'Which of these moons is the smallest?';

  @override
  String get qThickAirMoon => 'Which of these moons has a thick atmosphere?';

  @override
  String get qGeyserMoon => 'Which moon shoots geysers of water into space?';

  @override
  String get qVolcanicMoon => 'Which moon has the most active volcanoes?';

  @override
  String get qBackwardsMoon => 'Which moon goes around its planet backwards?';

  @override
  String get qBiggestRocky => 'Which of the four rocky planets is the biggest?';

  @override
  String get qColdestRocky => 'Which of the four rocky planets is the coldest?';

  @override
  String get qHighestPressure =>
      'Which planet has the heaviest air pressure at its surface?';

  @override
  String get qSecondLargest => 'Which planet is the second largest?';

  @override
  String get qLongestYear => 'Which planet has the longest year?';

  @override
  String get qShortestYear => 'Which planet has the shortest year?';

  @override
  String get qSmallestGiant =>
      'Which of the four giant planets is the smallest?';

  @override
  String get qRockyLongestYear =>
      'Which of the four rocky planets has the longest year?';

  @override
  String get qFastestMoon =>
      'Which of these moons goes around its planet the fastest?';

  @override
  String get qSlowestMoon =>
      'Which of these moons takes the longest to go around its planet?';

  @override
  String get qStrongestMoonGravity =>
      'Which of these moons has the strongest gravity?';

  @override
  String get qColdestMoon => 'Which of these moons is the coldest?';

  @override
  String get qSecondLargestMoon =>
      'Which of these moons is the second largest?';

  @override
  String get factTitle => 'Did you know?';

  @override
  String get factTap => 'Tap for another fact';

  @override
  String get factSun1 =>
      'The Sun holds 99.8% of all the mass in the solar system.';

  @override
  String get factSun2 =>
      'Sunlight takes about 8 minutes and 20 seconds to reach Earth.';

  @override
  String get factMercury1 =>
      'One day on Mercury, from sunrise to the next sunrise, lasts about 176 Earth days. That is twice as long as its year.';

  @override
  String get factMercury2 =>
      'Mercury has almost no air, so its sky is black even by day, and its nights are freezing cold.';

  @override
  String get factVenus1 =>
      'Venus spins backwards, so on Venus the Sun rises in the west.';

  @override
  String get factVenus2 =>
      'Venus is hotter than Mercury, even though it is farther from the Sun, because its thick air traps the heat.';

  @override
  String get factEarth1 =>
      'Earth is the only place we know with life, and about 71% of its surface is covered by water.';

  @override
  String get factEarth2 =>
      'Earth is not a perfect ball. It bulges a little at the equator because it spins.';

  @override
  String get factMars1 =>
      'Olympus Mons on Mars is the tallest volcano in the solar system, about two and a half times as tall as Mount Everest.';

  @override
  String get factMars2 => 'Sunsets on Mars look blue.';

  @override
  String get factJupiter1 =>
      'Jupiter has more than twice the mass of all the other planets put together.';

  @override
  String get factJupiter2 =>
      'The Great Red Spot is a storm bigger than Earth, and people have watched it for more than 150 years.';

  @override
  String get factSaturn1 =>
      'Saturn is so light for its size that it would float in water, if you could find a bathtub big enough.';

  @override
  String get factSaturn2 =>
      'Saturn\'s rings are very wide but very thin: in places only about ten metres thick.';

  @override
  String get factUranus1 =>
      'Uranus rolls around the Sun on its side, tilted by about 98 degrees.';

  @override
  String get factUranus2 =>
      'Uranus was the first planet found with a telescope. William Herschel spotted it in 1781.';

  @override
  String get factNeptune1 =>
      'Neptune has the fastest winds of any planet, more than 2,000 km/h.';

  @override
  String get factNeptune2 =>
      'Neptune was found with maths before anyone saw it: in 1846 astronomers worked out where it had to be.';

  @override
  String get factMoon1 =>
      'The Moon moves about 3.8 centimetres farther from Earth every year.';

  @override
  String get factMoon2 =>
      'We always see the same side of the Moon, because it turns exactly once for each trip around Earth.';

  @override
  String get factPluto1 => 'A year on Pluto lasts about 248 Earth years.';

  @override
  String get factPluto2 =>
      'Pluto has a huge heart-shaped plain of frozen nitrogen.';

  @override
  String get factIo1 =>
      'Io is the most volcanic world we know, with hundreds of active volcanoes.';

  @override
  String get factIo2 =>
      'Jupiter\'s gravity squeezes and stretches Io, and the heat from this powers its volcanoes.';

  @override
  String get factEuropa1 =>
      'Under its icy shell, Europa probably holds about twice as much water as all of Earth\'s oceans.';

  @override
  String get factEuropa2 =>
      'Europa is one of the best places to look for life beyond Earth. The Europa Clipper spacecraft is on its way there.';

  @override
  String get factGanymede1 =>
      'Ganymede is the largest moon in the solar system. It is even bigger than Mercury.';

  @override
  String get factGanymede2 =>
      'Ganymede is the only moon known to have a magnetic field of its own.';

  @override
  String get factCallisto1 =>
      'Callisto is one of the most heavily cratered places in the solar system, and its surface is very old.';

  @override
  String get factCallisto2 =>
      'Callisto is far enough from Jupiter to get less of its harsh radiation, so scientists have suggested it for a future base.';

  @override
  String get factTitan1 =>
      'Titan is the only moon with a thick atmosphere. Its air pressure at the surface is higher than on Earth.';

  @override
  String get factTitan2 =>
      'Titan has rivers and lakes, but they hold liquid methane and ethane, not water.';

  @override
  String get factEnceladus1 =>
      'Enceladus shoots jets of ice and water vapour into space through cracks near its south pole.';

  @override
  String get factEnceladus2 => 'The jets of Enceladus feed Saturn\'s E ring.';

  @override
  String get factTriton1 =>
      'Triton goes around Neptune backwards, so it was probably a dwarf planet that Neptune captured.';

  @override
  String get factTriton2 =>
      'At about −235 °C, Triton is one of the coldest places anyone has measured in the solar system.';

  @override
  String get jumpInput => 'Your jump height on Earth (cm)';

  @override
  String jumpHigh(String height) {
    return 'Jump: $height';
  }

  @override
  String jumpFeelsLike(String height) {
    return 'A $height jump on Earth becomes';
  }

  @override
  String get jumpNote =>
      'Same push-off as on Earth. On the Sun and the gas giants there is no ground to stand on, so this is only a thought game.';

  @override
  String valueCm(String value) {
    return '$value cm';
  }

  @override
  String valueM(String value) {
    return '$value m';
  }

  @override
  String get eclipseTotalLunar => 'Total lunar eclipse';

  @override
  String get eclipsePartialLunar => 'Partial lunar eclipse';

  @override
  String get eclipsePenumbralLunar => 'Penumbral lunar eclipse';

  @override
  String get eclipseTotalSolar => 'Total solar eclipse';

  @override
  String get eclipseAnnularSolar => 'Annular solar eclipse';

  @override
  String get eclipseHybridSolar => 'Hybrid solar eclipse';

  @override
  String get eclipsePartialSolar => 'Partial solar eclipse';

  @override
  String get eclipseTotalLunarDesc =>
      'The Moon moves fully into Earth\'s shadow and often turns a dim red. Everyone on the night side of Earth can see it, and it is safe to watch with your eyes.';

  @override
  String eclipsePartialLunarDesc(String percent) {
    return 'Part of the Moon ($percent% of its width) moves into Earth\'s dark shadow. It is safe to watch with your eyes.';
  }

  @override
  String get eclipsePenumbralLunarDesc =>
      'The Moon passes through the faint outer shadow of Earth. It only dims a little, so it is hard to notice.';

  @override
  String get eclipseTotalSolarDesc =>
      'The Moon completely covers the Sun along a narrow path across Earth. Outside that path you see a partial eclipse.';

  @override
  String get eclipseAnnularSolarDesc =>
      'The Moon is a little too far away to cover the Sun fully, so a bright ring is left. The ring shows along a narrow path; outside it the eclipse is partial.';

  @override
  String get eclipseHybridSolarDesc =>
      'Along its path this eclipse is total in some places and ring-shaped in others. Outside the path it is partial.';

  @override
  String get eclipsePartialSolarDesc =>
      'The Moon covers only a part of the Sun, and nowhere on Earth is the Sun fully covered.';

  @override
  String get eclipseNoCity =>
      'Choose a city in Astryl to see if you can watch it from there.';

  @override
  String eclipseLunarUp(String city) {
    return 'The Moon is above the horizon in $city at the middle of the eclipse.';
  }

  @override
  String eclipseLunarPartly(String city) {
    return 'In $city the Moon is above the horizon for only part of the eclipse.';
  }

  @override
  String eclipseLunarDown(String city) {
    return 'In $city the Moon stays below the horizon, so you cannot see it from there.';
  }

  @override
  String eclipseSolarNone(String city) {
    return 'Not visible from $city: the Moon\'s shadow misses it, or the Sun is below the horizon.';
  }

  @override
  String eclipseSolarSlight(String city) {
    return 'From $city at most a very slight partial eclipse, hard to notice.';
  }

  @override
  String eclipseSolarPartial(String city, String percent) {
    return 'Rough estimate for $city: the Moon covers about $percent% of the Sun\'s width at best.';
  }

  @override
  String eclipseSolarNear(String city) {
    return '$city is close to the path where the Sun is almost or fully covered. Check an eclipse map; this estimate is rough.';
  }

  @override
  String get eclipseSolarSafety =>
      'Never look at the Sun without proper eclipse glasses.';

  @override
  String get alertsTitle => 'Alerts';

  @override
  String get tonightAlertSwitch => 'Tonight in the sky, every evening';

  @override
  String get tonightAlertTime => 'Time';

  @override
  String get tonightAlertNote =>
      'A short note about the Moon and the planets you can see, at the time you choose. It is worked out on your phone, with no internet. Android only lets Astryl prepare about two weeks of notes ahead, so open the app now and then.';

  @override
  String get tonightNotifTitle => 'Tonight in the sky';

  @override
  String tonightMoon(String phase, String percent) {
    return 'Moon: $phase, $percent% lit.';
  }

  @override
  String tonightPlanets(String planets) {
    return 'Look for: $planets.';
  }

  @override
  String get tonightNoPlanets => 'No bright planets in the evening sky.';

  @override
  String get tonightNoCity => 'Choose a city in Astryl to see the planets.';

  @override
  String get birthdayTitle => 'My birthday sky';

  @override
  String get birthdaySubtitle =>
      'The Moon and the planets on the day you were born, and the big days of your life.';

  @override
  String get birthdayCardHint => 'Moon phase, planets and milestones';

  @override
  String get birthdayNeedDate => 'Set your birth date';

  @override
  String get birthdayMoon => 'Moon on your birthday';

  @override
  String get birthdayPlanets => 'Planets on that day';

  @override
  String birthdayDaysOld(String count) {
    return 'You are $count days old today.';
  }

  @override
  String get birthdayMilestones => 'Milestones';

  @override
  String birthdayDayN(String count) {
    return 'Day $count';
  }

  @override
  String get birthdayBillion => '1 billion seconds old';

  @override
  String get birthdayPassed => 'Done';

  @override
  String get birthdayNote =>
      'Worked out on your phone from the same orbits as the rest of Astryl. Your birth date never leaves it.';

  @override
  String get missionsTitle => 'Space missions';

  @override
  String get missionsSubtitle =>
      'Famous moments in the exploration of space, oldest first.';

  @override
  String get missionsCardHint => 'Famous missions through time';

  @override
  String get missionSputnik1 =>
      'The first artificial satellite. This metal ball, about the size of a beach ball, circled Earth for about three months. Its beeping could be heard on radios and it started the space age.';

  @override
  String get missionVostok1 =>
      'Yuri Gagarin became the first person in space. He circled Earth once, in about 108 minutes.';

  @override
  String get missionApollo11 =>
      'Neil Armstrong and Buzz Aldrin landed in the Sea of Tranquility and became the first people to walk on the Moon. Michael Collins waited for them in orbit.';

  @override
  String get missionVenera7 =>
      'The first spacecraft to land on another planet and send a signal back. It sent data from Venus for about 23 minutes in the crushing heat.';

  @override
  String get missionViking1 =>
      'It landed on Mars and worked there for more than six years, sending the first long series of photos and weather reports from the surface of another planet.';

  @override
  String get missionVoyager1 =>
      'Launched in 1977, it flew past Jupiter and Saturn and entered interstellar space in 2012. It is the farthest human-made object from Earth.';

  @override
  String get missionHubble =>
      'Launched in 1990, it looks at the universe from above Earth\'s air. Its sharp pictures helped measure the age of the universe and showed thousands of faraway galaxies.';

  @override
  String get missionHuygens =>
      'Huygens, a probe carried by Cassini, parachuted down to Saturn\'s moon Titan. It was the first landing in the outer solar system, and it sent pictures from the surface.';

  @override
  String get missionCuriosity =>
      'This car-sized rover landed in Gale Crater using a rocket-powered sky crane. It found that Mars once had the right conditions for life.';

  @override
  String get missionMangalyaan =>
      'India\'s Mars Orbiter Mission reached Mars orbit on its first try, a first for any country, and at a very low cost.';

  @override
  String get missionRosetta =>
      'Rosetta\'s lander Philae touched down on comet 67P/Churyumov–Gerasimenko, the first landing on a comet. Rosetta itself circled the comet for two years.';

  @override
  String get missionNewhorizons =>
      'After a nine-year trip, it flew past Pluto and showed us icy mountains and a huge heart-shaped plain for the first time.';

  @override
  String get missionPerseverance =>
      'The Perseverance rover landed in Jezero Crater to look for signs of old life and collect rock samples. Its helicopter Ingenuity made the first powered flight on another planet.';

  @override
  String get missionJwst =>
      'The largest space telescope has a 6.5-metre gold mirror and watches the sky in infrared light from 1.5 million km away. It sees some of the first galaxies.';

  @override
  String get missionChandrayaan3 =>
      'India became the fourth country to land softly on the Moon, and the first near its south pole. The Vikram lander carried the Pragyan rover.';

  @override
  String get spacecraftTitle => 'Spacecraft now';

  @override
  String get spacecraftSubtitle =>
      'How far some famous spacecraft are from Earth right now.';

  @override
  String get spacecraftCardHint => 'Voyager, JWST, Mars rovers and more';

  @override
  String get spacecraftDistance => 'Distance from Earth';

  @override
  String get spacecraftAltitude => 'Height above Earth';

  @override
  String get spacecraftInAu => 'In astronomical units';

  @override
  String get spacecraftSpeed => 'Speed';

  @override
  String get spacecraftSignal => 'Radio signal takes';

  @override
  String get spacecraftNote =>
      'Distances are estimates. For the far probes they are worked out from average speed and can be off by about 1%, because Earth moves round the Sun. The Mars distance is calculated for today. One AU (astronomical unit) is the distance from Earth to the Sun.';

  @override
  String valueBillionKm(String value) {
    return '$value billion km';
  }

  @override
  String valueAu(String value) {
    return '$value AU';
  }

  @override
  String valueKmS(String value) {
    return '$value km/s';
  }

  @override
  String get spacecraftVoyager1 =>
      'Launched in 1977. In 2012 it became the first spacecraft to enter interstellar space. Its radio signal is already about a day old when it reaches us.';

  @override
  String get spacecraftVoyager2 =>
      'Launched in 1977. It is the only spacecraft that has visited Uranus and Neptune, and it entered interstellar space in 2018.';

  @override
  String get spacecraftNewHorizons =>
      'Flew past Pluto in 2015 and the Kuiper Belt object Arrokoth in 2019. It is still travelling outward and still sending data.';

  @override
  String get spacecraftJwst =>
      'The largest space telescope, launched in 2021. It sits near a point called L2, about 1.5 million km from Earth, with its sunshield always facing the Sun.';

  @override
  String get spacecraftIss =>
      'Circles Earth about every 90 minutes. People have lived on board without a break since 2000.';

  @override
  String get spacecraftHubble =>
      'Launched in 1990 and still working. It circles Earth above the blurring air, so its pictures are very sharp.';

  @override
  String get spacecraftMarsRovers =>
      'Curiosity (landed 2012) and Perseverance (landed 2021) are driving on Mars. The distance to Mars changes from about 55 million km to over 400 million km.';

  @override
  String get searchTooltip => 'Search';

  @override
  String get searchHint => 'Search planets, moons, missions…';

  @override
  String get searchClear => 'Clear';

  @override
  String searchEmpty(String query) {
    return 'Nothing found for “$query”.';
  }

  @override
  String get searchBodies => 'Planets and moons';

  @override
  String get searchMissions => 'Missions';

  @override
  String get searchSpacecraft => 'Spacecraft';

  @override
  String get favoritesTitle => 'Favourites';

  @override
  String get favoritesEmpty =>
      'Tap the star on a planet, mission or spacecraft to keep it here.';

  @override
  String get favoriteAdd => 'Add to favourites';

  @override
  String get favoriteRemove => 'Remove from favourites';

  @override
  String get textSize => 'Text size';

  @override
  String get textSizeNormal => 'Normal';

  @override
  String get textSizeLarge => 'Large';

  @override
  String get textSizeLarger => 'Larger';

  @override
  String get textSizeNote =>
      'Makes the text in Astryl bigger. It never goes below your phone\'s own text size.';

  @override
  String get skyOtherNight => 'The night sky';

  @override
  String get planetsThatNight => 'Planets that night';

  @override
  String get previousDay => 'Previous day';

  @override
  String get nextDay => 'Next day';

  @override
  String get pickDate => 'Choose a date';

  @override
  String get backToTonight => 'Back to tonight';

  @override
  String get moonCalendar => 'Moon calendar';

  @override
  String get moonCalendarHint => 'The phase of the Moon on every day';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get keyMoonDates => 'Main phases this month';

  @override
  String get moonCalendarNote =>
      'Phase dates and times are shown in your phone\'s time zone and are accurate to within about an hour.';

  @override
  String get seeSkyThatDay => 'See the sky on this day';

  @override
  String get sunLightTitle => 'Sun and light';

  @override
  String get firstLight => 'First light';

  @override
  String get goldenMorningEnds => 'Morning golden hour ends';

  @override
  String get solarNoon => 'Solar noon';

  @override
  String get goldenEveningStarts => 'Evening golden hour starts';

  @override
  String get lastLight => 'Last light';

  @override
  String get darkSky => 'Fully dark sky';

  @override
  String get sunDayLength => 'Day length';

  @override
  String durationHm(String hours, String minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get sunNote =>
      'Golden hour is when the Sun is less than 6° above the horizon. First and last light are when it is 6° below, and the sky is fully dark when it is 18° below. Times are worked out for the date you choose.';

  @override
  String get sunStaysUp => 'On this day the Sun does not set.';

  @override
  String get sunStaysDown => 'On this day the Sun does not rise.';

  @override
  String get solarSystemTitle => 'Solar system';

  @override
  String get starMapTitle => 'Star map';

  @override
  String get starMapCardHint => 'Stars and constellations in your sky';

  @override
  String get starMapHint =>
      'Drag to look around, pinch to zoom, tap a star or a constellation.';

  @override
  String get starsLabel => 'Stars';

  @override
  String get constellationsLabel => 'Constellations';

  @override
  String get starMapFind => 'Find it';

  @override
  String get constellationsList => 'All constellations';

  @override
  String magnitudeValue(String value) {
    return 'Magnitude $value';
  }

  @override
  String get starBelowHorizon => 'Below the horizon at this time';

  @override
  String get starMapNow => 'Now';

  @override
  String get starUnnamed => 'Star';

  @override
  String get binocularsTitle => 'Binocular guide';

  @override
  String get binocularsHint => 'What to look for with ordinary binoculars';

  @override
  String get binocularsIntro =>
      'Hold the binoculars steady, for example with your elbows on a wall or a car roof. Away from city lights, look for dim, fuzzy patches rather than sharp stars.';

  @override
  String get binocularsNote =>
      'Times show when each object is highest during the dark part of the night in your chosen city. Object names are the ones used worldwide. Tap one to see it on the star map.';

  @override
  String get dsoCluster => 'Star cluster';

  @override
  String get dsoGalaxy => 'Galaxy';

  @override
  String get dsoNebula => 'Nebula';

  @override
  String get storyOri =>
      'Orion the Hunter is easy to find: three stars in a short straight line make his belt. Above the belt, orange Betelgeuse marks one shoulder; below it, blue-white Rigel marks one foot. Under the belt hangs a faint fuzzy patch, the Orion Nebula, a cloud where new stars are being born. Orion is an evening sight in winter in the north and in summer in the south.';

  @override
  String get storyUMa =>
      'The seven bright stars of the Big Dipper, also called the Plough, are part of the Great Bear. The two stars at the end of the bowl, Dubhe and Merak, point the way to Polaris: follow the line upward for about five times the gap between them. From much of the north, the Big Dipper circles Polaris all night and never sets.';

  @override
  String get storyUMi =>
      'Polaris, the North Star, sits at the tip of the Little Bear’s tail. It hardly moves because it lies almost exactly above Earth’s north pole, so the whole sky seems to turn around it. Its height above the horizon equals your latitude. It is not a very bright star, but it is the most useful one for finding north. It cannot be seen from the southern half of the world.';

  @override
  String get storyCas =>
      'Cassiopeia is a W or an M, depending on the hour and the season, made of five fairly bright stars. It lies on the opposite side of Polaris from the Big Dipper, so when one is low the other is high. In the old story she was a queen who boasted of her beauty.';

  @override
  String get storyCyg =>
      'Cygnus the Swan flies along the Milky Way. Its brightest stars form the Northern Cross, with Deneb at the top, the tail of the swan. Away from city lights the Milky Way looks like a pale river of light running through the swan, and binoculars show that it is made of countless faint stars. Summer and autumn evenings are the best time.';

  @override
  String get storySco =>
      'Scorpius looks like a scorpion with a curved tail ending in a hook. Its heart is red Antares, whose name means rival of Mars because the two look alike in colour. It is a summer constellation in the north, low in the south, and it passes high overhead for people in the southern half of the world.';

  @override
  String get storyLeo =>
      'Leo the Lion is one of the few constellations that really looks like its animal. A backward question mark of stars, the Sickle, forms the head and chest and ends at bright Regulus, the lion’s heart. The triangle of stars to the east is its hindquarters. Spring evenings are the best time in the north.';

  @override
  String get storyTau =>
      'Taurus the Bull has a V-shaped face, the Hyades cluster, with orange Aldebaran as its eye. Aldebaran looks as if it belongs to the cluster, but it is much closer to us. Higher up, the Pleiades, or Seven Sisters, is a tiny group of blue stars that most people see as six or seven. The Pleiades are known all over the world and appear in the stories of many cultures.';

  @override
  String get storyGem =>
      'Gemini the Twins are marked by two bright stars, Castor and Pollux, standing side by side like the heads of two brothers. Pollux is the brighter one and has an orange tint. Castor is really a system of six stars. Look for them high in the sky on winter and spring evenings in the north.';

  @override
  String get storyLyr =>
      'Lyra the Lyre is small but holds Vega, one of the brightest stars of the northern sky. Vega is blue-white and, together with Deneb in Cygnus and Altair in Aquila, forms the Summer Triangle. Right next to Vega, a small parallelogram of stars makes the body of the lyre.';

  @override
  String get storyCru =>
      'Crux, the Southern Cross, is the smallest of all the constellations but one of the most famous. Four bright stars make a cross, and the two stars of its long arm point towards the south celestial pole, so it helps travellers find south. It cannot be seen from most of the northern half of the world.';

  @override
  String get satellitesTitle => 'Tiangong and Hubble';

  @override
  String get satellitesCardHint => 'When they fly over your city';

  @override
  String get tiangongName => 'Tiangong';

  @override
  String get hubbleName => 'Hubble';

  @override
  String satNeedsOnline(String name) {
    return 'To show $name, Astryl needs its orbit data from the internet. It is downloaded once and then works offline for days.';
  }

  @override
  String satPassTitle(String name) {
    return '$name passing over you';
  }

  @override
  String get satNote =>
      'Positions are worked out on your phone from the orbit data. A pass is easy to see when the sky is dark and the satellite is lit by the Sun. Tiangong is bright, like a fast star. Hubble is much fainter, so binoculars help.';

  @override
  String get newsTitle => 'Space news';

  @override
  String get newsCardHint => 'The latest articles from space news sites';

  @override
  String get newsNeedsOnline =>
      'Turn on online features to read the latest space news.';

  @override
  String get newsFailed =>
      'Could not update the news. Showing the saved articles.';

  @override
  String get newsNone =>
      'No news could be loaded. Check your internet and try again.';

  @override
  String get newsNote =>
      'Articles come from the Spaceflight News API and are in English. Tapping one opens the publisher’s website in your browser. Astryl downloads no pictures.';

  @override
  String get newsOpenFailed => 'Could not open the link.';

  @override
  String get tonightShareTitle => 'Share tonight’s sky';

  @override
  String get tonightShareHint =>
      'A picture of the Moon and planets for your friends';

  @override
  String tonightShareText(String city) {
    return 'The sky over $city, made with Astryl, the free Solar System app: https://github.com/aditymishr098-collab/astryl';
  }

  @override
  String skyOverCity(String city) {
    return 'The sky over $city';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get backupTitle => 'Backup';

  @override
  String get backupNote =>
      'Your favourites, settings, quiz scores, city and birth date go into one small file. It stays on your phone until you send it somewhere. Bells for single events are not included: set them again after restoring.';

  @override
  String get backupSave => 'Save a backup';

  @override
  String get backupRestore => 'Restore a backup';

  @override
  String get backupShareText => 'Astryl backup';

  @override
  String get backupSaveFailed => 'The backup could not be made.';

  @override
  String get backupRestoreTitle => 'Restore this backup?';

  @override
  String get backupRestoreAsk =>
      'This replaces your favourites, settings, quiz scores, city and birth date on this phone.';

  @override
  String get backupRestoreConfirm => 'Restore';

  @override
  String get backupRestored => 'Backup restored.';

  @override
  String get backupBad => 'That file is not an Astryl backup.';

  @override
  String get surfaceMapTitle => 'Surface map';

  @override
  String surfaceMapOf(String body) {
    return '$body: surface map';
  }

  @override
  String get surfaceMapMoonHint =>
      'Where Apollo, Chang\'e, Chandrayaan and others landed.';

  @override
  String get surfaceMapMarsHint =>
      'Where Viking, Curiosity, Perseverance and other landers and rovers touched down.';

  @override
  String get surfaceMapTap =>
      'Tap a marker to read the story. Pinch to zoom in.';

  @override
  String get surfaceMapNote =>
      'A simplified map, not a photo: the big seas, basins, craters and volcanoes are drawn in the right places, and every landing site is at its real latitude and longitude.';

  @override
  String get surfaceMapSites => 'Landing sites';

  @override
  String get siteKindCrewed => 'Crewed landing';

  @override
  String get siteKindLander => 'Lander';

  @override
  String get siteKindRover => 'Rover';

  @override
  String get siteKindSample => 'Sample return';

  @override
  String get mapNearSide => 'Near side';

  @override
  String get mapFarSide => 'Far side';

  @override
  String get siteLuna9 =>
      'Luna 9 made the first soft landing on another world and sent back the first photos taken on the Moon\'s surface.';

  @override
  String get siteSurveyor1 =>
      'Surveyor 1 was the first American soft landing on the Moon. It sent back more than 11,000 photos and showed that the ground was firm enough to land on.';

  @override
  String get siteApollo11 =>
      'The first people on the Moon, Neil Armstrong and Buzz Aldrin, landed here at Tranquility Base in July 1969.';

  @override
  String get siteApollo12 =>
      'Apollo 12 landed close to the old probe Surveyor 3, and the crew brought some of its parts back to Earth.';

  @override
  String get siteLuna16 =>
      'Luna 16 was the first robot to bring Moon soil back to Earth, about 100 grams, with no crew on board.';

  @override
  String get siteLunokhod1 =>
      'Lunokhod 1 was the first rover on another world. It drove about 10 km over the Sea of Rains in eleven months.';

  @override
  String get siteApollo14 =>
      'Apollo 14 landed in the Fra Mauro highlands. Alan Shepard hit two golf balls on the Moon.';

  @override
  String get siteApollo15 =>
      'Apollo 15 was the first mission with a Moon buggy, and explored the foot of the Apennine mountains.';

  @override
  String get siteApollo16 =>
      'Apollo 16 explored the Descartes highlands by rover and brought back about 95 kg of rocks.';

  @override
  String get siteApollo17 =>
      'Apollo 17, in December 1972, is the most recent time people walked on the Moon. Geologist Harrison Schmitt was one of the two walkers.';

  @override
  String get siteChange3 =>
      'China\'s Chang\'e 3 put the Yutu rover on the Moon in December 2013, the first soft landing there since 1976.';

  @override
  String get siteChange4 =>
      'Chang\'e 4 made the first soft landing on the far side of the Moon, inside the huge South Pole-Aitken basin, in January 2019.';

  @override
  String get siteChange5 =>
      'Chang\'e 5 brought back about 1.7 kg of Moon samples in December 2020, the first new samples in 44 years.';

  @override
  String get siteChandrayaan3 =>
      'India\'s Chandrayaan-3 landed near the Moon\'s south pole on 23 August 2023, making India the fourth country to land on the Moon.';

  @override
  String get siteSlim =>
      'Japan\'s SLIM landed in January 2024 within about 100 metres of its target, a very precise landing.';

  @override
  String get siteViking1 =>
      'Viking 1 made the first successful Mars landing in July 1976 and worked on the surface for more than six years.';

  @override
  String get siteViking2 =>
      'Viking 2 landed in Utopia Planitia in September 1976 and photographed frost on the red ground.';

  @override
  String get sitePathfinder =>
      'Mars Pathfinder landed in July 1997 and carried Sojourner, the first rover on Mars, about the size of a microwave oven.';

  @override
  String get siteSpirit =>
      'Spirit landed in Gusev crater in January 2004 and found signs that water once shaped the rocks there.';

  @override
  String get siteOpportunity =>
      'Opportunity landed in January 2004 and worked for almost 15 years, though it was built for 90 days.';

  @override
  String get sitePhoenix =>
      'Phoenix landed near the north pole in May 2008 and confirmed that there is water ice just under the soil.';

  @override
  String get siteCuriosity =>
      'Curiosity landed in Gale crater in August 2012 and showed that the place could once have supported microbial life.';

  @override
  String get siteInsight =>
      'InSight landed in November 2018 and recorded hundreds of marsquakes, listening to the inside of the planet.';

  @override
  String get sitePerseverance =>
      'Perseverance landed in Jezero crater in February 2021 with the helicopter Ingenuity, and collects rock samples for a future trip to Earth.';

  @override
  String get siteZhurong =>
      'China\'s Zhurong landed in May 2021, making China the second country to drive a rover on Mars.';

  @override
  String get featImbrium => 'Mare Imbrium (Sea of Showers)';

  @override
  String get featSerenitatis => 'Mare Serenitatis (Sea of Serenity)';

  @override
  String get featTranquillitatis => 'Mare Tranquillitatis (Sea of Tranquility)';

  @override
  String get featCrisium => 'Mare Crisium (Sea of Crises)';

  @override
  String get featFecunditatis => 'Mare Fecunditatis (Sea of Fertility)';

  @override
  String get featNectaris => 'Mare Nectaris (Sea of Nectar)';

  @override
  String get featNubium => 'Mare Nubium (Sea of Clouds)';

  @override
  String get featHumorum => 'Mare Humorum (Sea of Moisture)';

  @override
  String get featProcellarum => 'Oceanus Procellarum (Ocean of Storms)';

  @override
  String get featFrigoris => 'Mare Frigoris (Sea of Cold)';

  @override
  String get featOrientale => 'Orientale basin';

  @override
  String get featAitken => 'South Pole-Aitken basin';

  @override
  String get featTycho => 'Tycho crater';

  @override
  String get featCopernicus => 'Copernicus crater';

  @override
  String get featOlympus => 'Olympus Mons';

  @override
  String get featTharsis => 'Tharsis volcanoes';

  @override
  String get featValles => 'Valles Marineris';

  @override
  String get featHellas => 'Hellas Planitia';

  @override
  String get featArgyre => 'Argyre Planitia';

  @override
  String get featUtopia => 'Utopia Planitia';

  @override
  String get featIsidis => 'Isidis Planitia';

  @override
  String get featSyrtis => 'Syrtis Major';

  @override
  String get featChryse => 'Chryse Planitia';

  @override
  String get featAcidalia => 'Acidalia Planitia';

  @override
  String get featElysium => 'Elysium Mons';

  @override
  String get featNorthCap => 'North polar cap';

  @override
  String get featSouthCap => 'South polar cap';

  @override
  String get acctTitle => 'Astryl account';

  @override
  String get acctCreateTitle => 'Create your account';

  @override
  String get acctIntro =>
      'Optional. A username and a password, no e-mail. Your favourites, quiz scores and settings then follow you between this app and astryl.space.';

  @override
  String get acctTabCreate => 'Create account';

  @override
  String get acctTabLogin => 'Log in';

  @override
  String get acctUsername => 'Username';

  @override
  String get acctUsernameHint => '3 to 20 letters (a to z), digits or _';

  @override
  String get acctPassword => 'Password';

  @override
  String get acctPasswordHint => 'At least 8 characters';

  @override
  String get acctPasswordAgain => 'Password again';

  @override
  String get acctForgot => 'Forgot password?';

  @override
  String get acctRecoverTitle => 'Reset with your recovery code';

  @override
  String get acctRecoverCode => 'Recovery code';

  @override
  String get acctRecoverNewPassword => 'New password';

  @override
  String get acctRecoverButton => 'Set new password';

  @override
  String get acctBackToLogin => 'Back to log in';

  @override
  String get acctConsent => 'I have read and accept the Privacy Policy';

  @override
  String get acctReadPolicy => 'Read the Privacy Policy';

  @override
  String get acctOptionalTitle => 'Optional. All off until you switch them on.';

  @override
  String get acctCountMe => 'Count me as an active user';

  @override
  String get acctCountMeNote =>
      'Sends a random number made on this phone, once in a while, so Astryl can show how many people use it. It is not linked to you.';

  @override
  String get acctShareCountry => 'Share my country';

  @override
  String get acctShareCountryNote =>
      'The country from your phone’s language and region setting, for a chart of countries.';

  @override
  String get acctShareLocation => 'Share my approximate location';

  @override
  String get acctShareLocationNote =>
      'Needs an account. Android’s approximate location is used (a few kilometres). Only the latest place is kept, rounded to about 10 km, and it is updated when you open the app.';

  @override
  String get acctSkip => 'Skip now';

  @override
  String get acctSkipNote =>
      'You can make an account later in Settings. The app works the same without one.';

  @override
  String get acctCodeTitle => 'Your recovery code';

  @override
  String get acctCodeWarn =>
      'Write it down or keep it somewhere safe. If you forget your password, this code is the only way back in. It works 3 times.';

  @override
  String get acctCopy => 'Copy';

  @override
  String get acctCopied => 'Copied';

  @override
  String get acctCodeSaved => 'I have saved my recovery code';

  @override
  String get acctContinue => 'Continue';

  @override
  String acctRecovered(int count) {
    return 'Password changed. The code can be used $count more times.';
  }

  @override
  String acctLoggedInAs(String name) {
    return 'Logged in as $name';
  }

  @override
  String get acctNotLoggedIn => 'You are not logged in.';

  @override
  String get acctSync => 'Sync my data';

  @override
  String get acctSyncNote =>
      'Favourites, quiz scores, language, theme, city and birth date are kept in your account and shared with astryl.space.';

  @override
  String get acctSyncNow => 'Sync now';

  @override
  String get acctSyncOk => 'Synced';

  @override
  String get acctSyncFailed =>
      'Could not sync. Check your internet and try again.';

  @override
  String get acctSyncing => 'Syncing…';

  @override
  String get acctNewCode => 'Make a new recovery code';

  @override
  String get acctNewCodeNote => 'The old code stops working.';

  @override
  String get acctLogOut => 'Log out';

  @override
  String get acctDelete => 'Delete my account';

  @override
  String get acctDeleteNote =>
      'Deletes your account and everything stored for it online. The data on this phone stays.';

  @override
  String get acctDeleteConfirmTitle => 'Delete your account?';

  @override
  String get acctDeleteConfirmBody =>
      'This cannot be undone. Type your password to confirm.';

  @override
  String get acctDeleteButton => 'Delete';

  @override
  String get acctDeleted => 'Account deleted.';

  @override
  String get acctCommunity => 'Astryl community';

  @override
  String acctStatsLine(String registered, String active) {
    return '$registered accounts · $active active in the last 30 days';
  }

  @override
  String get acctStatsNote => 'Active means people who chose to be counted.';

  @override
  String get acctPrivacyLink => 'Privacy Policy';

  @override
  String get acctErrOffline =>
      'No internet, or the server is not answering. Try again.';

  @override
  String get acctErrTaken => 'That username is taken.';

  @override
  String get acctErrUsername =>
      'Username: 3 to 20 letters (a to z), digits or _.';

  @override
  String get acctErrPassword => 'Password: 8 to 72 characters.';

  @override
  String get acctErrMismatch => 'The two passwords are not the same.';

  @override
  String get acctErrLogin => 'Wrong username or password.';

  @override
  String get acctErrRecovery => 'Wrong username or recovery code.';

  @override
  String get acctErrUsedUp =>
      'This recovery code has already been used 3 times.';

  @override
  String get acctErrLocked => 'Too many wrong tries. Wait 15 minutes.';

  @override
  String get acctErrRate => 'Too many tries. Try again later.';

  @override
  String get acctErrGeneric => 'Something went wrong. Try again.';

  @override
  String get acctErrCode => 'A recovery code has 16 letters and digits.';

  @override
  String get myLocation => 'My location';

  @override
  String get useMyLocation => 'Use my location';

  @override
  String get locDenied => 'Location permission was not given.';

  @override
  String get locOff => 'Turn on location in your phone’s settings.';

  @override
  String get locError => 'Could not find your location. Try again.';

  @override
  String get settingsAccountSubtitle =>
      'Optional. Sync your data with astryl.space.';

  @override
  String get anonymousTitle => 'Without an account';

  @override
  String get spaceMode => 'Space';

  @override
  String get spaceBack => 'Whole Solar System';

  @override
  String get spaceHint =>
      'Drag to look around · Pinch to zoom · Tap a planet to fly to it · Sizes and distances not to scale';

  @override
  String get spacecraftAdityal1 =>
      'India\'s (ISRO) first solar observatory. Placed in a halo orbit around the Sun–Earth L1 point (1.5 million km away) to watch the Sun\'s corona and solar storms non-stop.';

  @override
  String get uniTitle => 'Universe map';

  @override
  String get uniCardHint => 'Fly from the Sun to the farthest galaxies';

  @override
  String get uniHint => 'Drag to turn · Pinch to zoom · Tap anything';

  @override
  String get uniLevelSolar => 'Solar System';

  @override
  String get uniLevelStars => 'Nearby stars';

  @override
  String get uniLevelMilkyWay => 'Milky Way';

  @override
  String get uniLevelLocal => 'Local Group';

  @override
  String get uniLevelGalaxies => 'Galaxies';

  @override
  String get uniLevelUniverse => 'Universe';

  @override
  String get uniGoTo => 'Go to';

  @override
  String get uniSearchHint => 'Search stars, galaxies, black holes';

  @override
  String get uniNothing => 'Nothing found';

  @override
  String get uniSpeedReal => 'Real time';

  @override
  String get uniSpeedDay => '1 day per second';

  @override
  String get uniSpeedYear => '1 year per second';

  @override
  String get uniSpeedMillion => '1 million years per second';

  @override
  String get uniSpeedFast => '25 million years per second';

  @override
  String get uniNow => 'Now';

  @override
  String uniAhead(String value) {
    return '$value from now';
  }

  @override
  String get uniBackToNow => 'Back to now';

  @override
  String get uniSpedUp => 'Sped up: in real time this motion is far too slow to see.';

  @override
  String get uniKindStar => 'Star';

  @override
  String get uniKindPlanet => 'Planet';

  @override
  String get uniKindBlackHole => 'Black hole';

  @override
  String get uniKindGalaxyCluster => 'Cluster of galaxies';

  @override
  String get uniShapeSpiral => 'Spiral galaxy';

  @override
  String get uniShapeBarred => 'Barred spiral galaxy';

  @override
  String get uniShapeElliptical => 'Elliptical galaxy';

  @override
  String get uniShapeLenticular => 'Lenticular galaxy';

  @override
  String get uniShapeIrregular => 'Irregular galaxy';

  @override
  String get uniDistance => 'Distance from Earth';

  @override
  String get uniDistanceNow => 'Distance today';

  @override
  String get uniLightTime => 'Its light travelled for';

  @override
  String get uniWidth => 'Width';

  @override
  String get uniMass => 'Mass';

  @override
  String get uniHorizon => 'Horizon radius';

  @override
  String get uniEstimated => 'Distance estimated from its redshift.';

  @override
  String get uniFlyHere => 'Fly here';

  @override
  String uniScreen(String value) {
    return 'Screen width ≈ $value';
  }

  @override
  String get uniEdge => 'Edge of the observable universe';

  @override
  String uniLy(String value) {
    return '$value light-years';
  }

  @override
  String uniLyK(String value) {
    return '$value thousand light-years';
  }

  @override
  String uniLyM(String value) {
    return '$value million light-years';
  }

  @override
  String uniLyB(String value) {
    return '$value billion light-years';
  }

  @override
  String uniDays(String value) {
    return '$value days';
  }

  @override
  String uniYr(String value) {
    return '$value years';
  }

  @override
  String uniYrK(String value) {
    return '$value thousand years';
  }

  @override
  String uniYrM(String value) {
    return '$value million years';
  }

  @override
  String uniYrB(String value) {
    return '$value billion years';
  }

  @override
  String uniSuns(String value) {
    return '$value Suns';
  }

  @override
  String uniSunsM(String value) {
    return '$value million Suns';
  }

  @override
  String uniSunsB(String value) {
    return '$value billion Suns';
  }

  @override
  String issBelowBy(String direction, String degrees) {
    return '$direction, $degrees° below the horizon';
  }

  @override
  String get issLight => 'Light';

  @override
  String get issInSun => 'In sunlight';

  @override
  String get issInShadow => 'In Earth\'s shadow';

  @override
  String issNextVisible(String wait, String time) {
    return 'Next easy-to-see pass in $wait, at $time';
  }

  @override
  String issNextPass(String wait, String time) {
    return 'Next pass in $wait, at $time';
  }

  @override
  String get issTrackPast => 'Where it was';

  @override
  String get issTrackNext => 'Where it is going';

  @override
  String get issNight => 'Night on Earth';

  @override
  String issDataAge(String time) {
    return 'Orbit data from $time ago';
  }

  @override
  String issDays(String value) {
    return '$value days';
  }

  @override
  String get issOnlyVisible => 'Only passes that are easy to see';

  @override
  String get issNoVisible => 'No easy-to-see passes in the next 5 days.';
}
