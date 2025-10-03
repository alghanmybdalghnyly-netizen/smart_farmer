import 'package:flutter/material.dart';
import '../models/crop.dart';

class CropDetailScreen extends StatelessWidget {
  static const routeName = '/cropDetail';
  final CropInfo crop;
  const CropDetailScreen({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(crop.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _StatTile(title: 'موسم الزراعة', value: crop.season),
            _StatTile(title: 'موعد الحصاد', value: crop.harvest),
            _StatTile(title: 'التربة المناسبة', value: crop.soil),
            _StatTile(title: 'الري', value: crop.irrigation),
            _StatTile(title: 'التسميد', value: crop.fertilization),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text('الأمراض الشائعة وعلاجها',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(height: 8),
            ...crop.diseases.map((d) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surface,
                border: Border.all(color: cs.outlineVariant),
                borderRadius: BorderRadius.circular(12),
              ),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style.copyWith(height: 1.6),
                  children: [
                    const TextSpan(
                        text: 'المرض: ', style: TextStyle(fontWeight: FontWeight.w700)),
                    TextSpan(text: '${d.name}\n'),
                    const TextSpan(
                        text: 'العلاج: ', style: TextStyle(fontWeight: FontWeight.w700)),
                    TextSpan(text: d.treatment),
                  ],
                ),
              ),
            )),
            if (crop.notes != null && crop.notes!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text('ملاحظات إضافية',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(crop.notes!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;
  const _StatTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style.copyWith(height: 1.6),
          children: [
            TextSpan(text: '$title: ', style: const TextStyle(fontWeight: FontWeight.w700)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
