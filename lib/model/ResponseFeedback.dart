class ResponseFeedback {
  String? message;
  Data? data;

  ResponseFeedback({this.message, this.data});

  ResponseFeedback.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? iV;
  String? updatedAt;
  String? createdAt;
  String? serviceRequestId;
  String? customerId;
  String? sId;
  String? count;
  String? feedback;

  Data(
      {this.iV,
        this.updatedAt,
        this.createdAt,
        this.serviceRequestId,
        this.customerId,
        this.sId,
        this.count,
        this.feedback});

  Data.fromJson(Map<String, dynamic> json) {
    iV = json['__v'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    serviceRequestId = json['serviceRequestId'];
    customerId = json['customerId'];
    sId = json['_id'];
    count = json['count'];
    feedback = json['feedback'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__v'] = this.iV;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    data['serviceRequestId'] = this.serviceRequestId;
    data['customerId'] = this.customerId;
    data['_id'] = this.sId;
    data['count'] = this.count;
    data['feedback'] = this.feedback;
    return data;
  }
}