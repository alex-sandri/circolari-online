import 'package:circolari_online/models/CircolareAnswer.dart';
import 'package:flutter/material.dart';

class CircolareAnswerPage extends StatelessWidget {
  final CircolareAnswer answer;

  CircolareAnswerPage(this.answer);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            title: Text(answer.id),
          ),
          body: ListView.builder(
            itemCount: answer.fields.length,
            itemBuilder: (context, index) {
              final MapEntry<String, dynamic> field = answer.fields.entries.elementAt(index);

              return ListTile(
                title: SelectableText(field.key),
                subtitle: SelectableText(
                  field.value.runtimeType == bool
                    ? (field.value ? "Sì" : "No")
                    : field.value.toString(),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}