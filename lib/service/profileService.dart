import 'dart:convert';
import 'dart:io';

import 'package:app_tcc_unip/controller/dto/erroFormDTO.dart';
import 'package:app_tcc_unip/controller/dto/profileDTO.dart';
import 'package:app_tcc_unip/controller/exception/ErroFormException.dart';
import 'package:app_tcc_unip/controller/form/profileForm.dart';
import 'package:app_tcc_unip/dao/profileDAO.dart';
import 'package:app_tcc_unip/model/profile.dart';
import 'package:app_tcc_unip/service/tokenService.dart';
import 'package:app_tcc_unip/service/userService.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

const BASE_URL_API = 'BASE_URL_API';

class ProfileService {
  final String baseURL = dotenv.get(BASE_URL_API);
  final _userService = UserService();
  final _tokenService = TokenService();
  final _profileDAO = ProfileDAO();

  ProfileService() {
    print('criando profileService');
  }

  Future<ProfileDTO?> getProfileCurrentUser() async {
    int userId = await _userService.getUserId();
    Profile? profile = await _profileDAO.profileByUserId(userId);

    if (profile != null) {
      return ProfileDTO.fromProfile(profile);
    }

    print('buscando id do usuário');
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

    if (profileForm.photo != null) {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final photo = profileForm.photo!;
      var split = photo.split("\.");
      var extension = '.${split[split.length - 1]}';
      final photoFile = File(photo);

      await Directory('$path/.tccunip/profile/').create(recursive: true);

      var newFile =
          File('$path/.tccunip/profile/${profileForm.userId}$extension');
      await newFile.delete();

      final newDirectory = await photoFile.copy(newFile.path);
      profileForm.photo = newDirectory.path;

      await photoFile.delete();
    }

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
      var profileDTO =
          ProfileDTO.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      await _profileDAO.insertOrUpdate(profileDTO.toProfile());
      return profileDTO;
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
