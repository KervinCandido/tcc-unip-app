import 'package:app_tcc_unip/connection/db/connectionFactory.dart';
import 'package:app_tcc_unip/model/movieGenrer.dart';
import 'package:sqflite/sqlite_api.dart';

class MovieGenrerDAO {
  final _db = ConnectionFactory.getInstance();

  Future<void> insertOrUpdate(MovieGenrer movieGenrer) async {
    final db = await _db.connection;
    await db.insert(
      'movieGender',
      movieGenrer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertOrUpdateList(List<MovieGenrer> movieGenrer) async {
    movieGenrer.forEach((element) => insertOrUpdate(element));
  }

  Future<List<MovieGenrer>> findAll() async {
    final db = await _db.connection;

    final List<Map<String, dynamic>> maps = await db.query('movieGender');

    if (maps.length < 1) return [];

    return List.generate(
      maps.length,
      (index) => MovieGenrer(
        id: maps[index]['MOVIE_ID'],
        name: maps[index]['NAME'],
      ),
    );
  }
}
