import 'package:circolari_online/models/Circolare.dart';
import 'package:circolari_online/widgets/CircolareField.dart';
import 'package:flutter/material.dart';

class CreateCircolarePage extends StatefulWidget {
  @override
  _CreateCircolarePageState createState() => _CreateCircolarePageState();
}

class _CreateCircolarePageState extends State<CreateCircolarePage> {
  final List<CircolareField> _fields = [];

  final TextEditingController _titleController = TextEditingController();

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
                  String _label = "";
                  bool _isRequired = false;

                  Map<String, dynamic> _defaultValues = {
                    "string": null,
                    "double": null,
                    "int": null,
                    "bool": false,
                  };

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
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Etichetta",
                                ),
                                onChanged: (value) {
                                  if (Circolare.isRestrictedFieldLabel(value))
                                  {
                                    setState(() => _label = "");

                                    return;
                                  }

                                  setState(() => _label = value);
                                },
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (Circolare.isRestrictedFieldLabel(value))
                                    return "Un campo non può avere come etichetta $value";

                                  return null;
                                },
                              ),
                              CheckboxListTile(
                                title: Text("Campo obbligatorio"),
                                value: _isRequired,
                                onChanged: (checked) =>
                                  setState(() => _isRequired = checked),
                              ),

                              if (_type == "string")
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: "Valore predefinito",
                                  ),
                                  onChanged: (value) => setState(() => _defaultValues[_type] = value),
                                ),

                              if (_type == "double")
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Valore predefinito",
                                  ),
                                  onChanged: (value) {
                                    final double parsedValue = double.tryParse(value);

                                    if (parsedValue == null) return;

                                    setState(() => _defaultValues[_type] = parsedValue);
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (double.tryParse(value) == null)
                                      return "Il numero non è valido";

                                    return null;
                                  },
                                ),

                              if (_type == "int")
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Valore predefinito",
                                  ),
                                  onChanged: (value) {
                                    final int parsedValue = int.tryParse(value);

                                    if (parsedValue == null) return;

                                    setState(() => _defaultValues[_type] = parsedValue);
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (int.tryParse(value) == null)
                                      return "Il numero deve essere intero";

                                    return null;
                                  },
                                ),

                              if (_type == "bool")
                                CheckboxListTile(
                                  title: Text("Valore predefinito"),
                                  value: _defaultValues[_type],
                                  onChanged: (checked) =>
                                    setState(() => _defaultValues[_type] = checked),
                                ),
                              
                              if (_type != null && _label.isNotEmpty)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(top: 8),
                                  child: FlatButton(
                                    child: Text("Aggiungi"),
                                    padding: const EdgeInsets.all(16),
                                    color: Theme.of(context).accentColor,
                                    colorBrightness: Theme.of(context).accentColorBrightness,
                                    onPressed: () {
                                      this.setState(() {
                                        _fields.add(CircolareField(
                                          type: _type,
                                          label: _label,
                                          defaultValue: _defaultValues[_type],
                                          isRequired: _isRequired,
                                        ));
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Titolo",
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value.isEmpty ? "Il titolo non può essere vuoto" : null,
                ),
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                    bottom: 8,
                  ),
                  itemCount: _fields.length,
                  itemBuilder: (context, index) {
                    final CircolareField field = _fields[index];

                    return Dismissible(
                      key: ValueKey(field),
                      onDismissed: (direction) => setState(() => _fields.removeAt(index)),
                      background: Container(
                        color: Colors.red,
                        child: Icon(
                          Icons.delete,
                        ),
                      ),
                      child: field,
                    );
                  },
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
                  onPressed: () async {
                    if (_fields.isEmpty)
                      showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Text("Errore"),
                          content: Text("Devi inserire almeno un campo"),
                        ),
                      );

                    if (_fields.isEmpty || _titleController.text.isEmpty) return;

                    await Circolare(
                      title: _titleController.text,
                      fields: _fields,
                    ).create();

                    Navigator.of(context).pop();
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