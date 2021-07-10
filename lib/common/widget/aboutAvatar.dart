import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hatchery_im/flavors/Flavors.dart';

Widget netWorkAvatar(String avatarUrl, double radius) {
  return Container(
    padding: const EdgeInsets.all(2),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Flavors.colorInfo.mainBackGroundColor,
    ),
    child: CachedNetworkImage(
        imageUrl: avatarUrl,
        placeholder: (context, url) => CircleAvatar(
              backgroundImage: AssetImage('images/default_avatar.png'),
              maxRadius: radius,
            ),
        errorWidget: (context, url, error) => CircleAvatar(
              backgroundImage: AssetImage('images/default_avatar.png'),
              maxRadius: radius,
            ),
        imageBuilder: (context, imageProvider) {
          return CircleAvatar(
            backgroundImage: imageProvider,
            maxRadius: radius,
          );
        }),
  );
}
