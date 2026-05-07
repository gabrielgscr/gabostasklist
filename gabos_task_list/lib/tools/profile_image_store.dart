import 'package:sqflite_sqlcipher/sqflite.dart';

class ProfileImageStore {
  static const String _dbName = 'gabos_task_database.db';
  static const String _tableName = 'person_profile_images';

  static Future<Database> _openDb() async {
    final dbPath = await getDatabasesPath();
    final fullPath = '$dbPath/$_dbName';

    final db = await openDatabase(fullPath);
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tableName (
        personId INTEGER PRIMARY KEY,
        imagePath TEXT NOT NULL,
        updatedDate TEXT,
        FOREIGN KEY(personId) REFERENCES persons(personId) ON DELETE CASCADE
      )
    ''');

    return db;
  }

  static Future<void> saveImagePath(int personId, String imagePath) async {
    final db = await _openDb();
    await db.insert(_tableName, {
      'personId': personId,
      'imagePath': imagePath,
      'updatedDate': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<String?> getImagePath(int personId) async {
    final db = await _openDb();
    final result = await db.query(
      _tableName,
      columns: ['imagePath'],
      where: 'personId = ?',
      whereArgs: [personId],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first['imagePath'] as String?;
  }

  static Future<void> removeImagePath(int personId) async {
    final db = await _openDb();
    await db.delete(_tableName, where: 'personId = ?', whereArgs: [personId]);
  }
}
