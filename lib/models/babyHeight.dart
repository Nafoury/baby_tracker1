class HeightMeasureData {
  int? heightId;
  double? measure;
  DateTime? date;
  String? babyId;

  HeightMeasureData({this.heightId, this.measure, this.date, this.babyId});

  HeightMeasureData.fromJson(Map<String, dynamic> json) {
    heightId = json['height_id'];
    measure = double.parse(json['measure'].toString());
    date = DateTime.parse(json['date']);
    babyId = json['baby_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height_id'] = this.heightId;
    data['weight'] = this.measure;
    data['date'] = this.date;
    data['baby_id'] = this.babyId;
    return data;
  }
}
