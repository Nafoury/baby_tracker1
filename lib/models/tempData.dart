class TempData {
  int? tempId;
  double? temp;
  String? date;
  String? note;
  int? babyId;

  TempData({this.tempId, this.temp, this.date, this.note, this.babyId});

  TempData.fromJson(Map<String, dynamic> json) {
    tempId = json['temp_id'];
    temp = json['temp'];
    date = json['date'];
    note = json['note'];
    babyId = json['baby_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temp_id'] = this.tempId;
    data['temp'] = this.temp;
    data['date'] = this.date;
    data['note'] = this.note;
    data['baby_id'] = this.babyId;
    return data;
  }
}
