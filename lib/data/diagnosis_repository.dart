import 'package:sqflite/sqflite.dart';
import '../models/diagnosis_record.dart';
import 'app_database.dart';

class DiagnosisRepository {
  static const _table = 'diagnosis_records';

  static Future<int> insert(DiagnosisRecord r) async {
    final db = await AppDatabase.instance();
    return db.insert(_table, r.toMap());
  }

  static Future<List<DiagnosisRecord>> all({int? limit, int? offset}) async {
    final db = await AppDatabase.instance();
    final rows = await db.query(
      _table,
      orderBy: 'createdAt DESC',
      limit: limit,
      offset: offset,
    );
    return rows.map(DiagnosisRecord.fromMap).toList();
  }

  static Future<int> delete(int id) async {
    final db = await AppDatabase.instance();
    return db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> clear() async {
    final db = await AppDatabase.instance();
    return db.delete(_table);
  }
}
