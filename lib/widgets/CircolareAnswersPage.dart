import 'package:circolari_online/models/Circolare.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CircolareAnswersPage extends StatelessWidget {
  final Circolare circolare;

  CircolareAnswersPage(this.circolare);

  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Risposte: " + circolare.title),
            actions: [
              IconButton(
                icon: Icon(Icons.share),
                tooltip: "Condividi",
                onPressed: () {
                  showDialog(
                    context: context,
                    child: Dialog(
                      backgroundColor: Colors.white,
                      child: QrImage(
                        data: "TODO",
                        version: QrVersions.auto,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: db.collection("circolari/${circolare.id}/answers").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();

              if (snapshot.data.docs.isEmpty)
                return Center(
                  child: Text("Non sono presenti risposte"),
                );

              return ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: snapshot.data.size,
                itemBuilder: (context, index) {
                  return ListTile();
                },
              );
            }
          )
        ),
      ),
    );
  }
}