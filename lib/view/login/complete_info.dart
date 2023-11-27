import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/sqldb.dart';
import 'package:baby_tracker/view/home/home_view.dart';
import 'package:baby_tracker/view/main_tab/main_tab.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/common_widgets/round_textfiled.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class Completeinfo extends StatefulWidget {
  const Completeinfo({super.key});

  @override
  State<Completeinfo> createState() => _CompleteinfoState();
}

class _CompleteinfoState extends State<Completeinfo> {
  final _babynamecontroller = TextEditingController();
  final _dateTextController = TextEditingController();
  final _babyheight = TextEditingController();
  final _babyweight = TextEditingController();
  final _firstname = TextEditingController();
  String? selectedValue;
  String? dropdownError;
  final formkey = GlobalKey<FormState>();
  String? validateDropdown(String? value) {
    if (value == null || value.isEmpty) {
      return "gender is required";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
          child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Image.asset(
                  "assets/images/baby_mum8.png",
                  width: media.width,
                  fit: BoxFit.fitWidth,
                ),
                Text(
                  "Let's complete baby profile",
                  style: TextStyle(
                      color: Tcolor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
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
                        height: media.width * 0.03,
                      ),
                      RoundTextFiled(
                          hintext: "Baby Name",
                          icon: "assets/images/profile.png",
                          controller: _babynamecontroller,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "password is required";
                            }
                            return null;
                          }),
                      SizedBox(
                        height: media.width * 0.03,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Tcolor.lightgray,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 50,
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Image.asset(
                                "assets/images/user_gender.png",
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                                color: Tcolor.gray,
                              ),
                            ),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField<String>(
                                  items: ["Male", "Female"]
                                      .map((name) => DropdownMenuItem(
                                          value: name,
                                          child: Text(
                                            name,
                                            style: TextStyle(
                                                color: Tcolor.gray,
                                                fontSize: 14),
                                          )))
                                      .toList(),
                                  value: selectedValue,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedValue = value;
                                      dropdownError = null;
                                    });
                                  },
                                  validator: validateDropdown,
                                  isExpanded: true,
                                  hint: Text(
                                    "Choose Gender",
                                    style: TextStyle(
                                        color: Tcolor.gray, fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                            if (dropdownError != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  dropdownError!,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.03,
                      ),
                      RoundTextFiled(
                          controller: _dateTextController,
                          hintext: "Date of birth",
                          icon: "assets/images/calender_birth.png",
                          keyboardType: TextInputType.datetime,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100));
                            if (pickedDate != null) {
                              setState(() {
                                _dateTextController.text =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                              });
                            }
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "date of birth is required";
                            }
                            return null;
                          }),
                      SizedBox(
                        height: media.width * 0.03,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextFiled(
                                hintext: "Baby Weight",
                                icon: "assets/images/weight-scale.png",
                                controller: _babyweight,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "baby weight is required";
                                  }
                                  return null;
                                }),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                              width: 45,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: Tcolor.secondryG,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                "KG",
                                style: TextStyle(
                                    color: Tcolor.white, fontSize: 12),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.03,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextFiled(
                                hintext: "Baby Height",
                                icon: "assets/images/height_icon.png",
                                controller: _babyheight,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "baby height is required";
                                  }
                                  return null;
                                }),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                              width: 45,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: Tcolor.secondryG,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                "CM",
                                style: TextStyle(
                                    color: Tcolor.white, fontSize: 12),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      RoundButton(
                          onpressed: () {
                            if (formkey.currentState!.validate()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeView()),
                              );
                            }
                          },
                          title: "Next >"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
