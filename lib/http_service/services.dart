import 'package:flutter/foundation.dart';
import 'package:ni_service/model/RequestCustomerDetailsModel.dart';
import 'package:ni_service/model/RequestSetPassword.dart';
import 'package:ni_service/model/ResponseCustomerDetailsModel.dart';
import 'package:ni_service/model/ResponseDashboardDetails.dart';
import 'package:ni_service/model/ResponseFeedback.dart';
import 'package:ni_service/model/ResponseSetPassword.dart';
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
        Uri.http(
            "16.170.250.91:3000", "/get-my-complaints", queryParameters),
        headers: headers);
    final json = jsonDecode(res.body);
    return responseGetServiceRequestList.fromJson(json);
  } catch (e) {
    throw Exception(e);
  }
}

//http://16.170.250.91:3000/get-dashboard-details
Future<ResponseDashboardDetails> complaintsCounts(String customerId) async {
  try {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    final queryParameters = {'customerId': customerId};
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

    var res = await http.post(
        Uri.http("16.170.250.91:3000", "/save-feedback"),
        body: jsonEncode(requestFeedback),
        headers: headers);
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


