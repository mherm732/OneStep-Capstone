import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../screens/login_screen.dart';

Future<void> logout(BuildContext context) async {
  const storage = FlutterSecureStorage();
  await storage.delete(key: 'jwt');

  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => const LoginScreen()),
    (route) => false,
  );
}
