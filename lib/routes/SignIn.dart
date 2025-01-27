import 'package:circolari_online/routes/Home.dart';
import 'package:circolari_online/routes/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final bool reauthenticate;

  SignIn({ this.reauthenticate = false });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
          title: Text("Accedi"),
          actions: [
            FlatButton(
              child: Text("Registrati"),
              onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignUp())),
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
              child: Text("Accedi"),
              onPressed: () async {
                try
                {
                  if (widget.reauthenticate)
                  {
                    EmailAuthCredential credential = EmailAuthProvider.credential(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );

                    await _auth.currentUser.reauthenticateWithCredential(credential);

                    Navigator.of(context).pop();
                  }
                  else
                  {
                    await _auth.signInWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Home()),
                      (route) => false
                    );
                  }
                }
                on FirebaseAuthException catch (e)
                {
                  _emailError = _passwordError = null;

                  switch (e.code)
                  {
                    case "invalid-email": _emailError = "Email non valida"; break;
                    case "user-not-found": _emailError = "Non è presente un utente con questa email"; break;
                    case "wrong-password": _passwordError = "Password errata"; break;
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