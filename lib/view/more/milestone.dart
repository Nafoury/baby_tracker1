import 'package:baba_tracker/controller/milesStonesController.dart';
import 'package:baba_tracker/models/milestonesModel.dart';
import 'package:baba_tracker/view/editionanddeletion/babymilestone.dart';
import 'package:flutter/material.dart';

class MilestoneList extends StatelessWidget {
  final List<Map<String, dynamic>> milestones;
  final Function(String, DateTime) onDatePicked;
  final Set<String> pickedMilestones;
  final BuildContext context; // Add BuildContext parameter

  const MilestoneList({
    required this.milestones,
    required this.onDatePicked,
    required this.pickedMilestones,
    required this.context, // Accept BuildContext from parent widget
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: milestones.length,
      itemBuilder: (context, index) {
        var milestoneSet = milestones[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' ${milestoneSet['range']} months',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...milestoneSet['milestones'].map<Widget>((milestone) {
              bool isPicked = pickedMilestones.contains(milestone);
              return MilestoneCard(
                label: milestone,
                color: milestoneSet['color'],
                onDatePicked: (pickedDate) {
                  onDatePicked(milestone, pickedDate);
                },
                isPicked: isPicked,
                onEdit: () async {
                  if (isPicked) {
                    MilestoneData? milestoneData =
                        await _retrieveMilestoneData(milestone);
                    if (milestoneData != null) {
                      _onMilestoneSelected(
                          milestoneData, context); // Pass context
                    }
                  } else {
                    // Prompt user to pick a date
                  }
                },
              );
            }).toList(),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Future<MilestoneData?> _retrieveMilestoneData(String label) async {
    MileStonesController mileStonesController = MileStonesController();
    var data = await mileStonesController.retrieveWeightData();
    return data.firstWhere((entry) => entry.label == label,
        orElse: () => MilestoneData());
  }

  void _onMilestoneSelected(MilestoneData milestoneData, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MileStoneEdit(
          entryData: milestoneData,
        ),
      ),
    );
  }
}

class MilestoneCard extends StatelessWidget {
  final String label;
  final Color color;
  final Function(DateTime) onDatePicked;
  final Function() onEdit;
  final bool isPicked;

  const MilestoneCard({
    required this.label,
    required this.color,
    required this.onDatePicked,
    required this.onEdit,
    required this.isPicked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isPicked) {
          onEdit();
        } else {
          _pickDate(context);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: color,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isPicked)
              Icon(
                Icons.star,
                color: Colors.yellow,
                size: 26,
              ),
          ],
        ),
      ),
    );
  }

  void _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      onDatePicked(pickedDate);
    }
  }
}
