import 'package:flutter/material.dart';

class VideoConfig extends ChangeNotifier {
  bool autoMute = true;
  // https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html
  //The following example implements a simple counter that utilizes an AnimatedBuilder to limit rebuilds to only the Text widget. The current count is stored in a ValueNotifier, which rebuilds the AnimatedBuilder's contents when its value is changed.
  void toggleAutoMute() {
    autoMute = !autoMute;
    //notifyListeners 이 클래스를 참조하는 것들에게 값 변경을 notify하는 함수
    notifyListeners();
  }
}

final videoConfig = VideoConfig();
