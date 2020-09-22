import 'package:barcode_scan/barcode_scan.dart';
import 'package:circolari_online/models/Circolare.dart';
import 'package:circolari_online/widgets/CircolareAnswersPage.dart';
import 'package:circolari_online/widgets/CreateCircolarePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Circolari Online",
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Circolari Online"),
          actions: [
            IconButton(
              icon: Icon(Icons.qr_code),
              tooltip: "Compila circolare",
              onPressed: () async {
                final ScanResult result = await BarcodeScanner.scan(
                  options: ScanOptions(
                    restrictFormat: [ BarcodeFormat.qr ],
                  ),
                );

                if (result.type == ResultType.Barcode)
                {
                  print(result.rawContent);
                }
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: db.collection("circolari").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();

            if (snapshot.data.docs.isEmpty)
              return Center(
                child: Text("Non sono presenti circolari"),
              );

            return ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: snapshot.data.size,
              itemBuilder: (context, index) {
                final Circolare circolare = Circolare.fromFirestore(snapshot.data.docs[index]);

                return ListTile(
                  title: Text(circolare.title),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CircolareAnswersPage(circolare)
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("it", "IT"),
      ],
    );
  }
}