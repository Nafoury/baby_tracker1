import 'package:baba_tracker/main.dart';
import 'package:baba_tracker/view/login/forgetpassword..dart';
import 'package:flutter/material.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/common_widgets/round_textfiled.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:get/get.dart';

class UpdatedPassword extends StatefulWidget {
  const UpdatedPassword({Key? key}) : super(key: key);

  @override
  State<UpdatedPassword> createState() => _UpdatedPasswordState();
}

class _UpdatedPasswordState extends State<UpdatedPassword> {
  final _passwordTextController = TextEditingController();
  final _passwordTextController1 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Crud crud = Crud();

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _updatePassword() async {
    if (_formKey.currentState!.validate() &&
        _passwordTextController.text == _passwordTextController1.text) {
      try {
        var response = await crud.postrequest(linkUpdatePassword, {
          "password": _passwordTextController.text,
          "email": sharedPref.getString("email")
        });
        if (response['status'] == "success") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Image.asset(
                  "assets/images/change.png",
                  height: 60,
                  width: 60,
                ),
                content: Text("Password was successfully updated."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.offAllNamed("/login");
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print("Error during password update: $e");
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Image.asset(
              "assets/images/change.png",
              height: 60,
              width: 60,
            ),
            content: Text("the password dosen't match"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.offAllNamed("/login");
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
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
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.off(ForgetPassword());
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
                  SizedBox(height: 80),
                  RoundTextFiled(
                    hintext: "Password",
                    icon: "assets/images/lock_icon.png",
                    controller: _passwordTextController,
                    obscureText: _obscureText,
                    rightIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Tcolor.gray,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter password";
                      } else if (value.length < 8) {
                        return "Password length should be at least 8 characters";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: media.width * 0.1),
                  RoundTextFiled(
                    hintext: "Confirm password",
                    icon: "assets/images/lock_icon.png",
                    controller: _passwordTextController1,
                    obscureText: _obscureText,
                    rightIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Tcolor.gray,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "cofirm password";
                      } else if (value.length < 8) {
                        return "Password length should be at least 8 characters";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: media.width * 0.2),
                  RoundButton(
                    onpressed: _updatePassword,
                    title: "Update Password",
                  ),
                  SizedBox(height: media.width * 0.04),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
