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
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['_id'] = this.sId;
        data['file'] = this.file;
        data['extension'] = this.extension;
        data['notes'] = this.notes;
        data['createdAt'] = this.createdAt;
        data['updatedAt'] = this.updatedAt;
        data['__v'] = this.iV;
        return data;
    }
}