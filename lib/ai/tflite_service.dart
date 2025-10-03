// lib/ai/tflite_service.dart
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

/// خدمة TFLite بدون tflite_flutter_helper
class TfliteService {
  TfliteService._();
  static final TfliteService instance = TfliteService._();

  Interpreter? _interpreter;
  List<String> _labels = [];

  bool get isReady => _interpreter != null && _labels.isNotEmpty;

  Future<void> init() async {
    if (_interpreter != null) return;

    // 1) تحميل التسميات
    final labelsRaw = await rootBundle.loadString('assets/model/labels.txt');
    _labels = labelsRaw
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    // 2) تحميل النموذج
    final options = InterpreterOptions()..threads = 2;
    _interpreter = await Interpreter.fromAsset(
      'assets/model/plant_disease.tflite',
      options: options,
    );
  }

  /// يبني مصفوفة الإدخال وفق نوع التنسور (float32 أو uint8)
  /// ملاحظة: tflite_flutter يعيد النوع على شكل TensorType
  List _buildInputTensor(
      img.Image resized,
      int h,
      int w,
      int c,
      TensorType inputType,
      ) {
    final isFloat = inputType == TensorType.float32;

    if (isFloat) {
      // [1, h, w, c] double (مطبع 0..1)
      final input = List.generate(
        1,
            (_) => List.generate(
          h,
              (y) => List.generate(
            w,
                (x) {
              final px = resized.getPixel(x, y); // Image 4.x يرجع Pixel
              final r = px.r.toDouble();
              final g = px.g.toDouble();
              final b = px.b.toDouble();

              if (c == 1) {
                final gray = (0.299 * r + 0.587 * g + 0.114 * b) / 255.0;
                return [gray];
              }
              return [r / 255.0, g / 255.0, b / 255.0];
            },
            growable: false,
          ),
          growable: false,
        ),
        growable: false,
      );
      return input;
    } else if (inputType == TensorType.uint8) {
      // [1, h, w, c] int (0..255)
      final input = List.generate(
        1,
            (_) => List.generate(
          h,
              (y) => List.generate(
            w,
                (x) {
              final px = resized.getPixel(x, y);
              final r = px.r;
              final g = px.g;
              final b = px.b;

              if (c == 1) {
                final gray = (0.299 * r + 0.587 * g + 0.114 * b).round();
                return [gray];
              }
              return [r, g, b];
            },
            growable: false,
          ),
          growable: false,
        ),
        growable: false,
      );
      return input;
    } else {
      throw Exception('نوع إدخال غير مدعوم: $inputType');
    }
  }

  Future<({String label, double confidence})> classify(File imageFile) async {
    if (!isReady) {
      await init();
    }
    final interpreter = _interpreter!;

    // 1) أشكال وأنواع التنسورات
    final inputTensor = interpreter.getInputTensor(0);
    final inputShape = inputTensor.shape; // [1, h, w, c]
    final inputType = inputTensor.type;   // TensorType

    final outputTensor = interpreter.getOutputTensor(0);
    final outputShape = outputTensor.shape; // [1, numClasses]
    final outputType = outputTensor.type;   // TensorType

    final h = inputShape[1];
    final w = inputShape[2];
    final c = inputShape.length > 3 ? inputShape[3] : 1;

    // 2) فك الصورة وتغيير حجمها
    final raw = await imageFile.readAsBytes();
    final base = img.decodeImage(raw);
    if (base == null) {
      throw Exception('تعذّر قراءة الصورة.');
    }
    final resized = img.copyResize(base, width: w, height: h);

    // 3) مصفوفة الإدخال
    final input = _buildInputTensor(resized, h, w, c, inputType);

    // 4) مصفوفة الإخراج
    final numClasses = outputShape[1];
    dynamic output;
    if (outputType == TensorType.float32) {
      output = [List<double>.filled(numClasses, 0.0, growable: false)];
    } else if (outputType == TensorType.uint8) {
      output = [List<int>.filled(numClasses, 0, growable: false)];
    } else {
      // fallback
      output = [List<double>.filled(numClasses, 0.0, growable: false)];
    }

    // 5) تشغيل الاستدلال
    interpreter.run(input, output);

    // 6) قراءة النتائج
    late List<double> scores;
    if (outputType == TensorType.uint8) {
      final ints = (output[0] as List).cast<int>();
      scores = ints.map((v) => v / 255.0).toList();
    } else {
      scores = (output[0] as List).map((e) => (e as num).toDouble()).toList();
    }

    // 7) أعلى فئة
    int topIdx = 0;
    double top = -1;
    final limit = min(scores.length, _labels.length);
    for (int i = 0; i < limit; i++) {
      if (scores[i] > top) {
        top = scores[i];
        topIdx = i;
      }
    }

    final label =
    _labels.isNotEmpty && topIdx < _labels.length ? _labels[topIdx] : 'غير معروف';

    final conf = top.isNaN ? 0.0 : top.clamp(0.0, 1.0);

    return (label: label, confidence: conf);
  }

  void close() {
    _interpreter?.close();
    _interpreter = null;
  }
}
