class CompleteinfoModel {
  final int? id;
  final String first_name;
  final String baby_name;
  final String gender;
  final int date_of_birth;
  final double weight;
  final double height;

  CompleteinfoModel(
      {this.id,
      required this.first_name,
      required this.baby_name,
      required this.gender,
      required this.date_of_birth,
      required this.height,
      required this.weight});

  factory CompleteinfoModel.fromMap(Map<String, dynamic> json) =>
      CompleteinfoModel(
        id: json["id"],
        first_name: json["first_name"],
        baby_name: json["baby_name"],
        date_of_birth: json["date_of_birth"],
        gender: json["gender"],
        weight: json["weight"],
        height: json["height"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "first_name": first_name,
        "baby_name": baby_name,
        "gender": gender,
        "date_of_birth": date_of_birth,
        "weight": weight,
        "height": height
      };
}
