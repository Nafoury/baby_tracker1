class TeethData {
  int? toothId;
  DateTime? date;
  String? upper;
  String? lower;
  int? babyId;

  TeethData({this.toothId, this.date, this.upper, this.lower, this.babyId});

  TeethData.fromJson(Map<String, dynamic> json) {
    toothId = json['teeth_id'];
    date = DateTime.parse(json['date']);
    upper = json['upper_jaw'];
    lower = json['lower_jaw'];
    babyId = json['baby_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teeth_id'] = this.toothId;
    data['date'] = this.date;
    data['upper_jaw'] = this.upper;
    data['lower_jaw'] = this.lower;
    data['baby_id'] = this.babyId;
    return data;
  }
}
