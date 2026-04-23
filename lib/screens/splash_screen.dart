import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/token_service.dart';
import 'home_screen.dart';
import 'signin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoRotation;
  late final Animation<double> _textOpacity;
  late final Animation<double> _progressOpacity;
  late final Animation<double> _ringScale;
  late final Animation<double> _ringOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _logoScale = Tween<double>(
      begin: 0.78,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _logoOpacity = Tween<double>(
      begin: 0.25,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _logoRotation = Tween<double>(
      begin: 0.08,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.85, curve: Curves.easeOut),
      ),
    );

    _progressOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 1.0, curve: Curves.easeIn),
      ),
    );

    _ringScale = Tween<double>(begin: 0.8, end: 1.22).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.9, curve: Curves.easeOut),
      ),
    );

    _ringOpacity = Tween<double>(begin: 0.22, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.95, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future.delayed(const Duration(milliseconds: 3100));
    final token = await TokenService.getToken();

    if (!mounted) return;

    if (token != null) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 360),
        ),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const Signin(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 360),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final logoSize = (size.width * 0.28).clamp(108.0, 138.0);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0F172A),
              const Color(0xFF1E293B),
              AppColors.primaryOrange.withValues(alpha: 0.82),
            ],
          ),
        ),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Stack(
                  children: [
                    Positioned(
                      top: -130 + (16 * _controller.value),
                      left: -90 + (10 * _controller.value),
                      child: Container(
                        width: size.width * 0.62,
                        height: size.width * 0.62,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryOrange.withValues(
                            alpha: 0.14,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -150 + (22 * _controller.value),
                      right: -100 + (12 * _controller.value),
                      child: Container(
                        width: size.width * 0.72,
                        height: size.width * 0.72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryEmerald.withValues(
                            alpha: 0.11,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        return Opacity(
                          opacity: _ringOpacity.value,
                          child: Transform.scale(
                            scale: _ringScale.value,
                            child: Container(
                              width: logoSize * 1.06,
                              height: logoSize * 1.06,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.58),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScale.value,
                          child: Transform.rotate(
                            angle: _logoRotation.value,
                            child: Opacity(
                              opacity: _logoOpacity.value,
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: logoSize,
                        height: logoSize,
                        padding: EdgeInsets.all(
                          (logoSize * 0.2).clamp(20.0, 28.0),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.9),
                            width: 1.4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryOrange.withValues(
                                alpha: 0.38,
                              ),
                              blurRadius: 42,
                              spreadRadius: 4,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Image.asset('lib/assets/logo.png'),
                      ),
                    ),
                    SizedBox(height: (logoSize * 0.2).clamp(20.0, 30.0)),
                    FadeTransition(
                      opacity: _textOpacity,
                      child: Text(
                        'SwifTrip',
                        style: TextStyle(
                          fontSize: (size.width * 0.08).clamp(28.0, 34.0),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    FadeTransition(
                      opacity: _textOpacity,
                      child: const Text(
                        'Discover your next story',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    FadeTransition(
                      opacity: _progressOpacity,
                      child: SizedBox(
                        width: 96,
                        child: LinearProgressIndicator(
                          minHeight: 3,
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                          backgroundColor: Colors.white24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
