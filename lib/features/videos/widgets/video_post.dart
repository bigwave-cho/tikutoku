import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished;
  final int index;
  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.index,
  });

  @override
  State<VideoPost> createState() => _VideoPostState();
}

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

  void _onVisibilityChanged(VisibilityInfo info) {
    // info.visibleFraction : Widget이 화면 100퍼센트 채우면 재생.
    print("video: ${widget.index} is ${info.visibleFraction * 100}");

    // _onVideoChange 함수에서 동영상이 끝나면 finished되기 때문에
    // 아래 조건이 만족됨.
    if (info.visibleFraction == 1 && !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }
  }

  // 탭 정지-재생 함수
  void _togglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
    } else {
      _videoPlayerController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    // VisibilityDetector를 설치하고 자식을 감싸면
    // 자식이 화면에 얼마나 나오는지(0~1)로 반환
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          //Positioned.fill() : Stack 자식요소를 화면에 꽉채움.
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Container(
                    color: Colors.teal,
                  ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _togglePause,
            ),
          ),
          const Positioned.fill(
            //IgnorePointer : 자식 요소에 event 무시되고 통과되도록.
            child: IgnorePointer(
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.play,
                  color: Colors.white,
                  size: Sizes.size52,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
