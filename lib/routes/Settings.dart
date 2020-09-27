import 'package:circolari_online/routes/Home.dart';
import 'package:circolari_online/routes/SignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Impostazioni"),
        ),
        body: ListView(
          children: [
            if (_auth.currentUser != null)
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("Elimina account"),
                onTap: () => showDialog(
                  context: context,
                  child: AlertDialog(
                    title: Text("Elimina account"),
                    content: Text("Eliminando il tuo account perderai tutte le circolari create e le loro relative risposte"),
                    actions: [
                      FlatButton(
                        child: Text("Annulla"),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      FlatButton(
                        child: Text("OK"),
                        onPressed: () async {
                          Navigator.of(context).pop();

                          try
                          {
                            await _auth.currentUser.delete();

                            Navigator
                              .of(context)
                              .pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => Home()),
                                (route) => false,
                              );
                          }
                          on FirebaseAuthException catch (e)
                          {
                            if (e.code == "requires-recent-login")
                            {
                              Navigator
                                .of(context)
                                .push(MaterialPageRoute(builder: (context) => SignIn(reauthenticate: true)));
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}