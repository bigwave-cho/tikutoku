import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/users/widgets/accounted_users.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      //TabBar 위한
      length: 2,
      child: CustomScrollView(
        // slivers의 자식위젯으로는 sliver와 관련된 위젯만 가능
        slivers: [
          SliverAppBar(
            title: const Text(
              "JH",
            ),
            actions: [
              IconButton(
                onPressed: () {},
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
                SizedBox(
                  height: Sizes.size48,
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
                FractionallySizedBox(
                  widthFactor: 0.33,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: Sizes.size12,
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
                Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: const TabBar(
                    indicatorColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.label,
                    // label :label만큼  tab : tab만큼
                    labelPadding: EdgeInsets.symmetric(
                      vertical: Sizes.size10,
                    ),
                    labelColor: Colors.black,
                    tabs: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes.size20,
                        ),
                        child: Icon(
                          Icons.grid_4x4_rounded,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes.size20,
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.heart,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(
                    children: [
                      // SliverToBoxAdapter 자식으로 SliverGrid가 들어갈 수 없음
                      //그래서 GridView를 넣음
                      GridView.builder(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.all(
                          Sizes.size6,
                        ),
                        itemCount: 20,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: Sizes.size10,
                          mainAxisSpacing: Sizes.size10,
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
                                  aspectRatio: 9 / 16,
                                  child: FadeInImage.assetNetwork(
                                      fit: BoxFit.cover,
                                      placeholder:
                                          "assets/images/placeholder.jpg",
                                      image:
                                          "https://plus.unsplash.com/premium_photo-1681412205359-a803b2649d57?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80"),
                                ),
                              ),
                              Gaps.v8,
                              const Text(
                                  "This is a very long caption for my tiktok that im upload just now currently",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: Sizes.size16 + Sizes.size2,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Gaps.v5,
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
                        }),
                      ),
                      const Center(
                        child: Text("page one"),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
