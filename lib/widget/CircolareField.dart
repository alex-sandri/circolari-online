import 'package:flutter/material.dart';

class CircolareField<T> extends StatelessWidget {
  final String label;

  final bool isRequired;

  final CircolareFieldConstraints constraints;

  final T defaultValue;

  CircolareField({
    @required this.label,
    this.isRequired = false,
    this.constraints,
    this.defaultValue,
  })
  {
    if (!<Type>[ String, num, int, double, bool ].contains(T))
      throw ArgumentError("Only String, num, int, double and bool are supported types");
  }

  @override
  Widget build(BuildContext context) {
    if (T == bool)
    {
      bool value = defaultValue ?? false;

      return StatefulBuilder(
        builder: (context, setState) {
          return CheckboxListTile(
            title: Text(label),
            value: value,
            onChanged: (checked) =>
              setState(() => value = checked),
          );
        },
      );
    }

    return TextFormField(
      initialValue: defaultValue?.toString(),
      keyboardType: [ num, int, double ].contains(T) ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: (value) {
        String error;

        if (constraints == null) return error;

        if (!(constraints.regex?.hasMatch(value) ?? true))
          error = "Il valore inserito non rispetta il formato previsto";
        else
          switch (T)
          {
            case String:

              if (value.length < constraints.minLength)
                error = "Il testo deve avere almeno ${constraints.minLength} caratteri";
              else if (value.length > constraints.maxLength)
                error = "Il testo non deve superare i ${constraints.maxLength} caratteri";

              break;
            case num:
            case int:
            case double:
              final num number = num.tryParse(value);

              if (number == null)
                error = "Il numero non è valido";
              else if (T == int && number.toInt() != number)
                error = "Il numero deve essere intero";
              else if (number < constraints.min)
                error = "Il numero deve essere superiore o uguale a ${constraints.min}";
              else if (number > constraints.max)
                error = "Il numero deve essere inferiore o uguale a ${constraints.max}";

              break;
          }

        return error;
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