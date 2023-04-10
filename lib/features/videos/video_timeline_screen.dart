import 'package:flutter/material.dart';

class VideoTimelineScreen extends StatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  State<VideoTimelineScreen> createState() => _VideoTimelineScreenState();
}

class _VideoTimelineScreenState extends State<VideoTimelineScreen> {
  int _itemCount = 4;

  List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.teal,
    Colors.yellow,
  ];

  void _onPageChanged(int page) {
    if (page == _itemCount - 1) {
      setState(() {});
      _itemCount = _itemCount + 4;
      //addAll(list) : 리스트에 다른 리스트를 추가해줌.
      colors.addAll([
        Colors.blue,
        Colors.red,
        Colors.teal,
        Colors.yellow,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      // onPagechanged : 페이지의 인덱스를 전달해줌.
      onPageChanged: _onPageChanged,
      itemCount: _itemCount,
      itemBuilder: (context, index) => Container(
        color: colors[index],
        child: Center(
          child: Text(
            'Screen $index',
            style: const TextStyle(
              fontSize: 68,
            ),
          ),
        ),
      ),
    );
  }
}
