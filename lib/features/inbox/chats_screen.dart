import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok/features/inbox/chat_detail.dart';
import 'package:tiktok/features/inbox/models/chatroom.dart';
import 'package:tiktok/features/inbox/select_chat_screen.dart';
import 'package:tiktok/features/inbox/view_models/chatrooms_view_model.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  static const String routeName = "chats";
  static const String routeURL = "/chats";

  const ChatsScreen({super.key});

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  List<ChatroomModel> _items = [];

  final Duration _duration = const Duration(milliseconds: 500);
  void _addItem() {
    context.pushNamed(
      SelectChatScreen.routeName,
    );

    // if (_key.currentState != null) {
    //   _key.currentState!.insertItem(
    //     _items.length,
    //     duration: _duration,
    //   );
    //   _items.add(_items.length);
    // }
  }

  // void _deleteItem(int index) {
  //   if (_key.currentState != null) {
  //     _key.currentState!.removeItem(
  //       index,
  //       (context, animation) => SizeTransition(
  //         sizeFactor: animation,
  //         child: Container(
  //           color: Colors.red,
  //           // 지울 때 나타나는 위젯으로 같은 위젯이 아닌 새로 만들어지는 위젯임 참고.
  //           child: _makeTile(index),
  //         ),
  //       ),
  //       duration: _duration,
  //     );
  //     _items.removeAt(index);
  //   }
  // }

  void _initItem(List<ChatroomModel> data) {
    if (_key.currentState != null) {
      _key.currentState!.insertItem(
        data.length,
        duration: _duration,
      );
      _items = data;
    }
  }

  void _onChatTap(ChatroomModel chatroom) async {
    final String chatroomId = await ref
        .read(chatroomProvider.notifier)
        .findChatroomId(chatroom.personA, chatroom.personB);
    context.pushNamed(
      ChatDetailScreen.routeName,
      params: {
        "chatId": chatroomId,
      },
    );
    /*
    방법2
    context.push("1");
     */
  }

  // ListTile _makeTile(int index) {
  //   return ListTile(
  //     //길게 눌렀을 때
  //     onLongPress: (() => _deleteItem(index)),
  //     onTap: () => _onChatTap(index),
  //     leading: const CircleAvatar(
  //       radius: 30,
  //       foregroundImage: NetworkImage(
  //           "https://avatars.githubusercontent.com/u/105909665?v=4"),
  //       child: Text(
  //         "JH",
  //       ),
  //     ),
  //     title: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       crossAxisAlignment: CrossAxisAlignment.end,
  //       children: [
  //         Text(
  //           "Messi ($index)",
  //           style: const TextStyle(
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //         //title과 줄 맞추기 위해서 trailing대신 이렇게 구현
  //         Text(
  //           "2:16 PM",
  //           style: TextStyle(
  //             color: Colors.grey.shade500,
  //             fontSize: Sizes.size12,
  //           ),
  //         ),
  //       ],
  //     ),
  //     subtitle: const Text("Don't forget to make a video."),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text(
          "Direct messages",
        ),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const FaIcon(
              FontAwesomeIcons.plus,
            ),
          ),
        ],
      ),
      body: ref.watch(chatroomProvider).when(
            data: (data) {
              return ListView.separated(
                itemBuilder: ((context, index) {
                  final chatroom = data[index];
                  return GestureDetector(
                    onTap: (() => _onChatTap(chatroom)),
                    child: Row(children: [
                      const CircleAvatar(),
                      Gaps.h20,
                      Text(chatroom.personA),
                    ]),
                  );
                }),
                separatorBuilder: ((context, index) => Gaps.v32),
                itemCount: data.length,
              );
            },
            error: ((error, stackTrace) => Center(
                  child: Text(error.toString()),
                )),
            loading: (() => const Center(
                  child: CircularProgressIndicator(),
                )),
          ),
    );
  }
}
