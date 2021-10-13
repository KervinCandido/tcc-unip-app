import 'package:app_tcc_unip/ui/components/genderSelector/gender.dart';
import 'package:flutter/material.dart';

class GenderOption extends StatelessWidget {
  final Gender gender;

  const GenderOption({Key? key, required this.gender}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: gender.isSelected ? Color(0xFF3B4257) : Colors.white,
        child: Container(
          height: 40,
          width: 40,
          alignment: Alignment.center,
          margin: new EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                gender.icon,
                color: gender.isSelected ? gender.selectedColor : gender.color,
                size: 20,
              ),
            ],
          ),
        ));
  }
}
