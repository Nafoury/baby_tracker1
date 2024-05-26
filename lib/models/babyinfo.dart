class BabyInfo {
  int? infoId;
  String? babyName;
  String? gender;
  DateTime? dateOfBirth;
  double? babyWeight;
  double? babyHeight;
  double? babyhead;
  String? image;
  int? completeInfoUserAuthorization;
  bool? isActive;

  BabyInfo(
      {this.infoId,
      this.babyName,
      this.gender,
      this.dateOfBirth,
      this.babyWeight,
      this.babyhead,
      this.babyHeight,
      this.image,
      this.isActive,
      this.completeInfoUserAuthorization});

  BabyInfo.fromJson(Map<String, dynamic> json) {
    infoId = json['info_id'];
    babyName = json['baby_name'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'] != null
        ? DateTime.parse(json['date_of_birth'])
        : null;
    babyWeight = double.tryParse(json['baby_weight'].toString()) ?? 0.0;
    babyHeight = double.tryParse(json['baby_height'].toString()) ?? 0.0;
    babyhead = double.tryParse(json['baby_head'].toString()) ?? 0.0;
    image = json['photo'];
    completeInfoUserAuthorization = json['complete_info_user_authorization'];
    isActive = json['active'] == 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['info_id'] = this.infoId;
    data['baby_name'] = this.babyName;
    data['gender'] = this.gender;
    data['date_of_birth'] = this.dateOfBirth;
    data['baby_weight'] = this.babyWeight;
    data['baby_height'] = this.babyHeight;
    data['photo'] = this.image;
    data['baby_head'] = this.babyhead;
    data['complete_info_user_authorization'] =
        this.completeInfoUserAuthorization;
    return data;
  }
}
