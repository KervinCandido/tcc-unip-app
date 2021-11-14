import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_tcc_unip/controller/ProfileController.dart';
import 'package:app_tcc_unip/controller/dto/profileDTO.dart';
import 'package:app_tcc_unip/controller/exception/ErroFormException.dart';
import 'package:app_tcc_unip/controller/form/profileForm.dart';
import 'package:app_tcc_unip/service/userService.dart';
import 'package:app_tcc_unip/ui/components/genderSelector/gender.dart';
import 'package:app_tcc_unip/ui/components/genderSelector/genderOption.dart';
import 'package:app_tcc_unip/ui/components/genderSelector/genderSelector.dart';
import 'package:app_tcc_unip/ui/util/loading.dart';
import 'package:app_tcc_unip/ui/validator/mustFilledValidation.dart';
import 'package:app_tcc_unip/ui/validator/selectOneOptionValidation.dart';
import 'package:app_tcc_unip/ui/validator/sizeValidation.dart';
import 'package:app_tcc_unip/ui/validator/validation.dart';
import 'package:app_tcc_unip/ui/validator/validationException.dart';
import 'package:app_tcc_unip/ui/validator/validator.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditableProfile extends StatefulWidget {
  final ProfileDTO? profile;

  EditableProfile({
    Key? key,
    this.profile,
  }) : super(key: key);

  @override
  _EditableProfileState createState() => _EditableProfileState(this.profile);
}

class _EditableProfileState extends State<EditableProfile> {
  var _formProfileKey = GlobalKey<FormState>();
  var _genderSelectorKey = GlobalKey<GenderSelectorState>();

  ProfileDTO? profile;
  final _userService = UserService();
  final _profileController = ProfileController();
  var _birthDateFormat = DateFormat('dd/MM/yyyy');

  int _userId = 0;
  var _profileNameController = TextEditingController();
  var _birthDateController = TextEditingController();
  Gender? _gender;
  var _descriptionController = TextEditingController();

  ImageProvider? _photoProfile;
  File? _photo;

  _EditableProfileState([this.profile]) {
    _profileNameController =
        TextEditingController(text: profile?.profileName ?? null);
    _birthDateController =
        TextEditingController(text: profile?.birthDateFormatted ?? null);
    _descriptionController =
        TextEditingController(text: profile?.description ?? null);

    _photoProfile = profile != null && profile!.photo != null
        ? Image.network(
            profile!.photo!,
            width: 120,
          ).image
        : null;
    PaintingBinding.instance!.imageCache!.clear();
  }

