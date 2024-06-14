class RequestValidateCalibration {
  String? machineType;
  String? customerId;

  RequestValidateCalibration({this.machineType, this.customerId});

  RequestValidateCalibration.fromJson(Map<String, dynamic> json) {
    machineType = json['machineType'];
    customerId = json['customerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['machineType'] = this.machineType;
    data['customerId'] = this.customerId;
    return data;
  }
}