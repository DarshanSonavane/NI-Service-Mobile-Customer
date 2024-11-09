class RequestCalibration {
  String? employeeId;
  String? machineType;
  String? customerId;
  String? versionName;

  RequestCalibration({this.employeeId, this.machineType, this.customerId});

  RequestCalibration.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    machineType = json['machineType'];
    customerId = json['customerId'];
    customerId = json['customerId'];
    versionName = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['machineType'] = this.machineType;
    data['customerId'] = this.customerId;
    data['version'] = this.versionName;
    return data;
  }
}
