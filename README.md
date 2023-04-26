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
