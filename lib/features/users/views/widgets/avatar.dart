import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok/features/users/view_models/avatar_view_model.dart';

class Avatar extends ConsumerWidget {
  final String name;
  final bool hasAvatar;
  final String uid;

  const Avatar({
    super.key,
    required this.name,
    required this.hasAvatar,
    required this.uid,
  });

  Future<void> _onAvatarTap(WidgetRef ref) async {
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 150,
      maxWidth: 150,
    );

    if (xfile != null) {
      final file = File(xfile.path);
      ref.read(avatarProvider.notifier).uploadAvatar(file);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(avatarProvider).isLoading;
    return GestureDetector(
      onTap: isLoading ? null : () => _onAvatarTap(ref),
      child: isLoading
          ? Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator.adaptive(),
            )
          : CircleAvatar(
              radius: 50,
              foregroundColor: Colors.blue,
              foregroundImage: hasAvatar
                  //버그: NetworkImage는 이미지를 캐싱하기 때문에 사진을 바꿔도 이전 사진을 보여주고 있음.
                  // 그래서 쿼리에 날짜 추가해줘서 url에 변화를 줘서 새로운 url이라고 보도록 만듦.
                  ? NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/tikutoku-jh124.appspot.com/o/avatars%2F$uid?alt=media&token=2f74f544-9394-44d0-a8e7-362d07e2476a&forceupdate=${DateTime.now().toString()}")
                  : null,
              child: Text(name),
            ),
    );
  }
}
