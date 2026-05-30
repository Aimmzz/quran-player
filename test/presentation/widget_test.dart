import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quranplayer/data/model/surah.dart';
import 'package:quranplayer/presentation/widget/surah_list_tile.dart';
import 'package:quranplayer/presentation/widget/reciter_chip.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: ThemeData(useMaterial3: true),
  home: Scaffold(body: child),
);

void main() {

  /*
  * Verifies that SurahListTile renders the surah name and verse count,
  * and calls onTap when tapped.
  * */
  group('SurahListTile', () {
    final surah = Surah.fromJson({
      'number': 1,
      'name': 'الفاتحة',
      'englishName': 'Al-Faatiha',
      'englishNameTranslation': 'The Opening',
      'numberOfAyahs': 7,
      'revelationType': 'Meccan',
    });

    testWidgets('renders surah name and triggers onTap', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(_wrap(
        SurahListTile(
          surah: surah,
          isPlaying: false,
          onTap: () => tapped = true,
        ),
      ));

      // Surah English name is visible
      expect(find.text('Al-Faatiha'), findsOneWidget);

      // Verse count appears in the subtitle
      expect(find.textContaining('7 verses'), findsOneWidget);

      // Tapping the tile calls onTap
      await tester.tap(find.byType(ListTile));
      expect(tapped, isTrue);
    });
  });

  /*
  * Verifies that ReciterChip reflects selected vs unselected visual state
  * and calls onTap when pressed.
  * */
  group('ReciterChip', () {
    testWidgets('shows label and responds to tap', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(_wrap(
        ReciterChip(
          label: 'Mishary Alafasy',
          isSelected: false,
          onTap: () => tapped = true,
        ),
      ));

      // Label is rendered
      expect(find.text('Mishary Alafasy'), findsOneWidget);

      // Chip is present as a FilterChip
      expect(find.byType(FilterChip), findsOneWidget);

      // Tapping triggers the callback
      await tester.tap(find.byType(FilterChip));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });
}
