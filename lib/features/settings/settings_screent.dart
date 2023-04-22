import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = false;
  void _onNotificationsChanged(bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _notifications = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
        ),
      ),
      body: ListView(
        children: [
          //이거 추천함. ㅋ
          SwitchListTile.adaptive(
              value: _notifications, onChanged: _onNotificationsChanged),
          // 플랫폼에 따라 스이치 변경
          Switch.adaptive(
              value: _notifications, onChanged: _onNotificationsChanged),
          //애플스타일 스위치
          CupertinoSwitch(
              value: _notifications, onChanged: _onNotificationsChanged),
          SwitchListTile(
              value: _notifications,
              onChanged: _onNotificationsChanged,
              title: const Text("Enable notifications")),
          //안드스타일 스위치
          Switch(value: _notifications, onChanged: _onNotificationsChanged),
          //그냥 체크박스
          Checkbox(
            value: _notifications,
            onChanged: _onNotificationsChanged,
          ),
          //리스트타일 스타일 체크박스
          CheckboxListTile(
            value: _notifications,
            onChanged: _onNotificationsChanged,
            title: const Text(
              "Enable notifications",
            ),
            checkColor: Colors.white,
            activeColor: Colors.black,
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
              print(date); //2023-04-22 00:00:00.000

              //시간피커
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              print(time); //TimeOfDay(22:46)

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
              print(booking);
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
                            print('hhk');
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
