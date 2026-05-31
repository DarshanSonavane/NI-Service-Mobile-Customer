class RequestFeedback {
  String? customerId;
  String? serviceRequestId;
  String? feedback;
  String? count;

  RequestFeedback(
      {this.customerId, this.serviceRequestId, this.feedback, this.count});

  RequestFeedback.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    serviceRequestId = json['serviceRequestId'];
    feedback = json['feedback'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    data['serviceRequestId'] = serviceRequestId;
    data['feedback'] = feedback;
    data['count'] = count;
    return data;
  }
}
