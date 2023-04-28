import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //getter  : 해당 getter로 접근해서 값을 받을 수 있음. ex) user().name : name이 getter
  // user().name() <- 이렇게 할 필요 없어짐

  //로그인 여부
  bool get isLoggedIn => user != null;

  //현재 유저 정보
  User? get user => _firebaseAuth.currentUser;

  Future<void> signUp(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }
}

final authRepo = Provider((ref) => AuthenticationRepository());
