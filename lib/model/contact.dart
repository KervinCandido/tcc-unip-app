class Contact {
  final int userId;
  final String? photo;
  final String profileName;
  final String userName;

  Contact(this.userId, this.photo, this.profileName, this.userName);

  Map<String, dynamic> toMap() {
    return {
      "USER_ID": userId,
      "PHOTO": photo,
      "PROFILE_NAME": profileName,
      "USER_NAME": userName,
    };
  }
}
