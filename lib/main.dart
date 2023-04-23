import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/authentication/email_screen.dart';
import 'package:tiktok/features/authentication/login_screen.dart';
import 'package:tiktok/features/authentication/sign_up_screen.dart';
import 'package:tiktok/features/authentication/username_screen.dart';
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

// ## flex_color_scheme
// theme 적용 한방에 끝내주는 패키지
//https://pub.dev/packages/flex_color_scheme
//https://rydmike.com/flexcolorscheme/themesplayground-v7/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TikTok',
      //themeMode : flutter에게 light/dark 사용 알려줌
      themeMode: ThemeMode.system, // system: 시스템설정 따라가기

      theme: ThemeData(
          //Materail2에서 3적용하는 방법
          useMaterial3: true,
          textTheme: Typography.blackMountainView,
          //A Material Design text theme with dark glyphs based on San Francisco.
          // Typography는 font와 color만을 제공하지 size나 기타 속성들은 건드리지 않음
          brightness: Brightness.light,

          // 머터리얼 클릭이벤트 시 나오는 물결 이벤트 색 투명하게해서 안보이게!
          splashColor: Colors.transparent,
          // 길게 누를때 나오는 컬러
          highlightColor: Colors.transparent,
          //모든 scaffold 배경 디폴트 정하기
          scaffoldBackgroundColor: Colors.white,

          //일관성을 원한다면 한번에 적용
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.grey.shade50,
          ),
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
            surfaceTintColor: Colors.white,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: Sizes.size16 + Sizes.size2,
              fontWeight: FontWeight.w600,
            ),
          ),
          tabBarTheme: TabBarTheme(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey.shade500,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          listTileTheme: const ListTileThemeData(
            iconColor: Colors.black,
          )),
      //dark일 때 설정
      darkTheme: ThemeData(
        useMaterial3: true,
        tabBarTheme: const TabBarTheme(
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xffe9435a),
        ),

        //전역 주고
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey.shade900,
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
          surfaceTintColor: Colors.grey.shade900,
          backgroundColor: Colors.grey.shade900,
        ),
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFFE9435A),
        brightness: Brightness.dark,
        textTheme: Typography.whiteMountainView,
      ),
      // home: const SignUpScreen(), //로그인 생략위해 잠시 바꿈.

      // pushNamed  -> routes 기능 사용해보기!(최신 기능)
      initialRoute: SignUpScreen.routeName,
      routes: {
        // path를 아래처럼 각 클래스에 static으로 선언해서 사용하면 오타 실수 방지 가능
        SignUpScreen.routeName: ((context) => const SignUpScreen()),
        UsernameScreen.routeName: (context) => const UsernameScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        EmailScreen.routeName: ((context) => const EmailScreen()),
      },
    );
  }
}
