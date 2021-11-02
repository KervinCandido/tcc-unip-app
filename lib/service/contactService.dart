import 'dart:convert';
import 'dart:io';

import 'package:app_tcc_unip/dao/contactDAO.dart';
import 'package:app_tcc_unip/model/ContactRecommendationConverter.dart';
import 'package:app_tcc_unip/model/contact.dart';
import 'package:app_tcc_unip/model/contactRecommendation.dart';
import 'package:app_tcc_unip/model/pageSpring.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:app_tcc_unip/service/tokenService.dart';
import 'package:app_tcc_unip/service/userService.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<List<ContactRecommendation>> getContacts() async {
    var token = await _tokenService.getTokenForResquest();
    var userId = await _userService.getUserId();

    var listContacts = await _contactDAO.listContacts(userId);

    if (listContacts.isNotEmpty) {
      return listContacts
          .map(
            (contact) => ContactRecommendation(
              userName: contact.userName,
              photoProfile:
                  contact.photo != null ? '$baseURL${contact.photo}' : null,
              profileName: contact.profileName,
            ),
          )
          .toList();
    }

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
      }
      return content;
    }

    return List.empty();
  }
}
