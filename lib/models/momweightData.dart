import 'dart:ffi';

class MomData {
  int? momId;
  double? weight;
  DateTime? date;
  String? babyId;

  MomData({this.momId, this.weight, this.date, this.babyId});

  MomData.fromJson(Map<String, dynamic> json) {
    momId = json['mom_id'];
    weight = double.parse(json['weight'].toString());
    date = DateTime.parse(json['date']);
    babyId = json['baby_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mom_id'] = this.momId;
    data['weight'] = this.weight;
    data['date'] = this.date;
    data['baby_id'] = this.babyId;
    return data;
  }
}
