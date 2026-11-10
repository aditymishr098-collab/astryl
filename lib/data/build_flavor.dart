import 'package:flutter/foundation.dart' show kIsWeb;

/// True in the Android build, which updates itself from GitHub releases. The
/// web build never updates itself: the browser always loads the newest version.
const bool inAppUpdates = !kIsWeb;

