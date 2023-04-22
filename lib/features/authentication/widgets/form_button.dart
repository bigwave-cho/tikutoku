import 'package:flutter/material.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/utils.dart';

class FormButton extends StatelessWidget {
  //VSCode가 부모위젯의 _username을 그대로 가지고 오면서 아래와 같은
  //생성자가 생성됨. 생성자 파라미터로 private을 정의하는 것은 허용되지 않기 때문에
  // 인자로 _username을 받아 _username에 할당해주는 방식을 선택함.
  /* vscode가 자동 생성한 방식
  const FromButton({
    Key? key,
    required String username,
  })  : _username = username,
        super(key: key);

  final String _username;
  */
  // 대신, boolean을 받는 방법
  const FormButton({
    super.key,
    required this.disabled,
  });
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      //AnimatedContainer : deco가 바뀌면 애니메이션 효과 부여 가능
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.size10),
          color: disabled
              ? isDarkMode(context)
                  ? Colors.grey.shade800
                  : Colors.grey.shade300
              : Theme.of(context).primaryColor,
        ),
        //AimatedContainer는 자신만을 애니메이팅하고 자식컴포는 안함.
        //따라서 자식도 애니메이트 위젯으로 감싸주기 and 스타일도 빼주기.
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            color: disabled ? Colors.grey.shade400 : Colors.white,
            fontWeight: FontWeight.w600,
          ),
          child: const Text(
            'Next',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
