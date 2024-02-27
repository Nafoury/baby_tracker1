class BottleData {
  int? feed1Id;
  DateTime? startDate;
  double? amount;
  String? note;
  String? babyId;

  BottleData(
      {this.feed1Id, this.startDate, this.amount, this.note, this.babyId});

  BottleData.fromMap(Map<String, dynamic> json) {
    feed1Id = json['feed1_id'];
    startDate = DateTime.parse(json['date']);
    amount = json['amount'];
    note = json['note'];
    babyId = json['baby_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feed1_id'] = this.feed1Id;
    data['date'] = this.startDate;
    data['amount'] = this.amount;
    data['note'] = this.note;
    data['baby_id'] = this.babyId;
    return data;
  }
}
