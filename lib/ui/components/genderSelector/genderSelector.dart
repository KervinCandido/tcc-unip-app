import 'package:app_tcc_unip/ui/components/genderSelector/genderOption.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';

import 'gender.dart';

class GenderSelector extends StatefulWidget {
  final void Function(Gender)? onSelected;
  final String? Function(Gender? gender)? onValidate;
  final String? initialValue;

  GenderSelector(
      {Key? key, this.onSelected, this.onValidate, this.initialValue})
      : super(key: key);

  @override
  GenderSelectorState createState() {
    return GenderSelectorState(onSelected, onValidate, initialValue);
  }
}

class GenderSelectorState extends State<GenderSelector> {
  final List<Gender> _genders = [
    Gender(
      'MALE',
      CommunityMaterialIcons.gender_male,
      false,
      Colors.blue,
      Colors.blue,
    ),
    Gender(
      'FEMALE',
      CommunityMaterialIcons.gender_female,
      false,
      Colors.red,
      Colors.red,
    ),
    /*Gender(
      'OTHERS',
      CommunityMaterialIcons.gender_transgender,
      false,
      Colors.black,
      Colors.white,
    ),*/
  ];

  final void Function(Gender)? onSelected;
  final String? Function(Gender? gender)? onValidate;

  Gender? selected;

  GenderSelectorState(this.onSelected, this.onValidate, String? initialValue) {
    if (initialValue != null) {
      _genders.forEach((el) => {
            if (el.value == initialValue)
              {
                el.isSelected = true,
                selected = el,
              }
          });
    }
  }

  Gender? get genderSelect => selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Gênero',
          style: TextStyle(fontSize: 16),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: GestureDetector(
                child: GenderOption(gender: _genders[0]),
                onTap: () => _selectGenderOption(_genders[0]),
              ),
            ),
            Flexible(
              child: GestureDetector(
                child: GenderOption(gender: _genders[1]),
                onTap: () => _selectGenderOption(_genders[1]),
              ),
            ),
            /*Flexible(
              child: GestureDetector(
                child: GenderOption(gender: _genders[2]),
                onTap: () => _selectGenderOption(_genders[2]),
              ),
            ),*/
          ],
        ),
        Column(
          children: _message,
        ),
      ],
    );
  }

  List<Text> _message = [];

  void _selectGenderOption(Gender gender) {
    setState(() {
      selected = gender;
      _genders.forEach((element) {
        element.isSelected = element == gender;
      });
      _valid();
    });
    this.onSelected!(gender);
  }

  bool _valid() {
    this._message.clear();
    if (onValidate == null) return true; // nao foi implementado para validacao
    String? erroMessage = onValidate!(selected);
    if (erroMessage != null) {
      setState(() {
        _message.clear();
        _message.add(Text(
          erroMessage,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).errorColor,
          ),
        ));
      });
      return false;
    }
    return true;
  }

  bool validate() {
    return _valid();
  }
}
