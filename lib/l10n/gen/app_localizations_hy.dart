// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Armenian (`hy`).
class AppLocalizationsHy extends AppLocalizations {
  AppLocalizationsHy([String locale = 'hy']) : super(locale);

  @override
  String get appTitle => 'Heliora';

  @override
  String get tagline =>
      'Ուսումնասիրեք Արեգակնային համակարգը՝ ամբողջովին անցանց';

  @override
  String get navExplore => 'Ուսումնասիրել';

  @override
  String get navCompare => 'Համեմատել';

  @override
  String get navWeight => 'Քաշ';

  @override
  String get navQuiz => 'Վիկտորինա';

  @override
  String get viewMode => 'Դիտման ռեժիմ';

  @override
  String get settings => 'Կարգավորումներ';

  @override
  String get notToScale => 'Մասշտաբով չէ · Հպեք մոլորակին՝ այն բացելու համար';

  @override
  String get dragToRotate => 'Քաշեք՝ պտտելու համար · Մատներով մեծացրեք';

  @override
  String get planetsTitle => 'Մոլորակներ';

  @override
  String get planetMercury => 'Մերկուրի';

  @override
  String get planetVenus => 'Վեներա';

  @override
  String get planetEarth => 'Երկիր';

  @override
  String get planetMars => 'Մարս';

  @override
  String get planetJupiter => 'Յուպիտեր';

  @override
  String get planetSaturn => 'Սատուրն';

  @override
  String get planetUranus => 'Ուրան';

  @override
  String get planetNeptune => 'Նեպտուն';

  @override
  String planetOrder(int n) {
    return 'Արեգակից $n-րդ մոլորակը';
  }

  @override
  String get openDetails => 'Բացել մանրամասները';

  @override
  String get diameter => 'Տրամագիծ';

  @override
  String get gravity => 'Ձգողություն';

  @override
  String get avgTemp => 'Միջին ջերմաստիճան';

  @override
  String get avgTempShort => 'Միջին ջերմ.';

  @override
  String get dayLength => 'Օր';

  @override
  String get yearLength => 'Տարի';

  @override
  String get moons => 'Հայտնի արբանյակներ';

  @override
  String get moonsShort => 'Արբանյակներ';

  @override
  String get distance => 'Հեռավորությունը Արեգակից';

  @override
  String get pressure => 'Ճնշումը մակերևույթին';

  @override
  String get noSurface => 'Պինդ մակերևույթ չունի';

  @override
  String valueKm(String value) {
    return '$value կմ';
  }

  @override
  String valueMillionKm(String value) {
    return '$value միլիոն կմ';
  }

  @override
  String valueHours(String value) {
    return '$value ժ';
  }

  @override
  String valueDays(String value) {
    return '$value օր';
  }

  @override
  String valueYears(String value) {
    return '$value տարի';
  }

  @override
  String get atmosphere => 'Մթնոլորտ';

  @override
  String get thinAtmosphere =>
      'Գրեթե մթնոլորտ չունի։ Այս գազերը կազմում են շատ բարակ շերտ՝ էկզոսֆերա։';

  @override
  String get oxygen => 'Թթվածին';

  @override
  String get oxygenVsEarth => 'Թթվածինը՝ Երկրի համեմատ';

  @override
  String get breathable => 'Պիտանի է մարդու շնչառության համար';

  @override
  String get notBreathable =>
      'Շնչել հնարավոր չէ, անհրաժեշտ է տիեզերական հագուստ';

  @override
  String weightFeelsLike(String weight) {
    return 'Երկրի վրա $weight կգ-ն այստեղ կլինի';
  }

  @override
  String get gasCo2 => 'Ածխաթթու գազ';

  @override
  String get gasN2 => 'Ազոտ';

  @override
  String get gasO2 => 'Թթվածին';

  @override
  String get gasAr => 'Արգոն';

  @override
  String get gasH2 => 'Ջրածին';

  @override
  String get gasHe => 'Հելիում';

  @override
  String get gasCh4 => 'Մեթան';

  @override
  String get gasNa => 'Նատրիում';

  @override
  String get gasK => 'Կալիում';

  @override
  String get compareTitle => 'Մոլորակների համեմատություն';

  @override
  String get compareHint => 'Ընտրեք երկու մոլորակ՝ կողք կողքի տեսնելու համար։';

  @override
  String get weightTitle => 'Ձեր քաշը այլ մոլորակների վրա';

  @override
  String get weightInput => 'Ձեր քաշը Երկրի վրա (կգ)';

  @override
  String gravityTimes(String factor) {
    return 'Երկրի ձգողության $factor×';
  }

  @override
  String get quizTitle => 'Մոլորակների վիկտորինա';

  @override
  String get quizIntro =>
      '10 հարց մոլորակների և արբանյակների մասին։ Քանի՞սին կպատասխանեք ճիշտ։';

  @override
  String get quizStart => 'Սկսել վիկտորինան';

  @override
  String quizProgress(int current, int total) {
    return 'Հարց $current/$total';
  }

  @override
  String get quizNext => 'Հաջորդը';

  @override
  String get quizSeeResult => 'Տեսնել արդյունքը';

  @override
  String get quizCorrect => 'Ճիշտ է։';

  @override
  String quizWrong(String answer) {
    return 'Ոչ այնքան։ Պատասխանն է՝ $answer։';
  }

  @override
  String quizScore(int score, int total) {
    return '$total-ից $score ճիշտ պատասխան';
  }

  @override
  String quizBest(int score) {
    return 'Լավագույն արդյունք՝ $score';
  }

  @override
  String get quizNewBest => 'Նոր լավագույն արդյունք։';

  @override
  String get quizAgain => 'Խաղալ նորից';

  @override
  String get qLargest => 'Ո՞ր մոլորակն է ամենամեծը';

  @override
  String get qSmallest => 'Ո՞ր մոլորակն է ամենափոքրը';

  @override
  String get qHottest => 'Ո՞ր մոլորակն է ամենատաքը';

  @override
  String get qColdest => 'Ո՞ր մոլորակն է ամենացուրտը';

  @override
  String get qMostMoons => 'Ո՞ր մոլորակն ունի ամենաշատ հայտնի արբանյակներ';

  @override
  String get qBreathable => 'Ո՞ր մոլորակի վրա կարող են մարդիկ շնչել օդը';

  @override
  String get qClosest => 'Ո՞ր մոլորակն է ամենամոտը Արեգակին';

  @override
  String get qFarthest => 'Ո՞ր մոլորակն է ամենահեռուն Արեգակից';

  @override
  String get qStrongestGravity => 'Ո՞ր մոլորակի ձգողությունն է ամենաուժեղը';

  @override
  String get qShortestDay => 'Ո՞ր մոլորակի օրն է ամենակարճը';

  @override
  String get qLongestDay => 'Ո՞ր մոլորակի օրն է ամենաերկարը';

  @override
  String get appearance => 'Տեսք';

  @override
  String get theme => 'Թեմա';

  @override
  String get themeSystem => 'Համակարգային';

  @override
  String get themeLight => 'Բաց';

  @override
  String get themeDark => 'Մուգ';

  @override
  String get language => 'Լեզու';

  @override
  String get appLanguage => 'Հավելվածի լեզուն';

  @override
  String get languageNote => '20 լեզու · նաև մոլորակների անունները';

  @override
  String get phoneLanguage => 'Հեռախոսի լեզուն';

  @override
  String get updates => 'Թարմացումներ';

  @override
  String get version => 'Տարբերակ';

