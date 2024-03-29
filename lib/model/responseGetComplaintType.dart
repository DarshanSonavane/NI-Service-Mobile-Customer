class responseGetComplaintType {
  String? code;
  String? message;
  List<dataComplainType>? data;

  responseGetComplaintType({this.code, this.message, this.data});

  responseGetComplaintType.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <dataComplainType>[];
      json['data'].forEach((v) {
        data!.add(new dataComplainType.fromJson(v));
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

class dataComplainType {
  String? sId;
  String? name;
  int? iV;

  dataComplainType({this.sId, this.name, this.iV});

  dataComplainType.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['__v'] = this.iV;
    return data;
  }
}