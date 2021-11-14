import 'dart:convert';

import 'package:app_tcc_unip/dao/contactDAO.dart';
import 'package:app_tcc_unip/dao/messageDAO.dart';
import 'package:app_tcc_unip/model/ContactRecommendationConverter.dart';
import 'package:app_tcc_unip/model/contact.dart';
import 'package:app_tcc_unip/model/contactRecommendation.dart';
import 'package:app_tcc_unip/model/contactWithLastMessage.dart';
import 'package:app_tcc_unip/model/pageSpring.dart';
import 'package:app_tcc_unip/model/requestContact.dart';
import 'package:app_tcc_unip/model/requestContactConverter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:app_tcc_unip/service/tokenService.dart';
import 'package:app_tcc_unip/service/userService.dart';

const BASE_URL_API = 'BASE_URL_API';

class ContactService {
  final String baseURL = dotenv.get(BASE_URL_API);
  final _userService = UserService();
  final _tokenService = TokenService();
  final _contactDAO = ContactDAO();

  Future<List<ContactRecommendation>> getContactRecommendation() async {
    var token = await _tokenService.getTokenForResquest();
    var userId = await _userService.getUserId();
    final response = await http.get(
      Uri.parse('$baseURL/contact/recommendations/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept-Language': 'pt-BR',
        'Authorization': token == null ? '' : token
      },
    );

    print('statusCode: ${response.statusCode}');
    if (response.statusCode == 200) {
      PageSpring<ContactRecommendation> pageSpring = PageSpring.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)),
        ContactRecommendationConverter(),
      );

      pageSpring.content.forEach((contact) {
        if (contact.photoProfile != null) {
          contact.photoProfile = '$baseURL${contact.photoProfile}';
        }
      });

      return pageSpring.content;
    }

    return List.empty();
  }

  Future<List<ContactWithLastMessage>> getContacts() async {
    var token = await _tokenService.getTokenForResquest();
    var userId = await _userService.getUserId();

    // var listContacts = await _contactDAO.listContacts(userId);

    // if (listContacts.isNotEmpty) {
    //   return listContacts
    //       .map(
    //         (contact) => ContactRecommendation(
    //           userName: contact.userName,
    //           photoProfile:
    //               contact.photo != null ? '$baseURL${contact.photo}' : null,
    //           profileName: contact.profileName,
    //         ),
    //       )
    //       .toList();
    // }

    final response = await http.get(
      Uri.parse('$baseURL/contact/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept-Language': 'pt-BR',
        'Authorization': token == null ? '' : token
      },
    );

    if (response.statusCode == 200) {
      PageSpring<ContactRecommendation> pageSpring = PageSpring.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)),
        ContactRecommendationConverter(),
      );

      var content = pageSpring.content;
      final List<ContactWithLastMessage> _contacts = [];

      for (var cr in content) {
        await _contactDAO.insertOrUpdate(
          Contact(
            userId,
            cr.photoProfile,
            cr.profileName,
            cr.userName,
          ),
        );
        if (cr.photoProfile != null) {
          cr.photoProfile = '$baseURL${cr.photoProfile}';
        }
        final _messageDAO = MessageDAO();
        final _message = await _messageDAO.lastMessage(userId, cr.userName);
        _contacts.add(ContactWithLastMessage(
          userName: cr.userName,
          photoProfile: cr.photoProfile,
          profileName: cr.profileName,
          lastMessage:
              _message.isSend ? 'Você: ${_message.message}' : _message.message,
        ));
      }

      return _contacts;
    }

    return List.empty();
  }

  Future<List<RequestContact>> getNotifications() async {
    var token = await _tokenService.getTokenForResquest();
    var userId = await _userService.getUserId();

    final response = await http.get(
      Uri.parse('$baseURL/contact/requested/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept-Language': 'pt-BR',
        'Authorization': token == null ? '' : token
      },
    );

    if (response.statusCode == 200) {
      PageSpring<RequestContact> pageSpring = PageSpring.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)),
        RequestContactConverter(),
      );

      return pageSpring.content.map((c) {
        if (c.requester.photoProfile != null) {
          c.requester.photoProfile = '$baseURL${c.requested.photoProfile}';
        }
        if (c.requested.photoProfile != null) {
          c.requested.photoProfile = '$baseURL${c.requested.photoProfile}';
        }
        return c;
      }).toList();
    }

    return List.empty();
  }
}
