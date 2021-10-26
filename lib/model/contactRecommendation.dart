class ContactRecommendation {
  String userName;
  String? photoProfile;
  String profileName;

  ContactRecommendation({
    required this.userName,
    required this.photoProfile,
    required this.profileName,
  });

  factory ContactRecommendation.fromJson(Map<String, dynamic> json) {
    return ContactRecommendation(
      userName: json['userName'],
      photoProfile: json['photoProfile'],
      profileName: json['profileName'],
    );
  }

  @override
  String toString() {
    return 'userName: $userName, profileName: $profileName';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ContactRecommendation && other.userName == userName;
  }

  @override
  int get hashCode => super.hashCode;
}
