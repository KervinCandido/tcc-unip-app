import 'dart:convert';

import 'package:app_tcc_unip/model/contactRecommendation.dart';
import 'package:app_tcc_unip/ui/main/chat/chat.dart';
import 'package:flutter/material.dart';

class ContactItem extends StatefulWidget {
  final ContactRecommendation contact;
  const ContactItem({Key? key, required this.contact}) : super(key: key);

  @override
  _ContactItemState createState() => _ContactItemState(this.contact);
}

class _ContactItemState extends State<ContactItem> {
  final ContactRecommendation contact;

  _ContactItemState(this.contact);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return Chat(this.contact);
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              minRadius: 22,
              backgroundImage: this.contact.photoProfile == null
                  ? null
                  : Image.memory(base64Decode(this.contact.photoProfile!))
                      .image,
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
                    'mensagem muito grade que vai ficar com reticencias',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
