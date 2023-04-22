import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          const AboutListTile(applicationName: "TIKUTOKU"),
        ],
      ),
    );
  }
}
