import 'dart:async';

import 'package:flutter/foundation.dart' show PlatformDispatcher, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/crash_reporter.dart';
import 'l10n/gen/app_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/update_gate.dart';
import 'state/app_state.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState();
  await state.load();
  if (!kIsWeb) {
    _watchCrashes(state);
  }
  runApp(HelioraApp(state: state));
}

/// Sends a small anonymous report to the project's Supabase when the app
/// crashes (see crash_reporter.dart). Turned off in Settings.
void _watchCrashes(AppState state) {
  final reporter = CrashReporter(
    bridge: state.bridge,
    enabled: () => state.account.crashReports,
    version: () => state.appVersion,
    locale: () => state.settings.localeCode.isEmpty
        ? PlatformDispatcher.instance.locale.languageCode
        : state.settings.localeCode,
  );
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    previous?.call(details);
    unawaited(reporter.record(details.exception, details.stack));
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    unawaited(reporter.record(error, stack));
    return false;
  };
  unawaited(reporter.flush());
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
            // Home, Sky, Compare and Quiz have no app bar, so the status bar
            // style is set here for the whole app (app bars use the same).
            builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
              value: statusBarStyle(Theme.of(context).brightness),
              child: _withTextSize(context, child, settings.textScalePercent),
            ),
            // The app opens straight on Home. The account is optional and
            // lives in the You tab.
            home: const UpdateGate(child: HomeScreen()),
          );
        },
      ),
    );
  }
}
