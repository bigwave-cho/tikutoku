import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> sendMessage(
    String text,
    BuildContext context,
    String chatId,
  ) async {
    final user = ref.read(authRepo).user;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final message = MessageModel(
        text: text,
        userId: user!.uid,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      _repo.sendMessage(message, chatId);
    });
  }
}

final messagesProvider = AsyncNotifierProvider<MessagesViewModel, void>(
  () => MessagesViewModel(),
);

/*
riverpod은 위젯트리가 아닌 전역에 존재하므로
autoDispose를 설정하지 않으면 화면에 상관없이 계속 StreamProvider가 
살아있음.
 */
final chatProvider =
    StreamProvider.autoDispose.family<List<MessageModel>, String>(
  (ref, chatroomId) {
    final db = FirebaseFirestore.instance;

    return db
        .collection('chat_rooms')
        .doc(chatroomId)
        .collection("texts")
        .orderBy('createdAt')
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (doc) => MessageModel.fromJson(
                  doc.data(),
                ),
              )
              .toList()
              .reversed
              .toList(),
        );
  },
);
