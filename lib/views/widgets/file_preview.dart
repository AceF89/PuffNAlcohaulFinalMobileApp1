import 'package:alcoholdeliver/core/constants/app_colors.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';
import 'package:alcoholdeliver/views/widgets/app_bar/back_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FilePreviewScreen extends StatelessWidget {
  final String file;
  const FilePreviewScreen({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(context, title: ''),
      body: Column(
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: file,
              imageBuilder: (context, imageProvider) => PhotoView(
                imageProvider: imageProvider,
                backgroundDecoration: const BoxDecoration(
                  color: AppColors.whiteFontColor,
                ),
              ),
              height: double.infinity,
              width: double.infinity,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  _buildPlaceHolder(),
              errorWidget: (context, url, error) => _buildPlaceHolder(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPlaceHolder() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: radius,
      ),
    ).toShimmer();
  }
}
