import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const DB_NAME = 'tcc_unip.db';

class ConnectionFactory {
  static ConnectionFactory _instance = ConnectionFactory._();

  ConnectionFactory._();

  factory ConnectionFactory.getInstance() {
    return _instance;
  }

  // Future<Database> get connection async {
  //   return openDatabase(
  //     join(await getDatabasesPath(), DB_NAME),
  //     onCreate: (db, version) {
  //       return db.execute(
  //         '''CREATE TABLE ();''',
  //       );
  //     },
  //     version: 1,
  //   );
  // }
}
