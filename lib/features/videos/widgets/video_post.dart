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

/*
 ## mixin
 class ... with A : class A의 메서드와 프로퍼티를 모두 복사

 ## SingleTickerProviderStateMixin
 Provides a single [Ticker] that is configured to only tick while the current tree is enabled
 싱클 티커는 해당 위젯이 current tree(화면에 보일 때)만 tick(시계가 틱틱 - 작동)하게 함.

 ### vsync : 해당 애니메이션의 프레임마다 작동함
   vsync에 할당한 this는 해당 class를 참조하고 해당 클래스는 ticker 클래스를 mixin하고있어
   Ticker를 호출한다.

  ### 요약
  애니메이션은 모든 애니메이션 프레임을 보여주기 위해 매프레임마다 작동할 ticker가 필요하고 
  이 티커는 위젯이 화면에 렌더링 됐을 때만 불러와서 작동한다.(위젯이 사라지면 killed).
  하지만 매 프레임마다 작동하는 함수는 리소스를 많이 잡아먹기 때문에 current tree에 있을 때만
  티커가 작동하게 하는 것이 중요하고 SingleTickerProviderStateMixin이 이를 가능하게 해준다.

  참고 : TickerProviderStateMixin 은 여러 애니메이션 컨트롤러가 있을 때 사용
 */

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
