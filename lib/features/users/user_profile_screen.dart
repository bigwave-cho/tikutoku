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
          pinned: true, // backgroundColor와 title 보여줌

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
        // Sliver에 사용가능한 container같은거라고 보면 될듯.
        /*
        SliverToBoxAdapter는 일반 Box 위젯 (예: Container, Column, Row 등)을
         Sliver 위젯으로 변환하는데 사용되는 특수한 위젯입니다.
          SliverToBoxAdapter는 CustomScrollView와 같은 스크롤 가능한 영역에서 
          일반 위젯을 사용할 수 있게 해주므로, 이를 사용하면 Sliver에 
          사용 가능한 Container와 같은 기능을 제공
         */
        SliverToBoxAdapter(
          child: Column(children: const [
            CircleAvatar(
              backgroundColor: Colors.red,
              radius: 20,
            ),
          ]),
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
        SliverPersistentHeader(
          delegate: CustomDelegate(),
          // pinned: true, // pinned true주면  sticky됨
          floating: true,
        ),
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
          ),
        ),
      ],
    );
  }
}

// SliverPersistentHeaderDelegate을 커스터마이징해서 사용하기
// 구현해야하는 메서드를 전구눌러서 바로 넣을 수 있음.
class CustomDelegate extends SliverPersistentHeaderDelegate {
  // 빌드되어 나오는 위젯
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.indigo,
      child: const FractionallySizedBox(
        // Fracti.. : 부모만큼 영역 차지
        heightFactor: 1,
        child: Center(
          child: Text(
            "title!!@!@",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  //최대높이 : pinned되기 전 높이
  @override
  double get maxExtent => 150;

  //최소높이 : pinned되고나서 높이
  @override
  double get minExtent => 80;

//shouldRebuild : maxExtent,minExtent 등의 값을 변경하고 싶으면 true
// build에서 완전히 다른 widgetTree를 리턴하려면 false
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
