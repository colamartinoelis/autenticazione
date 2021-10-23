import 'package:autentication/Screen/Autenticazione/LoginPage.dart';
import 'package:autentication/Screen/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:autentication/Repository/Repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Repository {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("Users");

  bool isLoading = false;


  Future<Widget> sendData(BuildContext context, String email, String, nome,
      String psw, Function setState) async {

    setState(() {
      isLoading = true;
    });

    try {
      print("making http request to register");
      final user = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: psw);
      if (user != null) {
        dbRef.child(user.user.uid).set({
          "email": email,
          "name": nome,
        }).asStream();
        Navigator.pushNamed(context, HomePage.routeName);
      }
    } catch (error) {
      print("errore nella registrazione: $error");

      setState(() {
        isLoading = false;
      });

      return await showDialog(
          context: context,
          builder: (BuildContext context) {
            print("ciao2");
            return AlertDialog(
              title: Text("Error"),
              content: Text(error.message),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  Future<void> logout(BuildContext context) async{

    await firebaseAuth.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginPage.routeName,
          (route) => false,
    );

    /*firebaseAuth.signOut().then((res) => Navigator.pushNamedAndRemoveUntil(
          context,
          LoginPage.routeName,
          (route) => false,
        ));*/

  }


}//fine classe
