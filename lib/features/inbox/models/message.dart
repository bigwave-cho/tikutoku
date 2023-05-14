class MessageModel {
  final String text;
  final String userId;
  final int createAt;

  MessageModel({
    required this.text,
    required this.userId,
    required this.createAt,
  });

  MessageModel.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        createAt = json['createAt'],
        userId = json['userId'];

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "userId": userId,
      "createdAt": createAt,
    };
  }
}
