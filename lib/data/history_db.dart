import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/diagnosis_record.dart';

class HistoryDb {
  static final HistoryDb instance = HistoryDb._internal();
  HistoryDb._internal();

  static const _dbName = 'smart_farmer.db';
  static const _dbVersion = 1;
  static const _table = 'diagnosis_history';

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_table(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            image_path TEXT NOT NULL,
            label TEXT NOT NULL,
            confidence REAL NOT NULL,
            created_at TEXT NOT NULL,
            notes TEXT
          )
        ''');
      },
    );
  }

  Future<int> insert(DiagnosisRecord r) async {
    final db = await database;
    return await db.insert(_table, r.toMap());
  }

  Future<List<DiagnosisRecord>> fetchAll() async {
    final db = await database;
    final rows = await db.query(_table, orderBy: 'created_at DESC');
    return rows.map((e) => DiagnosisRecord.fromMap(e)).toList();
  }

  Future<int> clearAll() async {
    final db = await database;
    return await db.delete(_table);
  }
}
