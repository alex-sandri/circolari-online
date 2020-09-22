import 'package:circolari_online/models/CircolareAnswer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CircolareAnswerPage extends StatelessWidget {
  final CircolareAnswer answer;

  CircolareAnswerPage(this.answer);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            title: Text(answer.id),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.check),
                  tooltip: "Segna come gestita",
                  onPressed: () async {
                    final FirebaseFirestore db = FirebaseFirestore.instance;

                    await db.collection("circolari/${answer.parentId}/answers").doc(answer.id).update({ "metadata.handled": true });

                    Scaffold
                      .of(context)
                      .showSnackBar(SnackBar(content: Text("Risposta segnata come gestita")));
                  },
                ),
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: answer.fields.length,
            itemBuilder: (context, index) {
              final MapEntry<String, dynamic> field = answer.fields.entries.elementAt(index);

              return ListTile(
                title: SelectableText(field.key),
                subtitle: SelectableText(
                  field.value.runtimeType == bool
                    ? (field.value ? "Sì" : "No")
                    : field.value.toString(),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}