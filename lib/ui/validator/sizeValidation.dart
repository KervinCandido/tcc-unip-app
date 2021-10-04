import 'package:app_tcc_unip/ui/validator/validation.dart';
import 'package:app_tcc_unip/ui/validator/validationException.dart';

class SizeValidation implements Validation<String> {
  int min;
  int max;

  SizeValidation(this.min, this.max);

  @override
  void valid(String value) {
    final length = value.length;
    if (length < this.min) {
      throw ValidationException('Mínimo de $min caracteres');
    } else if (length > this.max) {
      throw ValidationException('Máximo de $max caracteres');
    }
  }
}
