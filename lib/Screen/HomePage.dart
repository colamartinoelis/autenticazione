import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:autentication/Screen/Autenticazione/LoginPage.dart';
import 'package:autentication/Repository/Repository.dart';
import 'package:autentication/main.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/homePage";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  void logout(BuildContext context) {
    auth.signOut().then((res) => Navigator.pushNamedAndRemoveUntil(
          context,
          LoginPage.routeName,
          (route) => false,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: drawerHome(context),
      appBar: AppBar(
        centerTitle: false,
        // se non voglio la freccia che torna indietro nel leading impostare
        // come segue: automaticallyImplyLeading: false,
        title: new Text("HomePage"),
        actions: [
          new IconButton(
            icon: new Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
          //getIt<Repository>().logout(context),),
        ],
        elevation: 3,
      ),
      body: new Center(
        child: new Text("Body3"),
      ),
    );
  }

  Widget drawerHome(BuildContext context) {
    final account = auth.currentUser;
    DatabaseReference dbRef =
        FirebaseDatabase.instance.reference().child("Users");
    return new Drawer(
      child: new ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: account == null
                ? Text("nome")
                : new FutureBuilder(
                    future: dbRef.child(account.uid).once(),
                    builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        print("ciao");
                        return Text(snapshot.data.value['name']);
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
            accountEmail: account == null
                ? Text("EMAIL")
                : new FutureBuilder(
                    future: FirebaseDatabase.instance
                        .reference()
                        .child("Users")
                        .child(account.uid)
                        .once(),
                    builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        print("ciao");
                        return Text(snapshot.data.value['email']);
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
          ),
          new ListTile(
            leading: new Icon(
              Icons.home,
              color: Colors.black,
            ),
            title: new Text("Home"),
            onTap: () => Navigator.pushNamed(context, HomePage.routeName),
          ),
          new ListTile(
            leading: new Icon(
              Icons.settings,
              color: Colors.black,
            ),
            title: new Text("Settings"),
            onTap: () => Navigator.pushNamed(context, HomePage.routeName),
          )
        ],
      ),
    );
  }
}
