import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:ni_service/model/FCMDetails/RequestFCMKeyDetails.dart';
import 'package:ni_service/model/FCMDetails/ResponseFCMKeyDetails.dart';
import 'package:ni_service/model/RequestCalibration.dart';
import 'package:ni_service/model/RequestCustomerDetailsModel.dart';
import 'package:ni_service/model/RequestGetCustomerCalibrationList.dart';
import 'package:ni_service/model/RequestSetPassword.dart';
import 'package:ni_service/model/RequestTrackComplaint.dart';
import 'package:ni_service/model/RequestValidateCalibration.dart';
import 'package:ni_service/model/ResponseCalibrationService.dart';
import 'package:ni_service/model/ResponseCustomerDetailsModel.dart';
import 'package:ni_service/model/ResponseDashboardDetails.dart';
import 'package:ni_service/model/ResponseFeedback.dart';
import 'package:ni_service/model/ResponseGetCustomerCalibrationList.dart';
import 'package:ni_service/model/ResponseGetEmpList.dart';
import 'package:ni_service/model/ResponseNotificationList.dart';
import 'package:ni_service/model/ResponseSetPassword.dart';
import 'package:ni_service/model/ResponseTrackComplaint.dart';
import 'package:ni_service/model/ResponseValidateCalibration.dart';
import 'package:ni_service/model/requestCreateService.dart';
import 'package:ni_service/model/requestFeedback.dart';
import 'package:ni_service/model/requestLogin.dart';
import 'package:ni_service/model/responseCreateService.dart';
import 'package:ni_service/model/responseGetServiceRequestList.dart';
import 'package:ni_service/model/responseLogin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/responseGetComplaintType.dart';

Future<responseLogin> loginAPI(requestLogin requestLogin) async {
  try {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    var res = await http.post(Uri.http("16.170.250.91:3000", "/login"),
        body: jsonEncode(requestLogin), headers: headers);
    final json = jsonDecode(res.body);
    return responseLogin.fromJson(json);
  } catch (e) {
    if (kDebugMode) {
      print("Hello $e");
    }
    throw Exception(e);
  }
}

Future<responseGetComplaintType> getComplaintListAPI() async {
  try {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    var res = await http.get(
        Uri.http("16.170.250.91:3000", "/complaint-type-list"),
        headers: headers);
    final json = jsonDecode(res.body);
    return responseGetComplaintType.fromJson(json);
  } catch (e) {
    throw Exception(e);
  }
}

Future<responseCreateService> createServiceRequest(
    requestCreateService requestCreateServices) async {
  try {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    var res = await http.post(
        Uri.http("16.170.250.91:3000", "/create-service-request"),
        body: jsonEncode(requestCreateServices),
        headers: headers);
    final json = jsonDecode(res.body);
    return responseCreateService.fromJson(json);
  } catch (e) {
    throw Exception(e);
  }
}

Future<responseGetServiceRequestList> fetchComplaints(String customerId) async {
  try {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    final queryParameters = {'customerId': customerId};
    var res = await http.get(
        Uri.http("16.170.250.91:3000", "/get-my-complaints", queryParameters),
        headers: headers);
    final json = jsonDecode(res.body);
    return responseGetServiceRequestList.fromJson(json);
  } catch (e) {
    throw Exception(e);
  }
}

//http://16.170.250.91:3000/get-dashboard-details
Future<ResponseDashboardDetails> complaintsCounts(String customerId, String appVersion) async {
  try {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    final queryParameters = {'customerId': customerId, 'version' : appVersion};
    var res = await http.get(
        Uri.http(
            "16.170.250.91:3000", "/get-dashboard-details", queryParameters),
        headers: headers);
    final json = jsonDecode(res.body);
    return ResponseDashboardDetails.fromJson(json);
  } catch (e) {
    throw Exception(e);
  }
}

Future<ResponseFeedback> sendFeedbackRequest(
    RequestFeedback requestFeedback) async {
  try {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    var res = await http.post(Uri.http("16.170.250.91:3000", "/save-feedback"),
        body: jsonEncode(requestFeedback), headers: headers);
    final json = jsonDecode(res.body);
    return ResponseFeedback.fromJson(json);
  } catch (e) {
    throw Exception(e);
  }
}

