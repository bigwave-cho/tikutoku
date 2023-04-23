import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/settings/settings_screent.dart';
import 'package:tiktok/features/users/widgets/accounted_users.dart';
import 'package:tiktok/features/users/widgets/persistent_tabbar.dart';

class UserProfileScreen extends StatefulWidget {
  final String username;
  const UserProfileScreen({super.key, required this.username});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

void _onGearPressed(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const SettingsScreen(),
    ),
  );
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 그냥 메인네비 스캐폴드 색상 따라갈 필요없이 스캐폴드 감싸자.
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            //headerSliverBuilder: header info 부분
            headerSliverBuilder: ((context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: Text(
                    widget.username,
                  ),
                  actions: [
                    IconButton(
                      onPressed: () => _onGearPressed(context),
                      icon: const FaIcon(
                        FontAwesomeIcons.gear,
                        size: Sizes.size20,
                      ),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Gaps.v20,
                      const CircleAvatar(
                        radius: 50,
                        foregroundColor: Colors.blue,
                        foregroundImage: NetworkImage(
                            "https://avatars.githubusercontent.com/u/105909665?v=4"),
                        child: Text("User"),
                      ),
                      Gaps.v20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "JH",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: Sizes.size18,
                            ),
                          ),
                          Gaps.h5,
                          FaIcon(
                            FontAwesomeIcons.solidCircleCheck,
                            size: Sizes.size16,
                            color: Colors.blue.shade500,
                          ),
                        ],
                      ),
                      Gaps.v24,
                      Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: Sizes.size5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const AccountedUsers(
                              counts: 200,
                              kind: "Following",
                            ),
                            VerticalDivider(
                              // 아래처럼 설정해도 안보이는데
                              // 얘는 부모 위젯 높이를 기준으로 따라감.
                              // 그래서 Row를 SizedBox로 감싸고 height를 지정
                              width: Sizes.size32,
                              thickness: Sizes.size1,
                              color: Colors.grey.shade400,
                              //indet로 길이 조절
                              indent: Sizes.size14,
                              endIndent: Sizes.size14,
                            ),
                            const AccountedUsers(
                              counts: 1000,
                              kind: "Followers",
                            ),
                            VerticalDivider(
                              width: Sizes.size32,
                              thickness: Sizes.size1,
                              color: Colors.grey.shade400,
                              indent: Sizes.size14,
                              endIndent: Sizes.size14,
                            ),
                            const AccountedUsers(
                              counts: 1370,
                              kind: "Likes",
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: Sizes.size12,
                              horizontal: Sizes.size52,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(Sizes.size4),
                              ),
                            ),
                            child: const Text(
                              "Follow",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Gaps.h3,
                          Container(
                            width: 42,
                            height: 42,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(Sizes.size4),
                              ),
                            ),
                            child: const FaIcon(
                              FontAwesomeIcons.youtube,
                              size: Sizes.size20,
                            ),
                          ),
                          Gaps.h3,
                          Container(
                            width: 42,
                            height: 42,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(Sizes.size4),
                              ),
                            ),
                            child: const FaIcon(
                              FontAwesomeIcons.caretDown,
                              size: Sizes.size12,
                            ),
                          ),
                        ],
                      ),
                      Gaps.v14,
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes.size10,
                        ),
                        child: Text(
                          "All highlights and where to watch live matches on FIFA+ I wonder how it woludf",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Gaps.v14,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          FaIcon(
                            FontAwesomeIcons.link,
                            size: Sizes.size12,
                          ),
                          Gaps.h4,
                          Text(
                            "https://www.fifa.com/fifaplus/en/home",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Gaps.v5,
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  delegate: PersitentTabBar(),
                  pinned: true,
                ),
              ];
            }),
            //body :header가 다 스크롤 된 다음 스크롤될 부분
            body: TabBarView(
              children: [
                // SliverToBoxAdapter 자식으로 SliverGrid가 들어갈 수 없음
                //그래서 GridView를 넣음
                GridView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: 20,
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: Sizes.size2,
                    mainAxisSpacing: Sizes.size2,
                    childAspectRatio: 9 / 14,
                  ),
                  itemBuilder: ((context, index) {
                    return Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 9 / 14,
                          child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              placeholder: "assets/images/placeholder.jpg",
                              image:
                                  "https://plus.unsplash.com/premium_photo-1681412205359-a803b2649d57?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80"),
                        ),
                        Positioned(
                          bottom: Sizes.size4,
                          left: Sizes.size4,
                          child: Row(
                            children: const [
                              FaIcon(
                                FontAwesomeIcons.circlePlay,
                                color: Colors.white,
                                size: Sizes.size20,
                              ),
                              Gaps.h6,
                              Text(
                                "4.1M",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  }),
                ),
                const Center(
                  child: Text("page one"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
