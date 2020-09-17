import 'package:circolari_online/models/Circolare.dart';
import 'package:flutter/material.dart';

class CircolarePage extends StatefulWidget {
  final Circolare circolare;

  CircolarePage(this.circolare);

  @override
  _CircolarePageState createState() => _CircolarePageState();
}

class _CircolarePageState extends State<CircolarePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.circolare.title),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: widget.circolare.fields.length,
                  itemBuilder: (context, index) => widget.circolare.fields[index].toWidget(),
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