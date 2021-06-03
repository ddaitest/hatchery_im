import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:skeleton_text/skeleton_text.dart';

class LoadingView extends StatelessWidget {
  final double? viewWidth;
  final double? viewHeight;
  LoadingView({this.viewWidth = 100.0, this.viewHeight = 14.0});

  @override
  Widget build(BuildContext context) => _getContainerView();

  Widget _getContainerView() {
    return SkeletonAnimation(
      shimmerColor: Colors.grey[300]!,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: viewWidth!.h,
        height: viewHeight!.h,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
