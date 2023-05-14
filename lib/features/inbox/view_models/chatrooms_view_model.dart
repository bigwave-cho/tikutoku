import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok/features/inbox/models/chatroom.dart';
import 'package:tiktok/features/inbox/repos/chatroom_repo.dart';

class ChatroomsViewModel extends AsyncNotifier<List<ChatroomModel>> {
  List<ChatroomModel> _list = [];
  late final ChatroomRepo _chatroomRepo;

  @override
  FutureOr<List<ChatroomModel>> build() async {
    _chatroomRepo = ref.read(chatroomRepo);
    final user = ref.read(authRepo).user;
    _list = await _fetchChatrooms(user!.uid);
    return _list;
  }

  Future<List<ChatroomModel>> _fetchChatrooms(String uid) async {
    final result = await _chatroomRepo.fetchChatrooms(uid);
    final chats = result.docs.map((doc) => ChatroomModel.fromJson(doc.data()));
    return chats.toList();
  }

  Future<void> makeChatroom(String oppoUid) async {
    final userUid = ref.read(authRepo).user!.uid;
    final chatroom = ChatroomModel(personA: userUid, personB: oppoUid);
    ref.read(chatroomRepo).createChat(chatroom);
  }

  Future<String> findChatroomId(String personA, String personB) async {
    final id1 = "${personA}000$personB";
    final id2 = "${personB}000$personA";
    final chatroomId = await ref.read(chatroomRepo).findChatroomId(id1);

    if (chatroomId.data() != null) {
      return id1;
    } else {
      return id2;
    }
  }
}

final chatroomProvider =
    AsyncNotifierProvider<ChatroomsViewModel, List<ChatroomModel>>(
  () => ChatroomsViewModel(),
);
