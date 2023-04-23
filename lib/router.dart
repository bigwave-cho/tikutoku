import 'package:go_router/go_router.dart';
import 'package:tiktok/features/authentication/email_screen.dart';
import 'package:tiktok/features/authentication/sign_up_screen.dart';
import 'package:tiktok/features/authentication/username_screen.dart';
import 'package:tiktok/features/users/user_profile_screen.dart';

/*
## Nested Route
 /signup
 /signup/username
 /signup/username/email/...

### nested 안하면 위처럼 url을 계속 늘려가줘야 했음..
 */

final router = GoRouter(
  routes: [
    GoRoute(
      name: SignUpScreen.routeName,
      path: SignUpScreen.routeURL,
      builder: ((context, state) => const SignUpScreen()),
      routes: [
        GoRoute(
          // SignUp이 "/" ->  '/username' 에 해당
          name: UsernameScreen.routeName,
          path: UsernameScreen.routeURL,
          builder: (context, state) => const UsernameScreen(),
          routes: [
            GoRoute(
              name: EmailScreen.routeName,
              path: EmailScreen.routeURL,
              builder: ((context, state) {
                final args = state.extra as EmailScreenArgs;
                return EmailScreen(username: args.username);
              }),
            ),
          ],
        ),
      ],
    ),
    // GoRoute(
    //   path: LoginScreen.routeName,
    //   builder: ((context, state) => const LoginScreen()),
    // ),
    // GoRoute(
    //   //이름 설정을 해주면
    //   //context.pushName("username_screen") <- 작동함
    //   name: "username_screen",
    //   path: UsernameScreen.routeName,
    //   // GoRoute transition 적용
    //   pageBuilder: (context, state) {
    //     return CustomTransitionPage(
    //       child: const UsernameScreen(),
    //       transitionsBuilder: ((context, animation, secondaryAnimation, child) {
    //         return FadeTransition(
    //           opacity: animation,
    //           child: ScaleTransition(
    //             scale: animation,
    //             child: child,
    //           ),
    //         );
    //       }),
    //     );
    //   },
    // ),
    // GoRoute(
    //   path: EmailScreen.routeName,
    //   builder: ((context, state) {
    //     // obj라 프로퍼티에 쉽게 접근할 수 있도록 assertion
    //     final args = state.extra as EmailScreenArgs;

    //     return EmailScreen(username: args.username);
    //   }),
    // ),
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