Future<ResponseCustomerDetails> CustomerDetailsAPI(
    RequestCustomerDetails requestCustomerDetails) async {
  try {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    var res = await http.post(
        Uri.http("16.170.250.91:3000", "/update-customer-details"),
        body: jsonEncode(requestCustomerDetails),
        headers: headers);
    final json = jsonDecode(res.body);
    return ResponseCustomerDetails.fromJson(json);
  } catch (e) {
    throw Exception(e);
  }
}

Future<ResponseSetPassword> setPasswordAPI(
    RequestSetPassword requestSetPassword) async {
  try {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    var res = await http.post(
        Uri.http("16.170.250.91:3000", "/update-customer-password"),
        body: jsonEncode(requestSetPassword),
        headers: headers);
    final json = jsonDecode(res.body);
    return ResponseSetPassword.fromJson(json);
  } catch (e) {
    throw Exception(e);
  }
}

Future<ResponseTrackComplaint> fetchTrackComplaint(
    RequestTrackComplaint requestTrackComplaint) async {
  try {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    var res = await http.post(
        Uri.http("16.170.250.91:3000", "/track-complaint"),
        body: jsonEncode(requestTrackComplaint),
        headers: headers);
    final json = jsonDecode(res.body);
    return ResponseTrackComplaint.fromJson(json);
  } catch (e) {
    throw Exception(e);
  }
}

Future<ResponseGetEmpList> fetchDataEmployeeCalibration() async {
  try {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    var res = await http.get(
        Uri.http("16.170.250.91:3000", "/calibration-employee-list"),
        headers: headers);
    final json = jsonDecode(res.body);
    return ResponseGetEmpList.fromJson(json);
  } catch (e) {
    throw Exception(e);
  }
}

Future<ResponseNotificationList> fetchNotifications() async {
  try {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    var res = await http.get(
        Uri.http("16.170.250.91:3000", "/fetch-notification"),
        headers: headers);
    final json = jsonDecode(res.body);
    return ResponseNotificationList.fromJson(json);
  } catch (e) {
    throw Exception(e);
  }
}

Future<ResponseCalibrationService> createCalibrationRequest(
    RequestCalibration requestCalibration) async {
  try {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    var res = await http.post(
        Uri.http("16.170.250.91:3000", "/request-calibration"),
        body: jsonEncode(requestCalibration),
        headers: headers);
    final json = jsonDecode(res.body);
    return ResponseCalibrationService.fromJson(json);
  } catch (e) {
    throw Exception(e);
  }
}

Future<ResponseGetCustomerCalibrationList> fetchCalibrationList(
    RequestGetCustomerCalibrationList requestGetCustomerCalibrationList) async {
  try {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    var res = await http.post(
        Uri.http("16.170.250.91:3000", "/get-customer-calibration-list"),
        body: jsonEncode(requestGetCustomerCalibrationList),
        headers: headers);
    final json = jsonDecode(res.body);
    return ResponseGetCustomerCalibrationList.fromJson(json);
  } catch (e) {
    throw Exception(e);
  }
}

Future<ResponseValidateCalibration> validateCalibrationRequest(
    RequestValidateCalibration requestValidateCalibration) async {
  try {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    var res = await http.post(
        Uri.http("16.170.250.91:3000", "/validate-calibration"),
        body: jsonEncode(requestValidateCalibration),
        headers: headers);
    final json = jsonDecode(res.body);
    return ResponseValidateCalibration.fromJson(json);
  } catch (e) {
    throw Exception(e);
  }
}

Future<ResponseFCMKeyDetails> sendTokenToServer(
    RequestFCMKeyDetails requestFcmKeyDetails) async {
  try {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    var res = await http.post(
        Uri.http("16.170.250.91:3000", "/insert-customer-fcm-details"),
        body: jsonEncode(requestFcmKeyDetails),
        headers: headers);
    final json = jsonDecode(res.body);
    return ResponseFCMKeyDetails.fromJson(json);
  } catch (e) {
    throw Exception(e);
  }
}
