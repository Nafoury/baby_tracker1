class MedData {
  int? medId;
  DateTime? date;
  String? type;
  String? note;
  String? babyId;

  MedData({this.medId, this.date, this.type, this.note, this.babyId});

  MedData.fromJson(Map<String, dynamic> json) {
    medId = json['med_id'];
    date = DateTime.parse(json['date']);
    type = json['type'];
    note = json['note'];
    babyId = json['baby_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['med_id'] = this.medId;
    data['date'] = this.date;
    data['type'] = this.type;
    data['note'] = this.note;
    data['baby_id'] = this.babyId;
    return data;
  }
}
