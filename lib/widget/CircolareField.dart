import 'package:flutter/material.dart';

class CircolareField extends StatelessWidget {
  final String type;

  final String label;

  final bool isRequired;

  final CircolareFieldConstraints constraints;

  final dynamic defaultValue;

  CircolareField({
    @required this.type,
    @required this.label,
    this.isRequired = false,
    this.constraints,
    this.defaultValue,
  }): assert([ "string", "int", "double", "bool" ].contains(type)),
      assert([ "null", type].contains(defaultValue.runtimeType.toString().toLowerCase()));

  dynamic _value;

  dynamic get value => _value;

  @override
  Widget build(BuildContext context) {
    _value = defaultValue;

    if (type == "bool")
    {
      bool value = defaultValue ?? false;

      return StatefulBuilder(
        builder: (context, setState) {
          return CheckboxListTile(
            title: Text(label),
            value: value,
            onChanged: (checked) {
              _value = checked;

              setState(() => value = checked);
            },
          );
        },
      );
    }

    return TextFormField(
      initialValue: defaultValue?.toString(),
      keyboardType: [ "int", "double" ].contains(type) ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
      ),
      onChanged: (value) => _value = value,
      validator: (value) {
        String error;

        if (value.isEmpty && !isRequired) return error;

        if (value.isEmpty && isRequired) return "Questo campo è obbligatorio";

        switch (type)
        {
          case "string":

            if (constraints != null)
            {
              if (value.length < constraints?.minLength)
                error = "Il testo deve avere almeno ${constraints.minLength} caratteri";
              else if (value.length > constraints.maxLength)
                error = "Il testo non deve superare i ${constraints.maxLength} caratteri";
            }

            break;
          case "int":
          case "double":
            final num number = num.tryParse(value);

            if (number == null)
              error = "Il numero non è valido";
            else if (type == "int" && number.toInt() != number)
              error = "Il numero deve essere intero";

            if (constraints != null)
            {
              if (number < constraints.min)
                error = "Il numero deve essere superiore o uguale a ${constraints.min}";
              else if (number > constraints.max)
                error = "Il numero deve essere inferiore o uguale a ${constraints.max}";
            }

            break;
        }

        if (!(constraints?.regex?.hasMatch(value) ?? true))
          error = "Il valore inserito non rispetta il formato previsto";

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