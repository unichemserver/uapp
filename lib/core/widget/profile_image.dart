import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uapp/core/utils/assets.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
    required this.imgUrl,
    this.radius = 24.0,
  });

  final String imgUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            imgUrl,
            errorListener: (_) {
              const AssetImage(Assets.iconApp);
            },
          ),
        ),
      ),
    );
  }
}
