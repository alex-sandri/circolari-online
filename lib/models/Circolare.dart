import 'package:circolari_online/widgets/CircolareField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Circolare
{
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  final String id;

  final String title;

  final String description;

  final List<CircolareField> fields;

  Circolare({
    this.id,
    @required this.title,
    @required this.description,
    @required this.fields,
  });

  Future<void> create() =>
    _db.collection("circolari").add({
      "metadata": {
        "owner": _auth.currentUser.uid,
        "createdAt": FieldValue.serverTimestamp(),
      },
      ...this.toFirestore(),
    });

  Future<void> update(String field, dynamic value) => _db.collection("circolari").doc(id).update({ field: value });

  Future<void> delete() => CloudFunctions(region: "europe-west1").getHttpsCallable(functionName: "deleteCircolare").call({ "id": id });

  static Stream<Circolare> get(String id) async* {
    await for (final DocumentSnapshot snapshot in _db.collection("circolari").doc(id).snapshots())
    {
      yield Circolare.fromFirestore(snapshot);
    }
  }

  static Stream<List<Circolare>> getAll() async* {
    await for (final QuerySnapshot snapshot in _db.collection("circolari").where("metadata.owner", isEqualTo: _auth.currentUser.uid).snapshots())
    {
      yield snapshot.docs.map((doc) => Circolare.fromFirestore(doc)).toList();
    }
  }

  Map<String, dynamic> toFirestore() => {
    "title": title,
    "description": description,
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
      description: document.data()["description"],
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