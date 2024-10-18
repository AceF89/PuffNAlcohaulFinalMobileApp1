import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/screens/accounts/provider/payment_methods_provider.dart';
import 'package:alcoholdeliver/views/screens/accounts/widgets/card_title.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/back_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/common_widgets.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  late PaymentMethodsProvider provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getAllSavedStripeCard(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(context, title: 'Payment Method'),
      body: Consumer(
        builder: (context, ref, _) {
          provider = ref.watch(paymentMethodsProvider);

          if (provider.loading) {
            return Loader.circularProgressIndicator();
          }

          if (provider.savedCards.isEmpty) {
            return const NoDataAvailable(label: 'No Cards Available');
          }

          return ScrollableColumn.withSafeArea(
            children: [
              SizedBoxH10(),
              ListView.builder(
                itemCount: provider.savedCards.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, i) {
                  final curCard = provider.savedCards[i];

                  return CardTile(
                    card: curCard,
                    onDeleteCard: (card) => provider.deleteCard(context, card),
                  );
                },
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Sizes.s20.sp),
          child: PrimaryButton(
            label: 'Add Card',
            onPressed: () async {
              final status = await Navigator.of(context).pushNamed(Routes.addNewCard);
              if (status == null || status == false) return;
              // ignore: use_build_context_synchronously
              context.showSuccessSnackBar('Card Added Successfully');
              // ignore: use_build_context_synchronously
              provider.getAllSavedStripeCard(context);
            },
          ),
        ),
      ),
    );
  }
}
