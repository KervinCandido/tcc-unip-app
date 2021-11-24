import 'package:app_tcc_unip/model/movieGenrer.dart';
import 'package:app_tcc_unip/model/musicalGenrer.dart';
import 'package:intl/intl.dart';

class Profile {
  final int userId;
  final String profileName;
  final DateTime birthDate;
  final String gender;
  final String? photo;
  final String? description;
  List<MusicalGenrer> favoriteMusicalGenrer;
  List<MovieGenrer> favoriteMovieGenrer;

  final _dateFormat = DateFormat('yyyy-MM-dd');

  Profile(
    this.userId,
    this.profileName,
    this.birthDate,
    this.gender,
    this.photo,
    this.description,
    this.favoriteMusicalGenrer,
    this.favoriteMovieGenrer,
  );

  Map<String, dynamic> toMap() {
    return {
      'USER_ID': userId,
      'PROFILE_NAME': profileName,
      'BIRTH_DATE': _dateFormat.format(birthDate),
      'GENDER': gender,
      'PHOTO': photo,
      'DESCRIPTION': description,
    };
  }

  String get birthDateFormatted => _dateFormat.format(birthDate);

  @override
  String toString() {
    return '''Profile: {
      user_id: $userId,
      profile_name: $profileName,
      birth_date: $birthDateFormatted,
      gender: $gender,
      photo: ${photo != null ? photo!.substring(0, 20) : ''}
      description: ${description != null ? description!.substring(0, 20) : ''}
    }''';
  }
}
