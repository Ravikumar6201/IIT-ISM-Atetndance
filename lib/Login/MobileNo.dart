import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MObileNo extends StatefulWidget {
  String mobileno,mobilenew;
  @override
  MObileNo({required this.mobileno, required this.mobilenew});

  @override
  State<MObileNo> createState() => _MObileNoState();
}

class _MObileNoState extends State<MObileNo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MObile No."),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Current Number Is -> " + widget.mobileno),
            Text("Enter Number Is -> " + widget.mobilenew),
          ],
        ),
      ),
    );
  }
}
