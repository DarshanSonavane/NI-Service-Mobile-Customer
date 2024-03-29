class ResponseCustomerDetails {
  String? code;
  String? message;
  Data? data;

  ResponseCustomerDetails({this.code, this.message, this.data});

  ResponseCustomerDetails.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? n;
  int? nModified;
  int? ok;

  Data({this.n, this.nModified, this.ok});

  Data.fromJson(Map<String, dynamic> json) {
    n = json['n'];
    nModified = json['nModified'];
    ok = json['ok'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['n'] = this.n;
    data['nModified'] = this.nModified;
    data['ok'] = this.ok;
    return data;
  }
}