import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/authentication/repos/authentication_repo.dart';

class NotificationsProvider extends AsyncNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> updateToken(String token) async {
    final user = ref.read(authRepo).user;
    if (user == null) return;
    _db.collection("users").doc(user.uid).update({"token": token});
  }

  Future<void> initListeners() async {
    final permission = await _messaging.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }
    //foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("I just got a message and I'm in the the foreground");
      print(event.notification?.title);
    });
  }

  @override
  FutureOr build() async {
    final token = await _messaging.getToken();
    print(token);
    if (token == null) return;
    await updateToken(token);
    await initListeners();
    _messaging.onTokenRefresh.listen((newToken) async {
      await updateToken(token);
    });
  }
}

final notificationsProvider = AsyncNotifierProvider(
  () => NotificationsProvider(),
);
