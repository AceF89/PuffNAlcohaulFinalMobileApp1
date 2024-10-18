import 'package:alcoholdeliver/model/charge_card_res.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/model/product.dart';
import 'package:alcoholdeliver/model/product_categories.dart';
import 'package:alcoholdeliver/model/user_address.dart';
import 'package:alcoholdeliver/views/screens/accounts/view/accounts_screen.dart';
import 'package:alcoholdeliver/views/screens/accounts/view/contact_us_screen.dart';
import 'package:alcoholdeliver/views/screens/accounts/view/edit_account_screen.dart';
import 'package:alcoholdeliver/views/screens/accounts/view/loyalty_points.dart';
import 'package:alcoholdeliver/views/screens/accounts/view/payment_methods_screen.dart';
import 'package:alcoholdeliver/views/screens/accounts/view/request_product_screen.dart';
import 'package:alcoholdeliver/views/screens/auth/change_password/view/change_password_screen.dart';
import 'package:alcoholdeliver/views/screens/chats/view/chat_screen.dart';
import 'package:alcoholdeliver/views/screens/checkout/view/add_card_screen.dart';
import 'package:alcoholdeliver/views/screens/checkout/view/checkout_options_screen.dart';
import 'package:alcoholdeliver/views/screens/checkout/view/checkout_screen.dart';
import 'package:alcoholdeliver/views/screens/checkout/view/payment_method_screen.dart';
import 'package:alcoholdeliver/views/screens/checkout/view/payment_success_screen.dart';
import 'package:alcoholdeliver/views/screens/home/main_home.dart';
import 'package:alcoholdeliver/views/screens/homepage/view/all_category_screen.dart';
import 'package:alcoholdeliver/views/screens/homepage/view/all_delivery_orders.dart';
import 'package:alcoholdeliver/views/screens/homepage/view/feature_products_screen.dart';
import 'package:alcoholdeliver/views/screens/homepage/view/homepage_screen.dart';
import 'package:alcoholdeliver/views/screens/homepage/view/homepage_search_screen.dart';
import 'package:alcoholdeliver/views/screens/my_address/view/address_details.dart';
import 'package:alcoholdeliver/views/screens/my_address/view/confirm_delivery_address_screen.dart';
import 'package:alcoholdeliver/views/screens/my_address/view/edit_address_details.dart';
import 'package:alcoholdeliver/views/screens/my_address/view/my_address_screen.dart';
import 'package:alcoholdeliver/views/screens/my_orders/view/my_orders_screen.dart';
import 'package:alcoholdeliver/views/screens/my_orders/view/order_details_screen.dart';
import 'package:alcoholdeliver/views/screens/my_orders/view/order_tracking_screen.dart';
import 'package:alcoholdeliver/views/screens/notifications/view/notification_screens.dart';
import 'package:alcoholdeliver/views/screens/products/view/all_related_products_screen.dart';
import 'package:alcoholdeliver/views/screens/products/view/product_details_screen.dart';
import 'package:alcoholdeliver/views/screens/products/view/product_screen.dart';
import 'package:alcoholdeliver/views/widgets/file_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alcoholdeliver/views/screens/auth/forgot_password/view/forgot_password_screen.dart';
import 'package:alcoholdeliver/views/screens/auth/forgot_password/view/new_password_screen.dart';
import 'package:alcoholdeliver/views/screens/auth/forgot_password/view/verify_otp_screen.dart';
import 'package:alcoholdeliver/views/screens/auth/login/view/login_screen.dart';
import 'package:alcoholdeliver/views/screens/auth/signup/view/signup_screen.dart';
import 'package:alcoholdeliver/views/screens/splash/splash.dart';

class Routes {
  Routes._();

  static const String splashScreen = '/splash';

  // Auth
  static const String loginScreen = '/auth/login';
  static const String signupScreen = '/auth/signup';
  static const String forgotPasswordScreen = '/auth/forgot-password';
  static const String forgotPasswordVerifyScreen = '/auth/forgot-password/verify';
  static const String forgotPasswordNewPassword = '/auth/forgot-password/new-password';
  static const String changePassword = '/auth/change-password';

  // Home
  static const String mainHome = '/main_home';
  static const String homepage = '/homepage';
  static const String homepageSearch = '/homepage/search';
  static const String featureProducts = '/homepage/feature_products';
  static const String allCategories = '/homepage/all_catgories';
  static const String notification = '/notification';
  static const String allDeliveryOrdersScreen = '/homepage/all_delivery_orders_screen';

  // Product
  static const String product = '/product';
  static const String productDetails = '/product/details';
  static const String allRelatedProducts = '/product/all_related_products';

  // Checkout
  static const String checkout = '/checkout';
  static const String checkoutOptions = '/checkout_options';
  static const String paymentMethod = '/payment_method';
  static const String paymentSuccess = '/payment_success';
  static const String addNewCard = '/checkout/add_new_card';

  // My Address
  static const String myAddress = '/my_address';
  static const String confirmDeliveryAddress = '/my_address/confirm_delivery_address';
  static const String addressDetails = '/my_address/address_details';
  static const String editAddressDetails = '/my_address/address_details/edit';

