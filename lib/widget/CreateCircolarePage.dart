import 'package:circolari_online/widget/CircolareField.dart';
import 'package:flutter/material.dart';

class CreateCircolarePage extends StatelessWidget {
  final List<CircolareField> fields = [];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Crea nuova circolare"),
          ),
          body: Column(
            children: [
              Expanded(
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    // TODO
                  },
                  children: fields,
                ),
              ),
              Container(
                width: double.infinity,
                child: FlatButton(
                  child: Text("Conferma"),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).accentColor,
                  colorBrightness: Theme.of(context).accentColorBrightness,
                  onPressed: () {
                    // TODO
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: "Aggiungi campo",
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton<String>(
                          hint: Text("Tipo"),
                          items: [
                            DropdownMenuItem(child: Text("Testo"), value: "string"),
                            DropdownMenuItem(child: Text("Numero"), value: "num"),
                            DropdownMenuItem(child: Text("Numero intero"), value: "int"),
                            DropdownMenuItem(child: Text("Checkbox"), value: "bool"),
                          ],
                          onChanged: (type) {
                            // TODO
                          }
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}