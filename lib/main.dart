import 'package:firebase_core/firebase_core.dart';
import 'package:fit_mind/core/routes/app_routes.dart';
import 'package:fit_mind/core/routes/routes_names.dart';
import 'package:fit_mind/core/theme/app_theme.dart';
import 'package:fit_mind/firebase_options.dart';
import 'package:fit_mind/view/splash/splash_screen.dart';
import 'package:fit_mind/view_model/google_fit_view_model.dart';
import 'package:fit_mind/view_model/on_boarding_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnBoardingProvider()),
        ChangeNotifierProvider(create: (_) => GoogleFitProvider()),
      ],
      child:  const MyApp(),
    )

     );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: SplashScreen(),
      onGenerateRoute: Routes.generateRout,
    );
  }
}


