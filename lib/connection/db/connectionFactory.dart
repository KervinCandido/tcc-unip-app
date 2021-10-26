import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const DB_NAME = 'tcc_unip.db';

class ConnectionFactory {
  static ConnectionFactory _instance = ConnectionFactory._();

  ConnectionFactory._();

  factory ConnectionFactory.getInstance() {
    return _instance;
  }

  Future<Database> get connection async {
    return openDatabase(
      join(await getDatabasesPath(), DB_NAME),
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE IF NOT EXISTS setting(
            KEY TEXT PRIMARY KEY,
            VALUE TEXT
          ) WITHOUT ROWID;''');
        await db.execute(
          '''CREATE TABLE IF NOT EXISTS profile(
            USER_ID INTEGER PRIMARY KEY,
            PROFILE_NAME TEXT NOT NULL,
            BIRTH_DATE TEXT NOT NULL,
            GENDER TEXT NOT NULL,
            PHOTO TEXT,
            DESCRIPTION TEXT
          );''',
        );
      },
      version: 1,
    );
  }
}
