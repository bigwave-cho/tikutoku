import 'package:flutter/material.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/authentication/widgets/form_button.dart';
import 'package:tiktok/features/onboarding/interests_screen.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  //globalKey
  // 고유식별자, 폼의 state에 접근, 폼의 메서드 실행
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};

  void _onSubmitTap() {
    // formTextfield는 textfield와 다르게 에러 텍스트가 바로 나오지 않음.
    // 따라서 formkey를 통해 현재 스테이트에 접근하여 validate 메서드를 호출하면
    // 세팅한 유효성 검사에 따른 반환 값을 리턴해줌
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        // 유효성 통과하면 해당 값 save
        _formKey.currentState!.save();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const InterestsScreen(),
          ),
        );
      }
    }
    /*
    validate()
    : Validates every [FormField] that is a descendant of this [Form],
     and returns true if there are no errors.
     */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size36,
        ),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                  // textField의 value를 받아 유효성 검사 후 string or null을 반환
                  // err => string , 통과 => null
                  validator: (value) {
                    return null;
                    // return "I don't like your email";
                  },
                  //onSaved: save() 된 값 확인
                  onSaved: ((newValue) {
                    print(newValue);
                    if (newValue != null) {
                      formData['email'] = newValue;
                    }
                  }),
                ),
                Gaps.v16,
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                  validator: (value) {
                    return null;
                    // return "Wrong password";
                  },
                  onSaved: ((newValue) {
                    print(newValue);
                    if (newValue != null) {
                      formData['password'] = newValue;
                    }
                  }),
                ),
                Gaps.v28,
                // FormButton의 text는 next고정이라 다른 버튼 커스터마이징 해볼까?
                GestureDetector(
                  onTap: _onSubmitTap,
                  child: const FormButton(disabled: false),
                ),
                // customized button. (그냥 formbutton 써야겠다.)
                /*
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 100,
                            vertical: 12,
                          ),
                        ),
                        //onPressed에 null을 주면 비활성화 가능
                        onPressed: false ? _onSubmitTap : null,
                        child: const Text('Login!'),
                      ),
                    ),
                  ],
                ),
                */
              ],
            )),
      ),
    );
  }
}
