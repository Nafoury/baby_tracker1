class NusringData {
  int? feedId;
  String? leftDuration;
  DateTime? date;
  String? nursingSide;
  String? startingBreast;
  String? rightDuration;
  String? babyId;

  NusringData(
      {this.feedId,
      this.leftDuration,
      this.date,
      this.nursingSide,
      this.startingBreast,
      this.rightDuration,
      this.babyId});

  NusringData.fromJson(Map<String, dynamic> json) {
    feedId = json['feed_id'];
    leftDuration = json['left_duration'] is int
        ? '00:00:00'
        : json['left_duration'].toString();
    date = DateTime.parse(json['date']);
    nursingSide = json['nursing_side'];
    startingBreast = json['starting_side'];
    rightDuration = json['right_duration'] is int
        ? '00:00:00'
        : json['right_duration'].toString();
    babyId = json['baby_id'].toString(); // Convert baby_id to String
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feed_id'] = this.feedId;
    data['left_duration'] = this.leftDuration;
    data['date'] = this.date;
    data['nursing_side'] = this.nursingSide;
    data['starting_side'] = this.startingBreast;
    data['right_duration'] = this.rightDuration;
    data['baby_id'] = this.babyId;
    return data;
  }
}
