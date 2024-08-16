class requestCreateService {
  String? customerId;
  String? machineType;
  String? complaintType;
  String? status;
  String? version;
  String? addintionalReq;

  requestCreateService({
    this.customerId,
    this.machineType,
    this.complaintType,
    this.status,
    this.version,
    this.addintionalReq,
  });

  requestCreateService.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    machineType = json['machineType'];
    complaintType = json['complaintType'];
    status = json['status'];
    version = json['version'];
    addintionalReq = json['additionalReq'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    data['machineType'] = machineType;
    data['complaintType'] = complaintType;
    data['status'] = status;
    data['version'] = version;
    data['additionalReq'] = addintionalReq;
    return data;
  }
}
