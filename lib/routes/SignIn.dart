import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
              ),
              obscureText: true,
            ),
            FlatButton(
              child: Text("Accedi"),
              onPressed: () async {
                try
                {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                }
                on FirebaseAuthException catch (e)
                {
                  String error = "Errore sconosciuto";

                  switch (e.code)
                  {
                    case "user-not-found": error = "Non è presente un utente con questa email"; break;
                    case "wrong-password": error = "Password errata"; break;
                    case "invalid-email": error = "Email non valida"; break;
                  }

                  showDialog(
                    context: context,
                    child: AlertDialog(
                      title: Text("Errore"),
                      content: Text(error),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}