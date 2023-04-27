import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/videos/models/playback_config_model.dart';
import 'package:tiktok/features/videos/repos/video_playback_config_repo.dart';

// Notifier<model> : Notifier에게 model데이터를 반환할 것이라고 알려줌
class PlaybackConfigViewModel extends Notifier<PlaybackConfigModel> {
  final VideoPlaybackConfigRepository _repository;

  PlaybackConfigViewModel(this._repository);

  void setMuted(bool value) {
    _repository.setMuted(value);
    state = PlaybackConfigModel(
      muted: value,
      autoplay: state.autoplay,
    );
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    // state.autoplay = value;
    /* 위와 같이 state의 값을 직접 수정하지 않고 덮어씌우는 이유
      Riverpod은 불변성(immutable)을 중요시함.
      부분 수정을 하게 되면 불변성을 깨뜨리는 것이며 이는 사이드이펙트를 발생시켜 안정성을 감소시킴.
      그래서 Model그대로 value를 할당하여 인스턴스를 만들어 기존의 인스턴스를 덮어씌우는 것!
     */
    state = PlaybackConfigModel(muted: state.muted, autoplay: value);
  }

  @override
  build() {
    // 사용자가 초기에 볼 데이터를 이니셜라이즈해서 state로 반환
    // state로 데이터에 접근, 수정이 가능
    return PlaybackConfigModel(
      muted: _repository.isMuted(),
      autoplay: _repository.isAutoplay(),
    );
  }
}

//마지막 NotifireProvider<뷰모델, 모델>
// final playbackConfigProivder =
//     NotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
//   () => PlaybackConfigViewModel(),
// );

//현 상황 : repository가 필요함.. SharePreferences는 메인에서 await으로 작동
//그래서 이번만 throw error해서 해결해보자
// 일단은 playbackConfigProvider가 에러 반환하도록 해놓고
// 메인에서 override해서 뷰모델을 반환할 것
final playbackConfigProivder =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
  () => throw UnimplementedError(),
);
