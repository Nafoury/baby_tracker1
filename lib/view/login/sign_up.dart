import 'package:baba_tracker/common/color_extension.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/common_widgets/round_textfiled.dart';
import 'package:baba_tracker/main.dart';
import 'package:baba_tracker/view/home/home_view.dart';
import 'package:baba_tracker/view/login/complete_info.dart';
import 'package:baba_tracker/view/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:baba_tracker/models/sleepData.dart';
import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  Crud crud = Crud();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _firstname = TextEditingController();
  bool isloading = false;
  bool ischeck = false;
  bool isvisible = false;
  final formkey = GlobalKey<FormState>();

  signUp() async {
    var response = await crud.postrequest(linksignup, {
      "first_name": _firstname.text,
      "email": _emailTextController.text,
      "password": _passwordTextController.text
    });
    print(response); // Print the response to check its structure
    if (response['status'] == "success") {
      if (response.containsKey('id')) {
        String userId = response['id'].toString();
        // Store the user ID in shared preferences
        await sharedPref.setString('first_name', _firstname.text);
        sharedPref.setString("id", userId);
        sharedPref.setBool('isLoggedIn', true);
        Get.offAllNamed("/completeinfo");
      } else {
        print("ID not found in the response"); // Check this print statement
      }
    } else {
      print("signup fail");
    }
  }

  saveToSharedPreferences() async {
    sharedPref.setString('first_name', _firstname.text);
  }

  sendEmail() async {
    String username = _emailTextController.text;
    String password = _passwordTextController.text;

    final smtpServer = gmail(username, password);
    // Create our message.
    final message = Message()
      ..from = Address(username)
      ..recipients.add('fatema.moha.2001@gmail.com')
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
      ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }

    var connection = PersistentConnection(smtpServer);

    // Send the first message
    await connection.send(message);

    // close the connection
    await connection.close();
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
                      hintext: "First Name",
                      icon: "assets/images/profile.png",
                      controller: _firstname,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "password is required";
                        }
                        return null;
                      }),
                  SizedBox(
                    height: media.width * 0.04,
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
                  SizedBox(
                    height: media.width * 0.4,
                  ),
                  RoundButton(
                      onpressed: () async {
                        if (formkey.currentState!.validate()) {
                          await signUp();
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
