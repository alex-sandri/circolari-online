import 'package:circolari_online/widget/CircolareField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Circolare
{
  final String title;

  final List<CircolareField> fields;

  Circolare({
    @required this.title,
    @required this.fields,
  });

  Map<String, dynamic> toFirestore() => {
    "title": title,
    "fields": fields.map((field) => {
      "label": field.label,
      "isRequired": field.isRequired,
      "defaultValue": field.defaultValue,
    }).toList(),
  };

  static Circolare fromFirestore(QueryDocumentSnapshot document) =>
    Circolare(
      title: document.data()["title"],
      fields: (document.data()["fields"] as List).map((field) => CircolareField(
        label: field["label"],
        isRequired: field["isRequired"],
        defaultValue: field["defaultValue"],
      )).toList(),
    );
}