import 'package:fit_mind/view/on_boarding/goal_screen.dart';
import 'package:flutter/material.dart';
// import '../../view/onboarding/permission_screen.dart';
// import '../../view/auth/login_screen.dart';
// import '../../view/auth/signup_screen.dart';
// import '../../view/stats/stats_screen.dart';
// import '../../view/ai_chat/chat_screen.dart';
// import '../../view/profile/profile_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const stats = '/stats';
  static const chat = '/chat';
  static const profile = '/profile';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const GoalScreen(),
    // home: (context) => const HomeScreen(),
    // stats: (context) => const StatsScreen(),
    // chat: (context) => const ChatScreen(),
    // profile: (context) => const ProfileScreen(),
  };
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Hal – AI Health Coach",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
