import 'package:flutter/material.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/authentication/email_screen.dart';
import 'package:tiktok/features/authentication/widgets/form_button.dart';
import 'package:go_router/go_router.dart';

class UsernameScreen extends StatefulWidget {
  static String routeURL = "username";
  static String routeName = "username";
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreen();
}

class _UsernameScreen extends State<UsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  // 내용 유무에 따라 버튼 활성화
  String _username = "";

  //text변화 감지를 위해서 listner
  @override
  void initState() {
    super.initState();
    _usernameController.addListener(() {
      setState(() {
        _username = _usernameController.text;
      });
    });
  }

  @override
  void dispose() {
    //이 스크린을 벗어날 때 컨트롤러를 dispose해주지 않으면
    // 리스너들이 메모리에 남아있어 나중에 앱이 크래쉬날 수 있음.
    _usernameController.dispose();
    super.dispose();
  }

  void _onNextTap() {
    if (_username.isEmpty) return;
    context.pushNamed(
      EmailScreen.routeName,
      extra: EmailScreenArgs(username: _username),
    );
    // context.push(
    //   EmailScreen.routeName,
    //   /* 파라미터를 숨겨서 전달하기
    //      nav1과 마찬가지로 만들어둔 arg 객체를 이용
    //      해당 class의 username을 바꿔준다음
    //      extra에 전달
    //   */
    //   extra: EmailScreenArgs(username: _username),
    // );
    /*
    ## pushName으로 데이터 넘기기
    1. 메인.dart에 route 설정
    2. 받을 페이지에 args class 만들어 주기
    3. 넘겨줄 페이지에서 args class에 해당 데이터 넘기기
    
    final args = ModalRoute.of(context)!.settings.arguments as EmailScreenArgs;
    4. 받는 페이지에서는 위처럼 ModalRoute를 이용하여 데이터 받아오기.
    assertion 없을 경우 object로 args.username 이런식으로 접근 안되니 어설션 해주기.
     */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign up",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v40,
            const Text(
              "Create username",
              style: TextStyle(
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gaps.v8,
            const Text(
              "You can always change this later.",
              style: TextStyle(
                fontSize: Sizes.size16,
                color: Colors.black45,
              ),
            ),
            Gaps.v16,
            TextField(
              //TextField가 Controller의 존재를 알 수 있음.
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: "Username",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              cursorColor: Theme.of(context).primaryColor,
            ),
            Gaps.v16,
            GestureDetector(
              //StateFul widget의 State내에서는 context를 어디서나 사용가능해서
              // 따로 넘겨줄 필요가 없음.
              //Stateless widget에서의 navigator
              //lib/features/authentication/widgets/auth_button.dart
              onTap: _onNextTap,
              child: FormButton(disabled: _username.isEmpty),
            )
          ],
        ),
      ),
    );
  }
}
