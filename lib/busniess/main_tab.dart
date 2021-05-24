import 'package:flutter/material.dart';
import 'package:hatchery_im/busniess/chat_home/chat_page.dart';
import 'package:hatchery_im/common/log.dart';
import '../config.dart';
import '../routers.dart';

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
  bool nextKickBackExitApp = false;
  var bottomTabs = mainTabs;
  List<Widget> _tabBodies = [ChatPage(), ChatPage(), ChatPage()];

  var _pageController = PageController();
  int _tabIndex = 0;

  @override
  void initState() {
    // _tabController = TabController(vsync: this, length: _tabBodies.length);
    Future.delayed(Duration(milliseconds: 10), () {
      MainTabHandler.setGotoFun((page) {
        if (_tabIndex != page) {
          _switchTab(page);
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    MainTabHandler.setGotoFun(null);
    super.dispose();
  }

  void handleClick(String value) {
    switch (value) {
      case '物业介绍':
        break;
      case '商务合作':
        // todo
        break;
      case '关于与帮助':
        Routers.navigateTo("/about");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          // selectedLabelStyle: Flavors.textStyles.tabBarTextSelected,
          // unselectedLabelStyle: Flavors.textStyles.tabBarTextUnSelected,
          selectedFontSize: 12.0,
          unselectedFontSize: 12.0,
          currentIndex: _tabIndex,
          items: bottomTabs.map((e) => _navBarItem(e)).toList(),
          type: BottomNavigationBarType.fixed,
          iconSize: 30.0,
          //点击事件
          onTap: _switchTab,
        ),
      ),
    );
  }

  _switchTab(int index) {
    setState(() {
      Log.log("DEBUG=>$index", color: LColor.RED);
      _tabIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  BottomNavigationBarItem _navBarItem(TabInfo info) {
    return BottomNavigationBarItem(
      icon: Icon(
        info.icon,
        size: 30,
      ),
      label: info.label,
      activeIcon: Icon(
        info.activeIcon,
        size: 30,
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (nextKickBackExitApp) {
      // exitApp();
      return true;
    } else {
      // showToast('再按一次退出APP');
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
