import 'package:flutter/material.dart';
import 'package:tiktok/features/videos/models/playback_config_model.dart';
import 'package:tiktok/features/videos/repos/video_playback_config_repo.dart';

class PlaybackConfigViewModel extends ChangeNotifier {
// 이 뷰모델을 통하지 않고 모델이나 레포에 접근해서 값 수정하는 것을 막기 위해서 private로 선언
  final VideoPlaybackConfigRepository _repository;

  late final PlaybackConfigModel _model = PlaybackConfigModel(
      muted: _repository.isMuted(), autoplay: _repository.isAutoplay());

  // 이 constructor는 class의 인스턴스가 생성될 때 실행되며
  // 생성되고나서 변수들을 이니셜라이즈한다.
  PlaybackConfigViewModel(this._repository);

// 오직 뷰모델을 통해서만 값에 접근가능하도록 메서드를 선언.
// 아래 get/set메서드들에만 접근할 수 있다.
  bool get muted => _model.muted;

  bool get autoplay => _model.autoplay;

  void setMuted(bool value) {
    _repository.setMuted(value); // 레포에게는 디스크에 값 업뎃하라고 하고
    _model.muted = value; // model의 값도 업데이트
    notifyListeners();
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    _model.autoplay = value;
    notifyListeners();
  }
}
