class ResponseLogin {
  String? code;
  String? message;
  List<Data>? data;
  List<MachineDetails>? machineDetails;

  ResponseLogin({this.code, this.message, this.data, this.machineDetails});

  ResponseLogin.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    if (json['machineDetails'] != null) {
      machineDetails = <MachineDetails>[];
      json['machineDetails'].forEach((v) {
        machineDetails!.add(MachineDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (machineDetails != null) {
      data['machineDetails'] = machineDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? customerCode;
  String? customerName;
  String? city;
  String? password;
  String? email;
  String? gstNo;
  String? mobile;
  String? amcDue;
  String? machineNumber;
  String? comboMachineNumber;
  String? dieselMachineNumber;
  String? petrolMachineNumber;
  String? stateCode;
  String? machineModel;

  Data(
      {this.sId,
      this.customerCode,
      this.customerName,
      this.city,
      this.password,
      this.email,
      this.gstNo,
      this.mobile,
      this.amcDue,
      this.machineNumber,
      this.comboMachineNumber,
      this.dieselMachineNumber,
      this.petrolMachineNumber,
      this.stateCode,
      this.machineModel});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    customerCode = json['customerCode'];
    customerName = json['customerName'];
    city = json['city'];
    password = json['password'];
    email = json['email'];
    gstNo = json['gstNo'];
    mobile = json['mobile'];
    amcDue = json['amcDue'];
    machineNumber = json['machineNumber'];
    comboMachineNumber = json['comboMachineNumber'];
    dieselMachineNumber = json['dieselMachineNumber'];
    petrolMachineNumber = json['petrolMachineNumber'];
    stateCode = json['stateCode'];
    machineModel = json['machineModel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['customerCode'] = customerCode;
    data['customerName'] = customerName;
    data['city'] = city;
    data['password'] = password;
    data['email'] = email;
    data['gstNo'] = gstNo;
    data['mobile'] = mobile;
    data['amcDue'] = amcDue;
    data['machineNumber'] = machineNumber;
    data['comboMachineNumber'] = comboMachineNumber;
    data['dieselMachineNumber'] = dieselMachineNumber;
    data['petrolMachineNumber'] = petrolMachineNumber;
    data['stateCode'] = stateCode;
    data['machineModel'] = machineModel;
    return data;
  }
}

class MachineDetails {
  String? sId;
  String? model;
  String? machineno;
  String? customercode;
  int? iV;
  String? createdAt;
  String? updatedAt;

  MachineDetails(
      {this.sId,
      this.model,
      this.machineno,
      this.customercode,
      this.iV,
      this.createdAt,
      this.updatedAt});

  MachineDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    model = json['MODEL'];
    machineno = json['MACHINE_NO'];
    customercode = json['CUSTOMER_CODE'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['MODEL'] = model;
    data['MACHINE_NO'] = machineno;
    data['CUSTOMER_CODE'] = customercode;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
