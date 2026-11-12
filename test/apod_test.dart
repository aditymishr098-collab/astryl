import 'package:flutter_test/flutter_test.dart';
import 'package:heliora/data/online_service.dart';

void main() {
  group('space photo of the day', () {
    test('reads the server answer and keeps only NASA pictures', () {
      final a = Apod.fromJson(<String, dynamic>{
        'date': '2026-11-11',
        'title': 'Dwarf Galaxy NGC 4449',
        'explanation': 'A small galaxy.',
        'media': 'image',
        'url': 'https://apod.nasa.gov/apod/image/2611/x_1024.jpg',
        'hdurl': 'https://example.com/big.jpg',
        'copyright': 'NASA, ESA',
        'page': 'https://apod.nasa.gov/apod/ap261111.html',
      }, fetchedAtMs: 5)!;
      expect(a.isImage, isTrue);
      expect(a.hdUrl, '');
      expect(a.fetchedAtMs, 5);
      final back = Apod.fromJson(a.toJson())!;
      expect(back.title, a.title);
      expect(back.url, a.url);
      expect(back.fetchedAtMs, 5);
    });

    test('a video day has no picture, and bad answers are refused', () {
      final v = Apod.fromJson(<String, dynamic>{'date': '2026-11-12', 'title': 'A video', 'url': 'https://www.youtube.com/embed/x'})!;
      expect(v.isImage, isFalse);
      expect(v.page, 'https://apod.nasa.gov/apod/');
      expect(Apod.fromJson(<String, dynamic>{'title': 'No date'}), isNull);
      expect(Apod.fromJson(<String, dynamic>{'date': '2026-11-12', 'title': ' '}), isNull);
      expect(Apod.fromJson('nope'), isNull);
    });

    test('NASA and the Astryl server are the only new hosts', () {
      expect(OnlineService.trustedHosts, contains('apod.nasa.gov'));
      expect(OnlineService.trustedHosts, contains('pmfjjlfggzihbnbmqkao.supabase.co'));
    });
  });
}
