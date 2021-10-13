import 'package:app_tcc_unip/controller/dto/profileDTO.dart';
import 'package:app_tcc_unip/controller/form/profileForm.dart';
import 'package:app_tcc_unip/service/profileService.dart';

class ProfileController {
  var _profileService = ProfileService();

  Future<ProfileDTO> createNewProfile(ProfileForm profileForm) async {
    return await _profileService.create(profileForm);
  }
}
