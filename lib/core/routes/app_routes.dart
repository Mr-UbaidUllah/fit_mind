

import 'package:fit_mind/core/routes/routes_names.dart';
import 'package:fit_mind/view/home/home_screen.dart';
import 'package:fit_mind/view/on_boarding/goal_screen.dart';
import 'package:fit_mind/view/splash/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Routes {

  static Route<dynamic> generateRout(RouteSettings settings) {
    switch(settings.name) {
      case RoutesNames.splash:
        return MaterialPageRoute(builder: (BuildContext context) => SplashScreen());

      case RoutesNames.onBoarding:
        return MaterialPageRoute(builder: (BuildContext context) => GoalScreen());

      case RoutesNames.home:
        return MaterialPageRoute(builder: (BuildContext context) => HomeScreen());

      default :
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text("No route Found"),
            ),
          );
        });
    }
  }
}