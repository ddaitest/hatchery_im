import 'package:flutter/material.dart';
import 'package:hatchery_im/routers.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'common/AppContext.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/manager/appManager.dart';
import 'package:hatchery_im/manager/splashManager.dart';
import 'package:hatchery_im/manager/loginManager.dart';
import 'package:hatchery_im/manager/registerManager.dart';
import 'package:hatchery_im/manager/chatHomeManager.dart';
import 'package:hatchery_im/manager/contactsManager.dart';
import 'package:hatchery_im/manager/contactsApplicationManager.dart';
import 'package:hatchery_im/manager/searchNewContactsManager.dart';
import 'package:hatchery_im/manager/groupsManager.dart';
import 'package:hatchery_im/manager/myProfileManager.dart';
import 'package:hatchery_im/manager/friendProfileManager.dart';
import 'package:hatchery_im/manager/profileEditManager.dart';
import 'package:hatchery_im/manager/profileEditDetailManager.dart';
import 'package:hatchery_im/manager/blockListManager.dart';
import 'package:hatchery_im/manager/chatDetailManager.dart';
import 'package:hatchery_im/manager/selectContactsModelManager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,

        ///这是设置状态栏的图标和字体的颜色
        ///Brightness.light  一般都是显示为白色
        ///Brightness.dark 一般都是显示为黑色
        statusBarIconBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  /// 强制竖屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppManager()),
        ChangeNotifierProvider(create: (_) => SplashManager()),
        ChangeNotifierProvider(create: (_) => LoginManager()),
        ChangeNotifierProvider(create: (_) => RegisterManager()),
        ChangeNotifierProvider(create: (_) => ContactsManager()),
        ChangeNotifierProvider(create: (_) => SearchNewContactsManager()),
        ChangeNotifierProvider(create: (_) => ContactsApplicationManager()),
        ChangeNotifierProvider(create: (_) => GroupsManager()),
        // ChangeNotifierProvider(create: (_) => NewGroupsManager()),
        ChangeNotifierProvider(create: (_) => MyProfileManager()),
        ChangeNotifierProvider(create: (_) => FriendProfileManager()),
        ChangeNotifierProvider(create: (_) => ProfileEditManager()),
        ChangeNotifierProvider(create: (_) => ProfileEditDetailManager()),
        ChangeNotifierProvider(create: (_) => BlockListManager()),
        ChangeNotifierProvider(create: (_) => ChatDetailManager()),
        ChangeNotifierProvider(create: (_) => ChatHomeManager()),
        ChangeNotifierProvider(create: (_) => SelectContactsModelManager()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => MaterialApp(
        navigatorKey: App.navState,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.notoSansTextTheme(),
          // primarySwatch: Colors.blue,
        ),
        initialRoute: '/splash',
        // initialRoute: '/test',
        onGenerateRoute: Routers.generateRoute,
      ),
    );
  }
}
