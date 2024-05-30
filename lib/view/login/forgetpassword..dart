import 'dart:convert';

import 'package:baba_tracker/common/color_extension.dart';
import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:baba_tracker/main.dart';
import 'package:baba_tracker/view/home/home_view.dart';
import 'package:baba_tracker/view/login/login_page.dart';
import 'package:baba_tracker/view/login/sign_up.dart';

import 'package:flutter/material.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/common_widgets/round_textfiled.dart';
import 'package:baba_tracker/models/sleepData.dart';
import 'package:get/get.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _LoginPageState();
}

class _LoginPageState extends State<ForgetPassword> {
  final _emailTextController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  Crud crud = Crud();
  late String verfiylink;

  resetpassword() async {
    try {
      var response = await crud.postrequest(linkResetPassword, {
        "email": _emailTextController.text,
      });

      if (response.containsKey("error")) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Image.asset(
                "assets/images/warning.png",
                height: 60,
                width: 60,
              ),
              content: Text(
                  "Invalid email,enter the email that you used to sign up"),
              actions: [
                TextButton(
                  onPressed: () {
                    _emailTextController.clear();
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          verfiylink = response["url"];
          print(verfiylink);
          sharedPref.setString("email", _emailTextController.text);
          Get.offAllNamed("/updatedPassword");
        });
      }
    } catch (e) {
      print("Error during login: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.off(LoginPage());
                        },
                        icon: Image.asset(
                          "assets/images/back_Navs.png",
                          width: 25,
                          height: 25,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  RoundTextFiled(
                    hintext: "enter valid email",
                    icon: "assets/images/email_icon.png",
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTextController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "email is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: media.width * 0.6,
                  ),
                  RoundButton(
                      onpressed: () async {
                        if (formkey.currentState!.validate()) {
                          resetpassword();
                        }
                      },
                      title: "Reset password"),
                  SizedBox(
                    height: media.width * 0.04,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
