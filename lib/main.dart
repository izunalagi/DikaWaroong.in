import 'package:flutter/material.dart';
import 'package:project/view/splashscreen/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:project/view/autentikasi/login.dart';
import 'package:project/view/autentikasi/register.dart';
import 'package:project/view/home/homepage.dart';
import 'package:project/view/home/activitypage.dart';
import 'package:project/profile/profile_page.dart';
import 'package:project/view/splashscreen/splashscreen2.dart';
import 'package:project/view/home/cartpage.dart';
import 'package:project/providers/cart_provider.dart';
import 'package:project/view/home/qris_payment_page.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Wajib sebelum await
  await initializeDateFormatting(
    'id_ID',
    null,
  ); // Inisialisasi locale Indonesia

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
      theme: ThemeData(fontFamily: 'Roboto'),
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
        // Jangan daftarkan '/qris' di sini
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/qris') {
          final args = settings.arguments;
          if (args is int) {
            return MaterialPageRoute(
              builder: (context) => QrisPaymentPage(idTransaksi: args),
            );
          } else {
            return MaterialPageRoute(
              builder:
                  (context) => Scaffold(
                    body: Center(
                      child: Text(
                        'Error: idTransaksi harus diberikan sebagai int.',
                      ),
                    ),
                  ),
            );
          }
        }
        return null; // biarkan flutter handle route lain yang gak ada
      },
    );
  }
}
