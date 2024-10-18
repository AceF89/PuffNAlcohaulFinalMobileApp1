class ProductCategories {
  final num? id;
  final String? name;
  final num? iconFileId;
  final num? loyaltyPoints;
  final bool? isActive;
  final DateTime? addedOn;
  final num? addedBy;
  final DateTime? modifiedOn;
  final num? modifiedBy;
  final String? fullIconFileUrl;

  ProductCategories({
    this.id,
    this.name,
    this.iconFileId,
    this.loyaltyPoints,
    this.isActive,
    this.addedOn,
    this.addedBy,
    this.modifiedOn,
    this.modifiedBy,
    this.fullIconFileUrl,
  });

  ProductCategories copyWith({
    int? id,
    String? name,
    int? iconFileId,
    int? loyaltyPoints,
    bool? isActive,
    DateTime? addedOn,
    int? addedBy,
    DateTime? modifiedOn,
    int? modifiedBy,
    String? fullIconFileUrl,
  }) {
    return ProductCategories(
      id: id ?? this.id,
      name: name ?? this.name,
      iconFileId: iconFileId ?? this.iconFileId,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      isActive: isActive ?? this.isActive,
      addedOn: addedOn ?? this.addedOn,
      addedBy: addedBy ?? this.addedBy,
      modifiedOn: modifiedOn ?? this.modifiedOn,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      fullIconFileUrl: fullIconFileUrl ?? this.fullIconFileUrl,
    );
  }

  factory ProductCategories.fromJson(Map<String, dynamic> json) {
    return ProductCategories(
      id: json['id'],
      name: json['name'],
      iconFileId: json['iconFileId'],
      loyaltyPoints: json['loyaltyPoints'],
      isActive: json['isActive'],
      addedOn: json['addedOn'] == null ? null : DateTime.parse(json['addedOn']),
      addedBy: json['addedBy'],
      modifiedOn: json['modifiedOn'] == null
          ? null
          : DateTime.parse(json['modifiedOn']),
      modifiedBy: json['modifiedBy'],
      fullIconFileUrl: json['fullIconFileUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconFileId': iconFileId,
      'loyaltyPoints': loyaltyPoints,
      'isActive': isActive,
      'addedOn': addedOn?.toIso8601String(),
      'addedBy': addedBy,
      'modifiedOn': modifiedOn?.toIso8601String(),
      'modifiedBy': modifiedBy,
      'fullIconFileUrl': fullIconFileUrl,
    };
  }
}
