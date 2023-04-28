import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/authentication/repos/authentication_repo.dart';

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;

  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp() async {
    state = const AsyncValue.loading(); //로딩중

    // signupForm의 데이터를 받아와서.
    final form = ref.read(signupForm);

    /*
    await _authRepo.signUp(form["email"], form["password"]); // 이메일패스워드 처리 끝나면
    state = AsyncValue.data(null); // null(로딩처리끝) : 아무것도 expose 하지 않기 때문
    */

    //위 코드 역할 하는 AsyncValue.guard : try catch해서 에러 핸들링도 해줌
    //form을 이용해서 firebaseauth에 전달(레포)
    state = await AsyncValue.guard(
      () async => await _authRepo.signUp(
        form["email"],
        form["password"],
      ),
    );
  }
}

//StateProvider : A provider that exposes a value that can be modified from outside.
// 외부에서 수정 가능한 값을 provide
final signupForm = StateProvider(
  (ref) => {},
);

//
final signupProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
