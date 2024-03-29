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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['serviceRequestId'] = this.serviceRequestId;
    data['feedback'] = this.feedback;
    data['count'] = this.count;
    return data;
  }
}