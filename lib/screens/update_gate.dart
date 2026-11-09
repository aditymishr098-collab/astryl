import 'package:flutter/material.dart';

import '../l10n/names.dart';
import '../state/app_state.dart';
import '../theme.dart';
import 'update_dialog.dart';

/// Runs before anything else each time the app opens. It asks GitHub for the
/// newest release; when there is one, the update dialog comes first, with
/// "Update now" and "Skip". After the dialog (or at once, when there is no
/// update, no internet or the check is slow) the app opens as usual.
class UpdateGate extends StatefulWidget {
  const UpdateGate({super.key, required this.child});

  final Widget child;

  @override
  State<UpdateGate> createState() => _UpdateGateState();
}

class _UpdateGateState extends State<UpdateGate> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  Future<void> _run() async {
    final state = AppScope.read(context);
    final info = await state.checkOnOpen();
    if (info != null && mounted) {
      await showUpdateDialog(context, info);
    }
    if (mounted) {
      setState(() => _ready = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return widget.child;
    }
    final p = Palette.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Astryl',
                style: TextStyle(
                    fontSize: 34, fontWeight: FontWeight.w700, color: p.text)),
            const SizedBox(height: 6),
            Text(context.l10n.tagline,
                style: TextStyle(fontSize: 14, color: p.muted)),
            const SizedBox(height: 24),
            SizedBox.square(
              dimension: 22,
              child:
                  CircularProgressIndicator(strokeWidth: 2, color: p.accent),
            ),
          ],
        ),
      ),
    );
  }
}
