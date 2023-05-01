class UserProfileModel {
  final String uid;
  final String email;
  final String name;
  final String bio;
  final String link;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.bio,
    required this.link,
  });

  // 데이터가 없거나 잘못된 경우 제공할 기본값 제공 메서드.
  //https://velog.io/@bigwave-cho/Dart-%EB%8B%A4%ED%8A%B8-%EA%B8%B0%EC%B4%88#named-constructor-parameter:~:text=)%3B%0A%7D-,Named%20Constructor,-class%20Player%20%7B
  UserProfileModel.empty()
      : uid = "",
        email = "",
        name = "",
        bio = "",
        link = "";
}
