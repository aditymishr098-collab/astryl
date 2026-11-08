import 'package:flutter/foundation.dart' show kIsWeb;

/// True in the normal build, which updates itself from GitHub. The F-Droid
/// build is made with `--dart-define=FDROID=true`: F-Droid brings the updates,
/// so the app never checks for or installs them. The web build never updates
/// itself either: the browser always loads the newest version.
const bool inAppUpdates = !kIsWeb && !bool.fromEnvironment('FDROID');
