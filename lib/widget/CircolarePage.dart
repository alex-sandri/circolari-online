import 'package:circolari_online/models/Circolare.dart';
import 'package:flutter/material.dart';

class CircolarePage extends StatelessWidget {
  final Circolare circolare;

  CircolarePage(this.circolare);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            title: Text(circolare.title),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: circolare.fields.length,
                  itemBuilder: (context, index) => circolare.fields[index],
                ),
              ),
              Container(
                width: double.infinity,
                child: FlatButton(
                  child: Text("Invia"),
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