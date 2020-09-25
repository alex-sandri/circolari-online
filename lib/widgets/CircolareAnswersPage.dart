import 'package:circolari_online/models/Circolare.dart';
import 'package:circolari_online/models/CircolareAnswer.dart';
import 'package:circolari_online/models/CircolareSettings.dart';
import 'package:circolari_online/widgets/CircolareAnswerPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CircolareAnswersPage extends StatelessWidget {
  final Circolare circolare;

  CircolareAnswersPage(this.circolare);

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: DefaultTabController(
        length: 2,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Scaffold(
            appBar: AppBar(
              title: Text(circolare.title),
              actions: [
                IconButton(
                  icon: Icon(Icons.share),
                  tooltip: "Condividi",
                  onPressed: () {
                    showDialog(
                      context: context,
                      child: Dialog(
                        backgroundColor: Colors.white,
                        child: QrImage(
                          data: circolare.toString(),
                          version: QrVersions.auto,
                        ),
                      ),
                    );
                  },
                ),
              ],
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.question_answer), text: "Risposte"),
                  Tab(icon: Icon(Icons.settings), text: "Impostazioni"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _db.collection("circolari/${circolare.id}/answers").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return LinearProgressIndicator();

                    if (snapshot.data.docs.isEmpty)
                      return Center(
                        child: Text("Non sono presenti risposte"),
                      );

                    return ListView.separated(
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: snapshot.data.size,
                      itemBuilder: (context, index) {
                        final CircolareAnswer answer = CircolareAnswer.fromFirestore(snapshot.data.docs[index]);

                        return ListTile(
                          leading: (answer.metadata["handled"] ?? false)
                            ? Icon(Icons.check)
                            : null,
                          title: Text(snapshot.data.docs[index].id),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CircolareAnswerPage(answer),
                            ),
                          ),
                        );
                      },
                    );
                  }
                ),
                CircolareSettingsWidget(circolare),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CircolareSettingsWidget extends StatelessWidget {
  final Circolare circolare;

  CircolareSettingsWidget(this.circolare);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CircolareSettings>(
      stream: CircolareSettings.of(circolare).asBroadcastStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        return Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SwitchListTile(
                    title: Text("Accetta nuove risposte"),
                    value: snapshot.data.allowNewAnswers,
                    onChanged: (allow) => snapshot.data.allowNewAnswers = allow,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              child: FlatButton.icon(
                icon: Icon(Icons.delete),
                label: Text("Elimina"),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.all(16),
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                onPressed: () => circolare.delete(),
              ),
            ),
          ],
        );
      },
    );
  }
}