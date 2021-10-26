import 'dart:convert';

import 'package:app_tcc_unip/model/contactRecommendation.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final ContactRecommendation contact;
  final Function(bool) accept;
  const NotificationItem(this.contact, this.accept, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: 8,
        right: 16,
      ),
      child: Row(
        children: [
          CircleAvatar(
            minRadius: 30,
            backgroundImage: this.contact.photoProfile == null
                ? null
                : Image.memory(base64Decode(this.contact.photoProfile!)).image,
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  this.contact.profileName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                GestureDetector(
                  onTap: () => accept(true),
                  child: Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 35.0,
                  ),
                ),
                GestureDetector(
                  onTap: () => accept(false),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.red,
                    size: 35.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
