class RequestFCMKeyDetails {
  String? customerId;
  String? deviceId;
  String? fcmKey;

  RequestFCMKeyDetails({this.customerId, this.deviceId, this.fcmKey});

  RequestFCMKeyDetails.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    deviceId = json['deviceId'];
    fcmKey = json['fcmKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    data['deviceId'] = deviceId;
    data['fcmKey'] = fcmKey;
    return data;
  }
}
