class Product {
  final num? id;
  final String? name;
  final String? size;
  final num? costPrice;
  final num? quantity;
  final double? salePrice;
  final num? catId;
  final num? storeId;
  final String? detail;
  final String? mediaFileIds;
  final bool? isFeatured;
  final num? posId;
  final num? currentStock;
  final String? barcode;
  final String? productImageUrl;
  final String? productImageFullUrl;
  final num? mediaFileId;
  final DateTime? addedOn;
  final num? addedBy;
  final DateTime? modifiedOn;
  final num? modifiedBy;
  final String? categoryName;
  final String? storeName;

  Product({
    this.id,
    this.name,
    this.size,
    this.costPrice,
    this.quantity,
    this.salePrice,
    this.catId,
    this.currentStock,
    this.storeId,
    this.detail,
    this.mediaFileIds,
    this.isFeatured,
    this.posId,
    this.barcode,
    this.productImageUrl,
    this.productImageFullUrl,
    this.mediaFileId,
    this.addedOn,
    this.addedBy,
    this.modifiedOn,
    this.modifiedBy,
    this.categoryName,
    this.storeName,
  });

  String get formattedCostPrice => costPrice?.toStringAsFixed(2) ?? '0.00';
  String get formattedSalePrice => salePrice?.toStringAsFixed(2) ?? '0.00';

  Product copyWith({
    num? id,
    String? name,
    String? size,
    num? costPrice,
    num? quantity,
    double? salePrice,
    num? catId,
    num? currentStock,
    num? storeId,
    String? detail,
    String? mediaFileIds,
    bool? isFeatured,
    num? posId,
    String? barcode,
    String? productImageUrl,
    String? productImageFullUrl,
    num? mediaFileId,
    DateTime? addedOn,
    num? addedBy,
    DateTime? modifiedOn,
    num? modifiedBy,
    String? categoryName,
    String? storeName,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      size: size ?? this.size,
      costPrice: costPrice ?? this.costPrice,
      quantity: quantity ?? this.quantity,
      salePrice: salePrice ?? this.salePrice,
      catId: catId ?? this.catId,
      currentStock: currentStock ?? this.currentStock,
      storeId: storeId ?? this.storeId,
      detail: detail ?? this.detail,
      mediaFileIds: mediaFileIds ?? this.mediaFileIds,
      isFeatured: isFeatured ?? this.isFeatured,
      posId: posId ?? this.posId,
      barcode: barcode ?? this.barcode,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      productImageFullUrl: productImageFullUrl ?? this.productImageFullUrl,
      mediaFileId: mediaFileId ?? this.mediaFileId,
      addedOn: addedOn ?? this.addedOn,
      addedBy: addedBy ?? this.addedBy,
      modifiedOn: modifiedOn ?? this.modifiedOn,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      categoryName: categoryName ?? this.categoryName,
      storeName: storeName ?? this.storeName,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      size: json['size'],
      quantity: json['quantity'],
      costPrice: json['costPrice'],
      salePrice: json['salePrice']?.toDouble(),
      catId: json['catId'],
      currentStock: json['currentStock'],
      storeId: json['storeId'],
      detail: json['detail'],
      mediaFileIds: json['mediaFileIds'],
      isFeatured: json['isFeatured'],
      posId: json['posId'],
      barcode: json['barcode'],
      productImageUrl: json['productImageUrl'],
      productImageFullUrl: json['productImageFullUrl'],
      mediaFileId: json['mediaFileId'],
      addedOn: json['addedOn'] == null ? null : DateTime.parse(json['addedOn']),
      addedBy: json['addedBy'],
      modifiedOn: json['modifiedOn'] == null ? null : DateTime.parse(json['modifiedOn']),
      modifiedBy: json['modifiedBy'],
      categoryName: json['categoryName'],
      storeName: json['storeName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'size': size,
      'costPrice': costPrice,
      'quantity': quantity,
      'salePrice': salePrice,
      'catId': catId,
      'currentStock': currentStock,
      'storeId': storeId,
      'detail': detail,
      'mediaFileIds': mediaFileIds,
      'isFeatured': isFeatured,
      'posId': posId,
      'barcode': barcode,
      'productImageUrl': productImageUrl,
      'productImageFullUrl': productImageFullUrl,
      'mediaFileId': mediaFileId,
      'addedOn': addedOn?.toIso8601String(),
      'addedBy': addedBy,
      'modifiedOn': modifiedOn?.toIso8601String(),
      'modifiedBy': modifiedBy,
      'categoryName': categoryName,
      'storeName': storeName,
    };
  }
}