  @override
  String get checkForUpdates => 'Ստուգել թարմացումները';

  @override
  String get checking => 'Ստուգվում է…';

  @override
  String get autoUpdateCheck => 'Ավտոմատ ստուգել օրը մեկ անգամ';

  @override
  String get updateNote =>
      'Թարմացումները գալիս են GitHub Releases-ից։ Ձեր կարգավորումները մնում են հեռախոսում։';

  @override
  String get upToDate => 'Դուք ունեք վերջին տարբերակը։';

  @override
  String get updateFailed =>
      'Չհաջողվեց միանալ GitHub-ին։ Ստուգեք ինտերնետը և նորից փորձեք։';

  @override
  String get updateAvailable => 'Հասանելի է թարմացում';

  @override
  String updateReady(String version) {
    return '$version տարբերակը պատրաստ է ներբեռնման։';
  }

  @override
  String get download => 'Ներբեռնել';

  @override
  String get later => 'Ավելի ուշ';

  @override
  String get about => 'Մասին';

  @override
  String get sourceCode => 'Սկզբնական կոդը GitHub-ում';

  @override
  String get privacyLine => 'Անցանց · Առանց գովազդի · Առանց հետևման';

  @override
  String get dataSource => 'Տվյալներ՝ NASA Planetary Fact Sheet';

  @override
  String get openFailed => 'Չհաջողվեց բացել հղումը։';

  @override
  String get bodySun => 'Արեգակ';

  @override
  String get bodyMoon => 'Լուսին';

  @override
  String get bodyPluto => 'Պլուտոն';

  @override
  String get moonIo => 'Իո';

  @override
  String get moonEuropa => 'Եվրոպա';

  @override
  String get moonGanymede => 'Գանիմեդ';

  @override
  String get moonCallisto => 'Կալիստո';

  @override
  String get moonTitan => 'Տիտան';

  @override
  String get moonEnceladus => 'Էնցելադ';

  @override
  String get moonTriton => 'Տրիտոն';

  @override
  String get kindStar => 'Մեր աստղը՝ Արեգակնային համակարգի կենտրոնը';

  @override
  String get kindDwarf => 'Գաճաճ մոլորակ';

  @override
  String moonOf(String planet) {
    return '$planet-ի արբանյակ';
  }

  @override
  String get orbitPeriod => 'Մեկ պտույտ';

  @override
  String distanceFrom(String body) {
    return 'Հեռավորությունը՝ $body';
  }

  @override
  String get composition => 'Ինչից է բաղկացած';

  @override
  String get noAtmosphere => 'Իրական մթնոլորտ չունի, գրեթե վակուում է։';

  @override
  String get majorMoons => 'Գլխավոր արբանյակներ';

  @override
  String get lifeTitle => 'Կարո՞ղ են մարդիկ այստեղ ապրել';

  @override
  String get lifeScoreShort => 'Կյանքի միավոր';

  @override
  String get lifeNote =>
      'Հաշվված է ջերմաստիճանից, օդի ճնշումից, թթվածնից, ջրից, մակերևույթից և ձգողությունից։ Երկիրը ստանում է 10։';

  @override
  String get water => 'Ջուր';

  @override
  String get waterLiquid => 'Հեղուկ ջուր';

  @override
  String get waterIce => 'Սառույց';

  @override
  String get waterOcean => 'Օվկիանոս սառույցի տակ';

  @override
  String get waterNone => 'Ջուր չկա';

  @override
  String get surface => 'Մակերևույթ';

  @override
  String get solidSurface => 'Պինդ մակերևույթ';

  @override
  String get lifeHome => 'Ճիշտ տան պես';

  @override
  String get lifeHard => 'Շատ դժվար է, պետք են փակ բազա և տիեզերական հագուստ';

  @override
  String get lifeNo => 'Անհնար է մարդկանց համար';

  @override
  String get downloadInstall => 'Ներբեռնել և տեղադրել';

  @override
  String downloadingPercent(String percent) {
    return 'Ներբեռնվում է… $percent%';
  }

  @override
  String get installNow => 'Տեղադրել';

  @override
  String get allowInstalls =>
      'Բացված էկրանին թույլ տվեք Heliora-ին տեղադրել հավելվածներ, հետո վերադարձեք և սեղմեք «Տեղադրել»։';

  @override
  String get downloadFailed =>
      'Ներբեռնումը չավարտվեց։ Ստուգեք ինտերնետը և նորից փորձեք։';

  @override
  String get tryAgain => 'Նորից փորձել';

  @override
  String get today => 'Այսօր';

  @override
  String get play => 'Միացնել';

  @override
  String get pause => 'Դադար';

  @override
  String get monthBack => '30 օր առաջ';

  @override
  String get monthForward => '30 օր հետո';

  @override
  String get positionsNote =>
      'Իրական դիրքերը այս ամսաթվին · Չափերը և հեռավորությունները մասշտաբով չեն · Հպեք մոլորակին';

  @override
  String get navYou => 'Դուք';

  @override
  String get ageTitle => 'Ձեր տարիքը այլ մոլորակների վրա';

  @override
  String get setBirthDate => 'Նշեք ծննդյան ամսաթիվը';

  @override
  String get changeBirthDate => 'Փոխել';

  @override
  String nextBirthday(String days) {
    return 'Հաջորդ ծննդյան օրը՝ $days օրից';
  }

  @override
  String get ageNote => 'Ձեր ծննդյան ամսաթիվը պահվում է միայն այս հեռախոսում։';

  @override
  String get share => 'Կիսվել';

  @override
  String shareText(String planet) {
    return '$planet-ը Heliora-ում՝ անվճար անցանց Արեգակնային համակարգի հավելված․ https://github.com/lumio-apps/heliora';
  }

  @override
  String get shareFailed => 'Չհաջողվեց կիսվել նկարով։';

  @override
  String get travelTitle => 'Որքա՞ն հեռու է';

  @override
  String get distanceFromEarth => 'Հեռավորությունը Երկրից այսօր';

  @override
  String get lightTime => 'Լույսին պետք է';

  @override
  String get bySpacecraft => 'Տիեզերանավով՝ 60 000 կմ/ժ';

  @override
  String get byCar => 'Մեքենայով՝ 100 կմ/ժ';

  @override
  String valueSeconds(String value) {
    return '$value վ';
  }

  @override
  String valueMinutes(String value) {
    return '$value ր';
  }

  @override
  String get sizeTitle => 'Չափ';

  @override
  String sizeTimes(String big, String times, String small) {
    return '$big-ը $times× ավելի լայն է, քան $small-ը։';
  }

  @override
  String sizeSimilar(String a, String b) {
    return '$a-ը և $b-ը գրեթե նույն չափի են։';
  }

  @override
  String get navSky => 'Երկինք';

  @override
  String get skyTitle => 'Այս գիշերվա երկինքը';

  @override
  String get chooseCity => 'Ընտրեք ձեր քաղաքը';

  @override
  String get chooseCityHint =>
      'Ընտրեք մոտակա քաղաքը՝ տեսնելու Լուսինը և այս գիշեր տեսանելի մոլորակները։ Տեղորոշման թույլտվություն պետք չէ, և ընտրությունը մնում է հեռախոսում։';

  @override
  String get searchCity => 'Որոնել քաղաք';

  @override
  String get noCityFound => 'Քաղաք չի գտնվել';

  @override
  String get cityNote =>
      'Ժամերը հեռախոսի ժամային գոտով են։ Մոլորակը համարվում է տեսանելի, եթե մութ երկնքում հորիզոնից առնվազն 5° բարձր է։';

