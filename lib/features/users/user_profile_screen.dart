import 'package:flutter/material.dart';
import 'package:tiktok/constants/sizes.dart';

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
          //floating, pinned, snap  기본값 false
          // floating: true, // 스크롤이 어디있든 스크롤 방향에 따라 나타남
          // pinned: true, // backgroundColor와 title 보여줌

          // floating에 snap을 추가하면 약간만 위로 스크롤해도 appbar가 나옴
          snap: true,
          floating: true,

          stretch: true, // 최상단에 있을때 아래로 스크롤하면 appbar가 늘어남

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
        //ListView
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
            childCount: 50, //자식 몇개인지
            (context, index) => Container(
              color: Colors.amber[100 * (index % 9)],
              child: Align(
                alignment: Alignment.center,
                child: Text("Item $index"),
              ),
            ),
          ),
          itemExtent: 100,
        ) //item 높이
        ,
        //GridView
        SliverGrid(
            delegate: SliverChildBuilderDelegate(
              childCount: 50,
              (context, index) => Container(
                color: Colors.amber[100 * (index % 9)],
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Item $index"),
                ),
              ),
            ),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100,
              mainAxisSpacing: Sizes.size20,
              crossAxisSpacing: Sizes.size20,
              childAspectRatio: 1,
            ))
      ],
    );
  }
}
