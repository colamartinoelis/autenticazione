import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:autentication/Repository/Repository.dart';
import 'package:autentication/Screen/Autenticazione/AccountPage.dart';
import 'package:autentication/Screen/Autenticazione/Splash.dart';
import 'package:autentication/Screen/HomePage.dart';
import 'package:autentication/Screen/Autenticazione/LoginPage.dart';
import 'package:get_it/get_it.dart';

//final getIt = GetIt.instance;



void main() async{
  //getIt.registerSingleton<Repository>(Repository());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        Splash.routeName: (_) => new Splash(),
        LoginPage.routeName: (context) => new LoginPage(),
        AccountPage.routeName: (_) => new AccountPage(),
        HomePage.routeName: (_) =>new HomePage(),
      },
      initialRoute: Splash.routeName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
      ),
    );
  }
}
