import 'package:flutter/material.dart';
import '../utils/logout_util.dart';

AppBar buildAppBarWithLogout(BuildContext context, String title) {
  return AppBar(
    title: Text(title),
    centerTitle: true,
    actions: [
      IconButton(
        icon: const Icon(Icons.logout, color: Colors.black),
        onPressed: () => logout(context),
        tooltip: 'Logout',
      ),
    ],
  );
}
