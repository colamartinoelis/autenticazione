import 'package:autentication/Component/CircularProgressIndicatorWHITE.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import 'package:autentication/Component/AppFormField.dart';
import 'package:autentication/Component/PulsanteFocus.dart';

import 'package:autentication/Screen/Autenticazione/LoginPage.dart';

import 'package:autentication/Util/Validazione.dart';
import 'package:autentication/Repository/Repository.dart';

import '../../main.dart';
import '../HomePage.dart';

class AccountPage extends StatefulWidget {
  static String routeName = "/accountPage";

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isLoading = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("Users");

  final TextEditingController nomeController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController pswController = new TextEditingController();
  final TextEditingController pswConfermataController =
      new TextEditingController();

  String errorNome;
  String errorEmail;
  String errorPsw;
  String errorPswConfermata;

  void onSubmitAccount() async {
    final nome = nomeController.text.trim();
    final email = emailController.text.trim();
    final psw = pswController.text.trim();
    final pswConfermata = pswConfermataController.text.trim();

    setState(() {
      errorNome = null;
      errorEmail = null;
      errorPsw = null;
      errorPswConfermata = null;
    });

    // Validazione campi form
    final valid = validazione((daValidare) {
      daValidare(
          nome.isEmpty, () => setState(() => errorNome = "Campo richiesto"));
      daValidare(
          email.isEmpty, () => setState(() => errorEmail = "Campo richiesto"));
      daValidare(email.isNotEmpty && !isValidEmail(email),
          () => setState(() => errorEmail = "Email NON valida"));
      daValidare(
          psw.isEmpty, () => setState(() => errorPsw = "Campo richiesto"));
      daValidare(
          psw.isNotEmpty && psw.length < 6,
          () => setState(() => errorPsw = "Password troppo corta, almeno 6 "
              "caratteri alfanumerici!"));
      daValidare(pswConfermata.isEmpty,
          () => setState(() => errorPswConfermata = "Campo richiesto"));
      daValidare(
          psw.isNotEmpty && pswConfermata.isNotEmpty && psw != pswConfermata,
          () => setState(() => errorPswConfermata = "Le due password NON "
              "coincidono!"));
    });

    if (!valid)
      return;
    else {
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
    }


  @override
  void dispose() {
    super.dispose();
    nomeController.dispose();
    emailController.dispose();
    pswConfermataController.dispose();
    pswController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        actions: [
          new TextButton(
            onPressed: () => Navigator.pushNamed(context, LoginPage.routeName),
            child: new Text(
              "Hai già un account?",
              style: new TextStyle(color: Colors.black54),
            ),
          )
        ],
        elevation: 0,
      ),
      body: corpoCentraleAccountForm(),
    );
  }

  Widget corpoCentraleAccountForm() => new SingleChildScrollView(
        child: new Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titolo(),
              new SizedBox(
                height: 5,
              ),
              sottotitolo(),
              new SizedBox(
                height: 30,
              ),
              formLogin(),
              new SizedBox(
                height: 40,
              ),
              pulsanteAccount(),
              new SizedBox(
                height: 10,
              ),
              pulsanteGoogle(),
            ],
          ),
        ),
      );

  Widget titolo() => new Text(
        "Crea il tuo Account",
        style: new TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget sottotitolo() => new Text(
        "Inserisci i dati richiesti per creare il tuo account",
        style: new TextStyle(
          color: Colors.black38,
        ),
      );

  Widget formLogin() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new AppFormField(
            label: "Nome",
            iconaSx: Icons.person,
            hintText: "nome",
            keyboardType: TextInputType.text,
            error: errorNome,
            controller: nomeController,
          ),
          new SizedBox(height: 20),
          new AppFormField(
              label: "Email",
              iconaSx: Icons.mail,
              hintText: "email",
              keyboardType: TextInputType.emailAddress,
              error: errorEmail,
              controller: emailController),
          new SizedBox(height: 20),
          new AppFormField(
              label: "Password",
              iconaSx: Icons.lock,
              hintText: "password",
              keyboardType: TextInputType.text,
              obscureText: true,
              error: errorPsw,
              controller: pswController),
          new SizedBox(height: 20),
          new AppFormField(
            label: "Conferma Password",
            iconaSx: Icons.lock,
            hintText: "conferma password",
            keyboardType: TextInputType.text,
            obscureText: true,
            error: errorPswConfermata,
            controller: pswConfermataController,
          ),
        ],
      );

  Widget pulsanteAccount() => new PulsanteFocus(
        child:   isLoading
      //getIt<Repository>().isLoading
            ? new CircularProgressIndicatorWHITE()
            : new Text("Crea il Tuo Account"),
        backgroundColor: Color(0xFF0661F1),
        onPressed: onSubmitAccount,
      );

  Widget pulsanteGoogle() => Center(
          child: SignInButton(
        Buttons.Google,
        text: "Sign up with Google",
        shape: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 1),
            borderRadius: BorderRadius.circular(20)),
        onPressed: () {},
      ));
}
