import 'package:app_tcc_unip/model/contactRecommendation.dart';

class RequestContact {
  int id;
  ContactRecommendation requester;
  ContactRecommendation requested;

  RequestContact(this.id, this.requester, this.requested);

  factory RequestContact.fromJson(Map<String, dynamic> json) {
    return RequestContact(
      json['requestId'],
      ContactRecommendation.fromJson(json['from']),
      ContactRecommendation.fromJson(json['to']),
    );
  }
}
