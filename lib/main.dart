import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/view/autentikasi/login.dart';
import 'package:project/view/autentikasi/register.dart';
import 'package:project/view/dashboard/mainpage.dart';
import 'package:project/view/home/homepage.dart';
import 'package:project/profile/profile_page.dart';
import 'package:project/view/splashscreen/splashscreen2.dart';
import 'package:project/view/home/ProductDetailsPage.dart';
import 'package:project/view/home/cartpage.dart'; // ← jika belum ada, tambahkan
import 'package:project/providers/cart_provider.dart';
import 'package:project/view/home/qris_payment_page.dart'; // ← tambahkan path CartProvider kamu

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
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
      initialRoute: '/',
      routes: {
        '/kn': (context) => const WelcomeScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/': (context) => const HomePage(),
        '/cart': (context) => const CartPage(),
        '/profile': (context) => const ProfilePage(),
        '/qris': (context) => const QrisPaymentPage(), // ← tambahkan ini untuk akses halaman keranjang
      },
    );
  }
}
