import 'package:app_tcc_unip/ui/validator/validation.dart';
import 'package:app_tcc_unip/ui/validator/validationException.dart';

class EqualsPasswordValidation implements Validation<String> {
  final String password;

  EqualsPasswordValidation(this.password);

  @override
  void valid(String value) {
    if (value != password) {
      throw ValidationException('Valor está diferente da senha');
    }
  }
}
