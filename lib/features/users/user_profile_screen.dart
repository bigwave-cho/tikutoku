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
    return CustomScrollView(
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
              )
            ],
          ),
        )
      ],
    );
  }
}
