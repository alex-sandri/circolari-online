import 'package:circolari_online/widget/CircolareField.dart';
import 'package:flutter/material.dart';

class Circolare
{
  final String title;

  final List<CircolareField> fields;

  Circolare({
    @required this.title,
    @required this.fields,
  });
}