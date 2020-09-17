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
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.circolare.title),
        ),
        body: Container(),
      ),
    );
  }
}