import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      // slivers의 자식위젯으로는 sliver와 관련된 위젯만 가능
      slivers: [
        SliverAppBar(
          floating: true,
          //stretch :false - 기본값 아래로 늘어나는 것 false
          stretch: true,
          pinned: true,
          //앱바인데도 스크롤 가능
          backgroundColor: Colors.teal,
          elevation: 1,
          title: const Text("hello!"),
          // height가 100일 때 스크롤 시작
          collapsedHeight: 100,
          // height가 300이고 스크롤하면 height가 줄어듦
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [
              //scratch 모드 설정도 가능
              StretchMode.blurBackground,
              StretchMode.fadeTitle,
              StretchMode.zoomBackground,
            ],
            background: Image.asset(
              "assets/images/placeholder.jpg",
              fit: BoxFit.cover,
            ),
            title: const Text("hello!"),
          ),
        ),
      ],
    );
  }
}
