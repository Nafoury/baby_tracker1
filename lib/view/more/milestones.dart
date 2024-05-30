import 'package:baba_tracker/controller/milesStonesController.dart';
import 'package:baba_tracker/models/milestonesModel.dart';
import 'package:baba_tracker/view/editionanddeletion/babymilestone.dart';
import 'package:baba_tracker/view/more/dataRange.dart';
import 'package:baba_tracker/view/more/milestone.dart';
import 'package:flutter/material.dart';

class Milestones extends StatefulWidget {
  const Milestones({super.key});

  @override
  _MilestonesState createState() => _MilestonesState();
}

class _MilestonesState extends State<Milestones> {
  int _selectedMonth = 1;
  late MileStonesController mileStonesController = new MileStonesController();
  Set<String> pickedMilestones = {};

  final List<Map<String, dynamic>> milestoneData = [
    {
      'range': '1-3',
      'milestones': [
        'Startles by...',
        'Ooo/Aah sounds',
        'Looks in direction of voice'
      ],
      'color': Colors.orange
    },
    {
      'range': '2-4',
      'milestones': [
        'Smiles spontaneously',
        'Social smile',
        'Looks at own hand'
      ],
      'color': Colors.pink
    },
    {
      'range': '4-8',
      'milestones': [
        'Laughing and squealing',
        'Babling',
      ],
      'color': Colors.green
    },
    {
      'range': '8-10',
      'milestones': ['Feeds self', 'Bangs toys together', 'Stands alone'],
      'color': Colors.blue
    },
    {
      'range': '10-12',
      'milestones': ['Mama/Dada specific', 'Uses spoon', 'Waves bye-bye'],
      'color': Colors.yellow
    },
    // Add more ranges and milestones as needed
  ];
  @override
  void initState() {
    super.initState();
    _retrieveData(); // Call the retrieve data function when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      Navigator.pop(context);
                    },
                    icon: Image.asset(
                      "assets/images/back_Navs.png",
                      width: 25,
                      height: 25,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Text(
                    "MileStones",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                  Spacer(flex: 3),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DateRangeSelector(
                  selectedMonth: _selectedMonth,
                  onMonthSelected: (month) {
                    setState(() {
                      _selectedMonth = month;
                    });
                  },
                ),
              ),
              Expanded(
                child: MilestoneList(
                  milestones: getMilestonesForMonth(_selectedMonth),
                  onDatePicked: saveMilestone,
                  pickedMilestones: pickedMilestones,
                  context: context,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> getMilestonesForMonth(int month) {
    return milestoneData.where((data) {
      int start = int.parse(data['range'].split('-')[0]);
      int end = int.parse(data['range'].split('-')[1]);
      return month >= start && month <= end;
    }).toList();
  }

  Future<void> saveMilestone(String label, DateTime date) async {
    await mileStonesController.saveData(
        milestones: MilestoneData(date: date, label: label));
    setState(() {
      pickedMilestones.add(label);
    });
  }

  void _retrieveData() async {
    var data = await mileStonesController.retrieveWeightData();
    setState(() {
      pickedMilestones = data
          .where((entry) => entry.label != null)
          .map((entry) => entry.label!)
          .toSet();
    });
  }
}
