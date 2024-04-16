import 'package:baby_tracker/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DayItem extends StatelessWidget {
  final int day;

  DayItem(this.day);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showBottomSheet(
            context: context,
            builder: (context) => Container(
                  height: 100,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          XFile? xFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
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
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text("Choose from Camera"),
                        ),
                      )
                    ],
                  ),
                ));
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade200, // or any other color
        ),
        child: Center(
          child: Text(
            day.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
