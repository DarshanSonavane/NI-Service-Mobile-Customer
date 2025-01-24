class RequestRenewAMC {
  String? customerId;
  String? amcType;

  RequestRenewAMC({this.customerId, this.amcType});

  RequestRenewAMC.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    amcType = json['amcType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    data['amcType'] = amcType;
    return data;
  }
}
