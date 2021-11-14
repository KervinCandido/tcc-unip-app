import 'dart:convert';
import 'dart:io';
import 'package:app_tcc_unip/controller/dto/profileDTO.dart';
import 'package:app_tcc_unip/ui/main/profile/editableProfile.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';

class ViewProfile extends StatefulWidget {
  final ProfileDTO profile;
  ViewProfile(this.profile, {Key? key}) : super(key: key);

  @override
  _ViewProfileState createState() => _ViewProfileState(this.profile);
}

class _ViewProfileState extends State<ViewProfile> {
  ProfileDTO profile;
  _ViewProfileState(this.profile) {
    PaintingBinding.instance!.imageCache!.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 25,
              ),
              Container(
                width: 120,
                height: 120,
                child: Container(
                  width: 120,
                  height: 120,
                  child: CircleAvatar(
                    backgroundImage: this.profile.photo == null
                        ? null
                        : Image.network(this.profile.photo!).image,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                this.profile.profileName,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Data nascimento ${profile.birthDateFormatted}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Gênero',
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(
                      profile.gender == 'MALE'
                          ? CommunityMaterialIcons.gender_male
                          : CommunityMaterialIcons.gender_female,
                      color:
                          profile.gender == 'MALE' ? Colors.blue : Colors.red,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Descrição',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        profile.description == null ? '' : profile.description!,
                        style: TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 10,
                        softWrap: true,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return EditableProfile(profile: profile);
              },
            ),
          );

          if (result == null) return;
          setState(() {
            profile = result;
            if (profile.photo != null) {
              profile.photo =
                  '${profile.photo}?v=${DateTime.now().millisecondsSinceEpoch}';
            }
          });
        },
        child: const Icon(Icons.edit),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
