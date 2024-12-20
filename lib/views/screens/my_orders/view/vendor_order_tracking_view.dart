import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/constants/app_sizes.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/model/order.dart';
import 'package:alcoholdeliver/routes/routes.dart';
import 'package:alcoholdeliver/views/screens/my_orders/dialogs/reject_reason_dialog.dart';
import 'package:alcoholdeliver/views/screens/my_orders/provider/driver_delivery_provider.dart';
import 'package:alcoholdeliver/views/screens/my_orders/provider/vendor_order_tracking_provider.dart';
import 'package:alcoholdeliver/views/screens/my_orders/widgets/agent_card.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/back_app_bar.dart';
import 'package:alcoholdeliver/views/widgets/common_widgets.dart';
import 'package:alcoholdeliver/views/widgets/google_map_direction.dart';
import 'package:alcoholdeliver/views/widgets/license_card.dart';
import 'package:alcoholdeliver/views/widgets/loader.dart';
import 'package:alcoholdeliver/views/widgets/primary_button.dart';
import 'package:alcoholdeliver/views/widgets/scrollable_column.dart';
import 'package:alcoholdeliver/views/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorOrderTrackingView extends StatefulWidget {
  final Order order;

  const VendorOrderTrackingView({super.key, required this.order});

  @override
  State<VendorOrderTrackingView> createState() =>
      _VendorOrderTrackingViewState();
}

class _VendorOrderTrackingViewState extends State<VendorOrderTrackingView> {
  late VendorOrderTrackingProvider _provider;
  late DriverDeliveryProvider _dProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.initListener(widget.order.firebaseItemId ?? '');
      _dProvider.doorImage = null;
      _provider.setOrder(widget.order);
      _provider.getEstimatedTime(
        widget.order.originCoordinate,
        widget.order.destinationCoordinate,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(context, title: 'Delivery Tracking'),
      body: Consumer(builder: (context, ref, _) {
        _provider = ref.watch(vendorOrderTrackingProvider);
        _dProvider = ref.watch(driverDeliveryProvider);

        return ScrollableColumn.withSafeArea(
          padding: EdgeInsets.zero,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Sizes.s300.h,
              child: _provider.isMapLoading
                  ? Loader.circularProgressIndicator()
                  : GoogleMapDirection(
                      originCoordinates: _provider.originCoordinate ??
                          widget.order.originCoordinate,
                      originName: '',
                      hideOriginMarker: _provider.isLocationAvailable,
                      destinationCoordinates:
                          widget.order.destinationCoordinate,
                      destinationName: '',
                      externalMarkers: _provider.driverLocation,
                    ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: PaddingValues.padding.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Traking Informations
                  SizedBoxH20(),
                  Text(
                    'Tracking Details',
                    style: TextStyle(
                      color: AppColors.primaryFontColor,
                      fontWeight: FontWeight.w500,
                      fontSize: Sizes.s20.sp,
                    ),
                  ),
                  SizedBoxH20(),
                  ColumnText(
                    label: 'Delivery Time',
                    value: _provider.isEstimatedTimeLoading
                        ? 'Loading..'
                        : _provider.deliveryEstimatedTime == null
                            ? 'N/A'
                            : _provider.deliveryEstimatedTime!,
                  ),
                  SizedBoxH20(),
                  ColumnText(
                      label: 'Delivery Type',
                      value: widget.order.orderType ?? 'N/A'),
                  SizedBoxH20(),
                  ColumnText(
                      label: 'Delivery Address',
                      value: '#${widget.order.address ?? 'N/A'}'),
                  SizedBoxH20(),

                  /// Driver Information
                  const BlueDivider(),
                  SizedBoxH10(),

                  AgentCard(
                    name: widget.order.placedByName ?? 'N/A',
                    type: 'Customer',
                    onTapChat: () {
                      Navigator.of(context)
                          .pushNamed(Routes.chat, arguments: widget.order);
                    },
                  ),
                  SizedBoxH10(),
                  const BlueDivider(),
                  SizedBoxH10(),

                  /// Order Details
                  ColumnText(
                      label: 'Order Details',
                      value: widget.order.displayValues ?? 'N/A'),
                  Row(
                    children: [
                      Text(
                        "Order No: #${widget.order.id}",
                        style: TextStyle(
                          color: AppColors.primaryFontColor,
                          fontWeight: FontWeight.w400,
                          fontSize: Sizes.s16.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBoxH20(),

                  /// Delivery Status
                  ColumnText(
                      label: 'Delivery Status',
                      value: widget.order.status ?? 'N/A'),
                  SizedBoxH20(),

                  /// Licence Pics
                  const BoldHeader('User License Picture'),
                  SizedBoxH10(),
                  // TODO: Update Licence Image
                  Row(
                    children: [
                      LicenseCard(
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.filePreview,
                              arguments: widget.order.fullFrontLicenseFileUrl);
                        },
                        label: 'Front Copy',
                        ignorePointer: false,
                        selectedImage: null,
                        showBottomText: true,
                        selectedImageUrl: widget.order.fullFrontLicenseFileUrl,
                      ),
                      SizedBoxW10(),
                      LicenseCard(
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.filePreview,
                              arguments: widget.order.fullBackLicenseFileUrl);
                        },
                        label: 'Back Copy',
                        ignorePointer: false,
                        selectedImage: null,
                        showBottomText: true,
                        selectedImageUrl: widget.order.fullBackLicenseFileUrl,
                      ),
                    ],
                  ),
                  SizedBoxH30(),

                  /// Upload Pics
                  const BoldHeader('Upload Door Picture'),
                  SizedBoxH10(),
                  LicenseCard(
                    label: 'Front Copy',
                    showBottomText: false,
                    selectedImage: _dProvider.doorImage,
                    selectedImageUrl: widget.order.doorImageFullUrl,
                    onTap: () => _dProvider.onSelectImage(context),
                  ),
                  SizedBoxH30(),

                  /// Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          label: 'Reject',
                          showShadow: true,
                          onPressed: () async {
                            // ignore: use_build_context_synchronously
                            final reason = await RejectReasonDialog.show(
                                    context, _dProvider.reasonController) ??
                                '';
                            if (reason.isEmpty) {
                              // ignore: use_build_context_synchronously
                              context
                                  .showFailureSnackBar('Reason is Mandatory');
                              return;
                            }

                            final status = await _dProvider.setOrderStatus(
                              // ignore: use_build_context_synchronously
                              context,
                              widget.order.id ?? 0,
                              'Rejected',
                              reason: reason,
                            );
                            if (!status) return;

                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBoxW20(),
                      Expanded(
                        child: PrimaryButton(
                          label: 'Delivered',
                          showShadow: true,
                          onPressed: () async {
                            if (_dProvider.doorImage == null) {
                              context.showFailureSnackBar(
                                  'Please select door image');
                              return;
                            }

                            final fileRes = await _dProvider.uploadFile(
                                context, _dProvider.doorImage);
                            if (fileRes == null) return;

                            final ouState =
                                // ignore: use_build_context_synchronously
                                await _dProvider.updateImageId(
                                    context,
                                    widget.order
                                        .copyWith(doorImageId: fileRes.id));
                            if (!ouState) return;

                            // ignore: use_build_context_synchronously
                            final status = await _dProvider.setOrderStatus(
                                context, widget.order.id ?? 0, 'Delivered');
                            if (!status) return;

                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBoxH30(),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
