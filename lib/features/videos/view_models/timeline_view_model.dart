import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/videos/models/video_model.dart';
import 'package:tiktok/features/videos/repos/videos_repo.dart';

//AsyncNotifier : api로부터 데이터를 받기 때문에 async
class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  late final VideosRepository _repository;
  List<VideoModel> _list = [];

  //FutureOr
  //: Notifire<model>은 오직 모델만을 반환
  // 이거는 Future도 반환하기 때문에 FutureOr을 쓰는 것
  @override
  FutureOr<List<VideoModel>> build() async {
    // await Future.delayed(const Duration(seconds: 5));

    // throw Exception("can't fetch"); // 임시로 에러 반환해서 에러 텍스트 확인용

    _repository = ref.read(videosRepo);
    final result = await _repository.fetchVideos();
    final newList = result.docs.map(
      (doc) => VideoModel.fromJson(
        doc.data(),
      ),
    );
    _list = newList.toList();
    print(newList);
    return _list;
  }
}

// NotifireProvider와 동일
//  SharedPreference가 특이한 경우고 이건 이렇게 뷰모델을 초기화해서 반환하면 됨.
final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
