import 'dart:io';
import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/common_widgets/linkapi.dart';
import 'package:baby_tracker/common_widgets/round_button.dart';
import 'package:baby_tracker/controller/faceDayController.dart';
import 'package:baby_tracker/models/faceModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
                    onPressed: () {},
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
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Close',
                      style: TextStyle(color: Colors.blue.shade200),
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
                    onPressed: () {
                      if (widget.faceData.imageId != null) {
                        faceDayController.deleteImage(widget.faceData.imageId!);
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
                        faceDayController.editImage(
                            FaceData(
                              date: widget.faceData.date,
                              image: widget.faceData.image,
                              imageId: widget.faceData.imageId!,
                            ),
                            imagefile: myfile!);
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