  Future<int> get user => _userService.getUserId();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: FutureBuilder<int>(
          future: user,
          builder: (
            BuildContext context,
            AsyncSnapshot<int> snapshot,
          ) {
            if (snapshot.hasData) {
              _userId = snapshot.data!;
              return SizedBox.expand(
                child: Form(
                  key: _formProfileKey,
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
                          child: Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                child: CircleAvatar(
                                  backgroundImage: _photoProfile,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  child: Container(
                                    child: Icon(Icons.edit),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white54,
                                      // borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                  onTap: () async {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SimpleDialog(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          children: [
                                            SimpleDialogOption(
                                              child: Text('Galeria'),
                                              padding: EdgeInsets.only(
                                                top: 16,
                                                left: 16,
                                                bottom: 12,
                                                right: 8,
                                              ),
                                              onPressed: () async {
                                                var picture =
                                                    await ImagePicker()
                                                        .pickImage(
                                                            source: ImageSource
                                                                .gallery);
                                                if (picture == null) {
                                                  Navigator.pop(context);
                                                  return;
                                                }

                                                setState(() {
                                                  _photo = File(picture.path);
                                                  _photoProfile =
                                                      Image.file(_photo!).image;
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                            SimpleDialogOption(
                                                child: Text('Câmera'),
                                                padding: EdgeInsets.only(
                                                  top: 12,
                                                  left: 16,
                                                  bottom: 16,
                                                  right: 8,
                                                ),
                                                onPressed: () async {
                                                  var picture =
                                                      await ImagePicker()
                                                          .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .camera);
                                                  if (picture == null) {
                                                    Navigator.pop(context);
                                                    return;
                                                  }
                                                  setState(() {
                                                    _photo = File(picture.path);
                                                    _photoProfile =
                                                        Image.file(_photo!)
                                                            .image;
                                                  });
                                                  Navigator.pop(context);
                                                }),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: TextFormField(
                            validator: (value) {
                              return _validation(
                                value,
                                [
                                  MustFilledValidation(),
                                  SizeValidation(3, 20),
                                ],
                              );
                            },
                            controller: _profileNameController,
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(fontSize: 18.0),
                            keyboardType: TextInputType.name,
                            cursorColor: Colors.redAccent,
                            decoration: InputDecoration(
                              contentPadding:
                                  new EdgeInsets.only(left: 16, right: 16),
                              fillColor: Colors.white,
                              labelText: 'Nome do Perfil',
                              hintStyle: TextStyle(
                                color: Colors.redAccent,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                  width: 2.0,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: TextFormField(
                            validator: (value) {
                              return _validation(
                                value,
                                [
                                  MustFilledValidation(),
                                ],
                              );
                            },
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              ).then(
                                (date) => _birthDateController.text =
                                    _birthDateFormat.format(date!),
                              );
                            },
                            controller: _birthDateController,
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(fontSize: 18.0),
                            keyboardType: TextInputType.name,
                            cursorColor: Colors.redAccent,
                            readOnly: true,
                            decoration: InputDecoration(
                              contentPadding:
                                  new EdgeInsets.only(left: 16, right: 16),
                              fillColor: Colors.white,
                              labelText: 'Data nascimento',
                              suffixIcon: Icon(Icons.calendar_today_outlined),
                              hintStyle: TextStyle(
                                color: Colors.redAccent,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                  width: 2.0,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GenderSelector(
                          key: _genderSelectorKey,
                          initialValue: this.profile?.gender ?? null,
                          onSelected: (gender) => this._gender = gender,
                          onValidate: (gender) => _validation(
                              gender != null ? gender.value : null, [
                            SelectOneOptioneValidation(),
                          ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.bottom,
                            textInputAction: TextInputAction.newline,
                            minLines: 3,
                            maxLines: 10,
                            style: TextStyle(fontSize: 18.0),
                            keyboardType: TextInputType.multiline,
                            cursorColor: Colors.redAccent,
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              contentPadding: new EdgeInsets.only(
                                  left: 16, right: 16, top: 10, bottom: 10),
                              fillColor: Colors.white,
                              hintText: 'Descrição',
                              hintStyle: TextStyle(
                                color: Colors.black38,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                  width: 2.0,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SpinKitSpinningLines(
              color: Colors.redAccent,
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formProfileKey.currentState!.validate() &&
              _genderSelectorKey.currentState!.validate()) {
            if (_userId < 1) return;
            var profileName = _profileNameController.text;
            var birthDate = _birthDateFormat.parse(_birthDateController.text);

            var description = _descriptionController.text;
            var profileForm = ProfileForm(
              _userId,
              profileName,
              birthDate,
              _genderSelectorKey.currentState!.genderSelect!.value,
              _photo,
              description,
            );
            var loading = Loading();
            try {
              print('create new profile');
              loading.showLoaderDialog(context);
              var profileDTO =
                  await _profileController.createNewProfile(profileForm);
              Navigator.pop(context);
              Navigator.pop(context, profileDTO);
            } on ErroFormException catch (e) {
              print(e);
              final String message = e.erros
                  .map((e) => e.message)
                  .reduce((value, element) => '$element\n');

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(message),
              ));
              Navigator.pop(context);
            }
          }
        },
        child: const Icon(Icons.save),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _validation(String? val, List<Validation> validations) {
    try {
      final validator = Validator(validations: validations);
      validator.valid(val);
    } on ValidationException catch (e) {
      return e.message;
    }
    return null;
  }

  @override
  void dispose() {
    _profileNameController.dispose();
    _birthDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
