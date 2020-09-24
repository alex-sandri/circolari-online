import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Accedi"),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: [
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Password",
              ),
              obscureText: true,
            ),
            FlatButton(
              child: Text("Accedi"),
              onPressed: () {
                // TODO
              },
            ),
          ],
        ),
      ),
    );
  }
}