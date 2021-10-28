import 'package:app_tcc_unip/model/profile.dart';
import 'package:intl/intl.dart';

class ProfileForm {
  final int userId;
  final String profileName;
  final DateTime birthDate;
  final String gender;
  String? photo;
  final String? description;

  String? photoPath;

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

  Profile toProfile() {
    return Profile(
      userId,
      profileName,
      birthDate,
      gender,
      photoPath,
      description,
    );
  }
}
