import 'package:alcoholdeliver/apis/product_api/product_api.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/model/saved_cards.dart';
import 'package:alcoholdeliver/model/user_details.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AutoDisposeChangeNotifierProvider<PaymentMethodsProvider> paymentMethodsProvider =
    ChangeNotifierProvider.autoDispose((ref) => PaymentMethodsProvider());

class PaymentMethodsProvider extends DefaultChangeNotifier {
  UserDetails? user;
  final ProductApi _api = ProductApi.instance;

  List<SavedCards> savedCards = [];

  PaymentMethodsProvider();

  void removeCards(SavedCards card) {
    savedCards.removeWhere((e) => e.id == card.id);
    notify();
  }

  Future<bool> getAllSavedStripeCard(BuildContext context) async {
    if (await ConnectivityService.isConnected) {
      loading = true;

      var result = await _api.getAllSavedStripeCard();

      return result.when(
        (value) async {
          savedCards = value;
          loading = false;
          return true;
        },
        (error) {
          loading = false;
          context.showFailureSnackBar(error);
          return false;
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
      return true;
    }
  }

  Future<void> deleteCard(BuildContext context, SavedCards card) async {
    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);
      var result = await _api.deleteCardFromStripe(cardToken: card.id ?? '');

      return result.when(
        (value) async {
          removeCards(card);
          Loader.dismiss(context);
        },
        (error) {
          context.showFailureSnackBar(error);
          Loader.dismiss(context);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
    }
  }
}
