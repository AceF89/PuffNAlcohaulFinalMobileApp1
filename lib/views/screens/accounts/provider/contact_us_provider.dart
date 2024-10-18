import 'package:alcoholdeliver/apis/user_api/user_api.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/model/user_details.dart';
import 'package:alcoholdeliver/providers/default_change_notifier.dart';
import 'package:alcoholdeliver/services/connectivity_service.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AutoDisposeChangeNotifierProvider<ContactUsProvider> contactUsProvider =
    ChangeNotifierProvider.autoDispose((ref) => ContactUsProvider());

class ContactUsProvider extends DefaultChangeNotifier {
  UserDetails? user;
  final UserApi _api = UserApi.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  ContactUsProvider();

  Future<bool> contactUs(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) return false;

    if (await ConnectivityService.isConnected) {
      // ignore: use_build_context_synchronously
      Loader.show(context);

      var result = await _api.contactUs(message: controller.text.trim());

      return result.when(
        (value) async {
          Loader.dismiss(context);
          context.showSuccessSnackBar('Message Sent Successfully');
          return true;
        },
        (error) {
          Loader.dismiss(context);
          context.showFailureSnackBar(error);
          return false;
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showFailureSnackBar(kNoInternet);
      return false;
    }
  }
}
