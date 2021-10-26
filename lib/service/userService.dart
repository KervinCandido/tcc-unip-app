import 'package:app_tcc_unip/service/tokenService.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

const USER_NAME_KEY = 'TCC_UNIP_USER_NAME';

class UserService {
  final tokenService = TokenService();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<int> getUserId() async {
    var token = await tokenService.getToken();
    var decodedToken = JwtDecoder.decode(token!);
    return int.tryParse(decodedToken['sub']) ?? 0;
  }

  Future<String?> getUsernameCurrentUser() async {
    final prefs = await _prefs;
    return prefs.getString(USER_NAME_KEY);
  }
}
