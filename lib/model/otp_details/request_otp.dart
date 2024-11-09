class RequestOtp {
  String? customerCode;

  RequestOtp({this.customerCode});

  RequestOtp.fromJson(Map<String, dynamic> json) {
    customerCode = json['customerCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerCode'] = customerCode;
    return data;
  }
}
