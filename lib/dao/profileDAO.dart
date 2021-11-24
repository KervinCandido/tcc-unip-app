import 'package:app_tcc_unip/connection/db/connectionFactory.dart';
import 'package:app_tcc_unip/model/movieGenrer.dart';
import 'package:app_tcc_unip/model/musicalGenrer.dart';
import 'package:app_tcc_unip/model/profile.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqlite_api.dart';

class ProfileDAO {
  final _db = ConnectionFactory.getInstance();
  final _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> insertOrUpdate(Profile profile) async {
    final db = await _db.connection;
    await db.insert(
      'profile',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.delete('favoriteMusicalGender',
        where: 'USER_ID = ?', whereArgs: [profile.userId]);

    await db.delete('favoriteMovieGender',
        where: 'USER_ID = ?', whereArgs: [profile.userId]);

    var favoriteMusicalGenrer = profile.favoriteMusicalGenrer;
    for (final mg in favoriteMusicalGenrer) {
      await db.insert('favoriteMusicalGender', {
        'USER_ID': profile.userId,
        'MUSICAL_ID': mg.id,
      });
    }

    var favoriteMovieGenrer = profile.favoriteMovieGenrer;
    for (final mg in favoriteMovieGenrer) {
      await db.insert('favoriteMovieGender', {
        'USER_ID': profile.userId,
        'MOVIE_ID': mg.id,
      });
    }
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

    List<Map<String, dynamic>> resultfavoriteMusicalGender = await db.rawQuery(
      '''
      SELECT mg.MUSICAL_ID, mg.NAME FROM favoriteMusicalGender fmg 
        INNER JOIN 
          musicalGender mg
        ON fmg.MUSICAL_ID = mg.MUSICAL_ID
      WHERE fmg.USER_ID = ?
    ''',
      [id],
    );

    final favoriteMusicalGenrer =
        List.generate(resultfavoriteMusicalGender.length, (index) {
      return MusicalGenrer(
        id: resultfavoriteMusicalGender[index]['MUSICAL_ID'],
        name: resultfavoriteMusicalGender[index]['NAME'],
      );
    });

    List<Map<String, dynamic>> resultfavoriteMovieGender = await db.rawQuery(
      '''
      SELECT mg.MOVIE_ID, mg.NAME FROM favoriteMovieGender fmg 
        INNER JOIN 
          movieGender mg
        ON fmg.MOVIE_ID = mg.MOVIE_ID
      WHERE fmg.USER_ID = ?
    ''',
      [id],
    );

    final favoriteMovieGender =
        List.generate(resultfavoriteMovieGender.length, (index) {
      return MovieGenrer(
        id: resultfavoriteMovieGender[index]['MOVIE_ID'],
        name: resultfavoriteMovieGender[index]['NAME'],
      );
    });

    return Profile(
      maps[0]['USER_ID'],
      maps[0]['PROFILE_NAME'],
      _dateFormat.parse(maps[0]['BIRTH_DATE']),
      maps[0]['GENDER'],
      maps[0]['PHOTO'],
      maps[0]['DESCRIPTION'],
      favoriteMusicalGenrer,
      favoriteMovieGender,
    );
  }
}
