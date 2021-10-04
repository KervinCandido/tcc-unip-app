import 'package:app_tcc_unip/ui/validator/validation.dart';

class EmailAlreadyExistsValidaton implements Validation {
  static final emailAlreadyExistsValidaton = EmailAlreadyExistsValidaton._();

  final List<String> _emailAlreadyExists = [];

  EmailAlreadyExistsValidaton._();

  factory EmailAlreadyExistsValidaton() {
    return emailAlreadyExistsValidaton;
  }

  void addEmail(String email) {
    _emailAlreadyExists.add(email);
  }

  @override
  void valid(value) {
    _emailAlreadyExists.contains(value);
  }
}
