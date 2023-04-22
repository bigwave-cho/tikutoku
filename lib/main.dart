import 'package:flutter/material.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/inbox/activity_screen.dart';
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
        // 머터리얼 클릭이벤트 시 나오는 물결 이벤트 색 투명하게해서 안보이게!
        splashColor: Colors.transparent,
        // 길게 누를때 나오는 컬러
        highlightColor: Colors.transparent,
        //모든 scaffold 배경 디폴트 정하기
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFFE9435A),
        textSelectionTheme: const TextSelectionThemeData(
          //cursorColor 설정
          cursorColor: Color(0xffe9435a),
          //텍스트 선택시 칼라 설정
          // selectionColor: Color(0xffe9435a),
        ),
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
      home: const ActivityScreen(), //로그인 생략위해 잠시 바꿈.
    );
  }
}
