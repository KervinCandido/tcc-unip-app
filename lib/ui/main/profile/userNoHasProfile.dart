import 'package:flutter/material.dart';

class UserNoHasProfile extends StatelessWidget {
  final VoidCallback? onPressed;

  UserNoHasProfile({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(Icons.person),
        label: Text('Criar novo perfil'),
        style: OutlinedButton.styleFrom(
          primary: Colors.redAccent,
          padding: const EdgeInsets.all(15),
          side: BorderSide(
            color: Colors.redAccent,
          ),
        ),
      ),
    );
    ;
  }
}
