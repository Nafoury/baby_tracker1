import 'package:baba_tracker/common/color_extension.dart';
import 'package:baba_tracker/common_widgets/crud.dart';
import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:baba_tracker/models/ImageModel.dart';
import 'package:baba_tracker/models/babyinfo.dart';
import 'package:baba_tracker/provider/UserImageProvider.dart';
import 'package:baba_tracker/provider/babyInfoDataProvider.dart';
import 'package:baba_tracker/view/editionanddeletion/babyEdit_deletion.dart';
import 'package:baba_tracker/view/profiles/baby_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MomProfile extends StatefulWidget {
  const MomProfile({Key? key}) : super(key: key);

  @override
  State<MomProfile> createState() => _MomProfileState();
}

class _MomProfileState extends State<MomProfile> {
  late SharedPreferences sharedPref;
  late String firstName = '';
  late String babyName = '';
  late BabyProvider babyProvider;
  late UserImageProvider userImageProvider;
  late File? myfile;
  late File? Updatedfile;
  List<UserData> userimage = [];
  late UserData userData;
  Crud crud = new Crud();

  @override
  void didChangeDependencies() {
    babyProvider = Provider.of<BabyProvider>(context, listen: true);
    setInitialActiveBaby();
    userImageProvider = Provider.of<UserImageProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    loadDataFromSharedPreferences();
  }

  loadDataFromSharedPreferences() async {
    sharedPref = await SharedPreferences.getInstance();
    setState(() {
      firstName = sharedPref.getString('first_name') ?? '';
      babyName = sharedPref.getString('baby_name') ?? '';
    });
  }

