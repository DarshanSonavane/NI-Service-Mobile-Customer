class RequestCustomerDetails {
  String? customerId;
  String? mobile;
  String? email;
  String? gstNo;

  RequestCustomerDetails(
      {this.customerId, this.mobile, this.email, this.gstNo});

  RequestCustomerDetails.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    mobile = json['mobile'];
    email = json['email'];
    gstNo = json['gstNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    data['mobile'] = mobile;
    data['email'] = email;
    data['gstNo'] = gstNo;
    return data;
  }
}
