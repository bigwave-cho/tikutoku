import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';

final tabs = ["Top", "Users", "Videos", "Sounds", "LIVE", "Shopping", "Brands"];

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _textEditingController =
      TextEditingController(text: "food tiktok"); //기본값 가능한지 첨 알았네
  void _onSearchChanged(String value) {
    print(value);
  }

  void _onSearchSubmitted(String value) {
    print(value);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: SizedBox(
            height: 40,
            child: TextField(
              controller: _textEditingController,
              onChanged: _onSearchChanged,
              onSubmitted: _onSearchSubmitted,
              decoration: InputDecoration(
                prefixIconConstraints: const BoxConstraints(maxWidth: 35),
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12),
                  child: FaIcon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Colors.black,
                    size: Sizes.size16,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: GestureDetector(
                    onTap: () {
                      _textEditingController.text = "";
                    },
                    child: const FaIcon(
                      FontAwesomeIcons.solidCircleXmark,
                      color: Colors.black,
                      size: Sizes.size16,
                    ),
                  ),
                ),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),
          // title: CupertinoSearchTextField(
          //   controller: _textEditingController,
          //   onChanged: _onSearchChanged,
          //   onSubmitted: _onSearchSubmitted,
          // ),
          elevation: 1, // AppBar 밑줄 구분선
          actions: [
            IconButton(
              onPressed: () {
                print('clicked');
              },
              icon: const FaIcon(
                FontAwesomeIcons.sliders,
                size: Sizes.size20,
              ),
            )
          ],
          bottom: TabBar(
            onTap: (value) {
              FocusScope.of(context).unfocus();
            },
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
            // listview도 가지고 있음. 드래그 감지해서 키보드 사라지도록.
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: AspectRatio(
                      //AspectRatio : 원하는 비율로 이미지를 맞춤.
                      aspectRatio: 9 / 16,
                      child: FadeInImage.assetNetwork(
                          // 네트워크 이미지의 로딩 시간동안 에셋의 플레이스홀더 이미지를 보여줌
                          fit: BoxFit.cover,
                          placeholder: "assets/images/placeholder.jpg",
                          image:
                              "https://plus.unsplash.com/premium_photo-1681412205359-a803b2649d57?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80"),
                    ),
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
