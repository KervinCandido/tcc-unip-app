import 'dart:convert';

import 'package:app_tcc_unip/model/ContactRecommendationConverter.dart';
import 'package:app_tcc_unip/model/contactRecommendation.dart';
import 'package:app_tcc_unip/model/pageSpring.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:app_tcc_unip/service/tokenService.dart';
import 'package:app_tcc_unip/service/userService.dart';

const BASE_URL_API = 'BASE_URL_API';

class ContactService {
  final String baseURL = dotenv.get(BASE_URL_API);
  final _userService = UserService();
  final _tokenService = TokenService();

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

      print('pageSpring: ${pageSpring.totalElements}');

      return pageSpring.content;
    }

    return List.empty();
  }

  Future<List<ContactRecommendation>> getContacts() async {
    var token = await _tokenService.getTokenForResquest();
    var userId = await _userService.getUserId();
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

      return pageSpring.content;
    }

    return List.empty();
  }
}
