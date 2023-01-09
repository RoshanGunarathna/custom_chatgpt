import 'package:custom_chatgpt/features/about/about.dart';
import 'package:custom_chatgpt/features/home/screens/home_screen.dart';

import 'package:flutter/material.dart';

//For manage all routes
Route<dynamic> ongenerateRoutes(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case HomeScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (context) => const HomeScreen());
    case AboutScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (context) => const AboutScreen());

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Text('Error: Page doesn\'t exit'),
        ),
      );
  }
}
