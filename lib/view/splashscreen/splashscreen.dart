import 'package:flutter/material.dart';
import 'dart:async';
import 'package:project/view/splashscreen/fadepage.dart';
import 'package:project/view/splashscreen/splashscreen2.dart';
// Import custom fade route
// import 'fade_page_route.dart'; // Uncomment dan sesuaikan path

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pageController;
  late AnimationController _logoController;
  late AnimationController _logoBreathingController;
  late AnimationController _creditsController;
  late AnimationController _exitController;
  
  late Animation<double> _pageFadeAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoBreathingAnimation;
  late Animation<double> _creditsAnimation;
  late Animation<double> _exitFadeAnimation;
  late Animation<double> _exitScaleAnimation;
  
  List<AnimationController> _letterControllers = [];
  List<Animation<Offset>> _letterAnimations = [];
  List<Animation<double>> _letterFadeAnimations = [];
  
  List<AnimationController> _descriptionControllers = [];
  List<Animation<Offset>> _descriptionAnimations = [];
  List<Animation<double>> _descriptionFadeAnimations = [];
  
  final String appName = "DikaWaroong.in";
  final String description = "Aplikasi Pemesanan Menu yang Fleksibel dan Praktis untuk Warung Mas Dika";
  
  @override
  void initState() {
    super.initState();
    
    // Page transition controller
    _pageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    // Logo animation controller
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    // Logo breathing effect controller
    _logoBreathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    // Credits animation controller
    _creditsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    // Exit animation controller - SLOWER untuk smooth transition
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // Diperlambat untuk sinkronisasi
    );
    
    // Page transition animation
    _pageFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pageController,
      curve: Curves.easeInOut,
    ));
    
    // Logo animations
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    ));
    
    _logoScaleAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));
    
    // Logo breathing animation
    _logoBreathingAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _logoBreathingController,
      curve: Curves.easeInOut,
    ));
    
    // Credits animation
    _creditsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _creditsController,
      curve: Curves.easeInOut,
    ));
    
    // Exit animations - Sinkronisasi dengan page transition
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
    
    // Initialize letter animations
    _initializeLetterAnimations();
    _initializeDescriptionAnimations();
    
    // Start animations sequence
    _startAnimationSequence();
  }
  
  void _initializeLetterAnimations() {
    for (int i = 0; i < appName.length; i++) {
      AnimationController controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
      
      Animation<Offset> slideAnimation = Tween<Offset>(
        begin: const Offset(0, 1.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.bounceOut,
      ));
      
      Animation<double> fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ));
      
      _letterControllers.add(controller);
      _letterAnimations.add(slideAnimation);
      _letterFadeAnimations.add(fadeAnimation);
    }
  }
  
  void _initializeDescriptionAnimations() {
    List<String> words = description.split(' ');
    for (int i = 0; i < words.length; i++) {
      AnimationController controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      );
      
      Animation<Offset> slideAnimation = Tween<Offset>(
        begin: const Offset(0, 0.8),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));
      
      Animation<double> fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ));
      
      _descriptionControllers.add(controller);
      _descriptionAnimations.add(slideAnimation);
      _descriptionFadeAnimations.add(fadeAnimation);
    }
  }
  
  void _startAnimationSequence() async {
    // Start page fade from black
    await _pageController.forward();
    
    // Start logo animation
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();
    
    // Start logo breathing effect
    await Future.delayed(const Duration(milliseconds: 600));
    _logoBreathingController.repeat(reverse: true);
    
    // Wait then start letter animations
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Animate letters one by one
    for (int i = 0; i < _letterControllers.length; i++) {
      _letterControllers[i].forward();
      await Future.delayed(const Duration(milliseconds: 80));
    }
    
    // Animate description words
    await Future.delayed(const Duration(milliseconds: 300));
    for (int i = 0; i < _descriptionControllers.length; i++) {
      _descriptionControllers[i].forward();
      await Future.delayed(const Duration(milliseconds: 60));
    }
    
    // Wait then show credits
    await Future.delayed(const Duration(milliseconds: 600));
    await _creditsController.forward();
    
    // Wait then start exit animation dan navigasi dengan fade transition
    await Future.delayed(const Duration(milliseconds: 2000));
    
    if (mounted) {
      // Mulai exit animation
      _exitController.forward();
      
      // Navigate dengan custom fade transition
      await Future.delayed(const Duration(milliseconds: 200)); // Sedikit delay untuk sinkronisasi
      
      Navigator.of(context).pushReplacement(
        FadePageRoute(
          child: const WelcomeScreen(), // Ganti dengan halaman tujuan Anda
          duration: const Duration(milliseconds: 1000), // Slow fade transition
        ),
      );
    }
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    _logoController.dispose();
    _logoBreathingController.dispose();
    _creditsController.dispose();
    _exitController.dispose();
    
    for (AnimationController controller in _letterControllers) {
      controller.dispose();
    }
    
    for (AnimationController controller in _descriptionControllers) {
      controller.dispose();
    }
    
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Maintain black background untuk mencegah white flash
      child: AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _pageFadeAnimation,
            child: AnimatedBuilder(
              animation: _exitController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _exitFadeAnimation,
                  child: Transform.scale(
                    scale: _exitScaleAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.orange.shade50,
                            Colors.orange.shade100,
                            Colors.orange.shade50,
                          ],
                        ),
                      ),
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: SafeArea(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Spacer(flex: 2),
                                  
                                  // Logo with breathing animation
                                  AnimatedBuilder(
                                    animation: Listenable.merge([_logoController, _logoBreathingController]),
                                    builder: (context, child) {
                                      return FadeTransition(
                                        opacity: _logoFadeAnimation,
                                        child: ScaleTransition(
                                          scale: _logoScaleAnimation,
                                          child: ScaleTransition(
                                            scale: _logoBreathingAnimation,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.orange.shade300.withOpacity(0.6),
                                                    blurRadius: 25,
                                                    spreadRadius: 8,
                                                    offset: const Offset(0, 10),
                                                  ),
                                                  BoxShadow(
                                                    color: Colors.orange.shade200.withOpacity(0.4),
                                                    blurRadius: 40,
                                                    spreadRadius: 15,
                                                    offset: const Offset(0, 5),
                                                  ),
                                                ],
                                              ),
                                              child: Image.asset(
                                                'assets/images/warung.png',
                                                height: 180,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  
                                  const SizedBox(height: 25),
                                  
                                  // Animated app name dengan letter-by-letter animation
                                  Container(
                                    height: 65,
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(appName.length, (index) {
                                        return AnimatedBuilder(
                                          animation: _letterControllers[index],
                                          builder: (context, child) {
                                            return SlideTransition(
                                              position: _letterAnimations[index],
                                              child: FadeTransition(
                                                opacity: _letterFadeAnimations[index],
                                                child: Text(
                                                  appName[index],
                                                  style: TextStyle(
                                                    fontSize: 38,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.brown.shade800,
                                                    letterSpacing: 1.5,
                                                    shadows: [
                                                      Shadow(
                                                        color: Colors.orange.shade300,
                                                        offset: const Offset(3, 3),
                                                        blurRadius: 6,
                                                      ),
                                                      Shadow(
                                                        color: Colors.orange.shade100,
                                                        offset: const Offset(-1, -1),
                                                        blurRadius: 2,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 15),
                                  
                                  // Animated description
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      children: List.generate(description.split(' ').length, (index) {
                                        final words = description.split(' ');
                                        return AnimatedBuilder(
                                          animation: _descriptionControllers[index],
                                          builder: (context, child) {
                                            return SlideTransition(
                                              position: _descriptionAnimations[index],
                                              child: FadeTransition(
                                                opacity: _descriptionFadeAnimations[index],
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                  child: Text(
                                                    '${words[index]} ',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey.shade700,
                                                      fontWeight: FontWeight.w500,
                                                      height: 1.4,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }),
                                    ),
                                  ),
                                  
                                  const Spacer(flex: 3),
                                  
                                  // Simple and elegant credits section
                                  AnimatedBuilder(
                                    animation: _creditsController,
                                    builder: (context, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0, 0.5),
                                          end: Offset.zero,
                                        ).animate(CurvedAnimation(
                                          parent: _creditsController,
                                          curve: Curves.easeOut,
                                        )),
                                        child: FadeTransition(
                                          opacity: _creditsAnimation,
                                          child: Column(
                                            children: [
                                              // Created by text
                                              Text(
                                                "Created by",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey.shade600,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.8,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              
                                              // Names in a simple row
                                              Text(
                                                "Anugrah Farel • Kiflin Nadil • Edward Judika",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.brown.shade700,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.5,
                                                  height: 1.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  
                                  const SizedBox(height: 30),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}