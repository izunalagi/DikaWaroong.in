import 'package:flutter/material.dart';
import 'package:project/view/splashscreen/fadepage.dart';
import 'package:project/view/autentikasi/login.dart';
import 'package:project/view/autentikasi/register.dart';
// Import custom fade route
// import 'fade_page_route.dart'; // Uncomment dan sesuaikan path

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _exitController;
  
  late Animation<double> _entranceFadeAnimation;
  late Animation<double> _exitFadeAnimation;
  late Animation<double> _exitScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Entrance animation controller untuk fade in ketika page dimuat
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Exit animation controller
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Slow exit animation
    );

    // Entrance fade animation
    _entranceFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeInOut,
    ));

    // Exit animations (smooth fade out dengan slight scale)
    _exitFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _exitController,
      curve: Curves.easeInOut,
    ));
    
    _exitScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _exitController,
      curve: Curves.easeInOut,
    ));

    // Start entrance animation ketika page dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entranceController.forward();
    });
  }

  void _navigateToLogin() async {
    _exitController.forward();
    await Future.delayed(const Duration(milliseconds: 1)); // Timing untuk sinkronisasi
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        FadePageRoute(
          child: const LoginPage(), // Ganti dengan LoginScreen Anda
          duration: const Duration(milliseconds: 1000),
        ),
      );
    }
  }

  void _navigateToRegister() async {
    _exitController.forward();
    await Future.delayed(const Duration(milliseconds: 300)); // Timing untuk sinkronisasi
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        FadePageRoute(
          child: const RegisterPage(), // Ganti dengan RegisterScreen Anda
          duration: const Duration(milliseconds: 1000),
        ),
      );
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_entranceController, _exitController]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _entranceFadeAnimation,
          child: FadeTransition(
            opacity: _exitFadeAnimation,
            child: Transform.scale(
              scale: _exitScaleAnimation.value,
              child: Scaffold(
                extendBodyBehindAppBar: true,
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    // Background Image
                    SizedBox.expand(
                      child: Image.asset(
                        'assets/images/background.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),

                    // Dark overlay
                    Container(color: Colors.black.withOpacity(0.3)),

                    // Main content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 100),

                          // Welcome Text dengan subtle entrance animation
                          AnimatedBuilder(
                            animation: _entranceController,
                            builder: (context, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.2),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: _entranceController,
                                  curve: Curves.easeOut,
                                )),
                                child: FadeTransition(
                                  opacity: _entranceFadeAnimation,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Welcome to our',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'DikaWaroong.in',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          const Spacer(),

                          // Buttons dengan subtle entrance animation
                          AnimatedBuilder(
                            animation: _entranceController,
                            builder: (context, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.3),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: _entranceController,
                                  curve: Curves.easeOut,
                                )),
                                child: FadeTransition(
                                  opacity: _entranceFadeAnimation,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      // Login Button
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange.shade700,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          elevation: 4,
                                        ),
                                        onPressed: _navigateToLogin,
                                        child: const Text(
                                          'Lanjutkan ke Login',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      
                                      const SizedBox(height: 12),
                                      
                                      // Register Button
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          side: const BorderSide(color: Colors.white),
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          elevation: 2,
                                        ),
                                        onPressed: _navigateToRegister,
                                        child: const Text(
                                          'Buat Akun',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      
                                      const SizedBox(height: 40),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Dummy classes untuk contoh - ganti dengan class sebenarnya
