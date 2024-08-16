class ResponseValidateCalibration {
  String? code;
  String? message;
  int? differenceDays;
  bool? isNewrecord;

  ResponseValidateCalibration(
      {this.code, this.message, this.differenceDays, this.isNewrecord});

  ResponseValidateCalibration.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    differenceDays = json['differenceDays'];
    isNewrecord = json['isNewrecord'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['differenceDays'] = this.differenceDays;
    data['isNewrecord'] = this.isNewrecord;
    return data;
  }
}