import 'package:flutter/material.dart';

class VideoTimelineScreen extends StatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  State<VideoTimelineScreen> createState() => _VideoTimelineScreenState();
}

class _VideoTimelineScreenState extends State<VideoTimelineScreen> {
  List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.teal,
    Colors.yellow,
  ];

  @override
  Widget build(BuildContext context) {
    // PageView : 자식요소들을 꽉 채운 슬라이드뷰로 만들어줌.
    // listview와 마찬가지로 builder메서드가 있어서 뷰포트에 보일 때 해당 자식 요소를 렌더링하게 됨.

    return PageView.builder(
      //pageSnapping : 슬라이드가 넘어가지 않고 중간에 멈춤
      //기본값: true - 일정 비율 넘어가면 슬라이드 넘어감)
      pageSnapping: true,
      //scrollDirection : 슬라이드 방향
      scrollDirection: Axis.vertical,
      // itemCount : 요소 개수 설정
      itemCount: 4,
      itemBuilder: (context, index) => Container(
        color: colors[index],
      ),
      // 아래 children : 그냥 PageView 사용할 때
      // children: [
      //   Container(
      //     color: Colors.blue,
      //   ),
      //   Container(
      //     color: Colors.teal,
      //   ),
      //   Container(
      //     color: Colors.yellow,
      //   ),
      //   Container(
      //     color: Colors.pink,
      //   ),
      // ],
    );
  }
}
