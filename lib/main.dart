import 'package:flutter/material.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/authentication/sign_up_screen.dart';
//# 프로젝트 구조를 스크린별로가 아닌 기능 별로 나누고
// 그 아래에 스크린과 공용 위젯으로 분리

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
        //모든 scaffold 배경 디폴트 정하기
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFFE9435A),
        // appbar 전역 설정
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // SignUpScreen()넣기 전에 Scaffold 없이 Padding위젯부터 시작했는데
      // 이 때 빨간 텍스트에 노란 밑줄로 표시가 되고 이는 이 위젯이
      // Scaffold 내에 위치하지 않음을 의미
      home: const SignUpScreen(),
    );
  }
}
