import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _openWhatsApp() async {
    final uri = Uri.parse('https://wa.me/967771471227');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    const double navHeight = kBottomNavigationBarHeight;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 12, 16, navHeight + bottomInset + 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  "المزارع الذكي",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(Icons.park, size: 48, color: Color(0xFF2E7D32)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {/* TODO: المعرض */},
                      icon: const Icon(Icons.photo_library, color: Colors.white),
                      label: const Text(
                        "اختر صورة النبات",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 2,
                    child: IconButton(
                      onPressed: () {/* TODO: الكاميرا */},
                      icon: const Icon(Icons.camera_alt, color: Color(0xFF2E7D32)),
                      tooltip: "التقاط صورة",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.troubleshoot, color: Color(0xFF2E7D32)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: Color(0xFF2E7D32)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {/* TODO */},
                label: const Text(
                  "عرض التشخيص",
                  style: TextStyle(color: Color(0xFF2E7D32), fontSize: 16),
                ),
              ),
            ],
          ),
        ),

        // الاسم والرقم "آخر شي" فوق شريط التنقل
        Positioned(
          left: 0,
          right: 0,
          bottom: navHeight + bottomInset + 8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "تم بناء وبرمجة التطبيق بواسطة م/عبدالغني الغانمي",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: _openWhatsApp,
                borderRadius: BorderRadius.circular(28),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FontAwesomeIcons.whatsapp, color: Colors.green, size: 18),
                      SizedBox(width: 8),
                      Text(
                        '+967 771 471 227',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
