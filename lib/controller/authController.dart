import 'package:app_tcc_unip/controller/dto/tokenDTO.dart';
import 'package:app_tcc_unip/controller/form/authForm.dart';
import 'package:app_tcc_unip/service/authService.dart';
import 'package:app_tcc_unip/service/tokenService.dart';

class AuthController {
  final authService = AuthService();
  final tokenService = TokenService();

  Future<bool> auth(AuthForm authForm) async {
    try {
      final tokenDTO = await authService.auth(authForm);
      await _storeToken(tokenDTO);
      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> autoAuth() async {
    try {
      final tokenDTO = await authService.autoAuth();
      await _storeToken(tokenDTO);
      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<void> _storeToken(TokenDTO tokenDTO) async {
    tokenService.storeToken(tokenDTO);
  }
}
