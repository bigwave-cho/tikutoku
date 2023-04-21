import 'package:flutter/material.dart';
import 'package:tiktok/constants/sizes.dart';

final tabs = ["Top", "Users", "Videos", "Sounds", "LIVE", "Shopping", "Brands"];

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /*
    TabBar 위젯 사용할 때 뜨는 에러 문구
    When creating a TabBar, you must either provide an explicit TabController using the "controller" property, or you must ensure that there is a DefaultTabController above the TabBar.

    해결: DefaultTabController위젯으로 감싸기
     */
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        // AppBar는 preferredSizWidget으로 특정 크기를 가지려하지만
        // 자식도 prefeerdSizeWidget이어야 하지만
        // 해당 위젯이 아닌 예시) Container의 경우라도
        // PrefferdWidgetSize 위젯으로 감싸면 사용가능
        appBar: AppBar(
          title: const Text("Discover"),
          elevation: 1, // AppBar 밑줄 구분선
          bottom: TabBar(
            //splashFactory :TabBar 클릭 애니메이션 설정 : NoSplach 물결 없앰
            splashFactory: NoSplash.splashFactory,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size16,
            ),
            // TabBar는 가지수 많으면 스크롤러블하게 바꿀 수도 있네
            isScrollable: true,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Sizes.size16,
            ),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey.shade500,
            indicatorColor: Colors.black,
            tabs: [
              for (var tab in tabs)
                Tab(
                  text: tab,
                )
            ],
          ),
        ),
        body: TabBarView(children: [
          GridView.builder(
            padding: const EdgeInsets.all(
              Sizes.size6,
            ),
            itemCount: 20,
            //SliverGridDelegateWithFixedCrossAxisCount : 고정된 개수의 grid-col
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: Sizes.size10,
              mainAxisSpacing: Sizes.size10,
              // 자식요소의 비율도 정하기 가능
              childAspectRatio: 9 / 16,
            ),
            itemBuilder: ((context, index) => Container(
                  color: Colors.teal,
                  child: Text(
                    "$index",
                  ),
                )),
          ),
          //skip(int) - 해당 순서 건너뛰어라
          for (var tab in tabs.skip(1))
            Center(
              child: Text(
                tab,
                style: const TextStyle(
                  fontSize: Sizes.size28,
                ),
              ),
            )
        ]),
      ),
    );
  }
}
