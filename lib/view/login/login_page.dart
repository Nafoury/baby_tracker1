import 'package:baba_tracker/common/color_extension.dart';
import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:baba_tracker/main.dart';
import 'package:baba_tracker/view/home/home_view.dart';
import 'package:baba_tracker/view/login/forgetpassword..dart';
import 'package:baba_tracker/view/login/sign_up.dart';

import 'package:flutter/material.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/common_widgets/round_textfiled.dart';
import 'package:baba_tracker/models/sleepData.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool ischeck = false;
  bool isvisible = false;
  final formkey = GlobalKey<FormState>();

  Crud crud = Crud();

  login() async {
    try {
      // Retrieve info_id from shared preferences
      String? infoId = sharedPref.getString("info_id");

      // Debug log to verify retrieved info_id
      print("Retrieved info_id during login: $infoId");

      var response = await crud.postrequest(linklogin, {
        "email": _emailTextController.text,
        "password": _passwordTextController.text,
      });

      if (response['status'] == "success") {
        // Update shared preferences with info_id from server response
        sharedPref.setString("id", response['data']['id'].toString());
        sharedPref.setString("info_id", response['data']['info_id'].toString());
        sharedPref.setBool('isLoggedIn', true);
        Get.offAllNamed("/mainTab");
        print("the baby id when I logged in" +
            response['data']['info_id'].toString());
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Incorrect email or password'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
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
                  Text(
                    "Hey there!",
                    style: TextStyle(color: Tcolor.gray, fontSize: 16),
                  ),
                  Text(
                    "Welcome back",
                    style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  RoundTextFiled(
                    hintext: "email",
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
                    height: media.width * 0.04,
                  ),
                  RoundTextFiled(
                    hintext: "password",
                    icon: "assets/images/lock_icon.png",
                    controller: _passwordTextController,
                    obscureText: isvisible,
                    rightIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isvisible = !isvisible;
                          });
                        },
                        icon: Icon(
                            isvisible ? Icons.visibility : Icons.visibility_off,
                            color: Tcolor.gray,
                            size: 20)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "password is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: media.width * 0.3,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(ForgetPassword());
                    },
                    child: Text(
                      "Forget your password?",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.04,
                  ),
                  RoundButton(
                      onpressed: () async {
                        if (formkey.currentState!.validate()) {
                          login();
                        }
                      },
                      title: "Login"),
                  SizedBox(
                    height: media.width * 0.04,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(Signup());
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Don't have an account yet?",
                          style: TextStyle(
                            color: Tcolor.black,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Register",
                          style: TextStyle(
                            color: Tcolor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
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
