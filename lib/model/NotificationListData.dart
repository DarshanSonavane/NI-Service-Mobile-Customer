class NotificationListData {
  String? sId;
  String? file;
  String? extension;
  String? notes;
  String? createdAt;
  String? updatedAt;
  int? iV;

  NotificationListData(
      {this.sId,
      this.file,
      this.extension,
      this.notes,
      this.createdAt,
      this.updatedAt,
      this.iV});

  NotificationListData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    file = json['file'];
    extension = json['extension'];
    notes = json['notes'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['file'] = file;
    data['extension'] = extension;
    data['notes'] = notes;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
