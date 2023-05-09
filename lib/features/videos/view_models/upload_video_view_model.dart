import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok/features/users/view_models/users_view_model.dart';
import 'package:tiktok/features/videos/models/video_model.dart';
import 'package:tiktok/features/videos/repos/videos_repo.dart';
import 'package:go_router/go_router.dart';

class UploadVideoViewModel extends AsyncNotifier<void> {
  late final VideosRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(videosRepo);
  }

  // #2. viewmodel을 만들고
  Future<void> uploadVideo(File video, BuildContext context) async {
    final user = ref.read(authRepo).user;
    final userProfile = ref.read(usersProvider).value;
    if (userProfile != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final task = await _repository.uploadVideoFile(
          video,
          user!.uid,
        );
        if (task.metadata != null) {
          // 스토리지에 파일 올리고 메타데이터가 확인되면 파이어스토어에도 정보 올려주기.

          // #4. 레포에 모델을 초기화해서 보내주면 완성.
          await _repository.saveVideo(
            VideoModel(
              title: "From Flutter",
              description: "미리보기에 form추가해서 타이틀 설명 추가해보자",
              fileUrl: await task.ref.getDownloadURL(),
              thumbnailUrl: "",
              creatorUid: user.uid,
              likes: 0,
              comments: 0,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              creator: userProfile.name,
            ),
          );
          // context.pushReplacement("/home");
          context.pop();
          context.pop();
        }
      });
    }
  }
}

final uploadVideoProvider = AsyncNotifierProvider<UploadVideoViewModel, void>(
  () => UploadVideoViewModel(),
);
