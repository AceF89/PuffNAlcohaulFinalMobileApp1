class FileUploadResponse {
  final num? id;
  final String? fileName;
  final String? fileUrl;
  final String? fullFileUrl;
  final DateTime? addedOn;

  FileUploadResponse({
    this.id,
    this.fileName,
    this.fileUrl,
    this.fullFileUrl,
    this.addedOn,
  });

  FileUploadResponse copyWith({
    num? id,
    String? fileName,
    String? fileUrl,
    String? fullFileUrl,
    DateTime? addedOn,
  }) {
    return FileUploadResponse(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      fullFileUrl: fullFileUrl ?? this.fullFileUrl,
      addedOn: addedOn ?? this.addedOn,
    );
  }

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) {
    return FileUploadResponse(
      id: json['id'],
      fileName: json['fileName'],
      fileUrl: json['fileUrl'],
      fullFileUrl: json['fullFileUrl'],
      addedOn: json['addedOn'] == null ? null : DateTime.parse(json['addedOn']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'fullFileUrl': fullFileUrl,
      'addedOn': addedOn?.toIso8601String(),
    };
  }
}
