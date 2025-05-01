import 'package:flutter/material.dart';
import 'package:project/view/autentikasi/login.dart';
import 'package:project/view/autentikasi/register.dart';
import 'package:project/view/splashscreen/splashscreen2.dart';
import 'view/splashscreen/splashscreen.dart'; // ganti sesuai path kamu

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DikaWaroong.in',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