  @override
  String illuminated(String percent) {
    return 'Լուսավորված է $percent%';
  }

  @override
  String get moonrise => 'Լուսնածագ';

  @override
  String get moonset => 'Լուսնամուտ';

  @override
  String get sunset => 'Մայրամուտ';

  @override
  String get sunrise => 'Արևածագ';

  @override
  String get nextFull => 'Հաջորդ լիալուսինը';

  @override
  String get nextNew => 'Հաջորդ նորալուսինը';

  @override
  String get phaseNew => 'Նորալուսին';

  @override
  String get phaseWaxingCrescent => 'Աճող մահիկ';

  @override
  String get phaseFirstQuarter => 'Առաջին քառորդ';

  @override
  String get phaseWaxingGibbous => 'Աճող լուսին';

  @override
  String get phaseFull => 'Լիալուսին';

  @override
  String get phaseWaningGibbous => 'Նվազող լուսին';

  @override
  String get phaseLastQuarter => 'Վերջին քառորդ';

  @override
  String get phaseWaningCrescent => 'Նվազող մահիկ';

  @override
  String get planetsTonight => 'Այս գիշերվա մոլորակները';

  @override
  String get statusVisible => 'Տեսանելի է այս գիշեր';

  @override
  String get statusEvening => 'Երեկոյան, մայրամուտից հետո';

  @override
  String get statusMorning => 'Առավոտյան, արևածագից առաջ';

  @override
  String get statusNotVisible => 'Այս գիշեր տեսանելի չէ';

  @override
  String bestAt(String time) {
    return 'Լավագույնը՝ $time';
  }

  @override
  String altitudeDir(String direction, String degrees) {
    return '$direction, $degrees° բարձրության վրա';
  }

  @override
  String riseSet(String rise, String set) {
    return 'Ծագում $rise · Մայրամուտ $set';
  }

  @override
  String get needsTelescope => 'Պետք է հեռադիտակ կամ աստղադիտակ';

  @override
  String get dirN => 'Հյուսիս';

  @override
  String get dirNE => 'Հյուսիս-արևելք';

  @override
  String get dirE => 'Արևելք';

  @override
  String get dirSE => 'Հարավ-արևելք';

  @override
  String get dirS => 'Հարավ';

  @override
  String get dirSW => 'Հարավ-արևմուտք';

  @override
  String get dirW => 'Արևմուտք';

  @override
  String get dirNW => 'Հյուսիս-արևմուտք';

  @override
  String get findPlanet => 'Գտնել երկնքում';

  @override
  String finderTitle(String name) {
    return 'Գտնել՝ $name';
  }

  @override
  String get pointPhone => 'Բարձրացրեք հեռախոսը և դանդաղ շարժեք։';

  @override
  String turnRight(String degrees) {
    return 'Թեքվեք աջ $degrees°';
  }

  @override
  String turnLeft(String degrees) {
    return 'Թեքվեք ձախ $degrees°';
  }

  @override
  String tiltUp(String degrees) {
    return 'Բարձրացրեք $degrees°';
  }

  @override
  String tiltDown(String degrees) {
    return 'Իջեցրեք $degrees°';
  }

  @override
  String onTarget(String name) {
    return '$name-ը հենց այնտեղ է։';
  }

  @override
  String belowHorizon(String name) {
    return '$name-ը հիմա հորիզոնից ցածր է։';
  }

  @override
  String risesAt(String time) {
    return 'Ծագում է $time-ին։';
  }

  @override
  String get noSensor =>
      'Այս հեռախոսը կողմնացույցի սենսոր չունի, ուստի որոնումը չի աշխատի։';

  @override
  String get calibrate =>
      'Կողմնացույցը պետք է չափաբերել՝ հեռախոսով մի քանի անգամ 8 գծեք։';

  @override
  String get phoneNow => 'Հեռախոսը ուղղված է';

  @override
  String get finderNote =>
      'Պահեք հեռախոսի հետևի մասը երկնքին դեմ և հեռու մագնիսներից ու մետաղից։ Երբեք մի նայեք Արեգակին։';

  @override
  String get eventsTitle => 'Տիեզերական իրադարձություններ';

  @override
  String get eventsSubtitle => 'Ինչ դիտել երկնքում առաջիկա 12 ամիսներին։';

  @override
  String eventsNext(String event, String when) {
    return 'Հաջորդը՝ $event · $when';
  }

  @override
  String get eventFullMoon => 'Լիալուսին';

  @override
  String get eventNewMoon => 'Նորալուսին';

  @override
  String eventOpposition(String planet) {
    return '$planet՝ հակադրության մեջ';
  }

  @override
  String eventEveningElongation(String planet) {
    return '$planet՝ երեկոյան դիտման լավագույն ժամանակ';
  }

  @override
  String eventMorningElongation(String planet) {
    return '$planet՝ առավոտյան դիտման լավագույն ժամանակ';
  }

  @override
  String eventConjunction(String a, String b) {
    return '$a-ը և $b-ը մոտենում են';
  }

  @override
  String get eventMarchEquinox => 'Մարտյան գիշերահավասար';

  @override
  String get eventJuneSolstice => 'Հունիսյան արևադարձ';

  @override
  String get eventSeptemberEquinox => 'Սեպտեմբերյան գիշերահավասար';

  @override
  String get eventDecemberSolstice => 'Դեկտեմբերյան արևադարձ';

  @override
  String get eventFullMoonDesc =>
      'Լուսնի ամբողջ դեմքը լուսավորված է։ Այն ծագում է մայրամուտի շուրջ։';

  @override
  String get eventNewMoonDesc =>
      'Լուսինը չի երևում։ Ամսվա ամենամութ երկինքը աստղեր և մոլորակներ դիտելու համար։';

  @override
  String eventOppositionDesc(String planet) {
    return '$planet-ը Արեգակի հակառակ կողմում է։ Այն այս տարվա ամենապայծառն է և երևում է ամբողջ գիշեր։';
  }

  @override
  String eventEveningDesc(String planet, String degrees) {
    return '$planet-ը Արեգակից $degrees° հեռու է՝ առավելագույն հեռավորության վրա։ Նայեք արևմուտքի ցածր մասին մայրամուտից հետո։';
  }

  @override
  String eventMorningDesc(String planet, String degrees) {
    return '$planet-ը Արեգակից $degrees° հեռու է՝ առավելագույն հեռավորության վրա։ Նայեք արևելքի ցածր մասին արևածագից առաջ։';
  }

  @override
  String eventConjunctionDesc(String degrees) {
    return 'Երկնքում դրանք անցնում են ընդամենը $degrees° հեռավորությամբ։';
  }

  @override
  String get eventEquinoxDesc =>
      'Երկրի վրա ամենուր ցերեկն ու գիշերը գրեթե հավասար են։';

  @override
  String get eventJuneSolsticeDesc =>
      'Ամենաերկար օրը հյուսիսում, ամենակարճը՝ հարավում։';

  @override
  String get eventDecemberSolsticeDesc =>
      'Ամենակարճ օրը հյուսիսում, ամենաերկարը՝ հարավում։';

  @override
  String eventMeteorShower(String shower) {
    return '$shower երկնաքարային հոսք';
  }

  @override
  String eventMeteorDesc(String rate, String percent) {
    return 'Մութ երկնքի տակ մինչև ժամում մոտ $rate ընկնող աստղ։ Լուսինը $percent% լուսավորված կլինի։';
  }

