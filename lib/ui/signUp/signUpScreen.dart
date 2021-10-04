import 'package:app_tcc_unip/controller/authController.dart';
import 'package:app_tcc_unip/controller/exception/ErroFormException.dart';
import 'package:app_tcc_unip/controller/form/authForm.dart';
import 'package:app_tcc_unip/controller/form/signForm.dart';
import 'package:app_tcc_unip/controller/signUpController.dart';
import 'package:app_tcc_unip/ui/login/loginScreen.dart';
import 'package:app_tcc_unip/ui/screens/categories_screen.dart';
import 'package:app_tcc_unip/ui/util/loading.dart';
import 'package:app_tcc_unip/ui/validator/emailValidation.dart';
import 'package:app_tcc_unip/ui/validator/equalsPasswordValidation.dart';
import 'package:app_tcc_unip/ui/validator/mustFilledValidation.dart';
import 'package:app_tcc_unip/ui/validator/sizeValidation.dart';
import 'package:app_tcc_unip/ui/validator/userNameAlreadyExistsValidaton.dart';
import 'package:app_tcc_unip/ui/validator/validation.dart';
import 'package:app_tcc_unip/ui/validator/validationException.dart';
import 'package:app_tcc_unip/ui/validator/validator.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

const PADDING_ITENS_FORM = 10.0;

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _signUpController = SignUpController();
  final _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cadastro',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: 25),
                TextFormField(
                  validator: (val) {
                    return _validation(val, [
                      MustFilledValidation(),
                      SizeValidation(2, 100),
                    ]);
                  },
                  controller: _nameController,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                  ),
                ),
                SizedBox(height: PADDING_ITENS_FORM),
                TextFormField(
                  validator: (val) {
                    return _validation(val, [
                      MustFilledValidation(),
                      SizeValidation(3, 64),
                      UserNameAlreadyExistsValidaton()
                    ]);
                  },
                  controller: _userNameController,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'Usuário',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                  ),
                ),
                SizedBox(height: PADDING_ITENS_FORM),
                TextFormField(
                  validator: (val) {
                    return _validation(val, [
                      MustFilledValidation(),
                      EmailValidation(),
                    ]);
                  },
                  controller: _emailController,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                  ),
                ),
                SizedBox(height: PADDING_ITENS_FORM),
                TextFormField(
                  validator: (val) {
                    return _validation(val, [
                      MustFilledValidation(),
                      SizeValidation(6, 20),
                    ]);
                  },
                  controller: _passwordController,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                  ),
                ),
                SizedBox(height: PADDING_ITENS_FORM),
                TextFormField(
                  validator: (val) {
                    return _validation(val, [
                      MustFilledValidation(),
                      SizeValidation(6, 20),
                      EqualsPasswordValidation(_passwordController.text),
                    ]);
                  },
                  onFieldSubmitted: (value) {
                    _signup();
                  },
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirmação da Senha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                  ),
                ),
                SizedBox(height: PADDING_ITENS_FORM * 2),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            _signup();
                          },
                          child: Text(
                            'Cadastrar',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: OutlinedButton.styleFrom(
                            primary: Theme.of(context).colorScheme.primary,
                            side: BorderSide(
                              width: 2,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: PADDING_ITENS_FORM * 2),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) {
                          return Login();
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Já possui uma conta ?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      final signUpForm = SignForm(
        this._nameController.text,
        this._userNameController.text,
        this._emailController.text,
        this._passwordController.text,
      );
      final load = Loading();
      load.showLoaderDialog(context);
      try {
        print('Tentando criar Usuário');
        var userDTO = await _signUpController.signUp(signUpForm);
        print('Usuário criado com sucesso!!');
        print('$userDTO');
        bool isLogged = await _authController.auth(
          AuthForm(
            userName: this._userNameController.text,
            password: this._passwordController.text,
          ),
        );
        print('Usuário logado $isLogged');

        Navigator.pop(context);
        if (isLogged) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) {
                return CategoriesScreen();
              },
            ),
          );
        }
      } on ErroFormException catch (e) {
        print(e);
        final String message = e.erros
            .map((e) => e.message)
            .reduce((value, element) => '$element\n');

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
        Navigator.pop(context);
      } catch (e) {
        print(e);
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
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
}
