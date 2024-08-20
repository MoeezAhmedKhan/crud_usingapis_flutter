import 'dart:io';

import 'package:assignment02/admin/dashboard.dart';
import 'package:assignment02/home.dart';
import 'package:assignment02/login.dart';
import 'package:assignment02/route/routes_name.dart';
import 'package:assignment02/signup.dart';
import 'package:assignment02/splash.dart';
import 'package:assignment02/user/image.dart';
import 'package:assignment02/user/profile.dart';
import 'package:flutter/material.dart';

class Routing {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.SplashScreen:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case RoutesName.SignupScreen:
        return MaterialPageRoute(
          builder: (context) => SignupScreen(),
        );
      case RoutesName.LoginScreen:
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
        );
      case RoutesName.HomeScreen:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      case RoutesName.UserImageScreen:
        return MaterialPageRoute(
          builder: (context) => UserImageScreen(),
        );
      case RoutesName.UserProfileScreen:
        return MaterialPageRoute(
          builder: (context) => UserProfileScreen(data: settings.arguments),
        );
      case RoutesName.AdminDashboardScreen:
        return MaterialPageRoute(
          builder: (context) => const AdminDashboardScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text("No Route Define")),
          ),
        );
    }
  }
}
