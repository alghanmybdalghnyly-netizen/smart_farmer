import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/crop.dart';

class CropsRepository {
  static List<CropCategory>? _cache;

  static Future<List<CropCategory>> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/crops/metadata.json');
    final obj = jsonDecode(raw) as Map<String, dynamic>;
    final list = (obj['categories'] as List<dynamic>)
        .map((e) => CropCategory.fromMap(e as Map<String, dynamic>))
        .toList();
    _cache = list;
    return list;
  }

  static Future<List<CropInfo>> search(String query) async {
    final cats = await load();
    final q = query.trim();
    if (q.isEmpty) {
      return cats.expand((c) => c.crops).toList();
    }
    final lower = q.toLowerCase();
    return cats
        .expand((c) => c.crops)
        .where((crop) =>
    crop.name.toLowerCase().contains(lower) ||
        crop.season.toLowerCase().contains(lower) ||
        crop.harvest.toLowerCase().contains(lower) ||
        crop.soil.toLowerCase().contains(lower) ||
        crop.irrigation.toLowerCase().contains(lower) ||
        crop.fertilization.toLowerCase().contains(lower) ||
        crop.diseases.any((d) =>
        d.name.toLowerCase().contains(lower) ||
            d.treatment.toLowerCase().contains(lower)))
        .toList();
  }
}
