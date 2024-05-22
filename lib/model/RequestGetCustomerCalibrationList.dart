class RequestGetCustomerCalibrationList {
  String? customerId;

  RequestGetCustomerCalibrationList({this.customerId});

  RequestGetCustomerCalibrationList.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    return data;
  }
}