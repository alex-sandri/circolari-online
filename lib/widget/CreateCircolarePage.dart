import 'package:circolari_online/widget/CircolareField.dart';
import 'package:flutter/material.dart';

class CreateCircolarePage extends StatefulWidget {
  @override
  _CreateCircolarePageState createState() => _CreateCircolarePageState();
}

class _CreateCircolarePageState extends State<CreateCircolarePage> {
  final List<CircolareField> _fields = [];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Crea nuova circolare"),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                tooltip: "Aggiungi campo",
                onPressed: () {
                  String _type;

                  showDialog(
                    context: context,
                    builder: (context) => StatefulBuilder(
                      builder: (context, setState) => Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButton<String>(
                                hint: Text("Tipo"),
                                value: _type,
                                isExpanded: true,
                                items: [
                                  DropdownMenuItem(child: Text("Testo"), value: "string"),
                                  DropdownMenuItem(child: Text("Numero"), value: "double"),
                                  DropdownMenuItem(child: Text("Numero intero"), value: "int"),
                                  DropdownMenuItem(child: Text("Checkbox"), value: "bool"),
                                ],
                                onChanged: (type) => setState(() => _type = type),
                              ),
                              
                              if (_type != null)
                                Container(
                                  width: double.infinity,
                                  child: FlatButton(
                                    child: Text("Aggiungi"),
                                    padding: const EdgeInsets.all(16),
                                    color: Theme.of(context).accentColor,
                                    colorBrightness: Theme.of(context).accentColorBrightness,
                                    onPressed: () {
                                      setState(() {
                                        switch (_type)
                                        {
                                          case "string":
                                            _fields.add(CircolareField<String>(
                                              label: "TODO",
                                            ));
                                            break;
                                          case "doouble":
                                            _fields.add(CircolareField<double>(
                                              label: "TODO",
                                            ));
                                            break;
                                          case "int":
                                            _fields.add(CircolareField<int>(
                                              label: "TODO",
                                            ));
                                            break;
                                          case "bool":
                                            _fields.add(CircolareField<bool>(
                                              label: "TODO",
                                            ));
                                            break;
                                        }
                                      });

                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    // TODO
                  },
                  children: _fields,
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
        ),
      ),
    );
  }
}