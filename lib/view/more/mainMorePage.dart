import 'package:baba_tracker/view/more/activities.dart';
import 'package:baba_tracker/view/more/face_day.dart';
import 'package:baba_tracker/view/more/guids.dart';
import 'package:baba_tracker/view/more/toothPage1.dart';
import 'package:baba_tracker/view/more/toothPgae.dart';
import 'package:flutter/material.dart';
import 'package:baba_tracker/common/color_extension.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePage();
}

class _MorePage extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(25), // Adjust the bottom margin as needed
              child: Text(
                "More",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            Expanded(
              child: GridView(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FaceAday()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade100,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/face.png",
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Face_A_Day",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w700),
                            )
                          ]),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade100,
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/milestone.png",
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Milestones",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                        ]),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Activities()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade100,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/guide.png",
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Guides",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w700),
                            ),
                          ]),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeethWidget()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade100,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/teeth.png",
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Teeth",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w700),
                            ),
                          ]),
                    ),
                  ),
                ],
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
