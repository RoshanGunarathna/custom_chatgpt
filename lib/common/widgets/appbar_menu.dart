import 'package:flutter/material.dart';

import '../../features/about/about.dart';
import '../show_snackbar.dart';

class AppBarMenu extends StatelessWidget {
  const AppBarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        position: PopupMenuPosition.under,

        // icon by default "3 dot" icon
        itemBuilder: (context) {
          return [
            const PopupMenuItem<int>(
              value: 0,
              child: Text('Sign Out'),
            ),
            const PopupMenuItem<int>(
              value: 1,
              child: Text('About'),
            ),
          ];
        },
        onSelected: (value) {
          if (value == 0) {
            showSnackBar(
                context, 'Don\'t push me out. I\'m still maintaining... :)');
          } else if (value == 1) {
            Navigator.pushNamed(context, AboutScreen.routeName);
          }
        });
  }
}
