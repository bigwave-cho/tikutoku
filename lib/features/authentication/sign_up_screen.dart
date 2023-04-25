import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/authentication/login_screen.dart';
import 'package:tiktok/features/authentication/username_screen.dart';
import 'package:tiktok/features/authentication/widgets/auth_button.dart';
import 'package:tiktok/utils.dart';
import 'package:go_router/go_router.dart';

// font_awesome_flutter : 설치

class SignUpScreen extends StatelessWidget {
  static const String routeURL = "/";
  static const routeName = "signup";

  const SignUpScreen({super.key});

  void _onLoginTap(BuildContext context) async {
    context.pushNamed(LoginScreen.routeName);

    /*
    push & go
    push : 간단히 웹에 히스토리 쌓듯이 stack을 쌓는 개념 (pop() 가능)
    go : <a> 태그로 이동하는.. 히스토리 없이  (pop 불가)
     */
  }

  void _onEmailTap(BuildContext context) async {
    // final result = await Navigator.of(context).push(
    //   PageRouteBuilder(
    //     pageBuilder: ((context, animation, secondaryAnimation) {
    //       return const UsernameScreen();
    //     }),
    //     //child는 pageBuilder가 리턴하는 것
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       final offsetAnimation = Tween(
    //         begin: const Offset(0, -1),
    //         end: const Offset(0, 0),
    //       ).animate(animation);

    //       final opacityAnimation = Tween(
    //         begin: 0.5,
    //         end: 1.0,
    //       ).animate(animation);

    //       return SlideTransition(
    //         //보통 Animation<double>이지만 이경우는 offset을 원해서
    //         //위에 변수하나 만들어줌.
    //         position: offsetAnimation,
    //         child: ScaleTransition(
    //           scale: animation,
    //           // 어디서부터 스케일트랜지션 시작할지
    //           // alignment: Alignment.bottomRight,
    //           child: FadeTransition(
    //             opacity: opacityAnimation,
    //             child: child,
    //           ),
    //         ),
    //       );
    //     },
    //     //push할 때 애니메이션
    //     transitionDuration: const Duration(seconds: 1),

    //     //다시 돌아올 때 애니메이션
    //     reverseTransitionDuration: const Duration(
    //       seconds: 1,
    //     ),
    //   ),
    // );
    // print(result); //로그인화면에서 pop에 넣어둔 것이 전달.
    // // 아무것도 없으면 null
    //임시로 밑의 path로 가도록 설정.

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => const UsernameScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //OrientationBuilder : 폰 방향 감지
    return OrientationBuilder(
      builder: (context, orientation) {
        // 랜드스케이프 방지 방법 1.
        if (orientation == Orientation.landscape) {
          return const Scaffold(
            body: Center(child: Text("plz rotate your phone.")),
          );
        }

        debugPrint("$orientation");
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(
                Sizes.size14,
              ),
              child: Column(
                children: [
                  Gaps.v80,
                  const Text(
                    "Sign up for TikTok",
                    // 직접 구글폰트 적용하기
                    style: TextStyle(
                      fontSize: Sizes.size24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gaps.v8,
                  const Opacity(
                    //방법2: 오파시티로 흰색이든 검정이든 흐릿하게 보이도록.
                    opacity: 0.7,
                    child: Text(
                      "Create a profile, follow other accounts, make your own videos, and more.",
                      style: TextStyle(
                        fontSize: Sizes.size16,
                        // 다크모드를 염두에 두고 해야하는 이유... 하드코딩 되버림
                        //방법1. 아래처럼 함수를 이용해서.
                        // color: isDarkMode(context)
                        //     ? Colors.grey.shade300
                        //     : Colors.black45,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gaps.v40,
                  // collection if를 사용해서 하나가 아닌 여러개에 적용하기
                  // [] 리스트로 감싸고 "..." 전개해주면 됨.
                  if (orientation == Orientation.portrait) ...[
                    GestureDetector(
                      onTap: () => _onEmailTap(context),
                      child: const AuthButton(
                        icon: FaIcon(FontAwesomeIcons.user),
                        text: 'Use email & password',
                      ),
                    ),
                    Gaps.v16,
                    GestureDetector(
                      // onTap: () => _onEmailTap(context),
                      child: const AuthButton(
                        icon: FaIcon(FontAwesomeIcons.apple),
                        text: 'Continue with Apple',
                      ),
                    ),
                  ],
                  if (orientation == Orientation.landscape)
                    Row(
                      //현재 Row로 감쌌는데 자식 위젯들이
                      // FractionallySizedBox라 제한되지 않은 부모 때문에
                      // 에러를 뿜음
                      /// 해결 : Expanded
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _onEmailTap(context),
                            child: const AuthButton(
                              icon: FaIcon(FontAwesomeIcons.user),
                              text: 'Use phone or email',
                            ),
                          ),
                        ),
                        Gaps.h16,
                        Expanded(
                          child: GestureDetector(
                            // onTap: () => _onEmailTap(context),
                            child: const AuthButton(
                              icon: FaIcon(FontAwesomeIcons.apple),
                              text: 'Continue with Apple',
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            //방법3: null줘서 전역 띰을 받는 방법도..
            color: isDarkMode(context) ? null : Colors.grey.shade50,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Sizes.size32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  Gaps.h5,
                  GestureDetector(
                    onTap: () => _onLoginTap(context),
                    child: Text(
                      'Log in',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
