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
          body: ListView.builder(
            itemCount: widget.circolare.fields.length,
            itemBuilder: (context, index) => widget.circolare.fields[index].toWidget(),
          ),
        ),
      ),
    );
  }
}