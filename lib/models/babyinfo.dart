class BabyInfo {
  int? infoId;
  String? babyName;
  String? gender;
  DateTime? dateOfBirth;
  double? babyWeight;
  double? babyHeight;
  double? babyhead;
  int? completeInfoUserAuthorization;
  int? isActive;

  BabyInfo(
      {this.infoId,
      this.babyName,
      this.gender,
      this.dateOfBirth,
      this.babyWeight,
      this.babyhead,
      this.babyHeight,
      this.isActive,
      this.completeInfoUserAuthorization});

  BabyInfo.fromJson(Map<String, dynamic> json) {
    infoId = json['info_id'];
    babyName = json['baby_name'];
    gender = json['gender'];
    dateOfBirth = DateTime.parse(json['date_of_birth']);
    babyWeight = double.parse(json['baby_weight'].toString());
    babyHeight = double.parse(json['baby_height'].toString());
    babyhead = double.parse(json['baby_head'].toString());
    completeInfoUserAuthorization = json['complete_info_user_authorization'];
    isActive = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['info_id'] = this.infoId;
    data['baby_name'] = this.babyName;
    data['gender'] = this.gender;
    data['date_of_birth'] = this.dateOfBirth;
    data['baby_weight'] = this.babyWeight;
    data['baby_height'] = this.babyHeight;
    data['baby_head'] = this.babyhead;
    data['complete_info_user_authorization'] =
        this.completeInfoUserAuthorization;
    return data;
  }
}
