class VaccineData {
  int? vaccineId;
  DateTime? date;
  String? type;
  String? note;
  String? babyId;

  VaccineData({this.vaccineId, this.date, this.type, this.note, this.babyId});

  VaccineData.fromJson(Map<String, dynamic> json) {
    vaccineId = json['vaccine_id'];
    date = DateTime.parse(json['date']);
    type = json['type'];
    note = json['note'];
    babyId = json['baby_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vaccine_id'] = this.vaccineId;
    data['date'] = this.date;
    data['type'] = this.type;
    data['note'] = this.note;
    data['baby_id'] = this.babyId;
    return data;
  }
}
