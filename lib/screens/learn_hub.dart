import 'package:flutter/material.dart';

import 'constellations_screen.dart';
import 'learn_screen.dart';
import 'myspace_screen.dart';
import 'tools_screens.dart';

/// The Learn section with its tools and My space.
class LearnHub extends StatelessWidget {
  const LearnHub({super.key});

  @override
  Widget build(BuildContext context) {
    return LearnScreen(tools: <Widget>[
      LearnTile(
        icon: Icons.person_pin_outlined,
        title: bi(context, 'My space', 'My space'),
        sub: bi(context, 'Favourites, scores, badges and \u201cI\u2019ve seen it\u201d', 'Favourites, scores, badges और \u201cमैंने देखा\u201d'),
        onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const MySpaceScreen())),
      ),
      LearnTile(
        icon: Icons.auto_awesome_outlined,
        title: bi(context, 'Constellations', 'तारामंडल'),
        sub: bi(context, 'All 88, with the best month and whether India sees them', 'सभी 88, सबसे अच्छे महीने और भारत से दिखने के साथ'),
        onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const ConstellationsScreen())),
      ),
      LearnTile(
        icon: Icons.radio_button_checked,
        title: bi(context, 'Black hole lab', 'ब्लैक होल lab'),
        sub: bi(context, 'Bend starlight, size any black hole, slow a clock', 'तारों की रोशनी मोड़िए, आकार निकालिए, घड़ी धीमी कीजिए'),
        onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const BlackHoleLabScreen())),
      ),
      LearnTile(
        icon: Icons.visibility_outlined,
        title: bi(context, 'Telescope simulator', 'Telescope simulator'),
        sub: bi(context, 'Magnification, field of view and the eyepiece view', 'ज़ूम, दृश्य-क्षेत्र और eyepiece का नज़ारा'),
        onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const TelescopeScreen())),
      ),
    ]);
  }
}
