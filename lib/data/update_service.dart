import 'dart:convert';
import 'dart:io';

/// A release published on GitHub.
class UpdateInfo {
  const UpdateInfo({
    required this.tag,
    required this.notes,
    required this.pageUrl,
    this.apkUrl,
  });

  /// For example "v1.0.1".
  final String tag;
  final String notes;
  final String pageUrl;

  /// Direct link to the signed APK, when the release has one.
  final String? apkUrl;

  String get version => tag.startsWith('v') ? tag.substring(1) : tag;

  String get downloadUrl => apkUrl ?? pageUrl;
}

/// Looks up the newest release of Heliora on GitHub. This is the only network
/// call the app makes, and it sends nothing about the user.
class UpdateService {
  static const String releasesPage =
      'https://github.com/aditymishr098-collab/heliora/releases';
  static const String _api =
      'https://api.github.com/repos/aditymishr098-collab/heliora/releases/latest';

  /// Throws on network or format errors.
  Future<UpdateInfo> latest() async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);
    try {
      final request = await client.getUrl(Uri.parse(_api));
      request.headers.set('Accept', 'application/vnd.github+json');
      request.headers.set('User-Agent', 'Heliora');
      final response =
          await request.close().timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        await response.drain<void>();
        throw HttpException('GitHub answered ${response.statusCode}');
      }
      final body = await response
          .transform(utf8.decoder)
          .join()
          .timeout(const Duration(seconds: 15));
      return parse(body);
    } finally {
      client.close(force: true);
    }
  }

  /// True when [url] is a GitHub https link, the only place updates come from.
  static bool isTrustedDownload(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.scheme == 'https' && uri.host == 'github.com';
  }

  /// Downloads the APK at [url] to [path] and reports progress from 0 to 1.
  /// Writes to a ".part" file first, so a broken download is never installed.
  /// Throws on any problem.
  Future<void> download(
    String url,
    String path,
    void Function(double progress) onProgress,
  ) async {
    if (!isTrustedDownload(url)) {
      throw const HttpException('Unexpected download link');
    }
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);
    final part = File('$path.part');
    try {
      final request = await client.getUrl(Uri.parse(url));
      request.headers.set('User-Agent', 'Heliora');
      final response =
          await request.close().timeout(const Duration(seconds: 20));
      if (response.statusCode != 200) {
        await response.drain<void>();
        throw HttpException('GitHub answered ${response.statusCode}');
      }
      final total = response.contentLength;
      var received = 0;
      final sink = part.openWrite();
      try {
        await for (final chunk
            in response.timeout(const Duration(seconds: 30))) {
          sink.add(chunk);
          received += chunk.length;
          if (total > 0) {
            onProgress(received / total);
          }
        }
      } finally {
        await sink.close();
      }
      if (total > 0 && received != total) {
        throw const HttpException('Download was cut off');
      }
      if (received < 1000000) {
        throw const HttpException('File is too small to be the app');
      }
      await part.rename(path);
    } on Exception {
      if (part.existsSync()) {
        part.deleteSync();
      }
      rethrow;
    } finally {
      client.close(force: true);
    }
  }

  /// Reads the GitHub "latest release" JSON.
  static UpdateInfo parse(String body) {
    final json = jsonDecode(body);
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Unexpected response');
    }
    final tag = json['tag_name'];
    if (tag is! String || tag.isEmpty) {
      throw const FormatException('No tag');
    }
    String? apk;
    final assets = json['assets'];
    if (assets is List) {
      for (final asset in assets) {
        if (asset is Map<String, dynamic>) {
          final name = asset['name'];
          final url = asset['browser_download_url'];
          if (name is String &&
              name.toLowerCase().endsWith('.apk') &&
              url is String &&
              url.startsWith('https://')) {
            apk = url;
            break;
          }
        }
      }
    }
    final page = json['html_url'];
    var notes = json['body'] is String ? (json['body'] as String).trim() : '';
    if (notes.length > 600) {
      notes = '${notes.substring(0, 600)}…';
    }
    return UpdateInfo(
      tag: tag,
      notes: notes,
      pageUrl: page is String && page.startsWith('https://')
          ? page
          : releasesPage,
      apkUrl: apk,
    );
  }
}
