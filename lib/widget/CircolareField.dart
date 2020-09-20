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
    if (!<Type>[ String, int, double, bool ].contains(T))
      throw ArgumentError("Only String, int, double and bool are supported types");
  }

  @override
  Widget build(BuildContext context) {
    if (T == bool)
    {
      bool value = defaultValue ?? false;

      return StatefulBuilder(
        key: ValueKey(this),
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
      key: ValueKey(this),
      initialValue: defaultValue?.toString(),
      keyboardType: [ int, double ].contains(T) ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: (value) {
        String error;

        if (value.isEmpty && !isRequired) return error;

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
            case int:
            case double:
              final double number = double.tryParse(value);

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

  final double min;
  final double max;

  CircolareFieldConstraints({
    this.regex,
    this.minLength,
    this.maxLength,
    this.min,
    this.max,
  });
}