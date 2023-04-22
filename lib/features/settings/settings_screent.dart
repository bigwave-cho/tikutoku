import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      body: ListView(
        children: [
          ListTile(
            //showAboutDialog() 내장함수 . 앱에 대한 정보를 띄울 수 있음.
            //오픈소스라이브러리에 대한 정보도 다 구현돼있어서 일일이 목록 만들 필요 없어짐
            onTap: (() => showAboutDialog(
                  context: context,
                  applicationVersion: "1.0",
                  applicationLegalese: "All rights reserved.",
                  applicationName: "TIKUTOKU",
                  applicationIcon: const FaIcon(
                    FontAwesomeIcons.cableCar,
                  ),
                )),
            title: const Text(
              "About",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text("About this app..."),
          ),
          // AboutListTile: 함수 만들필요 없음 걍 클릭 ㄱㄴ
          const AboutListTile(applicationName: "TIKUTOKU"),
        ],
      ),
    );
  }
}
