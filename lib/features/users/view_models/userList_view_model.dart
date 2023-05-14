import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok/features/users/models/user_profile_model.dart';
import 'package:tiktok/features/users/repos/user_repo.dart';

class UsersListViewModel extends AsyncNotifier<List<UserProfileModel>> {
  late final UserRepository _userRepository;
  late final AuthenticationRepository _authenticationRepository;
  late List<UserProfileModel> userList;

  @override
  FutureOr<List<UserProfileModel>> build() async {
    _userRepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);
    userList = await _getUserList();

    return userList;
  }

  Future<List<UserProfileModel>> _getUserList() async {
    final result = await _userRepository.fetchUsers();
    final users = result.docs
        .map(
          (doc) => UserProfileModel.fromJson(
            doc.data(),
          ),
        )
        .toList();
    return users.toList();
  }
}

final userListProvider =
    AsyncNotifierProvider<UsersListViewModel, List<UserProfileModel>>(
        (() => UsersListViewModel()));
