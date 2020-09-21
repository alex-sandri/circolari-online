import 'package:circolari_online/models/Circolare.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: db.collection("circolari/${circolare.id}/answers").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data.docs.isEmpty)
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