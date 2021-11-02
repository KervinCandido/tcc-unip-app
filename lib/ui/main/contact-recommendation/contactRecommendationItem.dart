import 'dart:convert';
import 'dart:io';

import 'package:app_tcc_unip/model/contactRecommendation.dart';
import 'package:flutter/material.dart';

class ContactRecommendationItem extends StatelessWidget {
  final ContactRecommendation contact;
  final void Function(ContactRecommendation contact) onAdd;

  const ContactRecommendationItem({
    Key? key,
    required this.contact,
    required this.onAdd,
  }) : super(key: key);

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
                : Image.network(
                    this.contact.photoProfile!,
                    width: 120,
                    height: 120,
                  ).image,
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
                  onTap: () {
                    this.onAdd(this.contact);
                  },
                  child: Icon(
                    Icons.add_circle_outline_rounded,
                    color: Theme.of(context).primaryColor,
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
