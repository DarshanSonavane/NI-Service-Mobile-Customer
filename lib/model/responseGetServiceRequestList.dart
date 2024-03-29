class responseGetServiceRequestList {
  String? message;
  String? code;
  List<DataComplaintsList>? data;

  responseGetServiceRequestList({this.message, this.code, this.data});

  responseGetServiceRequestList.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    code = json['code'];
    if (json['data'] != null) {
      data = <DataComplaintsList>[];
      json['data'].forEach((v) {
        data!.add(new DataComplaintsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataComplaintsList {
  String? sId;
  String? updatedAt;
  String? createdAt;
  CustomerId? customerId;
  ComplaintType? complaintType;
  String? assignedTo;
  int? iV;
  String? ratings;
  String? employeeFeedback;
  String? status;
  String? machineType;
  String? updatedBy;

  DataComplaintsList(
      {this.sId,
        this.updatedAt,
        this.createdAt,
        this.customerId,
        this.complaintType,
        this.assignedTo,
        this.iV,
        this.ratings,
        this.employeeFeedback,
        this.status,
        this.machineType,
        this.updatedBy});

  DataComplaintsList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    customerId = json['customerId'] != null
        ? new CustomerId.fromJson(json['customerId'])
        : null;
    complaintType = json['complaintType'] != null
        ? new ComplaintType.fromJson(json['complaintType'])
        : null;
    assignedTo = json['assignedTo'];
    iV = json['__v'];
    ratings = json['ratings'];
    employeeFeedback = json['employeeFeedback'];
    status = json['status'];
    machineType = json['machineType'];
    updatedBy = json['updatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    if (this.customerId != null) {
      data['customerId'] = this.customerId!.toJson();
    }
    if (this.complaintType != null) {
      data['complaintType'] = this.complaintType!.toJson();
    }
    data['assignedTo'] = this.assignedTo;
    data['__v'] = this.iV;
    data['ratings'] = this.ratings;
    data['employeeFeedback'] = this.employeeFeedback;
    data['status'] = this.status;
    data['machineType'] = this.machineType;
    data['updatedBy'] = this.updatedBy;
    return data;
  }
}

class CustomerId {
  String? sId;
  String? gstNo;
  String? email;
  String? mobile;
  String? amcDue;
  String? city;
  String? customerName;
  String? customerCode;

  CustomerId(
      {this.sId,
        this.gstNo,
        this.email,
        this.mobile,
        this.amcDue,
        this.city,
        this.customerName,
        this.customerCode});

  CustomerId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    gstNo = json['gstNo'];
    email = json['email'];
    mobile = json['mobile'];
    amcDue = json['amcDue'];
    city = json['city'];
    customerName = json['customerName'];
    customerCode = json['customerCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['gstNo'] = this.gstNo;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['amcDue'] = this.amcDue;
    data['city'] = this.city;
    data['customerName'] = this.customerName;
    data['customerCode'] = this.customerCode;
    return data;
  }
}

class ComplaintType {
  String? sId;
  String? name;

  ComplaintType({this.sId, this.name});

  ComplaintType.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}