import 'package:flutter/material.dart';
import 'package:one_step_app_flutter/screens/HomeDashboardScreen.dart';
import 'package:one_step_app_flutter/screens/login_screen.dart';
import 'package:one_step_app_flutter/screens/register_login_selection.dart';
import 'package:one_step_app_flutter/screens/register_screen.dart'; 

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => AuthSelectionScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(), 
        '/dashboard': (context) => HomeDashboardScreen(),
      },
    ),
  );
}
