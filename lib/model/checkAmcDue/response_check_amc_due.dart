class ResponseCheckAmcDue {
  int? code;
  String? message;
  Data? data;

  ResponseCheckAmcDue({this.code, this.message, this.data});

  ResponseCheckAmcDue.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? custometrCode;
  String? customerName;
  String? city;
  String? stateCode;
  String? mobile;
  String? email;
  String? amcDue;

  Data(
      {this.sId,
      this.custometrCode,
      this.customerName,
      this.city,
      this.stateCode,
      this.mobile,
      this.email,
      this.amcDue});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    custometrCode = json['custometrCode'];
    customerName = json['customerName'];
    city = json['city'];
    stateCode = json['stateCode'];
    mobile = json['mobile'];
    email = json['email'];
    amcDue = json['amcDue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['custometrCode'] = custometrCode;
    data['customerName'] = customerName;
    data['city'] = city;
    data['stateCode'] = stateCode;
    data['mobile'] = mobile;
    data['email'] = email;
    data['amcDue'] = amcDue;
    return data;
  }
}
