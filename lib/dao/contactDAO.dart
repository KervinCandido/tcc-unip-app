import 'package:app_tcc_unip/connection/db/connectionFactory.dart';
import 'package:app_tcc_unip/model/contact.dart';
import 'package:sqflite/sqlite_api.dart';

class ContactDAO {
  final _db = ConnectionFactory.getInstance();

  Future<void> insertOrUpdate(Contact contact) async {
    final db = await _db.connection;
    var value = await db.insert(
      'contact',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('INSERT contact: $value');
  }

  Future<List<Contact>> listContacts(int userId) async {
    final db = await _db.connection;
    final List<Map<String, dynamic>> maps = await db.query(
      'contact',
      where: "USER_ID = ?",
      whereArgs: [userId],
    );

    return List.generate(
      maps.length,
      (index) => Contact(
        maps[index]['USER_ID'],
        maps[index]['PHOTO'],
        maps[index]['PROFILE_NAME'],
        maps[index]['USER_NAME'],
      ),
    );
  }
}
