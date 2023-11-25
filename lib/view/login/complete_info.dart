import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/sqldb.dart';
import 'package:baby_tracker/view/main_tab/main_tab.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/common_widgets/round_textfiled.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:intl/intl.dart';

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

  Future<void> addData() async {
    try {
      SqlDb sqlDb = SqlDb();
      int response = await sqlDb.insertData(
          "INSERT INTO 'complete information' (baby_name,first_name,gender,date_of_birth,weight,height)VALUES('${_firstname.text}','${_babynamecontroller.text}','${selectedValue}', '${_dateTextController.text}', ${_babyweight.text}, ${_babyheight.text})");
      if (response > 0) {
        // Show a success message
        print("Data inserted successfully");
      } else {
        // Show an error message
        print("Failed to insert data");
      }
    } catch (e) {
      print("Error adding data: $e");
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
          padding: const EdgeInsets.all(2.0),
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
                    ),
                    SizedBox(
                      height: media.width * 0.03,
                    ),
                    RoundTextFiled(
                      hintext: "Baby Name",
                      icon: "assets/images/profile.png",
                      controller: _babynamecontroller,
                    ),
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
                            padding: const EdgeInsets.symmetric(horizontal: 15),
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
                              child: DropdownButton<String>(
                                items: ["Male", "Female"]
                                    .map((name) => DropdownMenuItem(
                                        value: name,
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                              color: Tcolor.gray, fontSize: 14),
                                        )))
                                    .toList(),
                                value: selectedValue,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                                isExpanded: true,
                                hint: Text(
                                  "Choose Gender",
                                  style: TextStyle(
                                      color: Tcolor.gray, fontSize: 12),
                                ),
                              ),
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
                          ),
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
                              style:
                                  TextStyle(color: Tcolor.white, fontSize: 12),
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
                          ),
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
                              style:
                                  TextStyle(color: Tcolor.white, fontSize: 12),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    RoundButton(
                        onpressed: () {
                          addData();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainTab()));
                        },
                        title: "Next >"),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
