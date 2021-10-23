import 'package:autentication/Component/CircularProgressIndicatorWHITE.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:autentication/main.dart';

import 'package:autentication/Screen/Autenticazione/AccountPage.dart';
import 'package:autentication/Screen/HomePage.dart';

import 'package:autentication/Util/Validazione.dart';
import 'package:autentication/Component/AppFormField.dart';
import 'package:autentication/Component/PulsanteFocus.dart';

class LoginPage extends StatefulWidget {
  static String routeName = "/loginPage";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController pswController = new TextEditingController();

  // Variabili di stato per gestire eventuali errori di validazione del form.
  String errorEmail;
  String errorPsw;
  //Variabile di stato per indicare se Repository.login sta caricando
  bool isLoading = false;

  void onSubmitLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final psw = pswController.text.trim();

    // Reset messaggi errore (altrimenti rimarrebbero anche se un campo fosse corretto)
    setState(() {
      errorEmail = null;
      errorPsw = null;
    });

    //validazione!!!
    final valid = validazione((daValidare) {
      daValidare(
          email.isEmpty, () => setState(() => errorEmail = "Campo richiesto"));
      daValidare(email.isNotEmpty && !isValidEmail(email),
          () => setState(() => errorEmail = "Email NON valida"));
      daValidare(
          psw.isEmpty, () => setState(() => errorPsw = "Campo richiesto"));
      daValidare(
          psw.isNotEmpty && psw.length < 6,
          () => setState(() => errorPsw =
              "Password troppo corta, almeno 5 caratteri alfanimerici!"));
    });

    if (!valid)
      return;
    else {
      setState(() {
        isLoading = true;
      });
      try {
        print("making http request to register");
        final user = await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: psw);
        if (user != null) {
          Navigator.pushNamed(context, HomePage.routeName);
        }
      } catch (error) {
        print("errore nel login: $error");
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
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          new TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, AccountPage.routeName),
            child: new Text(
              "Non hai ancora un "
              "account?",
              style: new TextStyle(color: Colors.black54),
            ),
          )
        ],
        elevation: 0,
      ),
      body: corpoCentraleLoginForm(context),
    );
  }

  Widget corpoCentraleLoginForm(BuildContext context) => new
  SingleChildScrollView(
        child: new Container(
          padding: EdgeInsets.all(10),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new SizedBox(
                height: 30,
              ),
              titolo(),
              new SizedBox(
                height: 10,
              ),
              sottotitolo(),
              new SizedBox(
                height: 40,
              ),
              formLogin(),
              new SizedBox(
                height: 40,
              ),
              new PulsanteFocus(
                child: isLoading
                    ? new CircularProgressIndicatorWHITE()
                    : new Text("Login"),
                backgroundColor: Color(0xFF0661F1),
                onPressed: () => onSubmitLogin(context),
              ),
            ],
          ),
        ),
      );

  Widget titolo() => new Text(
        "Ben Ritornato!",
        style: new TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget sottotitolo() => new Text(
        "Inserisci le tue credenziali per continuare",
        style: new TextStyle(
          color: Colors.black38,
        ),
      );

  Widget formLogin() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new AppFormField(
            label: "Email",
            controller: emailController,
            iconaSx: Icons.person,
            hintText: "email",
            keyboardType: TextInputType.emailAddress,
            error: errorEmail,
          ),
          new SizedBox(height: 30),
          new AppFormField(
            label: "Password",
            controller: pswController,
            iconaSx: Icons.lock,
            hintText: "password",
            obscureText: true,
            error: errorPsw,
          ),
        ],
      );
}
