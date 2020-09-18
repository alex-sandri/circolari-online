import 'package:flutter/material.dart';

class CircolareField<T> extends StatefulWidget
{
  final String label;

  final CircolareFieldConstraints constraints;

  final T defaultValue;

  final TextEditingController controller = TextEditingController();

  CircolareField({
    @required this.label,
    this.constraints,
    this.defaultValue,
  })
  {
    if (!<Type>[ String, num, int, double, bool ].contains(T))
      throw ArgumentError("Only String, num, int, double and bool are supported types");

    controller.text = defaultValue?.toString();
  }

  @override
  _CircolareFieldState<T> createState() => _CircolareFieldState<T>();
}

class _CircolareFieldState<T> extends State<CircolareField<T>> {
  T _value;

  String _error;

  @override
  Widget build(BuildContext context) {
    _value ??= widget.defaultValue;

    if (T == bool)
      return CheckboxListTile(
        title: Text(widget.label),
        value: _value as bool ?? false,
        onChanged: (checked) =>
          setState(() => _value = checked as T),
      );

    return TextField(
      controller: widget.controller,
      keyboardType: [ num, int, double ].contains(T) ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: widget.label,
        errorText: _error,
      ),
      onChanged: (value) {
        _error = null;

        _value = value is T ? value as T : null;

        if (widget.constraints == null) return;

        if (!(widget.constraints.regex?.hasMatch(value) ?? true))
          _error = "REGEX_NO_MATCH";
        else
          switch (T)
          {
            case String:

              if (value.length < widget.constraints.minLength)
                _error = "Il testo deve avere almeno ${widget.constraints.minLength} caratteri";
              else if (value.length > widget.constraints.maxLength)
                _error = "Il testo non deve superare i ${widget.constraints.maxLength} caratteri";

              break;
            case num:
            case int:
            case double:
              final num number = num.tryParse(value);

              if (number == null)
                _error = "Il numero non è valido";
              else if (T == int && number.toInt() != number)
                _error = "Il numero deve essere intero";
              else if (number < widget.constraints.min)
                _error = "Il numero deve essere superiore o uguale a ${widget.constraints.min}";
              else if (number > widget.constraints.max)
                _error = "Il numero deve essere inferiore o uguale a ${widget.constraints.max}";

              break;
          }

          setState(() {});
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