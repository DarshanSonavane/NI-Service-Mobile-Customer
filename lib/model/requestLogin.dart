class requestLogin {
  String? id;
  String? type;
  String? password;

  requestLogin({this.id, this.type, this.password});

  requestLogin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['password'] = password;
    return data;
  }
}
