import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class Order {
  final num? id;
  final num? placedBy;
  final DateTime? placedOn;
  final num? storeId;
  final num? driverId;
  final num? doorImageId;
  final String? status;
  final num? modifiedBy;
  final DateTime? modifiedOn;
  final String? refNo;
  final String? paymentMethod;
  final bool? isCart;
  final DateTime? scheduledDateTime;
  final num? pointRedeemed;
  final num? pointEarned;
  final num? tip;
  final List<OrderItem>? orderItems;
  final num? addedBy;
  final String? storeName;
  final String? storeAddress;
  final String? driverName;
  final String? placedByName;
  final String? productName;
  final String? doorImageFullUrl;
  final num? quantity;
  final double? subTotal;
  final double? totalTax;
  final String? deliveryFee;
  final num? serviceFee;
  final double? total;
  final String? categoryName;
  final String? productImageUrl;
  final String? productImageFullUrl;
  final String? profilePicUrl;
  final String? profilePicFullUrl;
  final String? address;
  final String? rcChannelId;
  final String? firebaseItemId;
  final String? type;
  final num? startLatitude;
  final num? endLatitude;
  final num? startLongitude;
  final num? endLongitude;
  final num? driverLongitude;
  final num? driverLatitude;
  final bool? isDelivering;
  final String? scheduleType;
  final String? fullFrontLicenseFileUrl;
  final String? fullBackLicenseFileUrl;
  final String? displayValues;
  final String? estimateTime;

  Order(
      {this.id,
      this.placedBy,
      this.placedOn,
      this.storeId,
      this.driverId,
      this.doorImageId,
      this.status,
      this.modifiedBy,
      this.modifiedOn,
      this.refNo,
      this.paymentMethod,
      this.doorImageFullUrl,
      this.isCart,
      this.scheduledDateTime,
      this.pointRedeemed,
      this.pointEarned,
      this.tip,
      this.orderItems,
      this.addedBy,
      this.storeName,
      this.storeAddress,
      this.driverName,
      this.placedByName,
      this.productName,
      this.quantity,
      this.subTotal,
      this.totalTax,
      this.deliveryFee,
      this.serviceFee,
      this.total,
      this.categoryName,
      this.productImageUrl,
      this.productImageFullUrl,
      this.profilePicUrl,
      this.profilePicFullUrl,
      this.address,
      this.firebaseItemId,
      this.type,
      this.startLatitude,
      this.endLatitude,
      this.startLongitude,
      this.endLongitude,
      this.rcChannelId,
      this.isDelivering,
      this.scheduleType,
      this.fullFrontLicenseFileUrl,
      this.fullBackLicenseFileUrl,
      this.displayValues,
      this.driverLatitude,
      this.driverLongitude,
      this.estimateTime});

  String get serviceFeeC {
    if (serviceFee == null) return 'Free';
    if (serviceFee == 0) return 'Free';
    return serviceFee?.toStringAsFixed(2) ?? '';
  }

  LatLng? get originCoordinate {
    if (startLatitude == null || startLongitude == null) return null;

    return LatLng(startLatitude!.toDouble(), startLongitude!.toDouble());
  }

  LatLng? get destinationCoordinate {
    if (endLatitude == null || endLongitude == null) return null;
    return LatLng(endLatitude!.toDouble(), endLongitude!.toDouble());
  }

  String? get formatedDate {
    if (placedOn == null) return null;

    DateFormat formatter = DateFormat('MM/dd/yy');
    return formatter.format(placedOn!);
  }

  String? get formatScheduledDateTime {
    if (scheduledDateTime == null) return null;

    //convert to local time
    final localDateTime = scheduledDateTime!.toLocal();
    final DateFormat formatter = DateFormat('MM/dd/yy HH:mm');
    return formatter.format(localDateTime);
  }

  String? get orderType {
    final sType = type?.toLowerCase();

    if (sType == null) return null;
    if (sType == 'pickup') return 'Pickup';
    if (sType != 'delivery') return 'N/A';

    final sScheduleType = scheduleType?.toLowerCase();
    if (sScheduleType == null) return 'Delivery';

    switch (sScheduleType) {
      case 'schedule':
        final time = formatScheduledDateTime;
        return time != null ? 'Delivery (Schedule $time)' : 'N/A';
      case 'asap':
        return 'Delivery (ASAP)';
      default:
        return 'Delivery';
    }
  }

  String? get statusDisplay {
    Map<String, String> statusDisplayMapping = {
      'paid': 'Paid',
      'pending': 'Pending',
      'rejected': 'Rejected',
      'accepted': 'Accepted',
      'pickedup': 'Picked Up',
      'cancelled': 'Cancelled',
      'delivered': 'Delivered',
      'preparing': 'Preparing',
      'delivering': 'Delivering',
      'readyforpickup': 'Ready For Pickup',
      'readyfordelivery': 'Ready For Delivery'
    };

    if (status == null) return null;
    return statusDisplayMapping[status?.toLowerCase()];
  }

  Order copyWith(
      {num? id,
      num? placedBy,
      DateTime? placedOn,
      num? storeId,
      num? driverId,
      num? doorImageId,
      String? status,
      num? modifiedBy,
      DateTime? modifiedOn,
      String? refNo,
      String? paymentMethod,
      String? doorImageFullUrl,
      bool? isCart,
      DateTime? scheduledDateTime,
      num? pointRedeemed,
      num? pointEarned,
      num? tip,
      List<OrderItem>? orderItems,
      num? addedBy,
      String? storeName,
      String? storeAddress,
      String? driverName,
      String? placedByName,
      String? productName,
      num? quantity,
      double? subTotal,
      double? totalTax,
      String? deliveryFee,
      num? serviceFee,
      double? total,
      String? categoryName,
      String? productImageUrl,
      String? productImageFullUrl,
      String? profilePicUrl,
      String? profilePicFullUrl,
      String? address,
      String? firebaseItemId,
      String? rcChannelId,
      String? type,
      String? scheduleType,
      String? fullFrontLicenseFileUrl,
      String? fullBackLicenseFileUrl,
      num? startLatitude,
      num? endLatitude,
      num? startLongitude,
      num? endLongitude,
      num? driverLatitude,
      num? driverLongitude,
      bool? isDelivering,
      String? displayValues,
      String? estimateTime}) {
    return Order(
        id: id ?? this.id,
        placedBy: placedBy ?? this.placedBy,
        placedOn: placedOn ?? this.placedOn,
        storeId: storeId ?? this.storeId,
        driverId: driverId ?? this.driverId,
        doorImageId: doorImageId ?? this.doorImageId,
        status: status ?? this.status,
        doorImageFullUrl: doorImageFullUrl ?? this.doorImageFullUrl,
        modifiedBy: modifiedBy ?? this.modifiedBy,
        modifiedOn: modifiedOn ?? this.modifiedOn,
        refNo: refNo ?? this.refNo,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        isCart: isCart ?? this.isCart,
        scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
        pointRedeemed: pointRedeemed ?? this.pointRedeemed,
        pointEarned: pointEarned ?? this.pointEarned,
        tip: tip ?? this.tip,
        orderItems: orderItems ?? this.orderItems,
        addedBy: addedBy ?? this.addedBy,
        storeName: storeName ?? this.storeName,
        storeAddress: storeAddress ?? this.storeAddress,
        driverName: driverName ?? this.driverName,
        placedByName: placedByName ?? this.placedByName,
        productName: productName ?? this.productName,
        quantity: quantity ?? this.quantity,
        subTotal: subTotal ?? this.subTotal,
        totalTax: totalTax ?? this.totalTax,
        deliveryFee: deliveryFee ?? this.deliveryFee,
        serviceFee: serviceFee ?? this.serviceFee,
        total: total ?? this.total,
        categoryName: categoryName ?? this.categoryName,
        productImageUrl: productImageUrl ?? this.productImageUrl,
        productImageFullUrl: productImageFullUrl ?? this.productImageFullUrl,
        profilePicUrl: profilePicUrl ?? this.profilePicUrl,
        profilePicFullUrl: profilePicFullUrl ?? this.profilePicFullUrl,
        address: address ?? this.address,
        firebaseItemId: firebaseItemId ?? this.firebaseItemId,
        type: type ?? this.type,
        scheduleType: scheduleType ?? this.scheduleType,
        fullFrontLicenseFileUrl:
            fullFrontLicenseFileUrl ?? this.fullFrontLicenseFileUrl,
        fullBackLicenseFileUrl:
            fullBackLicenseFileUrl ?? this.fullBackLicenseFileUrl,
        startLatitude: startLatitude ?? this.startLatitude,
        endLatitude: endLatitude ?? this.endLatitude,
        startLongitude: startLongitude ?? this.startLongitude,
        endLongitude: endLongitude ?? this.endLongitude,
        driverLatitude: driverLatitude ?? this.driverLatitude,
        driverLongitude: driverLongitude ?? this.driverLongitude,
        rcChannelId: rcChannelId ?? this.rcChannelId,
        isDelivering: isDelivering ?? this.isDelivering,
        displayValues: displayValues ?? this.displayValues,
        estimateTime: estimateTime ?? this.estimateTime);
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'],
        placedBy: json['placedBy'],
        placedOn:
            json['placedOn'] == null ? null : DateTime.parse(json['placedOn']),
        storeId: json['storeId'],
        driverId: json['driverId'],
        doorImageId: json['doorImageId'],
        doorImageFullUrl: json['doorImageFullUrl'],
        status: json['status'],
        modifiedBy: json['modifiedBy'],
        modifiedOn: json['modifiedOn'] == null
            ? null
            : DateTime.parse(json['modifiedOn']),
        refNo: json['refNo'],
        paymentMethod: json['paymentMethod'],
        isCart: json['isCart'],
        scheduledDateTime: json['scheduledDateTime'] == null
            ? null
            : DateTime.parse(json['scheduledDateTime']),
        pointRedeemed: json['pointRedeemed'],
        pointEarned: json['pointEarned'],
        tip: json['tip'],
        orderItems: json['orderItems'] == null
            ? []
            : List<OrderItem>.from(
                json['orderItems']!.map((x) => OrderItem.fromJson(x))),
        addedBy: json['addedBy'],
        storeName: json['storeName'],
        storeAddress: json['storeAddress'],
        driverName: json['driverName'],
        placedByName: json['placedByName'],
        productName: json['productName'],
        quantity: json['quantity'],
        subTotal: json['subTotal']?.toDouble(),
        totalTax: json['totalTax']?.toDouble(),
        deliveryFee: json['deliveryFee'],
        serviceFee: json['serviceFee'],
        total: json['total']?.toDouble(),
        categoryName: json['categoryName'],
        productImageUrl: json['productImageUrl'],
        productImageFullUrl: json['productImageFullUrl'],
        profilePicUrl: json['profilePicUrl'],
        profilePicFullUrl: json['profilePicFullUrl'],
        address: json['address'],
        firebaseItemId: json['firebaseItemId'],
        type: json['type'],
        scheduleType: json['scheduleType'],
        fullFrontLicenseFileUrl: json['fullFrontLicenseFileUrl'],
        fullBackLicenseFileUrl: json['fullBackLicenseFileUrl'],
        startLatitude: json['startLatitude'],
        endLatitude: json['endLatitude'],
        startLongitude: json['startLongitude'],
        endLongitude: json['endLongitude'],
        rcChannelId: json['rcChannelId'],
        isDelivering: json['isDelivering'],
        displayValues: json['displayValues'],
        estimateTime: json['estimateTime'],
        driverLatitude: json['driverLatitude'],
        driverLongitude: json['driverLongitude']);
  }

  Map<String, dynamic> toDoorIdJson() {
    return {
      'id': id,
      'doorImageId': doorImageId,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'placedBy': placedBy,
      'placedOn': placedOn?.toIso8601String(),
      'storeId': storeId,
      'driverId': driverId,
      'doorImageId': doorImageId,
      'doorImageFullUrl': doorImageFullUrl,
      'status': status,
      'modifiedBy': modifiedBy,
      'modifiedOn': modifiedOn?.toIso8601String(),
      'refNo': refNo,
      'paymentMethod': paymentMethod,
      'isCart': isCart,
      'scheduledDateTime': scheduledDateTime?.toIso8601String(),
      'pointRedeemed': pointRedeemed,
      'pointEarned': pointEarned,
      'tip': tip,
      'orderItems': orderItems == null
          ? []
          : List<dynamic>.from(orderItems!.map((x) => x.toJson())),
      'addedBy': addedBy,
      'storeName': storeName,
      'storeAddress': storeAddress,
      'driverName': driverName,
      'placedByName': placedByName,
      'productName': productName,
      'quantity': quantity,
      'subTotal': subTotal,
      'totalTax': totalTax,
      'deliveryFee': deliveryFee,
      'serviceFee': serviceFee,
      'total': total,
      'categoryName': categoryName,
      'productImageUrl': productImageUrl,
      'productImageFullUrl': productImageFullUrl,
      'profilePicUrl': profilePicUrl,
      'profilePicFullUrl': profilePicFullUrl,
      'address': address,
      'firebaseItemId': firebaseItemId,
      'type': type,
      'scheduleType': scheduleType,
      'fullFrontLicenseFileUrl': fullFrontLicenseFileUrl,
      'fullBackLicenseFileUrl': fullBackLicenseFileUrl,
      'startLatitude': startLatitude,
      'endLatitude': endLatitude,
      'startLongitude': startLongitude,
      'endLongitude': endLongitude,
      'rcChannelId': rcChannelId,
      'isDelivering': isDelivering,
      'displayValues': displayValues,
      'estimateTime': estimateTime,
      'driverLatitude': driverLatitude,
      'driverLongitude': driverLongitude
    };
  }
}

class OrderItem {
  final num? id;
  final num? orderId;
  final num? productId;
  final double? price;
  final num? quantity;
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
      'productName': productName,
      'productPrice': productPrice,
      'displayValue': displayValue,
      'productImageUrl': productImageUrl,
      'productImageFullUrl': productImageFullUrl,
    };
  }
}
