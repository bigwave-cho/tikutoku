import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok/features/inbox/models/message.dart';
import 'package:tiktok/features/inbox/repos/messages_repo.dart';

class MessagesViewModel extends AsyncNotifier<void> {
  late final MessagesRepo _repo;

  @override
  FutureOr<void> build() {
    _repo = ref.read(messagesRepo);
  }

  Future<void> sendMessage(String text, BuildContext context) async {
    final user = ref.read(authRepo).user;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final message = MessageModel(text: text, userId: user!.uid);
      _repo.sendMessage(message);
    });
  }
}

final messagesProvider = AsyncNotifierProvider<MessagesViewModel, void>(
  () => MessagesViewModel(),
);
