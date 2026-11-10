import 'package:flutter/material.dart';

import '../l10n/names.dart';
import '../state/app_state.dart';

/// Turns the reminder named [id] on or off. When it is off, it is set for
/// [at] with [title] and [body]; a null [at] means it is too late.
/// Shows a short message about what happened.
Future<void> toggleReminder(
  BuildContext context, {
  required String id,
  required DateTime? at,
  required String title,
  required String body,
}) async {
  final state = AppScope.read(context);
  final l = context.l10n;
  final loc = MaterialLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  void say(String text) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  if (state.hasReminder(id)) {
    await state.bridge.cancelReminder(id);
    await state.setReminder(id, false);
    say(l.reminderOff);
    return;
  }
  if (at == null) {
    say(l.reminderTooLate);
    return;
  }
  final date = loc.formatMediumDate(at);
  final channel = l.eventsTitle;

  final allowed = await state.bridge.requestNotifications();
  if (!allowed) {
    say(l.notificationsOff);
    return;
  }
  final ok = await state.bridge.scheduleReminder(
    id: id,
    at: at,
    title: title,
    body: body,
    channel: channel,
  );
  if (!ok) {
    say(l.reminderTooLate);
    return;
  }
  await state.setReminder(id, true);
  say(l.reminderSet(date));
}

/// True for reminders that belong to the space events list.
bool isEventReminder(String id) =>
    !id.startsWith('iss:') &&
    !id.startsWith('sat:') &&
    !id.startsWith('launch:') &&
    !id.startsWith('tonight:') &&
    !id.startsWith('quiz:');
