class MeasureData {
  int? measureId;
  double? measure;
  DateTime? date;
  String? babyId;

  MeasureData({this.measureId, this.measure, this.date, this.babyId});

  MeasureData.fromJson(Map<String, dynamic> json) {
    measureId = json['measure_id'];
    measure = double.parse(json['measure'].toString());
    date = DateTime.parse(json['date']);
    babyId = json['baby_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weight_id'] = this.measureId;
    data['weight'] = this.measure;
    data['date'] = this.date;
    data['baby_id'] = this.babyId;
    return data;
  }
}
