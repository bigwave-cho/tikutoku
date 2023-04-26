import 'package:flutter/material.dart';
import 'package:tiktok/features/videos/views/widgets/video_post.dart';

class VideoTimelineScreen extends StatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  State<VideoTimelineScreen> createState() => _VideoTimelineScreenState();
}

class _VideoTimelineScreenState extends State<VideoTimelineScreen> {
  int _itemCount = 4;

  final PageController _pageController = PageController();

  // final Duration _scrollDuration = const Duration(milliseconds: 250);
  // final Curve _scrollCurve = Curves.linear;

  void _onPageChanged(int page) {
    //페이지 전환을 틱톡처럼 빠르게 하는 방법
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 250),
      curve: Curves.linear,
    );
    if (page == _itemCount - 1) {
      /*
      animateToPage
      이런 식으로 해놓으면 3번째 페이지에 가면 0페이지로 돌아감.
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.bounceOut,
      );
      */
      _itemCount = _itemCount + 4;

      setState(() {});
    }
  }

  //영상이 끝나면 다음 페이지로 넘기는 메서드
  void _onVideoFinished() {
    return;
    // ticktok은 영상 끝나고 다음 영상으로 자동 스킵안하기 때문에 수정
    // _pageController.nextPage(
    //   duration: _scrollDuration,
    //   curve: _scrollCurve,
    // );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() {
    // Future가 5초 후 computation 작동
    // 나중엔 실제 data 받아올듯
    return Future.delayed(
      const Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    //RefreshIndicator: 스크롤 다운했을 때 새로고침하는 위젯
    return RefreshIndicator(
      // onRefresh : 의 함수는 Future를 반환하며 future가 완료될 때 까지 실행됨.
      onRefresh: _onRefresh,
      //displacement : 부모의 엣지로부터 top or bottom에서 offset value
      //스피너가 고정되어질 위치
      displacement: 50,
      //edgeOffset : 스크롤시 스피너가 나타날 위치
      edgeOffset: 20,
      color: Theme.of(context).primaryColor,
      strokeWidth: 4,
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: _itemCount,
        itemBuilder: (context, index) =>
            VideoPost(onVideoFinished: _onVideoFinished, index: index),
      ),
    );
  }
}
