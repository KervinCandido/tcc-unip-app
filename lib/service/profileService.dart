import 'dart:convert';

import 'package:app_tcc_unip/controller/dto/erroFormDTO.dart';
import 'package:app_tcc_unip/controller/dto/profileDTO.dart';
import 'package:app_tcc_unip/controller/exception/ErroFormException.dart';
import 'package:app_tcc_unip/controller/form/profileForm.dart';
import 'package:app_tcc_unip/service/tokenService.dart';
import 'package:app_tcc_unip/service/userService.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

const BASE_URL_API = 'BASE_URL_API';

class ProfileService {
  final String baseURL = dotenv.get(BASE_URL_API);
  final _userService = UserService();
  final _tokenService = TokenService();

  ProfileService() {
    print('criando profileService');
  }

  Future<ProfileDTO?> getProfileCurrentUser() async {
    print('buscando id do usuário');
    int userId = await _userService.getUserId();
    var token = await _tokenService.getTokenForResquest();
    final response = await http.get(
      Uri.parse('$baseURL/profile/user/id/$userId'),
      headers: {
        'Accept-Language': 'pt-BR',
        'Authorization': token == null ? '' : token
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return ProfileDTO.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    }

    return null;
  }

  Future<ProfileDTO> create(ProfileForm profileForm) async {
    var token = await _tokenService.getTokenForResquest();
    print(jsonEncode(profileForm));
    print('$token');
    final response = await http.post(
      Uri.parse('$baseURL/profile'),
      body: jsonEncode(profileForm),
      encoding: utf8,
      headers: {
        'Content-Type': 'application/json',
        'Accept-Language': 'pt-BR',
        'Authorization': token == null ? '' : token
      },
    );

    if (response.statusCode == 201) {
      return ProfileDTO.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 400) {
      Iterable it = jsonDecode(utf8.decode(response.bodyBytes));
      List<ErroFormDTO> errosFormDTO = List<ErroFormDTO>.from(
          it.map((model) => ErroFormDTO.fromJson(model)));
      throw ErroFormException(errosFormDTO);
    }

    throw Exception(
      'Falha ao criar perfil: { statusCode: ${response.statusCode}, body: ${response.body}',
    );
  }

  Future<ProfileDTO> update(ProfileForm profileForm) async {
    var token = await _tokenService.getTokenForResquest();
    final response = await http.put(
      Uri.parse('$baseURL/profile'),
      body: jsonEncode(profileForm),
      encoding: utf8,
      headers: {
        'Content-Type': 'application/json',
        'Accept-Language': 'pt-BR',
        'Authorization': token == null ? '' : token
      },
    );

    if (response.statusCode == 200) {
      return ProfileDTO.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 400) {
      Iterable it = jsonDecode(utf8.decode(response.bodyBytes));
      List<ErroFormDTO> errosFormDTO = List<ErroFormDTO>.from(
          it.map((model) => ErroFormDTO.fromJson(model)));
      throw ErroFormException(errosFormDTO);
    }

    throw Exception(
      'Falha ao criar perfil: { statusCode: ${response.statusCode}, body: ${response.body}',
    );
  }
}
