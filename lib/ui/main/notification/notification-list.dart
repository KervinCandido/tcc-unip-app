import 'package:app_tcc_unip/connection/websocket/websocketController.dart';
import 'package:app_tcc_unip/model/contactRecommendation.dart';
import 'package:app_tcc_unip/ui/main/notification/notificationItem.dart';
import 'package:flutter/material.dart';

class NotificationList extends StatefulWidget {
  final List<ContactRecommendation> contactList;
  final void Function(ContactRecommendation) onActionItem;
  const NotificationList(
      {Key? key, required this.contactList, required this.onActionItem})
      : super(key: key);

  @override
  _NotificationListState createState() =>
      _NotificationListState(this.contactList, this.onActionItem);
}

class _NotificationListState extends State<NotificationList> {
  final _webSocketController = WebsocketController.getInstance();
  final void Function(ContactRecommendation) onActionItem;
  final List<ContactRecommendation> contactList;

  _NotificationListState(this.contactList, this.onActionItem);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: contactList.length,
      itemBuilder: (_, int index) {
        return NotificationItem(this.contactList[index], (accept) {
          setState(() {
            var contact = this.contactList[index];
            if (accept) {
              _webSocketController.acceptContact(contact);
            } else {
              _webSocketController.rejectContact(contact);
            }
            onActionItem(contact);
          });
        });
      },
      separatorBuilder: (_, __) => const Divider(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
