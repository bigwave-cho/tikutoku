import 'package:go_router/go_router.dart';
import 'package:tiktok/common/widgets/main_navigation/main_navigation_screen.dart';
import 'package:tiktok/features/authentication/login_screen.dart';
import 'package:tiktok/features/authentication/sign_up_screen.dart';
import 'package:tiktok/features/inbox/activity_screen.dart';
import 'package:tiktok/features/inbox/chat_detail.dart';
import 'package:tiktok/features/inbox/chats_screen.dart';
import 'package:tiktok/features/onboarding/interests_screen.dart';
import 'package:tiktok/features/videos/video_recording_screen.dart';

/*
## Nested Route
 /signup
 /signup/username
 /signup/username/email/...

### nested 안하면 위처럼 url을 계속 늘려가줘야 했음..

path를 늘릴 때는 GoRoute 
같은 path에서 스크린 변화만 줄 때는 Navigator
 */

final router = GoRouter(
  // 임시로 리로드해도 바로 home으로 가게 설정
  initialLocation: "/inbox",
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
      builder: ((context, state) => const VideoRecordingScreen()),
    ),
  ],
);
