import 'NotificationListData.dart';

class ResponseNotificationList {
    String? code;
    String? message;
    List<NotificationListData>? data;

    ResponseNotificationList({this.code, this.message, this.data});

    ResponseNotificationList.fromJson(Map<String, dynamic> json) {
        code = json['code'];
        message = json['message'];
        if (json['data'] != null) {
            data = <NotificationListData>[];
            json['data'].forEach((v) {
                data!.add(new NotificationListData.fromJson(v));
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