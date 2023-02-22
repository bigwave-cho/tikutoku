import 'package:flutter/material.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/authentication/email_screen.dart';
import 'package:tiktok/features/authentication/widgets/form_button.dart';

//Controller : 코드나 메서드 등으로 TextField와 같은 위젯을 컨트롤 가능하게 해줌.
//StatelessWidget의 TextField는 입력만 가능하지 다른 기능을 못하는 상태.
//따라서 StatefulWidget으로 전환
class UsernameScreen extends StatefulWidget {
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EmailScreen(),
      ),
    );
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
              child: FromButton(disabled: _username.isEmpty),
            )
          ],
        ),
      ),
    );
  }
}
