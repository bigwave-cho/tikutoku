import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/inbox/models/message.dart';

class MessagesRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendMessage(MessageModel message) async {
    await _db
        .collection("chat_rooms")
        .doc("ab0M7ht1Risa95L2UB79")
        .collection("texts")
        .add(message.toJson());
  }
}

final messagesRepo = Provider((ref) => MessagesRepo());
