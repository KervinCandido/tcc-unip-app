import 'package:app_tcc_unip/ui/validator/validation.dart';
import 'package:app_tcc_unip/ui/validator/validationException.dart';

class MustFilledValidation implements Validation<String?> {
  @override
  void valid(String? value) {
    if (value == null || value.isEmpty) {
      throw ValidationException('Preenchimento obrigatório');
    }
  }
}
