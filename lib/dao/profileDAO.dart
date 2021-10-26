import 'package:app_tcc_unip/connection/db/connectionFactory.dart';
import 'package:app_tcc_unip/model/profile.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqlite_api.dart';

class ProfileDAO {
  final _db = ConnectionFactory.getInstance();
  final _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> insertOrUpdate(Profile profile) async {
    final db = await _db.connection;
    var value = await db.insert(
      'profile',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('INSERT PROFILE: $value');
  }

  Future<Profile?> profileByUserId(int id) async {
    final db = await _db.connection;

    final List<Map<String, dynamic>> maps = await db.query(
      'profile',
      where: 'USER_ID = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.length < 1) return null;

    return Profile(
      maps[0]['USER_ID'],
      maps[0]['PROFILE_NAME'],
      _dateFormat.parse(maps[0]['BIRTH_DATE']),
      maps[0]['GENDER'],
      maps[0]['PHOTO'],
      maps[0]['DESCRIPTION'],
    );
  }
}
