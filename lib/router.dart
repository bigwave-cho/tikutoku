import 'package:go_router/go_router.dart';
import 'package:tiktok/features/authentication/email_screen.dart';
import 'package:tiktok/features/authentication/login_screen.dart';
import 'package:tiktok/features/authentication/sign_up_screen.dart';
import 'package:tiktok/features/authentication/username_screen.dart';
import 'package:tiktok/features/users/user_profile_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: SignUpScreen.routeName,
      builder: ((context, state) => const SignUpScreen()),
    ),
    GoRoute(
      path: LoginScreen.routeName,
      builder: ((context, state) => const LoginScreen()),
    ),
    GoRoute(
      path: UsernameScreen.routeName,
      builder: ((context, state) => const UsernameScreen()),
    ),
    GoRoute(
      path: EmailScreen.routeName,
      builder: ((context, state) {
        // obj라 프로퍼티에 쉽게 접근할 수 있도록 assertion
        final args = state.extra as EmailScreenArgs;

        return EmailScreen(username: args.username);
      }),
    ),
    GoRoute(
      path: '/users/:username',
      builder: (context, state) {
        final username = state.params['username'];

        //쿼리 가져오는 방법
        final tab = state.queryParams['show'];
        return UserProfileScreen(
          username: '$username',
          tab: tab!,
        );
      },
    ),
  ],
);
