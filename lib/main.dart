import 'dart:io';

import 'package:custom_chatgpt/router.dart';
import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'constants/http-overrides.dart';
import 'features/home/screens/home_screen.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'custom_chatgpt_0.1',
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: appBarColor.withOpacity(0.5)),
        scaffoldBackgroundColor: backgroungColor,
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      onGenerateRoute: (settings) => ongenerateRoutes(settings),
    );
  }
}
