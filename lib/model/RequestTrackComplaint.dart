class RequestTrackComplaint {
  String? complaintId;

  RequestTrackComplaint({this.complaintId});

  RequestTrackComplaint.fromJson(Map<String, dynamic> json) {
    complaintId = json['complaintId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['complaintId'] = this.complaintId;
    return data;
  }
}