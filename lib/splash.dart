import 'dart:async';

import 'package:assignment02/const/sp.dart';
import 'package:assignment02/route/routes_name.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPref sp = SharedPref();
  @override
  void initState() {
    super.initState();
    auth();
  }

  void auth() async {
    await sp.init();
    Map<String, dynamic>? uData = sp.getUserData();
    print("User Data On Share Pref in $uData");
    if (uData!['user_id'] != null && uData!['role_id'] != null) {
      Future.delayed(
        const Duration(seconds: 3),
        () {
          Navigator.pushNamed(context, RoutesName.UserImageScreen);
        },
      );
    } else {
      Future.delayed(
        const Duration(seconds: 3),
        () {
          Navigator.pushNamed(context, RoutesName.LoginScreen);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: mq.height * 0.03),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Image.asset(
              "assets/images/logo.png",
              width: mq.width * 0.5,
            )),
            const Text(
              "Developed By\nMoeez Ahmed Khan",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
