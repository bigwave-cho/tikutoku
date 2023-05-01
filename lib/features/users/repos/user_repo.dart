import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/users/models/user_profile_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //create profile
  Future<void> createProfile(UserProfileModel profile) async {
    // set은 Map<String, dynamic> 을 인자로 전달받음 (json형태) 따라서
    // repo에 해당 형식으로 받을 수 있는 메서드 생성해야.
    await _db.collection('users').doc(profile.uid).set(profile.toJson());
  }

  //get profile
  Future<Map<String, dynamic>?> findProfile(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    return doc.data();
  }

  //update profile
  Future<void> uploadAvatar(File file, String fileName) async {
    final fileRef = _storage.ref().child('avatars/$fileName');
    final task = await fileRef.putFile(file);
    // task 로 취소, 재개, 완료 등등 제어 가능
  }
}

final userRepo = Provider(
  (ref) => UserRepository(),
);
