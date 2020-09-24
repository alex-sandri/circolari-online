import 'package:circolari_online/widgets/CircolareField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Circolare
{
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String id;

  final String title;

  final List<CircolareField> fields;

  Circolare({
    this.id,
    @required this.title,
    @required this.fields,
  });

  static Future<void> create(Circolare circolare) =>
    _db.collection("circolari").add(circolare.toFirestore());

  static Future<Circolare> get(String id) async =>
    Circolare.fromFirestore(await _db.collection("circolari").doc(id).get());

  static Stream<List<Circolare>> getAll() async* {
    await for (final QuerySnapshot snapshot in _db.collection("circolari").where("owner", isEqualTo: FirebaseAuth.instance.currentUser.uid).snapshots())
    {
      yield snapshot.docs.map((doc) => Circolare.fromFirestore(doc)).toList();
    }
  }

  Map<String, dynamic> toFirestore() => {
    "title": title,
    "fields": fields.map((field) => {
      "type": field.type,
      "label": field.label,
      "isRequired": field.isRequired,
      "defaultValue": field.defaultValue,
    }).toList(),
  };

  static Circolare fromFirestore(DocumentSnapshot document) =>
    Circolare(
      id: document.id,
      title: document.data()["title"],
      fields: (document.data()["fields"] as List).map((field) => CircolareField(
        type: field["type"],
        label: field["label"],
        isRequired: field["isRequired"],
        defaultValue: field["defaultValue"],
      )).toList(),
    );

  @override
  String toString() => id;

  static bool isRestrictedFieldLabel(String label) => [ "metadata" ].contains(label);
}