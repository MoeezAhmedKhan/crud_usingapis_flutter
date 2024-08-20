import 'dart:convert';
import 'dart:io';
import 'package:assignment02/apis/api.dart';
import 'package:assignment02/const/components.dart';
import 'package:assignment02/const/sp.dart';
import 'package:assignment02/route/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});
  TextEditingController signupNameController = TextEditingController();
  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  // jab hame without provider use kre state ko manage krna hota h statless widget k andr hi tb ham valueNotifier ka use krte hn
  ValueNotifier toggle = ValueNotifier(true);
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  ValidatorClass validatorClass = ValidatorClass();
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  Api api = Api();
  SharedPref sp = SharedPref();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
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
                        "Create your \nfree account",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: mq.height * 0.02),
                      const Text(
                        "Name",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textField(
                          validator: widget.validatorClass.validName,
                          // focusNode: nameFocusNode,
                          obscureText: false,
                          inputType: TextInputType.text,
                          hintText: "Wode Wilson",
                          controller: widget.signupNameController),
                      SizedBox(
                        height: mq.height * 0.02,
                      ),
                      const Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textField(
                          validator: widget.validatorClass.validEmail,
                          // focusNode: emailFocusNode,
                          obscureText: false,
                          inputType: TextInputType.emailAddress,
                          hintText: "wode.wilson@gmail.com",
                          controller: widget.signupEmailController),
                      SizedBox(
                        height: mq.height * 0.02,
                      ),
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
                            // focusNode: passwordFocusNode,
                            validator: widget.validatorClass.validPassword,
                            obscureText: widget.toggle.value,
                            inputType: TextInputType.visiblePassword,
                            hintText: "6 characters 6r more",
                            suffixIcon: InkWell(
                                onTap: () {
                                  widget.toggle.value = !(widget.toggle.value);
                                },
                                child: Icon(
                                  widget.toggle.value
                                      ? Icons.toggle_on
                                      : Icons.toggle_off,
                                )),
                            controller: widget.signupPasswordController,
                          );
                        },
                      ),
                      SizedBox(height: mq.height * 0.02),
                      InkWell(
                        onTap: () async {
                          await checkInternetConnectivity()
                              ? regUser()
                              : showSnackbar(context,
                                  "No internet connection. Please try again.");
                        },
                        child: button(
                            loading: api.loading,
                            circularProgressIndicator:
                                const CircularProgressIndicator(
                              color: Colors.white,
                              backgroundColor:
                                  Color.fromARGB(255, 184, 230, 252),
                            ),
                            height: mq.height * 0.08,
                            buttonText: "Create your free account"),
                      ),
                      SizedBox(height: mq.height * 0.02),
                      Row(
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RoutesName.LoginScreen);
                            },
                            child: const Text(
                              " Sign In",
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

  void regUser() async {
    if (widget.formkey.currentState!.validate()) {
      setState(() {
        api.setLoading(true);
      });
      final response = await api.registerUser({
        "name": widget.signupNameController.text.toString(),
        "email": widget.signupEmailController.text.toString(),
        "password": widget.signupPasswordController.text.toString(),
      });
      if (response is String) {
        final decodedResponse = jsonDecode(response);
        print("Decoded Response is $decodedResponse");
        final responseCode = decodedResponse['response_code'];
        final status = decodedResponse['status'];
        final message = decodedResponse['message'];
        if (responseCode == 200) {
          final user_id = int.parse(decodedResponse['data']['user_id'].toString());
          final role_id = int.parse(decodedResponse['data']['role_id'].toString());
          print("User id on signup is $user_id");
          print("Role id on signup is $role_id");
          await sp.init();
          await sp.saveUserId(userId: user_id, roleId: role_id);
          Map<String, dynamic>? userdata = sp.getUserData();
          print("User On Signup Shared Pref : $userdata");
          // print("User id on signup Shared pref is $userdata['user_id']");
          // print("Role id on signup Shared pref is $userdata['role_id']");
          widget.signupNameController.clear();
          widget.signupEmailController.clear();
          widget.signupPasswordController.clear();
          showAlert(
              context: context,
              title: 'Sucess',
              content: message,
              formkey: widget.formkey);
        } else if (responseCode == 409) {
          showAlert(
              context: context,
              title: 'Failed',
              content: message,
              formkey: widget.formkey);
        }
        setState(() {
          api.setLoading(false);
        });
      }
    }
  }
}
