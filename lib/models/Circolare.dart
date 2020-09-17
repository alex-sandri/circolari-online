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

class CircolareField<T>
{
  final String label;

  final CircolareFieldConstraints constraints;

  final T defaultValue;

  CircolareField({
    @required this.label,
    this.constraints,
    this.defaultValue,
  })
  {
    if (!<Type>[ String, num, int, double, bool ].contains(T))
      throw ArgumentError("Only String, num, int, double and bool are supported types");
  }

  Widget toWidget() {
    // TODO
  }
}

class CircolareFieldConstraints
{
  final RegExp regex;

  final int minLength;
  final int maxLength;

  final num min;
  final num max;

  CircolareFieldConstraints({
    this.regex,
    this.minLength,
    this.maxLength,
    this.min,
    this.max,
  });
}