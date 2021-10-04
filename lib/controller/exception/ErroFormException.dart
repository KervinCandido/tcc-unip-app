import 'package:app_tcc_unip/controller/dto/erroFormDTO.dart';

class ErroFormException implements Exception {
  final List<ErroFormDTO> erros;

  ErroFormException(this.erros);
}
