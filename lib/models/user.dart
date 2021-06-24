class User {
  int user_id;
  String user_name;
  String user_email;
  String user_tlp;
  String user_photo;

  User({this.user_id,
      this.user_name,
      this.user_email,
      this.user_tlp,
      this.user_photo});

  User.fromJson(Map<String, dynamic> json) :
        user_id = json['user_id'],
        user_name = json['user_name'],
        user_email = json['user_email'],
        user_tlp = json['user_tlp'],
        user_photo = json['user_photo'];
}
