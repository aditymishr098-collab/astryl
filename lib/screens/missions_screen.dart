import 'package:flutter/material.dart';

import '../data/favorites.dart';
import '../data/missions.dart';
import '../l10n/names.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/favorite_button.dart';

/// A timeline of famous space missions, oldest first.
class MissionsScreen extends StatelessWidget {
  const MissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.missionsTitle,
            style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: <Widget>[
          Text(l.missionsSubtitle,
              style: TextStyle(fontSize: 14, color: p.muted, height: 1.4)),
          const SizedBox(height: 16),
          for (final m in missions) ...<Widget>[
            MissionCard(mission: m),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

/// One mission: the year, its name and agency, and a short story. Also used
/// by the search and favourites list.
class MissionCard extends StatelessWidget {
  const MissionCard({super.key, required this.mission});

  final Mission mission;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final loc = MaterialLocalizations.of(context);
    final m = mission;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '${m.year}',
                style: TextStyle(fontFamily: headingFont, fontSize: 22, fontWeight: FontWeight.w700,
                  color: p.accentText,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(m.name,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: p.text)),
              ),
              FavoriteButton(favoriteKey: missionKey(m.id)),
            ],
          ),
          Text('${m.agency} · ${loc.formatMediumDate(m.date)}',
              style: TextStyle(fontSize: 12, color: p.muted)),
          const SizedBox(height: 8),
          Text(missionText(l, m.id),
              style: TextStyle(fontSize: 14, color: p.text, height: 1.4)),
        ],
      ),
    );
  }
}
