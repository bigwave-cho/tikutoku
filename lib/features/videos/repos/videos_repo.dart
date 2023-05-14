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
}

final videosRepo = Provider(((ref) => VideosRepository()));
