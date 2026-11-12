import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/main.dart';

Future<void> start(
  WidgetTester tester, {
  Size size = const Size(390, 844),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(MyApp(prefs: prefs));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    for (final family in ['Manrope', 'Cormorant']) {
      final loader = FontLoader(family);
      for (final weight
          in family == 'Manrope'
              ? [400, 500, 600, 700, 800]
              : [500, 600, 700]) {
        loader.addFont(
          rootBundle.load(
            'assets/fonts/${family == 'Manrope' ? 'Manrope' : 'CormorantGaramond'}-normal-$weight.ttf',
          ),
        );
      }
      await loader.load();
    }
  });
  testWidgets('Mobile home shows brand, photo hero and five navigation tabs', (
    tester,
  ) async {
    await start(tester);
    expect(find.text('DA GOLDEN HEAVEN'), findsOneWidget);
    expect(find.text('UTAMA'), findsOneWidget);
    expect(find.text('JAGAAN'), findsWidgets);
    expect(find.text('SUMBANG'), findsOneWidget);
    expect(find.text('LAWATAN'), findsWidgets);
    expect(find.text('AKAUN'), findsOneWidget);
    expect(find.byType(Photo), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Services tab opens care cards with supplied photographs', (
    tester,
  ) async {
    await start(tester);
    await tester.tap(find.text('JAGAAN').last);
    await tester.pumpAndSettle();
    expect(find.text('Jagaan Penuh Hormat'), findsOneWidget);
    expect(find.text('Jagaan Warga Emas'), findsOneWidget);
    await tester.tap(find.text('Jagaan Warga Emas'));
    await tester.pumpAndSettle();
    expect(find.text('PENJAGAAN PENUH HORMAT'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Donation search and category filter update visible items', (
    tester,
  ) async {
    await start(tester);
    await tester.tap(find.text('SUMBANG'));
    await tester.pumpAndSettle();
    expect(find.text('6 keperluan'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Lampin');
    await tester.pumpAndSettle();
    expect(find.text('1 keperluan'), findsOneWidget);
    expect(find.text('Lampin Dewasa (Saiz L)'), findsOneWidget);
    expect(find.text('Tisu Basah Dewasa'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Visit booking validates required fields', (tester) async {
    await start(tester);
    await tester.tap(find.text('LAWATAN').last);
    await tester.pumpAndSettle();
    expect(find.text('Datang & Kenali Kami'), findsOneWidget);
    await tester.ensureVisible(find.text('Simpan Permintaan Lawatan'));
    await tester.tap(find.text('Simpan Permintaan Lawatan'));
    await tester.pumpAndSettle();
    expect(find.text('Sila isi nama penuh'), findsOneWidget);
    expect(find.text('Sila isi no. telefon'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Account explains local records and unconfigured authentication',
    (tester) async {
      await start(tester);
      await tester.tap(find.text('AKAUN'));
      await tester.pumpAndSettle();
      expect(find.text('Belum ada rekod'), findsOneWidget);
      await tester.tap(find.text('Portal Waris'));
      await tester.pumpAndSettle();
      expect(find.text('Akses Selamat'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Small 320px viewport renders without overflow', (tester) async {
    await start(tester, size: const Size(320, 740));
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('SUMBANG'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Donation reservation persists locally and opens in My Records', (
    tester,
  ) async {
    await start(tester);
    await tester.tap(find.text('SUMBANG'));
    await tester.pumpAndSettle();
    final donate = find.text('Sumbang').first;
    await tester.ensureVisible(donate);
    await tester.tap(donate);
    await tester.pumpAndSettle();
    final reserve = find.text('Tempah 1 pek');
    await tester.ensureVisible(reserve);
    await tester.tap(reserve);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Ahmad');
    await tester.enterText(find.byType(TextFormField).at(1), '0123456789');
    await tester.ensureVisible(find.text('Simpan Tempahan'));
    await tester.tap(find.text('Simpan Tempahan'));
    await tester.pumpAndSettle();
    expect(find.text('Tempahan Disimpan'), findsWidgets);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('dgh_records'), contains('Ahmad'));
    await tester.ensureVisible(find.text('Lihat Rekod Saya'));
    await tester.tap(find.text('Lihat Rekod Saya'));
    await tester.pumpAndSettle();
    expect(find.text('Draf Tempahan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Compact desktop breakpoint fits all navigation items', (
    tester,
  ) async {
    await start(tester, size: const Size(1024, 900));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Desktop layout renders responsive hero', (tester) async {
    await start(tester, size: const Size(1440, 1000));
    expect(find.text('SSM 202603291886'), findsOneWidget);
    expect(find.text('Perkhidmatan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
