import 'dart:convert';

import 'package:app_tcc_unip/controller/dto/erroFormDTO.dart';
import 'package:app_tcc_unip/controller/dto/profileDTO.dart';
import 'package:app_tcc_unip/controller/exception/ErroFormException.dart';
import 'package:app_tcc_unip/controller/form/profileForm.dart';
import 'package:app_tcc_unip/dao/movieGenrerDAO.dart';
import 'package:app_tcc_unip/dao/musicalGenrerDAO.dart';
import 'package:app_tcc_unip/dao/profileDAO.dart';
import 'package:app_tcc_unip/model/movieGenrer.dart';
import 'package:app_tcc_unip/model/musicalGenrer.dart';
import 'package:app_tcc_unip/model/profile.dart';
import 'package:app_tcc_unip/service/tokenService.dart';
import 'package:app_tcc_unip/service/userService.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

const BASE_URL_API = 'BASE_URL_API';

class ProfileService {
  final String baseURL = dotenv.get(BASE_URL_API);
  final _userService = UserService();
  final _tokenService = TokenService();
  final _profileDAO = ProfileDAO();
  final _musicalGenrerDAO = MusicalGenrerDAO();
  final _movieGenrerDAO = MovieGenrerDAO();

  ProfileService() {
    print('criando profileService');
  }

  Future<List<MusicalGenrer>> getMusicalGenre() async {
    var musicalGenrerList = await _musicalGenrerDAO.findAll();

    if (musicalGenrerList.length > 0) {
      return musicalGenrerList;
    }

    var token = await _tokenService.getTokenForResquest();
    final response = await http.get(
      Uri.parse('$baseURL/profile/musicalGenrer'),
      headers: {
        'Accept-Language': 'pt-BR',
        'Authorization': token == null ? '' : token
      },
    );
    if (response.statusCode == 200) {
      Iterable it = jsonDecode(utf8.decode(response.bodyBytes));
      musicalGenrerList = List<MusicalGenrer>.from(
        it.map(
          (model) => MusicalGenrer.fromJson(model),
        ),
      );
      await _musicalGenrerDAO.insertOrUpdateList(musicalGenrerList);
      return musicalGenrerList;
    }
    return [];
  }

  Future<List<MovieGenrer>> getMovieGenre() async {
    List<MovieGenrer> movieGenrerList = await _movieGenrerDAO.findAll();

    if (movieGenrerList.length > 0) {
      return movieGenrerList;
    }

    var token = await _tokenService.getTokenForResquest();
    final response = await http.get(
      Uri.parse('$baseURL/profile/movieGenrer'),
      headers: {
        'Accept-Language': 'pt-BR',
        'Authorization': token == null ? '' : token
      },
    );
    if (response.statusCode == 200) {
      Iterable it = jsonDecode(utf8.decode(response.bodyBytes));
      movieGenrerList = List<MovieGenrer>.from(
        it.map(
          (model) => MovieGenrer.fromJson(model),
        ),
      );
      await _movieGenrerDAO.insertOrUpdateList(movieGenrerList);
      return movieGenrerList;
    }
    return [];
  }

  Future<ProfileDTO?> getProfileCurrentUser() async {
    int userId = await _userService.getUserId();
    Profile? profile = await _profileDAO.profileByUserId(userId);

    if (profile != null) {
      var profileDTO = ProfileDTO.fromProfile(profile);
      _trataPhotoUrl(profileDTO);
      return profileDTO;
    }

    print('buscando id do usu??rio');
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
      var profileDTO =
          ProfileDTO.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      _trataPhotoUrl(profileDTO);
      return profileDTO;
    }

    return null;
  }

  Future<ProfileDTO> create(ProfileForm profileForm) async {
    var token = await _tokenService.getTokenForResquest();

    // if (profileForm.photo != null) {
    //   await trataPhotoParaBancoDoDispositivo(profileForm);
    // }

    int userId = await _userService.getUserId();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseURL/profile'),
    );

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Accept-Language': 'pt-BR',
      'Authorization': token == null ? '' : token
    });

    if (profileForm.photo != null) {
      request.files.add(
          await http.MultipartFile.fromPath("photo", profileForm.photo!.path));
    }

    request.fields.addAll({
      'userId': '$userId',
      'profileName': profileForm.profileName,
      'birthDate': profileForm.birthDateISO,
      'gender': profileForm.gender,
      'description': profileForm.description ?? '',
    });

    for (int i = 0; i < profileForm.favoriteMusicalGenrer.length; i++) {
      request.fields.putIfAbsent("favoriteMusicalGenre[$i]",
          () => profileForm.favoriteMusicalGenrer[i].toString());
    }

    for (int i = 0; i < profileForm.favoriteMovieGenrer.length; i++) {
      request.fields.putIfAbsent("favoriteMovieGenre[$i]",
          () => profileForm.favoriteMovieGenrer[i].toString());
    }

    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      var profileDTO =
          ProfileDTO.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      await _profileDAO.insertOrUpdate(profileDTO.toProfile());
      _trataPhotoUrl(profileDTO);
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

  // Future<void> trataPhotoParaBancoDoDispositivo(ProfileForm profileForm) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final path = directory.path;
  //   final photo = profileForm.photo!;
  //   var split = photo.split("\.");
  //   var extension = '.${split[split.length - 1]}';
  //   final photoFile = File(photo);

  //   await Directory('$path/.tccunip/profile/').create(recursive: true);
  //   var millisecond = DateTime.now().millisecond;
  //   var newFile = File(
  //       '$path/.tccunip/profile/${profileForm.userId}$millisecond$extension');

  //   final image = decodeImage(photoFile.readAsBytesSync());
  //   var resizedImage = copyResize(image!, width: 120, height: 120);
  //   var encodedImage = encodeJpg(resizedImage);
  //   newFile.writeAsBytesSync(encodedImage);

  //   profileForm.photo = base64Encode(encodedImage);
  //   profileForm.photoPath = newFile.path;

  //   await photoFile.delete();
  //   // if (newFile.path != photoFile.path) {
  //   // }
  // }

  void _trataPhotoUrl(ProfileDTO profileDTO) {
    if (profileDTO.photo != null) {
      profileDTO.photo = '$baseURL${profileDTO.photo}';
    }
  }
}
