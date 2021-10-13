import 'package:app_tcc_unip/ui/validator/validation.dart';
import 'package:app_tcc_unip/ui/validator/validationException.dart';

class SelectOneOptioneValidation implements Validation<String?> {
  @override
  void valid(String? value) {
    if (value == null || value.isEmpty) {
      throw ValidationException('Selecione uma das opções');
    }
  }
}
