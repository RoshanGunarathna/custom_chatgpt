import 'package:custom_chatgpt/common/widgets/appbar_menu.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/about';
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('AppBar'),
        actions: [
          const AppBarMenu(),
        ],
      ),
    );
  }
}
