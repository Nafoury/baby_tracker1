class UserModel {
  final int? userid;
  final String useremail;
  final String userpassword;

  UserModel({
    this.userid,
    required this.useremail,
    required this.userpassword,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        userid: json["userid"],
        useremail: json["useremail"],
        userpassword: json["userpassword"],
      );

  Map<String, dynamic> toMap() => {
        "userid": userid,
        "useremail": useremail,
        "userpassword": userpassword,
      };
}
