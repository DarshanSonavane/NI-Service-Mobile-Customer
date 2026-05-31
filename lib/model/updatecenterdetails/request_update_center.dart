class RequestUpdateCenterDetails {
  String? customerId;
  String? petrolRegNumber;
  String? dieselRegNumber;

  RequestUpdateCenterDetails({
    this.customerId,
    this.petrolRegNumber,
    this.dieselRegNumber,
  });

  RequestUpdateCenterDetails.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    petrolRegNumber = json['petrolRegNumber'];
    dieselRegNumber = json['dieselRegNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['customerId'] = customerId;
    data['petrolRegNumber'] = petrolRegNumber;
    data['dieselRegNumber'] = dieselRegNumber;

    return data;
  }
}
