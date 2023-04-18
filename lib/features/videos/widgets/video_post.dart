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
      // 기본적으로 scale에 할당된 _animationController.value는 lowerBound가 기본값
      lowerBound: 1.0,
      upperBound: 1.5,
      // value 넣어주면 해당 value가 기본값
      value: 1.5,
      duration: _animationDuration,
    );

    // 리스너를 달고 setState를 호출해 1 -> 1.01...->1.5 매 순간 빌드를 호출하도록 한다.
    // 아래처럼 하지 않으면 1 -> 1.5 -> 1 로 value가 변하고 나서 build가 작동되기 때문에
    // transition이 보이지 않음.
    _animationController.addListener(() {
      setState(() {});
      print(_animationController.value);
    });
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
                // Transform.scale : scale만큼 크게 만드는 위젯으로 감싸기
                child: Transform.scale(
                  scale: _animationController.value,
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
