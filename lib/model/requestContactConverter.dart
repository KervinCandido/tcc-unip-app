import 'package:app_tcc_unip/model/converterPage.dart';
import 'package:app_tcc_unip/model/requestContact.dart';

class RequestContactConverter extends ConverterPage<RequestContact> {
  @override
  RequestContact convert(json) => RequestContact.fromJson(json);
}
