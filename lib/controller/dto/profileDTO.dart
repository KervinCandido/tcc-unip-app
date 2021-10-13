import 'package:intl/intl.dart';

class ProfileDTO {
  final int id;
  final int userId;
  final String profileName;
  final DateTime birthDate;
  final String gender;
  final String? photo;
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
}