  @override
  String get showerQuadrantids => 'Քվադրանտիդներ';

  @override
  String get showerLyrids => 'Լիրիդներ';

  @override
  String get showerEtaAquariids => 'Էտա Ջրհոսիդներ';

  @override
  String get showerPerseids => 'Պերսեիդներ';

  @override
  String get showerOrionids => 'Օրիոնիդներ';

  @override
  String get showerLeonids => 'Լեոնիդներ';

  @override
  String get showerGeminids => 'Երկվորյակիդներ';

  @override
  String get showerUrsids => 'Ուրսիդներ';

  @override
  String get eventToday => 'Այսօր';

  @override
  String get eventTomorrow => 'Վաղը';

  @override
  String eventInDays(String days) {
    return '$days օրից';
  }

  @override
  String get eventsNote =>
      'Ամսաթվերը հաշվարկվում են ձեր հեռախոսում և ցուցադրվում նրա ժամային գոտով։ Երկնաքարային հոսքերի գագաթնակետերը տարեկան սովորական օրեր են և կարող են շեղվել մեկ օրով։ Հիշեցումները մնում են միայն ձեր հեռախոսում։';

  @override
  String get remindMe => 'Հիշեցնել';

  @override
  String reminderSet(String date) {
    return 'Լավ, կհիշեցնեմ $date-ին։';
  }

  @override
  String get reminderOff => 'Հիշեցումը հեռացվեց։';

  @override
  String get reminderTooLate =>
      'Իրադարձությունը շատ մոտ է, հիշեցում դնել հնարավոր չէ։';

  @override
  String get notificationsOff =>
      'Heliora-ի ծանուցումները անջատված են։ Միացրեք Android-ի կարգավորումներում։';

  @override
  String get reminderTomorrow => 'Վաղը';

  @override
  String get reminderToday => 'Տեղի է ունենում այսօր';

  @override
  String get onlineTitle => 'Առցանց գործառույթներ';

  @override
  String get onlineSubtitle =>
      'Ցույց տալ տիեզերակայանը և հրթիռների արձակումները։ Այդ դեպքում Heliora-ն կապվում է միայն wheretheiss.at-ի, Celestrak-ի և Launch Library 2-ի հետ, որոնք կարող են տեսնել ձեր հեռախոսի ինտերնետ հասցեն։ Ուրիշ ոչինչ չի ուղարկվում։ Լռելյայն անջատված է։';

  @override
  String get turnOnOnline => 'Միացնել առցանց գործառույթները';

  @override
  String get issTitle => 'Տիեզերակայան';

  @override
  String get issCardHint => 'Որտեղ է հիմա և երբ կանցնի ձեր վերևով';

  @override
  String get issNeedsOnline =>
      'Կայանը ցույց տալու համար Heliora-ին պետք է նրա ուղեծրի տվյալները ինտերնետից։ Դրանք ներբեռնվում են մեկ անգամ և հետո մի քանի օր աշխատում են անցանց։';

  @override
  String get issLoading => 'Ուղեծրի տվյալները բեռնվում են…';

  @override
  String get issFailed =>
      'Չհաջողվեց ստանալ ուղեծրի տվյալները։ Ստուգեք ինտերնետը և նորից փորձեք։';

  @override
  String issStale(String days) {
    return 'Ուղեծրի տվյալները $days օրվա հին են, ուստի դիրքը կարող է թեթևակի սխալ լինել։ Թարմացնելու համար միացեք ինտերնետին։';
  }

  @override
  String get issHeight => 'Բարձրություն';

  @override
  String get issSpeed => 'Արագություն';

  @override
  String get issFromYou => 'Հեռավորությունը ձեզանից';

  @override
  String valueKmh(String value) {
    return '$value կմ/ժ';
  }

  @override
  String issAboveHorizon(String direction, String degrees) {
    return 'Հիմա ձեր հորիզոնից վերև է։ Նայեք՝ $direction, $degrees° բարձրության վրա։';
  }

  @override
  String get issBelowHorizon => 'Հիմա ձեր հորիզոնից ցածր է։';

  @override
  String issPassesTitle(String city) {
    return 'Հաջորդ անցումները $city-ի վերևով';
  }

  @override
  String get issNoPasses => 'Հաջորդ 5 օրում լավ անցումներ չկան։';

  @override
  String issMaxHigh(String degrees) {
    return 'Մինչև $degrees° բարձրություն';
  }

  @override
  String issFromTo(String start, String end) {
    return '$start-ից $end';
  }

  @override
  String get issVisible => 'Հեշտ երևում է';

  @override
  String get issHidden => 'Դժվար է երևում';

  @override
  String get issPassTitle => 'Տիեզերակայանը անցնում է ձեր վերևով';

  @override
  String issPassBody(String degrees, String direction) {
    return '10 րոպեից կծագի, մինչև $degrees° բարձրության վրա։ Նայեք՝ $direction։';
  }

  @override
  String get issNote =>
      'Դիրքերը հաշվարկվում են ձեր հեռախոսում՝ կայանի ուղեծրի տվյալներից։ Անցումը հեշտ երևում է, երբ երկինքը մութ է, իսկ կայանը լուսավորված է Արևով. այն նման է պայծառ, արագ աստղի։';

  @override
  String get launchesNeedOnline =>
      'Միացրեք առցանց գործառույթները՝ այստեղ հաջորդ հրթիռային արձակումները տեսնելու համար։';

  @override
  String get launchesFailed =>
      'Չհաջողվեց թարմացնել արձակումների ցանկը։ Ցուցադրվում է պահպանվածը։';

  @override
  String get launchesNote =>
      'Արձակման ժամերը գալիս են Launch Library 2-ից և հաճախ փոխվում են։ Անունները և վայրերը անգլերեն են։';

  @override
  String get launchReminderBody =>
      'Արձակվում է մոտ մեկ ժամից։ Ժամը կարող է փոխվել։';

  @override
  String get launchTimeTbd => 'Ժամը դեռ որոշված չէ';

  @override
  String get quizChoose => 'Ընտրեք մակարդակը';

  @override
  String get levelEasy => 'Հեշտ';

  @override
  String get levelMedium => 'Միջին';

  @override
  String get levelHard => 'Դժվար';

  @override
  String get levelEasyHint => 'Հիմնական տեղեկություններ մոլորակների մասին';

  @override
  String get levelMediumHint => 'Մոլորակներ և արբանյակներ';

  @override
  String get levelHardHint => 'Բարդ համեմատություններ և դասակարգումներ';

  @override
  String get qStar => 'Սրանցից ո՞րն է աստղ, ոչ թե մոլորակ։';

  @override
  String get qDwarf => 'Սրանցից ո՞րն է թզուկ մոլորակ։';

  @override
  String get qMoonVisited => 'Ո՞ր արբանյակի վրա են մարդիկ քայլել։';

  @override
  String get qLargestMoon => 'Այս արբանյակներից ո՞րն է ամենամեծը։';

  @override
  String get qSmallestMoon => 'Այս արբանյակներից ո՞րն է ամենափոքրը։';

  @override
  String get qThickAirMoon => 'Այս արբանյակներից ո՞րն ունի խիտ մթնոլորտ։';

  @override
  String get qGeyserMoon => 'Ո՞ր արբանյակն է ջրի գեյզերներ արձակում տիեզերք։';

  @override
  String get qVolcanicMoon =>
      'Ո՞ր արբանյակի վրա կան ամենաշատ գործող հրաբուխները։';

