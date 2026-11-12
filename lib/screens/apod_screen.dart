import 'package:flutter/material.dart';

import '../data/online_service.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'learn_screen.dart' show bi;

/// "Space photo of the day" card for the home screen: NASA's Astronomy
/// Picture of the Day. The last one is kept on the phone, so it still shows
/// offline. A tap opens the full picture and NASA's description.
class DailyPhotoCard extends StatefulWidget {
  const DailyPhotoCard({super.key});

  @override
  State<DailyPhotoCard> createState() => _DailyPhotoCardState();
}

class _DailyPhotoCardState extends State<DailyPhotoCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final state = AppScope.read(context);
      if (state.settings.onlineFeatures) {
        state.online.refreshApod();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final online = AppScope.of(context).online;
    return ListenableBuilder(
      listenable: online,
      builder: (context, _) {
        final apod = online.apod;
        final image = online.apodImage;
        final title = Row(children: <Widget>[
          Icon(Icons.photo_camera_outlined, size: 20, color: p.accent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(bi(context, 'Space photo of the day', 'आज की अंतरिक्ष तस्वीर'),
                style: headingStyle(17, p.text)),
          ),
          if (online.loadingApod)
            const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
        ]);
        if (apod == null) {
          return SurfaceCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              title,
              const SizedBox(height: 8),
              Text(
                online.apodFailed
                    ? bi(context, 'Could not load today’s photo. It needs the internet once.', 'आज की तस्वीर load नहीं हो पाई। इसके लिए एक बार internet चाहिए।')
                    : bi(context, 'Loading NASA’s photo of the day…', 'NASA की आज की तस्वीर load हो रही है…'),
                style: TextStyle(color: p.muted),
              ),
              if (online.apodFailed)
                TextButton(
                  onPressed: () => online.refreshApod(force: true),
                  child: Text(bi(context, 'Try again', 'फिर कोशिश करें')),
                ),
            ]),
          );
        }
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const ApodScreen())),
          child: SurfaceCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              title,
              const SizedBox(height: 10),
              if (image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Image.memory(image, fit: BoxFit.cover, gaplessPlayback: true,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                  ),
                )
              else if (!apod.isImage)
                Text(bi(context, '🎬 Today it is a video. Open it on NASA’s page.', '🎬 आज यह एक video है। इसे NASA के page पर खोलिए।'),
                    style: TextStyle(color: p.muted)),
              const SizedBox(height: 8),
              Text(apod.title, style: TextStyle(fontWeight: FontWeight.w700, color: p.text)),
              Text(apod.explanation, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: p.muted)),
            ]),
          ),
        );
      },
    );
  }
}

/// The full space photo of the day: zoomable picture, title, credit and
/// NASA's description (in English).
class ApodScreen extends StatelessWidget {
  const ApodScreen({super.key});

  Future<void> _open(BuildContext context, String url) async {
    final messenger = ScaffoldMessenger.of(context);
    final failed = bi(context, 'Could not open the page.', 'Page नहीं खुल सका।');
    final ok = await AppScope.read(context).bridge.openUrl(url);
    if (!ok) {
      messenger.showSnackBar(SnackBar(content: Text(failed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final online = AppScope.of(context).online;
    return Scaffold(
      appBar: AppBar(title: Text(bi(context, 'Space photo of the day', 'आज की अंतरिक्ष तस्वीर'), style: const TextStyle(fontWeight: FontWeight.w700))),
      body: ListenableBuilder(
        listenable: online,
        builder: (context, _) {
          final Apod? apod = online.apod;
          final image = online.apodImage;
          if (apod == null) {
            return Center(child: Text(bi(context, 'No photo yet.', 'अभी कोई तस्वीर नहीं।'), style: TextStyle(color: p.muted)));
          }
          final day = DateTime.tryParse(apod.date);
          return RefreshIndicator(
            onRefresh: () => online.refreshApod(force: true),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: <Widget>[
                if (image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: InteractiveViewer(
                      maxScale: 5,
                      child: Image.memory(image, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                    ),
                  ),
                if (image != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(bi(context, 'Pinch to zoom', 'Zoom करने के लिए दो उँगलियों से फैलाइए'), style: TextStyle(fontSize: 12, color: p.muted)),
                  ),
                const SizedBox(height: 12),
                Text(apod.title, style: headingStyle(20, p.text)),
                const SizedBox(height: 4),
                Text(
                  <String>[
                    if (day != null) MaterialLocalizations.of(context).formatMediumDate(day),
                    if (apod.copyright.isNotEmpty) '© ${apod.copyright}',
                  ].join(' · '),
                  style: TextStyle(fontSize: 13, color: p.muted),
                ),
                const SizedBox(height: 12),
                Text(apod.explanation, style: TextStyle(height: 1.45, color: p.text)),
                const SizedBox(height: 12),
                Text(bi(context, 'From NASA’s Astronomy Picture of the Day. The description is in English.', 'NASA की Astronomy Picture of the Day से। विवरण अंग्रेज़ी में है।'),
                    style: TextStyle(fontSize: 12, color: p.muted)),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    onPressed: () => _open(context, apod.page),
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: Text(bi(context, 'Open on NASA’s site', 'NASA की site पर खोलें')),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
