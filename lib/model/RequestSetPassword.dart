class RequestSetPassword {
  String? customerCode;
  String? password;

  RequestSetPassword({this.customerCode, this.password});

  RequestSetPassword.fromJson(Map<String, dynamic> json) {
    customerCode = json['customerCode'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerCode'] = this.customerCode;
    data['password'] = this.password;
    return data;
  }
}
