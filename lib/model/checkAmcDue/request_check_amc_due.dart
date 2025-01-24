class RequestCheckAmcDue {
  String? customerId;

  RequestCheckAmcDue({this.customerId});

  RequestCheckAmcDue.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    return data;
  }
}
