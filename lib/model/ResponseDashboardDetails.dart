class ResponseDashboardDetails {
  String? code;
  String? message;
  int? totalComplaints;
  int? openComplaints;
  int? closeComplaints;

  ResponseDashboardDetails(
      {this.code,
        this.message,
        this.totalComplaints,
        this.openComplaints,
        this.closeComplaints});

  ResponseDashboardDetails.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    totalComplaints = json['totalComplaints'];
    openComplaints = json['openComplaints'];
    closeComplaints = json['closeComplaints'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['totalComplaints'] = this.totalComplaints;
    data['openComplaints'] = this.openComplaints;
    data['closeComplaints'] = this.closeComplaints;
    return data;
  }
}