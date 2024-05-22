class RequestCalibration {
  String? employeeId;
  String? machineType;
  String? customerId;

  RequestCalibration({this.employeeId, this.machineType, this.customerId});

  RequestCalibration.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    machineType = json['machineType'];
    customerId = json['customerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['machineType'] = this.machineType;
    data['customerId'] = this.customerId;
    return data;
  }
}