import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/inbox/chat_detail.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  final List<int> _items = [];
  final Duration _duration = const Duration(milliseconds: 500);
  void _addItem() {
    if (_key.currentState != null) {
      _key.currentState!.insertItem(
        _items.length,
        duration: _duration,
      );
      _items.add(_items.length);
    }
  }

  void _deleteItem(int index) {
    if (_key.currentState != null) {
      _key.currentState!.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: Container(
            color: Colors.red,
            // 지울 때 나타나는 위젯으로 같은 위젯이 아닌 새로 만들어지는 위젯임 참고.
            child: _makeTile(index),
          ),
        ),
        duration: _duration,
      );
      _items.removeAt(index);
    }
  }

  void _onChatTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChatDetailScreen(),
      ),
    );
  }

  ListTile _makeTile(int index) {
    return ListTile(
      //길게 눌렀을 때
      onLongPress: (() => _deleteItem(index)),
      onTap: _onChatTap,
      leading: const CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
            "https://avatars.githubusercontent.com/u/105909665?v=4"),
        child: Text(
          "JH",
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Messi ($index)",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          //title과 줄 맞추기 위해서 trailing대신 이렇게 구현
          Text(
            "2:16 PM",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: Sizes.size12,
            ),
          ),
        ],
      ),
      subtitle: const Text("Don't forget to make a video."),
    );
  }

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
      body: AnimatedList(
        key: _key,
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size10,
        ),
        //AnimatedList는 itemCount가 아닌 아래 속성 가짐
        // 초기에 몇개로 시작할건지
        initialItemCount: 0,
        itemBuilder: (context, index, animation) {
          return FadeTransition(
            //플러터가 리스트타일을 구분할 수 있도록 유니크 키 부여
            key: UniqueKey(),
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              child: _makeTile(index),
            ),
          );
        },
      ),
    );
  }
}
