// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Heliora';

  @override
  String get tagline => 'Explora el sistema solar, totalmente sin conexión';

  @override
  String get navExplore => 'Explorar';

  @override
  String get navCompare => 'Comparar';

  @override
  String get navWeight => 'Peso';

  @override
  String get navQuiz => 'Quiz';

  @override
  String get viewMode => 'Modo de vista';

  @override
  String get settings => 'Ajustes';

  @override
  String get notToScale => 'No está a escala · Toca un planeta para abrirlo';

  @override
  String get dragToRotate => 'Arrastra para girar · Pellizca para hacer zoom';

  @override
  String get planetsTitle => 'Planetas';

  @override
  String get planetMercury => 'Mercurio';

  @override
  String get planetVenus => 'Venus';

  @override
  String get planetEarth => 'Tierra';

  @override
  String get planetMars => 'Marte';

  @override
  String get planetJupiter => 'Júpiter';

  @override
  String get planetSaturn => 'Saturno';

  @override
  String get planetUranus => 'Urano';

  @override
  String get planetNeptune => 'Neptuno';

  @override
  String planetOrder(int n) {
    return 'Planeta $n desde el Sol';
  }

  @override
  String get openDetails => 'Ver detalles';

  @override
  String get diameter => 'Diámetro';

  @override
  String get gravity => 'Gravedad';

  @override
  String get avgTemp => 'Temperatura media';

  @override
  String get avgTempShort => 'Temp. media';

  @override
  String get dayLength => 'Día';

  @override
  String get yearLength => 'Año';

  @override
  String get moons => 'Lunas conocidas';

  @override
  String get moonsShort => 'Lunas';

  @override
  String get distance => 'Distancia al Sol';

  @override
  String get pressure => 'Presión en la superficie';

  @override
  String get noSurface => 'Sin superficie sólida';

  @override
  String valueKm(String value) {
    return '$value km';
  }

  @override
  String valueMillionKm(String value) {
    return '$value millones de km';
  }

  @override
  String valueHours(String value) {
    return '$value h';
  }

  @override
  String valueDays(String value) {
    return '$value días';
  }

  @override
  String valueYears(String value) {
    return '$value años';
  }

  @override
  String get atmosphere => 'Atmósfera';

  @override
  String get thinAtmosphere =>
      'Casi no tiene atmósfera. Estos gases forman una capa muy fina llamada exosfera.';

  @override
  String get oxygen => 'Oxígeno';

  @override
  String get oxygenVsEarth => 'Oxígeno frente a la Tierra';

  @override
  String get breathable => 'Respirable para los humanos';

  @override
  String get notBreathable => 'No es respirable, se necesita un traje espacial';

  @override
  String weightFeelsLike(String weight) {
    return '$weight kg en la Tierra aquí se sienten como';
  }

  @override
  String get gasCo2 => 'Dióxido de carbono';

  @override
  String get gasN2 => 'Nitrógeno';

  @override
  String get gasO2 => 'Oxígeno';

  @override
  String get gasAr => 'Argón';

  @override
  String get gasH2 => 'Hidrógeno';

  @override
  String get gasHe => 'Helio';

  @override
  String get gasCh4 => 'Metano';

  @override
  String get gasNa => 'Sodio';

  @override
  String get gasK => 'Potasio';

  @override
  String get compareTitle => 'Comparar planetas';

  @override
  String get compareHint => 'Elige dos planetas para verlos lado a lado.';

  @override
  String get weightTitle => 'Tu peso en otros planetas';

  @override
  String get weightInput => 'Tu peso en la Tierra (kg)';

  @override
  String gravityTimes(String factor) {
    return '$factor× la gravedad de la Tierra';
  }

  @override
  String get quizTitle => 'Quiz de planetas';

  @override
  String get quizIntro =>
      '10 preguntas sobre los planetas y las lunas. ¿Cuántas aciertas?';

  @override
  String get quizStart => 'Empezar quiz';

  @override
  String quizProgress(int current, int total) {
    return 'Pregunta $current de $total';
  }

  @override
  String get quizNext => 'Siguiente';

  @override
  String get quizSeeResult => 'Ver resultado';

  @override
  String get quizCorrect => '¡Correcto!';

  @override
  String quizWrong(String answer) {
    return 'No del todo. La respuesta es $answer.';
  }

  @override
  String quizScore(int score, int total) {
    return 'Acertaste $score de $total';
  }

  @override
  String quizBest(int score) {
    return 'Mejor puntuación: $score';
  }

  @override
  String get quizNewBest => '¡Nueva mejor puntuación!';

  @override
  String get quizAgain => 'Jugar de nuevo';

  @override
  String get qLargest => '¿Cuál es el planeta más grande?';

  @override
  String get qSmallest => '¿Cuál es el planeta más pequeño?';

  @override
  String get qHottest => '¿Cuál es el planeta más caliente?';

  @override
  String get qColdest => '¿Cuál es el planeta más frío?';

  @override
  String get qMostMoons => '¿Qué planeta tiene más lunas conocidas?';

  @override
  String get qBreathable =>
      '¿En qué planeta pueden los humanos respirar el aire?';

  @override
  String get qClosest => '¿Qué planeta está más cerca del Sol?';

  @override
  String get qFarthest => '¿Qué planeta está más lejos del Sol?';

  @override
  String get qStrongestGravity => '¿Qué planeta tiene la gravedad más fuerte?';

  @override
  String get qShortestDay => '¿Qué planeta tiene el día más corto?';

  @override
  String get qLongestDay => '¿Qué planeta tiene el día más largo?';

  @override
  String get appearance => 'Apariencia';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get appLanguage => 'Idioma de la app';

  @override
  String get languageNote => '20 idiomas · también los nombres de los planetas';

  @override
  String get phoneLanguage => 'Idioma del teléfono';

  @override
  String get updates => 'Actualizaciones';

  @override
  String get version => 'Versión';

  @override
  String get checkForUpdates => 'Buscar actualizaciones';

  @override
  String get checking => 'Buscando…';

  @override
  String get autoUpdateCheck => 'Buscar automáticamente una vez al día';

  @override
  String get updateNote =>
      'Las actualizaciones vienen de GitHub Releases. Tus ajustes se quedan en tu teléfono.';

  @override
  String get upToDate => 'Tienes la última versión.';

  @override
  String get updateFailed =>
      'No se pudo conectar con GitHub. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get updateAvailable => 'Actualización disponible';

  @override
  String updateReady(String version) {
    return 'La versión $version está lista para descargar.';
  }

  @override
  String get download => 'Descargar';

  @override
  String get later => 'Más tarde';

  @override
  String get about => 'Acerca de';

  @override
  String get sourceCode => 'Código fuente en GitHub';

  @override
  String get privacyLine => 'Sin conexión · Sin anuncios · Sin rastreo';

  @override
  String get dataSource => 'Datos: NASA Planetary Fact Sheet';

  @override
  String get openFailed => 'No se pudo abrir el enlace.';

  @override
  String get bodySun => 'Sol';

  @override
  String get bodyMoon => 'Luna';

  @override
  String get bodyPluto => 'Plutón';

  @override
  String get moonIo => 'Ío';

  @override
  String get moonEuropa => 'Europa';

  @override
  String get moonGanymede => 'Ganímedes';

  @override
  String get moonCallisto => 'Calisto';

  @override
  String get moonTitan => 'Titán';

  @override
  String get moonEnceladus => 'Encélado';

  @override
  String get moonTriton => 'Tritón';

  @override
  String get kindStar => 'Nuestra estrella, el centro del sistema solar';

  @override
  String get kindDwarf => 'Planeta enano';

  @override
  String moonOf(String planet) {
    return 'Luna de $planet';
  }

  @override
  String get orbitPeriod => 'Una órbita';

  @override
  String distanceFrom(String body) {
    return 'Distancia a $body';
  }

  @override
  String get composition => 'De qué está hecho';

  @override
  String get noAtmosphere => 'No tiene una atmósfera real, es casi el vacío.';

  @override
  String get majorMoons => 'Lunas principales';

  @override
  String get lifeTitle => '¿Podrían vivir aquí los humanos?';

  @override
  String get lifeScoreShort => 'Puntuación de vida';

  @override
  String get lifeNote =>
      'Calculada con la temperatura, la presión del aire, el oxígeno, el agua, la superficie y la gravedad. La Tierra saca 10.';

  @override
  String get water => 'Agua';

  @override
  String get waterLiquid => 'Agua líquida';

  @override
  String get waterIce => 'Hielo';

  @override
  String get waterOcean => 'Océano bajo el hielo';

  @override
  String get waterNone => 'Sin agua';

  @override
  String get surface => 'Superficie';

  @override
  String get solidSurface => 'Superficie sólida';

  @override
  String get lifeHome => 'Como en casa';

  @override
  String get lifeHard =>
      'Muy difícil, se necesitaría una base cerrada y trajes espaciales';

  @override
  String get lifeNo => 'Imposible para los humanos';

  @override
  String get downloadInstall => 'Descargar e instalar';

  @override
  String downloadingPercent(String percent) {
    return 'Descargando… $percent%';
  }

  @override
  String get installNow => 'Instalar';

  @override
  String get allowInstalls =>
      'Permite que Heliora instale apps en la pantalla que se abrió y luego vuelve y toca Instalar.';

  @override
  String get downloadFailed =>
      'La descarga no terminó. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get tryAgain => 'Reintentar';

  @override
  String get today => 'Hoy';

  @override
  String get play => 'Reproducir';

  @override
  String get pause => 'Pausa';

  @override
  String get monthBack => '30 días antes';

  @override
  String get monthForward => '30 días después';

  @override
  String get positionsNote =>
      'Posiciones reales en esta fecha · Tamaños y distancias no a escala · Toca un planeta';

  @override
  String get navYou => 'Tú';

  @override
  String get ageTitle => 'Tu edad en otros planetas';

  @override
  String get setBirthDate => 'Indica tu fecha de nacimiento';

  @override
  String get changeBirthDate => 'Cambiar';

  @override
  String nextBirthday(String days) {
    return 'Próximo cumpleaños en $days días';
  }

  @override
  String get ageNote =>
      'Tu fecha de nacimiento solo se guarda en este teléfono.';

  @override
  String get share => 'Compartir';

  @override
  String shareText(String planet) {
    return '$planet en Heliora, la app gratuita del sistema solar sin conexión: https://github.com/lumio-apps/heliora';
  }

  @override
  String get shareFailed => 'No se pudo compartir la imagen.';

  @override
  String get travelTitle => '¿A qué distancia está?';

  @override
  String get distanceFromEarth => 'Distancia a la Tierra hoy';

  @override
  String get lightTime => 'La luz tarda';

  @override
  String get bySpacecraft => 'En nave espacial a 60.000 km/h';

  @override
  String get byCar => 'En coche a 100 km/h';

  @override
  String valueSeconds(String value) {
    return '$value s';
  }

  @override
  String valueMinutes(String value) {
    return '$value min';
  }

  @override
  String get sizeTitle => 'Tamaño';

  @override
  String sizeTimes(String big, String times, String small) {
    return '$big es $times× más ancho que $small.';
  }

  @override
  String sizeSimilar(String a, String b) {
    return '$a y $b tienen casi el mismo tamaño.';
  }

  @override
  String get navSky => 'Cielo';

  @override
  String get skyTitle => 'El cielo de esta noche';

  @override
  String get chooseCity => 'Elige tu ciudad';

  @override
  String get chooseCityHint =>
      'Elige la ciudad más cercana para ver la Luna y los planetas visibles esta noche. No se necesita permiso de ubicación y se queda en tu teléfono.';

  @override
  String get searchCity => 'Buscar ciudad';

  @override
  String get noCityFound => 'No se encontró ninguna ciudad';

  @override
  String get cityNote =>
      'Las horas están en la zona horaria de tu teléfono. Un planeta cuenta como visible si está al menos 5° sobre el horizonte con el cielo oscuro.';

  @override
  String illuminated(String percent) {
    return '$percent% iluminada';
  }

  @override
  String get moonrise => 'Salida de la Luna';

  @override
  String get moonset => 'Puesta de la Luna';

  @override
  String get sunset => 'Puesta de sol';

  @override
  String get sunrise => 'Salida del sol';

  @override
  String get nextFull => 'Próxima luna llena';

  @override
  String get nextNew => 'Próxima luna nueva';

  @override
  String get phaseNew => 'Luna nueva';

  @override
  String get phaseWaxingCrescent => 'Creciente';

  @override
  String get phaseFirstQuarter => 'Cuarto creciente';

  @override
  String get phaseWaxingGibbous => 'Gibosa creciente';

  @override
  String get phaseFull => 'Luna llena';

  @override
  String get phaseWaningGibbous => 'Gibosa menguante';

  @override
  String get phaseLastQuarter => 'Cuarto menguante';

  @override
  String get phaseWaningCrescent => 'Menguante';

  @override
  String get planetsTonight => 'Planetas esta noche';

  @override
  String get statusVisible => 'Visible esta noche';

  @override
  String get statusEvening => 'Al atardecer, tras la puesta de sol';

  @override
  String get statusMorning => 'Al amanecer, antes de la salida del sol';

  @override
  String get statusNotVisible => 'No visible esta noche';

  @override
  String bestAt(String time) {
    return 'Mejor a las $time';
  }

  @override
  String altitudeDir(String direction, String degrees) {
    return '$direction, a $degrees° de altura';
  }

  @override
  String riseSet(String rise, String set) {
    return 'Sale $rise · Se pone $set';
  }

  @override
  String get needsTelescope => 'Hacen falta prismáticos o telescopio';

  @override
  String get dirN => 'Norte';

  @override
  String get dirNE => 'Noreste';

  @override
  String get dirE => 'Este';

  @override
  String get dirSE => 'Sureste';

  @override
  String get dirS => 'Sur';

  @override
  String get dirSW => 'Suroeste';

  @override
  String get dirW => 'Oeste';

  @override
  String get dirNW => 'Noroeste';

  @override
  String get findPlanet => 'Buscar en el cielo';

  @override
  String finderTitle(String name) {
    return 'Buscar $name';
  }

  @override
  String get pointPhone => 'Levanta el móvil y muévelo despacio.';

  @override
  String turnRight(String degrees) {
    return 'Gira a la derecha $degrees°';
  }

  @override
  String turnLeft(String degrees) {
    return 'Gira a la izquierda $degrees°';
  }

  @override
  String tiltUp(String degrees) {
    return 'Inclina hacia arriba $degrees°';
  }

  @override
  String tiltDown(String degrees) {
    return 'Inclina hacia abajo $degrees°';
  }

  @override
  String onTarget(String name) {
    return '¡$name está justo ahí!';
  }

  @override
  String belowHorizon(String name) {
    return '$name está ahora bajo el horizonte.';
  }

  @override
  String risesAt(String time) {
    return 'Sale a las $time.';
  }

  @override
  String get noSensor =>
      'Este móvil no tiene sensor de brújula, así que el buscador no puede funcionar.';

  @override
  String get calibrate =>
      'La brújula necesita calibrarse: mueve el móvil en forma de 8 unas cuantas veces.';

  @override
  String get phoneNow => 'Tu móvil apunta a';

  @override
  String get finderNote =>
      'Sujeta el móvil con la parte trasera hacia el cielo y aléjalo de imanes y metal. Nunca mires al Sol.';

  @override
  String get eventsTitle => 'Eventos espaciales';

  @override
  String get eventsSubtitle =>
      'Qué mirar en el cielo en los próximos 12 meses.';

  @override
  String eventsNext(String event, String when) {
    return 'Próximo: $event · $when';
  }

  @override
  String get eventFullMoon => 'Luna llena';

  @override
  String get eventNewMoon => 'Luna nueva';

  @override
  String eventOpposition(String planet) {
    return '$planet en oposición';
  }

  @override
  String eventEveningElongation(String planet) {
    return '$planet: mejor vista por la tarde';
  }

  @override
  String eventMorningElongation(String planet) {
    return '$planet: mejor vista por la mañana';
  }

  @override
  String eventConjunction(String a, String b) {
    return '$a y $b se encuentran';
  }

  @override
  String get eventMarchEquinox => 'Equinoccio de marzo';

  @override
  String get eventJuneSolstice => 'Solsticio de junio';

  @override
  String get eventSeptemberEquinox => 'Equinoccio de septiembre';

  @override
  String get eventDecemberSolstice => 'Solsticio de diciembre';

  @override
  String get eventFullMoonDesc =>
      'Toda la cara de la Luna está iluminada. Sale hacia la puesta de sol.';

  @override
  String get eventNewMoonDesc =>
      'La Luna no se ve. El cielo más oscuro del mes para ver estrellas y planetas.';

  @override
  String eventOppositionDesc(String planet) {
    return '$planet está opuesto al Sol. Está en su momento más brillante del año y se ve toda la noche.';
  }

  @override
  String eventEveningDesc(String planet, String degrees) {
    return '$planet está a $degrees° del Sol, lo más lejos posible. Mira bajo en el oeste después de la puesta de sol.';
  }

  @override
  String eventMorningDesc(String planet, String degrees) {
    return '$planet está a $degrees° del Sol, lo más lejos posible. Mira bajo en el este antes del amanecer.';
  }

  @override
  String eventConjunctionDesc(String degrees) {
    return 'Pasan a solo $degrees° de distancia en el cielo.';
  }

  @override
  String get eventEquinoxDesc =>
      'El día y la noche duran casi lo mismo en toda la Tierra.';

  @override
  String get eventJuneSolsticeDesc =>
      'El día más largo en el norte y el más corto en el sur.';

  @override
  String get eventDecemberSolsticeDesc =>
      'El día más corto en el norte y el más largo en el sur.';

  @override
  String eventMeteorShower(String shower) {
    return 'Lluvia de meteoros $shower';
  }

  @override
  String eventMeteorDesc(String rate, String percent) {
    return 'Hasta unos $rate meteoros por hora con cielo oscuro. La Luna estará iluminada al $percent%.';
  }

  @override
  String get showerQuadrantids => 'Cuadrántidas';

  @override
  String get showerLyrids => 'Líridas';

  @override
  String get showerEtaAquariids => 'Eta Acuáridas';

  @override
  String get showerPerseids => 'Perseidas';

  @override
  String get showerOrionids => 'Oriónidas';

  @override
  String get showerLeonids => 'Leónidas';

  @override
  String get showerGeminids => 'Gemínidas';

  @override
  String get showerUrsids => 'Úrsidas';

  @override
  String get eventToday => 'Hoy';

  @override
  String get eventTomorrow => 'Mañana';

  @override
  String eventInDays(String days) {
    return 'En $days días';
  }

  @override
  String get eventsNote =>
      'Las fechas se calculan en tu móvil y se muestran en su zona horaria. Los picos de las lluvias de meteoros son fechas habituales cada año y pueden variar un día. Los recordatorios se quedan en tu móvil.';

  @override
  String get remindMe => 'Recordármelo';

  @override
  String reminderSet(String date) {
    return 'Vale, te lo recordaré el $date.';
  }

  @override
  String get reminderOff => 'Recordatorio eliminado.';

  @override
  String get reminderTooLate =>
      'Este evento está demasiado cerca para poner un recordatorio.';

  @override
  String get notificationsOff =>
      'Las notificaciones de Heliora están desactivadas. Actívalas en los ajustes de Android.';

  @override
  String get reminderTomorrow => 'Es mañana';

  @override
  String get reminderToday => 'Ocurre hoy';

  @override
  String get onlineTitle => 'Funciones en línea';

  @override
  String get onlineSubtitle =>
      'Muestra la estación espacial y los lanzamientos de cohetes. Entonces Heliora solo contacta con wheretheiss.at, Celestrak y Launch Library 2, que pueden ver la dirección de internet de tu móvil. No se envía nada más. Desactivado por defecto.';

  @override
  String get turnOnOnline => 'Activar funciones en línea';

  @override
  String get issTitle => 'Estación espacial';

  @override
  String get issCardHint => 'Dónde está ahora y cuándo pasa sobre ti';

  @override
  String get issNeedsOnline =>
      'Para mostrar la estación, Heliora necesita sus datos de órbita desde internet. Se descargan una vez y luego funcionan sin conexión durante días.';

  @override
  String get issLoading => 'Obteniendo los datos de órbita…';

  @override
  String get issFailed =>
      'No se pudieron obtener los datos de órbita. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String issStale(String days) {
    return 'Los datos de órbita tienen $days días, así que las posiciones pueden fallar. Conéctate a internet para actualizarlos.';
  }

  @override
  String get issHeight => 'Altura';

  @override
  String get issSpeed => 'Velocidad';

  @override
  String get issFromYou => 'Distancia a ti';

  @override
  String valueKmh(String value) {
    return '$value km/h';
  }

  @override
  String issAboveHorizon(String direction, String degrees) {
    return '¡Sobre tu horizonte ahora! Mira al $direction, a $degrees° de altura.';
  }

  @override
  String get issBelowHorizon => 'Bajo tu horizonte ahora mismo.';

  @override
  String issPassesTitle(String city) {
    return 'Próximos pasos sobre $city';
  }

  @override
  String get issNoPasses => 'No hay pasos buenos en los próximos 5 días.';

  @override
  String issMaxHigh(String degrees) {
    return 'Hasta $degrees° de altura';
  }

  @override
  String issFromTo(String start, String end) {
    return 'De $start a $end';
  }

  @override
  String get issVisible => 'Fácil de ver';

  @override
  String get issHidden => 'Difícil de ver';

  @override
  String get issPassTitle => 'La estación espacial pasa sobre ti';

  @override
  String issPassBody(String degrees, String direction) {
    return 'Sale en 10 minutos, hasta $degrees° de altura. Mira al $direction.';
  }

  @override
  String get issNote =>
      'Las posiciones se calculan en tu móvil con los datos de órbita de la estación. Un paso es fácil de ver cuando el cielo está oscuro y el Sol ilumina la estación: parece una estrella brillante y rápida.';

  @override
  String get launchesNeedOnline =>
      'Activa las funciones en línea para ver aquí los próximos lanzamientos de cohetes.';

  @override
  String get launchesFailed =>
      'No se pudo actualizar la lista de lanzamientos. Se muestra la guardada.';

  @override
  String get launchesNote =>
      'Las horas de lanzamiento vienen de Launch Library 2 y cambian a menudo. Los nombres y lugares están en inglés.';

  @override
  String get launchReminderBody =>
      'Despega en aproximadamente una hora. La hora puede cambiar.';

  @override
  String get launchTimeTbd => 'Hora aún sin fijar';

  @override
  String get quizChoose => 'Elige un nivel';

  @override
  String get levelEasy => 'Fácil';

  @override
  String get levelMedium => 'Medio';

  @override
  String get levelHard => 'Difícil';

  @override
  String get levelEasyHint => 'Lo básico de los planetas';

  @override
  String get levelMediumHint => 'Planetas y lunas';

  @override
  String get levelHardHint => 'Comparaciones y rankings difíciles';

  @override
  String get qStar => '¿Cuál de estos es una estrella, no un planeta?';

  @override
  String get qDwarf => '¿Cuál de estos es un planeta enano?';

  @override
  String get qMoonVisited => '¿En qué luna han caminado personas?';

  @override
  String get qLargestMoon => '¿Cuál de estas lunas es la más grande?';

  @override
  String get qSmallestMoon => '¿Cuál de estas lunas es la más pequeña?';

  @override
  String get qThickAirMoon => '¿Cuál de estas lunas tiene una atmósfera densa?';

  @override
  String get qGeyserMoon => '¿Qué luna lanza géiseres de agua al espacio?';

  @override
  String get qVolcanicMoon => '¿Qué luna tiene los volcanes más activos?';

  @override
  String get qBackwardsMoon =>
      '¿Qué luna gira alrededor de su planeta al revés?';

  @override
  String get qBiggestRocky =>
      '¿Cuál es el más grande de los cuatro planetas rocosos?';

  @override
  String get qColdestRocky =>
      '¿Cuál es el más frío de los cuatro planetas rocosos?';

  @override
  String get qHighestPressure =>
      '¿Qué planeta tiene la presión del aire más alta en su superficie?';

  @override
  String get qSecondLargest => '¿Qué planeta es el segundo más grande?';

  @override
  String get qLongestYear => '¿Qué planeta tiene el año más largo?';

  @override
  String get qShortestYear => '¿Qué planeta tiene el año más corto?';

  @override
  String get qSmallestGiant =>
      '¿Cuál es el más pequeño de los cuatro planetas gigantes?';

  @override
  String get qRockyLongestYear =>
      '¿Cuál de los cuatro planetas rocosos tiene el año más largo?';

  @override
  String get qFastestMoon =>
      '¿Cuál de estas lunas da la vuelta a su planeta más rápido?';

  @override
  String get qSlowestMoon =>
      '¿Cuál de estas lunas tarda más en dar la vuelta a su planeta?';

  @override
  String get qStrongestMoonGravity =>
      '¿Cuál de estas lunas tiene la gravedad más fuerte?';

  @override
  String get qColdestMoon => '¿Cuál de estas lunas es la más fría?';

  @override
  String get qSecondLargestMoon =>
      '¿Cuál de estas lunas es la segunda más grande?';

  @override
  String get factTitle => '¿Sabías que…?';

  @override
  String get factTap => 'Toca para ver otro dato';

  @override
  String get factSun1 =>
      'El Sol contiene el 99,8 % de toda la masa del sistema solar.';

  @override
  String get factSun2 =>
      'La luz del Sol tarda unos 8 minutos y 20 segundos en llegar a la Tierra.';

  @override
  String get factMercury1 =>
      'Un día en Mercurio, de un amanecer al siguiente, dura unos 176 días terrestres. Es el doble de largo que su año.';

  @override
  String get factMercury2 =>
      'Mercurio casi no tiene aire, así que su cielo es negro incluso de día y sus noches son gélidas.';

  @override
  String get factVenus1 =>
      'Venus gira al revés, así que en Venus el Sol sale por el oeste.';

  @override
  String get factVenus2 =>
      'Venus es más caliente que Mercurio, aunque está más lejos del Sol, porque su aire denso atrapa el calor.';

  @override
  String get factEarth1 =>
      'La Tierra es el único lugar con vida que conocemos, y cerca del 71 % de su superficie está cubierta de agua.';

  @override
  String get factEarth2 =>
      'La Tierra no es una bola perfecta. Se abulta un poco en el ecuador porque gira.';

  @override
  String get factMars1 =>
      'El Monte Olimpo de Marte es el volcán más alto del sistema solar, unas dos veces y media más alto que el Everest.';

  @override
  String get factMars2 => 'Los atardeceres en Marte se ven azules.';

  @override
  String get factJupiter1 =>
      'Júpiter tiene más del doble de masa que todos los demás planetas juntos.';

  @override
  String get factJupiter2 =>
      'La Gran Mancha Roja es una tormenta más grande que la Tierra, y la observamos desde hace más de 150 años.';

  @override
  String get factSaturn1 =>
      'Saturno es tan ligero para su tamaño que flotaría en el agua, si hubiera una bañera lo bastante grande.';

  @override
  String get factSaturn2 =>
      'Los anillos de Saturno son muy anchos pero muy delgados: en algunos puntos solo tienen unos diez metros de grosor.';

  @override
  String get factUranus1 =>
      'Urano gira alrededor del Sol rodando de lado, inclinado unos 98 grados.';

  @override
  String get factUranus2 =>
      'Urano fue el primer planeta descubierto con un telescopio. William Herschel lo vio en 1781.';

  @override
  String get factNeptune1 =>
      'Neptuno tiene los vientos más rápidos de cualquier planeta, de más de 2000 km/h.';

  @override
  String get factNeptune2 =>
      'Neptuno se encontró con matemáticas antes de que nadie lo viera: en 1846 los astrónomos calcularon dónde tenía que estar.';

  @override
  String get factMoon1 =>
      'La Luna se aleja de la Tierra unos 3,8 centímetros cada año.';

  @override
  String get factMoon2 =>
      'Siempre vemos la misma cara de la Luna, porque gira exactamente una vez por cada vuelta alrededor de la Tierra.';

  @override
  String get factPluto1 => 'Un año en Plutón dura unos 248 años terrestres.';

  @override
  String get factPluto2 =>
      'Plutón tiene una enorme llanura con forma de corazón hecha de nitrógeno helado.';

  @override
  String get factIo1 =>
      'Ío es el mundo más volcánico que conocemos, con cientos de volcanes activos.';

  @override
  String get factIo2 =>
      'La gravedad de Júpiter aprieta y estira a Ío, y el calor que eso produce alimenta sus volcanes.';

  @override
  String get factEuropa1 =>
      'Bajo su corteza de hielo, Europa probablemente guarda el doble de agua que todos los océanos de la Tierra.';

  @override
  String get factEuropa2 =>
      'Europa es uno de los mejores lugares para buscar vida fuera de la Tierra. La nave Europa Clipper va camino de allí.';

  @override
  String get factGanymede1 =>
      'Ganímedes es la luna más grande del sistema solar. Es incluso más grande que Mercurio.';

  @override
  String get factGanymede2 =>
      'Ganímedes es la única luna que se sabe que tiene campo magnético propio.';

  @override
  String get factCallisto1 =>
      'Calisto es uno de los lugares con más cráteres del sistema solar, y su superficie es muy antigua.';

  @override
  String get factCallisto2 =>
      'Calisto está lo bastante lejos de Júpiter como para recibir menos de su dura radiación, por eso los científicos lo han propuesto para una futura base.';

  @override
  String get factTitan1 =>
      'Titán es la única luna con una atmósfera densa. Su presión del aire en la superficie es mayor que en la Tierra.';

  @override
  String get factTitan2 =>
      'Titán tiene ríos y lagos, pero son de metano y etano líquidos, no de agua.';

  @override
  String get factEnceladus1 =>
      'Encélado lanza chorros de hielo y vapor de agua al espacio por grietas cerca de su polo sur.';

  @override
  String get factEnceladus2 =>
      'Los chorros de Encélado alimentan el anillo E de Saturno.';

  @override
  String get factTriton1 =>
      'Tritón gira alrededor de Neptuno al revés, así que probablemente era un planeta enano capturado por Neptuno.';

  @override
  String get factTriton2 =>
      'A unos −235 °C, Tritón es uno de los lugares más fríos que se han medido en el sistema solar.';

  @override
  String get jumpInput => 'Tu altura de salto en la Tierra (cm)';

  @override
  String jumpHigh(String height) {
    return 'Salto: $height';
  }

  @override
  String jumpFeelsLike(String height) {
    return 'Un salto de $height en la Tierra se convierte en';
  }

  @override
  String get jumpNote =>
      'Con el mismo impulso que en la Tierra. En el Sol y en los gigantes gaseosos no hay suelo donde pararse, así que esto es solo un juego de imaginación.';

  @override
  String valueCm(String value) {
    return '$value cm';
  }

  @override
  String valueM(String value) {
    return '$value m';
  }

  @override
  String get eclipseTotalLunar => 'Eclipse lunar total';

  @override
  String get eclipsePartialLunar => 'Eclipse lunar parcial';

  @override
  String get eclipsePenumbralLunar => 'Eclipse lunar penumbral';

  @override
  String get eclipseTotalSolar => 'Eclipse solar total';

  @override
  String get eclipseAnnularSolar => 'Eclipse solar anular';

  @override
  String get eclipseHybridSolar => 'Eclipse solar híbrido';

  @override
  String get eclipsePartialSolar => 'Eclipse solar parcial';

  @override
  String get eclipseTotalLunarDesc =>
      'La Luna entra por completo en la sombra de la Tierra y a menudo se vuelve de un rojo tenue. Lo ve todo el que esté en el lado nocturno de la Tierra, y es seguro mirarlo a simple vista.';

  @override
  String eclipsePartialLunarDesc(String percent) {
    return 'Una parte de la Luna ($percent% de su ancho) entra en la sombra oscura de la Tierra. Es seguro mirarlo a simple vista.';
  }

  @override
  String get eclipsePenumbralLunarDesc =>
      'La Luna pasa por la tenue sombra exterior de la Tierra. Solo se atenúa un poco, así que cuesta notarlo.';

  @override
  String get eclipseTotalSolarDesc =>
      'La Luna tapa por completo el Sol a lo largo de una franja estrecha de la Tierra. Fuera de esa franja se ve un eclipse parcial.';

  @override
  String get eclipseAnnularSolarDesc =>
      'La Luna está algo lejos para tapar el Sol del todo, así que queda un anillo brillante. El anillo se ve a lo largo de una franja estrecha; fuera de ella el eclipse es parcial.';

  @override
  String get eclipseHybridSolarDesc =>
      'A lo largo de su franja, este eclipse es total en unos sitios y anular en otros. Fuera de la franja es parcial.';

  @override
  String get eclipsePartialSolarDesc =>
      'La Luna tapa solo una parte del Sol, y en ningún lugar de la Tierra el Sol queda totalmente cubierto.';

  @override
  String get eclipseNoCity =>
      'Elige una ciudad en Heliora para saber si puedes verlo desde allí.';

  @override
  String eclipseLunarUp(String city) {
    return 'En el punto medio del eclipse, la Luna está sobre el horizonte en $city.';
  }

  @override
  String eclipseLunarPartly(String city) {
    return 'En $city, la Luna está sobre el horizonte solo durante una parte del eclipse.';
  }

  @override
  String eclipseLunarDown(String city) {
    return 'En $city, la Luna se queda bajo el horizonte, así que no se ve desde allí.';
  }

  @override
  String eclipseSolarNone(String city) {
    return 'No se ve desde $city: la sombra de la Luna no llega, o el Sol está bajo el horizonte.';
  }

  @override
  String eclipseSolarSlight(String city) {
    return 'Desde $city, como mucho un eclipse parcial muy leve, difícil de notar.';
  }

  @override
  String eclipseSolarPartial(String city, String percent) {
    return 'Cálculo aproximado para $city: la Luna cubre como mucho un $percent% del ancho del Sol.';
  }

  @override
  String eclipseSolarNear(String city) {
    return '$city está cerca de la franja donde el Sol queda casi o totalmente cubierto. Consulta un mapa del eclipse; este cálculo es aproximado.';
  }

  @override
  String get eclipseSolarSafety =>
      'Nunca mires al Sol sin gafas de eclipse adecuadas.';

  @override
  String get alertsTitle => 'Avisos';

  @override
  String get tonightAlertSwitch => 'El cielo de esta noche, cada tarde';

  @override
  String get tonightAlertTime => 'Hora';

  @override
  String get tonightAlertNote =>
      'Una nota breve sobre la Luna y los planetas que puedes ver, a la hora que elijas. Se calcula en tu teléfono, sin internet. Android solo deja que Heliora prepare unas dos semanas de notas por adelantado, así que abre la app de vez en cuando.';

  @override
  String get tonightNotifTitle => 'El cielo de esta noche';

  @override
  String tonightMoon(String phase, String percent) {
    return 'Luna: $phase, $percent% iluminada.';
  }

  @override
  String tonightPlanets(String planets) {
    return 'Busca: $planets.';
  }

  @override
  String get tonightNoPlanets =>
      'No hay planetas brillantes en el cielo del anochecer.';

  @override
  String get tonightNoCity =>
      'Elige una ciudad en Heliora para ver los planetas.';

  @override
  String get birthdayTitle => 'El cielo de mi cumpleaños';

  @override
  String get birthdaySubtitle =>
      'La Luna y los planetas el día en que naciste, y los días grandes de tu vida.';

  @override
  String get birthdayCardHint => 'Fase lunar, planetas e hitos';

  @override
  String get birthdayNeedDate => 'Indica tu fecha de nacimiento';

  @override
  String get birthdayMoon => 'La Luna en tu cumpleaños';

  @override
  String get birthdayPlanets => 'Los planetas ese día';

  @override
  String birthdayDaysOld(String count) {
    return 'Hoy tienes $count días de vida.';
  }

  @override
  String get birthdayMilestones => 'Hitos';

  @override
  String birthdayDayN(String count) {
    return 'Día $count';
  }

  @override
  String get birthdayBillion => '1000 millones de segundos de vida';

  @override
  String get birthdayPassed => 'Cumplido';

  @override
  String get birthdayNote =>
      'Se calcula en tu teléfono con las mismas órbitas que el resto de Heliora. Tu fecha de nacimiento nunca sale de él.';

  @override
  String get missionsTitle => 'Misiones espaciales';

  @override
  String get missionsSubtitle =>
      'Momentos famosos de la exploración del espacio, de más antiguo a más reciente.';

  @override
  String get missionsCardHint => 'Misiones famosas a lo largo del tiempo';

  @override
  String get missionSputnik1 =>
      'El primer satélite artificial. Esta bola de metal, del tamaño de un balón de playa, dio vueltas a la Tierra unos tres meses. Su pitido se oía por radio y con él empezó la era espacial.';

  @override
  String get missionVostok1 =>
      'Yuri Gagarin fue la primera persona en el espacio. Dio una vuelta a la Tierra en unos 108 minutos.';

  @override
  String get missionApollo11 =>
      'Neil Armstrong y Buzz Aldrin aterrizaron en el Mar de la Tranquilidad y fueron las primeras personas en caminar sobre la Luna. Michael Collins los esperó en órbita.';

  @override
  String get missionVenera7 =>
      'La primera nave en aterrizar en otro planeta y enviar una señal. Mandó datos desde Venus durante unos 23 minutos, bajo un calor aplastante.';

  @override
  String get missionViking1 =>
      'Aterrizó en Marte y funcionó allí más de seis años, enviando la primera larga serie de fotos e informes del tiempo desde la superficie de otro planeta.';

  @override
  String get missionVoyager1 =>
      'Lanzada en 1977, pasó cerca de Júpiter y Saturno y entró en el espacio interestelar en 2012. Es el objeto hecho por humanos más lejano de la Tierra.';

  @override
  String get missionHubble =>
      'Lanzado en 1990, mira el universo desde por encima del aire de la Tierra. Sus imágenes nítidas ayudaron a medir la edad del universo y mostraron miles de galaxias lejanas.';

  @override
  String get missionHuygens =>
      'Huygens, una sonda llevada por Cassini, bajó en paracaídas hasta Titán, la luna de Saturno. Fue el primer aterrizaje en el sistema solar exterior y envió fotos desde la superficie.';

  @override
  String get missionCuriosity =>
      'Este róver del tamaño de un coche aterrizó en el cráter Gale con una «grúa aérea» propulsada por cohetes. Descubrió que Marte tuvo en el pasado condiciones adecuadas para la vida.';

  @override
  String get missionMangalyaan =>
      'La misión india Mars Orbiter llegó a la órbita de Marte al primer intento, algo inédito para cualquier país, y con un coste muy bajo.';

  @override
  String get missionRosetta =>
      'Philae, el módulo de aterrizaje de Rosetta, se posó en el cometa 67P/Churiumov–Guerasimenko: el primer aterrizaje en un cometa. La propia Rosetta orbitó el cometa dos años.';

  @override
  String get missionNewhorizons =>
      'Tras un viaje de nueve años, pasó junto a Plutón y nos mostró por primera vez montañas de hielo y una enorme llanura con forma de corazón.';

  @override
  String get missionPerseverance =>
      'El róver Perseverance aterrizó en el cráter Jezero para buscar señales de vida antigua y recoger muestras de roca. Su helicóptero Ingenuity hizo el primer vuelo propulsado en otro planeta.';

  @override
  String get missionJwst =>
      'El mayor telescopio espacial tiene un espejo dorado de 6,5 metros y observa el cielo en luz infrarroja desde 1,5 millones de km. Ve algunas de las primeras galaxias.';

  @override
  String get missionChandrayaan3 =>
      'India se convirtió en el cuarto país en posarse suavemente en la Luna, y el primero cerca de su polo sur. El módulo Vikram llevaba al róver Pragyan.';

  @override
  String get spacecraftTitle => 'Naves espaciales ahora';

  @override
  String get spacecraftSubtitle =>
      'A qué distancia de la Tierra están ahora algunas naves espaciales famosas.';

  @override
  String get spacecraftCardHint => 'Voyager, JWST, róvers de Marte y más';

  @override
  String get spacecraftDistance => 'Distancia a la Tierra';

  @override
  String get spacecraftAltitude => 'Altura sobre la Tierra';

  @override
  String get spacecraftInAu => 'En unidades astronómicas';

  @override
  String get spacecraftSpeed => 'Velocidad';

  @override
  String get spacecraftSignal => 'La señal de radio tarda';

  @override
  String get spacecraftNote =>
      'Las distancias son estimaciones. En las sondas lejanas se calculan a partir de la velocidad media y pueden fallar un 1 % aproximadamente, porque la Tierra se mueve alrededor del Sol. La distancia a Marte está calculada para hoy. Una UA (unidad astronómica) es la distancia de la Tierra al Sol.';

  @override
  String valueBillionKm(String value) {
    return '$value mil millones de km';
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
      'Lanzada en 1977. En 2012 fue la primera nave en entrar en el espacio interestelar. Su señal de radio ya tiene cerca de un día cuando nos llega.';

  @override
  String get spacecraftVoyager2 =>
      'Lanzada en 1977. Es la única nave que ha visitado Urano y Neptuno, y entró en el espacio interestelar en 2018.';

  @override
  String get spacecraftNewHorizons =>
      'Pasó junto a Plutón en 2015 y junto al objeto del cinturón de Kuiper Arrokoth en 2019. Sigue alejándose y sigue enviando datos.';

  @override
  String get spacecraftJwst =>
      'El telescopio espacial más grande, lanzado en 2021. Está cerca de un punto llamado L2, a unos 1,5 millones de km de la Tierra, con su parasol siempre hacia el Sol.';

  @override
  String get spacecraftIss =>
      'Da una vuelta a la Tierra cada 90 minutos más o menos. Desde 2000 hay personas viviendo a bordo sin interrupción.';

  @override
  String get spacecraftHubble =>
      'Lanzado en 1990 y todavía en funcionamiento. Da vueltas a la Tierra por encima del aire que desenfoca las imágenes, así que sus fotos son muy nítidas.';

  @override
  String get spacecraftMarsRovers =>
      'Curiosity (aterrizó en 2012) y Perseverance (aterrizó en 2021) circulan por Marte. La distancia a Marte varía de unos 55 millones de km a más de 400 millones de km.';

  @override
  String get searchTooltip => 'Buscar';

  @override
  String get searchHint => 'Busca planetas, lunas, misiones…';

  @override
  String get searchClear => 'Borrar';

  @override
  String searchEmpty(String query) {
    return 'No se encontró nada para «$query».';
  }

  @override
  String get searchBodies => 'Planetas y lunas';

  @override
  String get searchMissions => 'Misiones';

  @override
  String get searchSpacecraft => 'Naves espaciales';

  @override
  String get favoritesTitle => 'Favoritos';

  @override
  String get favoritesEmpty =>
      'Toca la estrella de un planeta, una misión o una nave para guardarlo aquí.';

  @override
  String get favoriteAdd => 'Añadir a favoritos';

  @override
  String get favoriteRemove => 'Quitar de favoritos';

  @override
  String get textSize => 'Tamaño del texto';

  @override
  String get textSizeNormal => 'Normal';

  @override
  String get textSizeLarge => 'Grande';

  @override
  String get textSizeLarger => 'Más grande';

  @override
  String get textSizeNote =>
      'Agranda el texto de Heliora. Nunca baja del tamaño de texto de tu propio teléfono.';

  @override
  String get skyOtherNight => 'El cielo de la noche';

  @override
  String get planetsThatNight => 'Planetas esa noche';

  @override
  String get previousDay => 'Día anterior';

  @override
  String get nextDay => 'Día siguiente';

  @override
  String get pickDate => 'Elegir una fecha';

  @override
  String get backToTonight => 'Volver a esta noche';

  @override
  String get moonCalendar => 'Calendario lunar';

  @override
  String get moonCalendarHint => 'La fase de la Luna cada día';

  @override
  String get previousMonth => 'Mes anterior';

  @override
  String get nextMonth => 'Mes siguiente';

  @override
  String get keyMoonDates => 'Fases principales de este mes';

  @override
  String get moonCalendarNote =>
      'Las fechas y horas de las fases se muestran en la zona horaria de tu teléfono y son exactas con un margen de aproximadamente una hora.';

  @override
  String get seeSkyThatDay => 'Ver el cielo de este día';

  @override
  String get sunLightTitle => 'Sol y luz';

  @override
  String get firstLight => 'Primera luz';

  @override
  String get goldenMorningEnds => 'Termina la hora dorada de la mañana';

  @override
  String get solarNoon => 'Mediodía solar';

  @override
  String get goldenEveningStarts => 'Empieza la hora dorada de la tarde';

  @override
  String get lastLight => 'Última luz';

  @override
  String get darkSky => 'Cielo totalmente oscuro';

  @override
  String get sunDayLength => 'Duración del día';

  @override
  String durationHm(String hours, String minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get sunNote =>
      'La hora dorada es cuando el Sol está a menos de 6° sobre el horizonte. La primera y la última luz ocurren cuando está 6° por debajo, y el cielo está totalmente oscuro cuando está 18° por debajo. Las horas se calculan para la fecha que elijas.';

  @override
  String get sunStaysUp => 'Este día el Sol no se pone.';

  @override
  String get sunStaysDown => 'Este día el Sol no sale.';

  @override
  String get solarSystemTitle => 'Sistema solar';

  @override
  String get starMapTitle => 'Mapa estelar';

  @override
  String get starMapCardHint => 'Estrellas y constelaciones de tu cielo';

  @override
  String get starMapHint =>
      'Arrastra para mirar alrededor, junta los dedos para acercar y toca una estrella o una constelación.';

  @override
  String get starsLabel => 'Estrellas';

  @override
  String get constellationsLabel => 'Constelaciones';

  @override
  String get starMapFind => 'Encontrarla';

  @override
  String get constellationsList => 'Todas las constelaciones';

  @override
  String magnitudeValue(String value) {
    return 'Magnitud $value';
  }

  @override
  String get starBelowHorizon => 'Bajo el horizonte a esta hora';

  @override
  String get starMapNow => 'Ahora';

  @override
  String get starUnnamed => 'Estrella';

  @override
  String get binocularsTitle => 'Guía de prismáticos';

  @override
  String get binocularsHint => 'Qué buscar con unos prismáticos normales';

  @override
  String get binocularsIntro =>
      'Sostén los prismáticos con firmeza, por ejemplo apoyando los codos en un muro o en el techo de un coche. Lejos de las luces de la ciudad, busca manchas tenues y difusas más que estrellas nítidas.';

  @override
  String get binocularsNote =>
      'Las horas indican cuándo está más alto cada objeto durante la parte oscura de la noche en la ciudad que elegiste. Los nombres de los objetos son los que se usan en todo el mundo. Toca uno para verlo en el mapa estelar.';

  @override
  String get dsoCluster => 'Cúmulo estelar';

  @override
  String get dsoGalaxy => 'Galaxia';

  @override
  String get dsoNebula => 'Nebulosa';

  @override
  String get storyOri =>
      'Orión el Cazador es fácil de encontrar: tres estrellas en una línea recta corta forman su cinturón. Sobre el cinturón, la anaranjada Betelgeuse marca un hombro; debajo, la blanquiazul Rigel marca un pie. Bajo el cinturón cuelga una mancha tenue y difusa, la nebulosa de Orión, una nube donde están naciendo estrellas nuevas. Orión se ve por la tarde en invierno en el norte y en verano en el sur.';

  @override
  String get storyUMa =>
      'Las siete estrellas brillantes del Carro, también llamado Cazo o Big Dipper, forman parte de la Osa Mayor. Las dos estrellas del borde del cuenco, Dubhe y Merak, señalan el camino hacia Polaris: sigue la línea hacia arriba unas cinco veces la distancia entre ellas. Desde buena parte del norte, el Carro da vueltas alrededor de Polaris toda la noche y nunca se pone.';

  @override
  String get storyUMi =>
      'Polaris, la estrella polar, está en la punta de la cola de la Osa Menor. Casi no se mueve porque está casi exactamente sobre el polo norte de la Tierra, así que todo el cielo parece girar a su alrededor. Su altura sobre el horizonte es igual a tu latitud. No es una estrella muy brillante, pero es la más útil para encontrar el norte. No se puede ver desde la mitad sur del mundo.';

  @override
  String get storyCas =>
      'Casiopea tiene forma de W o de M, según la hora y la estación, y está hecha de cinco estrellas bastante brillantes. Está al otro lado de Polaris respecto al Carro, así que cuando una está baja, la otra está alta. En la historia antigua era una reina que presumía de su belleza.';

  @override
  String get storyCyg =>
      'El Cisne vuela a lo largo de la Vía Láctea. Sus estrellas más brillantes forman la Cruz del Norte, con Deneb arriba, la cola del cisne. Lejos de las luces de la ciudad, la Vía Láctea parece un pálido río de luz que atraviesa al cisne, y los prismáticos muestran que está hecha de incontables estrellas débiles. Las tardes de verano y otoño son las mejores.';

  @override
  String get storySco =>
      'Escorpio parece un escorpión con la cola curva que acaba en un gancho. Su corazón es la roja Antares, cuyo nombre significa rival de Marte porque los dos se parecen en el color. Es una constelación de verano en el norte, baja hacia el sur, y pasa alta sobre la cabeza de quienes viven en la mitad sur del mundo.';

  @override
  String get storyLeo =>
      'Leo, el León, es una de las pocas constelaciones que de verdad se parece a su animal. Un signo de interrogación al revés hecho de estrellas, la Hoz, forma la cabeza y el pecho y termina en la brillante Régulo, el corazón del león. El triángulo de estrellas del este son sus cuartos traseros. Las tardes de primavera son las mejores en el norte.';

  @override
  String get storyTau =>
      'Tauro, el Toro, tiene una cara en forma de V, el cúmulo de las Híades, con la anaranjada Aldebarán como ojo. Aldebarán parece pertenecer al cúmulo, pero está mucho más cerca de nosotros. Más arriba, las Pléyades, o Siete Hermanas, son un diminuto grupo de estrellas azules que la mayoría de la gente ve como seis o siete. Las Pléyades se conocen en todo el mundo y aparecen en las historias de muchas culturas.';

  @override
  String get storyGem =>
      'Géminis, los Gemelos, se reconoce por dos estrellas brillantes, Cástor y Pólux, que están lado a lado como las cabezas de dos hermanos. Pólux es la más brillante y tiene un tono anaranjado. Cástor es en realidad un sistema de seis estrellas. Búscalas en lo alto del cielo en las tardes de invierno y primavera en el norte.';

  @override
  String get storyLyr =>
      'La Lira es pequeña, pero contiene a Vega, una de las estrellas más brillantes del cielo del norte. Vega es blanquiazul y, junto con Deneb en Cisne y Altair en Águila, forma el Triángulo de Verano. Justo al lado de Vega, un pequeño paralelogramo de estrellas forma el cuerpo de la lira.';

  @override
  String get storyCru =>
      'La Cruz del Sur (Crux) es la más pequeña de todas las constelaciones, pero una de las más famosas. Cuatro estrellas brillantes forman una cruz, y las dos estrellas de su brazo largo señalan hacia el polo sur celeste, así que ayuda a los viajeros a encontrar el sur. No se puede ver desde la mayor parte de la mitad norte del mundo.';
}
