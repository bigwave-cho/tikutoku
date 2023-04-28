import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok/common/widgets/main_navigation/main_navigation_screen.dart';
import 'package:tiktok/features/authentication/login_screen.dart';
import 'package:tiktok/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok/features/authentication/sign_up_screen.dart';
import 'package:tiktok/features/inbox/activity_screen.dart';
import 'package:tiktok/features/inbox/chat_detail.dart';
import 'package:tiktok/features/inbox/chats_screen.dart';
import 'package:tiktok/features/onboarding/interests_screen.dart';
import 'package:tiktok/features/videos/views/video_recording_screen.dart';

/*
## Nested Route
 /signup
 /signup/username
 /signup/username/email/...

### nested 안하면 위처럼 url을 계속 늘려가줘야 했음..

path를 늘릴 때는 GoRoute 
같은 path에서 스크린 변화만 줄 때는 Navigator
 */

// 로그인 상태에 따라 리다이렉트
// Provider로 감싸줬기 때문에 이제부터 전역에서 사용가능해짐.
final routerProvider = Provider((ref) {
  // 참고: 다른 프로바이더도 접근 가능
  // ex) ref.read(timelineProvider)

  /*
  Provider 내에 다른 provider를 watch하게 되면
  watch 중인 프로바이더의 상태가 변경되면 관찰중인 프로바이더 또한 리빌드 된다.

  아래는 authState에 따라 라우터 프로바이더가 리빌드되어 
  로그인 여부에 따라 리다이렉트가 작동한다.
   */

  // StreamProvider를 watch해서 상태 변화를 감지
  // ref.watch(authState);

  return GoRouter(
    // 임시로 리로드해도 바로 home으로 가게 설정
    initialLocation: "/home",

    redirect: (context, state) {
      final isLoggedIn = ref.read(authRepo).isLoggedIn;

      if (!isLoggedIn) {
        //로그인하지 않고
        if (state.subloc != SignUpScreen.routeURL &&
            state.subloc != LoginScreen.routeURL) {
          // path( /signup) 가 사인업이나 로그인이 아니라면
          // "/" <- signup path
          // 회원가입 스크린으로 리다이렉트 시킨다.
          return SignUpScreen.routeURL;
        }
      }
      return null;
    },

    routes: [
      GoRoute(
        name: SignUpScreen.routeName,
        path: SignUpScreen.routeURL,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        name: LoginScreen.routeName,
        path: LoginScreen.routeURL,
        builder: ((context, state) => const LoginScreen()),
      ),
      GoRoute(
        name: InterestsScreen.routeName,
        path: InterestsScreen.routeURL,
        builder: ((context, state) => const InterestsScreen()),
      ),
      // 아래 지정된 path일 때만 화면 보여줌
      GoRoute(
        name: MainNavigationScreen.routeName,
        path: "/:tab(home|discover|inbox|profile)",
        builder: (context, state) {
          //path에 있는 tab 전달
          final tab = state.params["tab"]!;
          return MainNavigationScreen(tab: tab);
        },
      ),
      GoRoute(
        name: ActivityScreen.routeName,
        path: ActivityScreen.routeURL,
        builder: ((context, state) => const ActivityScreen()),
      ),
      GoRoute(
        name: ChatsScreen.routeName,
        path: ChatsScreen.routeURL,
        builder: ((context, state) => const ChatsScreen()),
        routes: [
          GoRoute(
            name: ChatDetailScreen.routeName,
            path: ChatDetailScreen.routeURL,
            builder: (context, state) {
              final id = state.params["chatId"]!;
              return ChatDetailScreen(
                chatId: id,
              );
            },
          )
        ],
      ),
      GoRoute(
        name: VideoRecordingScreen.routeName,
        path: VideoRecordingScreen.routeURL,
        // GoRoute로 페이지 트랜지션 주기
        pageBuilder: (context, state) => CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 150),
          child: const VideoRecordingScreen(),
          transitionsBuilder: ((context, animation, secondaryAnimation, child) {
            final position = Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation);
            return SlideTransition(
              position: position,
              child: child, // child = VidoeRecordingScreen
            );
          }),
        ),
      ),
    ],
  );
});
