import 'package:app_tcc_unip/connection/websocket/websocketController.dart';
import 'package:app_tcc_unip/model/contactRecommendation.dart';
import 'package:app_tcc_unip/service/contactService.dart';
import 'package:app_tcc_unip/ui/main/contact-recommendation/contactRecommendationItem.dart';
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
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Requisição enviada !!'),
                        ));
                      },
                    ),
                  );
                },
                separatorBuilder: (_, __) => const Divider(),
              ),
            );
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
