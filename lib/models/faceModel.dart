import 'dart:io';

class FaceData {
  int? imageId;
  DateTime? date;
  String? image;
  int? babyId;

  FaceData({this.imageId, this.date, this.image, this.babyId});

  FaceData.fromJson(Map<String, dynamic> json) {
    imageId = json['image_id'];
    date = DateTime.parse(json['date']);
    image = json['face_image'];
    babyId = json['baby_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_id'] = this.imageId;
    data['date'] = this.date;
    data['face_image'] = this.image;
    data['baby_id'] = this.babyId;
    return data;
  }
}
