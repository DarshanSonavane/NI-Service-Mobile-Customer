class responseGetServiceRequestList {
  String? code;
  String? message;
  List<DataComplaintsList>? data;

  responseGetServiceRequestList({this.code, this.message, this.data});

  responseGetServiceRequestList.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataComplaintsList>[];
      json['data'].forEach((v) {
        data!.add(new DataComplaintsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
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
  String? updatedBy;
  Ratings? ratings;
  String? employeeFeedback;
  String? status;
  String? machineType;

  DataComplaintsList(
      {this.sId,
      this.updatedAt,
      this.createdAt,
      this.customerId,
      this.complaintType,
      this.assignedTo,
      this.iV,
      this.updatedBy,
      this.ratings,
      this.employeeFeedback,
      this.status,
      this.machineType});

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
    updatedBy = json['updatedBy'];
    ratings =
        json['ratings'] != null ? new Ratings.fromJson(json['ratings']) : null;
    employeeFeedback = json['employeeFeedback'];
    status = json['status'];
    machineType = json['machineType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = createdAt;
    if (customerId != null) {
      data['customerId'] = customerId!.toJson();
    }
    if (complaintType != null) {
      data['complaintType'] = complaintType!.toJson();
    }
    data['assignedTo'] = assignedTo;
    data['__v'] = iV;
    data['updatedBy'] = updatedBy;
    if (ratings != null) {
      data['ratings'] = ratings!.toJson();
    }
    data['employeeFeedback'] = employeeFeedback;
    data['status'] = status;
    data['machineType'] = machineType;
    return data;
  }
}

class CustomerId {
  String? sId;
  String? password;
  String? gstNo;
  String? email;
  String? mobile;
  String? amcDue;
  String? city;
  String? customerName;
  String? customerCode;

  CustomerId(
      {this.sId,
      this.password,
      this.gstNo,
      this.email,
      this.mobile,
      this.amcDue,
      this.city,
      this.customerName,
      this.customerCode});

  CustomerId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    password = json['password'];
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
    data['password'] = this.password;
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

class Ratings {
  String? sId;
  String? updatedAt;
  String? createdAt;
  String? serviceRequestId;
  String? customerId;
  int? iV;
  String? count;
  String? feedback;

  Ratings(
      {this.sId,
      this.updatedAt,
      this.createdAt,
      this.serviceRequestId,
      this.customerId,
      this.iV,
      this.count,
      this.feedback});

  Ratings.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    serviceRequestId = json['serviceRequestId'];
    customerId = json['customerId'];
    iV = json['__v'];
    count = json['count'];
    feedback = json['feedback'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    data['serviceRequestId'] = this.serviceRequestId;
    data['customerId'] = this.customerId;
    data['__v'] = this.iV;
    data['count'] = this.count;
    data['feedback'] = this.feedback;
    return data;
  }
}
