import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/videos/models/video_model.dart';

//AsyncNotifier : api로부터 데이터를 받기 때문에 async
class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  List<VideoModel> _list = [VideoModel(title: "First video")];

  void uploadVideo() async {
    // Async 모델이 처음에 로딩완료된 상태라서
    // 수동으로 다시 업로드 메서드를 실행하면 loadig상태로 만들어주는 과정.
    state = const AsyncValue.loading();

    await Future.delayed(const Duration(seconds: 2));

    final newVideo = VideoModel(title: "${DateTime.now()}");
    // _list.add(newVideo);
    _list = [..._list, newVideo];

    //마찬가지로 state 덮어씌우기 : AsnycNoti는 아래처럼
    state = AsyncValue.data(_list);
  }

  //FutureOr
  //: Notifire<model>은 오직 모델만을 반환
  // 이거는 Future도 반환하기 때문에 FutureOr을 쓰는 것
  @override
  FutureOr<List<VideoModel>> build() async {
    await Future.delayed(const Duration(seconds: 5));

    // throw Exception("can't fetch"); // 임시로 에러 반환해서 에러 텍스트 확인용

    return _list;
  }
}

// NotifireProvider와 동일
//  SharedPreference가 특이한 경우고 이건 이렇게 뷰모델을 초기화해서 반환하면 됨.
final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
