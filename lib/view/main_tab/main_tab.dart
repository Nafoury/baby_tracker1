import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/common_widgets/tab_button.dart';
import 'package:baby_tracker/view/home/blank_view.dart';
import 'package:baby_tracker/view/home/home_view.dart';
import 'package:baby_tracker/view/more/mainMorePage.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracker/view/tracking/mainTracking.dart';

class MainTab extends StatefulWidget {
  const MainTab({Key? key}) : super(key: key);

  @override
  State<MainTab> createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  int selectTab = 0;
  late Widget currenttab;

  @override
  void initState() {
    super.initState();
    currenttab = const HomeView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: currenttab,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Tcolor.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, -1),
            )
          ],
        ),
        height: kToolbarHeight + MediaQuery.of(context).padding.bottom,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TabButton(
                icon: "assets/images/home_icon.png",
                selectedicon: "assets/images/home_icon.png",
                isActive: selectTab == 0,
                onTap: () {
                  if (mounted) {
                    setState(() {
                      selectTab = 0;
                      currenttab = const HomeView();
                    });
                  }
                },
              ),
            ),
            Expanded(
              child: TabButton(
                icon: "assets/images/tracking_icon.png",
                selectedicon: "assets/images/tracking_icon.png",
                isActive: selectTab == 1,
                onTap: () {
                  if (mounted) {
                    setState(() {
                      selectTab = 1;
                      currenttab = const TrackingPage();
                    });
                  }
                },
              ),
            ),
            Expanded(
              child: TabButton(
                icon: "assets/images/more_ square1.png",
                selectedicon: "assets/images/more_ square1.png",
                isActive: selectTab == 2,
                onTap: () {
                  if (mounted) {
                    setState(() {
                      selectTab = 2;
                      currenttab = const MorePage();
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
