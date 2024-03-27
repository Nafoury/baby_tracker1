class WeightData {
  int? weightId;
  double? weight;
  DateTime? date;
  String? babyId;

  WeightData({this.weightId, this.weight, this.date, this.babyId});

  WeightData.fromJson(Map<String, dynamic> json) {
    weightId = json['weight_id'];
    weight = double.parse(json['weight'].toString());
    date = DateTime.parse(json['date']);
    babyId = json['baby_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weight_id'] = this.weightId;
    data['weight'] = this.weight;
    data['date'] = this.date;
    data['baby_id'] = this.babyId;
    return data;
  }
}
