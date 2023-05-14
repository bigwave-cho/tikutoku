class ChatroomModel {
  final String personA;
  final String personB;

  ChatroomModel({
    required this.personA,
    required this.personB,
  });

  ChatroomModel.fromJson(Map<String, dynamic> json)
      : personA = json["personA"],
        personB = json["personB"];

  Map<String, dynamic> toJson() {
    return {
      "personA": personA,
      "personB": personB,
    };
  }
}
