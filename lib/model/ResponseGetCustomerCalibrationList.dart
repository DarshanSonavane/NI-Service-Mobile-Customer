class ResponseGetCustomerCalibrationList {
  String? message;
  List<Data>? data;

  ResponseGetCustomerCalibrationList({this.message, this.data});

  ResponseGetCustomerCalibrationList.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  CustomerId? customerId;
  String? machineType;
  EmployeeId? employeeId;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
        this.customerId,
        this.machineType,
        this.employeeId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    customerId = json['customerId'] != null
        ? new CustomerId.fromJson(json['customerId'])
        : null;
    machineType = json['machineType'];
    employeeId = json['employeeId'] != null
        ? new EmployeeId.fromJson(json['employeeId'])
        : null;
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.customerId != null) {
      data['customerId'] = this.customerId!.toJson();
    }
    data['machineType'] = this.machineType;
    if (this.employeeId != null) {
      data['employeeId'] = this.employeeId!.toJson();
    }
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class CustomerId {
  String? sId;
  String? customerCode;
  String? customerName;
  String? city;
  String? amcDue;
  String? mobile;
  String? email;
  String? gstNo;
  String? password;
  int? iV;

  CustomerId(
      {this.sId,
        this.customerCode,
        this.customerName,
        this.city,
        this.amcDue,
        this.mobile,
        this.email,
        this.gstNo,
        this.password,
        this.iV});

  CustomerId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    customerCode = json['customerCode'];
    customerName = json['customerName'];
    city = json['city'];
    amcDue = json['amcDue'];
    mobile = json['mobile'];
    email = json['email'];
    gstNo = json['gstNo'];
    password = json['password'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['customerCode'] = this.customerCode;
    data['customerName'] = this.customerName;
    data['city'] = this.city;
    data['amcDue'] = this.amcDue;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['gstNo'] = this.gstNo;
    data['password'] = this.password;
    data['__v'] = this.iV;
    return data;
  }
}

class EmployeeId {
  String? sId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? employeeCode;
  String? dob;
  String? phone;
  String? email;
  String? gender;
  String? role;
  String? isActive;
  String? password;
  String? updatedAt;

  EmployeeId(
      {this.sId,
        this.firstName,
        this.middleName,
        this.lastName,
        this.employeeCode,
        this.dob,
        this.phone,
        this.email,
        this.gender,
        this.role,
        this.isActive,
        this.password,
        this.updatedAt});

  EmployeeId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    employeeCode = json['employeeCode'];
    dob = json['dob'];
    phone = json['phone'];
    email = json['email'];
    gender = json['gender'];
    role = json['role'];
    isActive = json['isActive'];
    password = json['password'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['employeeCode'] = this.employeeCode;
    data['dob'] = this.dob;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['role'] = this.role;
    data['isActive'] = this.isActive;
    data['password'] = this.password;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}