import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/view/home/home_view.dart';
import 'package:baby_tracker/view/login/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/common_widgets/round_textfiled.dart';
import 'package:baby_tracker/sqldb.dart';
import 'package:baby_tracker/models/user.dart';

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
  bool isLoginTrue = false;
  String errorMessage = '';
  Future<bool> login(UserModel user) async {
    if (user.useremail.isEmpty || user.userpassword.isEmpty) {
      // Show an error if fields are empty
      setState(() {
        errorMessage = 'Email and password are required.';
      });
      return false;
    } else {
      try {
        SqlDb sqlDb = SqlDb();
        Map<String, dynamic> conditions = {
          'useremail': user.useremail,
          'userpassword': user.userpassword,
        };
        List<Map<String, dynamic>> response =
            await sqlDb.readData('user_authorization', conditions);
        if (response.isNotEmpty) {
          // Show a success message
          print("Data read correctly successfully");
          setState(() {
            errorMessage = '';
          });
          return true;
        } else {
          // Show an error message
          print("Failed to read data or user not found");
          setState(() {
            errorMessage = 'Incorrect email or password.';
          });
          return false;
        }
      } catch (e) {
        print("Error while reading data: $e");
        return false;
      }
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
                    height: media.width * 0.04,
                  ),
                  Text(
                    "Forget your password?",
                    style: TextStyle(color: Tcolor.gray, fontSize: 12),
                  ),
                  SizedBox(
                    height: media.width * 0.4,
                  ),
                  RoundButton(
                      onpressed: () async {
                        if (formkey.currentState!.validate()) {
                          UserModel user = UserModel(
                            useremail: _emailTextController.text,
                            userpassword: _passwordTextController.text,
                          );

                          bool loginSuccess = await login(user);
                          if (loginSuccess) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeView()),
                              (Route<dynamic> rout) => false,
                            );
                          }
                        }
                      },
                      title: "Login"),
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
                    ),
                  ),
                  isLoginTrue
                      ? const Text("email or password is incorrect",
                          style: TextStyle(color: Colors.red))
                      : const SizedBox(),
                  errorMessage.isNotEmpty
                      ? Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
