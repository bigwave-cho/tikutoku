import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/videos/widgets/video_button.dart';
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
    // 영상 반복 재생
    await _videoPlayerController.setLooping(true);
    _videoPlayerController.addListener(() {
      _onVideoChange();
    });
  }

  // 글자 수에 따른 더보기 기능
  bool _isSeeMore = false;
  final String _hashtagText = '#분위기 #좋다 #아아 ##맛없다';
  bool _isLognerTen = false;

  void _seeMore() {
    setState(() {
      _isSeeMore = !_isSeeMore;
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

    if (_hashtagText.length > 10) {
      _isLognerTen = true;
    }
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
          ),
          // Positioned : Stack내에서 원하는 곳에 위치 가능
          Positioned(
            bottom: 20,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '@JH',
                  style: TextStyle(
                    fontSize: Sizes.size20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.v10,
                const Text(
                  "Delicious Coffee!@@!",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    color: Colors.white,
                  ),
                ),
                Gaps.v10,
                GestureDetector(
                  onTap: _seeMore,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: Sizes.size16,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: _isSeeMore || !_isLognerTen
                              ? _hashtagText
                              : '${_hashtagText.substring(0, 10)}...',
                        ),
                        if (!_isSeeMore && _isLognerTen)
                          const TextSpan(
                            text: "See more",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              bottom: 20,
              right: 10,
              child: Column(
                children: const [
                  //CircleAvatar : 원 모양 아바타
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    foregroundImage: NetworkImage(
                      "https://avatars.githubusercontent.com/u/105909665?v=4",
                    ),
                    child: Text('JH'),
                  ),
                  Gaps.v20,
                  VideoButton(
                    icon: FontAwesomeIcons.solidHeart,
                    text: "2.9M",
                  ),
                  Gaps.v20,
                  VideoButton(
                    icon: FontAwesomeIcons.solidComment,
                    text: "33K",
                  ),
                  Gaps.v20,
                  VideoButton(
                    icon: FontAwesomeIcons.share,
                    text: "share",
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
