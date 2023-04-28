import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//platformBrightness가 dark인지 light인지 파악해서 다크모드 여부 반환
bool isDarkMode(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.dark;

void showFirebaseErrorSnack(BuildContext context, Object? error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
      ),
      content:
          Text((error as FirebaseException).message ?? "Something went wrong!"),
    ),
  );
}

/*
위 코드에 대한 설명
 // snackbar를 띄우는 코드는 context가 필요하니 context도 받아오자(위젯의 트리 위치를 파악)

      //(state.error as FirebaseException).message
      // dart에게 FirebaseExceptoin임을 알려주고 에러 message를 뽑아내자
      final snack = SnackBar(
        content: Text((state.error as FirebaseException).message ??
            "Something went wrong!"),
      );

      ScaffoldMessenger.of(context).showSnackBar(snack);
*/