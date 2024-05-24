import 'package:baba_tracker/common/color_extension.dart';
import 'package:baba_tracker/common_widgets/linkapi.dart';
import 'package:baba_tracker/models/babyinfo.dart';
import 'package:baba_tracker/provider/babyInfoDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChildrenProfile extends StatefulWidget {
  const ChildrenProfile({super.key});

  @override
  State<ChildrenProfile> createState() => _ChildrenProfileState();
}

class _ChildrenProfileState extends State<ChildrenProfile> {
  late BabyProvider babyProvider;

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
                  width: 35,
                ),
                Text(
                  'Children',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
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
            Consumer<BabyProvider>(
              builder: (context, babyProvider, _) {
                List<BabyInfo> babies = babyProvider.babyRecords;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: babies.map((baby) {
                      bool isActive =
                          baby.infoId.toString() == babyProvider.activeBabyId;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isActive
                                      ? Colors.green
                                      : Colors.transparent,
                                  width: 3.0, // Width of the border
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                radius: 30,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: baby.image!.isNotEmpty
                                      ? Image.network(
                                          "$linkImageFile/${baby.image}",
                                          fit: BoxFit.cover,
                                          width: 60,
                                          height: 60,
                                        )
                                      : Image.asset(
                                          "assets/images/profile.png",
                                          fit: BoxFit.cover,
                                          width: 30,
                                          height: 30,
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              baby.babyName!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
