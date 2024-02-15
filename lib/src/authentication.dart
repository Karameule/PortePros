import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets.dart';

class AuthFunc extends StatelessWidget {
  const AuthFunc({
    Key? key,
    required this.loggedIn,
    required this.signOut,
  }) : super(key: key);

  final bool loggedIn;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: loggedIn,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: StyledButton(
                onPressed: () {
                  context.go('/profile');
                },
                child: const Text('Profil'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 8),
            child: StyledButton(
              onPressed: () {
                if (!loggedIn) {
                  context.go('/sign-in');
                } else {
                  context.go('/sales'); // Redirige vers la page des ventes
                }
              },
              child: Text(loggedIn ? 'Ventes' : 'Se connecter'),
            ),
          ),
          Visibility(
            visible: loggedIn,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: StyledButton(
                onPressed: () {
                  context.go('/ranking'); // Redirige vers la page de classement
                },
                child: const Text('Classement'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
