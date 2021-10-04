import 'dart:convert';

import 'package:app_tcc_unip/controller/dto/erroFormDTO.dart';
import 'package:app_tcc_unip/controller/dto/userDTO.dart';
import 'package:app_tcc_unip/controller/exception/ErroFormException.dart';
import 'package:app_tcc_unip/controller/form/signForm.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SignUpService {
  final String baseURL = dotenv.get('BASE_URL_API');

  Future<UserDTO> signUp(SignForm userForm) async {
    final response = await http.post(
      Uri.parse('$baseURL/sign-up'),
      body: jsonEncode(userForm),
      encoding: utf8,
      headers: {
        'Content-Type': 'application/json',
        'Accept-Language': 'pt-BR',
      },
    );

    if (response.statusCode == 201) {
      print('Usuário criado com sucessor');
      print(utf8.decode(response.bodyBytes));
      return UserDTO.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 400) {
      print('Erro de form');
      print(utf8.decode(response.bodyBytes));
      Iterable it = jsonDecode(utf8.decode(response.bodyBytes));
      List<ErroFormDTO> errosFormDTO = List<ErroFormDTO>.from(
          it.map((model) => ErroFormDTO.fromJson(model)));
      throw ErroFormException(errosFormDTO);
    }

    throw Exception('Falha ao criar usuário: ${response.body}');
  }
}
