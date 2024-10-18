import 'package:alcoholdeliver/core/constants/app_assets.dart';
import 'package:alcoholdeliver/core/constants/app_font_family.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/screens/accounts/dialogs/delete_me_dialog.dart';
import 'package:alcoholdeliver/views/screens/accounts/dialogs/logout_dialog.dart';
import 'package:alcoholdeliver/views/screens/accounts/provider/accouts_provider.dart';
import 'package:alcoholdeliver/views/screens/accounts/widgets/account_info_tile.dart';
import 'package:alcoholdeliver/views/screens/accounts/widgets/account_option_card.dart';
import 'package:alcoholdeliver/views/screens/accounts/widgets/accounts_background.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  late AccountsProvider provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getMe(context);
    });
  }

  Future<void> onTapDeleteMeHandler(BuildContext context) async {
    final status = await DeleteMeDialog.show(context);
    if (status == null || status == false) return;

    // ignore: use_build_context_synchronously
    final isSuccess = await provider.deleteMe(context);
    if (isSuccess) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.loginScreen,
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, _) {
        provider = ref.watch(accountsProvider);

        return SafeArea(
          child: AccountsBackground(
            imageUrl: provider.user?.fullFileUrl ?? '',
            selectedImage: null,
            child: ScrollableColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Used SizedBox beause image size is 100 and its on half area
                /// 50 will be coverd by image on both side
                SizedBoxH50(),
                SizedBoxH20(),
                AccountInfoTile(
                  name: provider.user?.fullName ?? 'N/A',
                  joinedDate: provider.user?.joinedDate ?? 'N/A',
                ),
                SizedBoxH20(),
                Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: AppFontFamily.abrilFatface,
                    fontSize: Sizes.s20.sp,
                  ),
                ),
                SizedBoxH20(),
                AccountOptionCard(
                  label: 'Profile',
                  icon: AppAssets.icProfile,
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.editAccount);
                  },
                ),
                SizedBoxH20(),
                AccountOptionCard(
                  label: 'Payment Method',
                  icon: AppAssets.icPaymentMethod,
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.accountsPaymentMethod);
                  },
                ),
                SizedBoxH20(),
                AccountOptionCard(
                  label: 'Contact Us',
                  icon: AppAssets.icContactUs,
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.contactUs);
                  },
                ),
                SizedBoxH20(),
                AccountOptionCard(
                  label: 'Loyalty Points',
                  icon: AppAssets.icDollor,
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.loyaltyPoints);
                  },
                ),
                SizedBoxH20(),
                AccountOptionCard(
                  label: 'Request Product',
                  icon: AppAssets.icProduct,
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.requestProduct);
                  },
                ),
                SizedBoxH20(),
                AccountOptionCard(
                  label: 'Change Password',
                  icon: AppAssets.icKeyDark,
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.changePassword);
                  },
                ),
                SizedBoxH20(),
                AccountOptionCard(
                  label: 'Logout',
                  icon: AppAssets.icLogout,
                  onTap: () async {
                    final status = await LogoutDialog.show(context);
                    if (status == null || status == false) return;

                    preferences.logoutUser();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.loginScreen,
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
                SizedBoxH20(),
                AccountOptionCard(
                  label: 'Delete Account',
                  icon: AppAssets.icBin,
                  onTap: () => onTapDeleteMeHandler(context),
                ),
                SizedBoxH50(),
                SizedBoxH50(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
