import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

//SingleTickerProviderStateMixin
//ticker함수제공, 위젯이 위젯트리에 없을 때 리소스 낭비 예방
class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  // 배열만드는 메서드 List.generate
  final List<String> _notifications = List.generate(20, (index) => "${index}h");

/*
late 키워드는 Dart의 null-safety 기능에 속해 있으며, non-nullable 변수를 나중에 초기화할 수 있도록 허용합니다. 이는 변수의 초기값이 런타임에 결정되거나, 객체 생성 시점에 초기화할 수 없는 값에 유용합니다.

late 키워드를 사용하는 주요 이유는 다음과 같습니다:

초기화 지연: 변수를 선언할 때 초기화하지 않고, 나중에 초기화할 수 있습니다. 이는 초기화 시점을 늦춤으로써 앱의 성능을 향상시킬 수 있습니다.
순환 참조 해결: 두 개 이상의 클래스가 서로 참조할 때, 초기화 순서를 해결하기 위해 late 키워드를 사용할 수 있습니다.
초기화 로직이 복잡한 경우: 변수를 초기화하는 데 복잡한 계산이 필요한 경우에 late 키워드를 사용하여 초기화 로직을 분리할 수 있습니다.

위 예제에서 late 키워드는 _animationController 변수를 나중에 초기화하도록 허용합니다. vsync: this와 같은 초기화 코드는 객체 생성 시점에 사용할 수 없기 때문입니다. 이 경우, late 키워드를 사용하면 객체 생성 후에 AnimationController를 초기화하도록 합니다. 이렇게 함으로써, 초기화 시점이 런타임에 결정되거나 복잡한 초기화 로직을 분리할 수 있습니다.
 */

  // late 안쓰면 아래처럼 이닛스테이트로
  /* @override
      void initState() {
      super.initState();
      _animationController = AnimationController(vsync: this);
   }*/

// 두 개 이상의 클래스를 서로 참조
  late final AnimationController _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ));

  // animation을 생성해서 Tween()할당.
  late final Animation<double> _animation =
      Tween(begin: 0.0, end: 0.5).animate(_animationController);

  // 애니메이션 방법
  // 1. AnimationController의 value를 수정해서 컨트롤러에 리스너 추가(setstate)
  // 2. Animation Builder
  // 3. Animation 사용 -- 여기서 사용되는 방법

  void _onDismissed(String notification) {
    _notifications.remove(notification);
    setState(() {});
  }

  void _onTitleTap() {
    if (_animationController.isCompleted) {
      _animationController.reverse(); //isCompleted false
    } else {
      _animationController.forward(); //isCompleted true
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("$_notifications"); // 배열 사라지는거 확인가능.
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _onTitleTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "All activity",
              ),
              Gaps.h2,
              RotationTransition(
                turns: _animation,
                child: const FaIcon(
                  FontAwesomeIcons.chevronDown,
                  size: Sizes.size14,
                ),
              )
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          Gaps.v14,
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size20,
            ),
            child: Text(
              "New",
              style: TextStyle(
                fontSize: Sizes.size14,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          Gaps.v14,
          for (var notification in _notifications)
            Dismissible(
              key: Key(notification), //임시로 아무 키나 할당.
              onDismissed: ((direction) => _onDismissed(notification)),
              background: Container(
                alignment: Alignment.centerLeft,
                color: Colors.green,
                child: const Padding(
                  padding: EdgeInsets.only(
                    left: Sizes.size10,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.checkDouble,
                    color: Colors.white,
                    size: Sizes.size32,
                  ),
                ),
              ),
              secondaryBackground: Container(
                alignment: Alignment.centerRight,
                color: Colors.red,
                child: const Padding(
                  padding: EdgeInsets.only(
                    right: Sizes.size10,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.trashCan,
                    color: Colors.white,
                    size: Sizes.size32,
                  ),
                ),
              ),
              child: ListTile(
                minVerticalPadding: Sizes.size16,
                leading: Container(
                  width: Sizes.size52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: Sizes.size1,
                    ),
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.bell,
                      color: Colors.black,
                    ),
                  ),
                ),
                title: RichText(
                  text: TextSpan(
                    text: "Account updates:",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: Sizes.size16,
                    ),
                    children: [
                      const TextSpan(
                        text: " Upload longer videos",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextSpan(
                        text: " $notification",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: const FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: Sizes.size16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
