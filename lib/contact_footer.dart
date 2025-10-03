import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactFooter extends StatelessWidget {
  const ContactFooter({super.key});

  static const String phone = '+967 771 471 227';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'تم بناء وتصميم البرنامج بواسطة م/عبدالغني الغانمي',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            InkWell(
              onTap: () => launchUrl(Uri.parse('https://wa.me/967771471227')),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.whatsapp, size: 18, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      phone,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
