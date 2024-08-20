import 'dart:convert';

import 'package:assignment02/apis/api.dart';
import 'package:assignment02/const/components.dart';
import 'package:assignment02/const/sp.dart';
import 'package:assignment02/route/routes_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserProfileScreen extends StatefulWidget {
  dynamic data;
  UserProfileScreen({
    super.key,
    required this.data,
  });
  TextEditingController updateNameController = TextEditingController();
  TextEditingController updateEmailController = TextEditingController();
  TextEditingController updatePhoneController = TextEditingController();
  TextEditingController updatePasswordController = TextEditingController();
  TextEditingController updateCountryController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  ValueNotifier toggle = ValueNotifier(true);
  ValidatorClass validator = ValidatorClass();
  Api api = Api();

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      var userModel = await widget.api.getIndividualApi(widget.data['user_id']);
      setState(() {
        widget.updateNameController.text = userModel.data!.name ?? '';
        widget.updateEmailController.text = userModel.data!.email ?? '';
        widget.updatePhoneController.text = userModel.data!.phone ?? '';
        widget.updateCountryController.text = userModel.data!.country ?? '';
        widget.updatePasswordController.text = userModel.data!.password ?? '';
      });
    } catch (e) {
      if (kDebugMode) {
        print("Exception occurred: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final registrationDate = DateTime.parse(widget.data['created_at']);
    String formattedDate =
        "${registrationDate.day}-${registrationDate.month}-${registrationDate.year}";
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_circle_left_sharp,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Manage Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: mq.height * 0.12,
              color: Colors.blueAccent,
            ),
            Container(
              margin: EdgeInsets.only(top: mq.height * 0.27),
              padding: EdgeInsets.symmetric(horizontal: mq.width * 0.04),
              width: double.infinity,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Form(
                    key: widget.formkey,
                    child: Column(
                      children: [
                        textField(
                            hintText: "Enter name",
                            controller: widget.updateNameController,
                            inputType: TextInputType.text,
                            obscureText: false,
                            validator: widget.validator.validName),
                        SizedBox(height: mq.height * 0.02),
                        textField(
                            hintText: "Enter email",
                            controller: widget.updateEmailController,
                            inputType: TextInputType.emailAddress,
                            obscureText: false,
                            validator: widget.validator.validEmail),
                        SizedBox(height: mq.height * 0.02),
                        textField(
                            hintText: "Enter phone",
                            controller: widget.updatePhoneController,
                            inputType: TextInputType.phone,
                            obscureText: false,
                            validator: widget.validator.validPhone),
                        SizedBox(height: mq.height * 0.02),
                        textField(
                            hintText: "Enter country",
                            controller: widget.updateCountryController,
                            inputType: TextInputType.text,
                            obscureText: false,
                            validator: widget.validator.validCountry),
                        SizedBox(height: mq.height * 0.02),
                        ValueListenableBuilder(
                          valueListenable: widget.toggle,
                          builder: (context, value, child) {
                            return textField(
                                hintText: "Enter password",
                                controller: widget.updatePasswordController,
                                inputType: TextInputType.visiblePassword,
                                obscureText: widget.toggle.value,
                                validator: widget.validator.validPassword,
                                suffixIcon: InkWell(
                                    onTap: () {
                                      widget.toggle.value =
                                          !(widget.toggle.value);
                                    },
                                    child: Icon(widget.toggle.value
                                        ? Icons.toggle_on
                                        : Icons.toggle_off)));
                          },
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      userUpdate();
                    },
                    child: Container(
                      height: mq.height * 0.08,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: mq.width * 0.05,
                      ),
                      margin: EdgeInsets.only(
                          top: mq.height * 0.04, bottom: mq.height * 0.01),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: widget.api.loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                backgroundColor:
                                    Color.fromARGB(255, 184, 230, 252),
                              )
                            : const Text(
                                "Save",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: mq.height * 0.035),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: mq.width * 0.18,
                    backgroundImage: widget.data['userProfile'] == null
                        ? null
                        : NetworkImage(
                            "http://192.168.0.109/flutter_api/uploads/${widget.data['userProfile']}"),
                    child: widget.data['userProfile'] != null
                        ? null
                        : Icon(
                            Icons.person_add,
                            color: Colors.white,
                            size: mq.height * 0.05,
                          ),
                  ),
                  SizedBox(height: mq.height * 0.03),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Account was created",
                          style:
                              TextStyle(fontSize: 16, color: Colors.blueAccent),
                        ),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void userUpdate() async {
    if (widget.formkey.currentState!.validate()) {
      setState(() {
        widget.api.setLoading(true);
      });
      final oldEmail = widget.data['email'];
      final oldPassword = widget.data['password'];
      try {
        final response =
            await widget.api.updateProfile(widget.data['user_id'], {
          "name": widget.updateNameController.text,
          "email": widget.updateEmailController.text,
          "phone": widget.updatePhoneController.text,
          "password": widget.updatePasswordController.text,
          "country": widget.updateCountryController.text,
        });

        if (response is String) {
          final decodedResponse = jsonDecode(response);
          final responseCode = decodedResponse['response_code'];
          final status = decodedResponse['status'];
          final message = decodedResponse['message'];
          final data = decodedResponse['data'];
          if (responseCode == 200) {
            fetchUserData();
            showAlert(
                context: context,
                title: 'Sucess',
                content: message,
                formkey: widget.formkey);
            if (oldEmail != data['email'] || oldPassword != data['password']) {
              await Future.delayed(Duration(seconds: 3));
              showSessionExpiredDialog();
              SharedPref sp = SharedPref();
              sp.init();
              await Future.delayed(Duration(seconds: 1));
              sp.prefs.remove('user_id');
              Navigator.pushNamed(context, RoutesName.LoginScreen);
            }
          } else if (responseCode == 409) {
            showAlert(
                context: context,
                title: 'Failed',
                content: message,
                formkey: widget.formkey);
          }
          setState(() {
            widget.api.setLoading(false);
          });
        }
      } catch (e) {
        showAlert(
          context: context,
          title: 'Error',
          content: 'An error occurred while updating the profile.',
          formkey: widget.formkey,
        );
      } finally {
        setState(() {
          widget.api.setLoading(false);
        });
      }
    }
  }

  void showSessionExpiredDialog() {
    showSnackbar(context,
        "Your session is expired. Please log in again with your new credentials");
  }
}
