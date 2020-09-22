import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CircolareAnswer
{
  final String id;

  final Map<String, dynamic> fields;

  CircolareAnswer({
    @required this.id,
    @required this.fields,
  });

  static CircolareAnswer fromFirestore(DocumentSnapshot document) =>
    CircolareAnswer(
      id: document.id,
      fields: document.data(),
    );
}