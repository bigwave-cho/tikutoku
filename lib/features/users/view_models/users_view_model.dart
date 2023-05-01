import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/users/models/user_profile_model.dart';
import 'package:tiktok/features/users/repos/user_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _repository;

  @override
  FutureOr<UserProfileModel> build() {
    _repository = ref.read(userRepo);
    //초기에 프로파일 정보 없으면 empty메서드로 빈 스트링을 가진 인스턴스를 제공
    return UserProfileModel.empty();
  }

  //계정 생성 시 userCredential을 받아 새 인스턴스 생성해서 state에 할당
  Future<void> createProfile({
    required UserCredential credential,
    required String bio,
    required String displayName,
  }) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }
    state = const AsyncValue.loading();
    // 크레덴셜과 네임 bio를 받아서 profile 인스턴스 생성
    final profile = UserProfileModel(
      bio: bio,
      link: "undefined",
      uid: credential.user!.uid,
      name: credential.user!.displayName ?? displayName,
      email: credential.user!.email ?? "Anon@anon.com",
    );
    // 생성된 profile인스턴스를 _repo에 전달해서
    // 파이어스토어에 create!!
    await _repository.createProfile(profile);

    // 완료 후 state에는 해당 프로필내용 업뎃!
    state = AsyncValue.data(profile);
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);
