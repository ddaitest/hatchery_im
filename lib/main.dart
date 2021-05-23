import 'package:flutter/material.dart';
import 'package:hatchery_im/routers.dart';

import 'common/AppContext.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: App.navState,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: Routers.generateRoute,
    );
  }
}