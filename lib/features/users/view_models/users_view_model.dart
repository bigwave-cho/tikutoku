import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok/features/users/models/user_profile_model.dart';
import 'package:tiktok/features/users/repos/user_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _usersRepository; //프로파일
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<UserProfileModel> build() async {
    _usersRepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);

    //로그인 되어 있을때
    if (_authenticationRepository.isLoggedIn) {
      final profile = await _usersRepository
          .findProfile(_authenticationRepository.user!.uid);

      if (profile != null) {
        //파이어베이스에서 해당하는 프로파일을 가져와서 모델을 초기화 후 반환
        return UserProfileModel.fromJson(profile);
      }
    }

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
    await _usersRepository.createProfile(profile);

    // 완료 후 state에는 해당 프로필내용 업뎃!
    state = AsyncValue.data(profile);
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);
