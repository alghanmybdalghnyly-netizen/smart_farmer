import 'package:flutter/material.dart';
import 'diagnosis_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primary.withOpacity(.12), cs.primary.withOpacity(.04)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: cs.primary.withOpacity(.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('مرحبًا بك 👋', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  'ابدأ بفحص نباتاتك بالذكاء الاصطناعي أو تصفّح أدلة المحاصيل والطقس.',
                  style: TextStyle(color: cs.onSurface.withOpacity(.85)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pushReplacementNamed(context, DiagnosisScreen.routeName),
                      icon: const Icon(Icons.camera_alt_rounded),
                      label: const Text('فحص النبات الآن'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      child: const Text('فتح القائمة'),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _HowToUse(),
        ],
      ),
    );
  }
}

class _HowToUse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final items = const [
      ('التشخيص', 'التقط صورة وسيتم التحليل محليًا (سنضيف TFLite لاحقًا).'),
      ('محاصيلي', 'أدلة القات والبن والذرة والطماطم وغيرها.'),
      ('الطقس', 'عرض الطقس عند توفر الإنترنت.'),
      ('الخدمات', 'أدوات مساندة سنضيفها لاحقًا.'),
      ('السجل', 'مراجعة تشخيصاتك السابقة.'),
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('كيف تستخدم التطبيق؟', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 12),
          ...items.map((e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, color: cs.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style.copyWith(height: 1.6),
                      children: [
                        TextSpan(text: '${e.$1}: ', style: const TextStyle(fontWeight: FontWeight.w700)),
                        TextSpan(text: e.$2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
