import 'package:app_tcc_unip/connection/db/connectionFactory.dart';
import 'package:app_tcc_unip/model/message.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqlite_api.dart';

class MessageDAO {
  final _db = ConnectionFactory.getInstance();
  final _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss SSS');

  Future<void> insertOrUpdate(Message message) async {
    final db = await _db.connection;
    await db.insert(
      'message',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('message inserida');
  }

  Future<List<Message>> messageList(int userId) async {
    final db = await _db.connection;
    final List<Map<String, dynamic>> maps = await db.query(
      'message',
      where: "USER_ID = ?",
      whereArgs: [userId],
      orderBy: "DATE_MESSAGE ASC",
    );

    return List.generate(
      maps.length,
      (index) => Message(
        maps[index]['USER_ID'],
        maps[index]['USER_NAME'],
        maps[index]['MESSAGE'],
        maps[index]['IS_SEND'] == 1,
        _dateFormat.parse(maps[index]['DATE_MESSAGE']),
      ),
    );
  }
}