  @override
  String get qBackwardsMoon =>
      'Ո՞ր արբանյակն է իր մոլորակի շուրջ պտտվում հակառակ ուղղությամբ։';

  @override
  String get qBiggestRocky => 'Չորս քարքարոտ մոլորակներից ո՞րն է ամենամեծը։';

  @override
  String get qColdestRocky => 'Չորս քարքարոտ մոլորակներից ո՞րն է ամենացուրտը։';

  @override
  String get qHighestPressure =>
      'Ո՞ր մոլորակի մակերևույթին է օդի ճնշումը ամենաբարձրը։';

  @override
  String get qSecondLargest => 'Ո՞ր մոլորակն է երկրորդ ամենամեծը։';

  @override
  String get qLongestYear => 'Ո՞ր մոլորակն ունի ամենաերկար տարին։';

  @override
  String get qShortestYear => 'Ո՞ր մոլորակն ունի ամենակարճ տարին։';

  @override
  String get qSmallestGiant => 'Չորս հսկա մոլորակներից ո՞րն է ամենափոքրը։';

  @override
  String get qRockyLongestYear =>
      'Չորս քարքարոտ մոլորակներից ո՞րն ունի ամենաերկար տարին։';

  @override
  String get qFastestMoon =>
      'Այս արբանյակներից ո՞րն է իր մոլորակի շուրջ ամենաարագ պտտվում։';

  @override
  String get qSlowestMoon =>
      'Այս արբանյակներից ո՞ր մեկին է ամենաշատ ժամանակ պետք իր մոլորակի շուրջը պտտվելու համար։';

  @override
  String get qStrongestMoonGravity =>
      'Այս արբանյակներից ո՞րն ունի ամենաուժեղ ձգողությունը։';

  @override
  String get qColdestMoon => 'Այս արբանյակներից ո՞րն է ամենացուրտը։';

  @override
  String get qSecondLargestMoon =>
      'Այս արբանյակներից ո՞րն է երկրորդ ամենամեծը։';

  @override
  String get factTitle => 'Գիտե՞ք, որ…';

  @override
  String get factTap => 'Հպեք՝ ևս մեկ փաստ տեսնելու համար';

  @override
  String get factSun1 =>
      'Արեգակը պարունակում է Արեգակնային համակարգի ամբողջ զանգվածի 99,8%-ը։';

  @override
  String get factSun2 =>
      'Արեգակի լույսը Երկիր հասնելու համար մոտ 8 րոպե 20 վայրկյան է ծախսում։';

  @override
  String get factMercury1 =>
      'Մերկուրիի վրա մեկ օրը՝ մի արևածագից մինչև հաջորդը, տևում է մոտ 176 երկրային օր։ Դա նրա տարվա երկու անգամն է։';

  @override
  String get factMercury2 =>
      'Մերկուրիի վրա օդ գրեթե չկա, ուստի նրա երկինքը սև է նույնիսկ ցերեկը, իսկ գիշերները սառցային են։';

  @override
  String get factVenus1 =>
      'Վեներան պտտվում է հակառակ ուղղությամբ, ուստի այնտեղ Արեգակը ծագում է արևմուտքից։';

  @override
  String get factVenus2 =>
      'Վեներան ավելի շոգ է, քան Մերկուրին, թեև Արեգակից ավելի հեռու է, որովհետև նրա խիտ օդը ջերմությունը պահում է։';

  @override
  String get factEarth1 =>
      'Երկիրը միակ վայրն է, որտեղ մենք գիտենք կյանքի մասին, և նրա մակերևույթի մոտ 71%-ը ծածկված է ջրով։';

  @override
  String get factEarth2 =>
      'Երկիրը կատարյալ գնդակ չէ։ Պտտվելու պատճառով հասարակածի մոտ մի փոքր ուռած է։';

  @override
  String get factMars1 =>
      'Մարսի Օլիմպոս լեռը Արեգակնային համակարգի ամենաբարձր հրաբուխն է՝ Էվերեստից մոտ երկուսուկես անգամ բարձր։';

  @override
  String get factMars2 => 'Մարսի վրա մայրամուտները կապույտ են երևում։';

  @override
  String get factJupiter1 =>
      'Յուպիտերի զանգվածը երկու անգամից ավելի մեծ է մնացած բոլոր մոլորակների միասին վերցրած զանգվածից։';

  @override
  String get factJupiter2 =>
      'Մեծ կարմիր բիծը Երկրից մեծ մրրիկ է, որին մարդիկ հետևում են ավելի քան 150 տարի։';

  @override
  String get factSaturn1 =>
      'Սատուրնը իր չափի համար այնքան թեթև է, որ ջրի վրա կլողար, եթե բավականաչափ մեծ լոգարան գտնվեր։';

  @override
  String get factSaturn2 =>
      'Սատուրնի օղակները շատ լայն են, բայց շատ բարակ՝ որոշ տեղերում ընդամենը մոտ տաս մետր հաստությամբ։';

  @override
  String get factUranus1 =>
      'Ուրանը Արեգակի շուրջ պտտվում է կողքի վրա գլորվելով՝ մոտ 98 աստիճանով թեքված։';

  @override
  String get factUranus2 =>
      'Ուրանը առաջին մոլորակն էր, որ հայտնաբերվեց աստղադիտակով։ Ուիլյամ Հերշելը նկատեց այն 1781 թվականին։';

  @override
  String get factNeptune1 =>
      'Նեպտունի վրա ամենաարագ քամիներն են բոլոր մոլորակների մեջ՝ ժամում ավելի քան 2000 կմ։';

  @override
  String get factNeptune2 =>
      'Նեպտունը գտնվեց մաթեմատիկայով, նախքան որևէ մեկը տեսներ այն․ 1846 թվականին աստղագետները հաշվեցին, թե որտեղ պետք է լինի։';

  @override
  String get factMoon1 =>
      'Լուսինը ամեն տարի Երկրից հեռանում է մոտ 3,8 սանտիմետրով։';

  @override
  String get factMoon2 =>
      'Մենք միշտ տեսնում ենք Լուսնի նույն կողմը, որովհետև Երկրի շուրջ ամեն պտույտի ընթացքում այն ճիշտ մեկ անգամ է պտտվում իր առանցքի շուրջ։';

  @override
  String get factPluto1 =>
      'Պլուտոնի վրա մեկ տարին տևում է մոտ 248 երկրային տարի։';

  @override
  String get factPluto2 =>
      'Պլուտոնի վրա կա սառած ազոտից կազմված սրտաձև հսկայական դաշտավայր։';

  @override
  String get factIo1 =>
      'Իոն մեր ճանաչած ամենահրաբխային աշխարհն է՝ հարյուրավոր գործող հրաբուխներով։';

  @override
  String get factIo2 =>
      'Յուպիտերի ձգողությունը սեղմում և ձգում է Իոյին, և դրանից առաջացած ջերմությունը սնում է նրա հրաբուխները։';

  @override
  String get factEuropa1 =>
      'Սառցե ընդերքի տակ Եվրոպան հավանաբար պարունակում է Երկրի բոլոր օվկիանոսների ջրի մոտ կրկնակին։';

  @override
  String get factEuropa2 =>
      'Եվրոպան Երկրից դուրս կյանք փնտրելու լավագույն վայրերից է։ «Եվրոպա Կլիպեր» սարքը դեպի այնտեղ է թռչում։';

  @override
  String get factGanymede1 =>
      'Գանիմեդը Արեգակնային համակարգի ամենամեծ արբանյակն է։ Այն նույնիսկ Մերկուրիից մեծ է։';

