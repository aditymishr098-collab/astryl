/// True in the normal build, which updates itself from GitHub. The F-Droid
/// build is made with `--dart-define=FDROID=true`: F-Droid brings the updates,
/// so the app never checks for or installs them.
const bool inAppUpdates = !bool.fromEnvironment('FDROID');
