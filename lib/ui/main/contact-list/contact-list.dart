import 'package:app_tcc_unip/connection/websocket/websocketController.dart';
import 'package:app_tcc_unip/model/contactWithLastMessage.dart';
import 'package:app_tcc_unip/model/messageForm.dart';
import 'package:app_tcc_unip/service/contactService.dart';
import 'package:app_tcc_unip/ui/main/contact-list/contact-item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final _contactService = ContactService();

  _ContactListState() {
    PaintingBinding.instance!.imageCache!.clear();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ContactWithLastMessage>>(
        future: _contactService.getContacts(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<ContactWithLastMessage>> snapshot,
        ) {
          if (snapshot.hasData) {
            List<ContactWithLastMessage> contacts =
                snapshot.data ?? List.empty();

            return Padding(
              padding: const EdgeInsets.only(top: 4),
              child: ListView.separated(
                itemCount: contacts.length,
                itemBuilder: (_, int index) {
                  return ContactItem(contact: contacts[index]);
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

  @override
  void dispose() {
    super.dispose();
  }
}
