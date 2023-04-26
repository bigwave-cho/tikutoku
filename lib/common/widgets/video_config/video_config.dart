import 'package:flutter/widgets.dart';

/*
  stf Widget을 호출해서
  Inherited Widget을 반환 
  -> stf Widget을 통해 데이터를 inherited Widget한테 전달하여 모든 위젯에게 공유하도록

  ## 원래 상태
  Inherited Widget을 최상위에 두었음
  -> 위젯 트리에서 해당 Inherited Widget을 찾아내는 메서드를 반환하는 of함수를 생성
  -> 이제 모든 자식 위젯들은 <InheritedWidget.of(context)를 통해 해당 위젯을 찾아
   트리 위치에 상관없이 해당 Inherited Widget의 데이터를 사용가능

  ## 변경: Stateful Widget과 결합하여 값 업데이트 가능하게  
  autoMute란 값과 toggleMuted 함수를 가진 stf 위젯이 있음
  -> 이 위젯은 최상위에 위치하여 child(MeterialApp)를 받음
  -> child와 autoMute, toggle함수를 InheritedWidget에 전달하여 반환
  -> 결국 InheritedWidget으로 감싼거나 마찬가지
  -> 차이점은 stf위젯이 토글함수(setState포함)을 Inherited에게 전달했음
  -> 자식 위젯에서 InheritedWidget에 접근해서 해당 함수를 실행
  -> 결국 stf위젯의 토글 함수가 호출되는 것
  -> 해당 함수가 호출되고 최상위 위젯인 stf 위젯이 리빌드됨
  -> 새 값 전달받은 Inherited Widget도 새로 반환됨
  -> 자식 위젯들도 리빌드 되면서 Inherited Widget의 새 값을 반영하게 됨.

  이해를 위한 재요약
  StatefulWidget(VideoConfig)가 최상위에서 InheritedWidget(VideoConfigData)의 인스턴스를 생성.
  이 때 StatefulWidget은 autoMute와 toggleMuted()함수를 이 인스턴스에 전달하여 생성.
  결국 VideoConfigDate.of(context).toggleMuted() <- 를 호출하면 이 인스턴스의 toggleMuted는 
  StatefulWidget의 해당 함수를 참조하고 있는 상태(동일 레퍼런스값 공유)이므로 결과적으로 Stateful위젯의
  메서드가 호출이 되고 그 메서드에는 setState 함수가 있어 위젯을 리빌드한다.
  결국 최상위 위젯이 리빌드 되면서 다시 업데이트된 값을 가진 InheritedWidget을 빌드하여 반환하게 되고
  당연히 자식 위젯들도 리빌드되면서 새로 만들어진 InheritedWidget을 참조하여 업데이트된 값을 받아볼 수 있는것이다.

  이렇게 하지 않으면 최상위 위젯에서 프롭 드릴링으로 일일이 전달해줘야한다.

  하지만 이것도 최선이 아니고 너무 장황하다. Flutter 팀에서도 Provider를 사용하라고 권장하고 있고
  Provider나 상태관리패키지를 사용할 때 이것이 기본이 되므로 이해하고 있는 것이 중요하다.
   */

class VideoConfigData extends InheritedWidget {
  final bool autoMute;
  final void Function() toggleMuted;

  //child : Material 전체를 감싸서 차일드로 받으니 아래처럼 child를 받는구나
  const VideoConfigData({
    super.key,
    required super.child,
    required this.autoMute,
    required this.toggleMuted,
  });

  // context(위젯위치)를 받아 VideoConfigData를 반환하는 of라는 메서드를 선언.
  static VideoConfigData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VideoConfigData>()!;
  }

//updateShouldNotify : 위젯을 리빌드할지 결정
//Whether the framework should notify widgets that inherit from this widget.
// 이 위젯을 리빌드하면 상속하는 위젯들도 리빌드해야할수도 있다.
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

/*
문제 : 이 위젯의 값은 업데이트할 수 없다.
Stateful widget과 합쳐볼까
*/

class VideoConfig extends StatefulWidget {
  final Widget child;

  const VideoConfig({
    super.key,
    required this.child,
  });

  @override
  State<VideoConfig> createState() => _VideoConfigState();
}

class _VideoConfigState extends State<VideoConfig> {
  bool autoMute = false;

  void toggleMuted() {
    setState(() {
      autoMute = !autoMute;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VideoConfigData(
      toggleMuted: toggleMuted,
      autoMute: autoMute,
      child: widget.child,
    );
  }
}
