# tiktok

- IOS 실 기기 세팅
  https://docs.flutter.dev/get-started/install/macos#deploy-to-ios-devices

  1. 개발자 모드 활성화
  2. ... xcode 이런거 깔려있으니 생략
  3. Runner.xcworkspace를 xcode로 오픈
  4. Runner -> Signing&Capabilities -> Team 선택, 번들 아이덴티파이어 설정
  5. play 버튼(빌드)
  6. vscode에서 내 폰 선택해서 빌드하면 됨.

  //카메라 준비 : flutter pub add camera
  /\*

- camera
  https://pub.dev/packages/camera

<key>NSCameraUsageDescription</key>
<string>your usage description here</string>
<key>NSMicrophoneUsageDescription</key>
<string>your usage description here</string>

:PList에 위 코드 추가하면 camera에서 permission을 알아서 물어봐줌

하지만 퍼미션을 더 쉽게 요청할 수 있는 패키지를 추가해서 사용해보자.

- permission
  https://pub.dev/packages/permission_handler

젠장!! 퍼미션 요청 알림이 안뜬다
https://velog.io/@manpkh95/Flutter-iOS-%EA%B6%8C%ED%95%9C-%EB%B0%9B%EA%B8%B0-Permission-Handler-Package
이거 보면서 적용 해결 완료.

## inherited Widget

inherited Widget에서 정의한 값들은 다른 하위 트리 위젯으로 드릴링 할 필요 없이
바로 접근할 수 있다.

1. inherited widget 만들기
2. 머터리얼앱 감싸기
3. of함수 만들어서 해당 InheritedWidget class의 값에 접근하기.

## MVVM 아키텍쳐

아래 것들 대문자 따서.

Model : autoMuted, autePlay.. 데이터
ViewModel : View와 model 연결부
View : 사용자가 볼 수 있고 이벤트를 받는 부분 - screen

EX)
View - videoTimeline
VM - API에 데이터 요청
Model - 모델을 구성해서 Viewmodel에게
뷰모델은 다시 뷰에게 전달

뷰에서 이벤트가 발생하면
뷰모델이 이벤트를 받아 모델을 이용해 데이터를 수정/요청하여
다시 화면에 반영되도록 뷰에 돌려줌

"+" Repository : 데이터 저장(firebase와 통신)

## Riverpod

https://docs-v2.riverpod.dev/docs/getting_started

Riverpod은 Provider의 애너그램이다.
프로바이더의 업글 버전

리버팟은 위젯트리 밖에서도 존재할 수 있어 플러터와 독립적 관계이다.

## firebase CLI

flutterfire configure로 파베 연동을 하고

필요한 파베 플러그인..(ex. firestore)을 설치하고 나면

flutterfire configure를 다시 실행 시켜서 업뎃 확인

https://firebase.google.com/docs/flutter/setup?hl=ko&platform=android

/_이 명령어를 실행하면 Flutter 앱의 Firebase 구성이 최신 상태인지 확인하고
Android의 Crashlytics 및 Performance Monitoring의 경우 필수 Gradle 플러그인이 앱에 추가됩니다. _/
