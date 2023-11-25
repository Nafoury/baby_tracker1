import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/view/login/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/common_widgets/round_textfiled.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formfield = GlobalKey<FormState>;
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool ischeck = false;
  bool isvisible = false;
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
                  ),
                  SizedBox(
                    height: media.width * 0.04,
                  ),
                  Text(
                    "Forget your password?",
                    style: TextStyle(color: Tcolor.gray, fontSize: 12),
                  ),
                  SizedBox(
                    height: media.width * 0.4,
                  ),
                  RoundButton(onpressed: () {}, title: "Login"),
                  SizedBox(
                    height: media.width * 0.04,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Signup()));
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