  @override
  String get factGanymede2 =>
      'Գանիմեդը միակ արբանյակն է, որի մասին հայտնի է, որ ունի սեփական մագնիսական դաշտ։';

  @override
  String get factCallisto1 =>
      'Կալիստոն Արեգակնային համակարգի ամենաշատ խառնարաններ ունեցող վայրերից է, և նրա մակերևույթը շատ հին է։';

  @override
  String get factCallisto2 =>
      'Կալիստոն Յուպիտերից բավականաչափ հեռու է, որ նրա ուժեղ ճառագայթումից քիչ է ստանում, ուստի գիտնականները այն առաջարկել են ապագա բազայի համար։';

  @override
  String get factTitan1 =>
      'Տիտանը միակ արբանյակն է խիտ մթնոլորտով։ Նրա մակերևույթին օդի ճնշումը Երկրի վրայից բարձր է։';

  @override
  String get factTitan2 =>
      'Տիտանի վրա կան գետեր և լճեր, բայց դրանցում ջուր չէ, այլ հեղուկ մեթան և էթան։';

  @override
  String get factEnceladus1 =>
      'Էնցելադը հարավային բևեռի մոտ գտնվող ճեղքերից սառույցի և ջրային գոլորշու շիթեր է արձակում տիեզերք։';

  @override
  String get factEnceladus2 => 'Էնցելադի շիթերը սնում են Սատուրնի E օղակը։';

  @override
  String get factTriton1 =>
      'Տրիտոնը Նեպտունի շուրջ պտտվում է հակառակ ուղղությամբ, ուստի հավանաբար թզուկ մոլորակ էր, որին Նեպտունը գրավել է։';

  @override
  String get factTriton2 =>
      'Մոտ −235 °C-ով Տրիտոնը Արեգակնային համակարգի ամենացուրտ վայրերից է, որտեղ ջերմաստիճան է չափվել։';

  @override
  String get jumpInput => 'Ձեր թռիչքի բարձրությունը Երկրի վրա (սմ)';

  @override
  String jumpHigh(String height) {
    return 'Թռիչք՝ $height';
  }

  @override
  String jumpFeelsLike(String height) {
    return 'Երկրի վրա $height թռիչքն այստեղ դառնում է';
  }

  @override
  String get jumpNote =>
      'Հրումը նույնն է, ինչ Երկրի վրա։ Արեգակի և գազային հսկաների վրա կանգնելու համար գետին չկա, ուստի սա պարզապես երևակայության խաղ է։';

  @override
  String valueCm(String value) {
    return '$value սմ';
  }

  @override
  String valueM(String value) {
    return '$value մ';
  }

  @override
  String get eclipseTotalLunar => 'Լուսնի լրիվ խավարում';

  @override
  String get eclipsePartialLunar => 'Լուսնի մասնակի խավարում';

  @override
  String get eclipsePenumbralLunar => 'Լուսնի կիսաստվերային խավարում';

  @override
  String get eclipseTotalSolar => 'Արեգակի լրիվ խավարում';

  @override
  String get eclipseAnnularSolar => 'Արեգակի օղակաձև խավարում';

  @override
  String get eclipseHybridSolar => 'Արեգակի հիբրիդային խավարում';

  @override
  String get eclipsePartialSolar => 'Արեգակի մասնակի խավարում';

  @override
  String get eclipseTotalLunarDesc =>
      'Լուսինն ամբողջությամբ մտնում է Երկրի ստվերի մեջ և հաճախ դառնում է աղոտ կարմիր։ Այն տեսնում են Երկրի գիշերային կողմում գտնվող բոլորը, և անզեն աչքով նայելը անվտանգ է։';

  @override
  String eclipsePartialLunarDesc(String percent) {
    return 'Լուսնի մի մասը (լայնության $percent%) մտնում է Երկրի մութ ստվերի մեջ։ Անզեն աչքով նայելը անվտանգ է։';
  }

  @override
  String get eclipsePenumbralLunarDesc =>
      'Լուսինն անցնում է Երկրի թույլ արտաքին ստվերով։ Այն միայն մի փոքր աղոտանում է, ուստի դժվար է նկատել։';

  @override
  String get eclipseTotalSolarDesc =>
      'Երկրի վրա նեղ շերտով Լուսինն ամբողջությամբ ծածկում է Արեգակը։ Այդ շերտից դուրս երևում է մասնակի խավարում։';

  @override
  String get eclipseAnnularSolarDesc =>
      'Լուսինը մի փոքր շատ հեռու է Արեգակն ամբողջությամբ ծածկելու համար, ուստի մնում է պայծառ օղակ։ Օղակը երևում է նեղ շերտով, դրանից դուրս խավարումը մասնակի է։';

  @override
  String get eclipseHybridSolarDesc =>
      'Իր շերտի երկայնքով այս խավարումը որոշ տեղերում լրիվ է, մյուսներում՝ օղակաձև։ Շերտից դուրս այն մասնակի է։';

  @override
  String get eclipsePartialSolarDesc =>
      'Լուսինը ծածկում է Արեգակի միայն մի մասը, և Երկրի վրա ոչ մի տեղ Արեգակն ամբողջությամբ չի ծածկվում։';

  @override
  String get eclipseNoCity =>
      'Heliora-ում ընտրեք քաղաք՝ իմանալու համար՝ կարո՞ղ եք այնտեղից դիտել։';

  @override
  String eclipseLunarUp(String city) {
    return 'Խավարման կեսին $city-ում Լուսինը հորիզոնից վեր է։';
  }

  @override
  String eclipseLunarPartly(String city) {
    return '$city-ում Լուսինը հորիզոնից վեր է խավարման միայն մի մասի ընթացքում։';
  }

  @override
  String eclipseLunarDown(String city) {
    return '$city-ում Լուսինը մնում է հորիզոնից ներքև, ուստի այնտեղից չի երևա։';
  }

  @override
  String eclipseSolarNone(String city) {
    return '$city-ից չի երևա. Լուսնի ստվերը այնտեղ չի հասնում, կամ Արեգակը հորիզոնից ներքև է։';
  }

  @override
  String eclipseSolarSlight(String city) {
    return '$city-ից առավելագույնը շատ թույլ մասնակի խավարում, որը դժվար է նկատել։';
  }

  @override
  String eclipseSolarPartial(String city, String percent) {
    return 'Մոտավոր գնահատական $city-ի համար. Լուսինը ծածկում է Արեգակի լայնության առավելագույնը մոտ $percent%-ը։';
  }

  @override
  String eclipseSolarNear(String city) {
    return '$city-ը մոտ է այն շերտին, որտեղ Արեգակը գրեթե կամ լրիվ ծածկվում է։ Նայեք խավարման քարտեզին. այս գնահատականը մոտավոր է։';
  }

  @override
  String get eclipseSolarSafety =>
      'Երբեք մի նայեք Արեգակին՝ առանց խավարման համար նախատեսված ճիշտ ակնոցի։';

  @override
  String get alertsTitle => 'Ծանուցումներ';

  @override
  String get tonightAlertSwitch => 'Այս գիշերվա երկինքը՝ ամեն երեկո';

  @override
  String get tonightAlertTime => 'Ժամ';

  @override
  String get tonightAlertNote =>
      'Կարճ նշում Լուսնի և տեսանելի մոլորակների մասին՝ ձեր ընտրած ժամին։ Հաշվարկվում է ձեր հեռախոսում, առանց համացանցի։ Android-ը թույլ է տալիս Heliora-ին նախապես պատրաստել միայն մոտ երկու շաբաթվա նշումներ, ուստի ժամանակ առ ժամանակ բացեք հավելվածը։';

