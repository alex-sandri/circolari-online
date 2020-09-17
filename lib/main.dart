import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        body: Container(),
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