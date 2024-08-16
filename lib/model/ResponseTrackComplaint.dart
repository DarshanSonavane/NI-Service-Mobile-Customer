class ResponseTrackComplaint {
  String? code;
  String? message;
  Data? data;

  ResponseTrackComplaint({this.code, this.message, this.data});

  ResponseTrackComplaint.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  AssignedDetails? assignedDetails;
  List<ComplaintHistory>? complaintHistory;
  Complaint? complaint;

  Data({this.assignedDetails, this.complaintHistory, this.complaint});

  Data.fromJson(Map<String, dynamic> json) {
    assignedDetails = json['assignedDetails'] != null
        ? new AssignedDetails.fromJson(json['assignedDetails'])
        : null;
    if (json['complaintHistory'] != null) {
      complaintHistory = <ComplaintHistory>[];
      json['complaintHistory'].forEach((v) {
        complaintHistory!.add(new ComplaintHistory.fromJson(v));
      });
    }
    complaint = json['complaint'] != null
        ? new Complaint.fromJson(json['complaint'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.assignedDetails != null) {
      data['assignedDetails'] = this.assignedDetails!.toJson();
    }
    if (this.complaintHistory != null) {
      data['complaintHistory'] =
          this.complaintHistory!.map((v) => v.toJson()).toList();
    }
    if (this.complaint != null) {
      data['complaint'] = this.complaint!.toJson();
    }
    return data;
  }
}

class AssignedDetails {
  String? sId;
  AssignedTo? assignedTo;

  AssignedDetails({this.sId, this.assignedTo});

  AssignedDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    assignedTo = json['assignedTo'] != null
        ? new AssignedTo.fromJson(json['assignedTo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.assignedTo != null) {
      data['assignedTo'] = this.assignedTo!.toJson();
    }
    return data;
  }
}

class AssignedTo {
  String? sId;
  String? phone;
  String? lastName;
  String? firstName;

  AssignedTo({this.sId, this.phone, this.lastName, this.firstName});

  AssignedTo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    phone = json['phone'];
    lastName = json['lastName'];
    firstName = json['firstName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['phone'] = this.phone;
    data['lastName'] = this.lastName;
    data['firstName'] = this.firstName;
    return data;
  }
}

class ComplaintHistory {
  String? sId;
  String? requestId;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ComplaintHistory(
      {this.sId,
        this.requestId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.iV});

  ComplaintHistory.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    requestId = json['requestId'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['requestId'] = this.requestId;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Complaint {
  String? sId;
  ComplaintType? complaintType;

  Complaint({this.sId, this.complaintType});

  Complaint.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    complaintType = json['complaintType'] != null
        ? new ComplaintType.fromJson(json['complaintType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.complaintType != null) {
      data['complaintType'] = this.complaintType!.toJson();
    }
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