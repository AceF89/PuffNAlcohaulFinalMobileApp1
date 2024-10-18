import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/utils/validation_mixin.dart';
import 'package:alcoholdeliver/views/screens/accounts/provider/request_product_provider.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/back_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/primary_text_field.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestProductScreen extends StatefulWidget {
  const RequestProductScreen({super.key});

  @override
  State<RequestProductScreen> createState() => _RequestProductScreenState();
}

class _RequestProductScreenState extends State<RequestProductScreen> with ValidationMixin {
  late RequestProductProvider provider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context,
        title: 'Request Product',
      ),
      body: Consumer(
        builder: (context, ref, _) {
          provider = ref.watch(requestProductProvider);

          return Form(
            key: provider.formKey,
            child: ScrollableColumn.withSafeArea(
              children: [
                SizedBoxH10(),
                PrimaryTextField(
                  labelText: 'Enter Product Name',
                  labelColor: AppColors.secondaryFontColor,
                  hintText: '',
                  keyboardType: TextInputType.text,
                  validator: productNameValidation,
                  controller: provider.productNameController,
                ),
                SizedBoxH20(),
                PrimaryTextField(
                  labelText: 'Description',
                  maxLines: 10,
                  labelColor: AppColors.secondaryFontColor,
                  hintText: 'Write description',
                  keyboardType: TextInputType.text,
                  validator: descriptionValidation,
                  controller: provider.descriptionController,
                ),
                SizedBoxH20(),
                PrimaryButton(
                  label: 'Submit',
                  showShadow: true,
                  onPressed: () async {
                    final status = await provider.contactUs(context);
                    if (!status) return;
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                ),
                SizedBoxH20(),
              ],
            ),
          );
        },
      ),
    );
  }
}
