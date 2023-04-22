import 'package:flutter/material.dart';

//platformBrightness가 dark인지 light인지 파악해서 다크모드 여부 반환
bool isDarkMode(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.dark;
