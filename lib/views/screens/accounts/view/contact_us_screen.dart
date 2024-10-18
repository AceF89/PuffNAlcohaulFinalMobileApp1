import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/utils/validation_mixin.dart';
import 'package:alcoholdeliver/views/screens/accounts/provider/contact_us_provider.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/back_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/bottom_nav_bar/seconday_bottom_nav_bar.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/primary_text_field.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> with ValidationMixin {
  late ContactUsProvider provider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(context, title: 'Contact Us'),
      body: Consumer(builder: (context, ref, _) {
        provider = ref.watch(contactUsProvider);

        return Form(
          key: provider.formKey,
          child: ScrollableColumn.withSafeArea(
            children: [
              SizedBoxH20(),
              PrimaryTextField(
                labelText: 'How I help you ?',
                labelColor: AppColors.secondaryFontColor,
                hintText: 'Write message here...',
                keyboardType: TextInputType.text,
                controller: provider.controller,
                maxLines: 5,
                validator: messaageValidation,
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
      }),
      bottomNavigationBar: const SecondaryBottomNavBar(),
    );
  }
}
