class MedData {
  int? medId;
  DateTime? date;
  String? type;
  String? note;
  String? babyId;
  bool? isReminderSet;
  String? reminderInterval;

  MedData({
    this.medId,
    this.date,
    this.type,
    this.note,
    this.babyId,
    this.isReminderSet,
    this.reminderInterval,
  });

  MedData.fromJson(Map<String, dynamic> json) {
    medId = json['med_id'];
    date = DateTime.parse(json['date']);
    type = json['type'];
    note = json['note'];
    babyId = json['baby_id'].toString();
    isReminderSet = json['is_reminder_set'] == 1;
    reminderInterval = json['reminder_interval'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['med_id'] = this.medId;
    data['date'] = this.date?.toIso8601String();
    data['type'] = this.type;
    data['note'] = this.note;
    data['baby_id'] = this.babyId;
    data['is_reminder_set'] = this.isReminderSet;
    data['reminder_interval'] = this.reminderInterval;
    return data;
  }
}
