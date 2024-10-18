class Snippets {
  final num? id;
  final String? key;
  final String? content;
  final String? language;
  final num? addedBy;
  final num? modifiedBy;
  final DateTime? addedOn;
  final DateTime? modifiedOn;
  final num? mediaFileId;
  final String? mediaFileUrl;
  final String? mediaFileFullUrl;
  final String? submittedBy;
  final String? lstModifiedBy;

  Snippets({
    this.id,
    this.key,
    this.content,
    this.language,
    this.addedBy,
    this.modifiedBy,
    this.addedOn,
    this.modifiedOn,
    this.mediaFileId,
    this.mediaFileUrl,
    this.mediaFileFullUrl,
    this.submittedBy,
    this.lstModifiedBy,
  });

  Snippets copyWith({
    num? id,
    String? key,
    String? content,
    String? language,
    num? addedBy,
    num? modifiedBy,
    DateTime? addedOn,
    DateTime? modifiedOn,
    num? mediaFileId,
    String? mediaFileUrl,
    String? mediaFileFullUrl,
    String? submittedBy,
    String? lstModifiedBy,
  }) {
    return Snippets(
      id: id ?? this.id,
      key: key ?? this.key,
      content: content ?? this.content,
      language: language ?? this.language,
      addedBy: addedBy ?? this.addedBy,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      addedOn: addedOn ?? this.addedOn,
      modifiedOn: modifiedOn ?? this.modifiedOn,
      mediaFileId: mediaFileId ?? this.mediaFileId,
      mediaFileUrl: mediaFileUrl ?? this.mediaFileUrl,
      mediaFileFullUrl: mediaFileFullUrl ?? this.mediaFileFullUrl,
      submittedBy: submittedBy ?? this.submittedBy,
      lstModifiedBy: lstModifiedBy ?? this.lstModifiedBy,
    );
  }

  factory Snippets.fromJson(Map<String, dynamic> json) {
    return Snippets(
      id: json['id'],
      key: json['key'],
      content: json['content'],
      language: json['language'],
      addedBy: json['addedBy'],
      modifiedBy: json['modifiedBy'],
      addedOn: json['addedOn'] == null ? null : DateTime.parse(json['addedOn']),
      modifiedOn: json['modifiedOn'] == null ? null : DateTime.parse(json['modifiedOn']),
      mediaFileId: json['mediaFileId'],
      mediaFileUrl: json['mediaFileUrl'],
      mediaFileFullUrl: json['mediaFileFullUrl'],
      submittedBy: json['submittedBy'],
      lstModifiedBy: json['lstModifiedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'content': content,
      'language': language,
      'addedBy': addedBy,
      'modifiedBy': modifiedBy,
      'addedOn': addedOn?.toIso8601String(),
      'modifiedOn': modifiedOn?.toIso8601String(),
      'mediaFileId': mediaFileId,
      'mediaFileUrl': mediaFileUrl,
      'mediaFileFullUrl': mediaFileFullUrl,
      'submittedBy': submittedBy,
      'lstModifiedBy': lstModifiedBy,
    };
  }
}
