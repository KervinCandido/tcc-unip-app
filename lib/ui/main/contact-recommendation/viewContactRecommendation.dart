import 'package:app_tcc_unip/connection/websocket/websocketController.dart';
import 'package:app_tcc_unip/model/contactRecommendation.dart';
import 'package:app_tcc_unip/service/contactService.dart';
import 'package:app_tcc_unip/ui/main/contact-recommendation/contactRecommendationItem.dart';
import 'package:app_tcc_unip/ui/main/contact-recommendation/contactRecommendationList.dart';
import 'package:app_tcc_unip/ui/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ViewContactRecommendation extends StatefulWidget {
  const ViewContactRecommendation({Key? key}) : super(key: key);

  @override
  _ViewContactRecommendationState createState() =>
      _ViewContactRecommendationState();
}

class _ViewContactRecommendationState extends State<ViewContactRecommendation> {
  final _webSocketController = WebsocketController.getInstance();
  var _contactService = ContactService();
  final List<ContactRecommendation> recommendation = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ContactRecommendation>>(
        future: _contactService.getContactRecommendation(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<ContactRecommendation>> snapshot,
        ) {
          if (snapshot.hasData) {
            List<ContactRecommendation> recommendation =
                snapshot.data ?? List.empty();

            return ContactRecommendationList(recommendation);
          }

          return Container(
            color: Colors.white,
            child: SpinKitSpinningLines(
              color: Colors.redAccent,
            ),
          );
        });
  }
}
