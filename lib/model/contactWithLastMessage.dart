import 'package:app_tcc_unip/model/contactRecommendation.dart';

class ContactWithLastMessage extends ContactRecommendation {
  String lastMessage;

  ContactWithLastMessage({
    required userName,
    required photoProfile,
    required profileName,
    required this.lastMessage,
  }) : super(
          userName: userName,
          photoProfile: photoProfile,
          profileName: profileName,
        );
}
