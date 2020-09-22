import 'package:circolari_online/models/Circolare.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CircolarePage extends StatelessWidget {
  final Circolare circolare;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CircolarePage(this.circolare);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            title: Text(circolare.title),
          ),
          body: Column(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 8,
                    ),
                    itemCount: circolare.fields.length,
                    itemBuilder: (context, index) => circolare.fields[index],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: FlatButton(
                  child: Text("Invia"),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).accentColor,
                  colorBrightness: Theme.of(context).accentColorBrightness,
                  onPressed: () async {
                    if (_formKey.currentState.validate())
                    {
                      final FirebaseFirestore db = FirebaseFirestore.instance;

                      final Map<String, dynamic> answer = {
                        "fields": {},
                        "metadata": {
                          "sent": FieldValue.serverTimestamp(),
                        },
                      };

                      circolare.fields.forEach((field) => answer["fields"][field.label] = field.value);

                      await db.collection("circolari/${circolare.id}/answers").add(answer);

                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}