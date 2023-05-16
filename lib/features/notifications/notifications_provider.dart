import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/authentication/repos/authentication_repo.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok/features/inbox/chats_screen.dart';
import 'package:tiktok/features/videos/views/video_recording_screen.dart';

class NotificationsProvider extends FamilyAsyncNotifier<void, BuildContext> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> updateToken(String token) async {
    final user = ref.read(authRepo).user;
    if (user == null) return;
    _db.collection("users").doc(user.uid).update({"token": token});
  }

  Future<void> initListeners(BuildContext context) async {
    final permission = await _messaging.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }
    //Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("I just got a message and I'm in the the foreground");
      print(event.notification?.title);
    });

    //BackGround
    FirebaseMessaging.onMessageOpenedApp.listen((notification) {
      //background noti는 아예 캠페인 완료해서 전송
      // ['키'] <= 에 값 설정하고 보내고 아래 코드로 확인 가능
      //noti에 데이터 담아 보내기 가능하단거
      print(notification.data['screen']);
      context.pushNamed(ChatsScreen.routeName);
    });

    //Terminated
    // 위의 포/백그라운드 노티는 stream(이벤트리스너)지만
    // termi는 아님. 그냥 app이 noti에 의해 실행됐는지만 알려줌.
    final notification = await _messaging.getInitialMessage();

    if (notification != null) {
      print(notification.data['screen']);
      context.pushNamed(VideoRecordingScreen.routeName);
    }
  }

  @override
  FutureOr build(BuildContext context) async {
    final token = await _messaging.getToken();
    print(token);
    if (token == null) return;
    await updateToken(token);
    await initListeners(context);
    _messaging.onTokenRefresh.listen((newToken) async {
      await updateToken(token);
    });
  }
}

final notificationsProvider = AsyncNotifierProvider.family(
  () => NotificationsProvider(),
);
