import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
        ),
      ),
      // CloseButton 위젯
      // body: Column(
      //   children: const [
      //     //CloseButton pop이 내장되어있음
      //     CloseButton(),
      //   ],
      // ),

      //ListWheelScrollView : 휠처럼 생긴 위젯 ㅋㅋ
      // body: ListWheelScrollView(
      //   itemExtent: 200, //아이템 높이
      //   offAxisFraction: 1.5,
      //   //돋보기 기능ㅋㅋㅋ
      //   useMagnifier: true,
      //   magnification: 1.5,
      //   children: [
      //     for (var x in [1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5])
      //       FractionallySizedBox(
      //         widthFactor: 1,
      //         child: Container(
      //           color: Colors.teal,
      //           alignment: Alignment.center,
      //           child: const Text(
      //             "pick me",
      //             style: TextStyle(
      //               color: Colors.white,
      //               fontSize: 39,
      //             ),
      //           ),
      //         ),
      //       ),
      //   ],
      // ),

      body: Column(
        children: const [
          CupertinoActivityIndicator(
            radius: 40,
            animating: false,
          ), // ios 프로그레스 인디케이터
          CircularProgressIndicator(), // 구글꺼
          CircularProgressIndicator.adaptive(), //유저의 플랫폼에 따라 알아서 정해줌
        ],
      ),
    );
  }
}
