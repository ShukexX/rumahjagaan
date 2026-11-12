import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

const black = Color(0xFF171411);
const ink = Color(0xFF28231F);
const gold = Color(0xFFC69B43);
const goldLight = Color(0xFFE8C879);
const goldDark = Color(0xFF9A7425);
const cream = Color(0xFFF8F4EC);
const cream2 = Color(0xFFEFE7D8);
const muted = Color(0xFF7A7065);
const line = Color(0xFFE6DCCB);
const green = Color(0xFF27845A);
const address =
    'DA GOLDEN HEAVEN CARE CENTRE\nNO. 18 JALAN MAWAR 2/2\nPERSIARAN AMANJAYA 4\n08000 SUNGAI PETANI\nKEDAH, MALAYSIA';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences? prefs;
  const MyApp({super.key, this.prefs});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'DGH Care Centre',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: cream,
      fontFamily: 'Manrope',
      colorScheme: ColorScheme.fromSeed(
        seedColor: gold,
        primary: goldDark,
        surface: cream,
        onSurface: ink,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 13, height: 1.6, color: ink),
      ),
      dividerColor: line,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: gold, width: 1.5),
        ),
        hintStyle: const TextStyle(fontSize: 13, color: muted),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    home: CareApp(prefs: prefs),
  );
}

TextStyle serif(
  double size, {
  Color color = ink,
  FontWeight weight = FontWeight.w700,
  bool italic = false,
}) => TextStyle(
  fontFamily: 'Cormorant',
  fontSize: size,
  height: 1.08,
  color: color,
  fontWeight: weight,
  fontStyle: italic ? FontStyle.italic : FontStyle.normal,
);

class Eyebrow extends StatelessWidget {
  final String text;
  final Color color;
  const Eyebrow(this.text, {super.key, this.color = goldDark});
  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: TextStyle(
      color: color,
      fontSize: 9,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.8,
    ),
  );
}

class ActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final String variant;
  final bool small;
  const ActionButton(
    this.label, {
    super.key,
    this.icon,
    this.onTap,
    this.variant = 'gold',
    this.small = false,
  });
  @override
  Widget build(BuildContext context) {
    final dark = variant == 'dark';
    final golden = variant == 'gold';
    final ghost = variant == 'ghost';
    final orange = variant == 'orange';
    final foreground = dark || orange
        ? Colors.white
        : ghost
        ? goldLight
        : ink;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(small ? 10 : 12),
        gradient: golden
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFD4AB55), gold],
              )
            : null,
        color: golden
            ? null
            : dark
            ? black
            : orange
            ? const Color(0xFFEE4D2D)
            : ghost
            ? Colors.transparent
            : Colors.white,
        border: Border.all(
          color: golden
              ? gold
              : ghost
              ? const Color(0xFF625137)
              : dark || orange
              ? Colors.transparent
              : line,
        ),
        boxShadow: golden
            ? [
                BoxShadow(
                  color: gold.withValues(alpha: .16),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: small ? 11 : 16,
              vertical: small ? 10 : 14,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: small ? 15 : 17, color: foreground),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: small ? 11 : 12,
                      fontWeight: FontWeight.w700,
                      color: onTap == null ? muted : foreground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final VoidCallback? onTap;
  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.color = Colors.white,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color == black ? black : line),
      boxShadow: [
        BoxShadow(
          color: black.withValues(alpha: .035),
          blurRadius: 16,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    clipBehavior: Clip.antiAlias,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    ),
  );
}

class Photo extends StatelessWidget {
  final String file;
  final double height;
  final double radius;
  final Alignment alignment;
  const Photo(
    this.file, {
    super.key,
    this.height = 160,
    this.radius = 0,
    this.alignment = Alignment.center,
  });
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Image.asset(
      'assets/images/$file',
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
      alignment: alignment,
    ),
  );
}

class Service {
  final String title, description, image;
  final IconData icon;
  const Service(this.title, this.description, this.image, this.icon);
}

const services = [
  Service(
    'Jagaan Warga Emas',
    'Penjagaan harian penuh hormat — makan, kebersihan diri, rehat dan pemantauan oleh penjaga terlatih.',
    'photo-care-group.jpg',
    Icons.favorite_border_rounded,
  ),
  Service(
    'Jagaan OKU',
    'Sokongan peribadi untuk Orang Kurang Upaya mengikut keperluan bantuan dan mobiliti masing-masing.',
    'photo-oku.jpg',
    Icons.volunteer_activism_outlined,
  ),
  Service(
    'Penjagaan Diri Harian',
    'Bantuan mandi, berpakaian, makan dan kebersihan, direkod setiap hari untuk makluman waris.',
    'photo-supplies.png',
    Icons.wb_sunny_outlined,
  ),
  Service(
    'Bantuan Mobiliti',
    'Bantuan berjalan, pemindahan dan tukar posisi untuk keselesaan dan keselamatan.',
    'photo-oku.jpg',
    Icons.accessible_outlined,
  ),
  Service(
    'Aktiviti & Riadah',
    'Senaman ringan, aktiviti santai dan interaksi sosial setiap hari.',
    'photo-care-group.jpg',
    Icons.auto_awesome_outlined,
  ),
  Service(
    'Laporan Kepada Waris',
    'Maklumat aktiviti harian dan rekod penjagaan untuk ketenangan keluarga.',
    'room-lounge.jpg',
    Icons.shield_outlined,
  ),
];
const facilities = [
  ('Ruang Rehat', 'room-lounge.jpg'),
  ('Bilik Tidur', 'room-bedroom.jpg'),
  ('Ruang Makan', 'room-dining.jpg'),
];

class Need {
  final String name, category, unit, spec;
  final int target;
  const Need(this.name, this.category, this.unit, this.spec, this.target);
}

const needs = [
  Need(
    'Lampin Dewasa (Saiz L)',
    'Lampin',
    'pek',
    'Jenis pelekat (tape), saiz L, pek 10 helai',
    30,
  ),
  Need(
    'Tisu Basah Dewasa',
    'Kebersihan',
    'pek',
    'Tanpa alkohol, pek besar',
    20,
  ),
  Need('Susu Tepung Warga Emas', 'Makanan', 'tin', 'Tin 800g, rendah gula', 12),
  Need('Pad Alas Katil Pakai Buang', 'Kebersihan', 'pek', '60 × 90 cm', 15),
  Need(
    'Kerusi Mandi Beralas',
    'Peralatan',
    'unit',
    'Kaki anti-gelincir, boleh laras',
    2,
  ),
  Need('Termometer Digital Dahi', 'Kesihatan', 'unit', 'Tanpa sentuh', 2),
];

class CareApp extends StatefulWidget {
  final SharedPreferences? prefs;
  const CareApp({super.key, this.prefs});
  @override
  State<CareApp> createState() => _CareAppState();
}

