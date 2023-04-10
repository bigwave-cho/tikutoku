import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished;

  const VideoPost({super.key, required this.onVideoFinished});

  @override
  State<VideoPost> createState() => _VideoPostState();
}

/*
1. 로컬 비디오 or 이미지 사용하는 방법
   : assets 폴더 내에 이미지나 비디오를 위치시킨다.
    -> pubspec.yaml의 assets를 활성화하고 해당 파일의 경로를 적어준다.

2. video_player 패키지를 설치 사용!
 */
class _VideoPostState extends State<VideoPost> {
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset("assets/videos/video.mov");

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized) {
      // duration: 영상길이 == position : 사용자가 보고있는 지점
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  void _initVideoPlayer() async {
    await _videoPlayerController.initialize();
    _videoPlayerController.play();
    setState(() {});

    _videoPlayerController.addListener(() {
      _onVideoChange();
    });
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void dispose() {
    // dispose 안시키면 성능 저하
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //Positioned.fill() : Stack 자식요소를 화면에 꽉채움.
        Positioned.fill(
          child: _videoPlayerController.value.isInitialized
              ? VideoPlayer(_videoPlayerController)
              : Container(
                  color: Colors.teal,
                ),
        ),
      ],
    );
  }
}
