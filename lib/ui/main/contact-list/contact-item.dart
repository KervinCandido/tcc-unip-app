import 'package:app_tcc_unip/connection/websocket/websocketController.dart';
import 'package:app_tcc_unip/model/contactRecommendation.dart';
import 'package:app_tcc_unip/model/contactWithLastMessage.dart';
import 'package:app_tcc_unip/model/messageForm.dart';
import 'package:app_tcc_unip/service/userService.dart';
import 'package:app_tcc_unip/ui/main/chat/chat.dart';
import 'package:flutter/material.dart';

class ContactItem extends StatefulWidget {
  final ContactWithLastMessage contact;
  const ContactItem({Key? key, required this.contact}) : super(key: key);

  @override
  _ContactItemState createState() => _ContactItemState(this.contact);
}

class _ContactItemState extends State<ContactItem> {
  final _webSocket = WebsocketController.getInstance();
  final ContactWithLastMessage contact;

  final _userService = UserService();

  _ContactItemState(this.contact) {
    _webSocket.addMessageListener(onMessageReceived);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final id = await _userService.getUserId();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return Chat(this.contact, id);
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              minRadius: 24,
              backgroundImage: this.contact.photoProfile == null
                  ? null
                  : Image.network(this.contact.photoProfile!).image,
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    this.contact.profileName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    this.contact.lastMessage,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onMessageReceived(MessageForm messageForm) {
    if (messageForm.sender == this.contact.userName) {
      setState(() {
        this.contact.lastMessage = messageForm.content;
      });
    }
  }

  @override
  void dispose() {
    this._webSocket.removeMessageListener(onMessageReceived);
    super.dispose();
  }
}
