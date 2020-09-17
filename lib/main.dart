import 'package:circolari_online/models/Circolare.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Circolare> _circolari = [];

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
              // TODO
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