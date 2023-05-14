import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/videos/models/like_model.dart';
import 'package:tiktok/features/videos/repos/videos_repo.dart';

// FamilyAsyncNotifier : 빌드 시 arg를 받을 수 있음.
// 제너릭의 다음 타입으로 추가해줘야 함.

class VideoPostViewModel extends FamilyAsyncNotifier<LikeModel, String> {
  late final VideosRepository _repository;
  late final String _videoId;
  late final String _userId;

  bool _isLiked = false;
  int likedCounts = 0;

  @override
  FutureOr<LikeModel> build(String arg) {
    final idsArr = arg.split("000");
    _videoId = idsArr[0];
    _userId = idsArr[1];
    _repository = ref.read(videosRepo);

    return isLikedVideo();
  }

  Future<LikeModel> isLikedVideo() async {
    final likeData = await _repository.isLiked(_videoId, _userId);

    _isLiked = likeData.isLikedVideo;
    likedCounts = likeData.likeCounts;

    return likeData;
  }

  likeVideo() async {
    final isLiked = await _repository.likeVideo(_videoId, _userId);
    _isLiked = !isLiked;
    likedCounts = isLiked ? likedCounts - 1 : likedCounts + 1;
    state = AsyncValue.data(
        LikeModel(isLikedVideo: _isLiked, likeCounts: likedCounts));
  }
}

final videoPostProvider =
    AsyncNotifierProvider.family<VideoPostViewModel, LikeModel, String>(
  () => VideoPostViewModel(),
);
