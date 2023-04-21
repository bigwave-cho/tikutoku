import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
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

    추가 : DefaultTabController
    탭바와 탭바뷰의 기본 컨트롤러를 적용해주는 위젯이다.
    2개 이상의 length를 가져야 하고
    tabBar와 tabBarView의 수가 일치해야 한다.
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
              //자식 위젯 크기가 9/16을 벗어나기 때문에 세로를 늘려줬음
              childAspectRatio: 9 / 20,
            ),
            itemBuilder: ((context, index) {
              return Column(
                children: [
                  AspectRatio(
                    //AspectRatio : 원하는 비율로 이미지를 맞춤.
                    aspectRatio: 9 / 16,
                    child: FadeInImage.assetNetwork(
                        // 네트워크 이미지의 로딩 시간동안 에셋의 플레이스홀더 이미지를 보여줌
                        fit: BoxFit.cover,
                        placeholder: "assets/images/placeholder.jpg",
                        image:
                            "https://plus.unsplash.com/premium_photo-1681412205359-a803b2649d57?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80"),
                  ),
                  Gaps.v8,
                  const Text(
                      "This is a very long caption for my tiktok that im upload just now currently",
                      maxLines: 2,
                      //overflow : 맥스라인 넘어가는 글자에 대해 적용
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: Sizes.size16 + Sizes.size2,
                        fontWeight: FontWeight.bold,
                      )),
                  Gaps.v5,
                  //DefaultTextStyle : 기본 텍스트 스타일을 적용할 수 있는 위젯
                  DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(
                            "https://avatars.githubusercontent.com/u/105909665?v=4",
                          ),
                        ),
                        Gaps.h4,
                        const Expanded(
                          child: Text(
                            "My avatar is going to be very long",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Gaps.h4,
                        FaIcon(
                          FontAwesomeIcons.heart,
                          size: Sizes.size16,
                          color: Colors.grey.shade600,
                        ),
                        Gaps.h2,
                        const Text(
                          "2.5M",
                        ),
                      ],
                    ),
                  ),
                ],
              );
              // 외부 url 이미지 사용
              // return Image.network(
              //     "https://plus.unsplash.com/premium_photo-1681412205359-a803b2649d57?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80");

              // assets 이미지 사용 방법.
              // return Image.asset("assets/images/placeholder.jpg");
            }),
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
