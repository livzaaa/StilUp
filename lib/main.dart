import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const StilUpApp());
}

class StilUpApp extends StatelessWidget {
  const StilUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StilUp',
      theme: ThemeData(
        fontFamily: 'Georgia',
        scaffoldBackgroundColor: const Color(0xfff6eee9),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffe63946)),
      ),
      home: const SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    fadeAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    controller.forward();

    Future.delayed(const Duration(milliseconds: 2400), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (_, animation, __) {
            return FadeTransition(opacity: animation, child: const HomePage());
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6eee9),
      body: Center(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'StilUp',
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff9f7262),
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 14),
              Text(
                'your outfit mood',
                style: TextStyle(
                  color: Color(0xff8b7a73),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
