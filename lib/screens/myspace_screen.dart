import 'package:flutter/material.dart';

import '../data/learn_data.dart';
import '../data/planets.dart';
import '../l10n/names.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'learn_screen.dart';
import 'planet_screen.dart';

/// Things to see with your own eyes for the "I've seen it" list:
/// id, icon, English, Hindi.
const List<(String, String, String, String)> seenThings = <(String, String, String, String)>[
  ('moon', '🌙', 'The Moon', 'चाँद'), ('venus', '✨', 'Venus', 'शुक्र'), ('jupiter', '🪐', 'Jupiter', 'बृहस्पति'), ('saturn', '🪐', 'Saturn', 'शनि'),
  ('mars', '🔴', 'Mars', 'मंगल'), ('mercury', '☿', 'Mercury', 'बुध'), ('iss', '🛰️', 'The space station (ISS)', 'अंतरिक्ष स्टेशन (ISS)'), ('meteor', '☄️', 'A shooting star', 'टूटता तारा'),
  ('orion', '⭐', 'Orion', 'ओरायन (मृग)'), ('bigdipper', '⭐', 'The Big Dipper (Saptarishi)', 'सप्तर्षि'), ('polaris', '🧭', 'Polaris, the Pole Star', 'ध्रुव तारा'), ('pleiades', '✨', 'The Pleiades (Krittika)', 'कृत्तिका'),
  ('milkyway', '🌌', 'The Milky Way band', 'आकाशगंगा की पट्टी'), ('andromeda', '🌀', 'The Andromeda Galaxy', 'एंड्रोमेडा galaxy'), ('lunareclipse', '🌑', 'A lunar eclipse', 'चंद्र ग्रहण'), ('solareclipse', '🌞', 'A solar eclipse (safely!)', 'सूर्य ग्रहण (सुरक्षित तरीके से!)'),
];

