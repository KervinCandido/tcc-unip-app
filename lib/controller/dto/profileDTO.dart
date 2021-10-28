import 'package:app_tcc_unip/model/profile.dart';
import 'package:intl/intl.dart';

class ProfileDTO {
  final int id;
  final int userId;
  final String profileName;
  final DateTime birthDate;
  final String gender;
  String? photo;
  final String? description;

  ProfileDTO({
    required this.id,
    required this.userId,
    required this.profileName,
    required this.birthDate,
    required this.gender,
    this.photo,
    this.description,
  });

  String get birthDateFormatted =>
      DateFormat('dd/MM/yyyy').format(this.birthDate);

  factory ProfileDTO.fromJson(Map<String, dynamic> json) {
    return ProfileDTO(
      id: json['id'],
      userId: json['userId'],
      profileName: json['profileName'],
      birthDate: DateFormat('yyyy-MM-dd').parse(json['birthDate']),
      gender: json['gender'],
      photo: json['photo'],
      description: json['description'],
    );
  }

  @override
  String toString() {
    return '''ProfileDTO{
      id: $id,
      userId: $userId,
      profileName: $profileName,
      birthDate: $birthDate,
      gender: $gender,
      photo: $photo,
      description: $description
    }''';
  }

  Profile toProfile() {
    return Profile(
      userId,
      profileName,
      birthDate,
      gender,
      photo,
      description,
    );
  }

  factory ProfileDTO.fromProfile(Profile profile) {
    return ProfileDTO(
      id: 0,
      userId: profile.userId,
      profileName: profile.profileName,
      birthDate: profile.birthDate,
      gender: profile.gender,
      photo: profile.photo,
      description: profile.description,
    );
  }
}
