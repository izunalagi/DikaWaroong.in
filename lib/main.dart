import 'package:flutter/material.dart';
import 'package:project/view/dashboard/produk/edit_produk_page.dart';
import 'package:project/view/dashboard/produk/produk_page.dart';
import 'package:project/view/dashboard/produk/tambah_produk_page.dart';
import 'package:project/view/splashscreen/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:project/view/autentikasi/login.dart';
import 'package:project/view/autentikasi/register.dart';
import 'package:project/view/dashboard/mainpage.dart';
import 'package:project/view/home/homepage.dart';
import 'package:project/view/home/activitypage.dart';
import 'package:project/profile/profile_page.dart';
import 'package:project/view/splashscreen/splashscreen2.dart';
import 'package:project/view/home/ProductDetailsPage.dart';
import 'package:project/view/home/cartpage.dart'; // ← jika belum ada, tambahkan
import 'package:project/providers/cart_provider.dart';
import 'package:project/view/home/qris_payment_page.dart'; // ← tambahkan path CartProvider kamu
import 'package:project/view/dashboard/mainpage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DikaWaroong.in',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto', // ← Tambahkan ini
      ),
      initialRoute: '/',
      routes: {
        '/kn': (context) => const WelcomeScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/': (context) => const SplashScreen(),
        '/cart': (context) => const CartPage(),
        '/profile': (context) => const ProfilePage(),
        '/home': (context) => const HomePage(),
        '/activity': (context) => const ActivityPage(),
        '/qris': (context) => const QrisPaymentPage(),
      },
    );
  }
}
