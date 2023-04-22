import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiktok/constants/sizes.dart';
//# 프로젝트 구조를 스크린별로가 아닌 기능 별로 나누고
// 그 아래에 스크린과 공용 위젯으로 분리

void main() async {
  // 프레임워크와 플러터엔진을 연결(runApp)하기 전에 모든 것들을 초기화..
  WidgetsFlutterBinding.ensureInitialized();

  // 방법2: 아예 고정시켜버리기.
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  //여기서 호출하면 앱 전체에 적용되고
  //또는 스크린마다 적용도 할 수 있다.
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark, //폰 시스템(상태창 ui 흰색 검은색)
  );

  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      home: const LayoutBuilderCodeLab(), //로그인 생략위해 잠시 바꿈.
    );
  }
}

class LayoutBuilderCodeLab extends StatelessWidget {
  const LayoutBuilderCodeLab({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // LayoutBuilder는 부모요소의 너비와 높이를 받아
      // constraints로 제공.
      // Scaffold의 body가 화면 전체를 먹고있으니 미디어쿼리 값과 같아짐
      // 만약 레이아웃빌더를 다른 제한된 박스로 감싸면
      // 해당 박스의 너비와 높이를 받겠지.
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          // width: size.width,
          // height: size.height,
          color: Colors.teal,
          child: Center(
              child: Text(
            "미디어쿼리:${size.width},constraints: ${constraints.maxWidth}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 98,
            ),
          )),
        ),
      ),
    );
  }
}
