import 'package:flutter/material.dart';
import 'package:hatchery_im/routers.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'common/AppContext.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/manager/app_manager/appManager.dart';
import 'package:hatchery_im/manager/splash_manager/splashManager.dart';
import 'package:hatchery_im/manager/login_manager/loginManager.dart';
import 'package:hatchery_im/manager/register_manager/registerManager.dart';
import 'package:hatchery_im/manager/chat_manager/chatHomeManager.dart';
import 'package:hatchery_im/manager/contacts_manager/contactsManager.dart';
import 'package:hatchery_im/manager/contacts_manager/contactsApplicationManager.dart';
import 'package:hatchery_im/manager/contacts_manager/searchNewContactsManager.dart';
import 'package:hatchery_im/manager/group_manager/groupsManager.dart';
import 'package:hatchery_im/manager/profile_manager/myProfile_manager/myProfileManager.dart';
import 'package:hatchery_im/manager/profile_manager/friendsProfile_manager/friendProfileManager.dart';
import 'package:hatchery_im/manager/profile_manager/myProfile_manager/profileEditManager.dart';
import 'package:hatchery_im/manager/profile_manager/myProfile_manager/profileEditDetailManager.dart';
import 'package:hatchery_im/manager/contacts_manager/friendApplyManager.dart';
import 'package:hatchery_im/manager/block_manager/blockListManager.dart';
import 'package:hatchery_im/manager/chat_manager/chatDetailManager.dart';
import 'package:hatchery_im/manager/profile_manager/groupProfile_manager/groupProfileManager.dart';
import 'package:hatchery_im/manager/contacts_manager/selectContactsModelManager.dart';
import 'package:hatchery_im/manager/map_manager/showMapManager.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';

import 'manager/emojiModel_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppManager()),
        ChangeNotifierProvider(create: (_) => SplashManager()),
        ChangeNotifierProvider(create: (_) => LoginManager()),
        ChangeNotifierProvider(create: (_) => RegisterManager()),
        ChangeNotifierProvider(create: (_) => ContactsManager()),
        ChangeNotifierProvider(create: (_) => SearchNewContactsManager()),
        ChangeNotifierProvider(create: (_) => ContactsApplyManager()),
        ChangeNotifierProvider(create: (_) => GroupsManager()),
        ChangeNotifierProvider(create: (_) => GroupProfileManager()),
        ChangeNotifierProvider(create: (_) => MyProfileManager()),
        ChangeNotifierProvider(create: (_) => FriendProfileManager()),
        ChangeNotifierProvider(create: (_) => ProfileEditManager()),
        ChangeNotifierProvider(create: (_) => ProfileEditDetailManager()),
        ChangeNotifierProvider(create: (_) => FriendApplyManager()),
        ChangeNotifierProvider(create: (_) => BlockListManager()),
        ChangeNotifierProvider(create: (_) => ChatDetailManager()),
        ChangeNotifierProvider(create: (_) => ChatHomeManager()),
        ChangeNotifierProvider(create: (_) => SelectContactsModelManager()),
        ChangeNotifierProvider(create: (_) => ShowMapManager()),
        ChangeNotifierProvider(create: (_) => EmojiModelManager()),
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
          primarySwatch: Colors.blueGrey,
        ),
        initialRoute: '/splash',
        // initialRoute: '/test',
        onGenerateRoute: Routers.generateRoute,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('zh', 'CN'),
          const Locale('en', 'US'),
        ],
        builder: EasyLoading.init(),
      ),
    );
  }
}
