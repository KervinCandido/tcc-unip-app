import 'package:intl/intl.dart';

class ProfileForm {
  final int userId;
  final String profileName;
  final DateTime birthDate;
  final String gender;
  final String? photo;
  final String? description;

  ProfileForm(this.userId, this.profileName, this.birthDate, this.gender,
      this.photo, this.description);

  Map toJson() {
    return {
      'userId': this.userId,
      'profileName': this.profileName,
      'birthDate': DateFormat('yyyy-MM-dd').format(this.birthDate),
      'gender': this.gender,
      'photo': photo == null ? null : photo,
      'description': description == null ? null : description
    };
  }
}
