import 'dart:io';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:baba_tracker/controller/faceDayController.dart';
import 'package:baba_tracker/models/faceModel.dart';
import 'package:baba_tracker/view/editionanddeletion/babyFaceEdit_Deletion.dart';
import 'package:baba_tracker/view/tracking/growthT.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DayItem extends StatefulWidget {
  final FaceData faceData;
  DayItem({required this.faceData});

  @override
  _DayItemState createState() => _DayItemState();
}

class _DayItemState extends State<DayItem> {
  late File? myfile;
  late FaceData faceData;
  late FaceDayController faceDayController;

  @override
  void initState() {
    super.initState();
    faceData = FaceData();
    faceDayController = FaceDayController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: GestureDetector(
          onTap: () {
            if (widget.faceData.image == null) {
              showBottomSheet(
                context: context,
                builder: (context) => Container(
                  height: 100,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          XFile? xFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          setState(() {
                            myfile = File(xFile!.path);
                          });
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirm Adding"),
                                  content: Text(
                                      "Are you sure you want to add this photo"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        faceDayController.savefaceData(
                                            faceData:
                                                FaceData(date: DateTime.now()),
                                            imagefile: myfile!);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            duration: Durations.medium1,
                                            backgroundColor:
                                                Tcolor.gray.withOpacity(0.4),
                                            content: Text(
                                                "Photo was successfully added."),
                                          ),
                                        );
                                        Navigator.of(context).pop();

                                        // Go back to the previous page
                                      },
                                      child: Text("Add"),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text("Upload Image From Gallery"),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          XFile? xFile = await ImagePicker()
                              .pickImage(source: ImageSource.camera);
                          setState(() {
                            myfile = File(xFile!.path);
                          });
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirm Adding"),
                                  content: Text(
                                      "Are you sure you want to add this photo"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        faceDayController.savefaceData(
                                            faceData:
                                                FaceData(date: DateTime.now()),
                                            imagefile: myfile!);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            duration: Durations.medium1,
                                            backgroundColor:
                                                Tcolor.gray.withOpacity(0.4),
                                            content: Text(
                                                "Photo was successfully added."),
                                          ),
                                        );
                                        Navigator.of(context).pop();

                                        // Go back to the previous page
                                      },
                                      child: Text("Add"),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text("Choose from Camera"),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BabyFaceEdit(
                            faceData: widget.faceData,
                          )));
            }
          },
          child: Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.grey.shade200,
            ),
            child: widget.faceData.image != null
                ? ClipRRect(
                    child: Image.network(
                      "$linkImageFile/${widget.faceData.image}",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  )
                : Container(
                    // Return a placeholder widget when faceData.image is null
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey.shade200,
                    ),
                  ),
          ),
        ),
      )
    ]);
  }
}
