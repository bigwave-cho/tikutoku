import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/common/widgets/video_config/video_config.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/videos/widgets/video_button.dart';
import 'package:tiktok/features/videos/widgets/vidoe_comments.dart';
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

  // 글자 수에 따른 더보기 기능
  bool _isSeeMore = false;
  final String _hashtagText = '#분위기 #좋다 #아아 ##맛없다';
  bool _isLognerTen = false;

  bool _isPaused = false;
  bool _isMuted = false;

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
    /*
    앱의 첫 시작을 video timeline으로 했을 때 웹으로 빌드하면
    에러를 띄움. 
    이는 브라우저가 웹이 첫 시작 페이지가 소리가 있는 영상이고 
    이것이 자동재생되도록 설정되어있는 것을 막기 때문임.
     */
    //KIsWeb : 웹용으로 컴파일 되었다면 음소거!
    if (kIsWeb) {
      await _videoPlayerController.setVolume(0);
      _isMuted = true;
    }

    _videoPlayerController.addListener(() {
      _onVideoChange();
    });
  }

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
    /*
    모든 Stateful widget에는 mounted 위젯이 존재.
    Widget이 마운트되었는지 알려줌(위젯트리에 존재하는지)
    
    이 스크린이 없어지면서 controller를 dispose()하기 때문에
    다시 스크린으로 돌아오면 없는 컨트롤러를 함수에서 호출하기 떄문에 에러가 떠버림.

    그래서 앞에 mounted를 조건문으로 달아줘서 마운트 전에 함수내 코드가 실행되는 것을 방지
     */

    if (!mounted) return;

    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    } // 일시정지 후 새로고침하면 재생버튼이 보이는채로 영상재생되는 버그 수정

    // offstage는 화면이 dispose되지 않고 탭이 변경되도 남아있는다.(계속 재생할거)
    //그래서 탭 변경하여 안보이면 멈추게 할거다.
    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      _togglePause();
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

// 코멘트누르면 modalsheet이 튀어나오는 함수
  void _onCommentsTap(BuildContext context) async {
    if (_videoPlayerController.value.isPlaying) {
      //영상 재생중이면 정지
      _togglePause();
    }
    // Future를 반환하고 있어 await를 적용하면
    // 모달이 사라질 때 future가 resolve 되고 다음 코드가 실행됨.
    await showModalBottomSheet(
      //웬지 모르겠는데 Container에만 라디우스주면 안먹어서 추가
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          Sizes.size10,
        ),
      ),
      context: context,
      // isScrollControlled : 자식으로 ListView나 GridView를 가지고 있고 draggable하게 하려면
      // true로 설정해야함.
      isScrollControlled: true,
      builder: ((context) => const VideoComments()),
    );
    // 모달 닫히면 재생
    _togglePause();
  }

  void _onToggleVolume(BuildContext context) async {
    if (_isMuted == false) {
      await _videoPlayerController.setVolume(0);
    } else {
      await _videoPlayerController.setVolume(1);
    }
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  @override
  Widget build(BuildContext context) {
    //dependOnInheritedWidgetOfExactType :context에게 VideoConfig라는 타입의 inheritedWidget을 요청
    /*final vidoeConfig = context.dependOnInheritedWidgetOfExactType<VideoConfig>();
      이렇게 해도 되지만 VidoeConfig에 이것을 반환하는 메서드를 넣자.
    */

    //정정 : context는 위젯트리를 의미
    //dependOnInheritedWidgetOfExactType : 얘가 위젯트리에서 VideoConfig라고 명명된 위젯을 찾아
    // 우리가 어디서든 값에 접근할 수 있게 된다.
    // Theme.of(context)의 Theme을 찾아들어가봐도 config만든거랑 똑같이 생김.
    VideoConfigData.of(context).autoMute;

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
          Positioned(
            left: 20,
            top: 40,
            child: IconButton(
              icon: FaIcon(
                VideoConfigData.of(context).autoMute
                    ? FontAwesomeIcons.volumeOff
                    : FontAwesomeIcons.volumeHigh,
                color: Colors.white,
              ),
              onPressed: VideoConfigData.of(context).toggleMuted,
            ),
          ),
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
                children: [
                  GestureDetector(
                    onTap: () => _onToggleVolume(context),
                    child: VideoButton(
                      icon: _isMuted
                          ? FontAwesomeIcons.volumeXmark
                          : FontAwesomeIcons.volumeHigh,
                      text: _isMuted ? "Muted" : "Enjoy!",
                    ),
                  ),
                  Gaps.v20,
                  //CircleAvatar : 원 모양 아바타
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    foregroundImage: NetworkImage(
                      "https://avatars.githubusercontent.com/u/105909665?v=4",
                    ),
                    child: Text('JH'),
                  ),
                  Gaps.v20,
                  const VideoButton(
                    icon: FontAwesomeIcons.solidHeart,
                    text: "2.9M",
                  ),
                  Gaps.v20,
                  GestureDetector(
                    onTap: () => _onCommentsTap(context),
                    child: const VideoButton(
                      icon: FontAwesomeIcons.solidComment,
                      text: "33K",
                    ),
                  ),
                  Gaps.v20,
                  const VideoButton(
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
