class AddToCart {
  final num? productId;
  final num? quantity;
  final String? method;

  AddToCart({
    this.productId,
    this.quantity,
    this.method,
  });

  factory AddToCart.fromJson(Map<String, dynamic> json) {
    return AddToCart(
      productId: json['productId'],
      quantity: json['quantity'],
      method: json['method'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'method': method,
    };
  }
}
