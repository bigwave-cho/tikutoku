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

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset("assets/videos/video.mov");
  final Duration _animationDuration = const Duration(milliseconds: 200);

  bool _isPaused = false;

  late final AnimationController _animationController;

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

    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );
  }

  @override
  void dispose() {
    // dispose 안시키면 성능 저하
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 1 && !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }
  }

  // 탭 정지-재생 함수
  void _togglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      // reverse() : lowerBound 값으로
      _animationController.reverse();
    } else {
      _videoPlayerController.play();
      // forward() : lowerBound 값으로
      _animationController.forward();
    }
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
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
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                // AnimatedBuilder: 리스너에 setState 대신 사용할 수 있는 Widget
                child: AnimatedBuilder(
                  //_animationController 값 변화 감지
                  animation: _animationController,
                  builder: ((context, child) {
                    return Transform.scale(
                      // 해당 컨트롤러의 최신 값 참조
                      scale: _animationController.value,
                      child: child, // child는 아래의 child를 참조
                    );
                  }),
                  child: AnimatedOpacity(
                    opacity: _isPaused ? 1 : 0,
                    duration: _animationDuration,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size52,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
