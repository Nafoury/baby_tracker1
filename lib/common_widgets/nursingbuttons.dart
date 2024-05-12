import 'dart:async';
import 'package:baby_tracker/main.dart';
import 'package:baby_tracker/provider/nursingDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/controller/feedNursing.dart';
import 'package:baby_tracker/models/nursingData.dart';
import 'package:provider/provider.dart';

class RoundButton1 extends StatefulWidget {
  const RoundButton1({
    Key? key,
  }) : super(key: key);

  @override
  _RoundButton1State createState() => _RoundButton1State();
}

class _RoundButton1State extends State<RoundButton1> {
  bool isButtonLTapped = false;
  bool isButtonRTapped = false;
  bool isTimerLRunning = false;
  bool isTimerRRunning = false;
  DateTime? startTimeL;
  DateTime? startTimeR;
  late Duration elapsedTimeL = Duration.zero;
  late Duration elapsedTimeR = Duration.zero;
  late Timer timerL;
  late Timer timerR;
  late StreamController<String> timerControllerL;
  late StreamController<String> timerControllerR;
  DateTime? startDate;
  Function(DateTime)? onDateStratTimeChanged;
  DateTime dateTime = DateTime.now();
  NursingController nursingController = NursingController();
  late DateTime startDate1;
  late NursingDataProvider nursingDataProvider;
  late List<NusringData> nursingRecors = [];

  @override
  void initState() {
    super.initState();
    startDate1 = DateTime.now();
    timerControllerL = StreamController<String>.broadcast();
    timerControllerR = StreamController<String>.broadcast();
  }

  @override
  void dispose() {
    timerControllerL.close();
    timerControllerR.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    nursingDataProvider =
        Provider.of<NursingDataProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          height: 400,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Tcolor.primaryColor1.withOpacity(0.4)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tap the button L or R to\n begin the timer with",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isButtonLTapped = true;
                        isButtonRTapped = false;
                        if (isButtonLTapped) {
                          _startTimer('L');
                        }
                      });
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isButtonLTapped
                            ? Tcolor.primaryColor1.withOpacity(0.8)
                            : Colors.purpleAccent.shade100.withOpacity(0.2),
                        border: isButtonLTapped
                            ? null // Remove the border if isButtonLTapped is true
                            : Border.all(
                                color: Colors.purple.shade100,
                                width: 2.0,
                              ),
                      ),
                      child: Center(
                        child: Text(
                          "L",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isButtonRTapped = true;
                        isButtonLTapped = false;
                        if (isButtonRTapped) {
                          _startTimer('R');
                        }
                      });
                    },
                    child: Container(
                      width: 60,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isButtonRTapped
                            ? Tcolor.primaryColor1.withOpacity(0.8)
                            : Colors.purpleAccent.shade100.withOpacity(0.2),
                        border: isButtonRTapped
                            ? null // Remove the border if isButtonLTapped is true
                            : Border.all(
                                color: Colors.purple.shade100,
                                width: 2.0,
                              ),
                      ),
                      child: Center(
                        child: Text(
                          'R',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StreamBuilder<String>(
                    stream: timerControllerL.stream,
                    initialData: '00:00',
                    builder: (context, snapshot) {
                      return Text(
                        '  ${snapshot.data ?? "00:00"}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  StreamBuilder<String>(
                    stream: timerControllerR.stream,
                    initialData: '00:00',
                    builder: (context, snapshot) {
                      return Text(
                        '  ${snapshot.data ?? "00:00"}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Visibility(
            visible: isButtonLTapped || isButtonRTapped,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _stopTimer();
                      },
                      child: Text(
                        'Stop',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _resetTimer();
                      },
                      child: Text(
                        'Reset',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    _showStartDatePicker(
                        context, startDate1); // Show date picker for start date
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors
                            .purpleAccent.shade100, // Set the border color here
                        width: 2.0, // Set the border width
                      ),
                      borderRadius:
                          BorderRadius.circular(10.0), // Set the border radius
                    ),
                    child: Text(
                      DateFormat('dd MMM yyyy  HH:mm').format(startDate1),
                      style: TextStyle(
                        color: Colors.purpleAccent.shade100,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ],
    );
  }

  void _startTimer(String side) {
    setState(() {
      if (side == 'L') {
        isTimerLRunning = true;
        isTimerRRunning = false;
        startTimeL = DateTime.now();
        elapsedTimeL = Duration.zero;
        timerL = Timer.periodic(Duration(seconds: 1), (Timer timer) {
          if (!isTimerLRunning) {
            timer.cancel();
          } else {
            setState(() {
              elapsedTimeL = DateTime.now().difference(startTimeL!);
              timerControllerL.add(_formatDuration(elapsedTimeL));
            });
          }
        });
      } else if (side == 'R') {
        isTimerRRunning = true;
        isTimerLRunning = false;
        startTimeR = DateTime.now();
        elapsedTimeR = Duration.zero;
        timerR = Timer.periodic(Duration(seconds: 1), (Timer timer) {
          if (!isTimerRRunning) {
            timer.cancel();
          } else {
            setState(() {
              elapsedTimeR = DateTime.now().difference(startTimeR!);
              timerControllerR.add(_formatDuration(elapsedTimeR));
            });
          }
        });
      }
    });
  }

  void _stopTimer() async {
    setState(() {
      if (isTimerLRunning) {
        isTimerLRunning = false;
        elapsedTimeL = DateTime.now().difference(startTimeL!);
        timerL.cancel();
      } else if (isTimerRRunning) {
        isTimerRRunning = false;
        elapsedTimeR = DateTime.now().difference(startTimeR!);
        timerR.cancel();
      }
    });
    // Determine the starting breast side and nursing side based on the sequence of button presses
    String startSide = '';
    String breastSide = '';

    if (isButtonLTapped && isButtonRTapped) {
      // If both buttons were tapped, determine the sequence
      if (startTimeL != null && startTimeR != null) {
        // If both start times are available, check which one comes first
        if (startTimeL!.isBefore(startTimeR!)) {
          startSide = 'L';
          breastSide = 'R';
        } else {
          startSide = 'R';
          breastSide = 'L';
        }
      } else if (startTimeL != null) {
        startSide = 'L';
        breastSide = 'R';
      } else if (startTimeR != null) {
        startSide = 'R';
        breastSide = 'L';
      }
    } else if (isButtonLTapped) {
      startSide = 'L';
      breastSide = 'L';
    } else if (isButtonRTapped) {
      startSide = 'R';
      breastSide = 'R';
    }
    nursingDataProvider.addNursingData(NusringData(
      leftDuration: _formatDuration(elapsedTimeL),
      date: startDate1,
      nursingSide: breastSide,
      startingBreast: startSide,
      rightDuration: _formatDuration(elapsedTimeR),
      babyId: sharedPref.getString("info_id"),
    ));
  }

  void _resetTimer() {
    setState(() {
      isButtonLTapped = false;
      isButtonRTapped = false;
      isTimerLRunning = false;
      isTimerRRunning = false;
    });

    timerControllerL.add('00:00');
    timerControllerR.add('00:00');
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
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
                startDate1 = newDateTime;
              });
            },
          ),
        );
      },
    );
  }
}
