import 'package:app_tcc_unip/connection/websocket/websocketController.dart';
import 'package:app_tcc_unip/model/contactRecommendation.dart';
import 'package:app_tcc_unip/ui/main/contact-recommendation/contactRecommendationItem.dart';
import 'package:flutter/material.dart';

class ContactRecommendationList extends StatefulWidget {
  final List<ContactRecommendation> recommendation;
  const ContactRecommendationList(this.recommendation, {Key? key})
      : super(key: key);

  @override
  _ContactRecommendationListState createState() =>
      _ContactRecommendationListState(this.recommendation);
}

class _ContactRecommendationListState extends State<ContactRecommendationList> {
  final _webSocketController = WebsocketController.getInstance();
  final List<ContactRecommendation> recommendation;

  _ContactRecommendationListState(this.recommendation);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: ListView.separated(
        itemCount: recommendation.length,
        itemBuilder: (_, int index) {
          return Container(
            child: ContactRecommendationItem(
              contact: recommendation[index],
              onAdd: (var contact) {
                setState(() {
                  recommendation.remove(contact);
                  _webSocketController.requestAddContact(contact);
                });
              },
            ),
          );
        },
        separatorBuilder: (_, __) => const Divider(),
      ),
    );
  }
}
