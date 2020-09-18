import 'package:circolari_online/models/Circolare.dart';
import 'package:circolari_online/widget/CircolareField.dart';
import 'package:circolari_online/widget/CircolarePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Circolare> _circolari = [
    Circolare(
      title: "CIRCOLARE",
      fields: [
        CircolareField<String>(
          label: "STRING",
          constraints: CircolareFieldConstraints(
            minLength: 1,
            maxLength: 10,
          ),
          isRequired: true,
        ),
        CircolareField<int>(
          label: "INTEGER",
          constraints: CircolareFieldConstraints(
            min: 15,
            max: 100,
          ),
          defaultValue: 42,
        ),
        CircolareField<bool>(
          label: "BOOL",
          defaultValue: true,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Circolari Online",
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Circolari Online"),
        ),
        body: ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemCount: _circolari.length,
          itemBuilder: (context, index) {
            final Circolare circolare = _circolari[index];

            return ListTile(
              title: Text(circolare.title),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CircolarePage(circolare)
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: "Crea nuova circolare",
          onPressed: () {
            // TODO
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}