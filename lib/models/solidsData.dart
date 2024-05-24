class SolidsData {
  int? solidId;
  DateTime? date;
  int? fruits;
  int? veg;
  int? protein;
  int? grains;
  int? dairy;
  String? note;
  int? babyId;

  SolidsData(
      {this.solidId,
      this.date,
      this.fruits,
      this.veg,
      this.protein,
      this.grains,
      this.dairy,
      this.note,
      this.babyId});

  SolidsData.fromJson(Map<String, dynamic> json) {
    solidId = json['solid_id'];
    date = DateTime.parse(json['date']);
    fruits = json['fruits'];
    veg = json['veg'];
    protein = json['protein'];
    grains = json['grains'];
    dairy = json['dairy'];
    note = json['note'];
    babyId = json['baby_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['solid_id'] = this.solidId;
    data['date'] = this.date;
    data['fruits'] = this.fruits;
    data['veg'] = this.veg;
    data['protein'] = this.protein;
    data['grains'] = this.grains;
    data['dairy'] = this.dairy;
    data['note'] = this.note;
    data['baby_id'] = this.babyId;
    return data;
  }
}