class _CareAppState extends State<CareApp> {
  String page = 'Utama';
  String category = 'Semua';
  String search = '';
  final scroll = ScrollController();
  List<Map<String, dynamic>> records = [];
  bool get desktop => MediaQuery.sizeOf(context).width >= 1000;
  @override
  void initState() {
    super.initState();
    final saved = widget.prefs?.getString('dgh_records');
    if (saved != null) {
      try {
        records = List<Map<String, dynamic>>.from(
          (jsonDecode(saved) as List).map((e) => Map<String, dynamic>.from(e)),
        );
      } catch (_) {
        records = [];
      }
    }
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  void navigate(String value) {
    setState(() {
      page = value;
      search = '';
      category = 'Semua';
    });
    if (scroll.hasClients) {
      scroll.jumpTo(0);
    }
  }

  Future<void> save(Map<String, dynamic> record) async {
    setState(() => records.add(record));
    await widget.prefs?.setString('dgh_records', jsonEncode(records));
  }

  void toast(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> openLink(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      if (mounted) {
        toast('Tidak dapat membuka pautan. Sila cuba lagi.');
      }
    }
  }

  void sheet(String title, Widget child) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: cream,
      constraints: const BoxConstraints(maxWidth: 620),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(ctx).height * .86,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 0, 12, 12),
                child: Row(
                  children: [
                    Expanded(child: Text(title, style: serif(27))),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close_rounded, size: 21),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(22),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(desktop ? 80 : 68),
      child: header(),
    ),
    body: SafeArea(
      top: false,
      bottom: false,
      child: SingleChildScrollView(
        controller: scroll,
        child: Column(
          children: [
            if (page == 'Utama' && desktop) desktopHero(),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    desktop ? 32 : 16,
                    desktop ? 32 : 18,
                    desktop ? 32 : 16,
                    32,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: KeyedSubtree(key: ValueKey(page), child: content()),
                  ),
                ),
              ),
            ),
            footer(),
          ],
        ),
      ),
    ),
    bottomNavigationBar: desktop ? null : bottomNav(),
  );
  Widget header() => Container(
    decoration: const BoxDecoration(
      color: black,
      border: Border(bottom: BorderSide(color: Color(0xFF4B3E29))),
    ),
    child: SafeArea(
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: desktop ? 28 : 16),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => navigate('Utama'),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/dgh-mark.png',
                          width: desktop ? 60 : 51,
                          height: 45,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'DA GOLDEN HEAVEN',
                                  style: serif(
                                    desktop ? 17 : 14,
                                    color: goldLight,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'CARE · COMFORT · DIGNITY',
                                  style: TextStyle(
                                    color: Color(0xFFCABE9F),
                                    fontSize: 7,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (desktop) ...[
                  for (final p in [
                    'Utama',
                    'Tentang Kami',
                    'Jagaan',
                    'Kemudahan',
                    'Pakej',
                    'Sumbang',
                    'Care Shop',
                  ])
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: InkWell(
                        onTap: () => navigate(p),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: page == p ? gold : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            p == 'Jagaan'
                                ? 'Perkhidmatan'
                                : p == 'Sumbang'
                                ? 'Sumbangan'
                                : p,
                            style: TextStyle(
                              fontSize: 11,
                              color: page == p ? goldLight : cream,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 24),
                  ActionButton(
                    'Tempah Lawatan',
                    small: true,
                    icon: Icons.calendar_month_outlined,
                    onTap: () => navigate('Lawatan'),
                  ),
                ] else ...[
                  IconButton(
                    tooltip: 'Notifikasi',
                    onPressed: () => sheet(
                      'Notifikasi',
                      const Column(
                        children: [
                          Icon(
                            Icons.notifications_none_rounded,
                            size: 42,
                            color: goldDark,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Tiada notifikasi baharu',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Maklumat dan perkembangan pusat akan dipaparkan di sini.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: muted),
                          ),
                        ],
                      ),
                    ),
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: goldLight,
                      size: 23,
                    ),
                  ),
                  InkWell(
                    onTap: () => navigate('Akaun'),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 33,
                      height: 33,
                      decoration: BoxDecoration(
                        color: const Color(0xFF342D21),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF6A5734)),
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        size: 19,
                        color: goldLight,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );
  Widget bottomNav() {
    const tabs = [
      ('Utama', Icons.home_outlined),
      ('Jagaan', Icons.favorite_border_rounded),
      ('Sumbang', Icons.card_giftcard_outlined),
      ('Lawatan', Icons.calendar_month_outlined),
      ('Akaun', Icons.person_outline_rounded),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 67,
          child: Row(
            children: tabs.map((t) {
              final active = page == t.$1;
              return Expanded(
                child: InkWell(
                  onTap: () => navigate(t.$1),
                  child: Column(
                    children: [
                      Container(
                        width: 28,
                        height: 3,
                        decoration: BoxDecoration(
                          color: active ? gold : Colors.transparent,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Container(
                        width: 46,
                        height: 28,
                        decoration: BoxDecoration(
                          color: active
                              ? gold.withValues(alpha: .14)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          t.$2,
                          size: 22,
                          color: active ? goldDark : muted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t.$1.toUpperCase(),
                        style: TextStyle(
                          color: active ? goldDark : muted,
                          fontSize: 9,
                          letterSpacing: .5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget content() {
    switch (page) {
      case 'Utama':
        return home();
      case 'Jagaan':
        return servicesPage();
      case 'Kemudahan':
        return facilitiesPage();
      case 'Sumbang':
        return donationsPage();
      case 'Lawatan':
        return bookingPage();
      case 'Hubungi':
        return contactPage();
      case 'Tentang Kami':
        return aboutPage();
      case 'Pakej':
        return packagesPage();
      case 'Care Shop':
        return shopPage();
      case 'Kemasukan':
        return admissionPage();
      case 'Jejak':
        return trackingPage();
      default:
        return accountPage();
    }
  }

  Widget sectionHeader(
    String eyebrow,
    String title, {
    String? more,
    VoidCallback? onTap,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Eyebrow(eyebrow),
              const SizedBox(height: 5),
              Text(title, style: serif(desktop ? 34 : 27)),
            ],
          ),
        ),
        if (more != null)
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Text(
                    more,
                    style: const TextStyle(
                      color: goldDark,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: goldDark, size: 16),
                ],
              ),
            ),
          ),
      ],
    ),
  );
  Widget pageHead(String eyebrow, String title, String subtitle) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Eyebrow(eyebrow),
        const SizedBox(height: 8),
        Text(title, style: serif(desktop ? 44 : 33)),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: const TextStyle(color: muted, fontSize: 13, height: 1.7),
        ),
      ],
    ),
  );
  Widget heroCopy({bool large = false}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Eyebrow(
        large
            ? 'Pusat Jagaan Warga Emas & OKU · Sungai Petani, Kedah'
            : 'Care • Comfort • Dignity',
        color: goldLight,
      ),
      SizedBox(height: large ? 20 : 10),
      Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: 'Penjagaan Warga Emas & OKU Dengan '),
            TextSpan(
              text: 'Penuh Kasih',
              style: serif(
                large ? 58 : 32,
                color: goldLight,
                weight: FontWeight.w600,
                italic: true,
              ),
            ),
          ],
        ),
        style: serif(large ? 58 : 32, color: Colors.white),
      ),
      SizedBox(height: large ? 20 : 12),
      Text(
        'Keselesaan, perhatian dan penjagaan penuh hormat untuk insan tersayang.',
        style: TextStyle(
          color: const Color(0xFFCFC3AC),
          fontSize: large ? 15 : 12,
          height: 1.7,
        ),
      ),
      SizedBox(height: large ? 26 : 20),
      Row(
        children: [
          Expanded(
            flex: 3,
            child: ActionButton(
              'Tempah Lawatan',
              icon: Icons.calendar_month_outlined,
              onTap: () => navigate('Lawatan'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: ActionButton(
              large ? 'Hubungi Kami' : 'Hubungi',
              icon: Icons.call_outlined,
              variant: 'ghost',
              onTap: () => navigate('Hubungi'),
            ),
          ),
        ],
      ),
      if (large) ...[
        const SizedBox(height: 32),
        const Row(
          children: [
            Icon(Icons.verified_user_outlined, size: 15, color: gold),
            SizedBox(width: 8),
            Text(
              'SSM 202603291886',
              style: TextStyle(fontSize: 10, color: Color(0xFFBFB39C)),
            ),
            SizedBox(width: 24),
            Icon(Icons.location_on_outlined, size: 15, color: gold),
            SizedBox(width: 5),
            Text(
              'Sungai Petani, Kedah',
              style: TextStyle(fontSize: 10, color: Color(0xFFBFB39C)),
            ),
          ],
        ),
      ],
    ],
  );
  Widget desktopHero() => Container(
    color: black,
    width: double.infinity,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 46, 32, 48),
          child: Row(
            children: [
              Expanded(child: heroCopy(large: true)),
              const SizedBox(width: 54),
              const Expanded(
                child: Photo(
                  'photo-care-group.jpg',
                  height: 400,
                  radius: 22,
                  alignment: Alignment(.2, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  Widget home() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (!desktop) ...[
        Panel(
          padding: EdgeInsets.zero,
          color: black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Photo(
                'photo-care-group.jpg',
                height: 164,
                alignment: Alignment(.2, -.2),
              ),
              Padding(padding: const EdgeInsets.all(20), child: heroCopy()),
            ],
          ),
        ),
        const SizedBox(height: 26),
        shortcuts(),
        const SizedBox(height: 24),
        shopPromo(),
        const SizedBox(height: 28),
      ],
      sectionHeader(
        'Perkhidmatan',
        'Penjagaan Kami',
        more: 'Semua',
        onTap: () => navigate('Jagaan'),
      ),
      if (desktop)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < 3; i++) ...[
              if (i > 0) const SizedBox(width: 16),
              Expanded(child: serviceCard(services[i])),
            ],
          ],
        )
      else
        SizedBox(
          height: 282,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, i) =>
                SizedBox(width: 256, child: serviceCard(services[i])),
          ),
        ),
      SizedBox(height: desktop ? 40 : 28),
      sectionHeader(
        'Sumbangan',
        'Keperluan Semasa',
        more: 'Lihat semua',
        onTap: () => navigate('Sumbang'),
      ),
      needGrid(needs.take(4).toList()),
      if (desktop) ...[const SizedBox(height: 32), shopPromo()],
      SizedBox(height: desktop ? 40 : 28),
      sectionHeader(
        'Kemudahan',
        'Rumah Yang Selesa',
        more: 'Butiran',
        onTap: () => navigate('Kemudahan'),
      ),
      if (desktop)
        Row(
          children: [
            for (int i = 0; i < 3; i++) ...[
              if (i > 0) const SizedBox(width: 14),
              Expanded(child: facilityCard(facilities[i], height: 220)),
            ],
          ],
        )
      else
        Column(
          children: [
            Row(
              children: [
                Expanded(child: facilityCard(facilities[0], height: 130)),
                const SizedBox(width: 12),
                Expanded(child: facilityCard(facilities[1], height: 130)),
              ],
            ),
            const SizedBox(height: 12),
            facilityCard(facilities[2], height: 165),
          ],
        ),
      const SizedBox(height: 10),
      const Text(
        'Foto ilustrasi bagi menggambarkan suasana ruang. Foto sebenar premis akan dimuat naik oleh pengurusan.',
        style: TextStyle(fontSize: 10, color: muted, height: 1.6),
      ),
      const SizedBox(height: 30),
      visitCTA(),
      const SizedBox(height: 30),
      sectionHeader('Hubungi', 'Kami Sedia Membantu'),
      contactCard(),
    ],
  );
  Widget shortcuts() {
    final entries = [
      ('Jagaan Warga\nEmas', Icons.favorite_border_rounded, 'Jagaan'),
      ('Jagaan OKU', Icons.volunteer_activism_outlined, 'Jagaan'),
      ('Tempah\nLawatan', Icons.calendar_month_outlined, 'Lawatan'),
      ('Pakej\nPenjagaan', Icons.description_outlined, 'Pakej'),
      ('Dashboard\nWaris', Icons.shield_outlined, 'Akaun'),
      ('Bayaran', Icons.account_balance_wallet_outlined, 'Akaun'),
      ('Sumbangan', Icons.card_giftcard_outlined, 'Sumbang'),
      ('Beli di Shopee', Icons.shopping_bag_outlined, 'Sumbang'),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisExtent: 110,
        crossAxisSpacing: 6,
        mainAxisSpacing: 9,
      ),
      itemCount: entries.length,
      itemBuilder: (_, i) {
        final e = entries[i];
        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => navigate(e.$3),
          child: Column(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: i == 7 ? const Color(0xFFFFECE6) : Colors.white,
                  border: Border.all(
                    color: i == 7 ? const Color(0xFFFFD9CA) : line,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  e.$2,
                  color: i == 7 ? const Color(0xFFEE4D2D) : goldDark,
                  size: 25,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                e.$1,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget shopPromo() => Panel(
    color: black,
    padding: const EdgeInsets.all(18),
    onTap: () => navigate('Care Shop'),
    child: Row(
      children: [
        Container(
          width: 52,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF3B3020),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFF66502D)),
          ),
          child: const Icon(
            Icons.storefront_outlined,
            color: goldLight,
            size: 27,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow('Baharu', color: goldLight),
              const SizedBox(height: 4),
              Text('DGH Care Shop', style: serif(24, color: Colors.white)),
              const SizedBox(height: 5),
              const Text(
                'Beli sambil menyumbang · hasil disalurkan ke Dana Penjagaan',
                style: TextStyle(
                  color: Color(0xFFCFC3AC),
                  fontSize: 10,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.chevron_right, color: goldLight, size: 22),
      ],
    ),
  );
  Widget serviceCard(Service s) => Panel(
    padding: EdgeInsets.zero,
    onTap: () => serviceDetail(s),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Photo(s.image, height: desktop ? 185 : 120),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(s.icon, size: 15, color: goldDark),
                  const SizedBox(width: 6),
                  const Eyebrow('Jagaan'),
                ],
              ),
              const SizedBox(height: 7),
              Text(s.title, style: serif(22)),
              const SizedBox(height: 6),
              Text(
                s.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, color: muted, height: 1.6),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  void serviceDetail(Service s) => sheet(
    s.title,
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Photo(s.image, height: 210, radius: 14),
        const SizedBox(height: 18),
        const Eyebrow('Penjagaan Penuh Hormat'),
        const SizedBox(height: 10),
        Text(s.description),
        const SizedBox(height: 18),
        const Text(
          'Setiap penghuni dijaga mengikut tahap bantuan, mobiliti dan keselesaan masing-masing. Hubungi pengurusan untuk berbincang tentang keperluan insan tersayang.',
          style: TextStyle(color: muted),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ActionButton(
            'Tempah Lawatan',
            icon: Icons.calendar_month_outlined,
            onTap: () {
              Navigator.pop(context);
              navigate('Lawatan');
            },
          ),
        ),
      ],
    ),
  );
  Widget facilityCard(
    (String, String) f, {
    double height = 170,
  }) => GestureDetector(
    onTap: () => sheet(
      f.$1,
      Column(
        children: [
          Photo(f.$2, height: 290, radius: 14),
          const SizedBox(height: 14),
          const Text(
            'Foto ilustrasi. Foto sebenar premis akan dikemas kini oleh pengurusan.',
            style: TextStyle(color: muted, fontSize: 12),
          ),
        ],
      ),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [
          Photo(f.$2, height: height),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 22, 12, 10),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xB3171411)],
                ),
              ),
              child: Text(
                f.$1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  Widget visitCTA() => Panel(
    color: black,
    padding: EdgeInsets.all(desktop ? 30 : 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Eyebrow('Lawatan', color: goldLight),
        const SizedBox(height: 10),
        Text(
          'Lihat sendiri suasana pusat kami',
          style: serif(desktop ? 34 : 28, color: Colors.white),
        ),
        const SizedBox(height: 10),
        const Text(
          'Pilih tarikh dan slot masa. Pihak pengurusan akan mengesahkan tempahan anda.',
          style: TextStyle(color: Color(0xFFCFC3AC), fontSize: 12),
        ),
        const SizedBox(height: 20),
        ActionButton(
          'Tempah Lawatan',
          icon: Icons.calendar_month_outlined,
          onTap: () => navigate('Lawatan'),
        ),
      ],
    ),
  );
  Widget contactCard() => Panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                color: cream,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: goldDark,
                size: 21,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DA GOLDEN HEAVEN CARE CENTRE',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'No. 18 Jalan Mawar 2/2, Persiaran Amanjaya 4,\n08000 Sungai Petani, Kedah, Malaysia',
                    style: TextStyle(fontSize: 11, color: muted, height: 1.7),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: ActionButton(
                '019-4084829',
                small: true,
                icon: Icons.call_outlined,
                variant: 'dark',
                onTap: () => openLink('tel:+60194084829'),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: ActionButton(
                'WhatsApp',
                small: true,
                icon: Icons.chat_bubble_outline_rounded,
                variant: 'line',
                onTap: () => openLink('https://wa.me/60194084829'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
  Widget servicesPage() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      pageHead(
        'Perkhidmatan',
        'Jagaan Penuh Hormat',
        'Setiap penghuni dijaga mengikut keperluan bantuan, mobiliti dan keselesaan masing-masing.',
      ),
      LayoutBuilder(
        builder: (_, c) => Wrap(
          spacing: 16,
          runSpacing: 16,
          children: services
              .map(
                (s) => SizedBox(
                  width: (c.maxWidth - (desktop ? 32 : 0)) / (desktop ? 3 : 1),
                  child: serviceCard(s),
                ),
              )
              .toList(),
        ),
      ),
      const SizedBox(height: 26),
      visitCTA(),
      const SizedBox(height: 14),
      SizedBox(
        width: double.infinity,
        child: ActionButton(
          'Pertanyaan Kemasukan',
          icon: Icons.description_outlined,
          variant: 'line',
          onTap: () => navigate('Kemasukan'),
        ),
      ),
    ],
  );
  Widget facilitiesPage() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      pageHead(
        'Kemudahan',
        'Ruang Yang Selesa & Selamat',
        'Premis kediaman dengan tiga bilik tidur, ruang rehat bersama, dapur dan bilik air.',
      ),
      LayoutBuilder(
        builder: (_, c) => Wrap(
          spacing: 16,
          runSpacing: 18,
          children: [
            for (final f in facilities)
              SizedBox(
                width: desktop ? (c.maxWidth - 32) / 3 : c.maxWidth,
                child: Panel(
                  padding: EdgeInsets.zero,
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      facilityCard(f, height: desktop ? 240 : 230),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(f.$1, style: serif(25)),
                            const SizedBox(height: 6),
                            Text(
                              f.$1 == 'Bilik Tidur'
                                  ? 'Ruang peribadi yang tenang untuk berehat dengan selesa.'
                                  : f.$1 == 'Ruang Rehat'
                                  ? 'Ruang bersama yang mesra untuk aktiviti dan interaksi harian.'
                                  : 'Ruang makan yang bersih dan selesa untuk semua penghuni.',
                              style: const TextStyle(
                                fontSize: 12,
                                color: muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      notice(
        'Foto ilustrasi. Foto sebenar premis dan kapasiti katil akan dipaparkan selepas disahkan oleh pengurusan.',
      ),
      const SizedBox(height: 26),
      visitCTA(),
    ],
  );
  Widget notice(String text, {Color color = goldDark}) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .07),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: .2)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline_rounded, size: 19, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: color, fontSize: 12, height: 1.65),
          ),
        ),
      ],
    ),
  );
  Widget aboutPage() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      pageHead(
        'Tentang Kami',
        'DA Golden Heaven Care Centre',
        'Penjagaan yang mengutamakan insan. Ketenangan untuk setiap keluarga.',
      ),
      Panel(
        color: black,
        child: Center(
          child: Image.asset(
            'assets/images/dgh-full.png',
            height: 210,
            fit: BoxFit.contain,
          ),
        ),
      ),
      const SizedBox(height: 24),
      const Text(
        'DA Golden Heaven ialah pusat penjagaan warga emas dan Orang Kurang Upaya di Sungai Petani, Kedah. Kami berpegang kepada tiga nilai — Care, Comfort, Dignity.',
        style: TextStyle(fontSize: 15, height: 1.8),
      ),
      const SizedBox(height: 24),
      Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('Maklumat Pendaftaran'),
            const SizedBox(height: 12),
            infoRow(
              Icons.description_outlined,
              'No. Pendaftaran SSM',
              '202603291886 (KT0624340-A)',
            ),
            infoRow(
              Icons.shield_outlined,
              'Jenis Perniagaan',
              'Penjagaan Warga Emas dan Orang Kurang Upaya',
            ),
            infoRow(
              Icons.person_outline,
              'Pengurus / Penyelia',
              'MOHD SOFIAN BIN MOHD YAZID',
            ),
            infoRow(
              Icons.location_on_outlined,
              'Alamat Berdaftar',
              'No. 18 Jalan Mawar 2/2, Persiaran Amanjaya 4, Sungai Petani, Kedah',
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      visitCTA(),
    ],
  );
  Widget infoRow(
    IconData icon,
    String title,
    String sub, {
    VoidCallback? onTap,
  }) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cream,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: goldDark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  sub,
                  style: const TextStyle(
                    fontSize: 11,
                    color: muted,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            const Icon(Icons.chevron_right, color: muted, size: 20),
        ],
      ),
    ),
  );
  Widget packagesPage() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      pageHead(
        'Pakej',
        'Pakej Penjagaan',
        'Kadar ditetapkan oleh pengurusan mengikut tahap keperluan penjagaan.',
      ),
      for (final t in [
        'Jagaan Harian (Day Care)',
        'Jagaan Penginapan Bulanan',
        'Jagaan OKU',
      ])
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.favorite_border_rounded,
                  color: goldDark,
                  size: 25,
                ),
                const SizedBox(height: 14),
                Text(t, style: serif(27)),
                const SizedBox(height: 12),
                const Text(
                  'Butiran dan kadar akan dipaparkan selepas dikemas kini oleh pengurusan.',
                  style: TextStyle(fontSize: 12, color: muted),
                ),
                const SizedBox(height: 14),
                const StatusChip('Menunggu Konfigurasi'),
              ],
            ),
          ),
        ),
      const SizedBox(height: 10),
      ActionButton(
        'Minta Maklumat Pakej',
        icon: Icons.description_outlined,
        onTap: () => navigate('Kemasukan'),
      ),
    ],
  );
  Widget contactPage() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      pageHead(
        'Hubungi Kami',
        'Kami Sedia Membantu',
        'Bincangkan keperluan penjagaan insan tersayang bersama kami.',
      ),
      contactCard(),
      const SizedBox(height: 18),
      Panel(
        child: Column(
          children: [
            infoRow(
              Icons.schedule_outlined,
              'Lawatan ke Pusat',
              'Sila tempah tarikh dan slot masa sebelum berkunjung.',
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ActionButton(
                'Tempah Lawatan',
                icon: Icons.calendar_month_outlined,
                onTap: () => navigate('Lawatan'),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      Row(
        children: [
          Expanded(
            child: ActionButton(
              'Salin Alamat',
              icon: Icons.copy_outlined,
              variant: 'line',
              onTap: () {
                Clipboard.setData(const ClipboardData(text: address));
                toast('Alamat disalin');
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ActionButton(
              'Arah ke Pusat',
              icon: Icons.near_me_outlined,
              variant: 'line',
              onTap: () => openLink(
                'https://www.google.com/maps/search/?api=1&query=18+Jalan+Mawar+2%2F2+Persiaran+Amanjaya+Sungai+Petani',
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 24),
      notice(
        'Untuk kecemasan perubatan, sila hubungi 999. Talian pusat bukan pengganti perkhidmatan kecemasan.',
      ),
    ],
  );
  int reserved(Need n) => records
      .where(
        (r) =>
            r['type'] == 'donation' &&
            r['item'] == n.name &&
            r['status'] != 'Dibatalkan',
      )
      .fold(0, (s, r) => s + ((r['qty'] as num?)?.toInt() ?? 0));
  Widget needGrid(List<Need> items) => LayoutBuilder(
    builder: (_, c) {
      final columns = desktop
          ? 4
          : c.maxWidth > 600
          ? 3
          : 2;
      final w = (c.maxWidth - 12 * (columns - 1)) / columns;
      return Wrap(
        spacing: 12,
        runSpacing: 14,
        children: items
            .map((n) => SizedBox(width: w, child: needCard(n)))
            .toList(),
      );
    },
  );
  Widget needCard(Need n) {
    final held = reserved(n);
    final remaining = (n.target - held).clamp(0, n.target);
    return Panel(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => needDetail(n),
            child: Stack(
              children: [
                const Photo(
                  'photo-supplies.png',
                  height: 130,
                  alignment: Alignment(0, .3),
                ),
                if (n == needs.first)
                  const Positioned(
                    top: 9,
                    left: 9,
                    child: StatusChip('Keutamaan', color: Color(0xFFC54141)),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  n.category,
                  style: const TextStyle(color: muted, fontSize: 10),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 38,
                  child: Text(
                    n.name,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: held / n.target,
                    minHeight: 5,
                    color: gold,
                    backgroundColor: cream2,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  'Diterima 0/${n.target}',
                  style: const TextStyle(color: muted, fontSize: 10),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Ditempah $held',
                    style: const TextStyle(color: muted, fontSize: 10),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Baki untuk Disumbang $remaining',
                  style: TextStyle(
                    color: remaining > 0 ? goldDark : green,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ActionButton(
                    'Beli di Shopee',
                    small: true,
                    icon: Icons.shopping_bag_outlined,
                    variant: 'orange',
                    onTap: () => shopeeDisclosure(n),
                  ),
                ),
                const SizedBox(height: 7),
                SizedBox(
                  width: double.infinity,
                  child: ActionButton(
                    'Sumbang',
                    small: true,
                    variant: 'line',
                    onTap: () => needDetail(n),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget donationsPage() {
    final filtered = needs
        .where(
          (n) =>
              (category == 'Semua' || n.category == category) &&
              n.name.toLowerCase().contains(search.toLowerCase()),
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Panel(
          color: black,
          padding: EdgeInsets.all(desktop ? 32 : 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow('Sumbangan', color: goldLight),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Sedikit Daripada Kita,\n'),
                    TextSpan(
                      text: 'Besar Maknanya',
                      style: serif(
                        desktop ? 44 : 34,
                        color: goldLight,
                        italic: true,
                      ),
                    ),
                  ],
                ),
                style: serif(desktop ? 44 : 34, color: Colors.white),
              ),
              const SizedBox(height: 12),
              const Text(
                'Bersama memenuhi keperluan harian dan memberi keselesaan kepada penghuni kami.',
                style: TextStyle(color: Color(0xFFCFC3AC), fontSize: 12),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ActionButton(
                      'Senarai Keperluan',
                      small: true,
                      onTap: () {
                        setState(() {
                          category = 'Semua';
                          search = '';
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ActionButton(
                      'Sumbang Tunai Am',
                      small: true,
                      variant: 'ghost',
                      onTap: generalDonation,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        TextField(
          onChanged: (v) => setState(() => search = v),
          decoration: const InputDecoration(
            hintText: 'Cari keperluan…',
            prefixIcon: Icon(Icons.search, size: 21),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                [
                      'Semua',
                      'Lampin',
                      'Kebersihan',
                      'Makanan',
                      'Peralatan',
                      'Kesihatan',
                    ]
                    .map(
                      (cat) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            cat,
                            style: TextStyle(
                              fontSize: 11,
                              color: category == cat ? goldLight : ink,
                            ),
                          ),
                          selected: category == cat,
                          showCheckmark: false,
                          selectedColor: black,
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: line),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onSelected: (_) => setState(() => category = cat),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Text(
              '${filtered.length} keperluan',
              style: const TextStyle(color: muted, fontSize: 12),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () => navigate('Jejak'),
              icon: const Icon(Icons.local_shipping_outlined, size: 17),
              label: const Text(
                'Jejak Sumbangan',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (filtered.isEmpty)
          const Panel(
            child: Center(
              child: Text('Tiada keperluan dijumpai. Cuba carian lain.'),
            ),
          )
        else
          needGrid(filtered),
        const SizedBox(height: 28),
        sectionHeader('Panduan', 'Cara Menyumbang'),
        Panel(
          child: Column(
            children: [
              infoRow(
                Icons.search,
                '1. Pilih Keperluan',
                'Semak spesifikasi dan baki yang diperlukan.',
              ),
              infoRow(
                Icons.shopping_bag_outlined,
                '2. Pilih Cara Sumbangan',
                'Beli di Shopee atau tawarkan barang sendiri.',
              ),
              infoRow(
                Icons.local_shipping_outlined,
                '3. Hantar ke Pusat',
                'Rekod pembelian dan simpan nombor rujukan anda.',
              ),
              infoRow(
                Icons.verified_outlined,
                '4. Pengesahan Penerimaan',
                'Kakitangan akan mengesahkan barang yang diterima.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        contactCard(),
        const SizedBox(height: 24),
        shopPromo(),
      ],
    );
  }

  void shopeeDisclosure(Need n) => sheet(
    'Beli di Shopee',
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(n.name, style: serif(28)),
        const SizedBox(height: 12),
        Text(n.spec),
        const SizedBox(height: 18),
        notice(
          'Pautan ini membuka carian Shopee. Harga, stok dan pembelian diuruskan oleh penjual Shopee, bukan pusat jagaan.',
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: ActionButton(
            'Teruskan ke Shopee',
            variant: 'orange',
            icon: Icons.open_in_new_rounded,
            onTap: () => openLink(
              'https://shopee.com.my/search?keyword=${Uri.encodeComponent(n.name)}',
            ),
          ),
        ),
      ],
    ),
  );
  void needDetail(Need n) {
    int qty = 1;
    int mode = 0;
    final remaining = (n.target - reserved(n)).clamp(0, n.target);
    sheet(
      'Sumbang Keperluan',
      StatefulBuilder(
        builder: (ctx, update) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Photo('photo-supplies.png', height: 180, radius: 14),
            const SizedBox(height: 18),
            Eyebrow(n.category),
            const SizedBox(height: 8),
            Text(n.name, style: serif(30)),
            const SizedBox(height: 10),
            Text(n.spec, style: const TextStyle(color: muted)),
            const SizedBox(height: 18),
            Row(
              children: [
                for (final s in [
                  ('Sasaran', n.target),
                  ('Diterima', 0),
                  ('Ditempah', reserved(n)),
                  ('Baki', remaining),
                ])
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 5),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: line),
                      ),
                      child: Column(
                        children: [
                          Text('${s.$2}', style: serif(29, color: goldDark)),
                          const SizedBox(height: 3),
                          Text(
                            s.$1,
                            style: const TextStyle(fontSize: 9, color: muted),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Ditempah bukan stok fizikal. Diterima hanya selepas disahkan oleh kakitangan.',
              style: TextStyle(fontSize: 10, color: muted),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 6,
              children: [
                for (int i = 0; i < 3; i++)
                  ChoiceChip(
                    label: Text(
                      ['Beli di Shopee', 'Sumbang Wang', 'Barang Sendiri'][i],
                      style: TextStyle(
                        fontSize: 10,
                        color: mode == i ? goldLight : ink,
                      ),
                    ),
                    selected: mode == i,
                    selectedColor: black,
                    showCheckmark: false,
                    onSelected: (_) => update(() => mode = i),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            if (mode == 0) ...[
              SizedBox(
                width: double.infinity,
                child: ActionButton(
                  'Beli di Shopee',
                  variant: 'orange',
                  icon: Icons.shopping_bag_outlined,
                  onTap: () => shopeeDisclosure(n),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Hantar terus ke alamat pusat:',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              ),
              const SizedBox(height: 8),
              const Text(address, style: TextStyle(fontSize: 11, color: muted)),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ActionButton(
                      'Salin Alamat',
                      variant: 'line',
                      icon: Icons.copy_outlined,
                      small: true,
                      onTap: () {
                        Clipboard.setData(const ClipboardData(text: address));
                        toast('Alamat disalin');
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ActionButton(
                      'Saya Sudah Beli',
                      small: true,
                      onTap: remaining == 0
                          ? null
                          : () {
                              Navigator.pop(context);
                              declareDonation(n);
                            },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Kuantiti',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: qty > 1 ? () => update(() => qty--) : null,
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: goldDark,
                    ),
                  ),
                  Text(
                    '$qty',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    onPressed: qty < remaining
                        ? () => update(() => qty++)
                        : null,
                    icon: const Icon(Icons.add_circle_outline, color: goldDark),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ActionButton(
                  'Tempah $qty ${n.unit}',
                  onTap: remaining == 0
                      ? null
                      : () {
                          Navigator.pop(context);
                          reserveDonation(n, qty);
                        },
                ),
              ),
            ],
            if (mode == 1) ...[
              notice(
                'Dana pembelian memerlukan butiran akaun bank dan pengesahan pembayaran oleh pengurusan.',
              ),
              const SizedBox(height: 14),
              const StatusChip('Menunggu Konfigurasi'),
              const SizedBox(height: 18),
              ActionButton(
                'Hubungi Pengurusan',
                icon: Icons.chat_bubble_outline,
                onTap: () => openLink(
                  'https://wa.me/60194084829?text=${Uri.encodeComponent('Saya ingin menyumbang untuk ${n.name}.')}',
                ),
              ),
            ],
            if (mode == 2) ...[
              notice(
                'Barang mesti bersih, selamat dan sesuai digunakan. Semua tawaran tertakluk kepada semakan pengurusan.',
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ActionButton(
                  'Tawarkan Barang Sendiri',
                  icon: Icons.inventory_2_outlined,
                  onTap: () {
                    Navigator.pop(context);
                    ownItem(n);
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String reference(String prefix) =>
      '$prefix-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
  void reserveDonation(Need n, int qty) {
    final name = TextEditingController();
    final phone = TextEditingController();
    final form = GlobalKey<FormState>();
    sheet(
      'Tempah Sumbangan',
      Form(
        key: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(n.name, style: serif(27)),
            const SizedBox(height: 8),
            Text(
              '$qty ${n.unit}',
              style: const TextStyle(
                color: goldDark,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            formField('Nama', name, hint: 'Nama penyumbang'),
            formField('No. Telefon', phone, phone: true),
            notice(
              'Tempahan ini disimpan pada peranti anda. Hubungi pengurusan untuk mengesahkan sebelum menghantar barang.',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ActionButton(
                'Simpan Tempahan',
                onTap: () async {
                  if (!(form.currentState?.validate() ?? false)) {
                    return;
                  }
                  final ref = reference('DGH');
                  await save({
                    'type': 'donation',
                    'item': n.name,
                    'qty': qty,
                    'name': name.text,
                    'phone': phone.text,
                    'ref': ref,
                    'status': 'Draf Tempahan',
                    'date': DateTime.now().toIso8601String(),
                  });
                  if (!mounted) {
                    return;
                  }
                  Navigator.pop(context);
                  confirmation(
                    'Tempahan Disimpan',
                    ref,
                    'Draf tempahan anda telah disimpan pada peranti ini. Sila hantar butiran kepada pengurusan untuk pengesahan.',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void declareDonation(Need n) {
    final form = GlobalKey<FormState>();
    final order = TextEditingController(),
        phone = TextEditingController(),
        name = TextEditingController(),
        tracking = TextEditingController();
    int qty = 1;
    sheet(
      'Saya Sudah Beli',
      StatefulBuilder(
        builder: (_, update) => Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(n.name, style: serif(27)),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Text('Kuantiti'),
                  const Spacer(),
                  IconButton(
                    onPressed: qty > 1 ? () => update(() => qty--) : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('$qty'),
                  IconButton(
                    onPressed: qty < n.target - reserved(n)
                        ? () => update(() => qty++)
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              formField(
                'No. Pesanan Shopee',
                order,
                hint: 'Sekurang-kurangnya 6 aksara',
                validator: (v) => (v ?? '').trim().length < 6
                    ? 'Masukkan nombor pesanan yang sah'
                    : records.any((r) => r['order'] == v?.trim())
                    ? 'Nombor pesanan telah digunakan'
                    : null,
              ),
              formField('Nama', name),
              formField('No. Telefon', phone, phone: true),
              formField(
                'No. Penjejakan Kurier (pilihan)',
                tracking,
                required: false,
              ),
              notice(
                'Rekod ini disimpan pada peranti anda. Pengesahan penerimaan hanya dibuat oleh kakitangan pusat.',
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ActionButton(
                  'Simpan Maklumat Pembelian',
                  onTap: () async {
                    if (!(form.currentState?.validate() ?? false)) {
                      return;
                    }
                    final ref = reference('DGH');
                    await save({
                      'type': 'donation',
                      'item': n.name,
                      'qty': qty,
                      'ref': ref,
                      'order': order.text.trim(),
                      'tracking': tracking.text,
                      'name': name.text,
                      'phone': phone.text,
                      'status': 'Pembelian Direkod',
                      'date': DateTime.now().toIso8601String(),
                    });
                    if (!mounted) {
                      return;
                    }
                    Navigator.pop(context);
                    confirmation(
                      'Pembelian Direkod',
                      ref,
                      'Maklumat pembelian disimpan pada peranti ini. Hantar maklumat ini kepada pusat untuk penjejakan dan pengesahan.',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void ownItem(Need n) {
    final form = GlobalKey<FormState>();
    final name = TextEditingController(),
        phone = TextEditingController(),
        details = TextEditingController();
    String condition = 'Baru (belum dibuka)';
    sheet(
      'Tawarkan Barang Sendiri',
      StatefulBuilder(
        builder: (_, update) => Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(n.name, style: serif(27)),
              const SizedBox(height: 18),
              formField('Nama Penyumbang', name),
              formField('No. Telefon', phone, phone: true),
              const Text(
                'Keadaan Barang',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: condition,
                isExpanded: true,
                items:
                    [
                          'Baru (belum dibuka)',
                          'Baru (telah dibuka)',
                          'Terpakai — sangat baik',
                          'Terpakai — baik',
                          'Memerlukan pembaikan',
                        ]
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (v) => update(() => condition = v!),
              ),
              const SizedBox(height: 16),
              formField(
                'Butiran Barang',
                details,
                hint: 'Kuantiti, usia barang dan cara penghantaran',
                lines: 3,
              ),
              notice(
                'Barang tidak selamat akan ditolak. Hubungi pengurusan untuk menghantar gambar dan mendapatkan kelulusan sebelum penghantaran.',
              ),
              const SizedBox(height: 20),
              ActionButton(
                'Simpan Tawaran',
                onTap: () async {
                  if (!(form.currentState?.validate() ?? false)) {
                    return;
                  }
                  final ref = reference('BRG');
                  await save({
                    'type': 'offer',
                    'item': n.name,
                    'name': name.text,
                    'phone': phone.text,
                    'details': details.text,
                    'condition': condition,
                    'status': 'Draf Tawaran',
                    'ref': ref,
                    'date': DateTime.now().toIso8601String(),
                  });
                  if (!mounted) {
                    return;
                  }
                  Navigator.pop(context);
                  confirmation(
                    'Tawaran Disimpan',
                    ref,
                    'Tawaran disimpan pada peranti ini. Sila hantar gambar dan butiran kepada pengurusan untuk semakan.',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void generalDonation() => sheet(
    'Sumbang Tunai Am',
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Eyebrow('Dana Penjagaan'),
        const SizedBox(height: 12),
        Text('Setiap Sumbangan Bermakna', style: serif(31)),
        const SizedBox(height: 15),
        const Text(
          'Bantu menyokong penjagaan, makanan dan keselesaan harian penghuni kami.',
        ),
        const SizedBox(height: 18),
        notice(
          'Butiran akaun bank dan pembayaran DuitNow belum dikonfigurasi. Jangan buat bayaran tanpa pengesahan pengurusan.',
        ),
        const SizedBox(height: 18),
        const StatusChip('Menunggu Konfigurasi'),
        const SizedBox(height: 22),
        ActionButton(
          'Hubungi untuk Menyumbang',
          icon: Icons.chat_bubble_outline,
          onTap: () => openLink(
            'https://wa.me/60194084829?text=Saya%20ingin%20membuat%20sumbangan%20tunai.',
          ),
        ),
      ],
    ),
  );
  Widget formField(
    String label,
    TextEditingController controller, {
    String? hint,
    bool phone = false,
    bool required = true,
    int lines = 1,
    String? Function(String?)? validator,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: lines,
          keyboardType: phone ? TextInputType.phone : TextInputType.text,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText:
                hint ??
                (phone
                    ? 'Contoh: 012-3456789'
                    : 'Masukkan ${label.toLowerCase()}'),
          ),
          validator:
              validator ??
              (v) {
                if (required && (v ?? '').trim().isEmpty) {
                  return 'Sila isi ${label.toLowerCase()}';
                }
                if (phone &&
                    (v ?? '').replaceAll(RegExp(r'\D'), '').length < 9) {
                  return 'Masukkan nombor telefon yang sah';
                }
                return null;
              },
        ),
      ],
    ),
  );
  String recordMessage(Map<String, dynamic> r) => [
    'Rujukan: ${r['ref']}',
    '${r['item']}',
    'Nama: ${r['name'] ?? ''}',
    'Telefon: ${r['phone'] ?? ''}',
    if (r['visitors'] != null) 'Bilangan Pelawat: ${r['visitors']}',
    if (r['qty'] != null) 'Kuantiti: ${r['qty']}',
    if (r['care'] != null) 'Jenis Penjagaan: ${r['care']}',
    if (r['order'] != null) 'Pesanan Shopee: ${r['order']}',
    if (r['tracking'] != null && '${r['tracking']}'.isNotEmpty)
      'Penjejakan: ${r['tracking']}',
    if (r['details'] != null) 'Butiran: ${r['details']}',
    if (r['condition'] != null) 'Keadaan: ${r['condition']}',
    if (r['note'] != null && '${r['note']}'.isNotEmpty) 'Catatan: ${r['note']}',
  ].join('\n');
  void confirmation(String title, String ref, String message) => sheet(
    title,
    Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: green.withValues(alpha: .09),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: green, size: 35),
        ),
        const SizedBox(height: 20),
        Text(title, style: serif(30)),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: muted, fontSize: 12),
        ),
        const SizedBox(height: 20),
        Panel(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Eyebrow('No. Rujukan'),
                    const SizedBox(height: 5),
                    Text(
                      ref,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: ref));
                  toast('Rujukan disalin');
                },
                icon: const Icon(
                  Icons.copy_outlined,
                  size: 20,
                  color: goldDark,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ActionButton(
            'Hantar kepada Pengurusan',
            icon: Icons.chat_bubble_outline,
            onTap: () => openLink(
              'https://wa.me/60194084829?text=${Uri.encodeComponent(recordMessage(records.lastWhere((r) => r['ref'] == ref)))}',
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ActionButton(
            'Lihat Rekod Saya',
            variant: 'line',
            onTap: () {
              Navigator.pop(context);
              navigate('Akaun');
            },
          ),
        ),
      ],
    ),
  );
  Widget bookingPage() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      pageHead(
        'Lawatan',
        'Datang & Kenali Kami',
        'Lihat sendiri suasana pusat dan berbincang tentang keperluan insan tersayang.',
      ),
      const Photo('room-lounge.jpg', height: 200, radius: 18),
      const SizedBox(height: 22),
      BookingForm(
        onSubmit: (data) async {
          final ref = reference('LWT');
          await save({
            ...data,
            'type': 'visit',
            'ref': ref,
            'item': 'Lawatan ${data['visitDate']} · ${data['slot']}',
            'status': 'Draf Lawatan',
          });
          if (mounted) {
            confirmation(
              'Permintaan Lawatan Disimpan',
              ref,
              'Permintaan disimpan pada peranti ini. Hantar butiran kepada pengurusan melalui WhatsApp untuk pengesahan.',
            );
          }
        },
      ),
      const SizedBox(height: 24),
      notice(
        'Tempahan tertakluk kepada pengesahan pihak pengurusan. Sila hubungi 019-4084829 jika memerlukan bantuan.',
      ),
    ],
  );
  Widget admissionPage() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      pageHead(
        'Kemasukan',
        'Penjagaan untuk Insan Tersayang',
        'Kongsikan keperluan anda. Kami akan membantu mencari pilihan penjagaan yang sesuai.',
      ),
      AdmissionForm(
        onSubmit: (data) async {
          final ref = reference('MSK');
          await save({
            ...data,
            'type': 'admission',
            'item': 'Pertanyaan Kemasukan',
            'ref': ref,
            'status': 'Draf Pertanyaan',
          });
          if (mounted) {
            confirmation(
              'Pertanyaan Disimpan',
              ref,
              'Hantar pertanyaan anda kepada pengurusan untuk maklumat pakej dan penilaian keperluan penjagaan.',
            );
          }
        },
      ),
    ],
  );
  Widget accountPage() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      pageHead(
        'Akaun',
        'Selamat Datang',
        'Urus rekod lawatan dan sumbangan anda di satu tempat.',
      ),
      Panel(
        color: black,
        child: Row(
          children: [
            Container(
              width: 53,
              height: 53,
              decoration: BoxDecoration(
                color: const Color(0xFF3B3020),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.person_outline,
                color: goldLight,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tetamu DGH', style: serif(27, color: Colors.white)),
                  const SizedBox(height: 5),
                  const Text(
                    'Care · Comfort · Dignity',
                    style: TextStyle(color: goldLight, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Panel(
        child: Column(
          children: [
            infoRow(
              Icons.shield_outlined,
              'Portal Waris',
              'Aktiviti harian, bayaran dan rekod penjagaan',
              onTap: () => portal('Portal Waris'),
            ),
            infoRow(
              Icons.volunteer_activism_outlined,
              'Portal Penyumbang',
              'Sumbangan dan rekod penerimaan',
              onTap: () => portal('Portal Penyumbang'),
            ),
            infoRow(
              Icons.badge_outlined,
              'Portal Kakitangan',
              'Pengurusan penjagaan dan operasi pusat',
              onTap: () => portal('Portal Kakitangan'),
            ),
          ],
        ),
      ),
      const SizedBox(height: 26),
      sectionHeader('Peranti Ini', 'Rekod Saya'),
      if (records.isEmpty)
        const Panel(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                children: [
                  Icon(Icons.folder_open_outlined, color: goldDark, size: 36),
                  SizedBox(height: 12),
                  Text(
                    'Belum ada rekod',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Tempahan lawatan dan sumbangan anda akan dipaparkan di sini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        )
      else
        ...records.reversed.map(
          (r) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: recordCard(r),
          ),
        ),
      const SizedBox(height: 20),
      notice(
        'Rekod disimpan pada peranti ini sahaja. Akaun dalam talian dan penyegerakan akan tersedia selepas sistem pusat disambungkan.',
      ),
      const SizedBox(height: 20),
      Panel(
        child: Column(
          children: [
            infoRow(
              Icons.local_shipping_outlined,
              'Jejak Sumbangan',
              'Cari rekod dengan nombor rujukan',
              onTap: () => navigate('Jejak'),
            ),
            infoRow(
              Icons.info_outline,
              'Tentang Kami',
              'Maklumat pusat dan pendaftaran',
              onTap: () => navigate('Tentang Kami'),
            ),
            infoRow(
              Icons.call_outlined,
              'Hubungi Pengurusan',
              'Kami sedia membantu',
              onTap: () => navigate('Hubungi'),
            ),
          ],
        ),
      ),
    ],
  );
  void portal(String title) => sheet(
    title,
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Akses Selamat', style: serif(31)),
        const SizedBox(height: 14),
        const Text(
          'Portal ini memerlukan akaun yang didaftarkan oleh pengurusan pusat. Hubungi pengurusan untuk mendapatkan akses.',
        ),
        const SizedBox(height: 18),
        notice(
          'Pengesahan akaun belum disambungkan. Data peribadi dan rekod kesihatan tidak dipaparkan tanpa pengesahan.',
        ),
        const SizedBox(height: 22),
        ActionButton(
          'Hubungi Pengurusan',
          icon: Icons.chat_bubble_outline,
          onTap: () => openLink(
            'https://wa.me/60194084829?text=${Uri.encodeComponent('Saya ingin mendapatkan akses $title.')}',
          ),
        ),
      ],
    ),
  );
  Widget recordCard(Map<String, dynamic> r) => Panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              r['type'] == 'visit'
                  ? Icons.calendar_month_outlined
                  : r['type'] == 'order'
                  ? Icons.shopping_bag_outlined
                  : Icons.card_giftcard_outlined,
              size: 20,
              color: goldDark,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                '${r['ref']}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Salin rujukan',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: '${r['ref']}'));
                toast('Rujukan disalin');
              },
              icon: const Icon(Icons.copy_outlined, size: 17, color: muted),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Text(
          '${r['item']}',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
        if (r['qty'] != null)
          Text(
            'Kuantiti: ${r['qty']}',
            style: const TextStyle(fontSize: 11, color: muted),
          ),
        const SizedBox(height: 14),
        StatusChip(
          '${r['status']}',
          color: r['status'] == 'Dibatalkan' ? muted : goldDark,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: ActionButton(
                'Hubungi Pusat',
                small: true,
                variant: 'line',
                icon: Icons.chat_bubble_outline,
                onTap: () => openLink(
                  'https://wa.me/60194084829?text=${Uri.encodeComponent(recordMessage(r))}',
                ),
              ),
            ),
            if (r['status'] != 'Dibatalkan') ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: () async {
                  final yes = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Batalkan rekod?'),
                      content: const Text(
                        'Ini membatalkan draf pada peranti ini sahaja. Jika sudah dihantar kepada pusat, sila maklumkan pengurusan juga.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Kembali'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Batalkan'),
                        ),
                      ],
                    ),
                  );
                  if (yes == true) {
                    setState(() => r['status'] = 'Dibatalkan');
                    await widget.prefs?.setString(
                      'dgh_records',
                      jsonEncode(records),
                    );
                  }
                },
                child: const Text(
                  'Batal',
                  style: TextStyle(fontSize: 11, color: muted),
                ),
              ),
            ],
          ],
        ),
      ],
    ),
  );
  Widget trackingPage() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      pageHead(
        'Penjejakan',
        'Jejak Sumbangan Anda',
        'Masukkan nombor rujukan DGH, BRG atau LWT untuk melihat rekod pada peranti ini.',
      ),
      TextField(
        onChanged: (v) => setState(() => search = v.trim()),
        decoration: const InputDecoration(
          hintText: 'Contoh: DGH-12345678',
          prefixIcon: Icon(Icons.search),
        ),
      ),
      const SizedBox(height: 22),
      if (search.isNotEmpty) ...[
        if (records
            .where((r) => '${r['ref']}'.toUpperCase() == search.toUpperCase())
            .isEmpty)
          const Panel(
            child: Column(
              children: [
                Icon(Icons.search_off, size: 36, color: muted),
                SizedBox(height: 12),
                Text(
                  'Rujukan tidak dijumpai',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                Text(
                  'Semak semula nombor rujukan. Untuk rekod dari peranti lain, hubungi pusat.',
                  style: TextStyle(color: muted, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ...records
              .where((r) => '${r['ref']}'.toUpperCase() == search.toUpperCase())
              .map(recordCard),
      ] else
        notice(
          'Nombor rujukan boleh didapati dalam Rekod Saya selepas anda menyimpan tempahan atau sumbangan.',
        ),
    ],
  );
  final Map<int, int> cart = {};
  static const products = [
    (
      'Kad Ucapan Bunga Kering',
      'DGH Handmade',
      8.0,
      Icons.local_florist_outlined,
    ),
    ('Hamper Kasih DGH', 'Gifts & Hampers', 89.0, Icons.card_giftcard_outlined),
    ('Beg Tote DGH', 'Other', 25.0, Icons.shopping_bag_outlined),
  ];
  Widget shopPage() {
    final shown = products
        .asMap()
        .entries
        .where(
          (e) =>
              (category == 'Semua' || category == e.value.$2) &&
              e.value.$1.toLowerCase().contains(search.toLowerCase()),
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Panel(
          color: black,
          padding: EdgeInsets.all(desktop ? 32 : 23),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow('DGH Care Shop', color: goldLight),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Beli Sambil\n'),
                    TextSpan(
                      text: 'Menyumbang',
                      style: serif(
                        desktop ? 48 : 39,
                        color: goldLight,
                        italic: true,
                      ),
                    ),
                  ],
                ),
                style: serif(desktop ? 48 : 39, color: Colors.white),
              ),
              const SizedBox(height: 12),
              const Text(
                'Setiap pembelian membawa makna. Bersama menyokong Dana Penjagaan DGH.',
                style: TextStyle(fontSize: 12, color: Color(0xFFCFC3AC)),
              ),
              const SizedBox(height: 22),
              TextField(
                onChanged: (v) => setState(() => search = v),
                decoration: const InputDecoration(
                  hintText: 'Cari produk atau perkhidmatan…',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: ActionButton(
                      'Pesanan Saya',
                      variant: 'ghost',
                      small: true,
                      icon: Icons.receipt_long_outlined,
                      onTap: () => navigate('Akaun'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ActionButton(
                      'Ketelusan Dana',
                      variant: 'ghost',
                      small: true,
                      icon: Icons.shield_outlined,
                      onTap: transparency,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                [
                      'Semua',
                      'DGH Homemade',
                      'DGH Handmade',
                      'DGH Fragrance',
                      'Vibe Mobile',
                      'WiFi & Fibre',
                      'Xfind',
                      'Gifts & Hampers',
                      'Other',
                    ]
                    .map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            c,
                            style: TextStyle(
                              fontSize: 11,
                              color: category == c ? goldLight : ink,
                            ),
                          ),
                          showCheckmark: false,
                          selected: category == c,
                          selectedColor: black,
                          onSelected: (_) => setState(() => category = c),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
        const SizedBox(height: 18),
        notice(
          'Katalog contoh daripada reka bentuk. Pembelian dan pembayaran belum disambungkan. Sila sahkan ketersediaan dengan pengurusan.',
        ),
        const SizedBox(height: 22),
        if (shown.isEmpty)
          const Panel(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Produk akan datang. Sila semak semula nanti.',
                  style: TextStyle(color: muted),
                ),
              ),
            ),
          )
        else
          LayoutBuilder(
            builder: (_, c) => Wrap(
              spacing: 14,
              runSpacing: 14,
              children: shown.map((e) {
                final p = e.value;
                return SizedBox(
                  width: (c.maxWidth - (desktop ? 28 : 14)) / (desktop ? 3 : 2),
                  child: Panel(
                    padding: EdgeInsets.zero,
                    onTap: () => productDetail(e.key),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 155,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFF1E8D6), Color(0xFFE1D1AF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(p.$4, size: 40, color: goldDark),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.$2,
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: muted,
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                height: 42,
                                child: Text(
                                  p.$1,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'RM ${p.$3.toStringAsFixed(2)}',
                                style: serif(27, color: goldDark),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ActionButton(
                                  'Lihat Produk',
                                  small: true,
                                  variant: 'line',
                                  onTap: () => productDetail(e.key),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 24),
        if (cart.isNotEmpty)
          Panel(
            color: black,
            child: Row(
              children: [
                const Icon(Icons.shopping_bag_outlined, color: goldLight),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${cart.values.fold(0, (a, b) => a + b)} item · RM ${cartTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: cream,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                ActionButton('Lihat Troli', small: true, onTap: showCart),
              ],
            ),
          ),
        const SizedBox(height: 24),
        notice(
          'Pembelian bukan derma dan tidak layak mendapat potongan cukai. Hanya sumbangan dana yang disahkan akan dipaparkan dalam halaman ketelusan.',
        ),
      ],
    );
  }

  double get cartTotal =>
      cart.entries.fold(0.0, (sum, e) => sum + products[e.key].$3 * e.value);
  void productDetail(int id) {
    final p = products[id];
    int qty = 1;
    sheet(
      p.$1,
      StatefulBuilder(
        builder: (_, update) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 170,
              width: double.infinity,
              decoration: BoxDecoration(
                color: cream2,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(p.$4, color: goldDark, size: 75),
            ),
            const SizedBox(height: 20),
            Eyebrow(p.$2),
            const SizedBox(height: 10),
            Text(p.$1, style: serif(31)),
            const SizedBox(height: 10),
            Text(
              'RM ${p.$3.toStringAsFixed(2)}',
              style: serif(33, color: goldDark),
            ),
            const SizedBox(height: 12),
            Text(
              [
                'Kad ucapan buatan tangan dengan hiasan bunga kering. Dihasilkan oleh sukarelawan DGH.',
                'Set hadiah untuk insan tersayang. Kandungan tertakluk pada stok semasa.',
                'Beg kanvas tebal bercetak logo DA Golden Heaven.',
              ][id],
              style: const TextStyle(color: muted, fontSize: 12),
            ),
            const SizedBox(height: 16),
            notice(
              'Produk contoh. Harga dan ketersediaan perlu disahkan oleh pengurusan sebelum pembelian.',
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Text('Kuantiti'),
                const Spacer(),
                IconButton(
                  onPressed: qty > 1 ? () => update(() => qty--) : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('$qty'),
                IconButton(
                  onPressed: qty < 20 ? () => update(() => qty++) : null,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ActionButton(
                'Tambah ke Troli',
                icon: Icons.add_shopping_cart_outlined,
                onTap: () {
                  setState(() => cart[id] = (cart[id] ?? 0) + qty);
                  Navigator.pop(context);
                  toast('Produk ditambah ke troli');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCart() => sheet(
    'Troli Saya',
    StatefulBuilder(
      builder: (_, update) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (cart.isEmpty)
            const Text('Troli anda kosong.')
          else ...[
            for (final e in cart.entries.toList())
              Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: cream2,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(products[e.key].$4, color: goldDark),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            products[e.key].$1,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${e.value} × RM ${products[e.key].$3.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 12, color: muted),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() => cart.remove(e.key));
                        update(() {});
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Jumlah Anggaran'),
                const Spacer(),
                Text(
                  'RM ${cartTotal.toStringAsFixed(2)}',
                  style: serif(30, color: goldDark),
                ),
              ],
            ),
            const SizedBox(height: 18),
            notice(
              'Semak ketersediaan dengan pengurusan. Tiada bayaran dikenakan melalui aplikasi ini.',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ActionButton(
                'Tanya Pengurusan',
                icon: Icons.chat_bubble_outline,
                onTap: () {
                  final text =
                      'Saya berminat dengan produk DGH Care Shop:\n${cart.entries.map((e) => '${e.value} × ${products[e.key].$1}').join('\n')}\nJumlah anggaran: RM ${cartTotal.toStringAsFixed(2)}';
                  openLink(
                    'https://wa.me/60194084829?text=${Uri.encodeComponent(text)}',
                  );
                },
              ),
            ),
          ],
        ],
      ),
    ),
  );
  void transparency() => sheet(
    'Ketelusan Dana Penjagaan',
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Eyebrow('Amanah & Telus'),
        const SizedBox(height: 12),
        Text('Setiap Ringgit, Bermakna', style: serif(31)),
        const SizedBox(height: 18),
        notice(
          'Hanya amaun yang telah disahkan oleh pengurusan dipaparkan. Lejar dana dalam talian belum disambungkan.',
        ),
        const SizedBox(height: 18),
        for (final label in [
          'Sumbangan Disahkan',
          'Diperuntukkan',
          'Digunakan',
          'Baki Dana',
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Panel(
              child: Row(
                children: [
                  Expanded(
                    child: Text(label, style: const TextStyle(fontSize: 12)),
                  ),
                  Text('—', style: serif(28, color: goldDark)),
                ],
              ),
            ),
          ),
        const SizedBox(height: 10),
        const Text(
          'Hasil komersial diasingkan daripada sumbangan. Peruntukan dana dikira selepas kos, bayaran dan bahagian penghuni yang berkenaan.',
          style: TextStyle(color: muted, fontSize: 12),
        ),
      ],
    ),
  );
  Widget footer() => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: desktop ? 38 : 28),
    color: desktop ? black : cream,
    child: Column(
      children: [
        Image.asset('assets/images/dgh-mark.png', width: 70, height: 45),
        const SizedBox(height: 15),
        Text(
          'CARE · COMFORT · DIGNITY',
          style: TextStyle(
            fontSize: 9,
            letterSpacing: 2,
            color: desktop ? goldLight : goldDark,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 20,
          alignment: WrapAlignment.center,
          children: [
            for (final p in ['Tentang Kami', 'Kemudahan', 'Hubungi'])
              TextButton(
                onPressed: () => navigate(p),
                child: Text(
                  p,
                  style: TextStyle(
                    fontSize: 11,
                    color: desktop ? cream : muted,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '© 2026 DA GOLDEN HEAVEN CARE CENTRE\nSSM 202603291886 (KT0624340-A)',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
            height: 1.8,
            color: desktop ? const Color(0xFFB0A28B) : muted,
          ),
        ),
      ],
    ),
  );
}

class StatusChip extends StatelessWidget {
  final String text;
  final Color color;
  const StatusChip(this.text, {super.key, this.color = goldDark});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .10),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700),
    ),
  );
}

class BookingForm extends StatefulWidget {
  final Future<void> Function(Map<String, dynamic>) onSubmit;
  const BookingForm({super.key, required this.onSubmit});
  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(),
      phone = TextEditingController(),
      note = TextEditingController();
  DateTime? date;
  String? slot;
  int visitors = 1;
  bool saving = false;
  bool consent = false;
  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    note.dispose();
    super.dispose();
  }

  String get dateText => date == null
      ? 'Pilih tarikh lawatan'
      : '${date!.day.toString().padLeft(2, '0')}/${date!.month.toString().padLeft(2, '0')}/${date!.year}';
  @override
  Widget build(BuildContext context) => Panel(
    child: Form(
      key: form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('Tempah Lawatan'),
          const SizedBox(height: 10),
          Text('Kami Menanti Kehadiran Anda', style: serif(27)),
          const SizedBox(height: 22),
          input('Nama Penuh', name),
          input('No. Telefon', phone, isPhone: true),
          const Text(
            'Tarikh Lawatan',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ActionButton(
              dateText,
              variant: 'line',
              icon: Icons.calendar_month_outlined,
              onTap: () async {
                final now = DateUtils.dateOnly(DateTime.now());
                final chosen = await showDatePicker(
                  context: context,
                  initialDate: date ?? now.add(const Duration(days: 1)),
                  firstDate: now,
                  lastDate: now.add(const Duration(days: 90)),
                  helpText: 'Pilih tarikh lawatan',
                  confirmText: 'Pilih',
                  cancelText: 'Batal',
                );
                if (chosen != null) {
                  setState(() => date = chosen);
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Slot Masa',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 9,
            runSpacing: 8,
            children:
                [
                      '10:00 pagi',
                      '11:00 pagi',
                      '2:00 petang',
                      '3:00 petang',
                      '4:00 petang',
                    ]
                    .map(
                      (time) => ChoiceChip(
                        label: Text(
                          time,
                          style: TextStyle(
                            fontSize: 11,
                            color: slot == time ? goldLight : ink,
                          ),
                        ),
                        selected: slot == time,
                        selectedColor: black,
                        showCheckmark: false,
                        onSelected: (_) => setState(() => slot = time),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Text(
                'Bilangan Pelawat',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              IconButton(
                onPressed: visitors > 1
                    ? () => setState(() => visitors--)
                    : null,
                icon: const Icon(Icons.remove_circle_outline, size: 23),
              ),
              Text(
                '$visitors',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              IconButton(
                onPressed: visitors < 5
                    ? () => setState(() => visitors++)
                    : null,
                icon: const Icon(Icons.add_circle_outline, size: 23),
              ),
            ],
          ),
          const SizedBox(height: 10),
          input('Catatan (pilihan)', note, optional: true, lines: 3),
          CheckboxListTile(
            value: consent,
            activeColor: goldDark,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text(
              'Saya memahami bahawa lawatan perlu disahkan oleh pihak pengurusan.',
              style: TextStyle(fontSize: 11, color: muted),
            ),
            onChanged: (v) => setState(() => consent = v ?? false),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ActionButton(
              saving ? 'Menyimpan…' : 'Simpan Permintaan Lawatan',
              icon: Icons.calendar_month_outlined,
              onTap: saving
                  ? null
                  : () async {
                      if (!(form.currentState?.validate() ?? false)) {
                        return;
                      }
                      if (date == null || slot == null || !consent) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Sila pilih tarikh, slot masa dan tandakan persetujuan.',
                            ),
                          ),
                        );
                        return;
                      }
                      setState(() => saving = true);
                      await widget.onSubmit({
                        'name': name.text.trim(),
                        'phone': phone.text.trim(),
                        'visitDate': dateText,
                        'slot': slot,
                        'visitors': visitors,
                        'note': note.text.trim(),
                        'date': DateTime.now().toIso8601String(),
                      });
                      if (mounted) {
                        setState(() => saving = false);
                      }
                    },
            ),
          ),
        ],
      ),
    ),
  );
}

Widget input(
  String label,
  TextEditingController controller, {
  bool isPhone = false,
  bool optional = false,
  int lines = 1,
}) => Padding(
  padding: const EdgeInsets.only(bottom: 18),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        maxLines: lines,
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          hintText: isPhone
              ? 'Contoh: 012-3456789'
              : optional
              ? 'Maklumat tambahan'
              : 'Masukkan ${label.toLowerCase()}',
        ),
        style: const TextStyle(fontSize: 13),
        validator: (v) {
          if (optional) {
            return null;
          }
          if ((v ?? '').trim().isEmpty) {
            return 'Sila isi ${label.toLowerCase()}';
          }
          if (isPhone && (v ?? '').replaceAll(RegExp(r'\D'), '').length < 9) {
            return 'Masukkan nombor telefon yang sah';
          }
          return null;
        },
      ),
    ],
  ),
);

class AdmissionForm extends StatefulWidget {
  final Future<void> Function(Map<String, dynamic>) onSubmit;
  const AdmissionForm({super.key, required this.onSubmit});
  @override
  State<AdmissionForm> createState() => _AdmissionFormState();
}

class _AdmissionFormState extends State<AdmissionForm> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(),
      phone = TextEditingController(),
      details = TextEditingController();
  String care = 'Jagaan Warga Emas';
  bool saving = false;
  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    details.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Panel(
    child: Form(
      key: form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          input('Nama Waris', name),
          input('No. Telefon', phone, isPhone: true),
          const Text(
            'Jenis Penjagaan',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: care,
            isExpanded: true,
            items:
                [
                      'Jagaan Warga Emas',
                      'Jagaan OKU',
                      'Jagaan Harian (Day Care)',
                      'Jagaan Penginapan Bulanan',
                    ]
                    .map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(s, style: const TextStyle(fontSize: 12)),
                      ),
                    )
                    .toList(),
            onChanged: (v) => setState(() => care = v!),
          ),
          const SizedBox(height: 20),
          input(
            'Keperluan Penjagaan (pilihan)',
            details,
            optional: true,
            lines: 4,
          ),
          const Text(
            'Elakkan berkongsi nombor MyKad atau maklumat perubatan sensitif di sini. Penilaian terperinci dibuat terus bersama pengurusan.',
            style: TextStyle(color: muted, fontSize: 11),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ActionButton(
              saving ? 'Menyimpan…' : 'Simpan Pertanyaan',
              icon: Icons.description_outlined,
              onTap: saving
                  ? null
                  : () async {
                      if (!(form.currentState?.validate() ?? false)) {
                        return;
                      }
                      setState(() => saving = true);
                      await widget.onSubmit({
                        'name': name.text,
                        'phone': phone.text,
                        'care': care,
                        'note': details.text,
                        'date': DateTime.now().toIso8601String(),
                      });
                      if (mounted) {
                        setState(() => saving = false);
                      }
                    },
            ),
          ),
        ],
      ),
    ),
  );
}
