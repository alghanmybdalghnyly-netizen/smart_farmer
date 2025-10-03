class DiagnosisRecord {
  final int? id;
  final String imagePath; // مسار الصورة المحفوظة محليًا (إن وُجد)
  final String label;     // اسم المرض/الحالة
  final double confidence; // نسبة الثقة 0..1
  final DateTime createdAt;
  final String? notes;

  DiagnosisRecord({
    this.id,
    required this.imagePath,
    required this.label,
    required this.confidence,
    required this.createdAt,
    this.notes,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'image_path': imagePath,
    'label': label,
    'confidence': confidence,
    'created_at': createdAt.toIso8601String(),
    'notes': notes,
  };

  factory DiagnosisRecord.fromMap(Map<String, dynamic> m) => DiagnosisRecord(
    id: m['id'] as int?,
    imagePath: m['image_path'] as String,
    label: m['label'] as String,
    confidence: (m['confidence'] as num).toDouble(),
    createdAt: DateTime.parse(m['created_at'] as String),
    notes: m['notes'] as String?,
  );
}
