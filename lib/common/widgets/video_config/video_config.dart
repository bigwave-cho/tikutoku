import 'package:flutter/material.dart';

/*
## provider

1. ChangeNotifier 클래스 생성
2.  // ChangeNotifierProvider  프로바이더 하나일 때.
    // 프로바이더가 많으면 MultiProvider 로 최상위 위젯 감싸기
3. context.watch<클래스명>().값
   context.read<클래스명>().메서드 로 호출하여 사용

 */

class VideoConfig extends ChangeNotifier {
  bool isMuted = false;
  bool isAutoplay = false;

  void toggleIsMuted() {
    isMuted = !isMuted;
    notifyListeners();
  }

  void toggleIsAutoplay() {
    isAutoplay = !isAutoplay;
    notifyListeners();
  }
}
