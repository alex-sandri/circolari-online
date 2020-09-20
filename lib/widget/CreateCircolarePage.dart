import 'package:circolari_online/widget/CircolareField.dart';
import 'package:flutter/material.dart';

class CreateCircolarePage extends StatefulWidget {
  @override
  _CreateCircolarePageState createState() => _CreateCircolarePageState();
}

class _CreateCircolarePageState extends State<CreateCircolarePage> {
  final List<CircolareField> _fields = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

                  String _stringDefaultValue;
                  double _doubleDefaultValue;
                  int _intDefaultValue;
                  bool _checkboxDefaultValue = false;

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
                                onChanged: (value) => setState(() => _label = value),
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
                                  onChanged: (value) => setState(() => _stringDefaultValue = value),
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

                                    setState(() => _doubleDefaultValue = parsedValue);
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

                                    setState(() => _intDefaultValue = parsedValue);
                                  },
                                ),

                              if (_type == "bool")
                                CheckboxListTile(
                                  title: Text("Valore predefinito"),
                                  value: _checkboxDefaultValue,
                                  onChanged: (checked) =>
                                    setState(() => _checkboxDefaultValue = checked),
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
                                        switch (_type)
                                        {
                                          case "string":
                                            _fields.add(CircolareField<String>(
                                              label: _label,
                                              defaultValue: _stringDefaultValue,
                                              isRequired: _isRequired,
                                            ));
                                            break;
                                          case "double":
                                            _fields.add(CircolareField<double>(
                                              label: _label,
                                              defaultValue: _doubleDefaultValue,
                                              isRequired: _isRequired,
                                            ));
                                            break;
                                          case "int":
                                            _fields.add(CircolareField<int>(
                                              label: _label,
                                              defaultValue: _intDefaultValue,
                                              isRequired: _isRequired,
                                            ));
                                            break;
                                          case "bool":
                                            _fields.add(CircolareField<bool>(
                                              label: _label,
                                              defaultValue: _checkboxDefaultValue,
                                              isRequired: _isRequired,
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
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
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
                    print(_formKey.currentState.validate());
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