  @override
  String get tonightNotifTitle => 'Այս գիշերվա երկինքը';

  @override
  String tonightMoon(String phase, String percent) {
    return 'Լուսին. $phase, լուսավորված է $percent%։';
  }

  @override
  String tonightPlanets(String planets) {
    return 'Փնտրեք. $planets։';
  }

  @override
  String get tonightNoPlanets => 'Երեկոյան երկնքում պայծառ մոլորակներ չկան։';

  @override
  String get tonightNoCity =>
      'Մոլորակները տեսնելու համար Heliora-ում ընտրեք քաղաք։';

  @override
  String get birthdayTitle => 'Իմ ծննդյան օրվա երկինքը';

  @override
  String get birthdaySubtitle =>
      'Լուսինը և մոլորակները ձեր ծննդյան օրը, և ձեր կյանքի կարևոր օրերը։';

  @override
  String get birthdayCardHint => 'Լուսնի փուլ, մոլորակներ և հանգրվաններ';

  @override
  String get birthdayNeedDate => 'Նշեք ծննդյան ամսաթիվը';

  @override
  String get birthdayMoon => 'Լուսինը ձեր ծննդյան օրը';

  @override
  String get birthdayPlanets => 'Մոլորակները այդ օրը';

  @override
  String birthdayDaysOld(String count) {
    return 'Այսօր դուք $count օրական եք։';
  }

  @override
  String get birthdayMilestones => 'Հանգրվաններ';

  @override
  String birthdayDayN(String count) {
    return 'Օր $count';
  }

  @override
  String get birthdayBillion => '1 միլիարդ վայրկյան';

  @override
  String get birthdayPassed => 'Անցել է';

  @override
  String get birthdayNote =>
      'Հաշվարկվում է ձեր հեռախոսում՝ Heliora-ի մնացած մասի նույն ուղեծրերով։ Ձեր ծննդյան ամսաթիվը երբեք չի հեռանում հեռախոսից։';

  @override
  String get missionsTitle => 'Տիեզերական առաքելություններ';

  @override
  String get missionsSubtitle =>
      'Տիեզերքի ուսումնասիրության հայտնի պահեր՝ ամենահինից սկսած։';

  @override
  String get missionsCardHint => 'Հայտնի առաքելություններ ժամանակի ընթացքում';

  @override
  String get missionSputnik1 =>
      'Առաջին արհեստական արբանյակը։ Լողափի գնդակի չափ այս մետաղական գունդը մոտ երեք ամիս պտտվեց Երկրի շուրջ։ Նրա ազդանշանը լսվում էր ռադիոյով, և սկսվեց տիեզերական դարաշրջանը։';

  @override
  String get missionVostok1 =>
      'Յուրի Գագարինը դարձավ տիեզերք թռած առաջին մարդը։ Նա մոտ 108 րոպեում մեկ անգամ պտտվեց Երկրի շուրջ։';

  @override
  String get missionApollo11 =>
      'Նիլ Արմսթրոնգն ու Բազ Օլդրինը վայրէջք կատարեցին Հանգստության ծովում և դարձան Լուսնի վրա քայլած առաջին մարդիկ։ Մայքլ Քոլինզը նրանց սպասում էր ուղեծրում։';

  @override
  String get missionVenera7 =>
      'Առաջին սարքը, որը վայրէջք կատարեց մեկ այլ մոլորակի վրա և ազդանշան ուղարկեց։ Այն Վեներայից տվյալներ էր ուղարկում մոտ 23 րոպե՝ ջարդող շոգի մեջ։';

  @override
  String get missionViking1 =>
      'Այն վայրէջք կատարեց Մարսի վրա և այնտեղ աշխատեց վեց տարուց ավելի՝ ուղարկելով մեկ այլ մոլորակի մակերևույթից լուսանկարների և եղանակի զեկույցների առաջին երկար շարքը։';

  @override
  String get missionVoyager1 =>
      'Արձակվել է 1977 թվականին, անցել է Յուպիտերի և Սատուրնի մոտով և 2012 թվականին մտել աստղերի միջև տարածություն։ Սա Երկրից ամենահեռու մարդու ստեղծած օբյեկտն է։';

  @override
  String get missionHubble =>
      'Արձակվել է 1990 թվականին, դիտում է Տիեզերքը Երկրի օդից վերև։ Նրա հստակ նկարները օգնեցին չափել Տիեզերքի տարիքը և ցույց տվեցին հազարավոր հեռավոր գալակտիկաներ։';

  @override
  String get missionHuygens =>
      'Հյուգենսը՝ Կասինիի տարած զոնդը, պարաշյուտով իջավ Սատուրնի արբանյակ Տիտանի վրա։ Դա արտաքին Արեգակնային համակարգի առաջին վայրէջքն էր, և այն մակերևույթից նկարներ ուղարկեց։';

  @override
  String get missionCuriosity =>
      'Մեքենայի չափ այս մարսագնացը վայրէջք կատարեց Գեյլի խառնարանում՝ հրթիռով աշխատող «երկնային կռունկի» օգնությամբ։ Այն պարզեց, որ Մարսը ժամանակին կյանքի համար հարմար պայմաններ է ունեցել։';

  @override
  String get missionMangalyaan =>
      'Հնդկաստանի Mars Orbiter առաքելությունը Մարսի ուղեծիր հասավ առաջին փորձից, ինչը ոչ մի երկրի չէր հաջողվել, և շատ ցածր ծախսով։';

  @override
  String get missionRosetta =>
      'Ռոզետայի վայրէջքային սարք Ֆիլեն վայրէջք կատարեց 67P/Չուրյումով–Գերասիմենկո գիսաստղի վրա՝ գիսաստղի վրա առաջին վայրէջքը։ Ռոզետան ինքը երկու տարի պտտվեց գիսաստղի շուրջ։';

  @override
  String get missionNewhorizons =>
      'Ինը տարվա ճանապարհորդությունից հետո այն անցավ Պլուտոնի մոտով և առաջին անգամ մեզ ցույց տվեց սառցե լեռներ և սրտաձև հսկայական հարթավայր։';

  @override
  String get missionPerseverance =>
      'Perseverance մարսագնացը վայրէջք կատարեց Ջեզերո խառնարանում՝ հին կյանքի հետքեր փնտրելու և ապարների նմուշներ հավաքելու համար։ Նրա Ingenuity ուղղաթիռը կատարեց մեկ այլ մոլորակի վրա առաջին ղեկավարվող թռիչքը։';

  @override
  String get missionJwst =>
      'Ամենամեծ տիեզերական աստղադիտակն ունի 6,5 մետրանոց ոսկեգույն հայելի և դիտում է երկինքը ինֆրակարմիր լույսով 1,5 միլիոն կմ հեռավորությունից։ Այն տեսնում է առաջին գալակտիկաներից մի քանիսը։';

  @override
  String get missionChandrayaan3 =>
      'Հնդկաստանը դարձավ Լուսնի վրա մեղմ վայրէջք կատարած չորրորդ երկիրը և առաջինը՝ նրա հարավային բևեռի մոտ։ Vikram վայրէջքային սարքը կրում էր Pragyan մարսագնացը։';

  @override
  String get spacecraftTitle => 'Տիեզերանավերը հիմա';

