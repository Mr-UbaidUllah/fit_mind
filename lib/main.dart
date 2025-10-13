import 'package:firebase_core/firebase_core.dart';
import 'package:fit_mind/core/routes/app_routes.dart';
import 'package:fit_mind/core/routes/routes_names.dart';
import 'package:fit_mind/firebase_options.dart';
import 'package:fit_mind/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      onGenerateRoute: Routes.generateRout,
    );
  }
}


