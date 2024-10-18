class NotificationRes {
  final num? id;
  final String? title;
  final num? systemObjectId;
  final num? systemObjectRecordId;
  final String? content;
  final DateTime? addedOn;
  final num? byUserId;
  final String? forUserIds;
  final String? readByUserIds;
  final String? fileFullUrl;
  final bool? isRead;

  NotificationRes({
    this.id,
    this.title,
    this.systemObjectId,
    this.systemObjectRecordId,
    this.content,
    this.addedOn,
    this.byUserId,
    this.forUserIds,
    this.readByUserIds,
    this.fileFullUrl,
    this.isRead,
  });

  bool get isToday {
    if (addedOn == null) return false;
    final today = DateTime.now();
    return addedOn!.year == today.year && addedOn!.month == today.month && addedOn!.day == today.day;
  }

  bool get isYesterday {
    if (addedOn == null) return false;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return addedOn!.year == yesterday.year && addedOn!.month == yesterday.month && addedOn!.day == yesterday.day;
  }

  bool get isOlder {
    if (addedOn == null) return true;
    final today = DateTime.now();
    final difference = today.difference(addedOn!);
    return difference.inDays > 1;
  }

  String get formatTimePassed {
    if (addedOn == null) return 'N/A';
    final now = DateTime.now();
    final difference = now.difference(addedOn!.toLocal()).abs();

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inHours < 48) {
      return '1d';
    } else {
      return addedOn.toString().substring(0, 10);
    }
  }

  NotificationRes copyWith({
    num? id,
    String? title,
    num? systemObjectId,
    num? systemObjectRecordId,
    String? content,
    DateTime? addedOn,
    num? byUserId,
    String? forUserIds,
    String? readByUserIds,
    String? fileFullUrl,
    bool? isRead,
  }) {
    return NotificationRes(
      id: id ?? this.id,
      title: title ?? this.title,
      systemObjectId: systemObjectId ?? this.systemObjectId,
      systemObjectRecordId: systemObjectRecordId ?? this.systemObjectRecordId,
      content: content ?? this.content,
      addedOn: addedOn ?? this.addedOn,
      byUserId: byUserId ?? this.byUserId,
      forUserIds: forUserIds ?? this.forUserIds,
      readByUserIds: readByUserIds ?? this.readByUserIds,
      fileFullUrl: fileFullUrl ?? this.fileFullUrl,
      isRead: isRead ?? this.isRead,
    );
  }

  factory NotificationRes.fromJson(Map<String, dynamic> json) {
    return NotificationRes(
      id: json['id'],
      title: json['title'],
      systemObjectId: json['systemObjectId'],
      systemObjectRecordId: json['systemObjectRecordId'],
      content: json['content'],
      addedOn: json['addedOn'] == null ? null : DateTime.parse(json['addedOn']),
      byUserId: json['byUserId'],
      forUserIds: json['forUserIds'],
      readByUserIds: json['readByUserIds'],
      fileFullUrl: json['fileFullUrl'],
      isRead: json['isRead'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'systemObjectId': systemObjectId,
      'systemObjectRecordId': systemObjectRecordId,
      'content': content,
      'addedOn': addedOn?.toIso8601String(),
      'byUserId': byUserId,
      'forUserIds': forUserIds,
      'readByUserIds': readByUserIds,
      'fileFullUrl': fileFullUrl,
      'isRead': isRead,
    };
  }
}
