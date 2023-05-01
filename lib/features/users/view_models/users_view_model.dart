import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/users/models/user_profile_model.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  @override
  FutureOr<UserProfileModel> build() {
    //초기에 프로파일 정보 없으면 empty메서드로 빈 스트링을 가진 인스턴스를 제공
    return UserProfileModel.empty();
  }

  //계정 생성 시 userCredential을 받아 새 인스턴스 생성해서 state에 할당
  Future<void> createAccount(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }

    state = AsyncValue.data(
      UserProfileModel(
        bio: "undefined",
        link: "undefined",
        uid: credential.user!.uid,
        name: credential.user!.displayName ?? "Anon",
        email: credential.user!.email ?? "Anon@anon.com",
      ),
    );
  }
}

final usersProvider = AsyncNotifierProvider(
  () => UsersViewModel(),
);
