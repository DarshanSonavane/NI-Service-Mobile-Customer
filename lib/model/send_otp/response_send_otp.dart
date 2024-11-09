class ResponseSendOtp {
  String? code;
  String? message;

  ResponseSendOtp({this.code, this.message});

  ResponseSendOtp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}
