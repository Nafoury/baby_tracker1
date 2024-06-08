import 'dart:io';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:baba_tracker/common_widgets/round_button.dart';
import 'package:baba_tracker/controller/faceDayController.dart';
import 'package:baba_tracker/models/faceModel.dart';
import 'package:baba_tracker/provider/babyInfoDataProvider.dart';
import 'package:baba_tracker/provider/babyfaceDay.dart';
import 'package:baba_tracker/view/more/face_day.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class BabyFaceEdit extends StatefulWidget {
  final FaceData faceData;

  const BabyFaceEdit({Key? key, required this.faceData}) : super(key: key);

  @override
  State<BabyFaceEdit> createState() => _BabyFaceEditState();
}

class _BabyFaceEditState extends State<BabyFaceEdit> {
  DateTime? startDate = DateTime.now();
  late String image;
  File? myfile;
  FaceDayController faceDayController = new FaceDayController();
  String? selectedImagePath;
  late BabyProvider babyProvider;
  late FaceDayProvider faceDayProvider;

  @override
  void didChangeDependencies() {
    babyProvider =
        Provider.of<BabyProvider>(context, listen: true); // Access BabyProvider
    faceDayProvider = Provider.of<FaceDayProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.offAllNamed('/faceADay');
                    },
                    icon: Image.asset(
                      "assets/images/back_Navs.png",
                      width: 25,
                      height: 25,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Text(
                    "Edit",
                    style: TextStyle(
                      color: Tcolor.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    " ${babyProvider.activeBaby?.babyName ?? 'Baby'}", // Access active baby's name
                    style: TextStyle(
                      color: Tcolor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade300,
                height: 2,
              ),
              SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () {
                  // Show options for picking image
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Wrap(
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
                                XFile? xFile = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                setState(() {
                                  myfile = File(xFile!.path);
                                  selectedImagePath = xFile.path;
                                });
                                Navigator.of(context).pop();
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
                                  selectedImagePath = xFile.path;
                                });
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Text("Choose from Camera"),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: selectedImagePath != null
                        ? Image.file(
                            File(selectedImagePath!),
                            width: double.infinity,
                            fit: BoxFit.contain,
                          )
                        : Image.network(
                            "$linkImageFile/${widget.faceData.image}",
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (widget.faceData.imageId != null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirm Deletion"),
                              content: Text(
                                  "Are you sure you want to delete this photo?"),
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
                                    await faceDayProvider.deleteUserImage(
                                        widget.faceData.imageId!);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Durations.medium1,
                                        backgroundColor:
                                            Tcolor.gray.withOpacity(0.4),
                                        content: Text(
                                            "photo was successfully deleted."),
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                    Get.offAllNamed('/faceADay');

                                    // Go back to the previous page
                                  },
                                  child: Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      'Delete ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.red.shade300,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (widget.faceData.imageId != null) {
                        faceDayProvider.editUserImage(
                            faceData: FaceData(
                              date: widget.faceData.date,
                              image: widget.faceData.image,
                              imageId: widget.faceData.imageId!,
                            ),
                            imageFile: myfile!);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Image.asset(
                                "assets/images/change.png",
                                height: 60,
                                width: 60,
                              ),
                              content: Text("Photo  was successfully updated."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Get.offAllNamed('/faceADay');
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      'Edit ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue.shade300,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
