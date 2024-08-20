import 'dart:convert';

import 'package:assignment02/apis/api.dart';
import 'package:assignment02/const/components.dart';
import 'package:assignment02/const/sp.dart';
import 'package:assignment02/route/routes_name.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  ValueNotifier toggle = ValueNotifier(true);
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  ValidatorClass validatorClass = ValidatorClass();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Api api = Api();
  SharedPref sp = SharedPref();
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 25,
            child: Image.asset(
              "assets/images/signup-bg.PNG",
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            flex: 75,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mq.width * 0.10,
                vertical: mq.height * 0.05,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: widget.formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Login \naccount",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: mq.height * 0.02),
                      const Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textField(
                          validator: widget.validatorClass.validEmail,
                          obscureText: false,
                          inputType: TextInputType.emailAddress,
                          hintText: "wode.wilson@gmail.com",
                          controller: widget.loginEmailController),
                      SizedBox(height: mq.height * 0.02),
                      const Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: widget.toggle,
                        builder: (context, value, child) {
                          return textField(
                            validator: widget.validatorClass.validPassword,
                            obscureText: widget.toggle.value,
                            inputType: TextInputType.visiblePassword,
                            hintText: "6 characters or more",
                            suffixIcon: InkWell(
                                onTap: () {
                                  widget.toggle.value = !(widget.toggle.value);
                                },
                                child: Icon(
                                  widget.toggle.value
                                      ? Icons.toggle_off
                                      : Icons.toggle_on,
                                )),
                            controller: widget.loginPasswordController,
                          );
                        },
                      ),
                      SizedBox(height: mq.height * 0.02),
                      InkWell(
                        onTap: () async {
                          await checkInternetConnectivity()
                              ? login()
                              : showSnackbar(context,
                                  "No internet connection. Please try again.");
                        },
                        child: button(
                            loading: api.loading,
                            circularProgressIndicator:
                                const CircularProgressIndicator(
                              color: Colors.white,
                              backgroundColor:
                                  const Color.fromARGB(255, 184, 230, 252),
                            ),
                            height: mq.height * 0.08,
                            buttonText: "Login account"),
                      ),
                      SizedBox(height: mq.height * 0.02),
                      Row(
                        children: [
                          const Text(
                            "Dont have an account? ",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RoutesName.SignupScreen);
                            },
                            child: const Text(
                              " Sign Up",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  login() async {
    if (widget.formkey.currentState!.validate()) {
      setState(() {
        api.setLoading(true);
      });
      final response = await api.loginUser({
        "email": widget.loginEmailController.text.toString(),
        "password": widget.loginPasswordController.text.toString(),
      });
      if (response is String) {
        final decodedResponse = jsonDecode(response);
        print("Response on Login : $decodedResponse");
        final status = decodedResponse['status'];
        final response_code = decodedResponse['response_code'];
        final message = decodedResponse['message'];
        if (response_code == 200) {
          final user_id = int.parse(decodedResponse['data']['id']);
          final role_id = int.parse(decodedResponse['data']['role_id']);
          await sp.init();
          Map<String, dynamic>? uData = sp.getUserData();
          if (uData!['user_id'] == null && uData['role_id'] == null) {
            sp.saveUserId(userId: user_id,roleId: role_id);
          }
          widget.loginEmailController.clear();
          widget.loginPasswordController.clear();
          if (role_id == 0) {
            print("Navigation in AdminDashboard");
            return Navigator.pushNamed(context, RoutesName.AdminDashboardScreen);
          }
          Navigator.pushNamed(context, RoutesName.UserImageScreen);
        } else {
          showAlert(
              context: context,
              title: 'Failed',
              content: message,
              formkey: widget.formkey);
        }
      }
      setState(() {
        api.setLoading(false);
      });
    }
  }
}
