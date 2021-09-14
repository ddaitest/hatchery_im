import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/widget/aboutAvatar.dart';

class Info extends StatelessWidget {
  final String name, account, imageUrl, userID;
  Info(
      {required this.name,
      required this.account,
      required this.imageUrl,
      required this.userID});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0.h,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShape(),
            child: Container(
              height: 120.0.h,
              color: Flavors.colorInfo.mainColor,
            ),
          ),
          GestureDetector(
            onTap: () => Routers.navigateTo('/my_qrCode_card', arg: {
              'avatarUrl': imageUrl,
              'nickName': name,
              'account': account,
              'userID': userID
            }),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: netWorkAvatar(imageUrl, 60),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40.0.h,
                            width: 40.0.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              color: Flavors.colorInfo.mainColor,
                            ),
                            child: Icon(
                              Icons.qr_code_2_outlined,
                              color: Colors.white,
                            ),
                          )),
                    ],
                  ),
                  SizedBox(height: 5.0.h),
                  Text(
                    '$name',
                    style: TextStyle(
                      fontSize: 22.0.sp, // 22
                      color: Flavors.colorInfo.diver,
                    ),
                  ),
                  SizedBox(height: 5.0.h), //5
                  Text(
                    '账号：$account',
                    style: TextStyle(
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF8492A2),
                    ),
                  )
                ],
              ),
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
