class ResponseUpdateCenterDetails {
  String? code;
  String? message;
  CenterData? data;

  ResponseUpdateCenterDetails({
    this.code,
    this.message,
    this.data,
  });

  ResponseUpdateCenterDetails.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? CenterData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = <String, dynamic>{};

    dataMap['code'] = code;
    dataMap['message'] = message;

    if (data != null) {
      dataMap['data'] = data!.toJson();
    }

    return dataMap;
  }
}

class CenterData {
  bool? acknowledged;
  int? modifiedCount;
  dynamic upsertedId;
  int? upsertedCount;
  int? matchedCount;

  CenterData({
    this.acknowledged,
    this.modifiedCount,
    this.upsertedId,
    this.upsertedCount,
    this.matchedCount,
  });

  CenterData.fromJson(Map<String, dynamic> json) {
    acknowledged = json['acknowledged'];
    modifiedCount = json['modifiedCount'];
    upsertedId = json['upsertedId'];
    upsertedCount = json['upsertedCount'];
    matchedCount = json['matchedCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['acknowledged'] = acknowledged;
    data['modifiedCount'] = modifiedCount;
    data['upsertedId'] = upsertedId;
    data['upsertedCount'] = upsertedCount;
    data['matchedCount'] = matchedCount;

    return data;
  }
}
