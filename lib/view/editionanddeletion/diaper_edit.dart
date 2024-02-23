import 'dart:ffi';
import 'package:baby_tracker/common_widgets/crud.dart';
import 'package:baby_tracker/common_widgets/linkapi.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/main.dart';
import 'package:baby_tracker/models/diaperData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Diaperchange extends StatefulWidget {
  final DiaperData entryData;
  final VoidCallback onDelete;
  final Function(DateTime)? onDateStratTimeChanged;

  Diaperchange({
    required this.onDelete,
    required this.entryData,
    this.onDateStratTimeChanged,
  });

  @override
  _DiaperchangeState createState() => _DiaperchangeState();
}

class _DiaperchangeState extends State<Diaperchange> {
  Crud crud = Crud();
  late DateTime startDate;
  late String status;
  late String note;
  late TextEditingController noteController;

  deleteDiaper() async {
    var response = await crud.postrequest(linkDeleteRecord, {
      "change_id": widget.entryData.changeId.toString(),
    });
    if (response == 'success') {
      Navigator.of(context).pushReplacementNamed("/diaperchnage");
    } else {
      // Handle the case where the server response is not 'success'
      print('Editing failed. Server response: $response');
    }
  }

  editDiaper() async {
    try {
      // Check for internet connectivity
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      bool isOnline = (connectivityResult != ConnectivityResult.none);

      if (isOnline) {
        var response = await crud.postrequest(linkUpdateDiaper, {
          "start_date": startDate.toString(),
          "status": status,
          "note": note,
          "change_id": widget.entryData.changeId.toString(),
        });

        // Print the response for debugging
        print(widget.entryData.changeId.toString());
        print('Server response: $response');

        // Adjusted comparison
        if (response is Map && response['status'] == 'success') {
          Navigator.of(context).pushReplacementNamed("/diaperchnage");
        } else {
          // Handle the case where the server response is not 'success'
          print('Editing failed. Server response: $response');
        }
      } else {
        // Handle the case where there is no internet connection
        print('No internet connection. Cannot update data.');
      }
    } catch (e) {
      // Handle any exceptions that might occur during the update process
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    startDate = widget.entryData.startDate;
    status = widget.entryData.status;
    note = widget.entryData.note ?? '';
    noteController = TextEditingController(text: note);
  }

  @override
  Widget build(BuildContext context) {
    return _buildTrackingInfo();
  }

  Widget _buildTrackingInfo() {
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Get.offAllNamed("/mainTab");
                      },
                      icon: Image.asset(
                        "assets/images/back_Navs.png",
                        width: 25,
                        height: 25,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(width: 85),
                    Text(
                      "Diaper",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 80),
                    TextButton(
                      onPressed: () {
                        deleteDiaper();
                      },
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) {
                    return const Column(
                      children: [
                        SizedBox(height: 20),
                        Divider(
                          color: Colors.grey,
                          height: 1,
                        ),
                      ],
                    );
                  },
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    switch (index) {
                      case 0:
                        return GestureDetector(
                          onTap: () {
                            _showStartDatePicker(context, startDate);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(" Date & Time ",
                                  style: TextStyle(
                                    color: Tcolor.black,
                                    fontSize: 13,
                                  )),
                              Text(
                                DateFormat('dd MMM yyyy  HH:mm')
                                    .format(startDate),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      case 1:
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 80,
                                maxHeight: 25,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  items: ["poop", "pee", "mixed", "clean"]
                                      .map((name) => DropdownMenuItem(
                                            value: name,
                                            child: Text(
                                              name,
                                              style: TextStyle(
                                                color: Tcolor.gray,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  value: status,
                                  onChanged: (String? value) {
                                    print('Status changed: $value');
                                    setState(() {
                                      status = value!;
                                    });
                                  },
                                  icon: const Icon(Icons.arrow_drop_down),
                                  isExpanded: true,
                                  hint: const Text(
                                    'Status',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '${status ?? 'None'}',
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        );
                      case 2:
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: TextField(
                                controller:
                                    noteController, // Use noteController here
                                onChanged: (newNote) {
                                  // Update the note variable when the text changes
                                  setState(() {
                                    note = newNote;
                                  });
                                },

                                decoration: InputDecoration(
                                  hintText: "note",
                                ),
                              ),
                            ),
                          ],
                        );

                      default:
                        return SizedBox();
                    }
                  },
                ),
                SizedBox(height: 20),
                RoundButton(
                    onpressed: () {
                      editDiaper();
                    },
                    title: "Save changes")
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showStartDatePicker(BuildContext context, DateTime initialDateTime) {
    DateTime minimumDateTime =
        DateTime.now().subtract(const Duration(days: 40));
    DateTime maximumDateTime = DateTime.now();

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builderContext) {
        return Container(
          height: 200,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.dateAndTime,
            initialDateTime: initialDateTime,
            minimumDate: minimumDateTime,
            maximumDate: maximumDateTime,
            onDateTimeChanged: (DateTime newDateTime) {
              print('New DateTime: $newDateTime');
              setState(() {
                startDate = newDateTime;
                print('Updated startDate: $startDate');
                widget.onDateStratTimeChanged?.call(startDate);
              });
            },
          ),
        );
      },
    );
  }
}
