class RequestSendOtp {
  String? customerCode;
  String? otp;

  RequestSendOtp({this.customerCode, this.otp});

  RequestSendOtp.fromJson(Map<String, dynamic> json) {
    customerCode = json['customerCode'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerCode'] = customerCode;
    data['otp'] = otp;
    return data;
  }
}
