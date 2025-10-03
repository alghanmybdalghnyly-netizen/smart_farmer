class CropDisease {
  final String name;
  final String treatment;
  CropDisease({required this.name, required this.treatment});

  factory CropDisease.fromMap(Map<String, dynamic> m) =>
      CropDisease(name: m['name'] as String, treatment: m['treatment'] as String);
}

class CropInfo {
  final String id;
  final String name;
  final String season;
  final String harvest;
  final String soil;
  final String irrigation;
  final String fertilization;
  final List<CropDisease> diseases;
  final String? notes;

  CropInfo({
    required this.id,
    required this.name,
    required this.season,
    required this.harvest,
    required this.soil,
    required this.irrigation,
    required this.fertilization,
    required this.diseases,
    this.notes,
  });

  factory CropInfo.fromMap(Map<String, dynamic> m) => CropInfo(
    id: m['id'],
    name: m['name'],
    season: m['season'],
    harvest: m['harvest'],
    soil: m['soil'],
    irrigation: m['irrigation'],
    fertilization: m['fertilization'],
    diseases: (m['diseases'] as List<dynamic>)
        .map((e) => CropDisease.fromMap(e as Map<String, dynamic>))
        .toList(),
    notes: m['notes'],
  );
}

class CropCategory {
  final String id;
  final String name;
  final List<CropInfo> crops;

  CropCategory({required this.id, required this.name, required this.crops});

  factory CropCategory.fromMap(Map<String, dynamic> m) => CropCategory(
    id: m['id'],
    name: m['name'],
    crops: (m['crops'] as List<dynamic>)
        .map((e) => CropInfo.fromMap(e as Map<String, dynamic>))
        .toList(),
  );
}
