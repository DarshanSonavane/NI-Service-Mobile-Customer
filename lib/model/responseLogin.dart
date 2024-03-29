class responseLogin {
  String? code;
  String? message;
  List<Data>? data;

  responseLogin({this.code, this.message, this.data});

  responseLogin.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? gstNo;
  String? email;
  String? mobile;
  String? amcDue;
  String? city;
  String? customerName;
  String? customerCode;

  Data(
      {this.sId,
        this.gstNo,
        this.email,
        this.mobile,
        this.amcDue,
        this.city,
        this.customerName,
        this.customerCode});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    gstNo = json['gstNo'];
    email = json['email'];
    mobile = json['mobile'];
    amcDue = json['amcDue'];
    city = json['city'];
    customerName = json['customerName'];
    customerCode = json['customerCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['gstNo'] = this.gstNo;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['amcDue'] = this.amcDue;
    data['city'] = this.city;
    data['customerName'] = this.customerName;
    data['customerCode'] = this.customerCode;
    return data;
  }
}