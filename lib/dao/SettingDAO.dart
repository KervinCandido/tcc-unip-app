import 'package:app_tcc_unip/connection/db/connectionFactory.dart';
import 'package:app_tcc_unip/model/setting.dart';
import 'package:sqflite/sqlite_api.dart';

class SettingDAO {
  final _db = ConnectionFactory.getInstance();

  Future<void> insert(Setting setting) async {
    final db = await _db.connection;
    await db.insert(
      'setting',
      setting.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
