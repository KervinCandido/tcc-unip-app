import 'package:app_tcc_unip/controller/form/signForm.dart';
import 'package:app_tcc_unip/service/signUpService.dart';

import 'dto/userDTO.dart';

class SignUpController {
  final SignUpService signUpService = SignUpService();

  Future<UserDTO> signUp(SignForm userForm) async {
    return signUpService.signUp(userForm);
  }
}
