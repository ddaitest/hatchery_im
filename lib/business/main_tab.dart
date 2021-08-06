import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/business/chat_home/chat_page.dart';
import 'package:hatchery_im/business/contacts/contacts_page.dart';
import 'package:hatchery_im/business/group_page/group.dart';
import 'package:hatchery_im/business/profile_page/my_profile.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:badges/badges.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/manager/splashManager.dart';
import 'package:hatchery_im/api/entity.dart';
import '../config.dart';
import '../routers.dart';
import 'package:flutter/services.dart';

class MainTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainTabHandler(
      x: 0,
      child: MainTab2(),
    );
  }
}

class MainTab2 extends StatefulWidget {
  @override
  MainTabState createState() => MainTabState();
}

class MainTabState extends State<MainTab2> with SingleTickerProviderStateMixin {
  final manager = App.manager<SplashManager>();
  bool nextKickBackExitApp = false;
  var bottomTabs = mainTabs;
  CustomMenuInfo? _customMenuInfo;
  List<Widget> _bottomBarIcon = [];
  List<Widget> _tabBodies = [
    ChatPage(),
    ContactsPage(),
    GroupPage(),
    MyProfilePage()
  ];

  var _pageController = PageController();
  int _tabIndex = 0;
  String title = '消息列表';

  @override
  void initState() {
    /// 判断config返回的数据是否为null，为null则底部展示原有的4个icon，如果不为null则展示中间区域
    _customMenuInfo = manager.customMenuInfo;
    _setBottomBar();
    // _tabController = TabController(vsync: this, length: _tabBodies.length);

    Future.delayed(Duration.zero, () {
      MainTabHandler.setGotoFun((page) {
        if (_tabIndex != page) {
          _switchTab(page);
        }
      });
    });
    super.initState();
  }

  void _setBottomBar() {
    _bottomBarIcon = bottomTabs.map((e) => _navBarItem(e)).toList();
    if (_customMenuInfo != null) {
      _bottomBarIcon.insert(2, SizedBox(width: 30.0.w));
    }
  }

  _setAppBarInfo() {
    switch (_tabIndex) {
      case 0:
        title = '消息列表';
        break;
      case 1:
        title = '联系人';
        break;
      case 2:
        title = '群组';
        break;
      default:
        title = '消息列表';
        break;
    }
  }

  @override
  void dispose() {
    MainTabHandler.setGotoFun(null);
    super.dispose();
  }

  void handleClick(String value) {
    switch (value) {
      case '添加好友':
        Routers.navigateTo('/search_new_contacts');
        break;
      case '创建群组':
        Routers.navigateTo("/create_group");
        break;
      case 'TestPage':
        Routers.navigateTo("/test");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: _tabIndex != 3
              ? AppBarFactory.getMain(title, actions: [
                  PopupMenuButton<String>(
                    onSelected: handleClick,
                    icon: Icon(Icons.more_vert, size: 30, color: Colors.black),
                    itemBuilder: (BuildContext context) {
                      return {'添加好友', '创建群组', 'TestPage'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                ])
              : null,
          body: SafeArea(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: _tabBodies,
              // onPageChanged: (page) {
              //   setState(() => _tabIndex = page);
              // },
            ),
          ),
          bottomNavigationBar: BottomAppBar(
              color: Flavors.colorInfo.mainBackGroundColor, //底部工具栏的颜色。
              // shape: CircularNotchedRectangle(),
              //设置底栏的形状，一般使用这个都是为了和floatingActionButton融合，
              // 所以使用的值都是CircularNotchedRectangle(),有缺口的圆形矩形。
              elevation: 1.0,
              child: Container(
                height: 50.0.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: _bottomBarIcon,
                ),
              )),
          floatingActionButton:
              _customMenuInfo != null ? _floatingButtonView() : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ));
  }

  Widget _floatingButtonView() {
    return Container(
      height: 80.0.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            child: FloatingActionButton(
              backgroundColor: Flavors.colorInfo.mainBackGroundColor,
              elevation: 1.0,
              onPressed: () => Routers.navigateTo('/web_view',
                  arg: {"url": _customMenuInfo!.url!}),
              child: _floatingPicView(),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              '${_customMenuInfo!.title ?? ''}',
              style: Flavors.textStyles.homeTabFloatingText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatingPicView() {
    return Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Flavors.colorInfo.mainBackGroundColor,
        ),
        child: _customMenuInfo!.icon != null
            ? CachedNetworkImage(
                imageUrl: _customMenuInfo!.icon!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Icon(
                  Icons.cloud_download_rounded,
                  color: Colors.grey,
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.cloud_download_rounded,
                  color: Colors.grey,
                ),
              )
            : Container());
  }

  _switchTab(int index) {
    setState(() {
      _tabIndex = index;
      _setBottomBar();
      Log.log("$_tabIndex", color: LColor.RED);
      _setAppBarInfo();

      _pageController.jumpToPage(index);
    });
  }

  Widget _navBarItem(TabInfo info) {
    return Badge(
      position: BadgePosition.topEnd(top: -12, end: -12),
      showBadge: info.index == 0 ? true : false,
      elevation: 0.5,
      badgeContent: Text('99', style: Flavors.textStyles.homeTabBubbleText),
      animationType: BadgeAnimationType.scale,
      child: IconButton(
          onPressed: () => _switchTab(info.index),
          icon: Icon(
            _tabIndex != info.index ? info.icon : info.activeIcon,
            size: 35,
            color: _tabIndex == info.index
                ? Colors.blue
                : Flavors.colorInfo.normalGreyColor,
          )),
    );
  }

  Future<bool> _onWillPop() async {
    if (nextKickBackExitApp) {
      exitApp();
      return true;
    } else {
      showToast('再按一次退出APP');
      nextKickBackExitApp = true;
      Future.delayed(
        const Duration(seconds: 2),
        () => nextKickBackExitApp = false,
      );
      return false;
    }
  }
}

typedef void Goto(int page);

class MainTabHandler extends InheritedWidget {
  const MainTabHandler({
    Key? key,
    required this.x,
    required Widget child,
  }) : super(key: key, child: child);

  final int x;

  static MainTabHandler of(BuildContext context) {
    final MainTabHandler? result =
        context.dependOnInheritedWidgetOfExactType<MainTabHandler>();
    assert(result != null, 'No MainTabHandler found in context');
    return result!;
  }

  static int tt = 0;

  static Goto? goto;

  @override
  bool updateShouldNotify(MainTabHandler old) => x != old.x;

  ///跳转到置顶 Home 的 tab 页。
  static gotoTab(int tab) {
    if (tab >= 0 && tab < 3) {
      if (goto != null) {
        goto!(tab);
      }
    }
  }

  /// Home 页跳转的回调，应该在initState 时候添加，depose 时候移除
  static setGotoFun(Goto? fun) {
    goto = fun;
  }
}