  @override
  String get spacecraftSubtitle =>
      'Որոշ հայտնի տիեզերանավեր հիմա որքան հեռու են Երկրից։';

  @override
  String get spacecraftCardHint => 'Վոյաջեր, JWST, մարսագնացներ և ավելին';

  @override
  String get spacecraftDistance => 'Հեռավորությունը Երկրից';

  @override
  String get spacecraftAltitude => 'Բարձրությունը Երկրից';

  @override
  String get spacecraftInAu => 'Աստղագիտական միավորով';

  @override
  String get spacecraftSpeed => 'Արագություն';

  @override
  String get spacecraftSignal => 'Ռադիոազդանշանը տևում է';

  @override
  String get spacecraftNote =>
      'Հեռավորությունները մոտավոր են։ Հեռավոր զոնդերի համար դրանք հաշվարկված են միջին արագությամբ և կարող են սխալվել մոտ 1%-ով, քանի որ Երկիրը պտտվում է Արեգակի շուրջ։ Մարսի հեռավորությունը հաշվարկված է այսօրվա համար։ 1 AU-ն (աստղագիտական միավոր) Երկրից Արեգակ հեռավորությունն է։';

  @override
  String valueBillionKm(String value) {
    return '$value միլիարդ կմ';
  }

  @override
  String valueAu(String value) {
    return '$value AU';
  }

  @override
  String valueKmS(String value) {
    return '$value կմ/վրկ';
  }

  @override
  String get spacecraftVoyager1 =>
      'Արձակվել է 1977 թվականին։ 2012-ին դարձավ միջաստղային տարածություն մտած առաջին տիեզերանավը։ Նրա ռադիոազդանշանը մեզ հասնելիս արդեն մոտ մեկ օր հին է լինում։';

  @override
  String get spacecraftVoyager2 =>
      'Արձակվել է 1977 թվականին։ Միակ տիեզերանավն է, որ այցելել է Ուրան և Նեպտուն, իսկ 2018-ին մտել է միջաստղային տարածություն։';

  @override
  String get spacecraftNewHorizons =>
      '2015-ին թռավ Պլուտոնի մոտով, իսկ 2019-ին՝ Կոյպերի գոտու Արոկոթ օբյեկտի մոտով։ Այն դեռ շարունակում է հեռանալ և դեռ տվյալներ է ուղարկում։';

  @override
  String get spacecraftJwst =>
      'Ամենամեծ տիեզերական աստղադիտակը, արձակվել է 2021-ին։ Այն գտնվում է L2 կոչվող կետի մոտ՝ Երկրից մոտ 1,5 մլն կմ հեռավորության վրա, և նրա արևապաշտպան վահանը միշտ դեպի Արեգակն է։';

  @override
  String get spacecraftIss =>
      'Երկրի շուրջը պտույտ է կատարում մոտ յուրաքանչյուր 90 րոպեն մեկ։ 2000 թվականից նրա վրա մարդիկ անընդմեջ ապրում են։';

  @override
  String get spacecraftHubble =>
      'Արձակվել է 1990-ին և դեռ աշխատում է։ Այն պտտվում է Երկրի շուրջը պատկերը մշուշող օդից վեր, ուստի նրա լուսանկարները շատ պարզ են։';

  @override
  String get spacecraftMarsRovers =>
      'Քյուրիոսիթին (վայրէջք է կատարել 2012-ին) և Փերսիվիրենսը (վայրէջք է կատարել 2021-ին) շարժվում են Մարսի վրա։ Մարսի հեռավորությունը փոխվում է մոտ 55 մլն կմ-ից մինչև 400 մլն կմ-ից ավելի։';

  @override
  String get searchTooltip => 'Որոնել';

  @override
  String get searchHint => 'Որոնեք մոլորակներ, արբանյակներ, առաքելություններ…';

  @override
  String get searchClear => 'Մաքրել';

  @override
  String searchEmpty(String query) {
    return '«$query»-ի համար ոչինչ չգտնվեց։';
  }

  @override
  String get searchBodies => 'Մոլորակներ և արբանյակներ';

  @override
  String get searchMissions => 'Առաքելություններ';

  @override
  String get searchSpacecraft => 'Տիեզերանավեր';

  @override
  String get favoritesTitle => 'Ընտրյալներ';

  @override
  String get favoritesEmpty =>
      'Սեղմեք մոլորակի, առաքելության կամ տիեզերանավի աստղին, և այն կմնա այստեղ։';

  @override
  String get favoriteAdd => 'Ավելացնել ընտրյալներում';

  @override
  String get favoriteRemove => 'Հեռացնել ընտրյալներից';

  @override
  String get textSize => 'Տեքստի չափը';

  @override
  String get textSizeNormal => 'Սովորական';

  @override
  String get textSizeLarge => 'Մեծ';

  @override
  String get textSizeLarger => 'Ավելի մեծ';

  @override
  String get textSizeNote =>
      'Մեծացնում է Heliora-ի տեքստը։ Այն երբեք չի լինում ձեր հեռախոսի սեփական տեքստի չափից փոքր։';

  @override
  String get skyOtherNight => 'Գիշերային երկինք';

  @override
  String get planetsThatNight => 'Այդ գիշերվա մոլորակները';

  @override
  String get previousDay => 'Նախորդ օրը';

  @override
  String get nextDay => 'Հաջորդ օրը';

  @override
  String get pickDate => 'Ընտրել ամսաթիվ';

  @override
  String get backToTonight => 'Վերադառնալ այսօրվա գիշերվան';

  @override
  String get moonCalendar => 'Լուսնի օրացույց';

  @override
  String get moonCalendarHint => 'Լուսնի փուլը ամեն օր';

  @override
  String get previousMonth => 'Նախորդ ամիսը';

  @override
  String get nextMonth => 'Հաջորդ ամիսը';

  @override
  String get keyMoonDates => 'Այս ամսվա հիմնական փուլերը';

  @override
  String get moonCalendarNote =>
      'Փուլերի ամսաթվերն ու ժամերը ցուցադրվում են ձեր հեռախոսի ժամային գոտով և ճշգրիտ են մոտավորապես մեկ ժամի սահմաններում։';

  @override
  String get seeSkyThatDay => 'Տեսնել այս օրվա երկինքը';

  @override
  String get sunLightTitle => 'Արև և լույս';

  @override
  String get firstLight => 'Առաջին լույսը';

  @override
  String get goldenMorningEnds => 'Առավոտյան ոսկե ժամի ավարտը';

  @override
  String get solarNoon => 'Արևի ամենաբարձր կետը';

  @override
  String get goldenEveningStarts => 'Երեկոյան ոսկե ժամի սկիզբը';

  @override
  String get lastLight => 'Վերջին լույսը';

  @override
  String get darkSky => 'Լրիվ մութ երկինք';

  @override
  String get sunDayLength => 'Օրվա տևողությունը';

  @override
  String durationHm(String hours, String minutes) {
    return '$hours ժ $minutes ր';
  }

  @override
  String get sunNote =>
      'Ոսկե ժամը այն է, երբ Արևը հորիզոնից 6°-ից պակաս բարձր է։ Առաջին և վերջին լույսը լինում են, երբ այն 6° ցածր է, իսկ երկինքը լրիվ մթնում է, երբ այն 18° ցածր է։ Ժամերը հաշվարկված են ձեր ընտրած ամսաթվի համար։';

  @override
  String get sunStaysUp => 'Այս օրը Արևը չի մայր մտնում։';

  @override
  String get sunStaysDown => 'Այս օրը Արևը չի ծագում։';
}
