// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Heliora';

  @override
  String get tagline => 'Jelajahi Tata Surya, sepenuhnya offline';

  @override
  String get navExplore => 'Jelajahi';

  @override
  String get navCompare => 'Bandingkan';

  @override
  String get navWeight => 'Berat';

  @override
  String get navQuiz => 'Kuis';

  @override
  String get viewMode => 'Mode tampilan';

  @override
  String get settings => 'Setelan';

  @override
  String get notToScale => 'Tidak sesuai skala · Ketuk planet untuk membukanya';

  @override
  String get dragToRotate => 'Seret untuk memutar · Cubit untuk zoom';

  @override
  String get planetsTitle => 'Planet';

  @override
  String get planetMercury => 'Merkurius';

  @override
  String get planetVenus => 'Venus';

  @override
  String get planetEarth => 'Bumi';

  @override
  String get planetMars => 'Mars';

  @override
  String get planetJupiter => 'Jupiter';

  @override
  String get planetSaturn => 'Saturnus';

  @override
  String get planetUranus => 'Uranus';

  @override
  String get planetNeptune => 'Neptunus';

  @override
  String planetOrder(int n) {
    return 'Planet ke-$n dari Matahari';
  }

  @override
  String get openDetails => 'Buka detail';

  @override
  String get diameter => 'Diameter';

  @override
  String get gravity => 'Gravitasi';

  @override
  String get avgTemp => 'Suhu rata-rata';

  @override
  String get avgTempShort => 'Suhu rata-rata';

  @override
  String get dayLength => 'Hari';

  @override
  String get yearLength => 'Tahun';

  @override
  String get moons => 'Bulan yang diketahui';

  @override
  String get moonsShort => 'Bulan';

  @override
  String get distance => 'Jarak dari Matahari';

  @override
  String get pressure => 'Tekanan permukaan';

  @override
  String get noSurface => 'Tidak ada permukaan padat';

  @override
  String valueKm(String value) {
    return '$value km';
  }

  @override
  String valueMillionKm(String value) {
    return '$value juta km';
  }

  @override
  String valueHours(String value) {
    return '$value jam';
  }

  @override
  String valueDays(String value) {
    return '$value hari';
  }

  @override
  String valueYears(String value) {
    return '$value tahun';
  }

  @override
  String get atmosphere => 'Atmosfer';

  @override
  String get thinAtmosphere =>
      'Hampir tidak ada atmosfer. Gas-gas ini membentuk lapisan sangat tipis yang disebut eksosfer.';

  @override
  String get oxygen => 'Oksigen';

  @override
  String get oxygenVsEarth => 'Oksigen dibanding Bumi';

  @override
  String get breathable => 'Bisa dihirup manusia';

  @override
  String get notBreathable => 'Tidak bisa dihirup, perlu baju antariksa';

  @override
  String weightFeelsLike(String weight) {
    return '$weight kg di Bumi di sini terasa';
  }

  @override
  String get gasCo2 => 'Karbon dioksida';

  @override
  String get gasN2 => 'Nitrogen';

  @override
  String get gasO2 => 'Oksigen';

  @override
  String get gasAr => 'Argon';

  @override
  String get gasH2 => 'Hidrogen';

  @override
  String get gasHe => 'Helium';

  @override
  String get gasCh4 => 'Metana';

  @override
  String get gasNa => 'Natrium';

  @override
  String get gasK => 'Kalium';

  @override
  String get compareTitle => 'Bandingkan planet';

  @override
  String get compareHint => 'Pilih dua planet untuk dilihat berdampingan.';

  @override
  String get weightTitle => 'Berat Anda di planet lain';

  @override
  String get weightInput => 'Berat Anda di Bumi (kg)';

  @override
  String gravityTimes(String factor) {
    return '$factor× gravitasi Bumi';
  }

  @override
  String get quizTitle => 'Kuis planet';

  @override
  String get quizIntro =>
      '10 pertanyaan tentang planet dan bulan. Berapa yang bisa kamu jawab benar?';

  @override
  String get quizStart => 'Mulai kuis';

  @override
  String quizProgress(int current, int total) {
    return 'Pertanyaan $current dari $total';
  }

  @override
  String get quizNext => 'Berikutnya';

  @override
  String get quizSeeResult => 'Lihat hasil';

  @override
  String get quizCorrect => 'Benar!';

  @override
  String quizWrong(String answer) {
    return 'Belum tepat. Jawabannya $answer.';
  }

  @override
  String quizScore(int score, int total) {
    return 'Anda benar $score dari $total';
  }

  @override
  String quizBest(int score) {
    return 'Skor terbaik: $score';
  }

  @override
  String get quizNewBest => 'Skor terbaik baru!';

  @override
  String get quizAgain => 'Main lagi';

  @override
  String get qLargest => 'Planet mana yang terbesar?';

  @override
  String get qSmallest => 'Planet mana yang terkecil?';

  @override
  String get qHottest => 'Planet mana yang terpanas?';

  @override
  String get qColdest => 'Planet mana yang terdingin?';

  @override
  String get qMostMoons => 'Planet mana yang punya bulan paling banyak?';

  @override
  String get qBreathable => 'Di planet mana manusia bisa menghirup udaranya?';

  @override
  String get qClosest => 'Planet mana yang paling dekat dengan Matahari?';

  @override
  String get qFarthest => 'Planet mana yang paling jauh dari Matahari?';

  @override
  String get qStrongestGravity => 'Planet mana yang gravitasinya paling kuat?';

  @override
  String get qShortestDay => 'Planet mana yang harinya paling pendek?';

  @override
  String get qLongestDay => 'Planet mana yang harinya paling panjang?';

  @override
  String get appearance => 'Tampilan';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get language => 'Bahasa';

  @override
  String get appLanguage => 'Bahasa aplikasi';

  @override
  String get languageNote => '20 bahasa · nama planet juga';

  @override
  String get phoneLanguage => 'Bahasa ponsel';

  @override
  String get updates => 'Pembaruan';

  @override
  String get version => 'Versi';

  @override
  String get checkForUpdates => 'Periksa pembaruan';

  @override
  String get checking => 'Memeriksa…';

  @override
  String get autoUpdateCheck => 'Periksa otomatis sekali sehari';

  @override
  String get updateNote =>
      'Pembaruan datang dari GitHub Releases. Setelan Anda tetap ada di ponsel.';

  @override
  String get upToDate => 'Anda sudah memakai versi terbaru.';

  @override
  String get updateFailed =>
      'Tidak bisa terhubung ke GitHub. Periksa internet lalu coba lagi.';

  @override
  String get updateAvailable => 'Pembaruan tersedia';

  @override
  String updateReady(String version) {
    return 'Versi $version siap diunduh.';
  }

  @override
  String get download => 'Unduh';

  @override
  String get later => 'Nanti';

  @override
  String get about => 'Tentang';

  @override
  String get sourceCode => 'Kode sumber di GitHub';

  @override
  String get privacyLine => 'Offline · Tanpa iklan · Tanpa pelacakan';

  @override
  String get dataSource => 'Data: NASA Planetary Fact Sheet';

  @override
  String get openFailed => 'Tidak bisa membuka tautan.';

  @override
  String get bodySun => 'Matahari';

  @override
  String get bodyMoon => 'Bulan';

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
  String get kindStar => 'Bintang kita, pusat Tata Surya';

  @override
  String get kindDwarf => 'Planet kerdil';

  @override
  String moonOf(String planet) {
    return 'Bulan milik $planet';
  }

  @override
  String get orbitPeriod => 'Satu orbit';

  @override
  String distanceFrom(String body) {
    return 'Jarak dari $body';
  }

  @override
  String get composition => 'Terbuat dari apa';

  @override
  String get noAtmosphere => 'Tidak punya atmosfer sungguhan, hampir hampa.';

  @override
  String get majorMoons => 'Bulan utama';

  @override
  String get lifeTitle => 'Bisakah manusia tinggal di sini?';

  @override
  String get lifeScoreShort => 'Skor kehidupan';

  @override
  String get lifeNote =>
      'Dihitung dari suhu, tekanan udara, oksigen, air, permukaan, dan gravitasi. Bumi mendapat 10.';

  @override
  String get water => 'Air';

  @override
  String get waterLiquid => 'Air cair';

  @override
  String get waterIce => 'Es';

  @override
  String get waterOcean => 'Lautan di bawah es';

  @override
  String get waterNone => 'Tidak ada air';

  @override
  String get surface => 'Permukaan';

  @override
  String get solidSurface => 'Permukaan padat';

  @override
  String get lifeHome => 'Seperti di rumah';

  @override
  String get lifeHard =>
      'Sangat sulit, perlu pangkalan tertutup dan baju antariksa';

  @override
  String get lifeNo => 'Mustahil bagi manusia';

  @override
  String get downloadInstall => 'Unduh dan pasang';

  @override
  String downloadingPercent(String percent) {
    return 'Mengunduh… $percent%';
  }

  @override
  String get installNow => 'Pasang';

  @override
  String get allowInstalls =>
      'Izinkan Heliora memasang aplikasi di layar yang terbuka, lalu kembali dan ketuk Pasang.';

  @override
  String get downloadFailed =>
      'Unduhan tidak selesai. Periksa internet lalu coba lagi.';

  @override
  String get tryAgain => 'Coba lagi';

  @override
  String get today => 'Hari ini';

  @override
  String get play => 'Putar';

  @override
  String get pause => 'Jeda';

  @override
  String get monthBack => '30 hari sebelumnya';

  @override
  String get monthForward => '30 hari sesudahnya';

  @override
  String get positionsNote =>
      'Posisi asli pada tanggal ini · Ukuran dan jarak tidak sesuai skala · Ketuk planet';

  @override
  String get navYou => 'Anda';

  @override
  String get ageTitle => 'Umur Anda di planet lain';

  @override
  String get setBirthDate => 'Atur tanggal lahir';

  @override
  String get changeBirthDate => 'Ubah';

  @override
  String nextBirthday(String days) {
    return 'Ulang tahun berikutnya dalam $days hari';
  }

  @override
  String get ageNote => 'Tanggal lahir Anda hanya disimpan di ponsel ini.';

  @override
  String get share => 'Bagikan';

  @override
  String shareText(String planet) {
    return '$planet di Heliora, aplikasi Tata Surya offline gratis: https://github.com/lumio-apps/heliora';
  }

  @override
  String get shareFailed => 'Gambar tidak bisa dibagikan.';

  @override
  String get travelTitle => 'Seberapa jauh?';

  @override
  String get distanceFromEarth => 'Jarak dari Bumi hari ini';

  @override
  String get lightTime => 'Cahaya butuh';

  @override
  String get bySpacecraft => 'Dengan wahana 60.000 km/jam';

  @override
  String get byCar => 'Dengan mobil 100 km/jam';

  @override
  String valueSeconds(String value) {
    return '$value dtk';
  }

  @override
  String valueMinutes(String value) {
    return '$value mnt';
  }

  @override
  String get sizeTitle => 'Ukuran';

  @override
  String sizeTimes(String big, String times, String small) {
    return '$big $times× lebih lebar dari $small.';
  }

  @override
  String sizeSimilar(String a, String b) {
    return '$a dan $b hampir sama besar.';
  }

  @override
  String get navSky => 'Langit';

  @override
  String get skyTitle => 'Langit malam ini';

  @override
  String get chooseCity => 'Pilih kota Anda';

  @override
  String get chooseCityHint =>
      'Pilih kota terdekat untuk melihat Bulan dan planet yang tampak malam ini. Tidak perlu izin lokasi, dan pilihan hanya disimpan di ponsel.';

  @override
  String get searchCity => 'Cari kota';

  @override
  String get noCityFound => 'Kota tidak ditemukan';

  @override
  String get cityNote =>
      'Waktu memakai zona waktu ponsel. Planet dianggap tampak bila setidaknya 5° di atas cakrawala saat langit gelap.';

  @override
  String illuminated(String percent) {
    return '$percent% terang';
  }

  @override
  String get moonrise => 'Bulan terbit';

  @override
  String get moonset => 'Bulan terbenam';

  @override
  String get sunset => 'Matahari terbenam';

  @override
  String get sunrise => 'Matahari terbit';

  @override
  String get nextFull => 'Purnama berikutnya';

  @override
  String get nextNew => 'Bulan baru berikutnya';

  @override
  String get phaseNew => 'Bulan baru';

  @override
  String get phaseWaxingCrescent => 'Sabit awal';

  @override
  String get phaseFirstQuarter => 'Kuartal pertama';

  @override
  String get phaseWaxingGibbous => 'Cembung awal';

  @override
  String get phaseFull => 'Purnama';

  @override
  String get phaseWaningGibbous => 'Cembung akhir';

  @override
  String get phaseLastQuarter => 'Kuartal terakhir';

  @override
  String get phaseWaningCrescent => 'Sabit akhir';

  @override
  String get planetsTonight => 'Planet malam ini';

  @override
  String get statusVisible => 'Tampak malam ini';

  @override
  String get statusEvening => 'Petang, setelah matahari terbenam';

  @override
  String get statusMorning => 'Pagi, sebelum matahari terbit';

  @override
  String get statusNotVisible => 'Tidak tampak malam ini';

  @override
  String bestAt(String time) {
    return 'Terbaik pukul $time';
  }

  @override
  String altitudeDir(String direction, String degrees) {
    return '$direction, setinggi $degrees°';
  }

  @override
  String riseSet(String rise, String set) {
    return 'Terbit $rise · Terbenam $set';
  }

  @override
  String get needsTelescope => 'Perlu teropong atau teleskop';

  @override
  String get dirN => 'Utara';

  @override
  String get dirNE => 'Timur laut';

  @override
  String get dirE => 'Timur';

  @override
  String get dirSE => 'Tenggara';

  @override
  String get dirS => 'Selatan';

  @override
  String get dirSW => 'Barat daya';

  @override
  String get dirW => 'Barat';

  @override
  String get dirNW => 'Barat laut';

  @override
  String get findPlanet => 'Cari di langit';

  @override
  String finderTitle(String name) {
    return 'Cari $name';
  }

  @override
  String get pointPhone => 'Angkat ponsel dan gerakkan perlahan.';

  @override
  String turnRight(String degrees) {
    return 'Belok kanan $degrees°';
  }

  @override
  String turnLeft(String degrees) {
    return 'Belok kiri $degrees°';
  }

  @override
  String tiltUp(String degrees) {
    return 'Miringkan ke atas $degrees°';
  }

  @override
  String tiltDown(String degrees) {
    return 'Miringkan ke bawah $degrees°';
  }

  @override
  String onTarget(String name) {
    return '$name ada di sana!';
  }

  @override
  String belowHorizon(String name) {
    return '$name sedang berada di bawah cakrawala.';
  }

  @override
  String risesAt(String time) {
    return 'Terbit pukul $time.';
  }

  @override
  String get noSensor =>
      'Ponsel ini tidak punya sensor kompas, jadi pencari tidak bisa bekerja.';

  @override
  String get calibrate =>
      'Kompas perlu dikalibrasi: gerakkan ponsel membentuk angka 8 beberapa kali.';

  @override
  String get phoneNow => 'Ponsel Anda mengarah ke';

  @override
  String get finderNote =>
      'Pegang ponsel dengan bagian belakang menghadap langit, jauh dari magnet dan logam. Jangan pernah menatap Matahari.';

  @override
  String get eventsTitle => 'Peristiwa antariksa';

  @override
  String get eventsSubtitle =>
      'Apa yang bisa dilihat di langit dalam 12 bulan ke depan.';

  @override
  String eventsNext(String event, String when) {
    return 'Berikutnya: $event · $when';
  }

  @override
  String get eventFullMoon => 'Bulan purnama';

  @override
  String get eventNewMoon => 'Bulan baru';

  @override
  String eventOpposition(String planet) {
    return '$planet beroposisi';
  }

  @override
  String eventEveningElongation(String planet) {
    return '$planet: waktu terbaik di sore hari';
  }

  @override
  String eventMorningElongation(String planet) {
    return '$planet: waktu terbaik di pagi hari';
  }

  @override
  String eventConjunction(String a, String b) {
    return '$a dan $b berdekatan';
  }

  @override
  String get eventMarchEquinox => 'Ekuinoks Maret';

  @override
  String get eventJuneSolstice => 'Solstis Juni';

  @override
  String get eventSeptemberEquinox => 'Ekuinoks September';

  @override
  String get eventDecemberSolstice => 'Solstis Desember';

  @override
  String get eventFullMoonDesc =>
      'Seluruh wajah Bulan terang. Terbit sekitar matahari terbenam.';

  @override
  String get eventNewMoonDesc =>
      'Bulan tidak terlihat. Langit paling gelap bulan ini untuk melihat bintang dan planet.';

  @override
  String eventOppositionDesc(String planet) {
    return '$planet berseberangan dengan Matahari. Ia paling terang tahun ini dan terlihat sepanjang malam.';
  }

  @override
  String eventEveningDesc(String planet, String degrees) {
    return '$planet berjarak $degrees° dari Matahari, jarak terjauhnya. Lihat rendah di barat setelah matahari terbenam.';
  }

  @override
  String eventMorningDesc(String planet, String degrees) {
    return '$planet berjarak $degrees° dari Matahari, jarak terjauhnya. Lihat rendah di timur sebelum matahari terbit.';
  }

  @override
  String eventConjunctionDesc(String degrees) {
    return 'Keduanya hanya terpisah $degrees° di langit.';
  }

  @override
  String get eventEquinoxDesc =>
      'Siang dan malam hampir sama panjang di seluruh Bumi.';

  @override
  String get eventJuneSolsticeDesc =>
      'Hari terpanjang di utara, hari terpendek di selatan.';

  @override
  String get eventDecemberSolsticeDesc =>
      'Hari terpendek di utara, hari terpanjang di selatan.';

  @override
  String eventMeteorShower(String shower) {
    return 'Hujan meteor $shower';
  }

  @override
  String eventMeteorDesc(String rate, String percent) {
    return 'Hingga sekitar $rate meteor per jam di langit gelap. Bulan akan terang $percent%.';
  }

  @override
  String get showerQuadrantids => 'Kuadrantid';

  @override
  String get showerLyrids => 'Lirid';

  @override
  String get showerEtaAquariids => 'Eta Akuarid';

  @override
  String get showerPerseids => 'Perseid';

  @override
  String get showerOrionids => 'Orionid';

  @override
  String get showerLeonids => 'Leonid';

  @override
  String get showerGeminids => 'Geminid';

  @override
  String get showerUrsids => 'Ursid';

  @override
  String get eventToday => 'Hari ini';

  @override
  String get eventTomorrow => 'Besok';

  @override
  String eventInDays(String days) {
    return '$days hari lagi';
  }

  @override
  String get eventsNote =>
      'Tanggal dihitung di ponsel Anda dan ditampilkan dalam zona waktunya. Puncak hujan meteor adalah tanggal umum tiap tahun dan bisa bergeser sehari. Pengingat hanya tersimpan di ponsel Anda.';

  @override
  String get remindMe => 'Ingatkan saya';

  @override
  String reminderSet(String date) {
    return 'Baik, saya akan mengingatkan Anda pada $date.';
  }

  @override
  String get reminderOff => 'Pengingat dihapus.';

  @override
  String get reminderTooLate =>
      'Peristiwa ini terlalu dekat untuk membuat pengingat.';

  @override
  String get notificationsOff =>
      'Notifikasi Heliora mati. Nyalakan di pengaturan Android.';

  @override
  String get reminderTomorrow => 'Besok';

  @override
  String get reminderToday => 'Terjadi hari ini';

  @override
  String get onlineTitle => 'Fitur online';

  @override
  String get onlineSubtitle =>
      'Tampilkan stasiun luar angkasa dan peluncuran roket. Heliora lalu hanya menghubungi wheretheiss.at, Celestrak, dan Launch Library 2, yang dapat melihat alamat internet ponsel Anda. Tidak ada hal lain yang dikirim. Mati secara default.';

  @override
  String get turnOnOnline => 'Aktifkan fitur online';

  @override
  String get issTitle => 'Stasiun luar angkasa';

  @override
  String get issCardHint => 'Di mana sekarang dan kapan melintas di atas Anda';

  @override
  String get issNeedsOnline =>
      'Untuk menampilkan stasiun, Heliora memerlukan data orbitnya dari internet. Data diunduh sekali lalu berfungsi offline selama beberapa hari.';

  @override
  String get issLoading => 'Mengambil data orbit…';

  @override
  String get issFailed =>
      'Data orbit tidak bisa diambil. Periksa internet lalu coba lagi.';

  @override
  String issStale(String days) {
    return 'Data orbit sudah $days hari, jadi posisi mungkin meleset. Sambungkan ke internet untuk memperbaruinya.';
  }

  @override
  String get issHeight => 'Ketinggian';

  @override
  String get issSpeed => 'Kecepatan';

  @override
  String get issFromYou => 'Jarak dari Anda';

  @override
  String valueKmh(String value) {
    return '$value km/jam';
  }

  @override
  String issAboveHorizon(String direction, String degrees) {
    return 'Di atas cakrawala Anda sekarang! Lihat ke $direction, setinggi $degrees°.';
  }

  @override
  String get issBelowHorizon => 'Di bawah cakrawala Anda saat ini.';

  @override
  String issPassesTitle(String city) {
    return 'Lintasan berikutnya di atas $city';
  }

  @override
  String get issNoPasses => 'Tidak ada lintasan bagus dalam 5 hari ke depan.';

  @override
  String issMaxHigh(String degrees) {
    return 'Setinggi hingga $degrees°';
  }

  @override
  String issFromTo(String start, String end) {
    return 'Dari $start ke $end';
  }

  @override
  String get issVisible => 'Mudah dilihat';

  @override
  String get issHidden => 'Sulit dilihat';

  @override
  String get issPassTitle => 'Stasiun luar angkasa melintas di atas Anda';

  @override
  String issPassBody(String degrees, String direction) {
    return 'Terbit dalam 10 menit, setinggi hingga $degrees°. Lihat ke $direction.';
  }

  @override
  String get issNote =>
      'Posisi dihitung di ponsel Anda dari data orbit stasiun. Lintasan mudah dilihat saat langit gelap dan stasiun disinari Matahari: tampak seperti bintang terang yang bergerak cepat.';

  @override
  String get launchesNeedOnline =>
      'Aktifkan fitur online untuk melihat peluncuran roket mendatang di sini.';

  @override
  String get launchesFailed =>
      'Daftar peluncuran tidak bisa diperbarui. Menampilkan daftar tersimpan.';

  @override
  String get launchesNote =>
      'Waktu peluncuran berasal dari Launch Library 2 dan sering berubah. Nama dan tempat dalam bahasa Inggris.';

  @override
  String get launchReminderBody =>
      'Meluncur sekitar satu jam lagi. Waktu bisa berubah.';

  @override
  String get launchTimeTbd => 'Waktu belum ditentukan';

  @override
  String get quizChoose => 'Pilih tingkat';

  @override
  String get levelEasy => 'Mudah';

  @override
  String get levelMedium => 'Sedang';

  @override
  String get levelHard => 'Sulit';

  @override
  String get levelEasyHint => 'Dasar-dasar tentang planet';

  @override
  String get levelMediumHint => 'Planet dan bulan';

  @override
  String get levelHardHint => 'Perbandingan dan peringkat yang menjebak';

  @override
  String get qStar => 'Manakah dari ini yang bintang, bukan planet?';

  @override
  String get qDwarf => 'Manakah dari ini yang planet kerdil?';

  @override
  String get qMoonVisited => 'Di bulan mana manusia pernah berjalan?';

  @override
  String get qLargestMoon => 'Manakah dari bulan-bulan ini yang paling besar?';

  @override
  String get qSmallestMoon => 'Manakah dari bulan-bulan ini yang paling kecil?';

  @override
  String get qThickAirMoon =>
      'Manakah dari bulan-bulan ini yang punya atmosfer tebal?';

  @override
  String get qGeyserMoon =>
      'Bulan mana yang menyemburkan geiser air ke luar angkasa?';

  @override
  String get qVolcanicMoon =>
      'Bulan mana yang punya gunung berapi paling aktif?';

  @override
  String get qBackwardsMoon =>
      'Bulan mana yang mengelilingi planetnya dengan arah terbalik?';

  @override
  String get qBiggestRocky =>
      'Manakah yang terbesar dari empat planet berbatu?';

  @override
  String get qColdestRocky =>
      'Manakah yang terdingin dari empat planet berbatu?';

  @override
  String get qHighestPressure =>
      'Planet mana yang tekanan udara di permukaannya paling tinggi?';

  @override
  String get qSecondLargest => 'Planet mana yang terbesar kedua?';

  @override
  String get qLongestYear => 'Planet mana yang tahunnya paling panjang?';

  @override
  String get qShortestYear => 'Planet mana yang tahunnya paling pendek?';

  @override
  String get qSmallestGiant =>
      'Manakah yang terkecil dari empat planet raksasa?';

  @override
  String get qRockyLongestYear =>
      'Manakah dari empat planet berbatu yang tahunnya paling panjang?';

  @override
  String get qFastestMoon =>
      'Manakah dari bulan-bulan ini yang mengelilingi planetnya paling cepat?';

  @override
  String get qSlowestMoon =>
      'Manakah dari bulan-bulan ini yang butuh waktu paling lama mengelilingi planetnya?';

  @override
  String get qStrongestMoonGravity =>
      'Manakah dari bulan-bulan ini yang gravitasinya paling kuat?';

  @override
  String get qColdestMoon => 'Manakah dari bulan-bulan ini yang paling dingin?';

  @override
  String get qSecondLargestMoon =>
      'Manakah dari bulan-bulan ini yang terbesar kedua?';

  @override
  String get factTitle => 'Tahukah kamu?';

  @override
  String get factTap => 'Ketuk untuk fakta lain';

  @override
  String get factSun1 =>
      'Matahari menyimpan 99,8% dari seluruh massa tata surya.';

  @override
  String get factSun2 =>
      'Cahaya Matahari butuh sekitar 8 menit 20 detik untuk sampai ke Bumi.';

  @override
  String get factMercury1 =>
      'Satu hari di Merkurius, dari matahari terbit sampai terbit berikutnya, berlangsung sekitar 176 hari Bumi. Itu dua kali lebih panjang dari tahunnya.';

  @override
  String get factMercury2 =>
      'Merkurius hampir tidak punya udara, jadi langitnya hitam bahkan di siang hari, dan malamnya sangat dingin.';

  @override
  String get factVenus1 =>
      'Venus berputar terbalik, jadi di Venus Matahari terbit dari barat.';

  @override
  String get factVenus2 =>
      'Venus lebih panas daripada Merkurius, padahal lebih jauh dari Matahari, karena udaranya yang tebal memerangkap panas.';

  @override
  String get factEarth1 =>
      'Bumi adalah satu-satunya tempat yang kita tahu punya kehidupan, dan sekitar 71% permukaannya tertutup air.';

  @override
  String get factEarth2 =>
      'Bumi bukan bola yang sempurna. Bagian khatulistiwanya sedikit menggembung karena Bumi berputar.';

  @override
  String get factMars1 =>
      'Olympus Mons di Mars adalah gunung berapi tertinggi di tata surya, sekitar dua setengah kali setinggi Gunung Everest.';

  @override
  String get factMars2 => 'Matahari terbenam di Mars tampak biru.';

  @override
  String get factJupiter1 =>
      'Massa Jupiter lebih dari dua kali massa semua planet lain digabungkan.';

  @override
  String get factJupiter2 =>
      'Bintik Merah Besar adalah badai yang lebih besar dari Bumi, dan sudah diamati selama lebih dari 150 tahun.';

  @override
  String get factSaturn1 =>
      'Saturnus begitu ringan untuk ukurannya sehingga akan mengapung di air, kalau ada bak mandi yang cukup besar.';

  @override
  String get factSaturn2 =>
      'Cincin Saturnus sangat lebar tetapi sangat tipis: di beberapa tempat tebalnya hanya sekitar sepuluh meter.';

  @override
  String get factUranus1 =>
      'Uranus mengelilingi Matahari sambil berguling miring, dengan kemiringan sekitar 98 derajat.';

  @override
  String get factUranus2 =>
      'Uranus adalah planet pertama yang ditemukan dengan teleskop. William Herschel melihatnya pada 1781.';

  @override
  String get factNeptune1 =>
      'Neptunus punya angin tercepat di antara semua planet, lebih dari 2.000 km/jam.';

  @override
  String get factNeptune2 =>
      'Neptunus ditemukan lewat matematika sebelum ada yang melihatnya: pada 1846 para astronom menghitung di mana letaknya.';

  @override
  String get factMoon1 =>
      'Bulan menjauh dari Bumi sekitar 3,8 sentimeter setiap tahun.';

  @override
  String get factMoon2 =>
      'Kita selalu melihat sisi Bulan yang sama, karena Bulan berputar tepat sekali setiap mengelilingi Bumi sekali.';

  @override
  String get factPluto1 =>
      'Satu tahun di Pluto berlangsung sekitar 248 tahun Bumi.';

  @override
  String get factPluto2 =>
      'Pluto punya dataran besar berbentuk hati yang terbuat dari nitrogen beku.';

  @override
  String get factIo1 =>
      'Io adalah dunia paling vulkanik yang kita kenal, dengan ratusan gunung berapi aktif.';

  @override
  String get factIo2 =>
      'Gravitasi Jupiter menekan dan menarik Io, dan panas dari situ menggerakkan gunung-gunung berapinya.';

  @override
  String get factEuropa1 =>
      'Di bawah kerak esnya, Europa mungkin menyimpan air sekitar dua kali lipat dari seluruh samudra Bumi.';

  @override
  String get factEuropa2 =>
      'Europa adalah salah satu tempat terbaik untuk mencari kehidupan di luar Bumi. Wahana Europa Clipper sedang menuju ke sana.';

  @override
  String get factGanymede1 =>
      'Ganymede adalah bulan terbesar di tata surya. Bahkan lebih besar dari Merkurius.';

  @override
  String get factGanymede2 =>
      'Ganymede adalah satu-satunya bulan yang diketahui punya medan magnet sendiri.';

  @override
  String get factCallisto1 =>
      'Callisto adalah salah satu tempat dengan kawah terbanyak di tata surya, dan permukaannya sangat tua.';

  @override
  String get factCallisto2 =>
      'Callisto cukup jauh dari Jupiter sehingga menerima lebih sedikit radiasi kerasnya, jadi para ilmuwan mengusulkannya untuk pangkalan masa depan.';

  @override
  String get factTitan1 =>
      'Titan adalah satu-satunya bulan dengan atmosfer tebal. Tekanan udara di permukaannya lebih tinggi daripada di Bumi.';

  @override
  String get factTitan2 =>
      'Titan punya sungai dan danau, tetapi isinya metana dan etana cair, bukan air.';

  @override
  String get factEnceladus1 =>
      'Enceladus menyemburkan pancaran es dan uap air ke luar angkasa lewat retakan di dekat kutub selatannya.';

  @override
  String get factEnceladus2 => 'Pancaran Enceladus mengisi cincin E Saturnus.';

  @override
  String get factTriton1 =>
      'Triton mengelilingi Neptunus dengan arah terbalik, jadi kemungkinan dulunya planet kerdil yang ditangkap Neptunus.';

  @override
  String get factTriton2 =>
      'Pada sekitar −235 °C, Triton adalah salah satu tempat terdingin yang pernah diukur di tata surya.';

  @override
  String get jumpInput => 'Tinggi lompatanmu di Bumi (cm)';

  @override
  String jumpHigh(String height) {
    return 'Lompatan: $height';
  }

  @override
  String jumpFeelsLike(String height) {
    return 'Lompatan $height di Bumi menjadi';
  }

  @override
  String get jumpNote =>
      'Dengan tolakan yang sama seperti di Bumi. Di Matahari dan planet gas raksasa tidak ada tanah untuk berpijak, jadi ini hanya permainan khayalan.';

  @override
  String valueCm(String value) {
    return '$value cm';
  }

  @override
  String valueM(String value) {
    return '$value m';
  }

  @override
  String get eclipseTotalLunar => 'Gerhana bulan total';

  @override
  String get eclipsePartialLunar => 'Gerhana bulan sebagian';

  @override
  String get eclipsePenumbralLunar => 'Gerhana bulan penumbra';

  @override
  String get eclipseTotalSolar => 'Gerhana matahari total';

  @override
  String get eclipseAnnularSolar => 'Gerhana matahari cincin';

  @override
  String get eclipseHybridSolar => 'Gerhana matahari hibrida';

  @override
  String get eclipsePartialSolar => 'Gerhana matahari sebagian';

  @override
  String get eclipseTotalLunarDesc =>
      'Bulan masuk sepenuhnya ke bayangan Bumi dan sering tampak merah redup. Semua orang di sisi malam Bumi bisa melihatnya, dan aman dilihat dengan mata telanjang.';

  @override
  String eclipsePartialLunarDesc(String percent) {
    return 'Sebagian Bulan ($percent% dari lebarnya) masuk ke bayangan gelap Bumi. Aman dilihat dengan mata telanjang.';
  }

  @override
  String get eclipsePenumbralLunarDesc =>
      'Bulan melewati bayangan luar Bumi yang samar. Bulan hanya meredup sedikit, jadi sulit disadari.';

  @override
  String get eclipseTotalSolarDesc =>
      'Bulan menutupi Matahari sepenuhnya di sepanjang jalur sempit di Bumi. Di luar jalur itu terlihat gerhana sebagian.';

  @override
  String get eclipseAnnularSolarDesc =>
      'Bulan sedikit terlalu jauh untuk menutupi seluruh Matahari, sehingga tersisa cincin terang. Cincin terlihat di sepanjang jalur sempit; di luarnya gerhana hanya sebagian.';

  @override
  String get eclipseHybridSolarDesc =>
      'Di sepanjang jalurnya, gerhana ini total di beberapa tempat dan berbentuk cincin di tempat lain. Di luar jalur, gerhananya sebagian.';

  @override
  String get eclipsePartialSolarDesc =>
      'Bulan hanya menutupi sebagian Matahari, dan tidak ada tempat di Bumi yang melihat Matahari tertutup penuh.';

  @override
  String get eclipseNoCity =>
      'Pilih kota di Heliora untuk tahu apakah bisa melihatnya dari sana.';

  @override
  String eclipseLunarUp(String city) {
    return 'Di puncak gerhana, Bulan berada di atas cakrawala di $city.';
  }

  @override
  String eclipseLunarPartly(String city) {
    return 'Di $city, Bulan hanya berada di atas cakrawala selama sebagian gerhana.';
  }

  @override
  String eclipseLunarDown(String city) {
    return 'Di $city, Bulan tetap di bawah cakrawala, jadi tidak terlihat dari sana.';
  }

  @override
  String eclipseSolarNone(String city) {
    return 'Tidak terlihat dari $city: bayangan Bulan tidak sampai ke sana, atau Matahari di bawah cakrawala.';
  }

  @override
  String eclipseSolarSlight(String city) {
    return 'Dari $city, paling banyak gerhana sebagian yang sangat tipis, sulit disadari.';
  }

  @override
  String eclipseSolarPartial(String city, String percent) {
    return 'Perkiraan kasar untuk $city: Bulan menutupi paling banyak sekitar $percent% lebar Matahari.';
  }

  @override
  String eclipseSolarNear(String city) {
    return '$city dekat dengan jalur tempat Matahari hampir atau sepenuhnya tertutup. Lihat peta gerhana; perkiraan ini kasar.';
  }

  @override
  String get eclipseSolarSafety =>
      'Jangan pernah menatap Matahari tanpa kacamata gerhana yang sesuai.';

  @override
  String get alertsTitle => 'Pengingat';

  @override
  String get tonightAlertSwitch => 'Langit malam ini, setiap sore';

  @override
  String get tonightAlertTime => 'Waktu';

  @override
  String get tonightAlertNote =>
      'Catatan singkat tentang Bulan dan planet yang bisa kamu lihat, pada waktu yang kamu pilih. Dihitung di ponselmu, tanpa internet. Android hanya mengizinkan Heliora menyiapkan catatan sekitar dua minggu ke depan, jadi buka aplikasinya sesekali.';

  @override
  String get tonightNotifTitle => 'Langit malam ini';

  @override
  String tonightMoon(String phase, String percent) {
    return 'Bulan: $phase, $percent% terang.';
  }

  @override
  String tonightPlanets(String planets) {
    return 'Cari: $planets.';
  }

  @override
  String get tonightNoPlanets => 'Tidak ada planet terang di langit petang.';

  @override
  String get tonightNoCity => 'Pilih kota di Heliora untuk melihat planet.';

  @override
  String get birthdayTitle => 'Langit hari ulang tahunku';

  @override
  String get birthdaySubtitle =>
      'Bulan dan planet pada hari kamu lahir, serta hari-hari besar dalam hidupmu.';

  @override
  String get birthdayCardHint => 'Fase Bulan, planet, dan tonggak';

  @override
  String get birthdayNeedDate => 'Atur tanggal lahir';

  @override
  String get birthdayMoon => 'Bulan di hari ulang tahunmu';

  @override
  String get birthdayPlanets => 'Planet pada hari itu';

  @override
  String birthdayDaysOld(String count) {
    return 'Hari ini umurmu $count hari.';
  }

  @override
  String get birthdayMilestones => 'Tonggak';

  @override
  String birthdayDayN(String count) {
    return 'Hari ke-$count';
  }

  @override
  String get birthdayBillion => 'Berumur 1 miliar detik';

  @override
  String get birthdayPassed => 'Sudah';

  @override
  String get birthdayNote =>
      'Dihitung di ponselmu dengan orbit yang sama seperti bagian Heliora lainnya. Tanggal lahirmu tidak pernah keluar dari ponsel.';

  @override
  String get missionsTitle => 'Misi antariksa';

  @override
  String get missionsSubtitle =>
      'Momen terkenal dalam penjelajahan antariksa, dari yang paling lama.';

  @override
  String get missionsCardHint => 'Misi terkenal sepanjang waktu';

  @override
  String get missionSputnik1 =>
      'Satelit buatan pertama. Bola logam seukuran bola pantai ini mengorbit Bumi sekitar tiga bulan. Bunyi bipnya bisa didengar lewat radio, dan dari sinilah era antariksa dimulai.';

  @override
  String get missionVostok1 =>
      'Yuri Gagarin menjadi manusia pertama di antariksa. Ia mengelilingi Bumi sekali dalam sekitar 108 menit.';

  @override
  String get missionApollo11 =>
      'Neil Armstrong dan Buzz Aldrin mendarat di Laut Ketenangan dan menjadi manusia pertama yang berjalan di Bulan. Michael Collins menunggu mereka di orbit.';

  @override
  String get missionVenera7 =>
      'Pesawat pertama yang mendarat di planet lain dan mengirim sinyal. Ia mengirim data dari Venus selama sekitar 23 menit di tengah panas yang menghancurkan.';

  @override
  String get missionViking1 =>
      'Mendarat di Mars dan bekerja di sana lebih dari enam tahun, mengirim rangkaian panjang pertama foto dan laporan cuaca dari permukaan planet lain.';

  @override
  String get missionVoyager1 =>
      'Diluncurkan pada 1977, melewati Jupiter dan Saturnus, lalu memasuki ruang antarbintang pada 2012. Inilah benda buatan manusia terjauh dari Bumi.';

  @override
  String get missionHubble =>
      'Diluncurkan pada 1990, teleskop ini memandang alam semesta dari atas udara Bumi. Gambar-gambarnya yang tajam membantu mengukur usia alam semesta dan memperlihatkan ribuan galaksi jauh.';

  @override
  String get missionHuygens =>
      'Huygens, wahana yang dibawa Cassini, turun dengan parasut ke Titan, bulan Saturnus. Ini pendaratan pertama di tata surya bagian luar, dan ia mengirim foto dari permukaan.';

  @override
  String get missionCuriosity =>
      'Rover seukuran mobil ini mendarat di Kawah Gale dengan «derek langit» bertenaga roket. Ia menemukan bahwa Mars dulu pernah punya kondisi yang cocok untuk kehidupan.';

  @override
  String get missionMangalyaan =>
      'Misi Mars Orbiter milik India mencapai orbit Mars pada percobaan pertama, yang belum pernah dilakukan negara mana pun, dengan biaya sangat rendah.';

  @override
  String get missionRosetta =>
      'Pendarat Philae milik Rosetta mendarat di komet 67P/Churyumov–Gerasimenko, pendaratan pertama di sebuah komet. Rosetta sendiri mengorbit komet itu selama dua tahun.';

  @override
  String get missionNewhorizons =>
      'Setelah perjalanan sembilan tahun, wahana ini melintas dekat Pluto dan untuk pertama kalinya memperlihatkan gunung es dan dataran raksasa berbentuk hati.';

  @override
  String get missionPerseverance =>
      'Rover Perseverance mendarat di Kawah Jezero untuk mencari tanda kehidupan kuno dan mengumpulkan sampel batuan. Helikopternya, Ingenuity, melakukan penerbangan bertenaga pertama di planet lain.';

  @override
  String get missionJwst =>
      'Teleskop antariksa terbesar ini punya cermin emas 6,5 meter dan mengamati langit dalam cahaya inframerah dari jarak 1,5 juta km. Ia melihat beberapa galaksi pertama.';

  @override
  String get missionChandrayaan3 =>
      'India menjadi negara keempat yang mendarat mulus di Bulan, dan yang pertama di dekat kutub selatannya. Pendarat Vikram membawa rover Pragyan.';

  @override
  String get spacecraftTitle => 'Wahana antariksa saat ini';

  @override
  String get spacecraftSubtitle =>
      'Seberapa jauh beberapa wahana antariksa terkenal dari Bumi saat ini.';

  @override
  String get spacecraftCardHint => 'Voyager, JWST, rover Mars, dan lainnya';

  @override
  String get spacecraftDistance => 'Jarak dari Bumi';

  @override
  String get spacecraftAltitude => 'Ketinggian di atas Bumi';

  @override
  String get spacecraftInAu => 'Dalam satuan astronomi';

  @override
  String get spacecraftSpeed => 'Kecepatan';

  @override
  String get spacecraftSignal => 'Sinyal radio butuh';

  @override
  String get spacecraftNote =>
      'Jarak adalah perkiraan. Untuk wahana yang jauh, jarak dihitung dari kecepatan rata-rata dan bisa meleset sekitar 1%, karena Bumi bergerak mengelilingi Matahari. Jarak ke Mars dihitung untuk hari ini. Satu SA (satuan astronomi) adalah jarak dari Bumi ke Matahari.';

  @override
  String valueBillionKm(String value) {
    return '$value miliar km';
  }

  @override
  String valueAu(String value) {
    return '$value SA';
  }

  @override
  String valueKmS(String value) {
    return '$value km/dtk';
  }

  @override
  String get spacecraftVoyager1 =>
      'Diluncurkan tahun 1977. Pada 2012 menjadi wahana pertama yang memasuki ruang antarbintang. Sinyal radionya sudah berumur sekitar sehari saat sampai ke kita.';

  @override
  String get spacecraftVoyager2 =>
      'Diluncurkan tahun 1977. Satu-satunya wahana yang pernah mengunjungi Uranus dan Neptunus, dan memasuki ruang antarbintang pada 2018.';

  @override
  String get spacecraftNewHorizons =>
      'Melintasi Pluto pada 2015 dan objek Sabuk Kuiper Arrokoth pada 2019. Masih terus melaju ke luar dan masih mengirim data.';

  @override
  String get spacecraftJwst =>
      'Teleskop antariksa terbesar, diluncurkan tahun 2021. Letaknya dekat titik bernama L2, sekitar 1,5 juta km dari Bumi, dengan perisai suryanya selalu menghadap Matahari.';

  @override
  String get spacecraftIss =>
      'Mengelilingi Bumi sekitar tiap 90 menit. Sejak 2000 selalu ada orang yang tinggal di dalamnya tanpa putus.';

  @override
  String get spacecraftHubble =>
      'Diluncurkan tahun 1990 dan masih bekerja. Ia mengorbit Bumi di atas udara yang membuat gambar kabur, jadi fotonya sangat tajam.';

  @override
  String get spacecraftMarsRovers =>
      'Curiosity (mendarat 2012) dan Perseverance (mendarat 2021) sedang menjelajah Mars. Jarak ke Mars berubah dari sekitar 55 juta km hingga lebih dari 400 juta km.';

  @override
  String get searchTooltip => 'Cari';

  @override
  String get searchHint => 'Cari planet, bulan, misi…';

  @override
  String get searchClear => 'Hapus';

  @override
  String searchEmpty(String query) {
    return 'Tidak ada hasil untuk “$query”.';
  }

  @override
  String get searchBodies => 'Planet dan bulan';

  @override
  String get searchMissions => 'Misi';

  @override
  String get searchSpacecraft => 'Wahana antariksa';

  @override
  String get favoritesTitle => 'Favorit';

  @override
  String get favoritesEmpty =>
      'Ketuk bintang pada planet, misi, atau wahana agar tersimpan di sini.';

  @override
  String get favoriteAdd => 'Tambah ke favorit';

  @override
  String get favoriteRemove => 'Hapus dari favorit';

  @override
  String get textSize => 'Ukuran teks';

  @override
  String get textSizeNormal => 'Normal';

  @override
  String get textSizeLarge => 'Besar';

  @override
  String get textSizeLarger => 'Lebih besar';

  @override
  String get textSizeNote =>
      'Memperbesar teks di Heliora. Ukurannya tidak pernah lebih kecil dari ukuran teks bawaan ponselmu.';

  @override
  String get skyOtherNight => 'Langit malam';

  @override
  String get planetsThatNight => 'Planet pada malam itu';

  @override
  String get previousDay => 'Hari sebelumnya';

  @override
  String get nextDay => 'Hari berikutnya';

  @override
  String get pickDate => 'Pilih tanggal';

  @override
  String get backToTonight => 'Kembali ke malam ini';

  @override
  String get moonCalendar => 'Kalender Bulan';

  @override
  String get moonCalendarHint => 'Fase Bulan setiap hari';

  @override
  String get previousMonth => 'Bulan sebelumnya';

  @override
  String get nextMonth => 'Bulan berikutnya';

  @override
  String get keyMoonDates => 'Fase utama bulan ini';

  @override
  String get moonCalendarNote =>
      'Tanggal dan jam fase ditampilkan dalam zona waktu ponsel Anda dan akurat dalam kisaran sekitar satu jam.';

  @override
  String get seeSkyThatDay => 'Lihat langit pada hari ini';

  @override
  String get sunLightTitle => 'Matahari dan cahaya';

  @override
  String get firstLight => 'Cahaya pertama';

  @override
  String get goldenMorningEnds => 'Jam emas pagi berakhir';

  @override
  String get solarNoon => 'Tengah hari matahari';

  @override
  String get goldenEveningStarts => 'Jam emas sore dimulai';

  @override
  String get lastLight => 'Cahaya terakhir';

  @override
  String get darkSky => 'Langit benar-benar gelap';

  @override
  String get sunDayLength => 'Panjang siang';

  @override
  String durationHm(String hours, String minutes) {
    return '$hours j $minutes mnt';
  }

  @override
  String get sunNote =>
      'Jam emas adalah saat Matahari kurang dari 6° di atas cakrawala. Cahaya pertama dan terakhir terjadi saat Matahari 6° di bawah cakrawala, dan langit benar-benar gelap saat 18° di bawah. Waktunya dihitung untuk tanggal yang Anda pilih.';

  @override
  String get sunStaysUp => 'Pada hari ini Matahari tidak terbenam.';

  @override
  String get sunStaysDown => 'Pada hari ini Matahari tidak terbit.';

  @override
  String get solarSystemTitle => 'Tata surya';
}
