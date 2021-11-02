import 'dart:io';

import 'package:intl/intl.dart';

class ProfileForm {
  final int userId;
  final String profileName;
  final DateTime birthDate;
  final String gender;
  File? photo;
  final String? description;

  ProfileForm(this.userId, this.profileName, this.birthDate, this.gender,
      this.photo, this.description);

  get birthDateISO => DateFormat('yyyy-MM-dd').format(birthDate);
}
