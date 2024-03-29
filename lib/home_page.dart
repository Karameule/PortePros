import 'package:firebase_auth/firebase_auth.dart' // new
    hide
        EmailAuthProvider,
        PhoneAuthProvider; // new
import 'package:flutter/material.dart'; // new
import 'package:provider/provider.dart'; // new

import 'app_state.dart'; // new
import 'src/authentication.dart'; // new
import 'src/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PortePros'),
        centerTitle: true, // Centrer le titre de l'appBar
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            SizedBox(
                height: 20), // Espacement entre le widget précédent et l'image
            Image(
              image: AssetImage('PortePros_LOGO.jpg'),
              height: 250,
            ),
            Center(
              child: const Header("Bienvenue sur l'application PortePros"),
            ),
            Consumer<ApplicationState>(
              builder: (context, appState, _) => AuthFunc(
                loggedIn: appState.loggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
