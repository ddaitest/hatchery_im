import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/common/log.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String? pathName;
  final String title;

  WebViewPage(this.url, this.pathName, this.title);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late InAppWebViewController webViewController;
  late ContextMenu contextMenu;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  // String url = "";
  double progress = 0;
  PullToRefreshController pullToRefreshController = PullToRefreshController();

  // final urlController = TextEditingController();
  String _title = Flavors.stringsInfo.community_name;

  @override
  void initState() {
    super.initState();
    if (widget.title.isNotEmpty) {
      _title = widget.title;
    }
    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await webViewController.getSelectedText());
                await webViewController.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webViewController.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
          print("onContextMenuActionItemClicked: " +
              id.toString() +
              " " +
              contextMenuItemClicked.title);
        });

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController.reload();
        } else if (Platform.isIOS) {
          webViewController.loadUrl(
              urlRequest: URLRequest(url: await webViewController.getUrl()));
        }
      },
    );
  }

  gotoHomePage() async {
    String? pn = widget.pathName;
    if (pn == null || pn.isEmpty) {
      Navigator.pop(context);
    } else {
      Navigator.of(context).pushReplacementNamed(pn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            gotoHomePage();
          },
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: WillPopScope(
        onWillPop: () async {
          gotoHomePage();
          return false; //如果返回的Future最终值为false时，则当前路由不出栈(不会返回)；最终值为true时，当前路由出栈退出。
        },
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
          initialOptions: options,
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          // onLoadStart: (controller, url) {
          // setState(() {
          //   this.url = url.toString();
          // urlController.text = this.url;
          // });
          // },
          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(
                resources: resources,
                action: PermissionRequestResponseAction.GRANT);
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var uri = navigationAction.request.url;
            if (![
              "http",
              "https",
              "file",
              "chrome",
              "data",
              "javascript",
              "about"
            ].contains(uri!.scheme)) {
              Log.log("shouldOverrideUrlLoading = ${uri.toString()}");
              if (await canLaunch(uri.toString())) {
                // Launch the App
                await launch(
                  uri.toString(),
                );
                // and cancel the request
                return NavigationActionPolicy.CANCEL;
              }
            }
            return NavigationActionPolicy.ALLOW;
          },
          onLoadStop: (controller, url) async {
            controller.getTitle().then((value) {
              Log.log("WEBVIEW=$url title=$_title", color: LColor.RED);
              if (value != null && value != url.toString()) {
                setState(() {
                  this._title = value;
                });
              }
            });
          },
          onLoadError: (controller, url, code, message) {
            pullToRefreshController.endRefreshing();
          },
          onProgressChanged: (controller, progress) {
            if (progress == 100) {
              pullToRefreshController.endRefreshing();
            }
            setState(() {
              this.progress = progress / 100;
              // urlController.text = this.url;
            });
          },
          // onUpdateVisitedHistory: (controller, url, androidIsReload) {
          //   setState(() {
          //     // this.url = url.toString();
          //     // urlController.text = this.url;
          //   });
          // },
          onConsoleMessage: (controller, consoleMessage) {
            print(consoleMessage);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
