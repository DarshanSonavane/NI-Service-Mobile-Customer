class requestLogin {
  String? id;
  String? type;
  String? password;

  requestLogin({this.id, this.type,this.password});

  requestLogin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['password'] = this.password;
    return data;
  }
}