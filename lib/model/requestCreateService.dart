class requestCreateService {
  String? customerId;
  String? machineType;
  String? complaintType;
  String? status;
  String? version;

  requestCreateService(
      {this.customerId,
      this.machineType,
      this.complaintType,
      this.status,
      this.version});

  requestCreateService.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    machineType = json['machineType'];
    complaintType = json['complaintType'];
    status = json['status'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['machineType'] = this.machineType;
    data['complaintType'] = this.complaintType;
    data['status'] = this.status;
    data['version'] = this.version;
    return data;
  }
}
