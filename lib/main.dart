import 'package:app_tcc_unip/controller/authController.dart';
import 'package:app_tcc_unip/ui/main/mainScreen.dart';
import 'package:app_tcc_unip/ui/signUp/signUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  var _authController = AuthController();

  runApp(
    MaterialApp(
      title: 'Login',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.red,
        fontFamily: 'Raleway',
        canvasColor: Color.fromRGBO(255, 192, 203, 1),
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
              ),
            ),
      ),
      home: FutureBuilder<bool>(
        future: _authController.autoAuth(),
        builder: (
          BuildContext context,
          AsyncSnapshot<bool> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.done) {
            return (snapshot.data ?? false) ? MainScreen() : SignUp();
          }
          return Container(
            color: Colors.white,
            child: SpinKitSpinningLines(
              color: Colors.redAccent,
            ),
          );
        },
      ),
    ),
  );
}
