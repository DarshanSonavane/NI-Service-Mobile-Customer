import 'package:flutter/material.dart';

class HomeNavigatorObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute == null) {
      // Navigated back to the root route, which is the Home screen
      // You can replace 'Home' with the actual route name of your Home screen
      Navigator.of(route.navigator!.context).pushReplacementNamed('Home');
    }
  }
}