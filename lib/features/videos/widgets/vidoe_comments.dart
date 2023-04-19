import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';

class VideoComments extends StatefulWidget {
  const VideoComments({super.key});

  @override
  State<VideoComments> createState() => _VideoCommentsState();
}

class _VideoCommentsState extends State<VideoComments> {
  void _onClosePressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    /*
     ## MediaQuery 
     MediaQuery.of(context).size.width는 현재 디스플레이에서 사용 가능한 가로 길이를 반환합니다. 여기서 context는 빌드(build context)를 참조하며, 이를 사용하여 현재 앱 화면에 대한 정보를 얻을 수 있습니다.

     Flutter에서 MediaQuery는 미디어 쿼리 정보를 다루는 클래스입니다. MediaQuery.of(context)는 주어진 컨텍스트에 가장MediaQueryData를 반환합니다. 여기서, size 속성은 현재 디스플레이에 대한 논리적 크기를 나타내는 Size 객체를 반width 속성은 이 객체의 가로 길이를 반환합니다.

    이 정보를 사용하여 다양한 디스플레이 크기에서 동적으로 UI를 조정할 수 있습니다. 예를 들어, 화면의 가로 길이에 따라너비를 조정할 수 있습니다.
      */

    final size = MediaQuery.of(context).size;

    // showModalBottomSheet은 실제로 새로운 스크린을 push하는 것
    return Container(
      // height는 showModalBottomSheet에 isScrollControlled :true 여야 적용됨
      height: size.height * 0.75,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          Sizes.size10,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          // appbar의 back버튼 비활성
          backgroundColor: Colors.grey.shade50,
          automaticallyImplyLeading: false,
          title: const Text('22222 comments'),
          actions: [
            IconButton(
              onPressed: _onClosePressed,
              icon: const FaIcon(FontAwesomeIcons.xmark),
            ),
          ],
        ),
        body: Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.size10,
                horizontal: Sizes.size16,
              ),
              separatorBuilder: (context, index) => Gaps.v10,
              itemCount: 10,
              itemBuilder: ((context, index) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        child: Text(
                          'JH',
                        ),
                      ),
                      Gaps.h10,
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'JH',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Sizes.size14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Gaps.v3,
                          const Text(
                            "that that that dkdkdkddkdkd slkfanlsdf sldkfnasdfkjlndslf lsadkfn!!",
                          )
                        ],
                      )),
                      Gaps.h10,
                      Column(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.heart,
                            size: Sizes.size20,
                            color: Colors.grey.shade500,
                          ),
                          Gaps.v2,
                          Text(
                            '52.2k',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
            Positioned(
              bottom: 0,
              // Positioned width 없으면 에러뜸.
              width: size.width,

              child: BottomAppBar(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size16,
                    vertical: Sizes.size8,
                  ),
                  child: Row(children: [
                    CircleAvatar(
                      radius: 18,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey.shade500,
                      child: const Text(
                        'JH',
                      ),
                    ),
                    Gaps.h10,
                    Expanded(
                      //TextField는 그냥 쓰면 남은 공간을 다 차지하려 해서 에러가 뜬다(unbound)
                      // SizedBox로 감싸서 너비를 정해주거나 Expanded로 남은 공간을 차지하도록 하면 됨

                      // 가상키보드 : 키보드가 나타나면 플러터는 기본적으로 body를 리사이징하고
                      //             바텀 네비를 슬라이드 아웃 & 인 시킴
                      //resizeToAvoidBottomInset : false로 리사이징 비활성화.
                      child: TextField(
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          hintText: 'Write a commnet...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(Sizes.size12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: Sizes.size12,
                            vertical: Sizes.size10,
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
