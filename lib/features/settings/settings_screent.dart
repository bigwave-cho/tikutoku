import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok/features/videos/view_models/playback_config_vm.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  //business logic은 이론상 따로 둬야함. 삭제 and stf -> stl
  // Riverpod의 두 가지 위젯 : ConsumerWidget / ConsumerStatefulWidget
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //ref : Provider를 읽거나 수정 레퍼런스
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            //ref.watch(provider).값
            value: ref.watch(playbackConfigProivder).muted,
            onChanged: (value) =>
                ref.read(playbackConfigProivder.notifier).setMuted(value),
            title: const Text('Enable Muted'),
            subtitle: const Text("Muted keep you calm."),
          ),
          SwitchListTile.adaptive(
            //watch는 값을 리슨하고 있다가 변화가 있으면 리빌드
            value: ref.watch(playbackConfigProivder).autoplay,
            onChanged: (value) =>
                ref.read(playbackConfigProivder.notifier).setAutoplay(value),
            /*
              ref.read(playbackConfigProivder) : provider에 접근
              ref.read(playbackConfigProivder.notifire) : notifire class(VM)에 접근
              */
            title: const Text('Enable Autoplay'),
            subtitle: const Text("Enable it, if you want autoplay!"),
          ),
          SwitchListTile.adaptive(
            value: false,
            onChanged: (value) {},
            title: const Text('Enable Darkmode'),
            subtitle: const Text("dark dark!!"),
          ),
          ListTile(
            onTap: () async {
              //날짜피커
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1987),
                lastDate: DateTime(2030),
              );
              debugPrint('$date'); //2023-04-22 00:00:00.000

              //시간피커
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              debugPrint('$time'); //TimeOfDay(22:46)

              final booking = await showDateRangePicker(
                context: context,
                firstDate: DateTime(1987),
                lastDate: DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData(
                      appBarTheme: const AppBarTheme(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              debugPrint("$booking");
            },
            title: const Text("What is your birthday?"),
          ),
          ListTile(
            title: const Text(
              "Log out (ios and android)",
            ),
            textColor: Colors.red,
            onTap: () async {
              //ios 스타일
              await showCupertinoDialog(
                context: context,
                builder: ((context) => CupertinoAlertDialog(
                      title: const Text("Are you sure?"),
                      content: const Text("Plz don't go!!"),
                      actions: [
                        CupertinoDialogAction(
                          onPressed: (() => Navigator.of(context).pop()),
                          child: const Text(
                            "No",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        CupertinoDialogAction(
                          onPressed: () {
                            ref.read(authRepo).signOut();

                            // router에서 authState watch를 주석처리하고
                            // 아래처럼 수동으로 보내주기
                            // 현 상태가 로그인하면 바로 홈으로 가는지라
                            // 튜토리얼을 거치지 않고 있어 수정할 예정.
                            context.go('/');
                          },
                          //isDestructiveAction
                          //: true면 해당 액션이 중요하다고 판단, 빨간 텍스트로 표시됨
                          isDestructiveAction: true,
                          child: const Text(
                            "Yes",
                          ),
                        ),
                      ],
                    )),
              );
              // 커스텀(안드스탈)
              await showDialog(
                context: context,
                builder: ((context) => AlertDialog(
                      icon: const FaIcon(
                        FontAwesomeIcons.skull,
                      ),
                      title: const Text("Are you sure?"),
                      content: const Text("Plz don't go!!"),
                      actions: [
                        IconButton(
                          onPressed: (() => Navigator.of(context).pop()),
                          icon: const FaIcon(
                            FontAwesomeIcons.car,
                          ),
                        ),
                        TextButton(
                          onPressed: (() => Navigator.of(context).pop()),
                          child: const Text(
                            "Yes",
                          ),
                        ),
                      ],
                    )),
              );
            },
          ),
          ListTile(
            title: const Text(
              "Log out (ios / bottom)",
            ),
            textColor: Colors.red,
            onTap: () async {
              //아래에서 모달이 팝업됨
              // dialog와 차이는 영역 밖을 클릭하면 pop됨
              //ShowCupertinoDialog 쓰면 위쪽에 뜸
              await showCupertinoModalPopup(
                context: context,
                //CupertinoAlertDialog, AlertDialog, 도 잘 작동
                builder: ((context) => CupertinoActionSheet(
                      title: const Text("Are you sure?"),
                      message: const Text("plz dont ogogogogg"),
                      // content: const Text("Plz don't go!!"),
                      actions: [
                        //sheet용
                        CupertinoActionSheetAction(
                          onPressed: () {
                            debugPrint('hhk');
                          },
                          isDefaultAction: true, //글자가 좀 더 굵음
                          child: const Text(
                            "Not log out!",
                          ),
                        ),
                        CupertinoActionSheetAction(
                          onPressed: () {},
                          isDestructiveAction: true,
                          child: const Text(
                            "YES!!",
                          ),
                        ),

                        //dialog용 sheet에서도 작동하긴 함.
                        CupertinoDialogAction(
                          onPressed: (() => Navigator.of(context).pop()),
                          child: const Text(
                            "No",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        CupertinoDialogAction(
                          onPressed: (() => Navigator.of(context).pop()),
                          //isDestructiveAction
                          //: true면 해당 액션이 중요하다고 판단, 빨간 텍스트로 표시됨
                          isDestructiveAction: true,
                          child: const Text(
                            "Yes",
                          ),
                        ),
                      ],
                    )),
              );
            },
          ),
          const AboutListTile(applicationName: "TIKUTOKU"),
        ],
      ),
    );
  }
}
