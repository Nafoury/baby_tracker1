import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/common_widgets/on_boarding_page.dart';
import 'package:baby_tracker/view/login/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoradingView1 extends StatefulWidget {
  const OnBoradingView1({
    super.key,
  });

  @override
  State<OnBoradingView1> createState() => _OnBoradingView1State();
}

class _OnBoradingView1State extends State<OnBoradingView1> {
  int selectpage = 0;
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      selectpage = controller.page?.round() ?? 0;

      setState(() {});
    });
  }

  List pageArray = [
    {
      "title": "Track Your Baby Daily",
      "subtitle":
          "Don't worry if you have trouble in monitoring and recording your baby activities , We can help you recording baby’s activities and track it.",
      "image": "assets/images/baby_mum1.png",
    },
    {
      "title": "Track Baby Growth",
      "subtitle":
          "Tracking baby growth involves monitoring head circlum,weight and height ",
      "image": "assets/images/baby_mum23.png",
    },
    {
      "title": "Baby Memories",
      "subtitle":
          "suggests the act of capturing and preserving significant or memorable events in your baby's life, such as their first steps,or other milestones",
      "image": "assets/images/mum_baby3.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PageView.builder(
              controller: controller,
              itemCount: pageArray.length,
              itemBuilder: (context, index) {
                var pages = pageArray[index] as Map? ?? {};
                return OnBoardingPage(
                  pages: pages,
                );
              }),
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    color: Tcolor.primaryColor1,
                    value: (selectpage + 1) / 3,
                    strokeWidth: 2,
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Tcolor.primaryColor1,
                      borderRadius: BorderRadius.circular(35)),
                  child: IconButton(
                    icon: Icon(
                      Icons.navigate_next,
                      color: Tcolor.white,
                      size: 35,
                    ),
                    onPressed: () {
                      if (selectpage < 2) {
                        selectpage = selectpage + 1;
                        controller.animateToPage(selectpage,
                            duration: const Duration(microseconds: 300),
                            curve: Curves.bounceIn);
                        setState(() {});
                      } else {
                        Get.to(Signup());
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
