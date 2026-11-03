// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Heliora';

  @override
  String get tagline => 'Исследуйте Солнечную систему, полностью офлайн';

  @override
  String get navExplore => 'Обзор';

  @override
  String get navCompare => 'Сравнение';

  @override
  String get navWeight => 'Вес';

  @override
  String get navQuiz => 'Викторина';

  @override
  String get viewMode => 'Режим просмотра';

  @override
  String get settings => 'Настройки';

  @override
  String get notToScale =>
      'Не в масштабе · Нажмите на планету, чтобы открыть её';

  @override
  String get dragToRotate =>
      'Тяните, чтобы вращать · Сведите пальцы для масштаба';

  @override
  String get planetsTitle => 'Планеты';

  @override
  String get planetMercury => 'Меркурий';

  @override
  String get planetVenus => 'Венера';

  @override
  String get planetEarth => 'Земля';

  @override
  String get planetMars => 'Марс';

  @override
  String get planetJupiter => 'Юпитер';

  @override
  String get planetSaturn => 'Сатурн';

  @override
  String get planetUranus => 'Уран';

  @override
  String get planetNeptune => 'Нептун';

  @override
  String planetOrder(int n) {
    return 'Планета № $n от Солнца';
  }

  @override
  String get openDetails => 'Подробнее';

  @override
  String get diameter => 'Диаметр';

  @override
  String get gravity => 'Гравитация';

  @override
  String get avgTemp => 'Средняя температура';

  @override
  String get avgTempShort => 'Ср. темп.';

  @override
  String get dayLength => 'Сутки';

  @override
  String get yearLength => 'Год';

  @override
  String get moons => 'Известные спутники';

  @override
  String get moonsShort => 'Спутники';

  @override
  String get distance => 'Расстояние от Солнца';

  @override
  String get pressure => 'Давление у поверхности';

  @override
  String get noSurface => 'Нет твёрдой поверхности';

  @override
  String valueKm(String value) {
    return '$value км';
  }

  @override
  String valueMillionKm(String value) {
    return '$value млн км';
  }

  @override
  String valueHours(String value) {
    return '$value ч';
  }

  @override
  String valueDays(String value) {
    return '$value сут';
  }

  @override
  String valueYears(String value) {
    return '$value лет';
  }

  @override
  String get atmosphere => 'Атмосфера';

  @override
  String get thinAtmosphere =>
      'Атмосферы почти нет. Эти газы образуют очень тонкий слой — экзосферу.';

  @override
  String get oxygen => 'Кислород';

  @override
  String get oxygenVsEarth => 'Кислород в сравнении с Землёй';

  @override
  String get breathable => 'Пригодно для дыхания человека';

  @override
  String get notBreathable => 'Дышать нельзя, нужен скафандр';

  @override
  String weightFeelsLike(String weight) {
    return '$weight кг на Земле здесь ощущаются как';
  }

  @override
  String get gasCo2 => 'Углекислый газ';

  @override
  String get gasN2 => 'Азот';

  @override
  String get gasO2 => 'Кислород';

  @override
  String get gasAr => 'Аргон';

  @override
  String get gasH2 => 'Водород';

  @override
  String get gasHe => 'Гелий';

  @override
  String get gasCh4 => 'Метан';

  @override
  String get gasNa => 'Натрий';

  @override
  String get gasK => 'Калий';

  @override
  String get compareTitle => 'Сравнение планет';

  @override
  String get compareHint => 'Выберите две планеты, чтобы сравнить их.';

  @override
  String get weightTitle => 'Ваш вес на других планетах';

  @override
  String get weightInput => 'Ваш вес на Земле (кг)';

  @override
  String gravityTimes(String factor) {
    return '$factor× земной гравитации';
  }

  @override
  String get quizTitle => 'Викторина о планетах';

  @override
  String get quizIntro =>
      '10 вопросов о планетах и спутниках. Сколько правильных ответов вы дадите?';

  @override
  String get quizStart => 'Начать викторину';

  @override
  String quizProgress(int current, int total) {
    return 'Вопрос $current из $total';
  }

  @override
  String get quizNext => 'Далее';

  @override
  String get quizSeeResult => 'Посмотреть результат';

  @override
  String get quizCorrect => 'Верно!';

  @override
  String quizWrong(String answer) {
    return 'Не совсем. Правильный ответ: $answer.';
  }

  @override
  String quizScore(int score, int total) {
    return 'Правильно $score из $total';
  }

  @override
  String quizBest(int score) {
    return 'Лучший результат: $score';
  }

  @override
  String get quizNewBest => 'Новый рекорд!';

  @override
  String get quizAgain => 'Сыграть ещё';

  @override
  String get qLargest => 'Какая планета самая большая?';

  @override
  String get qSmallest => 'Какая планета самая маленькая?';

  @override
  String get qHottest => 'Какая планета самая горячая?';

  @override
  String get qColdest => 'Какая планета самая холодная?';

  @override
  String get qMostMoons => 'У какой планеты больше всего известных спутников?';

  @override
  String get qBreathable => 'На какой планете люди могут дышать воздухом?';

  @override
  String get qClosest => 'Какая планета ближе всего к Солнцу?';

  @override
  String get qFarthest => 'Какая планета дальше всего от Солнца?';

  @override
  String get qStrongestGravity => 'У какой планеты самая сильная гравитация?';

  @override
  String get qShortestDay => 'У какой планеты самые короткие сутки?';

  @override
  String get qLongestDay => 'У какой планеты самые длинные сутки?';

  @override
  String get appearance => 'Оформление';

  @override
  String get theme => 'Тема';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get language => 'Язык';

  @override
  String get appLanguage => 'Язык приложения';

  @override
  String get languageNote => '20 языков · и названия планет';

  @override
  String get phoneLanguage => 'Язык телефона';

  @override
  String get updates => 'Обновления';

  @override
  String get version => 'Версия';

  @override
  String get checkForUpdates => 'Проверить обновления';

  @override
  String get checking => 'Проверка…';

  @override
  String get autoUpdateCheck => 'Проверять автоматически раз в день';

  @override
  String get updateNote =>
      'Обновления приходят из GitHub Releases. Ваши настройки остаются на телефоне.';

  @override
  String get upToDate => 'У вас последняя версия.';

  @override
  String get updateFailed =>
      'Не удалось подключиться к GitHub. Проверьте интернет и попробуйте снова.';

  @override
  String get updateAvailable => 'Доступно обновление';

  @override
  String updateReady(String version) {
    return 'Версия $version готова к загрузке.';
  }

  @override
  String get download => 'Скачать';

  @override
  String get later => 'Позже';

  @override
  String get about => 'О приложении';

  @override
  String get sourceCode => 'Исходный код на GitHub';

  @override
  String get privacyLine => 'Офлайн · Без рекламы · Без отслеживания';

  @override
  String get dataSource => 'Данные: NASA Planetary Fact Sheet';

  @override
  String get openFailed => 'Не удалось открыть ссылку.';

  @override
  String get bodySun => 'Солнце';

  @override
  String get bodyMoon => 'Луна';

  @override
  String get bodyPluto => 'Плутон';

  @override
  String get moonIo => 'Ио';

  @override
  String get moonEuropa => 'Европа';

  @override
  String get moonGanymede => 'Ганимед';

  @override
  String get moonCallisto => 'Каллисто';

  @override
  String get moonTitan => 'Титан';

  @override
  String get moonEnceladus => 'Энцелад';

  @override
  String get moonTriton => 'Тритон';

  @override
  String get kindStar => 'Наша звезда, центр Солнечной системы';

  @override
  String get kindDwarf => 'Карликовая планета';

  @override
  String moonOf(String planet) {
    return 'Спутник: $planet';
  }

  @override
  String get orbitPeriod => 'Один оборот';

  @override
  String distanceFrom(String body) {
    return 'Расстояние до: $body';
  }

  @override
  String get composition => 'Из чего состоит';

  @override
  String get noAtmosphere => 'Настоящей атмосферы нет, почти вакуум.';

  @override
  String get majorMoons => 'Главные спутники';

  @override
  String get lifeTitle => 'Смогут ли здесь жить люди?';

  @override
  String get lifeScoreShort => 'Индекс жизни';

  @override
  String get lifeNote =>
      'Считается по температуре, давлению воздуха, кислороду, воде, поверхности и гравитации. У Земли 10.';

  @override
  String get water => 'Вода';

  @override
  String get waterLiquid => 'Жидкая вода';

  @override
  String get waterIce => 'Лёд';

  @override
  String get waterOcean => 'Океан подо льдом';

  @override
  String get waterNone => 'Воды нет';

  @override
  String get surface => 'Поверхность';

  @override
  String get solidSurface => 'Твёрдая поверхность';

  @override
  String get lifeHome => 'Совсем как дома';

  @override
  String get lifeHard => 'Очень трудно, нужна закрытая база и скафандры';

  @override
  String get lifeNo => 'Невозможно для людей';

  @override
  String get downloadInstall => 'Скачать и установить';

  @override
  String downloadingPercent(String percent) {
    return 'Загрузка… $percent%';
  }

  @override
  String get installNow => 'Установить';

  @override
  String get allowInstalls =>
      'Разрешите Heliora устанавливать приложения на открывшемся экране, затем вернитесь и нажмите «Установить».';

  @override
  String get downloadFailed =>
      'Загрузка не завершилась. Проверьте интернет и попробуйте снова.';

  @override
  String get tryAgain => 'Повторить';

  @override
  String get today => 'Сегодня';

  @override
  String get play => 'Пуск';

  @override
  String get pause => 'Пауза';

  @override
  String get monthBack => 'На 30 дней раньше';

  @override
  String get monthForward => 'На 30 дней позже';

  @override
  String get positionsNote =>
      'Реальные положения на эту дату · Размеры и расстояния не в масштабе · Нажмите на планету';

  @override
  String get navYou => 'Вы';

  @override
  String get ageTitle => 'Ваш возраст на других планетах';

  @override
  String get setBirthDate => 'Укажите дату рождения';

  @override
  String get changeBirthDate => 'Изменить';

  @override
  String nextBirthday(String days) {
    return 'До следующего дня рождения: $days дн.';
  }

  @override
  String get ageNote => 'Дата рождения хранится только на этом телефоне.';

  @override
  String get share => 'Поделиться';

  @override
  String shareText(String planet) {
    return '$planet в Heliora — бесплатное офлайн-приложение о Солнечной системе: https://github.com/lumio-apps/heliora';
  }

  @override
  String get shareFailed => 'Не удалось поделиться картинкой.';

  @override
  String get travelTitle => 'Как далеко?';

  @override
  String get distanceFromEarth => 'Расстояние от Земли сегодня';

  @override
  String get lightTime => 'Свет летит';

  @override
  String get bySpacecraft => 'На корабле со скоростью 60 000 км/ч';

  @override
  String get byCar => 'На машине со скоростью 100 км/ч';

  @override
  String valueSeconds(String value) {
    return '$value с';
  }

  @override
  String valueMinutes(String value) {
    return '$value мин';
  }

  @override
  String get sizeTitle => 'Размер';

  @override
  String sizeTimes(String big, String times, String small) {
    return '$big в $times× шире, чем $small.';
  }

  @override
  String sizeSimilar(String a, String b) {
    return '$a и $b почти одного размера.';
  }

  @override
  String get navSky => 'Небо';

  @override
  String get skyTitle => 'Небо сегодня ночью';

  @override
  String get chooseCity => 'Выберите город';

  @override
  String get chooseCityHint =>
      'Выберите ближайший город, чтобы увидеть Луну и планеты, видимые сегодня ночью. Доступ к геолокации не нужен, выбор хранится только на телефоне.';

  @override
  String get searchCity => 'Найти город';

  @override
  String get noCityFound => 'Город не найден';

  @override
  String get cityNote =>
      'Время указано в часовом поясе телефона. Планета считается видимой, если она хотя бы на 5° над горизонтом в тёмном небе.';

  @override
  String illuminated(String percent) {
    return 'Освещено $percent%';
  }

  @override
  String get moonrise => 'Восход Луны';

  @override
  String get moonset => 'Заход Луны';

  @override
  String get sunset => 'Закат';

  @override
  String get sunrise => 'Восход';

  @override
  String get nextFull => 'Ближайшее полнолуние';

  @override
  String get nextNew => 'Ближайшее новолуние';

  @override
  String get phaseNew => 'Новолуние';

  @override
  String get phaseWaxingCrescent => 'Растущий серп';

  @override
  String get phaseFirstQuarter => 'Первая четверть';

  @override
  String get phaseWaxingGibbous => 'Растущая Луна';

  @override
  String get phaseFull => 'Полнолуние';

  @override
  String get phaseWaningGibbous => 'Убывающая Луна';

  @override
  String get phaseLastQuarter => 'Последняя четверть';

  @override
  String get phaseWaningCrescent => 'Убывающий серп';

  @override
  String get planetsTonight => 'Планеты сегодня ночью';

  @override
  String get statusVisible => 'Видна сегодня ночью';

  @override
  String get statusEvening => 'Вечером, после заката';

  @override
  String get statusMorning => 'Утром, перед восходом';

  @override
  String get statusNotVisible => 'Сегодня не видна';

  @override
  String bestAt(String time) {
    return 'Лучше всего в $time';
  }

  @override
  String altitudeDir(String direction, String degrees) {
    return '$direction, высота $degrees°';
  }

  @override
  String riseSet(String rise, String set) {
    return 'Восход $rise · Заход $set';
  }

  @override
  String get needsTelescope => 'Нужен бинокль или телескоп';

  @override
  String get dirN => 'Север';

  @override
  String get dirNE => 'Северо-восток';

  @override
  String get dirE => 'Восток';

  @override
  String get dirSE => 'Юго-восток';

  @override
  String get dirS => 'Юг';

  @override
  String get dirSW => 'Юго-запад';

  @override
  String get dirW => 'Запад';

  @override
  String get dirNW => 'Северо-запад';

  @override
  String get findPlanet => 'Найти в небе';

  @override
  String finderTitle(String name) {
    return 'Найти: $name';
  }

  @override
  String get pointPhone => 'Поднимите телефон и медленно водите им.';

  @override
  String turnRight(String degrees) {
    return 'Повернитесь вправо на $degrees°';
  }

  @override
  String turnLeft(String degrees) {
    return 'Повернитесь влево на $degrees°';
  }

  @override
  String tiltUp(String degrees) {
    return 'Наклоните вверх на $degrees°';
  }

  @override
  String tiltDown(String degrees) {
    return 'Наклоните вниз на $degrees°';
  }

  @override
  String onTarget(String name) {
    return '$name прямо там!';
  }

  @override
  String belowHorizon(String name) {
    return '$name сейчас под горизонтом.';
  }

  @override
  String risesAt(String time) {
    return 'Восход в $time.';
  }

  @override
  String get noSensor =>
      'В этом телефоне нет датчика компаса, поэтому поиск не работает.';

  @override
  String get calibrate =>
      'Компас нужно откалибровать: несколько раз нарисуйте телефоном восьмёрку.';

  @override
  String get phoneNow => 'Телефон направлен на';

  @override
  String get finderNote =>
      'Держите телефон задней стороной к небу, вдали от магнитов и металла. Никогда не смотрите на Солнце.';

  @override
  String get eventsTitle => 'Космические события';

  @override
  String get eventsSubtitle => 'Что смотреть в небе в ближайшие 12 месяцев.';

  @override
  String eventsNext(String event, String when) {
    return 'Далее: $event · $when';
  }

  @override
  String get eventFullMoon => 'Полнолуние';

  @override
  String get eventNewMoon => 'Новолуние';

  @override
  String eventOpposition(String planet) {
    return '$planet в противостоянии';
  }

  @override
  String eventEveningElongation(String planet) {
    return '$planet: лучшее время вечером';
  }

  @override
  String eventMorningElongation(String planet) {
    return '$planet: лучшее время утром';
  }

  @override
  String eventConjunction(String a, String b) {
    return '$a и $b сближаются';
  }

  @override
  String get eventMarchEquinox => 'Мартовское равноденствие';

  @override
  String get eventJuneSolstice => 'Июньское солнцестояние';

  @override
  String get eventSeptemberEquinox => 'Сентябрьское равноденствие';

  @override
  String get eventDecemberSolstice => 'Декабрьское солнцестояние';

  @override
  String get eventFullMoonDesc =>
      'Луна освещена целиком. Она восходит около заката.';

  @override
  String get eventNewMoonDesc =>
      'Луны не видно. Самое тёмное небо месяца для звёзд и планет.';

  @override
  String eventOppositionDesc(String planet) {
    return '$planet находится напротив Солнца. Это самый яркий момент года, планета видна всю ночь.';
  }

  @override
  String eventEveningDesc(String planet, String degrees) {
    return '$planet в $degrees° от Солнца, это максимальное удаление. Смотрите низко на западе после заката.';
  }

  @override
  String eventMorningDesc(String planet, String degrees) {
    return '$planet в $degrees° от Солнца, это максимальное удаление. Смотрите низко на востоке перед рассветом.';
  }

  @override
  String eventConjunctionDesc(String degrees) {
    return 'Они пройдут всего в $degrees° друг от друга.';
  }

  @override
  String get eventEquinoxDesc => 'Во всём мире день и ночь почти равны.';

  @override
  String get eventJuneSolsticeDesc =>
      'Самый длинный день на севере, самый короткий на юге.';

  @override
  String get eventDecemberSolsticeDesc =>
      'Самый короткий день на севере, самый длинный на юге.';

  @override
  String eventMeteorShower(String shower) {
    return 'Метеорный поток $shower';
  }

  @override
  String eventMeteorDesc(String rate, String percent) {
    return 'До $rate метеоров в час под тёмным небом. Луна будет освещена на $percent%.';
  }

  @override
  String get showerQuadrantids => 'Квадрантиды';

  @override
  String get showerLyrids => 'Лириды';

  @override
  String get showerEtaAquariids => 'Эта-Акварииды';

  @override
  String get showerPerseids => 'Персеиды';

  @override
  String get showerOrionids => 'Ориониды';

  @override
  String get showerLeonids => 'Леониды';

  @override
  String get showerGeminids => 'Геминиды';

  @override
  String get showerUrsids => 'Урсиды';

  @override
  String get eventToday => 'Сегодня';

  @override
  String get eventTomorrow => 'Завтра';

  @override
  String eventInDays(String days) {
    return 'Через $days дн.';
  }

  @override
  String get eventsNote =>
      'Даты рассчитываются на вашем телефоне и показываются в его часовом поясе. Максимумы метеорных потоков — обычные даты каждого года, возможен сдвиг на день. Напоминания хранятся только на телефоне.';

  @override
  String get remindMe => 'Напомнить';

  @override
  String reminderSet(String date) {
    return 'Хорошо, напомню $date.';
  }

  @override
  String get reminderOff => 'Напоминание удалено.';

  @override
  String get reminderTooLate =>
      'Событие слишком близко, чтобы поставить напоминание.';

  @override
  String get notificationsOff =>
      'Уведомления Heliora отключены. Включите их в настройках Android.';

  @override
  String get reminderTomorrow => 'Будет завтра';

  @override
  String get reminderToday => 'Происходит сегодня';

  @override
  String get onlineTitle => 'Онлайн-функции';

  @override
  String get onlineSubtitle =>
      'Показывать космическую станцию и запуски ракет. Тогда Heliora обращается только к wheretheiss.at, Celestrak и Launch Library 2, которые видят интернет-адрес вашего телефона. Больше ничего не отправляется. По умолчанию выключено.';

  @override
  String get turnOnOnline => 'Включить онлайн-функции';

  @override
  String get issTitle => 'Космическая станция';

  @override
  String get issCardHint => 'Где она сейчас и когда пролетит над вами';

  @override
  String get issNeedsOnline =>
      'Чтобы показать станцию, Heliora нужны данные её орбиты из интернета. Они скачиваются один раз и потом работают офлайн несколько дней.';

  @override
  String get issLoading => 'Загрузка данных орбиты…';

  @override
  String get issFailed =>
      'Не удалось получить данные орбиты. Проверьте интернет и попробуйте снова.';

  @override
  String issStale(String days) {
    return 'Данным орбиты $days дн., поэтому положение может быть неточным. Подключитесь к интернету, чтобы обновить.';
  }

  @override
  String get issHeight => 'Высота';

  @override
  String get issSpeed => 'Скорость';

  @override
  String get issFromYou => 'Расстояние до вас';

  @override
  String valueKmh(String value) {
    return '$value км/ч';
  }

  @override
  String issAboveHorizon(String direction, String degrees) {
    return 'Сейчас над вашим горизонтом! Смотрите на $direction, высота $degrees°.';
  }

  @override
  String get issBelowHorizon => 'Сейчас под вашим горизонтом.';

  @override
  String issPassesTitle(String city) {
    return 'Ближайшие пролёты над: $city';
  }

  @override
  String get issNoPasses => 'В ближайшие 5 дней хороших пролётов нет.';

  @override
  String issMaxHigh(String degrees) {
    return 'До $degrees° над горизонтом';
  }

  @override
  String issFromTo(String start, String end) {
    return 'От $start до $end';
  }

  @override
  String get issVisible => 'Хорошо видна';

  @override
  String get issHidden => 'Плохо видна';

  @override
  String get issPassTitle => 'Космическая станция пролетает над вами';

  @override
  String issPassBody(String degrees, String direction) {
    return 'Появится через 10 минут, до $degrees° над горизонтом. Смотрите на $direction.';
  }

  @override
  String get issNote =>
      'Положение считается на вашем телефоне по данным орбиты станции. Пролёт хорошо виден, когда небо тёмное, а станцию освещает Солнце: она похожа на яркую быструю звезду.';

  @override
  String get launchesNeedOnline =>
      'Включите онлайн-функции, чтобы видеть здесь ближайшие запуски ракет.';

  @override
  String get launchesFailed =>
      'Не удалось обновить список запусков. Показан сохранённый список.';

  @override
  String get launchesNote =>
      'Время запусков берётся из Launch Library 2 и часто меняется. Названия и места указаны по-английски.';

  @override
  String get launchReminderBody =>
      'Старт примерно через час. Время может измениться.';

  @override
  String get launchTimeTbd => 'Время ещё не назначено';

  @override
  String get quizChoose => 'Выберите уровень';

  @override
  String get levelEasy => 'Лёгкий';

  @override
  String get levelMedium => 'Средний';

  @override
  String get levelHard => 'Сложный';

  @override
  String get levelEasyHint => 'Основы о планетах';

  @override
  String get levelMediumHint => 'Планеты и спутники';

  @override
  String get levelHardHint => 'Хитрые сравнения и рейтинги';

  @override
  String get qStar => 'Что из этого звезда, а не планета?';

  @override
  String get qDwarf => 'Что из этого карликовая планета?';

  @override
  String get qMoonVisited => 'По какому спутнику ходили люди?';

  @override
  String get qLargestMoon => 'Какой из этих спутников самый большой?';

  @override
  String get qSmallestMoon => 'Какой из этих спутников самый маленький?';

  @override
  String get qThickAirMoon => 'У какого из этих спутников плотная атмосфера?';

  @override
  String get qGeyserMoon => 'Какой спутник выбрасывает в космос гейзеры воды?';

  @override
  String get qVolcanicMoon =>
      'На каком спутнике больше всего действующих вулканов?';

  @override
  String get qBackwardsMoon =>
      'Какой спутник обращается вокруг своей планеты в обратную сторону?';

  @override
  String get qBiggestRocky => 'Какая из четырёх каменных планет самая большая?';

  @override
  String get qColdestRocky =>
      'Какая из четырёх каменных планет самая холодная?';

  @override
  String get qHighestPressure =>
      'У какой планеты самое высокое давление воздуха на поверхности?';

  @override
  String get qSecondLargest => 'Какая планета вторая по размеру?';

  @override
  String get qLongestYear => 'У какой планеты самый длинный год?';

  @override
  String get qShortestYear => 'У какой планеты самый короткий год?';

  @override
  String get qSmallestGiant =>
      'Какая из четырёх планет-гигантов самая маленькая?';

  @override
  String get qRockyLongestYear =>
      'У какой из четырёх каменных планет самый длинный год?';

  @override
  String get qFastestMoon =>
      'Какой из этих спутников быстрее всех обращается вокруг своей планеты?';

  @override
  String get qSlowestMoon =>
      'Какому из этих спутников нужно больше всего времени, чтобы обойти свою планету?';

  @override
  String get qStrongestMoonGravity =>
      'У какого из этих спутников самая сильная гравитация?';

  @override
  String get qColdestMoon => 'Какой из этих спутников самый холодный?';

  @override
  String get qSecondLargestMoon => 'Какой из этих спутников второй по размеру?';

  @override
  String get factTitle => 'Знаете ли вы?';

  @override
  String get factTap => 'Нажмите, чтобы увидеть другой факт';

  @override
  String get factSun1 =>
      'В Солнце сосредоточено 99,8% всей массы Солнечной системы.';

  @override
  String get factSun2 =>
      'Свету от Солнца нужно около 8 минут 20 секунд, чтобы дойти до Земли.';

  @override
  String get factMercury1 =>
      'Сутки на Меркурии, от одного восхода до следующего, длятся около 176 земных суток. Это вдвое дольше его года.';

  @override
  String get factMercury2 =>
      'На Меркурии почти нет воздуха, поэтому небо там чёрное даже днём, а ночи ледяные.';

  @override
  String get factVenus1 =>
      'Венера вращается в обратную сторону, поэтому на Венере Солнце встаёт на западе.';

  @override
  String get factVenus2 =>
      'Венера горячее Меркурия, хотя дальше от Солнца, потому что её плотная атмосфера удерживает тепло.';

  @override
  String get factEarth1 =>
      'Земля — единственное известное нам место с жизнью, и около 71% её поверхности покрыто водой.';

  @override
  String get factEarth2 =>
      'Земля не идеальный шар. Из-за вращения она немного вздута у экватора.';

  @override
  String get factMars1 =>
      'Гора Олимп на Марсе — самый высокий вулкан Солнечной системы, примерно в два с половиной раза выше Эвереста.';

  @override
  String get factMars2 => 'Закаты на Марсе выглядят голубыми.';

  @override
  String get factJupiter1 =>
      'Масса Юпитера больше чем вдвое превышает массу всех остальных планет вместе взятых.';

  @override
  String get factJupiter2 =>
      'Большое красное пятно — буря больше Земли, за которой люди наблюдают более 150 лет.';

  @override
  String get factSaturn1 =>
      'Сатурн для своего размера так лёгок, что плавал бы в воде, найдись достаточно большая ванна.';

  @override
  String get factSaturn2 =>
      'Кольца Сатурна очень широкие, но очень тонкие: местами всего около десяти метров толщиной.';

  @override
  String get factUranus1 =>
      'Уран катится вокруг Солнца на боку, его ось наклонена примерно на 98 градусов.';

  @override
  String get factUranus2 =>
      'Уран — первая планета, открытая с помощью телескопа. Уильям Гершель обнаружил её в 1781 году.';

  @override
  String get factNeptune1 =>
      'На Нептуне самые быстрые ветры среди планет: более 2000 км/ч.';

  @override
  String get factNeptune2 =>
      'Нептун нашли с помощью математики ещё до того, как его увидели: в 1846 году астрономы вычислили, где он должен быть.';

  @override
  String get factMoon1 =>
      'Луна удаляется от Земли примерно на 3,8 сантиметра каждый год.';

  @override
  String get factMoon2 =>
      'Мы всегда видим одну и ту же сторону Луны, потому что она делает ровно один оборот вокруг оси за каждый оборот вокруг Земли.';

  @override
  String get factPluto1 => 'Год на Плутоне длится около 248 земных лет.';

  @override
  String get factPluto2 =>
      'На Плутоне есть огромная равнина в форме сердца из замёрзшего азота.';

  @override
  String get factIo1 =>
      'Ио — самый вулканический из известных нам миров, на нём сотни действующих вулканов.';

  @override
  String get factIo2 =>
      'Гравитация Юпитера то сжимает, то растягивает Ио, и выделяющееся тепло питает его вулканы.';

  @override
  String get factEuropa1 =>
      'Под ледяной коркой на Европе, вероятно, примерно вдвое больше воды, чем во всех океанах Земли.';

  @override
  String get factEuropa2 =>
      'Европа — одно из лучших мест для поиска жизни за пределами Земли. К ней летит аппарат «Европа Клипер».';

  @override
  String get factGanymede1 =>
      'Ганимед — самый большой спутник в Солнечной системе. Он даже больше Меркурия.';

  @override
  String get factGanymede2 =>
      'Ганимед — единственный известный спутник с собственным магнитным полем.';

  @override
  String get factCallisto1 =>
      'Каллисто — одно из самых изрытых кратерами мест Солнечной системы, а её поверхность очень древняя.';

  @override
  String get factCallisto2 =>
      'Каллисто достаточно далеко от Юпитера, чтобы получать меньше его жёсткого излучения, поэтому учёные предлагали разместить на ней будущую базу.';

  @override
  String get factTitan1 =>
      'Титан — единственный спутник с плотной атмосферой. Давление воздуха на его поверхности выше, чем на Земле.';

  @override
  String get factTitan2 =>
      'На Титане есть реки и озёра, но в них жидкие метан и этан, а не вода.';

  @override
  String get factEnceladus1 =>
      'Энцелад выбрасывает в космос струи льда и водяного пара через трещины возле южного полюса.';

  @override
  String get factEnceladus2 => 'Струи Энцелада пополняют кольцо E Сатурна.';

  @override
  String get factTriton1 =>
      'Тритон обращается вокруг Нептуна в обратную сторону, так что, вероятно, это карликовая планета, захваченная Нептуном.';

  @override
  String get factTriton2 =>
      'При температуре около −235 °C Тритон — одно из самых холодных мест Солнечной системы, где измеряли температуру.';

  @override
  String get jumpInput => 'Высота вашего прыжка на Земле (см)';

  @override
  String jumpHigh(String height) {
    return 'Прыжок: $height';
  }

  @override
  String jumpFeelsLike(String height) {
    return 'Прыжок на $height на Земле превращается в';
  }

  @override
  String get jumpNote =>
      'Толчок такой же, как на Земле. На Солнце и газовых гигантах нет твёрдой поверхности, чтобы встать, так что это просто игра воображения.';

  @override
  String valueCm(String value) {
    return '$value см';
  }

  @override
  String valueM(String value) {
    return '$value м';
  }

  @override
  String get eclipseTotalLunar => 'Полное лунное затмение';

  @override
  String get eclipsePartialLunar => 'Частное лунное затмение';

  @override
  String get eclipsePenumbralLunar => 'Полутеневое лунное затмение';

  @override
  String get eclipseTotalSolar => 'Полное солнечное затмение';

  @override
  String get eclipseAnnularSolar => 'Кольцеобразное солнечное затмение';

  @override
  String get eclipseHybridSolar => 'Гибридное солнечное затмение';

  @override
  String get eclipsePartialSolar => 'Частное солнечное затмение';

  @override
  String get eclipseTotalLunarDesc =>
      'Луна целиком уходит в тень Земли и часто становится тускло-красной. Её видят все на ночной стороне Земли, и смотреть на неё невооружённым глазом безопасно.';

  @override
  String eclipsePartialLunarDesc(String percent) {
    return 'Часть Луны ($percent% её ширины) заходит в тёмную тень Земли. Смотреть невооружённым глазом безопасно.';
  }

  @override
  String get eclipsePenumbralLunarDesc =>
      'Луна проходит через слабую внешнюю тень Земли. Она лишь слегка тускнеет, поэтому заметить это трудно.';

  @override
  String get eclipseTotalSolarDesc =>
      'Луна полностью закрывает Солнце вдоль узкой полосы на Земле. Вне этой полосы видно частное затмение.';

  @override
  String get eclipseAnnularSolarDesc =>
      'Луна чуть дальше, чем нужно, чтобы закрыть Солнце целиком, поэтому остаётся яркое кольцо. Кольцо видно вдоль узкой полосы; вне её затмение частное.';

  @override
  String get eclipseHybridSolarDesc =>
      'Вдоль своей полосы это затмение в одних местах полное, а в других кольцеобразное. Вне полосы оно частное.';

  @override
  String get eclipsePartialSolarDesc =>
      'Луна закрывает только часть Солнца, и нигде на Земле Солнце не закрыто полностью.';

  @override
  String get eclipseNoCity =>
      'Выберите город в Heliora, чтобы узнать, можно ли наблюдать затмение оттуда.';

  @override
  String eclipseLunarUp(String city) {
    return 'В середине затмения Луна над горизонтом в городе $city.';
  }

  @override
  String eclipseLunarPartly(String city) {
    return 'В городе $city Луна над горизонтом лишь часть затмения.';
  }

  @override
  String eclipseLunarDown(String city) {
    return 'В городе $city Луна остаётся под горизонтом, поэтому оттуда затмение не видно.';
  }

  @override
  String eclipseSolarNone(String city) {
    return 'Из города $city не видно: тень Луны туда не попадает или Солнце под горизонтом.';
  }

  @override
  String eclipseSolarSlight(String city) {
    return 'Из города $city в лучшем случае очень слабое частное затмение, его трудно заметить.';
  }

  @override
  String eclipseSolarPartial(String city, String percent) {
    return 'Грубая оценка для города $city: Луна закрывает в лучшем случае около $percent% ширины Солнца.';
  }

  @override
  String eclipseSolarNear(String city) {
    return 'Город $city рядом с полосой, где Солнце закрыто почти или полностью. Посмотрите карту затмения; эта оценка грубая.';
  }

  @override
  String get eclipseSolarSafety =>
      'Никогда не смотрите на Солнце без специальных очков для затмений.';

  @override
  String get alertsTitle => 'Уведомления';

  @override
  String get tonightAlertSwitch => 'Небо сегодня вечером, каждый день';

  @override
  String get tonightAlertTime => 'Время';

  @override
  String get tonightAlertNote =>
      'Короткая заметка о Луне и планетах, которые можно увидеть, в выбранное вами время. Она считается на телефоне, интернет не нужен. Android позволяет Heliora подготовить заметки только примерно на две недели вперёд, поэтому время от времени открывайте приложение.';

  @override
  String get tonightNotifTitle => 'Небо сегодня вечером';

  @override
  String tonightMoon(String phase, String percent) {
    return 'Луна: $phase, освещено $percent%.';
  }

  @override
  String tonightPlanets(String planets) {
    return 'Поищите: $planets.';
  }

  @override
  String get tonightNoPlanets => 'В вечернем небе нет ярких планет.';

  @override
  String get tonightNoCity =>
      'Выберите город в Heliora, чтобы увидеть планеты.';

  @override
  String get birthdayTitle => 'Небо в мой день рождения';

  @override
  String get birthdaySubtitle =>
      'Луна и планеты в день вашего рождения и важные дни вашей жизни.';

  @override
  String get birthdayCardHint => 'Фаза Луны, планеты и вехи';

  @override
  String get birthdayNeedDate => 'Укажите дату рождения';

  @override
  String get birthdayMoon => 'Луна в ваш день рождения';

  @override
  String get birthdayPlanets => 'Планеты в тот день';

  @override
  String birthdayDaysOld(String count) {
    return 'Сегодня вам $count дн.';
  }

  @override
  String get birthdayMilestones => 'Вехи';

  @override
  String birthdayDayN(String count) {
    return 'День $count';
  }

  @override
  String get birthdayBillion => '1 миллиард секунд';

  @override
  String get birthdayPassed => 'Прошло';

  @override
  String get birthdayNote =>
      'Считается на вашем телефоне по тем же орбитам, что и всё остальное в Heliora. Дата рождения не покидает телефон.';

  @override
  String get missionsTitle => 'Космические миссии';

  @override
  String get missionsSubtitle =>
      'Знаменитые моменты освоения космоса, от самых давних к недавним.';

  @override
  String get missionsCardHint => 'Знаменитые миссии разных лет';

  @override
  String get missionSputnik1 =>
      'Первый искусственный спутник. Этот металлический шар размером с пляжный мяч около трёх месяцев летал вокруг Земли. Его писк можно было услышать по радио, и с него началась космическая эра.';

  @override
  String get missionVostok1 =>
      'Юрий Гагарин стал первым человеком в космосе. Он облетел Землю один раз примерно за 108 минут.';

  @override
  String get missionApollo11 =>
      'Нил Армстронг и Базз Олдрин сели в Море Спокойствия и стали первыми людьми, прошедшими по Луне. Майкл Коллинз ждал их на орбите.';

  @override
  String get missionVenera7 =>
      'Первый аппарат, севший на другую планету и передавший сигнал. Он присылал данные с Венеры около 23 минут в сокрушительной жаре.';

  @override
  String get missionViking1 =>
      'Он сел на Марс и проработал там больше шести лет, передав первую длинную серию снимков и сводок погоды с поверхности другой планеты.';

  @override
  String get missionVoyager1 =>
      'Запущенный в 1977 году, он пролетел мимо Юпитера и Сатурна и в 2012 году вошёл в межзвёздное пространство. Это самый далёкий от Земли рукотворный объект.';

  @override
  String get missionHubble =>
      'Запущенный в 1990 году, он смотрит на Вселенную из-за пределов земной атмосферы. Его чёткие снимки помогли измерить возраст Вселенной и показали тысячи далёких галактик.';

  @override
  String get missionHuygens =>
      'Зонд «Гюйгенс», доставленный «Кассини», спустился на парашюте на Титан, спутник Сатурна. Это была первая посадка во внешней части Солнечной системы, и он передал снимки с поверхности.';

  @override
  String get missionCuriosity =>
      'Этот ровер размером с автомобиль сел в кратере Гейла с помощью ракетного «небесного крана». Он выяснил, что на Марсе когда-то были условия, подходящие для жизни.';

  @override
  String get missionMangalyaan =>
      'Индийская миссия «Мангальян» вышла на орбиту Марса с первой попытки, что не удавалось ни одной стране, и при очень малых затратах.';

  @override
  String get missionRosetta =>
      'Посадочный модуль «Филы» миссии «Розетта» сел на комету 67P/Чурюмова — Герасименко: первая посадка на комету. Сама «Розетта» два года летала вокруг кометы.';

  @override
  String get missionNewhorizons =>
      'После девятилетнего пути он пролетел мимо Плутона и впервые показал нам ледяные горы и огромную равнину в форме сердца.';

  @override
  String get missionPerseverance =>
      'Ровер «Персеверанс» сел в кратере Езеро, чтобы искать следы древней жизни и собирать образцы пород. Его вертолёт «Индженьюити» совершил первый управляемый полёт на другой планете.';

  @override
  String get missionJwst =>
      'Самый большой космический телескоп с золотым зеркалом в 6,5 метра смотрит на небо в инфракрасном свете с расстояния 1,5 миллиона км. Он видит некоторые из первых галактик.';

  @override
  String get missionChandrayaan3 =>
      'Индия стала четвёртой страной, мягко севшей на Луну, и первой у её южного полюса. Посадочный модуль «Викрам» нёс ровер «Прагъян».';

  @override
  String get spacecraftTitle => 'Космические аппараты сейчас';

  @override
  String get spacecraftSubtitle =>
      'Как далеко от Земли находятся сейчас некоторые известные космические аппараты.';

  @override
  String get spacecraftCardHint => '«Вояджеры», JWST, марсоходы и другие';

  @override
  String get spacecraftDistance => 'Расстояние до Земли';

  @override
  String get spacecraftAltitude => 'Высота над Землёй';

  @override
  String get spacecraftInAu => 'В астрономических единицах';

  @override
  String get spacecraftSpeed => 'Скорость';

  @override
  String get spacecraftSignal => 'Радиосигнал идёт';

  @override
  String get spacecraftNote =>
      'Расстояния приблизительные. Для далёких зондов они рассчитаны по средней скорости и могут отличаться примерно на 1 %, потому что Земля движется вокруг Солнца. Расстояние до Марса рассчитано на сегодня. Одна а. е. (астрономическая единица) — это расстояние от Земли до Солнца.';

  @override
  String valueBillionKm(String value) {
    return '$value млрд км';
  }

  @override
  String valueAu(String value) {
    return '$value а. е.';
  }

  @override
  String valueKmS(String value) {
    return '$value км/с';
  }

  @override
  String get spacecraftVoyager1 =>
      'Запущен в 1977 году. В 2012 году стал первым аппаратом, вошедшим в межзвёздное пространство. Его радиосигнал доходит до нас уже примерно суточной давности.';

  @override
  String get spacecraftVoyager2 =>
      'Запущен в 1977 году. Единственный аппарат, побывавший у Урана и Нептуна. В 2018 году вошёл в межзвёздное пространство.';

  @override
  String get spacecraftNewHorizons =>
      'Пролетел мимо Плутона в 2015 году и мимо объекта пояса Койпера Аррокот в 2019 году. Он всё ещё летит наружу и всё ещё присылает данные.';

  @override
  String get spacecraftJwst =>
      'Самый большой космический телескоп, запущен в 2021 году. Находится возле точки L2, примерно в 1,5 млн км от Земли, а его солнечный экран всегда повёрнут к Солнцу.';

  @override
  String get spacecraftIss =>
      'Облетает Землю примерно каждые 90 минут. С 2000 года на борту без перерыва живут люди.';

  @override
  String get spacecraftHubble =>
      'Запущен в 1990 году и всё ещё работает. Он обращается вокруг Земли выше воздуха, который размывает изображение, поэтому его снимки очень чёткие.';

  @override
  String get spacecraftMarsRovers =>
      '«Кьюриосити» (сел в 2012 году) и «Персеверанс» (сел в 2021 году) ездят по Марсу. Расстояние до Марса меняется примерно от 55 млн км до более чем 400 млн км.';

  @override
  String get searchTooltip => 'Поиск';

  @override
  String get searchHint => 'Ищите планеты, спутники, миссии…';

  @override
  String get searchClear => 'Очистить';

  @override
  String searchEmpty(String query) {
    return 'По запросу «$query» ничего не найдено.';
  }

  @override
  String get searchBodies => 'Планеты и спутники';

  @override
  String get searchMissions => 'Миссии';

  @override
  String get searchSpacecraft => 'Космические аппараты';

  @override
  String get favoritesTitle => 'Избранное';

  @override
  String get favoritesEmpty =>
      'Нажмите на звёздочку у планеты, миссии или аппарата, и он останется здесь.';

  @override
  String get favoriteAdd => 'Добавить в избранное';

  @override
  String get favoriteRemove => 'Убрать из избранного';

  @override
  String get textSize => 'Размер текста';

  @override
  String get textSizeNormal => 'Обычный';

  @override
  String get textSizeLarge => 'Крупный';

  @override
  String get textSizeLarger => 'Ещё крупнее';

  @override
  String get textSizeNote =>
      'Увеличивает текст в Heliora. Он никогда не становится меньше размера текста, заданного в самом телефоне.';

  @override
  String get skyOtherNight => 'Ночное небо';

  @override
  String get planetsThatNight => 'Планеты в ту ночь';

  @override
  String get previousDay => 'Предыдущий день';

  @override
  String get nextDay => 'Следующий день';

  @override
  String get pickDate => 'Выбрать дату';

  @override
  String get backToTonight => 'Вернуться к сегодняшней ночи';

  @override
  String get moonCalendar => 'Лунный календарь';

  @override
  String get moonCalendarHint => 'Фаза Луны на каждый день';

  @override
  String get previousMonth => 'Предыдущий месяц';

  @override
  String get nextMonth => 'Следующий месяц';

  @override
  String get keyMoonDates => 'Главные фазы этого месяца';

  @override
  String get moonCalendarNote =>
      'Даты и время фаз показаны по часовому поясу вашего телефона и точны примерно до часа.';

  @override
  String get seeSkyThatDay => 'Посмотреть небо в этот день';

  @override
  String get sunLightTitle => 'Солнце и свет';

  @override
  String get firstLight => 'Первый свет';

  @override
  String get goldenMorningEnds => 'Конец утреннего золотого часа';

  @override
  String get solarNoon => 'Солнечный полдень';

  @override
  String get goldenEveningStarts => 'Начало вечернего золотого часа';

  @override
  String get lastLight => 'Последний свет';

  @override
  String get darkSky => 'Полностью тёмное небо';

  @override
  String get sunDayLength => 'Длина дня';

  @override
  String durationHm(String hours, String minutes) {
    return '$hours ч $minutes мин';
  }

  @override
  String get sunNote =>
      'Золотой час — это когда Солнце ниже 6° над горизонтом. Первый и последний свет бывают, когда оно на 6° под горизонтом, а небо полностью темнеет, когда оно на 18° ниже. Время рассчитано для выбранной даты.';

  @override
  String get sunStaysUp => 'В этот день Солнце не заходит.';

  @override
  String get sunStaysDown => 'В этот день Солнце не восходит.';

  @override
  String get solarSystemTitle => 'Солнечная система';
}
