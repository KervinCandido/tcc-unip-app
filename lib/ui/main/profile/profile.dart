import 'package:app_tcc_unip/controller/dto/profileDTO.dart';
import 'package:app_tcc_unip/service/profileService.dart';
import 'package:app_tcc_unip/ui/login/loginForm.dart';
import 'package:app_tcc_unip/ui/login/loginScreen.dart';
import 'package:app_tcc_unip/ui/main/profile/editableProfile.dart';
import 'package:app_tcc_unip/ui/main/profile/userNoHasProfile.dart';
import 'package:app_tcc_unip/ui/main/profile/viewProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var profileService = ProfileService();

  ProfileDTO? _newProfile;
  Future<ProfileDTO?> get userProfile => profileService.getProfileCurrentUser();

  @override
  Widget build(BuildContext context) {
    PaintingBinding.instance!.imageCache!.clear();
    return FutureBuilder<ProfileDTO?>(
        future: userProfile,
        builder: (
          BuildContext context,
          AsyncSnapshot<ProfileDTO?> snapshot,
        ) {
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.done) {
            _newProfile = snapshot.data;
            if (_newProfile != null) {
              return ViewProfile(_newProfile!);
            } else {
              return UserNoHasProfile(onPressed: () async {
                var result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return EditableProfile();
                    },
                  ),
                );
                setState(() {
                  if (result != null) {
                    _newProfile = result;
                  }
                });
              });
            }
          }
          return const SpinKitSpinningLines(
            color: Colors.redAccent,
          );
        });
  }
}
