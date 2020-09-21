import 'package:circolari_online/widgets/CircolareField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Circolare
{
  final String id;

  final String title;

  final List<CircolareField> fields;

  Circolare({
    this.id,
    @required this.title,
    @required this.fields,
  });

  Map<String, dynamic> toFirestore() => {
    "title": title,
    "fields": fields.map((field) => {
      "type": field.type,
      "label": field.label,
      "isRequired": field.isRequired,
      "defaultValue": field.defaultValue,
    }).toList(),
  };

  static Circolare fromFirestore(QueryDocumentSnapshot document) =>
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
}