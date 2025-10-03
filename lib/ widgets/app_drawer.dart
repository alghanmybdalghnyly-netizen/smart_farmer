import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/crops_screen.dart';
import '../screens/diagnosis_screen.dart';
import '../screens/history_screen.dart';
import '../screens/home_screen.dart';
import '../screens/services_screen.dart';
import '../screens/weather_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<void> _openWhatsApp() async {
    const phone = '967771471227';
    final uri = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _go(BuildContext context, String route) {
    Navigator.of(context).pop();
    if (ModalRoute.of(context)?.settings.name == route) return;
    Navigator.of(context).pushReplacementNamed(route);
    return;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // نبذة أعلى القائمة
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [cs.primary.withOpacity(.12), cs.primary.withOpacity(.04)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.primary.withOpacity(.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    CircleAvatar(
                      backgroundColor: cs.primary.withOpacity(.15),
                      child: Icon(Icons.agriculture, color: cs.primary),
                    ),
                    const SizedBox(width: 12),
                    const Text('المزارع الذكي',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  ]),
                  const SizedBox(height: 12),
                  Text(
                    'تشخيص أمراض النبات بالذكاء الاصطناعي بدون إنترنت، '
                        'مع إرشادات المحاصيل اليمنية والطقس عند الاتصال.',
                    style: TextStyle(color: cs.onSurface.withOpacity(.8)),
                  ),
                ],
              ),
            ),

            // العناصر
            _Tile(icon: Icons.home_filled, title: 'الرئيسية',
                onTap: () => _go(context, HomeScreen.routeName)),
            _Tile(icon: Icons.camera_alt_rounded, title: 'التشخيص',
                onTap: () => _go(context, DiagnosisScreen.routeName)),
            _Tile(icon: Icons.grass_rounded, title: 'محاصيلي',
                onTap: () => _go(context, CropsScreen.routeName)),
            _Tile(icon: Icons.cloud_rounded, title: 'الطقس',
                onTap: () => _go(context, WeatherScreen.routeName)),
            _Tile(icon: Icons.build_circle_rounded, title: 'الخدمات',
                onTap: () => _go(context, ServicesScreen.routeName)),
            _Tile(icon: Icons.history_rounded, title: 'السجل',
                onTap: () => _go(context, HistoryScreen.routeName)),

            const Spacer(),

            // تذييل المصمم + واتساب
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  Divider(color: cs.outlineVariant),
                  const SizedBox(height: 8),
                  const Text('تم تصميم وبناء البرنامج بواسطة:',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  const Text('م/ عبدالغني الغانمي',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 6),
                  Directionality( // لعرض الرقم بصيغة LTR
                    textDirection: TextDirection.ltr,
                    child: const Text('967771471227',
                        style: TextStyle(letterSpacing: 1.0)),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _openWhatsApp,
                      icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 18),
                      label: const Text('تواصل واتساب'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _Tile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: cs.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: onTap,
    );
  }
}
