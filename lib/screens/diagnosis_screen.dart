import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/history_db.dart';
import '../models/diagnosis_record.dart';
import '../ai/tflite_service.dart';

class DiagnosisScreen extends StatefulWidget {
  static const routeName = '/diagnosis';
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  File? _image;
  bool _busy = false;
  String? _resultLabel;
  double? _confidence;

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // حمِّل الموديل فور الدخول للشاشة (مرة واحدة)
    TfliteService.instance.init();
  }

  @override
  void dispose() {
    // إن حبيت تغلقه عند مغادرة الشاشة:
    // TfliteService.instance.close();
    super.dispose();
  }

  Future<void> _pickFrom(ImageSource src) async {
    final x = await _picker.pickImage(source: src, imageQuality: 90);
    if (x != null) setState(() => _image = File(x.path));
  }

  Future<void> _runDiagnosis() async {
    if (_image == null) return;

    setState(() {
      _busy = true;
      _resultLabel = null;
      _confidence = null;
    });

    try {
      final result = await TfliteService.instance.classify(_image!);

      setState(() {
        _resultLabel = result.label;
        _confidence = result.confidence;
      });

      // حفظ في السجل
      final rec = DiagnosisRecord(
        imagePath: _image!.path,
        label: result.label,
        confidence: result.confidence,
        createdAt: DateTime.now(),
        notes: 'تشخيص TFLite',
      );
      await HistoryDb.instance.insert(rec);

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('تم الحفظ في السجل')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('فشل التشخيص: $e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.primary.withOpacity(.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('التشخيص بالصور',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  'التقط صورة للورقة/الثمرة/الساق ثم اضغط "تشخيص". '
                      'النتيجة تُحفظ تلقائيًا في السجل.',
                  style: TextStyle(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // عارض الصورة
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: cs.outlineVariant),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _image == null
                  ? const Center(child: Text('لا توجد صورة بعد'))
                  : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_image!, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : () => _pickFrom(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_rounded),
                  label: const Text('كاميرا'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : () => _pickFrom(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_rounded),
                  label: const Text('المعرض'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          FilledButton.icon(
            onPressed: _busy || _image == null ? null : _runDiagnosis,
            icon: _busy
                ? const SizedBox(
                width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.biotech_rounded),
            label: Text(_busy ? 'جارٍ التشخيص…' : 'تشخيص'),
          ),

          if (_resultLabel != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: cs.outlineVariant),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.verified_outlined, color: cs.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'النتيجة: $_resultLabel '
                          '— الثقة: ${((_confidence ?? 0) * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
