import 'package:app_tcc_unip/connection/db/connectionFactory.dart';
import 'package:app_tcc_unip/model/musicalGenrer.dart';
import 'package:sqflite/sqlite_api.dart';

class MusicalGenrerDAO {
  final _db = ConnectionFactory.getInstance();

  Future<void> insertOrUpdate(MusicalGenrer musicalGenrer) async {
    final db = await _db.connection;
    await db.insert(
      'musicalGender',
      musicalGenrer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertOrUpdateList(List<MusicalGenrer> musicalGenrer) async {
    musicalGenrer.forEach((element) => insertOrUpdate(element));
  }

  Future<List<MusicalGenrer>> findAll() async {
    final db = await _db.connection;

    final List<Map<String, dynamic>> maps = await db.query('musicalGender');

    if (maps.length < 1) return [];

    return List.generate(
      maps.length,
      (index) => MusicalGenrer(
        id: maps[index]['MUSICAL_ID'],
        name: maps[index]['NAME'],
      ),
    );
  }
}
