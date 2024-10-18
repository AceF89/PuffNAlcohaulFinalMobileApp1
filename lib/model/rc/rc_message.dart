class RcMessage {
  final String? id;
  final String? userId;
  final String? username;
  final String? userFullName;
  final String? msg;
  final DateTime? createdAt;

  RcMessage({
    this.id,
    this.userId,
    this.msg,
    this.createdAt,
    this.username,
    this.userFullName,
  });

  RcMessage copyWith({
    String? id,
    String? userId,
    String? username,
    String? userFullName,
    String? msg,
    DateTime? createdAt,
  }) {
    return RcMessage(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userFullName: userFullName ?? this.userFullName,
      msg: msg ?? this.msg,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory RcMessage.fromJson(Map<String, dynamic> json) {
    return RcMessage(
      id: json["id"],
      userId: json["userId"],
      username: json["username"],
      userFullName: json["userFullName"],
      msg: json["msg"],
      createdAt: json["createdAt"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "username": username,
      "userFullName": userFullName,
      "msg": msg,
      "createdAt": createdAt,
    };
  }
}
