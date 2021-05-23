import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App {
  static final navState = new GlobalKey<NavigatorState>();

  static T manager<T>({bool listen: false}) {
    return Provider.of<T>(navState.currentContext!, listen: listen);
  }
}
