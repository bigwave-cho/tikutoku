class UserProfileModel {
  final String uid;
  final String email;
  final String name;
  final String bio;
  final String link;
  final bool hasAvatar;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.bio,
    required this.link,
    required this.hasAvatar,
  });

  // 데이터가 없거나 잘못된 경우 제공할 기본값 제공 메서드.
  //https://velog.io/@bigwave-cho/Dart-%EB%8B%A4%ED%8A%B8-%EA%B8%B0%EC%B4%88#named-constructor-parameter:~:text=)%3B%0A%7D-,Named%20Constructor,-class%20Player%20%7B
  UserProfileModel.empty()
      : uid = "",
        email = "",
        name = "",
        bio = "",
        link = "",
        hasAvatar = false;

  //파이어스토어에서 가져온 json을 이용해서 model 초기화
  UserProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        email = json["email"],
        name = json["name"],
        bio = json["bio"],
        link = json["link"],
        hasAvatar = json["hasAvatar"];

  //파이어스토어는 json을 받으므로 json 변환 메서드
  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "bio": bio,
      "link": link,
      "hasAvatar": hasAvatar,
    };
  }

  // 필드를 수정하고 싶으면 수정하고싶은 값만 전달하면 됨.
  UserProfileModel copyWith({
    final String? uid,
    final String? email,
    final String? name,
    final String? bio,
    final String? link,
    final bool? hasAvatar,
  }) {
    return UserProfileModel(
      // this. : uid는 파라미터로부터, this.uid는 model 클래스에서 온 것임을 확실히 나타냄
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      link: link ?? this.link,
      hasAvatar: hasAvatar ?? this.hasAvatar,
    );
  }
}
/*
 'copyWith'는 Flutter에서 사용하는 메소드 중 하나로, 기존 객체를 복제하고 일부 속성을 수정하여 새로운 객체를 생성하는 기능을 합니다.

일반적으로 객체의 속성을 변경할 때, 해당 객체를 직접 수정하는 방식으로 처리할 수 있습니다. 그러나, 이 방식은 객체의 불변성(immutability)을 보장하지 않기 때문에 예상치 못한 결과를 초래할 수 있습니다.

'copyWith'는 이러한 문제를 해결하기 위한 방법으로, 불변성을 보장하면서 객체의 일부 속성을 변경할 수 있도록 해줍니다. 이는 객체 지향 프로그래밍에서 매우 중요한 개념 중 하나로, 객체의 불변성을 유지하면서 객체를 다루는 것이 코드의 안정성과 가독성을 향상시키는 데 도움이 됩니다.
 */
