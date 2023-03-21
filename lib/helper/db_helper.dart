import 'package:flutter_complete_guide/providers/great_places.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sql.dart';

class DBHelper {
  static Future<sql.Database> database(String table) async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE $table('
            '$DB_TABLE_PLACES_ID TEXT PRIMARY KEY, '
            '$DB_TABLE_PLACES_TITLE TEXT, '
            '$DB_TABLE_PLACES_IMAGE TEXT, '
            '$DB_TABLE_PLACES_LOC_LAT REAL, '
            '$DB_TABLE_PLACES_LOC_LNG REAL, '
            '$DB_TABLE_PLACES_ADDRESS TEXT)');
      },
      version: 1,
    );
  }

  static Future<void> insert(
    String table,
    Map<String, Object> data,
  ) async {
    final db = await DBHelper.database(table);
    db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, Object>>> get(String table) async {
    final db = await DBHelper.database(table);
    return db.query(table);
  }
}
