class MilestoneData {
  int? milestoneId;
  DateTime? date;
  String? label;
  String? babyId;

  MilestoneData({
    this.milestoneId,
    this.date,
    this.label,
    this.babyId,
  });

  MilestoneData.fromJson(Map<String, dynamic> json) {
    milestoneId = json['milestone_id'];
    date = DateTime.parse(json['date']);
    label = json['label'];
    babyId = json['baby_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['milestone_id'] = this.milestoneId;
    data['date'] = this.date?.toIso8601String();
    data['label'] = this.label;
    data['baby_id'] = this.babyId;
    return data;
  }
}