/// My space: favourites, scores, badges, lessons to read next and the
/// "I've seen it" list, all in one place.
class MySpaceScreen extends StatelessWidget {
  const MySpaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final state = AppScope.of(context);
    final s = state.settings;
    final l = context.l10n;
    TextStyle h(double size) => TextStyle(fontFamily: headingFont, fontSize: size, fontWeight: FontWeight.w700, color: p.text);
    Widget card(String title, List<Widget> children) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: SurfaceCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[Text(title, style: h(18)), const SizedBox(height: 10), ...children]),
          ),
        );
    Widget score(String label, int v, int of) => Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 6),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: p.surfaceHigh, borderRadius: BorderRadius.circular(12)),
            child: Column(children: <Widget>[
              Text(v > 0 ? '$v/$of' : '–', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: p.text)),
              Text(label, style: TextStyle(fontSize: 12, color: p.muted)),
            ]),
          ),
        );

    return Scaffold(
      appBar: AppBar(title: Text(bi(context, 'My space', 'My space'), style: const TextStyle(fontWeight: FontWeight.w700))),
      body: FutureBuilder<LearnData>(
        future: LearnData.load(),
        builder: (context, snap) {
          final data = snap.data;
          final read = s.readLessons.toSet();
          final next = <(Lesson, int)>[];
          if (data != null) {
            for (final g in data.groups) {
              for (final (i, lesson) in g.lessons.indexed) {
                if (!read.contains(lesson.key) && next.length < 3) {
                  next.add((lesson, i));
                }
              }
            }
          }
          final bh = data?.group('blackholes');
          final bhRead = bh == null ? 0 : bh.lessons.where((x) => read.contains(x.key)).length;
          final bhTotal = bh?.lessons.length ?? 7;
          final dsBh = s.quizBests['ds-bh'] ?? 0;
          final seenCount = s.seen.length;
          final favs = <Planet>[for (final f in s.favorites) ...<Planet>[...planets, ...otherBodies].where((pl) => pl.id == f)];
          final badges = <(String, String, String, bool)>[
            ('⚫', 'Black hole explorer', 'ब्लैक होल explorer', bhRead >= bhTotal && dsBh >= bh101QuizNeeded),
            ('📚', 'Read 10 lessons', '10 पाठ पढ़े', read.length >= 10),
            ('🎓', 'Read all 20 lessons', 'सभी 20 पाठ पढ़े', read.length >= 20),
            ('🧠', 'Planet quiz: hard 10/10', 'ग्रह quiz: कठिन 10/10', s.bestFor('hard') >= 10),
            ('⭐', 'First favourite', 'पहला favourite', s.favorites.isNotEmpty),
            ('👀', 'Seen 5 things', '5 चीज़ें देखीं', seenCount >= 5),
            ('🔭', 'Seen 10 things', '10 चीज़ें देखीं', seenCount >= 10),
            ('🌌', 'Seen them all', 'सब देख लिया', seenCount >= seenThings.length),
            ('🔥', '7-day quiz streak', '7 दिन की quiz streak', (s.quizBests['streak'] ?? 0) >= 7),
          ];
          final got = badges.where((b) => b.$4).length;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            children: <Widget>[
              card('🧭 ${bi(context, 'Next for you', 'आपके लिए अगला')}', <Widget>[
                if (data == null) const Center(child: CircularProgressIndicator()),
                if (data != null && next.isEmpty) Text(bi(context, 'You have read every lesson. Wow!', 'आपने हर पाठ पढ़ लिया। वाह!'), style: TextStyle(color: p.text)),
                for (final n in next)
                  LearnTile(
                    icon: Icons.article_outlined,
                    title: n.$1.title.of(context),
                    sub: n.$1.lead.of(context),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => LessonScreen(groupId: n.$1.groupId, index: n.$2))),
                  ),
                Text(bi(context, '${read.length} lessons read', '${read.length} पाठ पढ़े'), style: TextStyle(fontSize: 13, color: p.muted)),
              ]),
              card('⭐ ${bi(context, 'Favourites', 'Favourites')}', <Widget>[
                if (favs.isEmpty)
                  Text(bi(context, 'No favourite planets yet. Tap the star on any planet or moon.', 'अभी कोई favourite ग्रह नहीं। किसी भी ग्रह या चाँद पर star दबाइए।'), style: TextStyle(color: p.muted)),
                Wrap(spacing: 8, runSpacing: 8, children: <Widget>[
                  for (final f in favs)
                    ActionChip(
                      label: Text('★ ${planetName(l, f)}'),
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => PlanetScreen(planet: f))),
                    ),
                ]),
              ]),
              card('🏅 ${bi(context, 'Best scores', 'सबसे अच्छे score')}', <Widget>[
                Text(bi(context, 'Planet quiz', 'ग्रहों की quiz'), style: TextStyle(color: p.muted)),
                const SizedBox(height: 6),
                Row(children: <Widget>[
                  score(bi(context, 'Easy', 'आसान'), s.bestFor('easy'), 10),
                  score(bi(context, 'Medium', 'मध्यम'), s.bestFor('medium'), 10),
                  score(bi(context, 'Hard', 'कठिन'), s.bestFor('hard'), 10),
                ]),
                const SizedBox(height: 10),
                Text(bi(context, 'Black hole and galaxy quiz', 'ब्लैक होल और galaxy quiz'), style: TextStyle(color: p.muted)),
                const SizedBox(height: 6),
                Row(children: <Widget>[
                  score(bi(context, 'Black holes', 'ब्लैक होल'), dsBh, 5),
                  score(bi(context, 'Galaxies', 'Galaxies'), s.quizBests['ds-gx'] ?? 0, 5),
                  score(bi(context, 'Mixed', 'मिला-जुला'), s.quizBests['ds-all'] ?? 0, 5),
                ]),
              ]),
              card('⚫ ${bi(context, 'Black holes 101', 'Black holes 101')}', <Widget>[
                ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: bhRead / bhTotal, minHeight: 8)),
                const SizedBox(height: 6),
                Text(bi(context, '$bhRead of $bhTotal lessons read', '$bhTotal में से $bhRead पाठ पढ़े'), style: TextStyle(color: p.text)),
              ]),
              card('👀 ${bi(context, 'I\'ve seen it', 'मैंने देखा')}', <Widget>[
                ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: seenCount / seenThings.length, minHeight: 8)),
                const SizedBox(height: 6),
                Text(bi(context, '$seenCount of ${seenThings.length} seen. Tap what you have seen with your own eyes (binoculars count).', '${seenThings.length} में से $seenCount देखे। जो अपनी आँखों से देखा है उस पर tap कीजिए (दूरबीन भी चलेगी)।'),
                    style: TextStyle(fontSize: 13, color: p.muted)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: <Widget>[
                  for (final t in seenThings)
                    FilterChip(
                      label: Text('${t.$2} ${bi(context, t.$3, t.$4)}'),
                      selected: s.seen.containsKey(t.$1),
                      onSelected: (_) => state.toggleSeen(t.$1),
                    ),
                ]),
              ]),
              card('🎖️ ${bi(context, 'Badges', 'Badges')}', <Widget>[
                Wrap(spacing: 8, runSpacing: 8, children: <Widget>[
                  for (final b in badges)
                    Opacity(
                      opacity: b.$4 ? 1 : 0.45,
                      child: Chip(label: Text('${b.$1} ${bi(context, b.$2, b.$3)}')),
                    ),
                ]),
                const SizedBox(height: 6),
                Text(bi(context, '$got of ${badges.length} badges', '${badges.length} में से $got badges'), style: TextStyle(fontSize: 13, color: p.muted)),
              ]),
            ],
          );
        },
      ),
    );
  }
}
