import 'dart:async';
import 'package:alcoholdeliver/apis/product_api/product_api.dart';
import 'package:alcoholdeliver/apis/user_api/user_api.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/model/add_to_card.dart';
import 'package:alcoholdeliver/model/cart.dart';
import 'package:alcoholdeliver/model/product.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ChangeNotifierProvider<CartProvider> cartProvider = ChangeNotifierProvider((ref) => CartProvider());

class CartProvider extends DefaultChangeNotifier {
  Timer? stateTimer;
  bool showCart = true;
  List<Product> cartItems = [];
  Map<num, num> cartQuantity = {};
  final UserApi _userApi = UserApi.instance;
  final ProductApi _productApi = ProductApi.instance;

  CartProvider();

  bool get showCartBar => cartQuantity.isNotEmpty && showCart;

  num getQuantity(Product product) => cartQuantity[product.id] ?? 1;

  num getQuantityWithZero(Product product) => cartQuantity[product.id] ?? 0;

  bool isAddedInCart(num productId) => cartQuantity.containsKey(productId);

  num get cartCount {
    if (cartQuantity.isEmpty) return 0;
    return cartQuantity.values.reduce((sum, value) => sum + value);
  }

  void setupTimer() {
    if (stateTimer != null) stateTimer?.cancel();
    showCart = true;
    stateTimer = Timer(const Duration(seconds: 8), () {
      showCart = false;
      notify();
    });
  }

  void setupCart(Cart data) {
    cartItems = data.modeledProducts ?? [];
    if (cartItems.isEmpty) {
      cartQuantity.clear();
    } else {
      for (final e in cartItems) {
        cartQuantity[e.id ?? 0] = e.quantity ?? 0;
      }
    }
    setupTimer();
    notify();
  }

  void addToCart(Product product, num quantity) {
    bool existsInCart = cartItems.any((item) => item.id == product.id);
    if (!existsInCart) {
      cartItems.add(product);
      cartQuantity[product.id ?? 0] = quantity;
    }
    if (cartQuantity.containsKey(product.id)) {
      cartQuantity[product.id ?? 0] = quantity;
    }
    setupTimer();
    notify();
  }

  void updateQuantity(Product product, num quantity) {
    cartQuantity[product.id ?? 0] = quantity;
    if (quantity == 0) removeFromCart(product);
    setupTimer();
    notify();
  }

  void removeFromCart(Product product) {
    cartItems.removeWhere((e) => e.id == product.id);
    cartQuantity.remove(product.id);
    setupTimer();
    notify();
  }

  Future<bool> addOrRemoveCart(
    BuildContext context,
    AddToCart data, {
    bool showSnackbar = true,
  }) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      if (showSnackbar) Loader.show(context);

      var result = await _productApi.addOrRemoveFromCart(
        productId: data.productId ?? 0,
        quantity: data.quantity ?? 0,
        action: data.method ?? 'add',
      );

      return result.when(
        (value) async {
          if (showSnackbar) context.showSuccessSnackBar('Cart updated successfully');
          // ignore: use_build_context_synchronously
          if (showSnackbar) Loader.dismiss(context);
          return true;
        },
        (error) {
          context.showFailureSnackBar(error);
          // ignore: use_build_context_synchronously
          if (showSnackbar) Loader.dismiss(context);
          return false;
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
      return false;
    }
  }

  Future<void> getCart(BuildContext context) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _productApi.getCart();

      return result.when(
        (value) async {
          Loader.dismiss(context);
          setupCart(value);
        },
        (error) {
          Loader.dismiss(context);
          context.showFailureSnackBar(error);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
    }
  }

  Future<void> getMe(BuildContext context) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _userApi.getMe();

      return result.when(
        (value) async {
          final oldUser = preferences.getUserProfile();
          final updatedProfile = value.copyWith(token: oldUser?.token);
          preferences.userProfile = updatedProfile;
          notify();
          Loader.dismiss(context);
        },
        (error) {
          Loader.dismiss(context);
          context.showFailureSnackBar(error);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
    }
  }
}
