import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/videos/models/video_model.dart';

// # 1 레포를 만들고
class VideosRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // upload a video
  UploadTask uploadVideoFile(File video, String uid) {
    final fileRef = _storage.ref().child(
        "/videos/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}");

    return fileRef.putFile(video);
  }

  // create a video document
  Future<void> saveVideo(VideoModel data) async {
    await _db.collection("videos").add(data.toJson());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos({
    int? lastItemCreatedAt,
  }) async {
    final query = _db
        .collection("videos")
        .orderBy(
          "createdAt",
          descending: true,
        )
        .limit(2);
    if (lastItemCreatedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastItemCreatedAt]).get();
    }

    /*
   startAfter([3])
   orderBy에 의해 1,2,3,4... 가져오는중
   3번 요소 다음부터 가져오고 싶다.  4,5...

   배열을 인자로 넣는 이유는 또다른 orderBy추가할 경우 다음 요소로 넣으면 됨.
   ([3, 'creatorUid'])

   fetchVideos(null);
   1,2
   fetchVideos(2);
   3,4
     */
  }

  Future<void> likeVideo(String videoId, String userId) async {
    /*
   firebase 한계
   기존처럼 그냥 likes를 add 해버리면 
   지금 유저가 또 누르는 건지 찾기 위해 (예를들어) 수백만개의 likes를
   검색하게 되고 firebase에 이에 대한 작업의 cost를 지불해야함.
    await _db
        .collection("likes")
        .where(
          'videoId',
          isEqualTo: videoId,
        )
        .where("userId", isEqualTo: userId);
  */
    //doc id로 비디오와 유저아이디로 지정, 필드값은 해당 시간만
    // 이렇게하면 중복으로 좋아요 추가가 불가

    /*
  추가로 좋아요누른 리스트 보여주기는
  functions 백그라운드 함수 사용해라.
  user내에 likes 콜렉션을 만드는 식으로
   */
    final query = _db.collection("likes").doc("${videoId}000$userId");
    final like = await query.get();
    if (!like.exists) {
      await query.set({
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      await query.delete();
    }
  }
}

final videosRepo = Provider(((ref) => VideosRepository()));
