import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/authentication/view_models/signup_view_model.dart';
import 'package:tiktok/features/authentication/widgets/form_button.dart';

class BirthdayScreen extends ConsumerStatefulWidget {
  const BirthdayScreen({super.key});

  @override
  ConsumerState<BirthdayScreen> createState() => _BirthdayScreen();
}

class _BirthdayScreen extends ConsumerState<BirthdayScreen> {
  final TextEditingController _birthdayController = TextEditingController();

  DateTime initialDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // 생성될 때마다 _birthdayController.value 초기화
    _setTextFieldDate(initialDate);
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    super.dispose();
  }

  void _onNextTap() {
    final state = ref.read(signupForm.notifier).state;
    ref.read(signupForm.notifier).state = {
      ...state,
      "bio": _birthdayController.value.text,
    };

    ref.read(signupProvider.notifier).signUp(context); // signUp 메서드를 호출
    // guard가 작동해서 error 유무에 따라 다음 스크린으로 이동시킬 것이다.

    // path가 /onboarding으로 바뀌어야 하니까 (GoRoute)
    //pushReplacementNamed : removeUntil.. 같은 기능 (뒤로가기 못하게)
    // context.pushReplacementNamed(InterestsScreen.routeName);
  }

  void _setTextFieldDate(DateTime date) {
    final textDate = date.toString().split(" ").first; // P1. 2023-03-22

    // _birthdayController의 value에 할당하여 초기화
    _birthdayController.value = TextEditingValue(text: textDate);
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
              "When's your birthday?",
              style: TextStyle(
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gaps.v8,
            const Text(
              "Your birthday won't be shown publicly.",
              style: TextStyle(
                fontSize: Sizes.size16,
                color: Colors.black45,
              ),
            ),
            Gaps.v16,
            TextField(
              enabled: false, //P1.  키보드 비활성
              //P1.  날짜가 인풋에 기본값으로 나옴
              controller: _birthdayController,
              decoration: InputDecoration(
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
              onTap: _onNextTap,
              child: FormButton(disabled: ref.watch(signupProvider).isLoading),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 300,
          child: CupertinoDatePicker(
            // mode 기본값 날짜 시간
            //{CupertinoDatePickerMode mode = CupertinoDatePickerMode.dateAndTime}
            mode: CupertinoDatePickerMode.date, // 날짜만
            // 최대 날짜 제한
            maximumDate: initialDate,
            // 초기 날짜 세팅
            initialDateTime: initialDate,
            //onDateTiemChanged : (DateTime value){}
            //DatePicker의 날짜가 인자로 전달되서 initaildate를 초기화 함
            onDateTimeChanged: _setTextFieldDate,
          ),
        ),
      ),
    );
  }
}
