import 'package:app_tcc_unip/connection/websocket/websocketController.dart';
import 'package:app_tcc_unip/model/requestContact.dart';
import 'package:app_tcc_unip/ui/main/notification/notificationItem.dart';
import 'package:flutter/material.dart';

class NotificationList extends StatefulWidget {
  final List<RequestContact> contactList;
  final void Function(RequestContact) onActionItem;
  const NotificationList(
      {Key? key, required this.contactList, required this.onActionItem})
      : super(key: key);

  @override
  _NotificationListState createState() =>
      _NotificationListState(this.contactList, this.onActionItem);
}

class _NotificationListState extends State<NotificationList> {
  final _webSocketController = WebsocketController.getInstance();
  final void Function(RequestContact) onActionItem;
  final List<RequestContact> contactList;

  _NotificationListState(this.contactList, this.onActionItem) {
    PaintingBinding.instance!.imageCache!.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: contactList.length,
      itemBuilder: (_, int index) {
        return NotificationItem(this.contactList[index].requester, (accept) {
          setState(() {
            var contact = this.contactList[index].requester;
            var requestId = this.contactList[index].id;
            if (accept) {
              _webSocketController.acceptContact(requestId, contact);
            } else {
              _webSocketController.rejectContact(requestId, contact);
            }
            onActionItem(this.contactList[index]);
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
