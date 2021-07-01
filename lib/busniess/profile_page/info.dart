import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/widget/aboutAvatar.dart';

class Info extends StatelessWidget {
  final String name, account, imageUrl;
  Info({
    required this.name,
    required this.account,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240.0.h,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShape(),
            child: Container(
              height: 150.0.h,
              color: Flavors.colorInfo.mainColor,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10.0), //10
                  height: 140.0.h,
                  width: 140.0.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 8.0.w, //8
                    ),
                  ),
                  child: netWorkAvatar(imageUrl, 140),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 22.0.sp, // 22
                    color: Flavors.colorInfo.diver,
                  ),
                ),
                SizedBox(height: 5.0.h), //5
                Text(
                  account,
                  style: TextStyle(
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF8492A2),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
