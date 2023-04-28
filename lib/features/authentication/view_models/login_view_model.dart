import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok/utils.dart';
import 'package:go_router/go_router.dart';

class LoginViewModel extends AsyncNotifier {
  late final AuthenticationRepository _repository;

  @override
  FutureOr build() {
    _repository = ref.read(authRepo);
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    state = const AsyncValue.loading();

    //guard : 에러가 없으면 결과값을, 있으면 에러를 반환
    // 이경우엔 덮어씌우는게 아니고
    // state.hasError <=
    // guard가 try문에서는 Future를 catch문에서는 AsyncValue.error를 반환
    // 까보면 나옴
    state = await AsyncValue.guard(
      () async => await _repository.signIn(email, password),
    );

    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.go("/home");
    }
  }
}

final loginProvider = AsyncNotifierProvider<LoginViewModel, void>(
  () => LoginViewModel(),
);
