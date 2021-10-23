import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:autentication/Component/PulsanteFocus.dart';
import 'package:autentication/Component/CircularProgressIndicatorWHITE.dart';
import 'package:autentication/Screen/Autenticazione/LoginPage.dart';
import 'package:autentication/Screen/HomePage.dart';




class Splash extends StatefulWidget {
  static String routeName = "/splash";

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  User result = FirebaseAuth.instance.currentUser;

  /* @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (result != null) {
        await Navigator.popAndPushNamed(context, HomePage.routeName);
      } else {
        await Navigator.popAndPushNamed(context, LoginPage.routeName);
      }
    });*/
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      print(result.toString());
      if (result != null)
        Navigator.popAndPushNamed(context, HomePage.routeName);
      else
        Navigator.popAndPushNamed(context, LoginPage.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    /*return new SplashScreen(
        navigateAfterSeconds: result != null ? HomePage() : AccountPage(),
        seconds: 5,
        title: new Text(
          'EUREKA!!',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
        ),
        image: Image.network(
          "https://picsum.photos/id/144/300/300",
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () => print("flutter"),
        loaderColor: Colors.orange);
  }*/

    return corpoCentraleSplash(context);
  }

  Widget corpoCentraleSplash(BuildContext context) => new Scaffold(
        body: new Stack(
          children: [
            new Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.network(
                "https://picsum.photos/id/14/300/300",
                fit: BoxFit.cover,
              ),
            ),
            new Positioned(
              top: MediaQuery.of(context).size.height / 2,
              left: 0,
              right: 0,
              bottom: 0,
              child: new Container(
                  color: Colors.white,
                  child: new Padding(
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Text(
                            "Lavoriamo Insieme",
                            style: new TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -4),
                          ),
                          new SizedBox(
                            height: 20,
                          ),
                          new Text(
                            "Funziona tutto meglio quando si collabora",
                            style: new TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          new SizedBox(
                            height: 60,
                          ),
                          new PulsanteFocus(
                            child: new CircularProgressIndicatorWHITE(),
                            backgroundColor: Colors.black87,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      );
}
