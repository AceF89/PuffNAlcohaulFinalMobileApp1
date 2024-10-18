import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/utils/screen_util.dart';
import 'package:alcoholdeliver/views/screens/homepage/provider/driver_homepage_provider.dart';
import 'package:alcoholdeliver/views/widgets/check_box.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoreSelectionDialog extends StatefulWidget {
  const StoreSelectionDialog({super.key});

  static Future<void> show(BuildContext context) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => const StoreSelectionDialog(),
    );
  }

  @override
  State<StoreSelectionDialog> createState() => _StoreSelectionDialogState();
}

class _StoreSelectionDialogState extends State<StoreSelectionDialog> {
  late DriverHomepageProvider provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getAllStores(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: AppColors.whiteFontColor,
      backgroundColor: AppColors.whiteFontColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.s14.sp),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: Sizes.s20.sp),
      content: Consumer(builder: (context, ref, _) {
        provider = ref.watch(driverHomepageProvider);

        return SizedBox(
          width: ScreenUtil().screenWidth * 0.8,
          child: ScrollableColumn(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Select Store',
                    style: TextStyle(
                      fontSize: Sizes.s20.sp,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.clear),
                  ),
                ],
              ),
              SizedBoxH10(),
              provider.isLoadingStore
                  ? Loader.circularProgressIndicator()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.stores.length,
                      itemBuilder: (ctx, index) {
                        final curStore = provider.stores[index];

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CheckBox(
                              isChecked: provider.isStoreChecked(curStore.id ?? 0),
                              onChanged: (bool? value) => provider.onToggleStore(curStore),
                            ),
                            Expanded(
                              child: Text(
                                curStore.name ?? 'N/A',
                                style: TextStyle(
                                  fontSize: Sizes.s16.sp,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ],
          ),
        );
      }),
    );
  }
}
