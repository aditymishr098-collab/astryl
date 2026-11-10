import 'package:flutter/material.dart';

import '../core/spacecraft.dart';
import '../data/favorites.dart';
import '../data/missions.dart';
import '../data/planets.dart';
import '../l10n/names.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/favorite_button.dart';
import 'missions_screen.dart';
import 'planet_screen.dart';
import 'spacecraft_screen.dart';

/// Search over planets, moons, missions and spacecraft. While nothing is
/// typed it shows the favourites.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openBody(Planet planet) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => PlanetScreen(planet: planet)),
    );
  }

  /// The names a body can be found by: its name in the app language and in
  /// English.
  List<String> _bodyNames(Planet planet) {
    final l = context.l10n;
    return <String>[planetName(l, planet), planet.id];
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final state = AppScope.of(context);
    final query = _controller.text;
    final searching = foldText(query).isNotEmpty;

    final bodies = <Planet>[];
    final foundMissions = <Mission>[];
    final foundCraft = <Spacecraft>[];
    if (searching) {
      for (final b in allBodies) {
        if (matchesQuery(query, _bodyNames(b))) {
          bodies.add(b);
        }
      }
      for (final m in missions) {
        if (matchesQuery(query, <String>[m.name, m.agency])) {
          foundMissions.add(m);
        }
      }
      for (final c in spacecraft) {
        if (matchesQuery(query, <String>[c.name])) {
          foundCraft.add(c);
        }
      }
    } else {
      // Favourites, in the order they were starred.
      for (final key in state.settings.favorites) {
        if (key.startsWith('mission:')) {
          for (final m in missions) {
            if (missionKey(m.id) == key) {
              foundMissions.add(m);
            }
          }
        } else if (key.startsWith('craft:')) {
          for (final c in spacecraft) {
            if (craftKey(c.id) == key) {
              foundCraft.add(c);
            }
          }
        } else {
          for (final b in allBodies) {
            if (b.id == key) {
              bodies.add(b);
            }
          }
        }
      }
    }
    final empty = bodies.isEmpty && foundMissions.isEmpty && foundCraft.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          style: TextStyle(fontSize: 18, color: p.text),
          decoration: InputDecoration(
            hintText: l.searchHint,
            hintStyle: TextStyle(color: p.muted),
            border: InputBorder.none,
          ),
          onChanged: (_) => setState(() {}),
        ),
        actions: <Widget>[
          if (searching)
            IconButton(
              tooltip: l.searchClear,
              icon: const Icon(Icons.close),
              onPressed: () {
                _controller.clear();
                setState(() {});
              },
            ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: <Widget>[
              if (!searching) SectionLabel(l.favoritesTitle),
              if (empty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    searching ? l.searchEmpty(query.trim()) : l.favoritesEmpty,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: p.muted, height: 1.4),
                  ),
                ),
              if (bodies.isNotEmpty) ...<Widget>[
                if (searching) SectionLabel(l.searchBodies),
                for (final b in bodies) ...<Widget>[
                  _BodyTile(planet: b, onTap: () => _openBody(b)),
                  const SizedBox(height: 8),
                ],
              ],
              if (foundMissions.isNotEmpty) ...<Widget>[
                if (searching) SectionLabel(l.searchMissions),
                for (final m in foundMissions) ...<Widget>[
                  MissionCard(mission: m),
                  const SizedBox(height: 8),
                ],
              ],
              if (foundCraft.isNotEmpty) ...<Widget>[
                if (searching) SectionLabel(l.searchSpacecraft),
                for (final c in foundCraft) ...<Widget>[
                  SpacecraftCard(craft: c),
                  const SizedBox(height: 8),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BodyTile extends StatelessWidget {
  const _BodyTile({required this.planet, required this.onTap});

  final Planet planet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    return Semantics(
      button: true,
      label: planetName(l, planet),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SurfaceCard(
          padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
          child: Row(
            children: <Widget>[
              PlanetBall(planet: planet, size: 40),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(planetName(l, planet),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: p.text)),
                    Text(bodySubtitle(l, planet),
                        style: TextStyle(fontSize: 12, color: p.muted)),
                  ],
                ),
              ),
              FavoriteButton(favoriteKey: planet.id),
            ],
          ),
        ),
      ),
    );
  }
}
