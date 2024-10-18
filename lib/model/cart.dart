import 'package:alcoholdeliver/model/product.dart';

class Cart {
  final num? id;
  final num? placedBy;
  final DateTime? placedOn;
  final num? storeId;
  final dynamic driverId;
  final String? status;
  final num? modifiedBy;
  final DateTime? modifiedOn;
  final dynamic refNo;
  final dynamic paymentMethod;
  final bool? isCart;
  final DateTime? scheduledDateTime;
  final num? tip;
  final List<OrderItem>? orderItems;
  final List<Product>? modeledProducts;
  final num? addedBy;
  final dynamic storeName;
  final dynamic driverName;
  final String? placedByName;
  final String? productName;
  final num? quantity;
  final double? price;
  final String? categoryName;
  final String? storeAddress;

  Cart({
    this.id,
    this.placedBy,
    this.placedOn,
    this.storeId,
    this.driverId,
    this.status,
    this.modifiedBy,
    this.modifiedOn,
    this.refNo,
    this.paymentMethod,
    this.modeledProducts,
    this.isCart,
    this.scheduledDateTime,
    this.tip,
    this.orderItems,
    this.addedBy,
    this.storeName,
    this.driverName,
    this.placedByName,
    this.productName,
    this.quantity,
    this.price,
    this.categoryName,
    this.storeAddress,
  });

  Cart copyWith({
    num? id,
    num? placedBy,
    DateTime? placedOn,
    num? storeId,
    dynamic driverId,
    String? status,
    num? modifiedBy,
    DateTime? modifiedOn,
    dynamic refNo,
    dynamic paymentMethod,
    bool? isCart,
    DateTime? scheduledDateTime,
    num? tip,
    List<OrderItem>? orderItems,
    List<Product>? modeledProducts,
    num? addedBy,
    dynamic storeName,
    dynamic driverName,
    String? placedByName,
    String? productName,
    num? quantity,
    double? price,
    String? categoryName,
    String? storeAddress,
  }) {
    return Cart(
      id: id ?? this.id,
      placedBy: placedBy ?? this.placedBy,
      placedOn: placedOn ?? this.placedOn,
      storeId: storeId ?? this.storeId,
      driverId: driverId ?? this.driverId,
      status: status ?? this.status,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      modifiedOn: modifiedOn ?? this.modifiedOn,
      refNo: refNo ?? this.refNo,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isCart: isCart ?? this.isCart,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
      tip: tip ?? this.tip,
      orderItems: orderItems ?? this.orderItems,
      addedBy: addedBy ?? this.addedBy,
      storeName: storeName ?? this.storeName,
      driverName: driverName ?? this.driverName,
      placedByName: placedByName ?? this.placedByName,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      categoryName: categoryName ?? this.categoryName,
      modeledProducts: modeledProducts ?? this.modeledProducts,
      storeAddress: storeAddress ?? this.storeAddress,
    );
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    List<OrderItem> orderItems = [];
    if (json['orderItems'] != null) {
      orderItems = List<OrderItem>.from(json['orderItems']!.map((x) => OrderItem.fromJson(x)));
    }

    List<Product> products = [];
    for (final e in orderItems) {
      products.add(Product(
        id: e.productId,
        name: e.productName,
        costPrice: e.price,
        productImageFullUrl: e.productImageFullUrl,
        quantity: e.quantity,
      ));
    }

    return Cart(
      id: json['id'],
      placedBy: json['placedBy'],
      placedOn: json['placedOn'] == null ? null : DateTime.parse(json['placedOn']),
      storeId: json['storeId'],
      driverId: json['driverId'],
      status: json['status'],
      modifiedBy: json['modifiedBy'],
      modifiedOn: json['modifiedOn'] == null ? null : DateTime.parse(json['modifiedOn']),
      refNo: json['refNo'],
      paymentMethod: json['paymentMethod'],
      isCart: json['isCart'],
      scheduledDateTime: json['scheduledDateTime'] == null ? null : DateTime.parse(json['scheduledDateTime']),
      tip: json['tip'],
      modeledProducts: products,
      orderItems: orderItems,
      addedBy: json['addedBy'],
      storeName: json['storeName'],
      driverName: json['driverName'],
      placedByName: json['placedByName'],
      productName: json['productName'],
      quantity: json['quantity'],
      price: json['price']?.toDouble(),
      categoryName: json['categoryName'],
      storeAddress: json['storeAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'placedBy': placedBy,
      'placedOn': placedOn?.toIso8601String(),
      'storeId': storeId,
      'driverId': driverId,
      'status': status,
      'modifiedBy': modifiedBy,
      'modifiedOn': modifiedOn?.toIso8601String(),
      'refNo': refNo,
      'paymentMethod': paymentMethod,
      'isCart': isCart,
      'scheduledDateTime': scheduledDateTime?.toIso8601String(),
      'tip': tip,
      'orderItems': orderItems == null ? [] : List<dynamic>.from(orderItems!.map((x) => x.toJson())),
      'addedBy': addedBy,
      'storeName': storeName,
      'driverName': driverName,
      'placedByName': placedByName,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'categoryName': categoryName,
      'storeAddress': storeAddress,
    };
  }
}

class OrderItem {
  final num? id;
  final num? orderId;
  final num? productId;
  final double? price;
  final num? quantity;
  final num? currentStock;
  final String? productName;
  final double? productPrice;
  final String? displayValue;
  final dynamic productImageUrl;
  final String? productImageFullUrl;

  OrderItem({
    this.id,
    this.orderId,
    this.productId,
    this.price,
    this.quantity,
    this.currentStock,
    this.productName,
    this.productPrice,
    this.displayValue,
    this.productImageUrl,
    this.productImageFullUrl,
  });

  OrderItem copyWith({
    num? id,
    num? orderId,
    num? productId,
    double? price,
    num? currentStock,
    num? quantity,
    String? productName,
    double? productPrice,
    String? displayValue,
    dynamic productImageUrl,
    String? productImageFullUrl,
  }) {
    return OrderItem(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      currentStock: currentStock ?? this.currentStock,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      displayValue: displayValue ?? this.displayValue,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      productImageFullUrl: productImageFullUrl ?? this.productImageFullUrl,
    );
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['orderId'],
      productId: json['productId'],
      price: json['price']?.toDouble(),
      quantity: json['quantity'],
      currentStock: json['currentStock'],
      productName: json['productName'],
      productPrice: json['productPrice']?.toDouble(),
      displayValue: json['displayValue'],
      productImageUrl: json['productImageUrl'],
      productImageFullUrl: json['productImageFullUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'price': price,
      'quantity': quantity,
      'currentStock': currentStock,
      'productName': productName,
      'productPrice': productPrice,
      'displayValue': displayValue,
      'productImageUrl': productImageUrl,
      'productImageFullUrl': productImageFullUrl,
    };
  }
}
