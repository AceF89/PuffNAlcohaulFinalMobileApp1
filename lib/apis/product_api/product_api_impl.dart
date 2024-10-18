part of 'product_api.dart';

abstract class ProductApiService extends ClientService implements ProductApi {}

class _ProductApiImpl extends ProductApiService {
  @override
  Future<Result<Pagination<List<Product>>, String>> getAllProduct({
    required int page,
    required GetAllProductE type,
    String? searchTerm,
    num? catId,
    num? storeId,
  }) async {
    String query = '?pageNumber=$page&pageSize=20&';
    if (storeId != null) query += 'storeId=$storeId&';
    switch (type) {
      case GetAllProductE.search:
        query += 'query=$searchTerm';
      case GetAllProductE.featured:
        query += 'filter=FEATURED';
      case GetAllProductE.all:
        query += '';
      case GetAllProductE.byCategory:
        query += 'catId=$catId';
      case GetAllProductE.searchByCategory:
        query += 'query=$searchTerm&catId=$catId';
    }

    var result = await request(
      requestType: RequestType.get,
      path: '/Products/GetAll$query',
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          List<Product> products = [];
          products = List<Product>.from(
            response['data']['items'].map((e) => Product.fromJson(e)),
          );

          return Success(
            Pagination.fromJson({
              'totalData': response['data']['totalItems'],
              'totalPages': response['data']['totalPages'],
              'data': products,
            }),
          );
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> addOrRemoveFromCart({
    required num productId,
    required num quantity,
    required String action,
  }) async {
    String path = '/Order/AddOrRemoveFromCart?productId=$productId&quantity=$quantity';
    if (action.isNotEmpty) {
      path += '&action=$action';
    }
    var result = await request(
      requestType: RequestType.post,
      path: path,
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          return Success(response['message']);
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<Cart, String>> getCart() async {
    var result = await request(
      requestType: RequestType.get,
      path: '/Order/GetCart',
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          return Success(Cart.fromJson(response['data']));
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> addTip({
    required num orderId,
    required num tip,
  }) async {
    String path = '/Order/AddTip?orderId=$orderId&tip=$tip';

    var result = await request(
      requestType: RequestType.post,
      path: path,
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          return Success(response['message']);
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> scheduleOrder({
    required num orderId,
    required DateTime datetime,
  }) async {
    String path = '/Order/ScheduleOrder?orderId=$orderId&scheduleDate=${datetime.toUtc()}';

    var result = await request(
      requestType: RequestType.post,
      path: path,
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          return Success(response['message']);
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> checkout() async {
    String path = '/Order/Checkout';

    var result = await request(
      requestType: RequestType.post,
      path: path,
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          return Success(response['message']);
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<StripeCardRes, String>> getTokenFromStripeCard({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
  }) async {
    Map<String, dynamic> cardData = {
      'card[number]': cardNumber,
      'card[exp_month]': expiryMonth,
      'card[exp_year]': expiryYear,
      'card[cvc]': cvv,
    };

    var result = await urlRequest(
      requestType: RequestType.post,
      url: 'https://api.stripe.com/v1/tokens',
      data: cardData,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization':
            'Bearer pk_test_51NfQ7FCECePmB1jYouLXV66U5xvFQjHlFV5iorPjK2SCIHgkM4Gi6ME5ww8cfN0fWQSjDIUa1UHzAf3bieIE3zgH00onkgeMaS',
      },
    );

    return result.when(
      (response) {
        return Success(StripeCardRes.fromJson(response));
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> saveCardTokenToStripe({required String cardToken}) async {
    var result = await request(
      requestType: RequestType.post,
      path: '/Payment/SaveCardToStripe?cardToken=$cardToken',
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          return Success(response['message']);
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<ChargeCardRes, String>> chargeCard({
    required String cardId,
    required num orderId,
  }) async {
    var result = await request(
      requestType: RequestType.post,
      path: '/Payment/ChargeCard?cardId=$cardId&orderId=$orderId',
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          return Success(ChargeCardRes.fromJson(response['data']));
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<List<SavedCards>, String>> getAllSavedStripeCard() async {
    var result = await request(
      requestType: RequestType.get,
      path: '/Payment/GetCardsFromStripe',
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          List<SavedCards> cards = [];
          cards = List<SavedCards>.from(
            response['data'].map((e) => SavedCards.fromJson(e)),
          );

          return Success(cards);
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }

  @override
  Future<Result<String, String>> deleteCardFromStripe({required String cardToken}) async {
    var result = await request(
      requestType: RequestType.post,
      path: '/Payment/DeleteCardFromStripe?cardId=$cardToken',
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          return Success(response['message']);
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }
}
