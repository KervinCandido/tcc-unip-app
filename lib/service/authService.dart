import 'dart:convert';

import 'package:app_tcc_unip/controller/dto/tokenDTO.dart';
import 'package:app_tcc_unip/controller/form/authForm.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

const USER_NAME_KEY = 'TCC_UNIP_USER_NAME';
const PASSOWORD_KEY = 'TCC_UNIP_PASSWORD';
const BASE_URL_API = 'BASE_URL_API';

class AuthService {
  final String baseURL = dotenv.get(BASE_URL_API);
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<TokenDTO> auth(AuthForm authForm) async {
    final response = await http.post(
      Uri.parse('$baseURL/auth'),
      body: jsonEncode(authForm),
      encoding: utf8,
      headers: {
        'Content-Type': 'application/json',
        'Accept-Language': 'pt-BR',
      },
    );

    if (response.statusCode == 200) {
      print('Autenticado com sucessor');

      final prefs = await _prefs;
      prefs.setString(USER_NAME_KEY, authForm.userName);
      prefs.setString(PASSOWORD_KEY, authForm.password);

      return TokenDTO.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception('Falha ao autenticar: ${response.body}');
    }

    throw Exception('A autenticação falhou: ${response.body}');
  }

  Future<TokenDTO> autoAuth() async {
    final prefs = await _prefs;
    var userName = prefs.getString(USER_NAME_KEY);
    var password = prefs.getString(PASSOWORD_KEY);
    if (userName == null || password == null) {
      throw Exception(
          'A autenticação falhou: sem dados para autenticação automática');
    }
    return this.auth(AuthForm(userName: userName, password: password));
  }
}
