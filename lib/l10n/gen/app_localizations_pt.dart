// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Heliora';

  @override
  String get tagline => 'Explore o Sistema Solar, totalmente offline';

  @override
  String get navExplore => 'Explorar';

  @override
  String get navCompare => 'Comparar';

  @override
  String get navWeight => 'Peso';

  @override
  String get navQuiz => 'Quiz';

  @override
  String get viewMode => 'Modo de visualização';

  @override
  String get settings => 'Configurações';

  @override
  String get notToScale => 'Fora de escala · Toque num planeta para abri-lo';

  @override
  String get dragToRotate => 'Arraste para girar · Pince para dar zoom';

  @override
  String get planetsTitle => 'Planetas';

  @override
  String get planetMercury => 'Mercúrio';

  @override
  String get planetVenus => 'Vênus';

  @override
  String get planetEarth => 'Terra';

  @override
  String get planetMars => 'Marte';

  @override
  String get planetJupiter => 'Júpiter';

  @override
  String get planetSaturn => 'Saturno';

  @override
  String get planetUranus => 'Urano';

  @override
  String get planetNeptune => 'Netuno';

  @override
  String planetOrder(int n) {
    return 'Planeta $n a partir do Sol';
  }

  @override
  String get openDetails => 'Ver detalhes';

  @override
  String get diameter => 'Diâmetro';

  @override
  String get gravity => 'Gravidade';

  @override
  String get avgTemp => 'Temperatura média';

  @override
  String get avgTempShort => 'Temp. média';

  @override
  String get dayLength => 'Dia';

  @override
  String get yearLength => 'Ano';

  @override
  String get moons => 'Luas conhecidas';

  @override
  String get moonsShort => 'Luas';

  @override
  String get distance => 'Distância do Sol';

  @override
  String get pressure => 'Pressão na superfície';

  @override
  String get noSurface => 'Sem superfície sólida';

  @override
  String valueKm(String value) {
    return '$value km';
  }

  @override
  String valueMillionKm(String value) {
    return '$value milhões de km';
  }

  @override
  String valueHours(String value) {
    return '$value h';
  }

  @override
  String valueDays(String value) {
    return '$value dias';
  }

  @override
  String valueYears(String value) {
    return '$value anos';
  }

  @override
  String get atmosphere => 'Atmosfera';

  @override
  String get thinAtmosphere =>
      'Quase não há atmosfera. Esses gases formam uma camada muito fina chamada exosfera.';

  @override
  String get oxygen => 'Oxigênio';

  @override
  String get oxygenVsEarth => 'Oxigênio comparado com a Terra';

  @override
  String get breathable => 'Respirável para humanos';

  @override
  String get notBreathable => 'Não respirável, é preciso um traje espacial';

  @override
  String weightFeelsLike(String weight) {
    return '$weight kg na Terra aqui parecem';
  }

  @override
  String get gasCo2 => 'Dióxido de carbono';

  @override
  String get gasN2 => 'Nitrogênio';

  @override
  String get gasO2 => 'Oxigênio';

  @override
  String get gasAr => 'Argônio';

  @override
  String get gasH2 => 'Hidrogênio';

  @override
  String get gasHe => 'Hélio';

  @override
  String get gasCh4 => 'Metano';

  @override
  String get gasNa => 'Sódio';

  @override
  String get gasK => 'Potássio';

  @override
  String get compareTitle => 'Comparar planetas';

  @override
  String get compareHint => 'Escolha dois planetas para vê-los lado a lado.';

  @override
  String get weightTitle => 'Seu peso em outros planetas';

  @override
  String get weightInput => 'Seu peso na Terra (kg)';

  @override
  String gravityTimes(String factor) {
    return '$factor× a gravidade da Terra';
  }

  @override
  String get quizTitle => 'Quiz dos planetas';

  @override
  String get quizIntro =>
      '10 perguntas sobre os planetas e as luas. Quantas você acerta?';

  @override
  String get quizStart => 'Começar quiz';

  @override
  String quizProgress(int current, int total) {
    return 'Pergunta $current de $total';
  }

  @override
  String get quizNext => 'Próxima';

  @override
  String get quizSeeResult => 'Ver resultado';

  @override
  String get quizCorrect => 'Correto!';

  @override
  String quizWrong(String answer) {
    return 'Não exatamente. A resposta é $answer.';
  }

  @override
  String quizScore(int score, int total) {
    return 'Você acertou $score de $total';
  }

  @override
  String quizBest(int score) {
    return 'Melhor pontuação: $score';
  }

  @override
  String get quizNewBest => 'Nova melhor pontuação!';

  @override
  String get quizAgain => 'Jogar de novo';

  @override
  String get qLargest => 'Qual é o maior planeta?';

  @override
  String get qSmallest => 'Qual é o menor planeta?';

  @override
  String get qHottest => 'Qual é o planeta mais quente?';

  @override
  String get qColdest => 'Qual é o planeta mais frio?';

  @override
  String get qMostMoons => 'Qual planeta tem mais luas conhecidas?';

  @override
  String get qBreathable => 'Em qual planeta os humanos podem respirar o ar?';

  @override
  String get qClosest => 'Qual planeta está mais perto do Sol?';

  @override
  String get qFarthest => 'Qual planeta está mais longe do Sol?';

  @override
  String get qStrongestGravity => 'Qual planeta tem a gravidade mais forte?';

  @override
  String get qShortestDay => 'Qual planeta tem o dia mais curto?';

  @override
  String get qLongestDay => 'Qual planeta tem o dia mais longo?';

  @override
  String get appearance => 'Aparência';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get language => 'Idioma';

  @override
  String get appLanguage => 'Idioma do app';

  @override
  String get languageNote => '20 idiomas · nomes dos planetas também';

  @override
  String get phoneLanguage => 'Idioma do telefone';

  @override
  String get updates => 'Atualizações';

  @override
  String get version => 'Versão';

  @override
  String get checkForUpdates => 'Procurar atualizações';

  @override
  String get checking => 'Procurando…';

  @override
  String get autoUpdateCheck => 'Procurar automaticamente uma vez por dia';

  @override
  String get updateNote =>
      'As atualizações vêm do GitHub Releases. Suas configurações ficam no seu telefone.';

  @override
  String get upToDate => 'Você já tem a versão mais recente.';

  @override
  String get updateFailed =>
      'Não foi possível acessar o GitHub. Verifique a internet e tente de novo.';

  @override
  String get updateAvailable => 'Atualização disponível';

  @override
  String updateReady(String version) {
    return 'A versão $version está pronta para baixar.';
  }

  @override
  String get download => 'Baixar';

  @override
  String get later => 'Depois';

  @override
  String get about => 'Sobre';

  @override
  String get sourceCode => 'Código-fonte no GitHub';

  @override
  String get privacyLine => 'Offline · Sem anúncios · Sem rastreamento';

  @override
  String get dataSource => 'Dados: NASA Planetary Fact Sheet';

  @override
  String get openFailed => 'Não foi possível abrir o link.';

  @override
  String get bodySun => 'Sol';

  @override
  String get bodyMoon => 'Lua';

  @override
  String get bodyPluto => 'Plutão';

  @override
  String get moonIo => 'Io';

  @override
  String get moonEuropa => 'Europa';

  @override
  String get moonGanymede => 'Ganimedes';

  @override
  String get moonCallisto => 'Calisto';

  @override
  String get moonTitan => 'Titã';

  @override
  String get moonEnceladus => 'Encélado';

  @override
  String get moonTriton => 'Tritão';

  @override
  String get kindStar => 'Nossa estrela, o centro do Sistema Solar';

  @override
  String get kindDwarf => 'Planeta anão';

  @override
  String moonOf(String planet) {
    return 'Lua de $planet';
  }

  @override
  String get orbitPeriod => 'Uma órbita';

  @override
  String distanceFrom(String body) {
    return 'Distância de $body';
  }

  @override
  String get composition => 'Do que é feito';

  @override
  String get noAtmosphere => 'Não tem atmosfera de verdade, é quase vácuo.';

  @override
  String get majorMoons => 'Luas principais';

  @override
  String get lifeTitle => 'Humanos poderiam viver aqui?';

  @override
  String get lifeScoreShort => 'Pontuação de vida';

  @override
  String get lifeNote =>
      'Calculada pela temperatura, pressão do ar, oxigênio, água, superfície e gravidade. A Terra tira 10.';

  @override
  String get water => 'Água';

  @override
  String get waterLiquid => 'Água líquida';

  @override
  String get waterIce => 'Gelo';

  @override
  String get waterOcean => 'Oceano sob o gelo';

  @override
  String get waterNone => 'Sem água';

  @override
  String get surface => 'Superfície';

  @override
  String get solidSurface => 'Superfície sólida';

  @override
  String get lifeHome => 'Igual a estar em casa';

  @override
  String get lifeHard =>
      'Muito difícil, seria preciso uma base fechada e trajes espaciais';

  @override
  String get lifeNo => 'Impossível para humanos';

  @override
  String get downloadInstall => 'Baixar e instalar';

  @override
  String downloadingPercent(String percent) {
    return 'Baixando… $percent%';
  }

  @override
  String get installNow => 'Instalar';

  @override
  String get allowInstalls =>
      'Permita que o Heliora instale apps na tela que abriu, depois volte e toque em Instalar.';

  @override
  String get downloadFailed =>
      'O download não terminou. Verifique a internet e tente de novo.';

  @override
  String get tryAgain => 'Tentar de novo';

  @override
  String get today => 'Hoje';

  @override
  String get play => 'Reproduzir';

  @override
  String get pause => 'Pausar';

  @override
  String get monthBack => '30 dias antes';

  @override
  String get monthForward => '30 dias depois';

  @override
  String get positionsNote =>
      'Posições reais nesta data · Tamanhos e distâncias fora de escala · Toque num planeta';

  @override
  String get navYou => 'Você';

  @override
  String get ageTitle => 'Sua idade em outros planetas';

  @override
  String get setBirthDate => 'Informe sua data de nascimento';

  @override
  String get changeBirthDate => 'Alterar';

  @override
  String nextBirthday(String days) {
    return 'Próximo aniversário em $days dias';
  }

  @override
  String get ageNote => 'Sua data de nascimento fica salva só neste telefone.';

  @override
  String get share => 'Compartilhar';

  @override
  String shareText(String planet) {
    return '$planet no Heliora, o app gratuito do Sistema Solar offline: https://github.com/lumio-apps/heliora';
  }

  @override
  String get shareFailed => 'Não foi possível compartilhar a imagem.';

  @override
  String get travelTitle => 'A que distância fica?';

  @override
  String get distanceFromEarth => 'Distância da Terra hoje';

  @override
  String get lightTime => 'A luz leva';

  @override
  String get bySpacecraft => 'De nave espacial a 60.000 km/h';

  @override
  String get byCar => 'De carro a 100 km/h';

  @override
  String valueSeconds(String value) {
    return '$value s';
  }

  @override
  String valueMinutes(String value) {
    return '$value min';
  }

  @override
  String get sizeTitle => 'Tamanho';

  @override
  String sizeTimes(String big, String times, String small) {
    return '$big é $times× mais largo que $small.';
  }

  @override
  String sizeSimilar(String a, String b) {
    return '$a e $b têm quase o mesmo tamanho.';
  }

  @override
  String get navSky => 'Céu';

  @override
  String get skyTitle => 'O céu desta noite';

  @override
  String get chooseCity => 'Escolha sua cidade';

  @override
  String get chooseCityHint =>
      'Escolha a cidade mais próxima para ver a Lua e os planetas visíveis esta noite. Não precisa de permissão de localização e fica só no seu telefone.';

  @override
  String get searchCity => 'Buscar cidade';

  @override
  String get noCityFound => 'Nenhuma cidade encontrada';

  @override
  String get cityNote =>
      'Os horários estão no fuso do seu telefone. Um planeta conta como visível quando está pelo menos 5° acima do horizonte com o céu escuro.';

  @override
  String illuminated(String percent) {
    return '$percent% iluminada';
  }

  @override
  String get moonrise => 'Nascer da Lua';

  @override
  String get moonset => 'Ocaso da Lua';

  @override
  String get sunset => 'Pôr do sol';

  @override
  String get sunrise => 'Nascer do sol';

  @override
  String get nextFull => 'Próxima lua cheia';

  @override
  String get nextNew => 'Próxima lua nova';

  @override
  String get phaseNew => 'Lua nova';

  @override
  String get phaseWaxingCrescent => 'Lua crescente';

  @override
  String get phaseFirstQuarter => 'Quarto crescente';

  @override
  String get phaseWaxingGibbous => 'Crescente gibosa';

  @override
  String get phaseFull => 'Lua cheia';

  @override
  String get phaseWaningGibbous => 'Minguante gibosa';

  @override
  String get phaseLastQuarter => 'Quarto minguante';

  @override
  String get phaseWaningCrescent => 'Lua minguante';

  @override
  String get planetsTonight => 'Planetas esta noite';

  @override
  String get statusVisible => 'Visível esta noite';

  @override
  String get statusEvening => 'À noitinha, após o pôr do sol';

  @override
  String get statusMorning => 'De madrugada, antes do nascer do sol';

  @override
  String get statusNotVisible => 'Não visível esta noite';

  @override
  String bestAt(String time) {
    return 'Melhor às $time';
  }

  @override
  String altitudeDir(String direction, String degrees) {
    return '$direction, a $degrees° de altura';
  }

  @override
  String riseSet(String rise, String set) {
    return 'Nasce $rise · Se põe $set';
  }

  @override
  String get needsTelescope => 'Precisa de binóculo ou telescópio';

  @override
  String get dirN => 'Norte';

  @override
  String get dirNE => 'Nordeste';

  @override
  String get dirE => 'Leste';

  @override
  String get dirSE => 'Sudeste';

  @override
  String get dirS => 'Sul';

  @override
  String get dirSW => 'Sudoeste';

  @override
  String get dirW => 'Oeste';

  @override
  String get dirNW => 'Noroeste';

  @override
  String get findPlanet => 'Encontrar no céu';

  @override
  String finderTitle(String name) {
    return 'Encontrar $name';
  }

  @override
  String get pointPhone => 'Levante o celular e mova-o devagar.';

  @override
  String turnRight(String degrees) {
    return 'Vire à direita $degrees°';
  }

  @override
  String turnLeft(String degrees) {
    return 'Vire à esquerda $degrees°';
  }

  @override
  String tiltUp(String degrees) {
    return 'Incline para cima $degrees°';
  }

  @override
  String tiltDown(String degrees) {
    return 'Incline para baixo $degrees°';
  }

  @override
  String onTarget(String name) {
    return '$name está bem ali!';
  }

  @override
  String belowHorizon(String name) {
    return '$name está abaixo do horizonte agora.';
  }

  @override
  String risesAt(String time) {
    return 'Nasce às $time.';
  }

  @override
  String get noSensor =>
      'Este celular não tem sensor de bússola, então o localizador não funciona.';

  @override
  String get calibrate =>
      'A bússola precisa ser calibrada: mova o celular em forma de 8 algumas vezes.';

  @override
  String get phoneNow => 'Seu celular aponta para';

  @override
  String get finderNote =>
      'Segure o celular com a parte de trás voltada para o céu e longe de ímãs e metais. Nunca olhe para o Sol.';

  @override
  String get eventsTitle => 'Eventos espaciais';

  @override
  String get eventsSubtitle => 'O que observar no céu nos próximos 12 meses.';

  @override
  String eventsNext(String event, String when) {
    return 'Próximo: $event · $when';
  }

  @override
  String get eventFullMoon => 'Lua cheia';

  @override
  String get eventNewMoon => 'Lua nova';

  @override
  String eventOpposition(String planet) {
    return '$planet em oposição';
  }

  @override
  String eventEveningElongation(String planet) {
    return '$planet: melhor visão à noite';
  }

  @override
  String eventMorningElongation(String planet) {
    return '$planet: melhor visão de manhã';
  }

  @override
  String eventConjunction(String a, String b) {
    return '$a e $b se encontram';
  }

  @override
  String get eventMarchEquinox => 'Equinócio de março';

  @override
  String get eventJuneSolstice => 'Solstício de junho';

  @override
  String get eventSeptemberEquinox => 'Equinócio de setembro';

  @override
  String get eventDecemberSolstice => 'Solstício de dezembro';

  @override
  String get eventFullMoonDesc =>
      'Todo o rosto da Lua está iluminado. Ela nasce perto do pôr do sol.';

  @override
  String get eventNewMoonDesc =>
      'A Lua fica escondida. O céu mais escuro do mês para ver estrelas e planetas.';

  @override
  String eventOppositionDesc(String planet) {
    return '$planet está oposto ao Sol. Está no seu brilho máximo do ano e aparece a noite toda.';
  }

  @override
  String eventEveningDesc(String planet, String degrees) {
    return '$planet está a $degrees° do Sol, o mais longe possível. Olhe baixo no oeste depois do pôr do sol.';
  }

  @override
  String eventMorningDesc(String planet, String degrees) {
    return '$planet está a $degrees° do Sol, o mais longe possível. Olhe baixo no leste antes do nascer do sol.';
  }

  @override
  String eventConjunctionDesc(String degrees) {
    return 'Eles passam a apenas $degrees° um do outro no céu.';
  }

  @override
  String get eventEquinoxDesc =>
      'Dia e noite têm quase a mesma duração em toda a Terra.';

  @override
  String get eventJuneSolsticeDesc =>
      'Dia mais longo no norte, mais curto no sul.';

  @override
  String get eventDecemberSolsticeDesc =>
      'Dia mais curto no norte, mais longo no sul.';

  @override
  String eventMeteorShower(String shower) {
    return 'Chuva de meteoros $shower';
  }

  @override
  String eventMeteorDesc(String rate, String percent) {
    return 'Até cerca de $rate meteoros por hora em céu escuro. A Lua estará $percent% iluminada.';
  }

  @override
  String get showerQuadrantids => 'Quadrantídeas';

  @override
  String get showerLyrids => 'Líridas';

  @override
  String get showerEtaAquariids => 'Eta Aquáridas';

  @override
  String get showerPerseids => 'Perseidas';

  @override
  String get showerOrionids => 'Oriônidas';

  @override
  String get showerLeonids => 'Leônidas';

  @override
  String get showerGeminids => 'Geminídeas';

  @override
  String get showerUrsids => 'Ursídeas';

  @override
  String get eventToday => 'Hoje';

  @override
  String get eventTomorrow => 'Amanhã';

  @override
  String eventInDays(String days) {
    return 'Em $days dias';
  }

  @override
  String get eventsNote =>
      'As datas são calculadas no seu celular e mostradas no fuso horário dele. Os picos das chuvas de meteoros são datas típicas de cada ano e podem variar um dia. Os lembretes ficam só no seu celular.';

  @override
  String get remindMe => 'Lembrar-me';

  @override
  String reminderSet(String date) {
    return 'Certo, vou lembrar você em $date.';
  }

  @override
  String get reminderOff => 'Lembrete removido.';

  @override
  String get reminderTooLate =>
      'Este evento está muito próximo para definir um lembrete.';

  @override
  String get notificationsOff =>
      'As notificações do Heliora estão desativadas. Ative-as nas configurações do Android.';

  @override
  String get reminderTomorrow => 'É amanhã';

  @override
  String get reminderToday => 'Acontece hoje';

  @override
  String get onlineTitle => 'Recursos online';

  @override
  String get onlineSubtitle =>
      'Mostre a estação espacial e os lançamentos de foguetes. Então o Heliora só contata wheretheiss.at, Celestrak e Launch Library 2, que podem ver o endereço de internet do seu celular. Nada mais é enviado. Desligado por padrão.';

  @override
  String get turnOnOnline => 'Ativar recursos online';

  @override
  String get issTitle => 'Estação espacial';

  @override
  String get issCardHint => 'Onde está agora e quando passa sobre você';

  @override
  String get issNeedsOnline =>
      'Para mostrar a estação, o Heliora precisa dos dados de órbita dela pela internet. Eles são baixados uma vez e depois funcionam offline por dias.';

  @override
  String get issLoading => 'Obtendo os dados de órbita…';

  @override
  String get issFailed =>
      'Não foi possível obter os dados de órbita. Verifique a internet e tente de novo.';

  @override
  String issStale(String days) {
    return 'Os dados de órbita têm $days dias, então as posições podem estar erradas. Conecte-se à internet para atualizar.';
  }

  @override
  String get issHeight => 'Altura';

  @override
  String get issSpeed => 'Velocidade';

  @override
  String get issFromYou => 'Distância de você';

  @override
  String valueKmh(String value) {
    return '$value km/h';
  }

  @override
  String issAboveHorizon(String direction, String degrees) {
    return 'Acima do seu horizonte agora! Olhe para $direction, a $degrees° de altura.';
  }

  @override
  String get issBelowHorizon => 'Abaixo do seu horizonte agora.';

  @override
  String issPassesTitle(String city) {
    return 'Próximas passagens sobre $city';
  }

  @override
  String get issNoPasses => 'Nenhuma boa passagem nos próximos 5 dias.';

  @override
  String issMaxHigh(String degrees) {
    return 'Até $degrees° de altura';
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
  String get issPassTitle => 'A estação espacial está passando sobre você';

  @override
  String issPassBody(String degrees, String direction) {
    return 'Nasce em 10 minutos, até $degrees° de altura. Olhe para $direction.';
  }

  @override
  String get issNote =>
      'As posições são calculadas no seu celular com os dados de órbita da estação. Uma passagem é fácil de ver quando o céu está escuro e o Sol ilumina a estação: parece uma estrela brilhante e rápida.';

  @override
  String get launchesNeedOnline =>
      'Ative os recursos online para ver aqui os próximos lançamentos de foguetes.';

  @override
  String get launchesFailed =>
      'Não foi possível atualizar a lista de lançamentos. Mostrando a lista salva.';

  @override
  String get launchesNote =>
      'Os horários de lançamento vêm do Launch Library 2 e mudam com frequência. Nomes e lugares estão em inglês.';

  @override
  String get launchReminderBody =>
      'Decola em cerca de uma hora. O horário pode mudar.';

  @override
  String get launchTimeTbd => 'Horário ainda não definido';

  @override
  String get quizChoose => 'Escolha um nível';

  @override
  String get levelEasy => 'Fácil';

  @override
  String get levelMedium => 'Médio';

  @override
  String get levelHard => 'Difícil';

  @override
  String get levelEasyHint => 'O básico sobre os planetas';

  @override
  String get levelMediumHint => 'Planetas e luas';

  @override
  String get levelHardHint => 'Comparações e rankings difíceis';

  @override
  String get qStar => 'Qual destes é uma estrela, e não um planeta?';

  @override
  String get qDwarf => 'Qual destes é um planeta anão?';

  @override
  String get qMoonVisited => 'Em qual lua as pessoas já caminharam?';

  @override
  String get qLargestMoon => 'Qual destas luas é a maior?';

  @override
  String get qSmallestMoon => 'Qual destas luas é a menor?';

  @override
  String get qThickAirMoon => 'Qual destas luas tem uma atmosfera densa?';

  @override
  String get qGeyserMoon => 'Qual lua lança gêiseres de água no espaço?';

  @override
  String get qVolcanicMoon => 'Qual lua tem os vulcões mais ativos?';

  @override
  String get qBackwardsMoon =>
      'Qual lua gira ao redor do seu planeta ao contrário?';

  @override
  String get qBiggestRocky => 'Qual é o maior dos quatro planetas rochosos?';

  @override
  String get qColdestRocky =>
      'Qual é o mais frio dos quatro planetas rochosos?';

  @override
  String get qHighestPressure =>
      'Qual planeta tem a maior pressão do ar na superfície?';

  @override
  String get qSecondLargest => 'Qual planeta é o segundo maior?';

  @override
  String get qLongestYear => 'Qual planeta tem o ano mais longo?';

  @override
  String get qShortestYear => 'Qual planeta tem o ano mais curto?';

  @override
  String get qSmallestGiant => 'Qual é o menor dos quatro planetas gigantes?';

  @override
  String get qRockyLongestYear =>
      'Qual dos quatro planetas rochosos tem o ano mais longo?';

  @override
  String get qFastestMoon =>
      'Qual destas luas dá a volta no seu planeta mais rápido?';

  @override
  String get qSlowestMoon =>
      'Qual destas luas leva mais tempo para dar a volta no seu planeta?';

  @override
  String get qStrongestMoonGravity =>
      'Qual destas luas tem a gravidade mais forte?';

  @override
  String get qColdestMoon => 'Qual destas luas é a mais fria?';

  @override
  String get qSecondLargestMoon => 'Qual destas luas é a segunda maior?';

  @override
  String get factTitle => 'Você sabia?';

  @override
  String get factTap => 'Toque para ver outra curiosidade';

  @override
  String get factSun1 =>
      'O Sol concentra 99,8% de toda a massa do sistema solar.';

  @override
  String get factSun2 =>
      'A luz do Sol leva cerca de 8 minutos e 20 segundos para chegar à Terra.';

  @override
  String get factMercury1 =>
      'Um dia em Mercúrio, de um nascer do Sol ao seguinte, dura cerca de 176 dias terrestres. É o dobro do seu ano.';

  @override
  String get factMercury2 =>
      'Mercúrio quase não tem ar, então o céu é preto até de dia, e as noites são congelantes.';

  @override
  String get factVenus1 =>
      'Vênus gira ao contrário, então em Vênus o Sol nasce no oeste.';

  @override
  String get factVenus2 =>
      'Vênus é mais quente que Mercúrio, mesmo estando mais longe do Sol, porque o ar espesso dela prende o calor.';

  @override
  String get factEarth1 =>
      'A Terra é o único lugar com vida que conhecemos, e cerca de 71% da sua superfície é coberta por água.';

  @override
  String get factEarth2 =>
      'A Terra não é uma bola perfeita. Ela é um pouco mais larga no equador porque gira.';

  @override
  String get factMars1 =>
      'O Monte Olimpo, em Marte, é o maior vulcão do sistema solar, com cerca de duas vezes e meia a altura do Everest.';

  @override
  String get factMars2 => 'Os pores do sol em Marte parecem azuis.';

  @override
  String get factJupiter1 =>
      'Júpiter tem mais do dobro da massa de todos os outros planetas juntos.';

  @override
  String get factJupiter2 =>
      'A Grande Mancha Vermelha é uma tempestade maior que a Terra, observada há mais de 150 anos.';

  @override
  String get factSaturn1 =>
      'Saturno é tão leve para o seu tamanho que boiaria na água, se existisse uma banheira grande o bastante.';

  @override
  String get factSaturn2 =>
      'Os anéis de Saturno são muito largos, mas muito finos: em alguns pontos têm só uns dez metros de espessura.';

  @override
  String get factUranus1 =>
      'Urano gira ao redor do Sol rolando de lado, inclinado cerca de 98 graus.';

  @override
  String get factUranus2 =>
      'Urano foi o primeiro planeta descoberto com um telescópio. William Herschel o viu em 1781.';

  @override
  String get factNeptune1 =>
      'Netuno tem os ventos mais rápidos de qualquer planeta, com mais de 2.000 km/h.';

  @override
  String get factNeptune2 =>
      'Netuno foi achado pela matemática antes de alguém vê-lo: em 1846, astrônomos calcularam onde ele devia estar.';

  @override
  String get factMoon1 =>
      'A Lua se afasta da Terra cerca de 3,8 centímetros por ano.';

  @override
  String get factMoon2 =>
      'Sempre vemos o mesmo lado da Lua, porque ela gira exatamente uma vez a cada volta ao redor da Terra.';

  @override
  String get factPluto1 =>
      'Um ano em Plutão dura cerca de 248 anos terrestres.';

  @override
  String get factPluto2 =>
      'Plutão tem uma enorme planície em formato de coração feita de nitrogênio congelado.';

  @override
  String get factIo1 =>
      'Io é o mundo mais vulcânico que conhecemos, com centenas de vulcões ativos.';

  @override
  String get factIo2 =>
      'A gravidade de Júpiter aperta e estica Io, e o calor disso alimenta os vulcões dele.';

  @override
  String get factEuropa1 =>
      'Sob a casca de gelo, Europa provavelmente guarda cerca do dobro da água de todos os oceanos da Terra.';

  @override
  String get factEuropa2 =>
      'Europa é um dos melhores lugares para procurar vida fora da Terra. A sonda Europa Clipper está a caminho.';

  @override
  String get factGanymede1 =>
      'Ganimedes é a maior lua do sistema solar. Ela é até maior que Mercúrio.';

  @override
  String get factGanymede2 =>
      'Ganimedes é a única lua conhecida com campo magnético próprio.';

  @override
  String get factCallisto1 =>
      'Calisto é um dos lugares com mais crateras do sistema solar, e a superfície dela é muito antiga.';

  @override
  String get factCallisto2 =>
      'Calisto fica longe o bastante de Júpiter para receber menos da radiação dele, por isso cientistas a sugeriram para uma futura base.';

  @override
  String get factTitan1 =>
      'Titã é a única lua com atmosfera densa. A pressão do ar na superfície dela é maior que na Terra.';

  @override
  String get factTitan2 =>
      'Titã tem rios e lagos, mas eles são de metano e etano líquidos, não de água.';

  @override
  String get factEnceladus1 =>
      'Encélado lança jatos de gelo e vapor de água no espaço por rachaduras perto do polo sul.';

  @override
  String get factEnceladus2 =>
      'Os jatos de Encélado alimentam o anel E de Saturno.';

  @override
  String get factTriton1 =>
      'Tritão gira ao redor de Netuno ao contrário, então provavelmente era um planeta anão capturado por Netuno.';

  @override
  String get factTriton2 =>
      'A cerca de −235 °C, Tritão é um dos lugares mais frios já medidos no sistema solar.';

  @override
  String get jumpInput => 'A altura do seu pulo na Terra (cm)';

  @override
  String jumpHigh(String height) {
    return 'Pulo: $height';
  }

  @override
  String jumpFeelsLike(String height) {
    return 'Um pulo de $height na Terra vira';
  }

  @override
  String get jumpNote =>
      'Com o mesmo impulso da Terra. No Sol e nos gigantes gasosos não há chão para pisar, então isto é só um jogo de imaginação.';

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
      'A Lua entra por completo na sombra da Terra e muitas vezes fica de um vermelho fraco. Todos no lado noturno da Terra podem ver, e é seguro olhar a olho nu.';

  @override
  String eclipsePartialLunarDesc(String percent) {
    return 'Uma parte da Lua ($percent% da sua largura) entra na sombra escura da Terra. É seguro olhar a olho nu.';
  }

  @override
  String get eclipsePenumbralLunarDesc =>
      'A Lua passa pela sombra externa e fraca da Terra. Ela só escurece um pouco, por isso é difícil de notar.';

  @override
  String get eclipseTotalSolarDesc =>
      'A Lua cobre o Sol por completo ao longo de uma faixa estreita na Terra. Fora dessa faixa, vê-se um eclipse parcial.';

  @override
  String get eclipseAnnularSolarDesc =>
      'A Lua está um pouco longe demais para cobrir o Sol inteiro, então sobra um anel brilhante. O anel aparece ao longo de uma faixa estreita; fora dela o eclipse é parcial.';

  @override
  String get eclipseHybridSolarDesc =>
      'Ao longo da sua faixa, este eclipse é total em alguns lugares e anular em outros. Fora da faixa, é parcial.';

  @override
  String get eclipsePartialSolarDesc =>
      'A Lua cobre só uma parte do Sol, e em nenhum lugar da Terra o Sol fica totalmente coberto.';

  @override
  String get eclipseNoCity =>
      'Escolha uma cidade no Heliora para ver se dá para assistir de lá.';

  @override
  String eclipseLunarUp(String city) {
    return 'No meio do eclipse, a Lua está acima do horizonte em $city.';
  }

  @override
  String eclipseLunarPartly(String city) {
    return 'Em $city, a Lua fica acima do horizonte só durante parte do eclipse.';
  }

  @override
  String eclipseLunarDown(String city) {
    return 'Em $city, a Lua fica abaixo do horizonte, então não dá para ver de lá.';
  }

  @override
  String eclipseSolarNone(String city) {
    return 'Não é visível de $city: a sombra da Lua não chega lá, ou o Sol está abaixo do horizonte.';
  }

  @override
  String eclipseSolarSlight(String city) {
    return 'De $city, no máximo um eclipse parcial bem leve, difícil de notar.';
  }

  @override
  String eclipseSolarPartial(String city, String percent) {
    return 'Estimativa aproximada para $city: a Lua cobre no máximo cerca de $percent% da largura do Sol.';
  }

  @override
  String eclipseSolarNear(String city) {
    return '$city fica perto da faixa em que o Sol é quase todo ou totalmente coberto. Veja um mapa do eclipse; esta estimativa é aproximada.';
  }

  @override
  String get eclipseSolarSafety =>
      'Nunca olhe para o Sol sem óculos próprios para eclipse.';

  @override
  String get alertsTitle => 'Alertas';

  @override
  String get tonightAlertSwitch => 'O céu de hoje à noite, todo fim de tarde';

  @override
  String get tonightAlertTime => 'Hora';

  @override
  String get tonightAlertNote =>
      'Uma nota curta sobre a Lua e os planetas que você pode ver, no horário que escolher. Ela é calculada no seu celular, sem internet. O Android só deixa o Heliora preparar cerca de duas semanas de notas com antecedência, então abra o app de vez em quando.';

  @override
  String get tonightNotifTitle => 'O céu de hoje à noite';

  @override
  String tonightMoon(String phase, String percent) {
    return 'Lua: $phase, $percent% iluminada.';
  }

  @override
  String tonightPlanets(String planets) {
    return 'Procure: $planets.';
  }

  @override
  String get tonightNoPlanets =>
      'Sem planetas brilhantes no céu do início da noite.';

  @override
  String get tonightNoCity =>
      'Escolha uma cidade no Heliora para ver os planetas.';

  @override
  String get birthdayTitle => 'O céu do meu aniversário';

  @override
  String get birthdaySubtitle =>
      'A Lua e os planetas no dia em que você nasceu, e os grandes dias da sua vida.';

  @override
  String get birthdayCardHint => 'Fase da Lua, planetas e marcos';

  @override
  String get birthdayNeedDate => 'Informe sua data de nascimento';

  @override
  String get birthdayMoon => 'A Lua no seu aniversário';

  @override
  String get birthdayPlanets => 'Os planetas naquele dia';

  @override
  String birthdayDaysOld(String count) {
    return 'Hoje você tem $count dias de vida.';
  }

  @override
  String get birthdayMilestones => 'Marcos';

  @override
  String birthdayDayN(String count) {
    return 'Dia $count';
  }

  @override
  String get birthdayBillion => '1 bilhão de segundos de vida';

  @override
  String get birthdayPassed => 'Feito';

  @override
  String get birthdayNote =>
      'Calculado no seu celular com as mesmas órbitas do resto do Heliora. Sua data de nascimento nunca sai dele.';

  @override
  String get missionsTitle => 'Missões espaciais';

  @override
  String get missionsSubtitle =>
      'Momentos famosos da exploração do espaço, do mais antigo ao mais recente.';

  @override
  String get missionsCardHint => 'Missões famosas ao longo do tempo';

  @override
  String get missionSputnik1 =>
      'O primeiro satélite artificial. Esta bola de metal, do tamanho de uma bola de praia, deu voltas na Terra por cerca de três meses. O seu bipe podia ser ouvido no rádio, e ali começou a era espacial.';

  @override
  String get missionVostok1 =>
      'Yuri Gagarin foi a primeira pessoa no espaço. Ele deu uma volta na Terra em cerca de 108 minutos.';

  @override
  String get missionApollo11 =>
      'Neil Armstrong e Buzz Aldrin pousaram no Mar da Tranquilidade e foram as primeiras pessoas a andar na Lua. Michael Collins os esperou em órbita.';

  @override
  String get missionVenera7 =>
      'A primeira nave a pousar em outro planeta e enviar um sinal. Mandou dados de Vênus por cerca de 23 minutos, sob um calor esmagador.';

  @override
  String get missionViking1 =>
      'Pousou em Marte e funcionou lá por mais de seis anos, enviando a primeira longa série de fotos e boletins do tempo da superfície de outro planeta.';

  @override
  String get missionVoyager1 =>
      'Lançada em 1977, passou por Júpiter e Saturno e entrou no espaço interestelar em 2012. É o objeto feito por humanos mais distante da Terra.';

  @override
  String get missionHubble =>
      'Lançado em 1990, ele observa o universo de cima do ar da Terra. Suas imagens nítidas ajudaram a medir a idade do universo e mostraram milhares de galáxias distantes.';

  @override
  String get missionHuygens =>
      'A sonda Huygens, levada pela Cassini, desceu de paraquedas em Titã, a lua de Saturno. Foi o primeiro pouso no sistema solar externo, e ela enviou imagens da superfície.';

  @override
  String get missionCuriosity =>
      'Este jipe-robô do tamanho de um carro pousou na cratera Gale com um «guindaste aéreo» movido a foguetes. Descobriu que Marte já teve condições adequadas para a vida.';

  @override
  String get missionMangalyaan =>
      'A missão indiana Mars Orbiter chegou à órbita de Marte na primeira tentativa, algo inédito para qualquer país, e com um custo muito baixo.';

  @override
  String get missionRosetta =>
      'O módulo Philae, da Rosetta, pousou no cometa 67P/Churyumov–Gerasimenko: o primeiro pouso em um cometa. A própria Rosetta orbitou o cometa por dois anos.';

  @override
  String get missionNewhorizons =>
      'Depois de uma viagem de nove anos, passou por Plutão e mostrou pela primeira vez montanhas de gelo e uma enorme planície em forma de coração.';

  @override
  String get missionPerseverance =>
      'O jipe-robô Perseverance pousou na cratera Jezero para procurar sinais de vida antiga e coletar amostras de rocha. Seu helicóptero Ingenuity fez o primeiro voo motorizado em outro planeta.';

  @override
  String get missionJwst =>
      'O maior telescópio espacial tem um espelho dourado de 6,5 metros e observa o céu em luz infravermelha a 1,5 milhão de km de distância. Ele vê algumas das primeiras galáxias.';

  @override
  String get missionChandrayaan3 =>
      'A Índia se tornou o quarto país a pousar suavemente na Lua, e o primeiro perto do polo sul. O módulo Vikram levava o jipe-robô Pragyan.';

  @override
  String get spacecraftTitle => 'Naves espaciais agora';

  @override
  String get spacecraftSubtitle =>
      'A que distância da Terra estão agora algumas naves espaciais famosas.';

  @override
  String get spacecraftCardHint => 'Voyager, JWST, rovers de Marte e mais';

  @override
  String get spacecraftDistance => 'Distância da Terra';

  @override
  String get spacecraftAltitude => 'Altura acima da Terra';

  @override
  String get spacecraftInAu => 'Em unidades astronômicas';

  @override
  String get spacecraftSpeed => 'Velocidade';

  @override
  String get spacecraftSignal => 'O sinal de rádio leva';

  @override
  String get spacecraftNote =>
      'As distâncias são estimativas. Para as sondas distantes, elas são calculadas a partir da velocidade média e podem errar cerca de 1%, porque a Terra se move em torno do Sol. A distância de Marte é calculada para hoje. Uma UA (unidade astronômica) é a distância da Terra ao Sol.';

  @override
  String valueBillionKm(String value) {
    return '$value bilhões de km';
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
      'Lançada em 1977. Em 2012, tornou-se a primeira nave a entrar no espaço interestelar. Seu sinal de rádio já tem cerca de um dia quando chega até nós.';

  @override
  String get spacecraftVoyager2 =>
      'Lançada em 1977. É a única nave que visitou Urano e Netuno, e entrou no espaço interestelar em 2018.';

  @override
  String get spacecraftNewHorizons =>
      'Passou por Plutão em 2015 e pelo objeto do Cinturão de Kuiper Arrokoth em 2019. Ainda segue para longe e ainda envia dados.';

  @override
  String get spacecraftJwst =>
      'O maior telescópio espacial, lançado em 2021. Fica perto de um ponto chamado L2, a cerca de 1,5 milhão de km da Terra, com o escudo solar sempre voltado para o Sol.';

  @override
  String get spacecraftIss =>
      'Dá uma volta na Terra a cada 90 minutos, mais ou menos. Desde 2000 há pessoas vivendo a bordo sem interrupção.';

  @override
  String get spacecraftHubble =>
      'Lançado em 1990 e ainda funcionando. Ele gira em torno da Terra acima do ar que borra as imagens, por isso suas fotos são muito nítidas.';

  @override
  String get spacecraftMarsRovers =>
      'Curiosity (pousou em 2012) e Perseverance (pousou em 2021) estão rodando em Marte. A distância até Marte varia de cerca de 55 milhões de km a mais de 400 milhões de km.';

  @override
  String get searchTooltip => 'Buscar';

  @override
  String get searchHint => 'Busque planetas, luas, missões…';

  @override
  String get searchClear => 'Limpar';

  @override
  String searchEmpty(String query) {
    return 'Nada encontrado para “$query”.';
  }

  @override
  String get searchBodies => 'Planetas e luas';

  @override
  String get searchMissions => 'Missões';

  @override
  String get searchSpacecraft => 'Naves espaciais';

  @override
  String get favoritesTitle => 'Favoritos';

  @override
  String get favoritesEmpty =>
      'Toque na estrela de um planeta, missão ou nave para guardá-lo aqui.';

  @override
  String get favoriteAdd => 'Adicionar aos favoritos';

  @override
  String get favoriteRemove => 'Remover dos favoritos';

  @override
  String get textSize => 'Tamanho do texto';

  @override
  String get textSizeNormal => 'Normal';

  @override
  String get textSizeLarge => 'Grande';

  @override
  String get textSizeLarger => 'Maior';

  @override
  String get textSizeNote =>
      'Aumenta o texto no Heliora. Ele nunca fica menor que o tamanho de texto do seu próprio celular.';

  @override
  String get skyOtherNight => 'O céu da noite';

  @override
  String get planetsThatNight => 'Planetas naquela noite';

  @override
  String get previousDay => 'Dia anterior';

  @override
  String get nextDay => 'Dia seguinte';

  @override
  String get pickDate => 'Escolher uma data';

  @override
  String get backToTonight => 'Voltar para esta noite';

  @override
  String get moonCalendar => 'Calendário lunar';

  @override
  String get moonCalendarHint => 'A fase da Lua em cada dia';

  @override
  String get previousMonth => 'Mês anterior';

  @override
  String get nextMonth => 'Próximo mês';

  @override
  String get keyMoonDates => 'Principais fases deste mês';

  @override
  String get moonCalendarNote =>
      'As datas e horas das fases aparecem no fuso horário do seu telefone e têm precisão de cerca de uma hora.';

  @override
  String get seeSkyThatDay => 'Ver o céu deste dia';

  @override
  String get sunLightTitle => 'Sol e luz';

  @override
  String get firstLight => 'Primeira luz';

  @override
  String get goldenMorningEnds => 'Fim da hora dourada da manhã';

  @override
  String get solarNoon => 'Meio-dia solar';

  @override
  String get goldenEveningStarts => 'Início da hora dourada da tarde';

  @override
  String get lastLight => 'Última luz';

  @override
  String get darkSky => 'Céu totalmente escuro';

  @override
  String get sunDayLength => 'Duração do dia';

  @override
  String durationHm(String hours, String minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get sunNote =>
      'A hora dourada é quando o Sol está a menos de 6° acima do horizonte. A primeira e a última luz acontecem quando ele está 6° abaixo, e o céu fica totalmente escuro quando ele está 18° abaixo. Os horários são calculados para a data que você escolher.';

  @override
  String get sunStaysUp => 'Neste dia o Sol não se põe.';

  @override
  String get sunStaysDown => 'Neste dia o Sol não nasce.';

  @override
  String get solarSystemTitle => 'Sistema Solar';

  @override
  String get starMapTitle => 'Mapa estelar';

  @override
  String get starMapCardHint => 'Estrelas e constelações no seu céu';

  @override
  String get starMapHint =>
      'Arraste para olhar ao redor, faça o gesto de pinça para dar zoom e toque numa estrela ou constelação.';

  @override
  String get starsLabel => 'Estrelas';

  @override
  String get constellationsLabel => 'Constelações';

  @override
  String get starMapFind => 'Encontrar';

  @override
  String get constellationsList => 'Todas as constelações';

  @override
  String magnitudeValue(String value) {
    return 'Magnitude $value';
  }

  @override
  String get starBelowHorizon => 'Abaixo do horizonte neste momento';

  @override
  String get starMapNow => 'Agora';

  @override
  String get starUnnamed => 'Estrela';

  @override
  String get binocularsTitle => 'Guia de binóculos';

  @override
  String get binocularsHint => 'O que procurar com binóculos comuns';

  @override
  String get binocularsIntro =>
      'Segure os binóculos firmes, por exemplo apoiando os cotovelos num muro ou no teto de um carro. Longe das luzes da cidade, procure manchas fracas e difusas, e não estrelas nítidas.';

  @override
  String get binocularsNote =>
      'Os horários mostram quando cada objeto está mais alto durante a parte escura da noite na cidade escolhida. Os nomes dos objetos são os usados no mundo todo. Toque em um para vê-lo no mapa estelar.';

  @override
  String get dsoCluster => 'Aglomerado estelar';

  @override
  String get dsoGalaxy => 'Galáxia';

  @override
  String get dsoNebula => 'Nebulosa';

  @override
  String get storyOri =>
      'Órion, o Caçador, é fácil de achar: três estrelas numa linha reta curta formam o seu cinturão. Acima do cinturão, a alaranjada Betelgeuse marca um ombro; abaixo, a branco-azulada Rigel marca um pé. Sob o cinturão pende uma mancha fraca e difusa, a Nebulosa de Órion, uma nuvem onde nascem novas estrelas. Órion é visto à noite no inverno no norte e no verão no sul.';

  @override
  String get storyUMa =>
      'As sete estrelas brilhantes da Grande Concha, também chamada de Carro ou Big Dipper, fazem parte da Ursa Maior. As duas estrelas da ponta da concha, Dubhe e Merak, apontam o caminho para Polaris: siga a linha para cima por cerca de cinco vezes a distância entre elas. De boa parte do norte, a Grande Concha gira em torno de Polaris a noite toda e nunca se põe.';

  @override
  String get storyUMi =>
      'Polaris, a Estrela do Norte, fica na ponta da cauda da Ursa Menor. Ela quase não se move porque está quase exatamente sobre o polo norte da Terra, e por isso todo o céu parece girar ao seu redor. Sua altura acima do horizonte é igual à sua latitude. Não é uma estrela muito brilhante, mas é a mais útil para achar o norte. Não pode ser vista da metade sul do mundo.';

  @override
  String get storyCas =>
      'Cassiopeia tem a forma de um W ou de um M, conforme a hora e a estação, e é feita de cinco estrelas bem brilhantes. Fica do outro lado de Polaris em relação à Grande Concha, então quando uma está baixa a outra está alta. Na história antiga, ela era uma rainha que se gabava da própria beleza.';

  @override
  String get storyCyg =>
      'O Cisne voa ao longo da Via Láctea. Suas estrelas mais brilhantes formam o Cruzeiro do Norte, com Deneb no alto, a cauda do cisne. Longe das luzes da cidade, a Via Láctea parece um pálido rio de luz atravessando o cisne, e os binóculos mostram que ela é feita de incontáveis estrelas fracas. As noites de verão e outono são as melhores.';

  @override
  String get storySco =>
      'Escorpião parece um escorpião com a cauda curva terminando num ferrão. Seu coração é a vermelha Antares, cujo nome significa rival de Marte, porque as duas se parecem na cor. É uma constelação de verão no norte, baixa no sul, e passa bem alto sobre a cabeça de quem vive na metade sul do mundo.';

  @override
  String get storyLeo =>
      'Leão é uma das poucas constelações que realmente se parece com o seu animal. Um ponto de interrogação invertido de estrelas, a Foice, forma a cabeça e o peito e termina na brilhante Régulo, o coração do leão. O triângulo de estrelas a leste é a parte traseira. As noites de primavera são as melhores no norte.';

  @override
  String get storyTau =>
      'Touro tem um rosto em forma de V, o aglomerado das Híades, com a alaranjada Aldebarã como olho. Aldebarã parece fazer parte do aglomerado, mas está muito mais perto de nós. Mais acima, as Plêiades, ou Sete Irmãs, são um pequeno grupo de estrelas azuis que a maioria das pessoas vê como seis ou sete. As Plêiades são conhecidas no mundo todo e aparecem nas histórias de muitas culturas.';

  @override
  String get storyGem =>
      'Gêmeos é marcado por duas estrelas brilhantes, Castor e Pólux, lado a lado como as cabeças de dois irmãos. Pólux é a mais brilhante e tem um tom alaranjado. Castor é, na verdade, um sistema de seis estrelas. Procure-as no alto do céu nas noites de inverno e primavera no norte.';

  @override
  String get storyLyr =>
      'Lira é pequena, mas abriga Vega, uma das estrelas mais brilhantes do céu do norte. Vega é branco-azulada e, junto com Deneb, em Cisne, e Altair, em Águia, forma o Triângulo de Verão. Bem ao lado de Vega, um pequeno paralelogramo de estrelas forma o corpo da lira.';

  @override
  String get storyCru =>
      'O Cruzeiro do Sul (Crux) é a menor de todas as constelações, mas uma das mais famosas. Quatro estrelas brilhantes formam uma cruz, e as duas estrelas do seu braço mais longo apontam para o polo sul celeste, ajudando os viajantes a achar o sul. Não pode ser vista na maior parte da metade norte do mundo.';
}
