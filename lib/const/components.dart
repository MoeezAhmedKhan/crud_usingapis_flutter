import 'dart:io';

import 'package:assignment02/apis/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextFormField textField({
  required String hintText,
  Widget? suffixIcon,
  required TextEditingController controller,
  required TextInputType inputType,
  required bool obscureText,
  required String? Function(String?)? validator,
}) {
  return TextFormField(
    validator: validator,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    obscureText: obscureText,
    keyboardType: inputType,
    controller: controller,
    decoration: InputDecoration(
      hintText: hintText,
      suffix: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

Container button({
  required double height,
  required String buttonText,
  required bool loading,
  required CircularProgressIndicator circularProgressIndicator,
}) {
  return Container(
    height: height,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: loading
          ? circularProgressIndicator
          : Text(
              buttonText,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
    ),
  );
}

class ValidatorClass {
  String? validEmail(value) {
    if (value.isEmpty) {
      return "Please enter an email";
    }
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? validName(value) {
    if (value.isEmpty) {
      return "Please enter a name";
    } else if (value.length < 3) {
      return "Minimum 3 letters are required";
    } else if (RegExp(r'[0-9]').hasMatch(value)) {
      return "Don't use numbers";
    }
    return null;
  }

  String? validPassword(value) {
    if (value.isEmpty) {
      return "Please enter a password";
    } else if (value.length < 6) {
      return "Minimum 6 letters are required";
    }
    return null;
  }

  String? validPhone(value) {
    if (value.isEmpty) {
      return "Please enter a phone";
    } else if (value.length < 11) {
      return "Minimum 11 numbers are required";
    }
    return null;
  }

  String? validCountry(value) {
    if (value.isEmpty) {
      return "Please enter a country";
    } else if (value.length < 2) {
      return "Minimum 3 letters are required";
    } else if (RegExp(r'[0-9]').hasMatch(value)) {
      return "Don't use numbers";
    }
    return null;
  }
}

void showAlert(
    {required BuildContext context,
    required String title,
    required String content,
    required GlobalKey<FormState> formkey}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shadowColor: Colors.black,
        backgroundColor: Colors.blueAccent,
        title: Text(
          title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(content, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              FocusScope.of(context).unfocus();
              formkey.currentState!.reset();
            },
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

Future<bool> checkInternetConnectivity() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    print("Network Checking :: $result");
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}

void showSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
