import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:baba_tracker/common/color_extension.dart';
import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:baba_tracker/models/faceModel.dart';
import 'package:baba_tracker/provider/babyfaceDay.dart';
import 'package:baba_tracker/view/editionanddeletion/babyFaceEdit_Deletion.dart';

class FaceAday extends StatefulWidget {
  const FaceAday({Key? key}) : super(key: key);

  @override
  _FaceAdayState createState() => _FaceAdayState();
}

class _FaceAdayState extends State<FaceAday> {
  late File? myfile;
  List<FaceData> userImages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  void fetchData() async {
    try {
      final faceDayProvider =
          Provider.of<FaceDayProvider>(context, listen: false);
      List<FaceData> records = await faceDayProvider.getImageRecord();
      setState(() {
        userImages = records;
      });
    } catch (e) {
      print('Error fetching images: $e');
    }
  }

  void _showImagePicker(BuildContext context, FaceData faceData) {
    showBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 100,
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                XFile? xFile =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (xFile != null) {
                  File file = File(xFile.path);
                  Navigator.of(context).pop(); // Close the bottom sheet
                  _showConfirmationDialog(context, faceData, file);
                }
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text("Upload Image From Gallery"),
              ),
            ),
            InkWell(
              onTap: () async {
                XFile? xFile =
                    await ImagePicker().pickImage(source: ImageSource.camera);
                if (xFile != null) {
                  File file = File(xFile.path);
                  Navigator.of(context).pop(); // Close the bottom sheet
                  _showConfirmationDialog(context, faceData, file);
                }
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text("Choose from Camera"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context, FaceData faceData, File file) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Adding"),
          content: Text("Are you sure you want to add this photo?"),
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
                final faceDayProvider =
                    Provider.of<FaceDayProvider>(context, listen: false);
                await faceDayProvider.saveUserImage(
                    faceData: faceData, imageFile: file);
                if (mounted) {
                  setState(() {
                    fetchData(); // Refresh the data
                  });
                  Future.delayed(Duration(milliseconds: 100), () {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 2),
                          backgroundColor: Tcolor.gray.withOpacity(0.4),
                          content: Text("Photo was successfully added."),
                        ),
                      );
                    }
                  });
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FaceDayProvider>(
      builder: (context, faceDayProvider, child) {
        return Scaffold(
          backgroundColor: Tcolor.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.offAllNamed('/mainTab', arguments: 2);
                        },
                        icon: Image.asset(
                          "assets/images/back_Navs.png",
                          width: 25,
                          height: 25,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(width: 75),
                      Text(
                        "Face A Day",
                        style: TextStyle(
                          color: Tcolor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: 30,
                      itemBuilder: (context, index) {
                        if (index < userImages.length) {
                          return GestureDetector(
                            onTap: () {
                              if (userImages[index].image!.isEmpty) {
                                _showImagePicker(context, userImages[index]);
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BabyFaceEdit(
                                        faceData: userImages[index]),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.grey.shade200,
                              ),
                              child: userImages[index].image!.isNotEmpty
                                  ? ClipRRect(
                                      child: Image.network(
                                        "$linkImageFile/${userImages[index].image}",
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    )
                                  : Container(
                                      margin: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () {
                              _showImagePicker(
                                  context, FaceData(date: DateTime.now()));
                            },
                            child: Container(
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.grey.shade200,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
