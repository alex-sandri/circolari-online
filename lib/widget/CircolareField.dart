import 'package:flutter/material.dart';

class CircolareField<T> extends StatefulWidget
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

  @override
  _CircolareFieldState<T> createState() => _CircolareFieldState<T>();
}

class _CircolareFieldState<T> extends State<CircolareField<T>> {
  T _value;

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
      controller: TextEditingController()..text = widget.defaultValue?.toString(),
      keyboardType: [ num, int, double ].contains(T) ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: widget.label,
      ),
      onChanged: (value) {
        _value = value is T ? value as T : null;

        if (widget.constraints == null) return;

        String error;

        if (!(widget.constraints.regex?.hasMatch(value) ?? true))
          error = "REGEX_NO_MATCH";
        else
          switch (T)
          {
            case String:

              if (value.length < widget.constraints.minLength)
                error = "MIN_LENGTH";
              else if (value.length > widget.constraints.maxLength)
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
              else if (number < widget.constraints.min)
                error = "MIN_NUM";
              else if (number > widget.constraints.max)
                error = "MAX_NUM";

              break;
          }
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