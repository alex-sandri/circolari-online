import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CircolareAnswer
{
  final String id;

  /// The `id` of the `Circolare` this answer belongs to
  final String parentId;

  final Map<String, dynamic> fields;

  final Map<String, dynamic> metadata;

  CircolareAnswer({
    @required this.id,
    @required this.parentId,
    @required this.fields,
    @required this.metadata,
  });

  static CircolareAnswer fromFirestore(DocumentSnapshot document) =>
    CircolareAnswer(
      id: document.id,
      parentId: document.reference.parent.parent.id,
      fields: document.data()..removeWhere((key, value) => key == "metadata"),
      metadata: document.data()["metadata"],
    );
}