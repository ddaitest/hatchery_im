// import 'package:flutter/material.dart';
// import 'package:hatchery/common/utils.dart';
// import 'package:hatchery/flavors/Flavors.dart';
// import 'package:hatchery/manager/splashManager.dart';
// import 'package:provider/provider.dart';
// import 'package:hatchery/common/AppContext.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class AgreementPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final manager = App.manager<SplashManager>();
//     return WillPopScope(
//         onWillPop: _onWillPop,
//         child: Scaffold(
//           body: _agreementMainView(context, manager),
//         ));
//   }
//
//   Widget _agreementMainView(context, SplashManager manager) {
//     print('DEBUG=> _agreementMainView 重绘了。。。。。。。。。。');
//     return Stack(
//       children: [
//         Container(
//           width: Flavors.sizesInfo.screenWidth,
//           decoration: BoxDecoration(
//               image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: AssetImage(
//                     "images/splash.jpg",
//                   ))),
//         ),
//         _agreementDialogView(context, manager)
//       ],
//     );
//   }
//
//   Widget _agreementDialogView(BuildContext context, SplashManager manager) {
//     return Center(
//       child: SingleChildScrollView(
//         child: Container(
//           width: Flavors.sizesInfo.screenWidth - 70.0.w,
//           padding: const EdgeInsets.only(
//               left: 24.0, right: 24.0, top: 27.0, bottom: 19.0),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(8.0)),
//             color: Color(0xFFFFFFFF),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Text(
//                 "服务条款和用户协议提示",
//                 style: Flavors.textStyles.agreementTitle,
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 20.0.h),
//               Text(
//                 Flavors.stringsInfo.agreement_card_text,
//                 style: Flavors.textStyles.agreementText,
//                 textAlign: TextAlign.start,
//               ),
//               SizedBox(height: 11.0.h),
//               Container(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     GestureDetector(
//                       onTap: () => manager.gotoUserAgreementUrl(),
//                       child: Text("《用户协议》",
//                           style: Flavors.textStyles.agreementLink),
//                     ),
//                     SizedBox(width: 5.0.w),
//                     GestureDetector(
//                       onTap: () => manager.gotoPrivacyAgreementUrl(),
//                       child: Text("《隐私政策》",
//                           style: Flavors.textStyles.agreementLink),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 18.0.h),
//               Container(
//                 width: Flavors.sizesInfo.screenWidth,
//                 height: 44.0.h,
//                 child: ElevatedButton(
//                   child: Text(
//                     "确 定",
//                     style: Flavors.textStyles.agreementConfirmBtn,
//                   ),
//                   onPressed: () => manager.clickAgreeAgreementButton(context),
//                 ),
//               ),
//               SizedBox(height: 10.0.h),
//               GestureDetector(
//                 onTap: () {
//                   showToast("需要同意才能继续使用");
//                 },
//                 child: Text(
//                   "不同意",
//                   style: Flavors.textStyles.agreementCloseAppBtn,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<bool> _onWillPop() async {
//     return false;
//   }
// }
