import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/icons_const.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  const CachedImage({
    Key? key,
    required this.imageUrl,
    this.size = 50.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.34), // Adjust the circular border based on size
          color: AppColors.hlfgrey,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildErrorWidget(),
    );
  }

  Widget _buildPlaceholder() {
    return SizedBox(
      height: size,
      width: size,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.textcolor,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.34), // Adjust the circular border based on size
        color: AppColors.hlfgrey,
        image: const DecorationImage(
          image: AssetImage(ImagesColletions.emptyAvtarImages), // Provide a local error placeholder image
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

Widget buildstaticImageWidget(double size) {
  return Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(size * 0.34), // Adjust the circular border based on size
      color: AppColors.hlfgrey,
      image: const DecorationImage(
        image: AssetImage(ImagesColletions.emptyAvtarImages), // Provide a local error placeholder image
        fit: BoxFit.cover,
      ),
    ),
  );
}
