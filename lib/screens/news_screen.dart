import 'package:flutter/material.dart';

import '../data/online_service.dart';
import '../l10n/names.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// The latest space news from the Spaceflight News API. Only text is
/// downloaded; an article opens on the publisher's own website.
class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final state = AppScope.read(context);
      if (state.settings.onlineFeatures) {
        state.online.refreshNews();
      }
    });
  }

  Future<void> _turnOn() async {
    final state = AppScope.read(context);
    await state.setOnlineFeatures(true);
    await state.online.refreshNews(force: true);
  }

  Future<void> _open(NewsItem item) async {
    final messenger = ScaffoldMessenger.of(context);
    final failed = context.l10n.newsOpenFailed;
    final bridge = AppScope.read(context).bridge;
    final opened = await bridge.openUrl(item.url);
    if (!opened && mounted) {
      messenger.showSnackBar(SnackBar(content: Text(failed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final state = AppScope.of(context);
    final online = state.online;
    final on = state.settings.onlineFeatures;

    return ListenableBuilder(
      listenable: online,
      builder: (context, _) {
        final items = online.news;
        final loc = MaterialLocalizations.of(context);

        final Widget body;
        if (!on && items.isEmpty) {
          body = ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(Icons.newspaper_outlined,
                        size: 48, color: p.accentText),
                    const SizedBox(height: 12),
                    Text(l.newsNeedsOnline,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15, color: p.text, height: 1.4)),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _turnOn,
                      child: Text(l.turnOnOnline),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else if (items.isEmpty) {
          body = ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(Icons.newspaper_outlined,
                        size: 48, color: p.accentText),
                    const SizedBox(height: 12),
                    if (online.loadingNews)
                      const Center(child: CircularProgressIndicator())
                    else ...<Widget>[
                      Text(l.newsNone,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15, color: p.text, height: 1.4)),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => online.refreshNews(force: true),
                        child: Text(l.tryAgain),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        } else {
          body = RefreshIndicator(
            onRefresh: () =>
                on ? online.refreshNews(force: true) : Future<void>.value(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: <Widget>[
                if (online.newsFailed) ...<Widget>[
                  Text(l.newsFailed,
                      style: TextStyle(fontSize: 13, color: p.bad)),
                  const SizedBox(height: 12),
                ],
                for (final item in items) ...<Widget>[
                  _NewsCard(
                    item: item,
                    dateText: loc.formatMediumDate(item.published.toLocal()),
                    onTap: () => _open(item),
                  ),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 8),
                Text(l.newsNote,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: p.muted)),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(l.newsTitle),
            actions: <Widget>[
              if (on && items.isNotEmpty)
                IconButton(
                  tooltip: l.tryAgain,
                  onPressed: online.loadingNews
                      ? null
                      : () => online.refreshNews(force: true),
                  icon: const Icon(Icons.refresh),
                ),
            ],
          ),
          body: body,
        );
      },
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard(
      {required this.item, required this.dateText, required this.onTap});

  final NewsItem item;
  final String dateText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final source = item.site.isEmpty ? dateText : '${item.site} · $dateText';
    return Semantics(
      button: true,
      label: '${item.title}, $source',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SurfaceCard(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(source,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: p.accentText)),
              const SizedBox(height: 4),
              Text(item.title,
                  style: headingStyle(17, p.text, height: 1.25)),
              if (item.summary.isNotEmpty) ...<Widget>[
                const SizedBox(height: 6),
                Text(item.summary,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 14, height: 1.4, color: p.muted)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
