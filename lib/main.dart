import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiktok/common/widgets/dark_mode_config/dark_mode_repo.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/notifications/notifications_provider.dart';
import 'package:tiktok/features/videos/repos/video_playback_config_repo.dart';
import 'package:tiktok/features/videos/view_models/playback_config_vm.dart';
import 'package:tiktok/firebase_options.dart';
import 'package:tiktok/router.dart';
//# 프로젝트 구조를 스크린별로가 아닌 기능 별로 나누고
// 그 아래에 스크린과 공용 위젯으로 분리

void main() async {
  // 프레임워크와 플러터엔진을 연결(runApp)하기 전에 모든 것들을 초기화..
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

  //SharedPreferences의 인스턴스를 불러와서 레포 생성
  final preferences = await SharedPreferences.getInstance();
  final repository = VideoPlaybackConfigRepository(preferences);
  final darkRepository = DarkModeRepository(preferences);

  // TikTokApp을 멀티프로바이더로 감싸고 repository를 뷰모델에 전달
  // -> 디스크에 있는 데이터로 뷰모델이 초기화된다.
  runApp(
    ProviderScope(
      // SharePrefereces 작동을 기다리고 만들어진 repository를 전달해서 덮어씌움.(overrides)
      overrides: [
        playbackConfigProivder.overrideWith(
          () => PlaybackConfigViewModel(repository),
        ),
      ],
      child: const TikTokApp(),
    ),
  );
}

class TikTokApp extends ConsumerWidget {
  const TikTokApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationsProvider);

    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
      title: 'TikTok',
      themeMode: false ? ThemeMode.dark : ThemeMode.light, // system: 시스템설정 따라가기
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
    );
  }
}

/*
# image picker https://pub.dev/packages/image_picker/install
ios라면 NSPhotoLibraryUsageDescription
NSCameraUsageDescription
NSMicrophoneUsageDescription 을 plist에 기입해야한다.

하지만 camera와 gallery saver 설치하면서 넣어뒀음.

안드는 ㄱㅊ
 */