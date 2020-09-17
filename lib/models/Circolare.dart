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

  T _value;

  T get value => _value;

  CircolareField({
    @required this.label,
    this.constraints,
    this.defaultValue,
  })
  {
    if (!<Type>[ String, num, int, double, bool ].contains(T))
      throw ArgumentError("Only String, num, int, double and bool are supported types");

    _value = defaultValue;
  }

  Widget toWidget() {
    if (T == bool)
      return StatefulBuilder(
        builder: (context, StateSetter setState) {
          return CheckboxListTile(
            title: Text(label),
            value: _value as bool ?? false,
            onChanged: (checked) =>
              setState(() => _value = checked as T),
          );
        }
      );

    return TextField(
      controller: TextEditingController()..text = defaultValue?.toString(),
      keyboardType: [ num, int, double ].contains(T) ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
      ),
      onChanged: (value) {
        _value = value as T;

        if (constraints == null) return;

        String error;

        switch (T)
        {
          case String:

            if (value.length < constraints.minLength)
              error = "MIN_LENGTH";
            else if (value.length > constraints.maxLength)
              error = "MAX_LENGTH";

            break;
          case num:
          case int:
          case double:
            final num number = num.tryParse(value);

            if (number == null)
              error = "INVALID_NUM";
            else if (T == int && number.toInt() != number)
              error = "NUM_NO_INT";
            else if (number < constraints.min)
              error = "MIN_NUM";
            else if (number > constraints.max)
              error = "MAX_NUM";

            break;
        }

        print(error);
      },
    );
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