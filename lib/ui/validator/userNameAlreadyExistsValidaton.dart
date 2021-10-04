import 'package:app_tcc_unip/ui/validator/validation.dart';

class UserNameAlreadyExistsValidaton implements Validation {
  static final instance = UserNameAlreadyExistsValidaton._();

  final List<String> _userNamesExists = [];

  UserNameAlreadyExistsValidaton._();

  factory UserNameAlreadyExistsValidaton() {
    return instance;
  }

  @override
  void valid(value) {
    _userNamesExists.contains(value);
  }

  void addUserName(String userName) {
    _userNamesExists.add(userName);
  }
}
