import 'package:barcode_scan/barcode_scan.dart';
import 'package:circolari_online/models/Circolare.dart';
import 'package:circolari_online/routes/SignIn.dart';
import 'package:circolari_online/widgets/CircolareAnswersPage.dart';
import 'package:circolari_online/widgets/CircolarePage.dart';
import 'package:circolari_online/widgets/CreateCircolarePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore db = FirebaseFirestore.instance;

  bool _isSignedIn() => auth.currentUser != null;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Circolari Online"),
          actions: [
            IconButton(
              icon: Icon(Icons.qr_code),
              tooltip: "Compila circolare",
              onPressed: () async {
                final ScanResult result = await BarcodeScanner.scan(
                  options: ScanOptions(
                    restrictFormat: [ BarcodeFormat.qr ],
                    strings: {
                      "cancel": "Annulla",
                      "flash_on": "Accendi flash",
                      "flash_off": "Spegni flash",
                    },
                  ),
                );

                if (result.type == ResultType.Barcode)
                {
                  final String id = result.rawContent;

                  final Circolare circolare = await Circolare.get(id);

                  Navigator
                    .of(context)
                    .push(MaterialPageRoute(
                      builder: (context) => CircolarePage(circolare),
                    ));
                }
              },
            ),

            if (_isSignedIn())
              IconButton(
                icon: Icon(Icons.exit_to_app),
                tooltip: "Esci",
                onPressed: FirebaseAuth.instance.signOut,
              ),

            if (!_isSignedIn())
              IconButton(
                icon: Icon(Icons.login),
                tooltip: "Accedi",
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignIn())),
              ),
          ],
        ),
        body: _isSignedIn()
          ?
            StreamBuilder<List<Circolare>>(
              stream: Circolare.getAll(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();

                if (snapshot.data.isEmpty)
                  return Center(
                    child: Text("Non sono presenti circolari"),
                  );

                return ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final Circolare circolare = snapshot.data[index];

                    return ListTile(
                      title: Text(circolare.title),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CircolareAnswersPage(circolare)
                        ),
                      ),
                    );
                  },
                );
              }
            )
          :
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Accedi per creare circolari"),
                  FlatButton.icon(
                    icon: Icon(Icons.login),
                    label: Text("Accedi"),
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignIn())),
                  ),
                ],
              ),
            ),
        floatingActionButton: !_isSignedIn() ? null : Builder(
          builder: (context) => FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: "Crea nuova circolare",
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateCircolarePage())),
          ),
        ),
      ),
    );
  }
}