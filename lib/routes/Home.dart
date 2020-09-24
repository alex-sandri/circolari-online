import 'package:barcode_scan/barcode_scan.dart';
import 'package:circolari_online/models/Circolare.dart';
import 'package:circolari_online/widgets/CircolareAnswersPage.dart';
import 'package:circolari_online/widgets/CircolarePage.dart';
import 'package:circolari_online/widgets/CreateCircolarePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final FirebaseFirestore db = FirebaseFirestore.instance;

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

                  final Circolare circolare = await Circolare.fromString(id);

                  Navigator
                    .of(context)
                    .push(MaterialPageRoute(
                      builder: (context) => CircolarePage(circolare),
                    ));
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              tooltip: "Esci",
              onPressed: FirebaseAuth.instance.signOut,
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: db.collection("circolari").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();

            if (snapshot.data.docs.isEmpty)
              return Center(
                child: Text("Non sono presenti circolari"),
              );

            return ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: snapshot.data.size,
              itemBuilder: (context, index) {
                final Circolare circolare = Circolare.fromFirestore(snapshot.data.docs[index]);

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
        ),
        floatingActionButton: Builder(
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