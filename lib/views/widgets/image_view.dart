import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:alcoholdeliver/core/constants/constants.dart';
import 'package:alcoholdeliver/core/helpers/extensions.dart';

class ImageView extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final BorderRadiusGeometry? radius;

  const ImageView({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? kNoImage,
      height: height,
      width: width,
      imageBuilder: (context, image) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: radius,
            image: DecorationImage(
              image: image,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),
        );
      },
      placeholder: (context, url) => _buildPlaceHolder(),
      errorWidget: (context, url, error) => _buildPlaceHolder(),
    );
  }

  Widget _buildPlaceHolder() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius,
      ),
    ).toShimmer();
  }
}