  void setInitialActiveBaby() {
    if (babyProvider.activeBabyId == null &&
        babyProvider.babyRecords.isNotEmpty) {
      // If no active baby is set and there are babies registered, set the first baby as active
      babyProvider.makeBabyActive(babyProvider.babyRecords.first.infoId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 45,
                ),
                Text(
                  "Profile",
                  style: TextStyle(
                      color: Tcolor.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
                TextButton(
                  onPressed: () {
                    Get.offAllNamed("/mainTab");
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.blue.shade200),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$firstName',
                  style: TextStyle(
                      color: Tcolor.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  minRadius: 25,
                  maxRadius: 25,
                  child: userImageProvider.userData.first.image!.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                height: 130,
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        XFile? xFile =
                                            await ImagePicker().pickImage(
                                          source: ImageSource.gallery,
                                        );
                                        setState(() {
                                          Updatedfile = File(xFile!.path);
                                        });
                                        Navigator.pop(context);
                                        userImageProvider.editUserImage(
                                            userData: UserData(
                                              id: int.parse(sharedPref
                                                  .getString("id")
                                                  .toString()),
                                            ),
                                            imageFile: Updatedfile!);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child:
                                            Text("Upload Image From Gallery"),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        XFile? xFile =
                                            await ImagePicker().pickImage(
                                          source: ImageSource.camera,
                                        );
                                        setState(() {
                                          Updatedfile = File(xFile!.path);
                                        });
                                        Navigator.pop(context);
                                        userImageProvider.editUserImage(
                                            userData: UserData(
                                              id: int.parse(sharedPref
                                                  .getString("id")
                                                  .toString()),
                                            ),
                                            imageFile: Updatedfile!);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Text("Choose from Camera"),
                                      ),
                                    ),
                                    if (userImageProvider
                                            .userData.first.image !=
                                        null)
                                      InkWell(
                                        onTap: () async {
                                          // Delete the image
                                          bool success = await userImageProvider
                                              .deleteUserImage(userImageProvider
                                                  .userData.first.image!);
                                          if (success) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                duration: Duration(
                                                    milliseconds: 1500),
                                                backgroundColor: Tcolor.gray
                                                    .withOpacity(0.3),
                                                content: Text(
                                                    "Photo was successfully deleted."),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                duration: Duration(
                                                    milliseconds: 1500),
                                                backgroundColor: Tcolor.gray
                                                    .withOpacity(0.4),
                                                content: Text(
                                                    "Failed to delete photo."),
                                              ),
                                            );
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            "Delete photo",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: userImageProvider
                                    .userData.first.image!.isNotEmpty
                                ? Image.network(
                                    "$linkImageFile/${userImageProvider.userData.first.image}",
                                    fit: BoxFit.cover,
                                    width: 200,
                                    height: 200,
                                  )
                                : Image.asset(
                                    "assets/images/profile.png",
                                    fit: BoxFit.fitHeight,
                                    width: 20,
                                    height: 20,
                                  ),
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                height: 100,
                                child: Column(children: [
                                  InkWell(
                                    onTap: () async {
                                      XFile? xFile =
                                          await ImagePicker().pickImage(
                                        source: ImageSource.gallery,
                                      );
                                      setState(() {
                                        myfile = File(xFile!.path);
                                      });
                                      Navigator.pop(context);
                                      userImageProvider.saveUserImage(
                                        userData: UserData(
                                          id: int.parse(sharedPref
                                              .getString("id")
                                              .toString()),
                                        ),
                                        imageFile: myfile!,
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text("Upload Image From Gallery"),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      XFile? xFile =
                                          await ImagePicker().pickImage(
                                        source: ImageSource.camera,
                                      );
                                      setState(() {
                                        myfile = File(xFile!.path);
                                      });
                                      Navigator.pop(context);

                                      userImageProvider.saveUserImage(
                                        userData: UserData(
                                          id: int.parse(sharedPref
                                              .getString("id")
                                              .toString()),
                                        ),
                                        imageFile: myfile!,
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text("Choose from Camera"),
                                    ),
                                  ),
                                ]),
                              ),
                            );
                          },
                          icon: Image.asset(
                            "assets/images/profile.png",
                            fit: BoxFit.fitHeight,
                            height: 20,
                            width: 20,
                          ),
                        ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Divider(), // Adding a divider
            Text(
              'Children',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            Consumer<BabyProvider>(
              builder: (context, babyProvider, _) {
                List<BabyInfo> babies = babyProvider.babyRecords;
                bool showAddButton = babies.length < 3;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: babies.length,
                      itemBuilder: (context, index) {
                        BabyInfo baby = babies[index];
                        bool isactive =
                            baby.infoId.toString() == babyProvider.activeBabyId;
                        return TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BabyProfileEditAndDeletion(
                                          babyInfo: baby)),
                            );
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                baby.gender == 'Male'
                                    ? "assets/images/baby_boy.png"
                                    : "assets/images/baby-girl1.png",
                                width: 20,
                                height: 20,
                                color: Colors.blue.shade300,
                              ),
                              SizedBox(width: 8),
                              Text(baby.babyName!),
                              SizedBox(
                                width: 10,
                              ),
                              if (isactive)
                                Text(
                                  "Active",
                                  style: TextStyle(
                                      color: Tcolor.black,
                                      fontWeight: FontWeight.bold),
                                )
                            ],
                          ),
                        );
                      },
                    ),
                    if (showAddButton) // Conditionally render the button
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BabyProfile()),
                          );
                        },
                        icon: CircleAvatar(
                          backgroundColor: Colors.white,
                          minRadius: 12,
                          maxRadius: 12,
                          child: Icon(
                            Icons.add,
                            color: Colors.blue,
                          ),
                        ),
                        label: Text(
                          'Add Another child',
                          style: TextStyle(
                            color: Tcolor.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            Divider(), // Adding a divider
            TextButton.icon(
              onPressed: () {
                sharedPref.clear();

                Navigator.of(context)
                    .pushNamedAndRemoveUntil("login", (route) => false);
              },
              icon: CircleAvatar(
                backgroundColor: Colors.white,
                minRadius: 12,
                maxRadius: 12,
                child: Icon(
                  Icons.logout,
                  color: Colors.blue,
                ),
              ),
              label: Text(
                'Sign out',
                style: TextStyle(
                  color: Tcolor.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
