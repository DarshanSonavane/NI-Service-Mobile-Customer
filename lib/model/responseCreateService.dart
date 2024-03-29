class responseCreateService {
  String? message;
  String? code;
  Data? data;

  responseCreateService({this.message, this.code, this.data});

  responseCreateService.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? customerId;
  String? machineType;
  String? complaintType;
  String? status;
  String? createdAt;
  String? sId;
  String? updatedAt;
  int? iV;

  Data(
      {this.customerId,
        this.machineType,
        this.complaintType,
        this.status,
        this.createdAt,
        this.sId,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    machineType = json['machineType'];
    complaintType = json['complaintType'];
    status = json['status'];
    createdAt = json['createdAt'];
    sId = json['_id'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['machineType'] = this.machineType;
    data['complaintType'] = this.complaintType;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['_id'] = this.sId;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}