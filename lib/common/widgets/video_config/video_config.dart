import 'package:flutter/widgets.dart';

class VideoConfig extends InheritedWidget {
  //child : Material 전체를 감싸서 차일드로 받으니 아래처럼 child를 받는구나
  const VideoConfig({super.key, required super.child});

  final bool autoMute = true;

  // context(위젯위치)를 받아 VideoConfig를 반환하는 of라는 메서드를 선언.
  static VideoConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VideoConfig>()!;
  }

//updateShouldNotify : 위젯을 리빌드할지 결정
//Whether the framework should notify widgets that inherit from this widget.
// 이 위젯을 리빌드하면 상속하는 위젯들도 리빌드해야할수도 있다.
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
