import 'package:circolari_online/models/Circolare.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CircolareSettings
{
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String id;

  final bool _allowNewAnswers;

  get allowNewAnswers => _allowNewAnswers;

  set allowNewAnswers(bool allow) => set("allowNewAnswers", allow);

  CircolareSettings._({
    @required this.id,
    @required bool allowNewAnswers,
  }):
    _allowNewAnswers = allowNewAnswers;

  Future<void> set(String field, dynamic value) => _db.collection("circolari").doc(id).update({ "settings.$field": value });

  static Stream<CircolareSettings> of(Circolare circolare) async* {
    await for (final DocumentSnapshot snapshot in _db.collection("circolari").doc(circolare.id).snapshots())
      yield CircolareSettings.fromFirestore(snapshot);
  }

  static CircolareSettings fromFirestore(DocumentSnapshot document) =>
    CircolareSettings._(
      id: document.id,
      allowNewAnswers: (document.data()["settings"] ?? CircolareSettings._default)["allowNewAnswers"],
    );

  static Map<String, dynamic> _default = {
    "allowNewAnswers": true,
  };
}