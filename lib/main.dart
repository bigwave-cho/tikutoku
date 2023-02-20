import 'package:flutter/material.dart';

void main() {
  runApp(const TilTokApp());
}

class TilTokApp extends StatelessWidget {
  const TilTokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TikTok',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(),
    );
  }
}
