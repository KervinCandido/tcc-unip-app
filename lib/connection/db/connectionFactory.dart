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
        await db.execute(
          '''CREATE TABLE IF NOT EXISTS contact(
            USER_ID INTEGER,
            PHOTO TEXT,
            PROFILE_NAME TEXT NOT NULL,
            USER_NAME TEXT PRIMARY KEY
          ) WITHOUT ROWID;''',
        );
        await db.execute(
          '''CREATE TABLE IF NOT EXISTS message(
            USER_ID INTEGER NOT NULL,
            USER_NAME TEXT NOT NULL,
            MESSAGE TEXT NOT NULL,
            IS_SEND INTEGER NOT NULL,
            DATE_MESSAGE TEXT NOT NULL,
            PRIMARY KEY(USER_ID, USER_NAME, DATE_MESSAGE)
          ) WITHOUT ROWID;''',
        );
        await db.execute(
          '''CREATE TABLE IF NOT EXISTS musicalGender(
            MUSICAL_ID INTEGER NOT NULL,
            NAME TEXT NOT NULL,
            PRIMARY KEY(MUSICAL_ID)
          );''',
        );

        await db.execute(
          '''CREATE TABLE IF NOT EXISTS movieGender(
            MOVIE_ID INTEGER NOT NULL,
            NAME TEXT NOT NULL,
            PRIMARY KEY(MOVIE_ID)
          );''',
        );

        await db.execute(
          '''CREATE TABLE IF NOT EXISTS favoriteMusicalGender(
            USER_ID INTEGER NOT NULL,
            MUSICAL_ID INTEGER NOT NULL,
            PRIMARY KEY(USER_ID, MUSICAL_ID)
          ) ;''',
        );
        await db.execute(
          '''CREATE TABLE IF NOT EXISTS favoriteMovieGender(
            USER_ID INTEGER NOT NULL,
            MOVIE_ID INTEGER NOT NULL,
            PRIMARY KEY(USER_ID, MOVIE_ID)
          ) ;''',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {},
      version: 1,
    );
  }
}
