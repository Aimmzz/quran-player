import 'package:flutter_test/flutter_test.dart';
import 'package:quranplayer/core/utils/app_utils.dart';
import 'package:quranplayer/data/model/surah.dart';

void main() {
  // Verifies that SurahModel correctly parses a JSON response from the API.
  group('SurahModel.fromJson', () {
    test('parses all fields from API JSON correctly', () {
      const json = {
        'number': 1,
        'name': 'الفاتحة',
        'englishName': 'Al-Faatiha',
        'englishNameTranslation': 'The Opening',
        'numberOfAyahs': 7,
        'revelationType': 'Meccan',
      };

      final surah = Surah.fromJson(json);

      expect(surah.number, 1);
      expect(surah.englishName, 'Al-Faatiha');
      expect(surah.englishNameTranslation, 'The Opening');
      expect(surah.numberOfAyahs, 7);
      expect(surah.revelationType, 'Meccan');
    });
  });

  // Verifies that AppUtils.formatDuration produces correct mm:ss strings.
  group('AppUtils.formatDuration', () {
    test('formats duration into padded mm:ss string', () {
      expect(AppUtils.formatDuration(Duration.zero), '00:00');
      expect(AppUtils.formatDuration(const Duration(seconds: 125)), '02:05');
    });
  });
}
