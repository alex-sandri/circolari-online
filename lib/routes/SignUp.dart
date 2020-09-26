import 'package:circolari_online/routes/Home.dart';
import 'package:circolari_online/routes/SignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  String _emailError;

  String _passwordError;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Registrati"),
          actions: [
            FlatButton(
              child: Text("Accedi"),
              onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignIn())),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                errorText: _emailError,
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                errorText: _passwordError,
              ),
              obscureText: true,
            ),
            FlatButton(
              child: Text("Registrati"),
              onPressed: () async {
                try
                {
                  await _auth.createUserWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Home()),
                    (route) => false
                  );
                }
                on FirebaseAuthException catch (e)
                {
                  _emailError = _passwordError = null;

                  switch (e.code)
                  {
                    case "invalid-email": _emailError = "Email non valida"; break;
                    case "email-already-in-use": _emailError = "È già presente un utente con questa email"; break;
                    case "weak-password": _passwordError = "Password poco sicura"; break;
                  }

                  setState(() {});
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}