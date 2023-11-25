import 'package:baby_tracker/common/color_extension.dart';
import 'package:baby_tracker/common_widgets/tab_button.dart';
import 'package:baby_tracker/view/home/blank_view.dart';
import 'package:baby_tracker/view/home/home_view.dart';
import 'package:flutter/material.dart';

class MainTab extends StatefulWidget {
  const MainTab({super.key});

  @override
  State<MainTab> createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();
  Widget currenttab = const HomeView();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: PageStorage(
        bucket: pageBucket,
        child: currenttab,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
            decoration: BoxDecoration(color: Tcolor.white, boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 2, offset: Offset(0, -2))
            ]),
            height: kToolbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TabButton(
                    icon: "assets/images/home_icon.png",
                    selectedicon: "assets/images/home_icon.png",
                    isActive: selectTab == 0,
                    onTap: () {
                      selectTab = 0;
                      currenttab = const HomeView();
                      if (mounted) {
                        setState(() {});
                      }
                    }),
                TabButton(
                    icon: "assets/images/tracking_icon.png",
                    selectedicon: "assets/images/tracking_icon.png",
                    isActive: selectTab == 1,
                    onTap: () {
                      selectTab = 1;
                      currenttab = const BlankView();
                      if (mounted) {
                        setState(() {});
                      }
                    }),
                TabButton(
                    icon: "assets/images/more_ square1.png",
                    selectedicon: "assets/images/more_ square1.png",
                    isActive: selectTab == 2,
                    onTap: () {
                      selectTab = 2;
                      currenttab = const BlankView();
                      if (mounted) {
                        setState(() {});
                      }
                    })
              ],
            )),
      ),
    );
  }
}
