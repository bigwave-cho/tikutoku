import 'package:flutter/material.dart';
import 'package:tiktok/screens/sign_up/sign_up_screen.dart';

void main() {
  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TikTok',
      theme: ThemeData(
        primaryColor: const Color(0xFFE9435A),
      ),
      // SignUpScreen()넣기 전에 Scaffold 없이 Padding위젯부터 시작했는데
      // 이 때 빨간 텍스트에 노란 밑줄로 표시가 되고 이는 이 위젯이
      // Scaffold 내에 위치하지 않음을 의미
      home: const SignUpScreen(),
    );
  }
}
