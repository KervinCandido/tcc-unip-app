import 'package:app_tcc_unip/model/contactRecommendation.dart';
import 'package:app_tcc_unip/model/converterPage.dart';

class ContactRecommendationConverter
    extends ConverterPage<ContactRecommendation> {
  @override
  ContactRecommendation convert(json) => ContactRecommendation.fromJson(json);
}
