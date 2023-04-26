import 'package:flutter/material.dart';
import 'package:tiktok/common/widgets/dark_mode_config/dark_mode_model.dart';
import 'package:tiktok/common/widgets/dark_mode_config/dark_mode_repo.dart';

class DarkModeViewModel extends ChangeNotifier {
// 이 뷰모델을 통하지 않고 모델이나 레포에 접근해서 값 수정하는 것을 막기 위해서 private로 선언
  final DarkModeRepository _repository;

  late final DarkModelModel _model = DarkModelModel(_repository.isDark());

  // 이 constructor는 class의 인스턴스가 생성될 때 실행되며
  // 생성되고나서 변수들을 이니셜라이즈한다.
  DarkModeViewModel(this._repository);

// 오직 뷰모델을 통해서만 값에 접근가능하도록 메서드를 선언.
// 아래 get/set메서드들에만 접근할 수 있다.
  bool get isDark => _model.isDark;

  void setIsDark(bool value) {
    _repository.setIsDark(value); // 레포에게는 디스크에 값 업뎃하라고 하고
    _model.isDark = value; // model의 값도 업데이트
    notifyListeners();
  }
}
