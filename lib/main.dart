import 'package:circolari_online/models/Circolare.dart';
import 'package:circolari_online/widget/CircolarePage.dart';
import 'package:circolari_online/widget/CreateCircolarePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());

  await Firebase.initializeApp();
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
        body: StreamBuilder<List<Circolare>>(
          stream: null,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: Text("Non sono presenti circolari"),
              );

            return ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final Circolare circolare = snapshot.data[index];

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
            );
          }
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: "Crea nuova circolare",
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateCircolarePage())),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}