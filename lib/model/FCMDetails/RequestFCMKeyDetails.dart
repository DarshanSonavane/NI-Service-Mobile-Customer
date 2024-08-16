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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['deviceId'] = this.deviceId;
    data['fcmKey'] = this.fcmKey;
    return data;
  }
}