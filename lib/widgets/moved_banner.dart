import 'package:flutter/material.dart';

import '../screens/learn_screen.dart' show bi;
import '../state/app_state.dart';
import '../theme.dart';

/// The website that carries Astryl on.
const String astrylSite = 'https://astryl.space';

/// Tells people that Astryl now lives on the website and the app will not
/// get new versions. The app keeps working, and the account is the same on
/// the website.
class MovedBanner extends StatelessWidget {
  const MovedBanner({super.key});

  Future<void> _open(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final failed = bi(context, 'Could not open the browser. Go to astryl.space', 'Browser नहीं खुल सका। astryl.space पर जाइए');
    final ok = await AppScope.read(context).bridge.openUrl(astrylSite);
    if (!ok) {
      messenger.showSnackBar(SnackBar(content: Text(failed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      decoration: BoxDecoration(
        color: p.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: p.accent.withValues(alpha: 0.45)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Row(children: <Widget>[
          Icon(Icons.public, color: p.accent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(bi(context, 'Astryl is now on the website', 'Astryl अब website पर है'),
                style: headingStyle(16, p.text)),
          ),
        ]),
        const SizedBox(height: 6),
        Text(
          bi(context,
              'This app will not get new versions. It keeps working, but everything new is at astryl.space: the ISS passes over your city, NASA’s photo of the day, lessons, quizzes and more. Log in there with the same username and password.',
              'इस app के नए version नहीं आएँगे। यह चलता रहेगा, पर सब कुछ नया astryl.space पर है: आपके शहर के ऊपर से ISS कब गुज़रेगा, NASA की आज की तस्वीर, पाठ, quiz और भी बहुत कुछ। वहाँ इसी username और password से log in कीजिए।'),
          style: TextStyle(fontSize: 13, height: 1.4, color: p.text),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => _open(context),
            icon: const Icon(Icons.open_in_new, size: 18),
            label: Text(bi(context, 'Open astryl.space', 'astryl.space खोलें')),
          ),
        ),
      ]),
    );
  }
}
