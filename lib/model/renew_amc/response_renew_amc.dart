class ResponseRenewAMC {
  int? code;
  String? message;

  ResponseRenewAMC({this.code, this.message});

  ResponseRenewAMC.fromJson(Map<String, dynamic> json) {
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
