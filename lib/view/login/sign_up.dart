import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/common_widgets/round_textfiled.dart';
import 'package:baby_tracker/view/home/home_view.dart';
import 'package:baby_tracker/view/login/complete_info.dart';
import 'package:baby_tracker/view/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/sqldb.dart';
import 'package:baby_tracker/models/user.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool ischeck = false;
  bool isvisible = false;
  final formkey = GlobalKey<FormState>();

  Future<int> savedata(UserModel user) async {
    try {
      SqlDb sqlDb = SqlDb();
      int response = await sqlDb.insertData('user_authorization', user.toMap());
      if (response > 0) {
        // Show a success message
        print("Data inserted successfully");
      } else {
        // Show an error message
        print("Failed to insert data");
      }
      return response;
    } catch (e) {
      print("Error adding data: $e");
      return 0;
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
                    "Create an Account",
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
                      bool emailValid =
                          RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                              .hasMatch(value!);
                      if (value!.isEmpty) {
                        return "Enter Email";
                      } else if (!emailValid) {
                        return "Enter Valid Email";
                      }
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
                        return "Enter password";
                      } else if (_passwordTextController.text.length < 6) {
                        return "Password Lenght should be more than 8 \ncharacters";
                      }
                    },
                  ),
                  SizedBox(
                    height: media.width * 0.04,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            ischeck = !ischeck;
                          });
                        },
                        icon: Icon(
                          ischeck
                              ? Icons.check_box_outlined
                              : Icons.check_box_outline_blank,
                          color: Tcolor.gray,
                          size: 20,
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "By continuing you accept our Privacy Policy and Term of Use",
                            style: TextStyle(color: Tcolor.gray, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: media.width * 0.4,
                  ),
                  RoundButton(
                      onpressed: () {
                        if (formkey.currentState!.validate()) {
                          UserModel user = UserModel(
                            useremail: _emailTextController.text,
                            userpassword: _passwordTextController.text,
                          );
                          savedata(user);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Completeinfo()),
                              (Route<dynamic> rout) => false);
                        }
                      },
                      title: "Register"),
                  SizedBox(
                    height: media.width * 0.04,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                            (Route<dynamic> rout) => false);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                              color: Tcolor.black,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Login",
                            style: TextStyle(
                              color: Tcolor.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
