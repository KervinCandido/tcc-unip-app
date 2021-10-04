import 'package:app_tcc_unip/service/tokenService.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserService {
  final tokenService = TokenService();

  Future<int> getUserId() async {
    var token = await tokenService.getToken();
    var decodedToken = JwtDecoder.decode(token!);
    return decodedToken['sub'];
  }
}
