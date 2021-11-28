import 'package:app_tcc_unip/controller/authController.dart';
import 'package:app_tcc_unip/controller/form/authForm.dart';
import 'package:app_tcc_unip/ui/main/mainScreen.dart';
import 'package:app_tcc_unip/ui/signUp/signUpScreen.dart';
import 'package:app_tcc_unip/ui/util/loading.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  var _userController = TextEditingController();
  var _passwordController = TextEditingController();
  var _passwordFocusNode = FocusNode();

  final authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image.asset('assets/images/logo150.png'),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: _userController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Preenchimento obrigatório';
                  } else if (value.length < 3 || value.length > 64) {
                    return 'O usuário deve ter de 6 a 20 caracteres';
                  }
                  return null;
                },
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: 18.0),
                keyboardType: TextInputType.name,
                cursorColor: Color(COLOR_PRIMARY),
                decoration: InputDecoration(
                  contentPadding: new EdgeInsets.only(left: 16, right: 16),
                  fillColor: Colors.white,
                  labelText: 'Usuário',
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
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Preenchimento obrigatório';
                  } else if (value.length < 6 || value.length > 20) {
                    return 'A senha deve ter de 6 a 20 caracteres';
                  }
                  return null;
                },
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  _login(context);
                },
                obscureText: true,
                focusNode: _passwordFocusNode,
                style: TextStyle(fontSize: 18.0),
                keyboardType: TextInputType.visiblePassword,
                cursorColor: Color(COLOR_PRIMARY),
                decoration: InputDecoration(
                  contentPadding: new EdgeInsets.only(left: 16, right: 16),
                  fillColor: Colors.white,
                  labelText: 'Senha',
                  hintStyle: TextStyle(
                    color: Colors.redAccent,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      child: Text('Entrar'),
                      onPressed: () {
                        _login(context);
                      },
                      style: OutlinedButton.styleFrom(
                        primary: Colors.redAccent,
                        padding: const EdgeInsets.all(15),
                        side: BorderSide(
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: GestureDetector(
                child: Text(
                  'Ainda não possui conta',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) {
                        return SignUp();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var loading = Loading();
      loading.showLoaderDialog(context);

      final user = _userController.text;
      final password = _passwordController.text;

      AuthForm authForm = AuthForm(userName: user, password: password);
      bool autencado = await authController.auth(authForm);
      Navigator.pop(context);

      if (autencado) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Autenticado com sucesso')),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              return MainScreen();
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário ou senha inválido')),
        );
        _passwordController.clear();
        _passwordFocusNode.requestFocus();
      }
    }
  }
}
