import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/gen/app_localizations.dart';
import 'screens/home_screen.dart';
import 'state/app_state.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState();
  await state.load();
  runApp(HelioraApp(state: state));
}

/// Makes the text at least [percent] of its normal size. The phone's own text
/// size setting is respected: the larger of the two is used.
Widget _withTextSize(BuildContext context, Widget? child, int percent) {
  final content = child ?? const SizedBox.shrink();
  if (percent <= 100) {
    return content;
  }
  final media = MediaQuery.of(context);
  final system = media.textScaler.scale(100) / 100;
  final wanted = percent / 100;
  if (system >= wanted) {
    return content;
  }
  return MediaQuery(
    data: media.copyWith(textScaler: TextScaler.linear(wanted)),
    child: content,
  );
}

class HelioraApp extends StatelessWidget {
  const HelioraApp({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          final settings = state.settings;
          final code = settings.localeCode;
          return MaterialApp(
            title: 'Astryl',
            debugShowCheckedModeBanner: false,
            theme: buildTheme(Brightness.light),
            darkTheme: buildTheme(Brightness.dark),
            themeMode: settings.themeMode,
            locale: code.isEmpty ? null : Locale(code),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) =>
                _withTextSize(context, child, settings.textScalePercent),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
