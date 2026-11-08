import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../theme.dart';
import 'common.dart';

/// One row of a list of events: an icon, a title, when it happens, a few
/// words about it and a bell to switch its reminder on or off.
class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    required this.icon,
    required this.title,
    required this.when,
    required this.description,
    required this.reminderOn,
    required this.tooltip,
    required this.onToggle,
    this.badge,
    this.badgeColor,
  });

  final Widget icon;
  final String title;
  final String when;
  final String description;
  final bool reminderOn;
  final String tooltip;
  final VoidCallback onToggle;

  /// A short coloured label under the description, for example "Easy to see".
  final String? badge;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return SurfaceCard(
      padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 40, height: 40, child: Center(child: icon)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: p.text)),
                const SizedBox(height: 2),
                Text(when,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: p.accentText)),
                if (description.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(description,
                      style: TextStyle(
                          fontSize: 13, color: p.muted, height: 1.35)),
                ],
                if (badge != null) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(badge!,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: badgeColor ?? p.muted)),
                ],
              ],
            ),
          ),
          // Reminders are Android alarms, so the web version has no bell.
          if (!kIsWeb)
            IconButton(
              tooltip: tooltip,
              onPressed: onToggle,
              icon: Icon(
                reminderOn
                    ? Icons.notifications_active
                    : Icons.notifications_none,
                color: reminderOn ? p.accentText : p.muted,
              ),
            ),
        ],
      ),
    );
  }
}
