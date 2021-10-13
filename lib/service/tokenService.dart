import 'package:app_tcc_unip/controller/dto/tokenDTO.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String token = "TCC_UNIP_TOKEN_API";

class TokenService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future storeToken(TokenDTO tokenDTO) async {
    final prefs = await _prefs;
    prefs.setString(token, tokenDTO.token);
  }

  Future<bool> hasToken() async {
    final prefs = await _prefs;
    return prefs.containsKey(token);
  }

  Future<String?> getToken() async {
    final prefs = await _prefs;
    return prefs.getString(token);
  }

  Future<String?> getTokenForResquest() async {
    var token = await getToken();
    return token == null ? null : 'Bearer $token';
  }

  Future<bool> removeToken() async {
    final prefs = await _prefs;
    return prefs.remove(token);
  }
}
