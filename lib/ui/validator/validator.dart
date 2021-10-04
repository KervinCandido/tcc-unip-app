import 'package:app_tcc_unip/ui/validator/validation.dart';

class Validator {
  List<Validation> validations;

  Validator({required this.validations});

  valid(value) {
    for (var validation in validations) {
      validation.valid(value);
    }
  }
}
