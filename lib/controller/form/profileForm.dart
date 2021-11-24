import 'dart:io';

import 'package:app_tcc_unip/model/movieGenrer.dart';
import 'package:app_tcc_unip/model/musicalGenrer.dart';
import 'package:intl/intl.dart';

class ProfileForm {
  final int userId;
  final String profileName;
  final DateTime birthDate;
  final String gender;
  File? photo;
  final String? description;
  List<int> favoriteMusicalGenrer;
  List<int> favoriteMovieGenrer;

  ProfileForm(
    this.userId,
    this.profileName,
    this.birthDate,
    this.gender,
    this.photo,
    this.description,
    this.favoriteMusicalGenrer,
    this.favoriteMovieGenrer,
  );

  get birthDateISO => DateFormat('yyyy-MM-dd').format(birthDate);
}
