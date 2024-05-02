import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/models/babyinfo.dart';
import 'package:baby_tracker/provider/babyInfoDataProvider.dart';
import 'package:baby_tracker/view/editionanddeletion/babyEdit_deletion.dart';
import 'package:baby_tracker/view/profiles/baby_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void didChangeDependencies() {
    babyProvider = Provider.of<BabyProvider>(context, listen: false);
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
                    Navigator.pop(context);
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
                  child: IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      "assets/images/profile.png",
                      fit: BoxFit.fitHeight,
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
                // Check if the number of babies is less than 3 to determine visibility of the button
                bool showAddButton = babies.length < 3;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: babies.length,
                      itemBuilder: (context, index) {
                        BabyInfo baby = babies[index];
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
