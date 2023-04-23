import 'package:flutter/material.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/authentication/password_screen.dart';
import 'package:tiktok/features/authentication/widgets/form_button.dart';

class EmailScreenArgs {
  final String username;

  EmailScreenArgs({required this.username});
}

class EmailScreen extends StatefulWidget {
  static String routeName = "/email";

  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreen();
}

class _EmailScreen extends State<EmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  String _email = "";

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _email = _emailController.text;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _isEmailValid() {
    if (_email.isEmpty) return null;
    // validation
    final regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!regExp.hasMatch(_email)) {
      return "Email Not Valid";
    }
    return null;
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void _onSubmit() {
    if (_email.isEmpty || _isEmailValid() != null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as EmailScreenArgs;
    debugPrint(args.username);
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
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
              Text(
                "What is your Email? ${args.username}",
                style: const TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.v16,
              TextField(
                controller: _emailController,
                // 키보드를 email에 맞게 세팅
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                //서브밋 옵션 1
                // onSubmitted: (value) => ,
                //서브밋 옵션 2
                onEditingComplete: _onSubmit,
                decoration: InputDecoration(
                  hintText: "Email",
                  errorText: _isEmailValid(),
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
              // valid 통과 못할 때도 비활성화 추가
              GestureDetector(
                onTap: _onSubmit,
                child: FormButton(
                    disabled: _email.isEmpty || _isEmailValid() != null),
              )
            ],
          ),
        ),
      ),
    );
  }
}
