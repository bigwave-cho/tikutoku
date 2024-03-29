import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok/features/inbox/models/message.dart';
import 'package:tiktok/features/inbox/view_models/messages_view_model.dart';
import 'package:tiktok/features/users/view_models/users_view_model.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = "chatDetail";
  // Nested route는 "/" 없어도 됨.
  static const String routeURL = ":chatId";

  final String chatId;

  const ChatDetailScreen({super.key, required this.chatId});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _editingController = TextEditingController();
  late String oppoUserName = "";
  void _onSendPressed() {
    final text = _editingController.text;
    if (text == "") {
      return;
    }
    ref
        .read(messagesProvider.notifier)
        .sendMessage(text, context, widget.chatId);
    _editingController.text = "";
  }

  _getUserInfo() async {
    final userList = await ref.read(usersProvider.notifier).getUserList();
    final a = userList
        .where((element) => element.uid == widget.chatId.split("000")[1])
        .toList()[0]
        .name;
    oppoUserName = a;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    late List<MessageModel> messageList;
    final isLoading = ref.watch(messagesProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size8,
          leading: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.all(Sizes.size4),
                child: CircleAvatar(
                  radius: Sizes.size24,
                  foregroundImage: NetworkImage(
                      "https://avatars.githubusercontent.com/u/105909665?v=4"),
                  child: Text("JH"),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: Sizes.size18,
                  height: Sizes.size18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: Sizes.size3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            oppoUserName,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: const Text("Active now"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              FaIcon(
                FontAwesomeIcons.flag,
                color: Colors.black,
                size: Sizes.size20,
              ),
              Gaps.h32,
              FaIcon(
                FontAwesomeIcons.ellipsis,
                color: Colors.black,
                size: Sizes.size20,
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ref.watch(chatProvider(widget.chatId)).when(
              data: ((data) {
                messageList = List.from(data);
                return ListView.separated(
                  reverse: true,
                  padding: EdgeInsets.only(
                    top: Sizes.size20,
                    left: Sizes.size14,
                    right: Sizes.size14,
                    bottom:
                        MediaQuery.of(context).padding.bottom + Sizes.size96,
                  ),
                  itemBuilder: ((context, index) {
                    final message = messageList[index];
                    final isMine =
                        message.userId == ref.watch(authRepo).user!.uid;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: isMine
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(
                            Sizes.size14,
                          ),
                          decoration: BoxDecoration(
                            color: isMine
                                ? Colors.blue
                                : Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(Sizes.size20),
                              topRight: const Radius.circular(Sizes.size20),
                              bottomLeft: Radius.circular(
                                isMine ? Sizes.size20 : Sizes.size5,
                              ),
                              bottomRight: Radius.circular(
                                !isMine ? Sizes.size20 : Sizes.size5,
                              ),
                            ),
                          ),
                          child: Text(
                            message.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: Sizes.size16,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  separatorBuilder: ((context, index) => Gaps.v10),
                  itemCount: data.length,
                );
              }),
              error: (error, stackTrace) => Center(
                    child: Text(
                      error.toString(),
                    ),
                  ),
              loading: () => const Center(child: CircularProgressIndicator())),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: BottomAppBar(
                color: Colors.grey.shade100,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: TextField(
                          controller: _editingController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: Sizes.size10,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  FaIcon(
                                    FontAwesomeIcons.faceSmile,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade400,
                      ),
                      padding: const EdgeInsets.all(9),
                      child: GestureDetector(
                        onTap: isLoading ? null : _onSendPressed,
                        child: FaIcon(
                          isLoading
                              ? FontAwesomeIcons.hourglass
                              : FontAwesomeIcons.solidPaperPlane,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Gaps.h20,
                  ],
                )),
          )
        ],
      ),
    );
  }
}