  // Accounts
  static const String account = '/account';
  static const String editAccount = '/account/edit';
  static const String requestProduct = '/account/request_product';
  static const String contactUs = '/account/contact_us';
  static const String loyaltyPoints = '/account/loyalty_points';
  static const String accountsPaymentMethod = '/account/payment_method';

  // My Orders
  static const String myOrders = '/my_orders';
  static const String orderDetails = '/my_orders/details';
  static const String orderTracking = '/my_orders/tracking';
  static const String chat = '/my_orders/chat';

  static const String filePreview = '/filePreview';
}

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    var args = settings.arguments;

    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case Routes.loginScreen:
        return CupertinoPageRoute(builder: (_) => const LoginScreen());
      case Routes.signupScreen:
        return CupertinoPageRoute(builder: (_) => const SignupScreen());
      case Routes.forgotPasswordScreen:
        return CupertinoPageRoute(builder: (_) => const ForgotPassword());
      case Routes.forgotPasswordVerifyScreen:
        return CupertinoPageRoute(builder: (_) => const VerifyOtpScreen());
      case Routes.forgotPasswordNewPassword:
        return CupertinoPageRoute(builder: (_) => const NewPassowrdScreen());
      case Routes.changePassword:
        return CupertinoPageRoute(builder: (_) => const ChangePasswordScreen());

      case Routes.mainHome:
        return CupertinoPageRoute(builder: (_) => const MainHome());

      case Routes.homepage:
        return CupertinoPageRoute(builder: (_) => const HomepageScreen());
      case Routes.homepageSearch:
        return CupertinoPageRoute(builder: (_) => HomepageSearchScreen(categories: args as List<ProductCategories>));
      case Routes.allCategories:
        return CupertinoPageRoute(builder: (_) => AllCategoryScreen(catgories: args as List<ProductCategories>));
      case Routes.featureProducts:
        return CupertinoPageRoute(builder: (_) => FeatureProductScreen(products: args as List<Product>));
      case Routes.contactUs:
        return CupertinoPageRoute(builder: (_) => const ContactUsScreen());
      case Routes.notification:
        return CupertinoPageRoute(builder: (_) => const NotificationScreens());
      case Routes.allDeliveryOrdersScreen:
        return CupertinoPageRoute(builder: (_) => const AllDeliveryOrdersScreen());

      /// Products
      case Routes.product:
        return CupertinoPageRoute(builder: (_) => ProductScreen(categorie: args as ProductCategories));
      case Routes.productDetails:
        return CupertinoPageRoute(builder: (_) => ProductDetailsScreen(product: args as Product));
      case Routes.allRelatedProducts:
        return CupertinoPageRoute(builder: (_) => AllRelatedProductScreen(products: args as List<Product>));

      /// Checkout
      case Routes.checkout:
        return CupertinoPageRoute(builder: (_) => const CheckoutScreen());
      case Routes.checkoutOptions:
        return CupertinoPageRoute(builder: (_) => const CheckoutOtionsScreen());
      case Routes.paymentMethod:
        return CupertinoPageRoute(builder: (_) => const PaymentMethodScreen());
      case Routes.paymentSuccess:
        return CupertinoPageRoute(builder: (_) => PaymentSuccessScreen(data: args as ChargeCardRes));
      case Routes.addNewCard:
        return CupertinoPageRoute(builder: (_) => const AddCardScreen());

      /// Accounts
      case Routes.account:
        return CupertinoPageRoute(builder: (_) => const AccountsScreen());
      case Routes.editAccount:
        return CupertinoPageRoute(builder: (_) => const EditAccountScreen());
      case Routes.requestProduct:
        return CupertinoPageRoute(builder: (_) => const RequestProductScreen());
      case Routes.loyaltyPoints:
        return CupertinoPageRoute(builder: (_) => const LoyaltyPointsScreen());
      case Routes.accountsPaymentMethod:
        return CupertinoPageRoute(builder: (_) => const PaymentMethodsScreen());

      /// My Address
      case Routes.myAddress:
        return CupertinoPageRoute(builder: (_) => const MyAddressScreen());
      case Routes.confirmDeliveryAddress:
        return CupertinoPageRoute(builder: (_) => const ConfirmDeliveryAdddressScreen());
      case Routes.addressDetails:
        return CupertinoPageRoute(builder: (_) => const AddressDetails());
      case Routes.editAddressDetails:
        return CupertinoPageRoute(builder: (_) => EditAddressDetails(address: args as UserAddress));

      /// My Orders
      case Routes.myOrders:
        return CupertinoPageRoute(builder: (_) => const MyOrdersScreen());
      case Routes.orderDetails:
        return CupertinoPageRoute(builder: (_) => OrderDetailsScreen(order: args as Order));
      case Routes.orderTracking:
        return CupertinoPageRoute(builder: (_) => OrderTrackingScreen(order: args as Order));
      case Routes.chat:
        return CupertinoPageRoute(builder: (_) => ChatScreen(order: args as Order));

      case Routes.filePreview:
        return CupertinoPageRoute(builder: (_) => FilePreviewScreen(file: args as String));

      default:
        return null;
    }
  }
}
