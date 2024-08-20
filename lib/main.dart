import 'package:assignment02/login.dart';
import 'package:assignment02/route/routes_name.dart';
import 'package:assignment02/route/routing.dart';
import 'package:assignment02/signup.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: RoutesName.SplashScreen,
      onGenerateRoute: Routing.generateRoutes,
    );
  }
}
