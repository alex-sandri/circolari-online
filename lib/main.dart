import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  List<dynamic> _circolari = [];

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
            final dynamic circolare = _circolari[index];

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