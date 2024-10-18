import 'package:alcoholdeliver/model/cart.dart';
import 'package:alcoholdeliver/model/charge_card_res.dart';
import 'package:alcoholdeliver/model/pagination_response.dart';
import 'package:alcoholdeliver/model/product.dart';
import 'package:alcoholdeliver/model/saved_cards.dart';
import 'package:alcoholdeliver/model/stripe_card_res.dart';
import 'package:alcoholdeliver/services/client/client_service.dart';
import 'package:alcoholdeliver/services/client/result.dart';

part 'product_api_impl.dart';

enum GetAllProductE { search, featured, all, byCategory, searchByCategory }

abstract class ProductApi {
  static final ProductApi _instance = _ProductApiImpl();

  static ProductApi get instance => _instance;

  Future<Result<Pagination<List<Product>>, String>> getAllProduct({
    required int page,
    required GetAllProductE type,
    String? searchTerm,
    num? catId,
    num? storeId,
  });

  Future<Result<String, String>> addOrRemoveFromCart({
    required num productId,
    required num quantity,
    required String action,
  });

  Future<Result<String, String>> addTip({required num orderId, required num tip});

  Future<Result<Cart, String>> getCart();

  Future<Result<String, String>> scheduleOrder({required num orderId, required DateTime datetime});

  Future<Result<String, String>> checkout();

  Future<Result<StripeCardRes, String>> getTokenFromStripeCard({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
  });

  Future<Result<String, String>> saveCardTokenToStripe({required String cardToken});

  Future<Result<ChargeCardRes, String>> chargeCard({required String cardId, required num orderId});

  Future<Result<List<SavedCards>, String>> getAllSavedStripeCard();

  Future<Result<String, String>> deleteCardFromStripe({required String cardToken});
}
