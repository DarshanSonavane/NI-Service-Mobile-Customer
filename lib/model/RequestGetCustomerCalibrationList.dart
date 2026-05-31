class RequestGetCustomerCalibrationList {
  String? customerId;

  RequestGetCustomerCalibrationList({this.customerId});

  RequestGetCustomerCalibrationList.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    return data;
  }
}
