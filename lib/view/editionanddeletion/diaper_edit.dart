import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/main.dart';
import 'package:baby_tracker/models/diaperData.dart';
import 'package:baby_tracker/provider/diaper_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';



class DiaperEdit extends StatefulWidget {
  final DiaperData entryData;

  final Function(DateTime)? onDateStratTimeChanged;

<<<<<<< HEAD
  DiaperEdit({
=======
  const Diaperchange({
    super.key,
>>>>>>> fc7aa2fe89c1cf0e18503a7a61c3435a4a260c41
    required this.entryData,
    this.onDateStratTimeChanged,
  });

  @override
  _DiaperchangeState createState() => _DiaperchangeState();
}

<<<<<<< HEAD
class _DiaperchangeState extends State<DiaperEdit> {
=======
class _DiaperchangeState extends State<Diaperchange> {
  late DiaperProvider diaperProvider;
  Crud crud = Crud();
>>>>>>> fc7aa2fe89c1cf0e18503a7a61c3435a4a260c41
  late DateTime startDate;
  late String status;
  late String note;
  late TextEditingController noteController;
  late DiaperProvider diaperProvider;

<<<<<<< HEAD
  @override
  void didChangeDependencies() {
    diaperProvider = Provider.of<DiaperProvider>(context, listen: false);
    super.didChangeDependencies();
  }

=======
>>>>>>> fc7aa2fe89c1cf0e18503a7a61c3435a4a260c41
  @override
  void initState() {
    super.initState();
    startDate = widget.entryData.startDate;
    status = widget.entryData.status;
    note = widget.entryData.note;
    noteController = TextEditingController(text: note);
  }

  @override
  void didChangeDependencies() {
    diaperProvider = Provider.of<DiaperProvider>(context, listen: false);
    super.didChangeDependencies();
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
                    const SizedBox(width: 85),
                    Text(
                      "Diaper",
                      style: TextStyle(
                        color: Tcolor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 80),
                    TextButton(
                      onPressed: () {
                        if (widget.entryData.changeId != null) {
                          diaperProvider
                              .deleteDiaperRecord(widget.entryData.changeId!);
                        }
<<<<<<< HEAD
                        Navigator.pop(context);
=======
>>>>>>> fc7aa2fe89c1cf0e18503a7a61c3435a4a260c41
                      },
                      child: const Text(
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
                  physics: const NeverScrollableScrollPhysics(),
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
                                style: const TextStyle(
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
                              status ?? 'None',
                              style: const TextStyle(
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

                                decoration: const InputDecoration(
                                  hintText: "note",
                                ),
                              ),
                            ),
                          ],
                        );

                      default:
                        return const SizedBox();
                    }
                  },
                ),
                const SizedBox(height: 20),
                RoundButton(
                    onpressed: () {
                      if (widget.entryData.changeId != null) {
                        diaperProvider.editDiaperRecord(DiaperData(
                            startDate: startDate,
                            note: note,
                            status: status,
                            changeId: widget.entryData.changeId!));
                      }
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
