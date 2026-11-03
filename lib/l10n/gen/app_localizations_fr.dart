// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Heliora';

  @override
  String get tagline => 'Explorez le Système solaire, entièrement hors ligne';

  @override
  String get navExplore => 'Explorer';

  @override
  String get navCompare => 'Comparer';

  @override
  String get navWeight => 'Poids';

  @override
  String get navQuiz => 'Quiz';

  @override
  String get viewMode => 'Mode d’affichage';

  @override
  String get settings => 'Réglages';

  @override
  String get notToScale =>
      'Pas à l’échelle · Touchez une planète pour l’ouvrir';

  @override
  String get dragToRotate => 'Faites glisser pour tourner · Pincez pour zoomer';

  @override
  String get planetsTitle => 'Planètes';

  @override
  String get planetMercury => 'Mercure';

  @override
  String get planetVenus => 'Vénus';

  @override
  String get planetEarth => 'Terre';

  @override
  String get planetMars => 'Mars';

  @override
  String get planetJupiter => 'Jupiter';

  @override
  String get planetSaturn => 'Saturne';

  @override
  String get planetUranus => 'Uranus';

  @override
  String get planetNeptune => 'Neptune';

  @override
  String planetOrder(int n) {
    return 'Planète n° $n depuis le Soleil';
  }

  @override
  String get openDetails => 'Voir les détails';

  @override
  String get diameter => 'Diamètre';

  @override
  String get gravity => 'Gravité';

  @override
  String get avgTemp => 'Température moyenne';

  @override
  String get avgTempShort => 'Temp. moyenne';

  @override
  String get dayLength => 'Jour';

  @override
  String get yearLength => 'Année';

  @override
  String get moons => 'Lunes connues';

  @override
  String get moonsShort => 'Lunes';

  @override
  String get distance => 'Distance au Soleil';

  @override
  String get pressure => 'Pression en surface';

  @override
  String get noSurface => 'Pas de surface solide';

  @override
  String valueKm(String value) {
    return '$value km';
  }

  @override
  String valueMillionKm(String value) {
    return '$value millions de km';
  }

  @override
  String valueHours(String value) {
    return '$value h';
  }

  @override
  String valueDays(String value) {
    return '$value jours';
  }

  @override
  String valueYears(String value) {
    return '$value ans';
  }

  @override
  String get atmosphere => 'Atmosphère';

  @override
  String get thinAtmosphere =>
      'Presque pas d’atmosphère. Ces gaz forment une couche très fine appelée exosphère.';

  @override
  String get oxygen => 'Oxygène';

  @override
  String get oxygenVsEarth => 'Oxygène comparé à la Terre';

  @override
  String get breathable => 'Respirable pour les humains';

  @override
  String get notBreathable =>
      'Non respirable, une combinaison spatiale est nécessaire';

  @override
  String weightFeelsLike(String weight) {
    return '$weight kg sur Terre donnent ici';
  }

  @override
  String get gasCo2 => 'Dioxyde de carbone';

  @override
  String get gasN2 => 'Azote';

  @override
  String get gasO2 => 'Oxygène';

  @override
  String get gasAr => 'Argon';

  @override
  String get gasH2 => 'Hydrogène';

  @override
  String get gasHe => 'Hélium';

  @override
  String get gasCh4 => 'Méthane';

  @override
  String get gasNa => 'Sodium';

  @override
  String get gasK => 'Potassium';

  @override
  String get compareTitle => 'Comparer les planètes';

  @override
  String get compareHint =>
      'Choisissez deux planètes pour les voir côte à côte.';

  @override
  String get weightTitle => 'Votre poids sur les autres planètes';

  @override
  String get weightInput => 'Votre poids sur Terre (kg)';

  @override
  String gravityTimes(String factor) {
    return '$factor× la gravité terrestre';
  }

  @override
  String get quizTitle => 'Quiz des planètes';

  @override
  String get quizIntro =>
      '10 questions sur les planètes et les lunes. Combien en réussirez-vous ?';

  @override
  String get quizStart => 'Commencer le quiz';

  @override
  String quizProgress(int current, int total) {
    return 'Question $current sur $total';
  }

  @override
  String get quizNext => 'Suivant';

  @override
  String get quizSeeResult => 'Voir le résultat';

  @override
  String get quizCorrect => 'Correct !';

  @override
  String quizWrong(String answer) {
    return 'Pas tout à fait. La réponse est $answer.';
  }

  @override
  String quizScore(int score, int total) {
    return '$score bonnes réponses sur $total';
  }

  @override
  String quizBest(int score) {
    return 'Meilleur score : $score';
  }

  @override
  String get quizNewBest => 'Nouveau meilleur score !';

  @override
  String get quizAgain => 'Rejouer';

  @override
  String get qLargest => 'Quelle est la plus grande planète ?';

  @override
  String get qSmallest => 'Quelle est la plus petite planète ?';

  @override
  String get qHottest => 'Quelle est la planète la plus chaude ?';

  @override
  String get qColdest => 'Quelle est la planète la plus froide ?';

  @override
  String get qMostMoons => 'Quelle planète a le plus de lunes connues ?';

  @override
  String get qBreathable =>
      'Sur quelle planète les humains peuvent-ils respirer l’air ?';

  @override
  String get qClosest => 'Quelle planète est la plus proche du Soleil ?';

  @override
  String get qFarthest => 'Quelle planète est la plus éloignée du Soleil ?';

  @override
  String get qStrongestGravity => 'Quelle planète a la gravité la plus forte ?';

  @override
  String get qShortestDay => 'Quelle planète a le jour le plus court ?';

  @override
  String get qLongestDay => 'Quelle planète a le jour le plus long ?';

  @override
  String get appearance => 'Apparence';

  @override
  String get theme => 'Thème';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get language => 'Langue';

  @override
  String get appLanguage => 'Langue de l’app';

  @override
  String get languageNote => '20 langues · noms des planètes inclus';

  @override
  String get phoneLanguage => 'Langue du téléphone';

  @override
  String get updates => 'Mises à jour';

  @override
  String get version => 'Version';

  @override
  String get checkForUpdates => 'Rechercher des mises à jour';

  @override
  String get checking => 'Recherche…';

  @override
  String get autoUpdateCheck => 'Vérifier automatiquement une fois par jour';

  @override
  String get updateNote =>
      'Les mises à jour viennent de GitHub Releases. Vos réglages restent sur votre téléphone.';

  @override
  String get upToDate => 'Vous avez la dernière version.';

  @override
  String get updateFailed =>
      'Impossible de joindre GitHub. Vérifiez votre connexion et réessayez.';

  @override
  String get updateAvailable => 'Mise à jour disponible';

  @override
  String updateReady(String version) {
    return 'La version $version est prête à être téléchargée.';
  }

  @override
  String get download => 'Télécharger';

  @override
  String get later => 'Plus tard';

  @override
  String get about => 'À propos';

  @override
  String get sourceCode => 'Code source sur GitHub';

  @override
  String get privacyLine => 'Hors ligne · Sans publicité · Sans pistage';

  @override
  String get dataSource => 'Données : NASA Planetary Fact Sheet';

  @override
  String get openFailed => 'Impossible d’ouvrir le lien.';

  @override
  String get bodySun => 'Soleil';

  @override
  String get bodyMoon => 'Lune';

  @override
  String get bodyPluto => 'Pluton';

  @override
  String get moonIo => 'Io';

  @override
  String get moonEuropa => 'Europe';

  @override
  String get moonGanymede => 'Ganymède';

  @override
  String get moonCallisto => 'Callisto';

  @override
  String get moonTitan => 'Titan';

  @override
  String get moonEnceladus => 'Encelade';

  @override
  String get moonTriton => 'Triton';

  @override
  String get kindStar => 'Notre étoile, le centre du Système solaire';

  @override
  String get kindDwarf => 'Planète naine';

  @override
  String moonOf(String planet) {
    return 'Lune de $planet';
  }

  @override
  String get orbitPeriod => 'Une orbite';

  @override
  String distanceFrom(String body) {
    return 'Distance à $body';
  }

  @override
  String get composition => 'De quoi il est fait';

  @override
  String get noAtmosphere => 'Pas de vraie atmosphère, c’est presque le vide.';

  @override
  String get majorMoons => 'Lunes principales';

  @override
  String get lifeTitle => 'Les humains pourraient-ils vivre ici ?';

  @override
  String get lifeScoreShort => 'Score de vie';

  @override
  String get lifeNote =>
      'Calculé d’après la température, la pression de l’air, l’oxygène, l’eau, la surface et la gravité. La Terre obtient 10.';

  @override
  String get water => 'Eau';

  @override
  String get waterLiquid => 'Eau liquide';

  @override
  String get waterIce => 'Glace';

  @override
  String get waterOcean => 'Océan sous la glace';

  @override
  String get waterNone => 'Pas d’eau';

  @override
  String get surface => 'Surface';

  @override
  String get solidSurface => 'Surface solide';

  @override
  String get lifeHome => 'Comme à la maison';

  @override
  String get lifeHard =>
      'Très difficile, il faudrait une base fermée et des combinaisons';

  @override
  String get lifeNo => 'Impossible pour les humains';

  @override
  String get downloadInstall => 'Télécharger et installer';

  @override
  String downloadingPercent(String percent) {
    return 'Téléchargement… $percent %';
  }

  @override
  String get installNow => 'Installer';

  @override
  String get allowInstalls =>
      'Autorisez Heliora à installer des apps sur l’écran qui s’est ouvert, puis revenez et touchez Installer.';

  @override
  String get downloadFailed =>
      'Le téléchargement n’a pas abouti. Vérifiez votre connexion et réessayez.';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get today => 'Aujourd’hui';

  @override
  String get play => 'Lecture';

  @override
  String get pause => 'Pause';

  @override
  String get monthBack => '30 jours plus tôt';

  @override
  String get monthForward => '30 jours plus tard';

  @override
  String get positionsNote =>
      'Positions réelles à cette date · Tailles et distances pas à l’échelle · Touchez une planète';

  @override
  String get navYou => 'Vous';

  @override
  String get ageTitle => 'Votre âge sur les autres planètes';

  @override
  String get setBirthDate => 'Indiquez votre date de naissance';

  @override
  String get changeBirthDate => 'Modifier';

  @override
  String nextBirthday(String days) {
    return 'Prochain anniversaire dans $days jours';
  }

  @override
  String get ageNote =>
      'Votre date de naissance reste uniquement sur ce téléphone.';

  @override
  String get share => 'Partager';

  @override
  String shareText(String planet) {
    return '$planet dans Heliora, l’app gratuite du Système solaire hors ligne : https://github.com/lumio-apps/heliora';
  }

  @override
  String get shareFailed => 'Impossible de partager l’image.';

  @override
  String get travelTitle => 'À quelle distance ?';

  @override
  String get distanceFromEarth => 'Distance de la Terre aujourd’hui';

  @override
  String get lightTime => 'La lumière met';

  @override
  String get bySpacecraft => 'En vaisseau à 60 000 km/h';

  @override
  String get byCar => 'En voiture à 100 km/h';

  @override
  String valueSeconds(String value) {
    return '$value s';
  }

  @override
  String valueMinutes(String value) {
    return '$value min';
  }

  @override
  String get sizeTitle => 'Taille';

  @override
  String sizeTimes(String big, String times, String small) {
    return '$big est $times× plus large que $small.';
  }

  @override
  String sizeSimilar(String a, String b) {
    return '$a et $b ont à peu près la même taille.';
  }

  @override
  String get navSky => 'Ciel';

  @override
  String get skyTitle => 'Le ciel de ce soir';

  @override
  String get chooseCity => 'Choisissez votre ville';

  @override
  String get chooseCityHint =>
      'Choisissez la ville la plus proche pour voir la Lune et les planètes visibles ce soir. Aucune autorisation de position n’est nécessaire et le choix reste sur votre téléphone.';

  @override
  String get searchCity => 'Rechercher une ville';

  @override
  String get noCityFound => 'Aucune ville trouvée';

  @override
  String get cityNote =>
      'Les heures sont dans le fuseau horaire du téléphone. Une planète est visible si elle est à au moins 5° au-dessus de l’horizon dans un ciel noir.';

  @override
  String illuminated(String percent) {
    return '$percent % éclairée';
  }

  @override
  String get moonrise => 'Lever de lune';

  @override
  String get moonset => 'Coucher de lune';

  @override
  String get sunset => 'Coucher du soleil';

  @override
  String get sunrise => 'Lever du soleil';

  @override
  String get nextFull => 'Prochaine pleine lune';

  @override
  String get nextNew => 'Prochaine nouvelle lune';

  @override
  String get phaseNew => 'Nouvelle lune';

  @override
  String get phaseWaxingCrescent => 'Premier croissant';

  @override
  String get phaseFirstQuarter => 'Premier quartier';

  @override
  String get phaseWaxingGibbous => 'Gibbeuse croissante';

  @override
  String get phaseFull => 'Pleine lune';

  @override
  String get phaseWaningGibbous => 'Gibbeuse décroissante';

  @override
  String get phaseLastQuarter => 'Dernier quartier';

  @override
  String get phaseWaningCrescent => 'Dernier croissant';

  @override
  String get planetsTonight => 'Planètes ce soir';

  @override
  String get statusVisible => 'Visible ce soir';

  @override
  String get statusEvening => 'Le soir, après le coucher du soleil';

  @override
  String get statusMorning => 'Le matin, avant le lever du soleil';

  @override
  String get statusNotVisible => 'Pas visible ce soir';

  @override
  String bestAt(String time) {
    return 'Idéal à $time';
  }

  @override
  String altitudeDir(String direction, String degrees) {
    return '$direction, à $degrees° de hauteur';
  }

  @override
  String riseSet(String rise, String set) {
    return 'Lever $rise · Coucher $set';
  }

  @override
  String get needsTelescope => 'Jumelles ou télescope nécessaires';

  @override
  String get dirN => 'Nord';

  @override
  String get dirNE => 'Nord-est';

  @override
  String get dirE => 'Est';

  @override
  String get dirSE => 'Sud-est';

  @override
  String get dirS => 'Sud';

  @override
  String get dirSW => 'Sud-ouest';

  @override
  String get dirW => 'Ouest';

  @override
  String get dirNW => 'Nord-ouest';

  @override
  String get findPlanet => 'Trouver dans le ciel';

  @override
  String finderTitle(String name) {
    return 'Trouver $name';
  }

  @override
  String get pointPhone => 'Levez votre téléphone et déplacez-le lentement.';

  @override
  String turnRight(String degrees) {
    return 'Tournez à droite de $degrees°';
  }

  @override
  String turnLeft(String degrees) {
    return 'Tournez à gauche de $degrees°';
  }

  @override
  String tiltUp(String degrees) {
    return 'Inclinez vers le haut de $degrees°';
  }

  @override
  String tiltDown(String degrees) {
    return 'Inclinez vers le bas de $degrees°';
  }

  @override
  String onTarget(String name) {
    return '$name est juste là !';
  }

  @override
  String belowHorizon(String name) {
    return '$name est actuellement sous l’horizon.';
  }

  @override
  String risesAt(String time) {
    return 'Il se lève à $time.';
  }

  @override
  String get noSensor =>
      'Ce téléphone n’a pas de capteur de boussole, la recherche ne peut donc pas fonctionner.';

  @override
  String get calibrate =>
      'La boussole doit être étalonnée : dessinez quelques 8 avec votre téléphone.';

  @override
  String get phoneNow => 'Votre téléphone pointe vers';

  @override
  String get finderNote =>
      'Tenez le téléphone avec l’arrière vers le ciel, loin des aimants et du métal. Ne regardez jamais le Soleil.';

  @override
  String get eventsTitle => 'Événements spatiaux';

  @override
  String get eventsSubtitle =>
      'À observer dans le ciel durant les 12 prochains mois.';

  @override
  String eventsNext(String event, String when) {
    return 'Prochain : $event · $when';
  }

  @override
  String get eventFullMoon => 'Pleine Lune';

  @override
  String get eventNewMoon => 'Nouvelle Lune';

  @override
  String eventOpposition(String planet) {
    return '$planet à l’opposition';
  }

  @override
  String eventEveningElongation(String planet) {
    return '$planet : meilleure visibilité le soir';
  }

  @override
  String eventMorningElongation(String planet) {
    return '$planet : meilleure visibilité le matin';
  }

  @override
  String eventConjunction(String a, String b) {
    return '$a et $b se rapprochent';
  }

  @override
  String get eventMarchEquinox => 'Équinoxe de mars';

  @override
  String get eventJuneSolstice => 'Solstice de juin';

  @override
  String get eventSeptemberEquinox => 'Équinoxe de septembre';

  @override
  String get eventDecemberSolstice => 'Solstice de décembre';

  @override
  String get eventFullMoonDesc =>
      'Toute la face de la Lune est éclairée. Elle se lève vers le coucher du Soleil.';

  @override
  String get eventNewMoonDesc =>
      'La Lune est invisible. Le ciel le plus sombre du mois pour voir les étoiles et les planètes.';

  @override
  String eventOppositionDesc(String planet) {
    return '$planet est à l’opposé du Soleil. Elle est à son plus brillant de l’année et visible toute la nuit.';
  }

  @override
  String eventEveningDesc(String planet, String degrees) {
    return '$planet est à $degrees° du Soleil, son écart maximal. Regardez bas à l’ouest après le coucher du Soleil.';
  }

  @override
  String eventMorningDesc(String planet, String degrees) {
    return '$planet est à $degrees° du Soleil, son écart maximal. Regardez bas à l’est avant le lever du Soleil.';
  }

  @override
  String eventConjunctionDesc(String degrees) {
    return 'Elles ne passent qu’à $degrees° l’une de l’autre dans le ciel.';
  }

  @override
  String get eventEquinoxDesc =>
      'Le jour et la nuit ont presque la même durée partout sur Terre.';

  @override
  String get eventJuneSolsticeDesc =>
      'Jour le plus long au nord, le plus court au sud.';

  @override
  String get eventDecemberSolsticeDesc =>
      'Jour le plus court au nord, le plus long au sud.';

  @override
  String eventMeteorShower(String shower) {
    return 'Pluie d’étoiles filantes : $shower';
  }

  @override
  String eventMeteorDesc(String rate, String percent) {
    return 'Jusqu’à environ $rate météores par heure sous un ciel sombre. La Lune sera éclairée à $percent %.';
  }

  @override
  String get showerQuadrantids => 'Quadrantides';

  @override
  String get showerLyrids => 'Lyrides';

  @override
  String get showerEtaAquariids => 'Êta Aquarides';

  @override
  String get showerPerseids => 'Perséides';

  @override
  String get showerOrionids => 'Orionides';

  @override
  String get showerLeonids => 'Léonides';

  @override
  String get showerGeminids => 'Géminides';

  @override
  String get showerUrsids => 'Ursides';

  @override
  String get eventToday => 'Aujourd’hui';

  @override
  String get eventTomorrow => 'Demain';

  @override
  String eventInDays(String days) {
    return 'Dans $days jours';
  }

  @override
  String get eventsNote =>
      'Les dates sont calculées sur votre téléphone et affichées dans son fuseau horaire. Les pics des pluies d’étoiles filantes sont des dates habituelles et peuvent varier d’un jour. Les rappels restent sur votre téléphone.';

  @override
  String get remindMe => 'Me le rappeler';

  @override
  String reminderSet(String date) {
    return 'D’accord, je vous le rappellerai le $date.';
  }

  @override
  String get reminderOff => 'Rappel supprimé.';

  @override
  String get reminderTooLate =>
      'Cet événement est trop proche pour régler un rappel.';

  @override
  String get notificationsOff =>
      'Les notifications de Heliora sont désactivées. Activez-les dans les réglages d’Android.';

  @override
  String get reminderTomorrow => 'C’est demain';

  @override
  String get reminderToday => 'Cela se passe aujourd’hui';

  @override
  String get onlineTitle => 'Fonctions en ligne';

  @override
  String get onlineSubtitle =>
      'Affichez la station spatiale et les lancements de fusées. Heliora ne contacte alors que wheretheiss.at, Celestrak et Launch Library 2, qui peuvent voir l’adresse internet de votre téléphone. Rien d’autre n’est envoyé. Désactivé par défaut.';

  @override
  String get turnOnOnline => 'Activer les fonctions en ligne';

  @override
  String get issTitle => 'Station spatiale';

  @override
  String get issCardHint =>
      'Où elle est maintenant et quand elle passe au-dessus de vous';

  @override
  String get issNeedsOnline =>
      'Pour afficher la station, Heliora a besoin de ses données d’orbite depuis internet. Elles sont téléchargées une fois, puis fonctionnent hors ligne pendant des jours.';

  @override
  String get issLoading => 'Récupération des données d’orbite…';

  @override
  String get issFailed =>
      'Impossible d’obtenir les données d’orbite. Vérifiez votre connexion et réessayez.';

  @override
  String issStale(String days) {
    return 'Les données d’orbite datent de $days jours, les positions peuvent donc être décalées. Connectez-vous à internet pour les actualiser.';
  }

  @override
  String get issHeight => 'Altitude';

  @override
  String get issSpeed => 'Vitesse';

  @override
  String get issFromYou => 'Distance de vous';

  @override
  String valueKmh(String value) {
    return '$value km/h';
  }

  @override
  String issAboveHorizon(String direction, String degrees) {
    return 'Au-dessus de votre horizon maintenant ! Regardez vers $direction, à $degrees° de hauteur.';
  }

  @override
  String get issBelowHorizon => 'Sous votre horizon pour l’instant.';

  @override
  String issPassesTitle(String city) {
    return 'Prochains passages au-dessus de $city';
  }

  @override
  String get issNoPasses => 'Aucun bon passage dans les 5 prochains jours.';

  @override
  String issMaxHigh(String degrees) {
    return 'Jusqu’à $degrees° de hauteur';
  }

  @override
  String issFromTo(String start, String end) {
    return 'De $start à $end';
  }

  @override
  String get issVisible => 'Facile à voir';

  @override
  String get issHidden => 'Difficile à voir';

  @override
  String get issPassTitle => 'La station spatiale passe au-dessus de vous';

  @override
  String issPassBody(String degrees, String direction) {
    return 'Se lève dans 10 minutes, jusqu’à $degrees° de hauteur. Regardez vers $direction.';
  }

  @override
  String get issNote =>
      'Les positions sont calculées sur votre téléphone à partir des données d’orbite de la station. Un passage est facile à voir quand le ciel est sombre et que le Soleil éclaire la station : elle ressemble à une étoile brillante et rapide.';

  @override
  String get launchesNeedOnline =>
      'Activez les fonctions en ligne pour voir ici les prochains lancements de fusées.';

  @override
  String get launchesFailed =>
      'Impossible de mettre à jour la liste des lancements. La liste enregistrée est affichée.';

  @override
  String get launchesNote =>
      'Les heures de lancement viennent de Launch Library 2 et changent souvent. Les noms et lieux sont en anglais.';

  @override
  String get launchReminderBody =>
      'Décolle dans environ une heure. L’heure peut changer.';

  @override
  String get launchTimeTbd => 'Heure pas encore fixée';

  @override
  String get quizChoose => 'Choisissez un niveau';

  @override
  String get levelEasy => 'Facile';

  @override
  String get levelMedium => 'Moyen';

  @override
  String get levelHard => 'Difficile';

  @override
  String get levelEasyHint => 'Les bases sur les planètes';

  @override
  String get levelMediumHint => 'Planètes et lunes';

  @override
  String get levelHardHint => 'Comparaisons et classements difficiles';

  @override
  String get qStar =>
      'Lequel de ces astres est une étoile et non une planète ?';

  @override
  String get qDwarf => 'Lequel de ces astres est une planète naine ?';

  @override
  String get qMoonVisited => 'Sur quelle lune des humains ont-ils marché ?';

  @override
  String get qLargestMoon => 'Laquelle de ces lunes est la plus grande ?';

  @override
  String get qSmallestMoon => 'Laquelle de ces lunes est la plus petite ?';

  @override
  String get qThickAirMoon =>
      'Laquelle de ces lunes a une atmosphère épaisse ?';

  @override
  String get qGeyserMoon =>
      'Quelle lune projette des geysers d’eau dans l’espace ?';

  @override
  String get qVolcanicMoon => 'Quelle lune a les volcans les plus actifs ?';

  @override
  String get qBackwardsMoon =>
      'Quelle lune tourne autour de sa planète à l’envers ?';

  @override
  String get qBiggestRocky =>
      'Laquelle des quatre planètes rocheuses est la plus grande ?';

  @override
  String get qColdestRocky =>
      'Laquelle des quatre planètes rocheuses est la plus froide ?';

  @override
  String get qHighestPressure =>
      'Quelle planète a la pression de l’air la plus forte à sa surface ?';

  @override
  String get qSecondLargest => 'Quelle planète est la deuxième plus grande ?';

  @override
  String get qLongestYear => 'Quelle planète a l’année la plus longue ?';

  @override
  String get qShortestYear => 'Quelle planète a l’année la plus courte ?';

  @override
  String get qSmallestGiant =>
      'Laquelle des quatre planètes géantes est la plus petite ?';

  @override
  String get qRockyLongestYear =>
      'Laquelle des quatre planètes rocheuses a l’année la plus longue ?';

  @override
  String get qFastestMoon =>
      'Laquelle de ces lunes fait le tour de sa planète le plus vite ?';

  @override
  String get qSlowestMoon =>
      'Laquelle de ces lunes met le plus de temps à faire le tour de sa planète ?';

  @override
  String get qStrongestMoonGravity =>
      'Laquelle de ces lunes a la gravité la plus forte ?';

  @override
  String get qColdestMoon => 'Laquelle de ces lunes est la plus froide ?';

  @override
  String get qSecondLargestMoon =>
      'Laquelle de ces lunes est la deuxième plus grande ?';

  @override
  String get factTitle => 'Le saviez-vous ?';

  @override
  String get factTap => 'Touchez pour un autre fait';

  @override
  String get factSun1 =>
      'Le Soleil contient 99,8 % de toute la masse du système solaire.';

  @override
  String get factSun2 =>
      'La lumière du Soleil met environ 8 minutes et 20 secondes pour atteindre la Terre.';

  @override
  String get factMercury1 =>
      'Un jour sur Mercure, d’un lever de soleil au suivant, dure environ 176 jours terrestres. C’est deux fois plus long que son année.';

  @override
  String get factMercury2 =>
      'Mercure n’a presque pas d’air, donc son ciel est noir même de jour, et ses nuits sont glaciales.';

  @override
  String get factVenus1 =>
      'Vénus tourne à l’envers, donc sur Vénus le Soleil se lève à l’ouest.';

  @override
  String get factVenus2 =>
      'Vénus est plus chaude que Mercure, bien qu’elle soit plus loin du Soleil, car son air épais retient la chaleur.';

  @override
  String get factEarth1 =>
      'La Terre est le seul endroit où l’on connaît la vie, et environ 71 % de sa surface est couverte d’eau.';

  @override
  String get factEarth2 =>
      'La Terre n’est pas une boule parfaite. Elle est un peu renflée à l’équateur parce qu’elle tourne.';

  @override
  String get factMars1 =>
      'Olympus Mons, sur Mars, est le plus haut volcan du système solaire, environ deux fois et demie plus haut que l’Everest.';

  @override
  String get factMars2 => 'Les couchers de soleil sur Mars sont bleus.';

  @override
  String get factJupiter1 =>
      'Jupiter a plus de deux fois la masse de toutes les autres planètes réunies.';

  @override
  String get factJupiter2 =>
      'La Grande Tache rouge est une tempête plus grande que la Terre, observée depuis plus de 150 ans.';

  @override
  String get factSaturn1 =>
      'Saturne est si légère pour sa taille qu’elle flotterait sur l’eau, si l’on trouvait une baignoire assez grande.';

  @override
  String get factSaturn2 =>
      'Les anneaux de Saturne sont très larges mais très fins : par endroits, seulement une dizaine de mètres d’épaisseur.';

  @override
  String get factUranus1 =>
      'Uranus roule autour du Soleil sur le côté, incliné d’environ 98 degrés.';

  @override
  String get factUranus2 =>
      'Uranus a été la première planète découverte avec un télescope. William Herschel l’a repérée en 1781.';

  @override
  String get factNeptune1 =>
      'Neptune a les vents les plus rapides de toutes les planètes, plus de 2 000 km/h.';

  @override
  String get factNeptune2 =>
      'Neptune a été trouvée par les maths avant que quiconque la voie : en 1846, des astronomes ont calculé où elle devait être.';

  @override
  String get factMoon1 =>
      'La Lune s’éloigne de la Terre d’environ 3,8 centimètres chaque année.';

  @override
  String get factMoon2 =>
      'On voit toujours la même face de la Lune, car elle tourne exactement une fois sur elle-même à chaque tour autour de la Terre.';

  @override
  String get factPluto1 =>
      'Une année sur Pluton dure environ 248 années terrestres.';

  @override
  String get factPluto2 =>
      'Pluton a une immense plaine en forme de cœur faite d’azote gelé.';

  @override
  String get factIo1 =>
      'Io est le monde le plus volcanique que l’on connaisse, avec des centaines de volcans actifs.';

  @override
  String get factIo2 =>
      'La gravité de Jupiter comprime et étire Io, et la chaleur ainsi produite alimente ses volcans.';

  @override
  String get factEuropa1 =>
      'Sous sa carapace de glace, Europe contient probablement environ deux fois plus d’eau que tous les océans de la Terre.';

  @override
  String get factEuropa2 =>
      'Europe est l’un des meilleurs endroits où chercher la vie hors de la Terre. La sonde Europa Clipper est en route.';

  @override
  String get factGanymede1 =>
      'Ganymède est la plus grande lune du système solaire. Elle est même plus grande que Mercure.';

  @override
  String get factGanymede2 =>
      'Ganymède est la seule lune connue qui possède son propre champ magnétique.';

  @override
  String get factCallisto1 =>
      'Callisto est l’un des endroits les plus cratérisés du système solaire, et sa surface est très ancienne.';

  @override
  String get factCallisto2 =>
      'Callisto est assez loin de Jupiter pour recevoir moins de son rayonnement violent, c’est pourquoi des scientifiques l’ont proposée pour une future base.';

  @override
  String get factTitan1 =>
      'Titan est la seule lune dotée d’une atmosphère épaisse. Sa pression à la surface est plus élevée que sur Terre.';

  @override
  String get factTitan2 =>
      'Titan a des rivières et des lacs, mais ils contiennent du méthane et de l’éthane liquides, pas de l’eau.';

  @override
  String get factEnceladus1 =>
      'Encelade projette des jets de glace et de vapeur d’eau dans l’espace par des fissures près de son pôle sud.';

  @override
  String get factEnceladus2 =>
      'Les jets d’Encelade alimentent l’anneau E de Saturne.';

  @override
  String get factTriton1 =>
      'Triton tourne autour de Neptune à l’envers, c’était donc probablement une planète naine capturée par Neptune.';

  @override
  String get factTriton2 =>
      'À environ −235 °C, Triton est l’un des endroits les plus froids jamais mesurés dans le système solaire.';

  @override
  String get jumpInput => 'La hauteur de votre saut sur Terre (cm)';

  @override
  String jumpHigh(String height) {
    return 'Saut : $height';
  }

  @override
  String jumpFeelsLike(String height) {
    return 'Un saut de $height sur Terre devient';
  }

  @override
  String get jumpNote =>
      'Avec la même impulsion que sur Terre. Sur le Soleil et les géantes gazeuses, il n’y a pas de sol où se tenir : ce n’est qu’un jeu d’imagination.';

  @override
  String valueCm(String value) {
    return '$value cm';
  }

  @override
  String valueM(String value) {
    return '$value m';
  }

  @override
  String get eclipseTotalLunar => 'Éclipse totale de Lune';

  @override
  String get eclipsePartialLunar => 'Éclipse partielle de Lune';

  @override
  String get eclipsePenumbralLunar => 'Éclipse de Lune par la pénombre';

  @override
  String get eclipseTotalSolar => 'Éclipse totale de Soleil';

  @override
  String get eclipseAnnularSolar => 'Éclipse annulaire de Soleil';

  @override
  String get eclipseHybridSolar => 'Éclipse hybride de Soleil';

  @override
  String get eclipsePartialSolar => 'Éclipse partielle de Soleil';

  @override
  String get eclipseTotalLunarDesc =>
      'La Lune entre entièrement dans l’ombre de la Terre et devient souvent rouge sombre. Tout le monde du côté nuit de la Terre peut la voir, et on peut la regarder à l’œil nu sans danger.';

  @override
  String eclipsePartialLunarDesc(String percent) {
    return 'Une partie de la Lune ($percent % de sa largeur) entre dans l’ombre sombre de la Terre. On peut la regarder à l’œil nu sans danger.';
  }

  @override
  String get eclipsePenumbralLunarDesc =>
      'La Lune traverse la faible ombre extérieure de la Terre. Elle s’assombrit à peine, donc c’est difficile à remarquer.';

  @override
  String get eclipseTotalSolarDesc =>
      'La Lune cache complètement le Soleil le long d’une bande étroite sur Terre. En dehors de cette bande, l’éclipse est partielle.';

  @override
  String get eclipseAnnularSolarDesc =>
      'La Lune est un peu trop loin pour cacher tout le Soleil, il reste donc un anneau lumineux. L’anneau se voit le long d’une bande étroite ; en dehors, l’éclipse est partielle.';

  @override
  String get eclipseHybridSolarDesc =>
      'Le long de sa bande, cette éclipse est totale à certains endroits et annulaire à d’autres. En dehors de la bande, elle est partielle.';

  @override
  String get eclipsePartialSolarDesc =>
      'La Lune ne cache qu’une partie du Soleil, et nulle part sur Terre le Soleil n’est entièrement caché.';

  @override
  String get eclipseNoCity =>
      'Choisissez une ville dans Heliora pour savoir si vous pouvez l’observer de là-bas.';

  @override
  String eclipseLunarUp(String city) {
    return 'Au milieu de l’éclipse, la Lune est au-dessus de l’horizon à $city.';
  }

  @override
  String eclipseLunarPartly(String city) {
    return 'À $city, la Lune n’est au-dessus de l’horizon que pendant une partie de l’éclipse.';
  }

  @override
  String eclipseLunarDown(String city) {
    return 'À $city, la Lune reste sous l’horizon : on ne la voit pas de là-bas.';
  }

  @override
  String eclipseSolarNone(String city) {
    return 'Invisible depuis $city : l’ombre de la Lune n’y passe pas, ou le Soleil est sous l’horizon.';
  }

  @override
  String eclipseSolarSlight(String city) {
    return 'Depuis $city, au mieux une très légère éclipse partielle, difficile à remarquer.';
  }

  @override
  String eclipseSolarPartial(String city, String percent) {
    return 'Estimation approximative pour $city : la Lune cache au mieux environ $percent % de la largeur du Soleil.';
  }

  @override
  String eclipseSolarNear(String city) {
    return '$city est proche de la bande où le Soleil est presque ou totalement caché. Consultez une carte de l’éclipse ; cette estimation est approximative.';
  }

  @override
  String get eclipseSolarSafety =>
      'Ne regardez jamais le Soleil sans lunettes d’éclipse adaptées.';

  @override
  String get alertsTitle => 'Alertes';

  @override
  String get tonightAlertSwitch => 'Le ciel de ce soir, chaque soir';

  @override
  String get tonightAlertTime => 'Heure';

  @override
  String get tonightAlertNote =>
      'Une courte note sur la Lune et les planètes visibles, à l’heure de votre choix. Elle est calculée sur votre téléphone, sans internet. Android ne laisse Heliora préparer qu’environ deux semaines de notes à l’avance : ouvrez donc l’appli de temps en temps.';

  @override
  String get tonightNotifTitle => 'Le ciel de ce soir';

  @override
  String tonightMoon(String phase, String percent) {
    return 'Lune : $phase, $percent % éclairée.';
  }

  @override
  String tonightPlanets(String planets) {
    return 'À repérer : $planets.';
  }

  @override
  String get tonightNoPlanets =>
      'Pas de planète brillante dans le ciel du soir.';

  @override
  String get tonightNoCity =>
      'Choisissez une ville dans Heliora pour voir les planètes.';

  @override
  String get birthdayTitle => 'Le ciel de mon anniversaire';

  @override
  String get birthdaySubtitle =>
      'La Lune et les planètes le jour de votre naissance, et les grands jours de votre vie.';

  @override
  String get birthdayCardHint => 'Phase de la Lune, planètes et étapes';

  @override
  String get birthdayNeedDate => 'Indiquez votre date de naissance';

  @override
  String get birthdayMoon => 'La Lune le jour de votre anniversaire';

  @override
  String get birthdayPlanets => 'Les planètes ce jour-là';

  @override
  String birthdayDaysOld(String count) {
    return 'Vous avez $count jours aujourd’hui.';
  }

  @override
  String get birthdayMilestones => 'Étapes';

  @override
  String birthdayDayN(String count) {
    return 'Jour $count';
  }

  @override
  String get birthdayBillion => '1 milliard de secondes de vie';

  @override
  String get birthdayPassed => 'Fait';

  @override
  String get birthdayNote =>
      'Calculé sur votre téléphone avec les mêmes orbites que le reste d’Heliora. Votre date de naissance ne le quitte jamais.';

  @override
  String get missionsTitle => 'Missions spatiales';

  @override
  String get missionsSubtitle =>
      'Des moments célèbres de l’exploration spatiale, du plus ancien au plus récent.';

  @override
  String get missionsCardHint => 'Des missions célèbres à travers le temps';

  @override
  String get missionSputnik1 =>
      'Le premier satellite artificiel. Cette boule de métal, de la taille d’un ballon de plage, a tourné autour de la Terre pendant environ trois mois. Son bip s’entendait à la radio, et l’ère spatiale commençait.';

  @override
  String get missionVostok1 =>
      'Youri Gagarine est devenu le premier humain dans l’espace. Il a fait un tour de la Terre en environ 108 minutes.';

  @override
  String get missionApollo11 =>
      'Neil Armstrong et Buzz Aldrin se sont posés dans la mer de la Tranquillité et sont devenus les premiers humains à marcher sur la Lune. Michael Collins les attendait en orbite.';

  @override
  String get missionVenera7 =>
      'Le premier engin à se poser sur une autre planète et à renvoyer un signal. Il a transmis des données depuis Vénus pendant environ 23 minutes, sous une chaleur écrasante.';

  @override
  String get missionViking1 =>
      'Elle s’est posée sur Mars et a fonctionné plus de six ans, envoyant la première longue série de photos et de bulletins météo depuis la surface d’une autre planète.';

  @override
  String get missionVoyager1 =>
      'Lancée en 1977, elle a survolé Jupiter et Saturne et est entrée dans l’espace interstellaire en 2012. C’est l’objet construit par l’humanité le plus éloigné de la Terre.';

  @override
  String get missionHubble =>
      'Lancé en 1990, il observe l’Univers depuis au-dessus de l’atmosphère terrestre. Ses images nettes ont aidé à mesurer l’âge de l’Univers et ont révélé des milliers de galaxies lointaines.';

  @override
  String get missionHuygens =>
      'Huygens, une sonde emportée par Cassini, a descendu en parachute jusqu’à Titan, la lune de Saturne. Ce fut le premier atterrissage dans le système solaire externe, et elle a envoyé des images depuis la surface.';

  @override
  String get missionCuriosity =>
      'Ce rover de la taille d’une voiture s’est posé dans le cratère Gale grâce à une « grue volante » propulsée par fusées. Il a montré que Mars a déjà réuni les conditions pour la vie.';

  @override
  String get missionMangalyaan =>
      'La mission indienne Mars Orbiter a atteint l’orbite de Mars du premier coup, une première pour un pays, et à très faible coût.';

  @override
  String get missionRosetta =>
      'Philae, l’atterrisseur de Rosetta, s’est posé sur la comète 67P/Tchourioumov-Guerassimenko : le premier atterrissage sur une comète. Rosetta elle-même a tourné autour de la comète pendant deux ans.';

  @override
  String get missionNewhorizons =>
      'Après neuf ans de voyage, elle a survolé Pluton et nous a montré pour la première fois des montagnes de glace et une immense plaine en forme de cœur.';

  @override
  String get missionPerseverance =>
      'Le rover Perseverance s’est posé dans le cratère Jezero pour chercher des traces de vie ancienne et collecter des échantillons de roche. Son hélicoptère Ingenuity a réalisé le premier vol motorisé sur une autre planète.';

  @override
  String get missionJwst =>
      'Le plus grand télescope spatial a un miroir doré de 6,5 mètres et observe le ciel en infrarouge depuis 1,5 million de km. Il voit certaines des premières galaxies.';

  @override
  String get missionChandrayaan3 =>
      'L’Inde est devenue le quatrième pays à se poser en douceur sur la Lune, et le premier près de son pôle Sud. L’atterrisseur Vikram transportait le rover Pragyan.';

  @override
  String get spacecraftTitle => 'Engins spatiaux en ce moment';

  @override
  String get spacecraftSubtitle =>
      'À quelle distance de la Terre se trouvent en ce moment quelques engins spatiaux célèbres.';

  @override
  String get spacecraftCardHint => 'Voyager, JWST, rovers martiens et plus';

  @override
  String get spacecraftDistance => 'Distance de la Terre';

  @override
  String get spacecraftAltitude => 'Altitude au-dessus de la Terre';

  @override
  String get spacecraftInAu => 'En unités astronomiques';

  @override
  String get spacecraftSpeed => 'Vitesse';

  @override
  String get spacecraftSignal => 'Le signal radio met';

  @override
  String get spacecraftNote =>
      'Les distances sont des estimations. Pour les sondes lointaines, elles sont calculées à partir de la vitesse moyenne et peuvent se tromper d’environ 1 %, car la Terre tourne autour du Soleil. La distance de Mars est calculée pour aujourd’hui. Une UA (unité astronomique) est la distance de la Terre au Soleil.';

  @override
  String valueBillionKm(String value) {
    return '$value milliards de km';
  }

  @override
  String valueAu(String value) {
    return '$value UA';
  }

  @override
  String valueKmS(String value) {
    return '$value km/s';
  }

  @override
  String get spacecraftVoyager1 =>
      'Lancée en 1977. En 2012, elle est devenue le premier engin à entrer dans l’espace interstellaire. Son signal radio a déjà environ un jour quand il nous parvient.';

  @override
  String get spacecraftVoyager2 =>
      'Lancée en 1977. C’est le seul engin à avoir visité Uranus et Neptune, et il est entré dans l’espace interstellaire en 2018.';

  @override
  String get spacecraftNewHorizons =>
      'A survolé Pluton en 2015 et l’objet de la ceinture de Kuiper Arrokoth en 2019. Elle continue de s’éloigner et d’envoyer des données.';

  @override
  String get spacecraftJwst =>
      'Le plus grand télescope spatial, lancé en 2021. Il se trouve près d’un point appelé L2, à environ 1,5 million de km de la Terre, son bouclier solaire toujours tourné vers le Soleil.';

  @override
  String get spacecraftIss =>
      'Fait le tour de la Terre environ toutes les 90 minutes. Des personnes y vivent sans interruption depuis 2000.';

  @override
  String get spacecraftHubble =>
      'Lancé en 1990 et toujours en service. Il tourne autour de la Terre au-dessus de l’air qui rend les images floues, donc ses photos sont très nettes.';

  @override
  String get spacecraftMarsRovers =>
      'Curiosity (posé en 2012) et Perseverance (posé en 2021) roulent sur Mars. La distance de Mars varie d’environ 55 millions de km à plus de 400 millions de km.';

  @override
  String get searchTooltip => 'Rechercher';

  @override
  String get searchHint => 'Cherchez planètes, lunes, missions…';

  @override
  String get searchClear => 'Effacer';

  @override
  String searchEmpty(String query) {
    return 'Rien trouvé pour « $query ».';
  }

  @override
  String get searchBodies => 'Planètes et lunes';

  @override
  String get searchMissions => 'Missions';

  @override
  String get searchSpacecraft => 'Engins spatiaux';

  @override
  String get favoritesTitle => 'Favoris';

  @override
  String get favoritesEmpty =>
      'Touchez l’étoile d’une planète, d’une mission ou d’un engin pour le garder ici.';

  @override
  String get favoriteAdd => 'Ajouter aux favoris';

  @override
  String get favoriteRemove => 'Retirer des favoris';

  @override
  String get textSize => 'Taille du texte';

  @override
  String get textSizeNormal => 'Normale';

  @override
  String get textSizeLarge => 'Grande';

  @override
  String get textSizeLarger => 'Plus grande';

  @override
  String get textSizeNote =>
      'Agrandit le texte dans Heliora. Il ne descend jamais sous la taille de texte de votre téléphone.';

  @override
  String get skyOtherNight => 'Le ciel de la nuit';

  @override
  String get planetsThatNight => 'Planètes cette nuit-là';

  @override
  String get previousDay => 'Jour précédent';

  @override
  String get nextDay => 'Jour suivant';

  @override
  String get pickDate => 'Choisir une date';

  @override
  String get backToTonight => 'Revenir à ce soir';

  @override
  String get moonCalendar => 'Calendrier lunaire';

  @override
  String get moonCalendarHint => 'La phase de la Lune chaque jour';

  @override
  String get previousMonth => 'Mois précédent';

  @override
  String get nextMonth => 'Mois suivant';

  @override
  String get keyMoonDates => 'Phases principales de ce mois';

  @override
  String get moonCalendarNote =>
      'Les dates et heures des phases sont affichées dans le fuseau horaire de votre téléphone, à environ une heure près.';

  @override
  String get seeSkyThatDay => 'Voir le ciel de ce jour';

  @override
  String get sunLightTitle => 'Soleil et lumière';

  @override
  String get firstLight => 'Première lumière';

  @override
  String get goldenMorningEnds => 'Fin de l’heure dorée du matin';

  @override
  String get solarNoon => 'Midi solaire';

  @override
  String get goldenEveningStarts => 'Début de l’heure dorée du soir';

  @override
  String get lastLight => 'Dernière lumière';

  @override
  String get darkSky => 'Ciel complètement noir';

  @override
  String get sunDayLength => 'Durée du jour';

  @override
  String durationHm(String hours, String minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get sunNote =>
      'L’heure dorée, c’est quand le Soleil est à moins de 6° au-dessus de l’horizon. La première et la dernière lumière ont lieu quand il est à 6° en dessous, et le ciel est complètement noir quand il est à 18° en dessous. Les heures sont calculées pour la date que vous choisissez.';

  @override
  String get sunStaysUp => 'Ce jour-là, le Soleil ne se couche pas.';

  @override
  String get sunStaysDown => 'Ce jour-là, le Soleil ne se lève pas.';

  @override
  String get solarSystemTitle => 'Système solaire';
}
