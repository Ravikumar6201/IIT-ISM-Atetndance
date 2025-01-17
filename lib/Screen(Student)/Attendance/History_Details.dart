// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:ism/Class/Colorconstat.dart';

class History_Screen extends StatefulWidget {
  const History_Screen({super.key});

  @override
  State<History_Screen> createState() => _History_ScreenState();
}

class _History_ScreenState extends State<History_Screen> {
  String classname = "CS001";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "($classname)",
          style: TextStyle(color: ColorConstant.whiteA700),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: ColorConstant.whiteA700,
          ),
        ),
        backgroundColor: ColorConstant.lightBlue701,
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            title: const Text('Status : '),
            subtitle: const Text('Date : %'),
            trailing: IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {},
            ),
          );
        },
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  final String history;

  const HistoryScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Center(
        child: Text(history),
      ),
    );
  }
}
