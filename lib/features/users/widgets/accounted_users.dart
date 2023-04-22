import 'package:flutter/material.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';

class AccountedUsers extends StatelessWidget {
  const AccountedUsers({
    Key? key,
    required this.counts,
    required this.kind,
  }) : super(key: key);
  final int counts;
  final String kind;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$counts',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Sizes.size18,
          ),
        ),
        Gaps.v3,
        Text(
          kind,
          style: TextStyle(
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
