import 'package:flutter/material.dart';
import 'package:batik_detector/constant/color.dart';
import 'package:batik_detector/ui/Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Batik Detector",
      theme: ThemeData(
        primaryColor: primaryColor,
        fontFamily: "Poppins"
      ),
      home: Home(),
    );
  }
}