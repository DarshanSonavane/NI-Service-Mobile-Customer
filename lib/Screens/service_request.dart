import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ni_service/Utils/Constants.dart';
import 'package:ni_service/model/otp_details/request_otp.dart';
import 'package:ni_service/model/responseGetComplaintType.dart';
import 'package:ni_service/model/send_otp/request_send_otp.dart';
import 'package:ni_service/widgets/shared_preference_manager.dart';
import 'package:ni_service/widgets/imageprogressindicator.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import '../Utils/clear_hive_data.dart';
import '../http_service/services.dart';
import '../model/requestCreateService.dart';
import '../model/responseGetServiceRequestList.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login_screen.dart';

class ServiceRequest extends StatefulWidget {
  final String title;

  const ServiceRequest({Key? key, required this.title}) : super(key: key);

  @override
  State<ServiceRequest> createState() => _ServiceRequestState();
}

class _ServiceRequestState extends State<ServiceRequest> {
  late String selectedRadioListTile;
  late responseGetComplaintType responseGetComplaint;
  dataComplainType? selectedComplaint;
  late List<dataComplainType> complaintDatas = [];
  bool _isLoading = false;
  final sharedPreferences = SharedPreferencesManager.instance;
  List<DataComplaintsList>? dataComplainList;
  bool isComplaintOpen = false;
  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();
  final TextEditingController additionalRequirementController =
      TextEditingController();

  @override
  void initState() {
    selectedRadioListTile = "Petrol";
    super.initState();
    _fetchComplaints();
  }

  setSelectedRadioTile(String val) {
    setState(() {
      selectedRadioListTile = val;
    });
  }

  List<String> topicOptions = [];

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: const Imageprogressindicator(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          color: Colors.grey.shade300,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15.0), // Add rounded corners
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 18.0, top: 30),
                              child: Text(
                                'Machine Type',
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          RadioListTile(
                            activeColor: Colors.lightGreen,
                            title: Text(
                              "Petrol",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold),
                            ),
                            value: "Petrol",
                            groupValue: selectedRadioListTile,
                            onChanged: (value) {
                              setState(() {
                                setSelectedRadioTile(value!);
                              });
                            },
                          ),
                          RadioListTile(
                            activeColor: Colors.lightGreen,
                            title: Text(
                              "Diesel",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold),
                            ),
                            value: "Diesel",
                            groupValue: selectedRadioListTile,
                            onChanged: (value) {
                              setState(() {
                                setSelectedRadioTile(value!);
                              });
                            },
                          ),
                          const SizedBox(height: 30),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 18.0),
                              child: Text(
                                'Nature of complaint',
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 12.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black38, width: 1.5),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: GestureDetector(
                                onTap: () => showDropdownMenu(),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        selectedComplaint?.name ??
                                            'Select Complaint',
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: TextField(
                              controller: additionalRequirementController,
                              maxLines: 5,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Additional Requirements (Optional)',
                                alignLabelWithHint: true,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          isComplaintOpen
                              ? ElevatedButton(
                                  onPressed: null, // Button is disabled
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade400,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40.0, vertical: 16.0),
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.white),
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    if (selectedComplaint
                                        .toString()
                                        .isNotEmpty) {
                                      getOTP();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Please Select above Options")),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40.0, vertical: 16.0),
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 30),
                          Visibility(
                            visible: isComplaintOpen,
                            child: const Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(left: 18.0),
                                child: Text(
                                  "Note :- You can not raise new complaint until your existing"
                                  " complaint is closed or feedback is provided",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getComplaintList() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      responseGetComplaint = await getComplaintListAPI();
      if (responseGetComplaint.code == "200" &&
          responseGetComplaint.data != null) {
        List<dataComplainType> fetchedData =
            List<dataComplainType>.from(responseGetComplaint.data!);
        if (mounted) {
          setState(() {
            complaintDatas = fetchedData;
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _logoutUser() async {
    //clearUserBox();
    await clearExcept(ONBOARDINGCOMPLETED);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const LoginScreen(
                  title: "Login",
                  showDialogOnLoad: true,
                )));
  }

  Future<void> getOTP() async {
    String? customercode = sharedPreferences?.getString("CustomerCode");
    RequestOtp requestOtp = RequestOtp();
    requestOtp.customerCode = customercode;
    try {
      setState(() {
        _isLoading = true;
      });
      final responseOtp = await fetchOtp(requestOtp);
      if (responseOtp.code == "200") {
        _showOtpDialog(customercode);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> createServiceRequestAPI() async {
    String? customerId = sharedPreferences?.getString(CUSTOMERID);
    String? complaintTypes = selectedComplaint!.sId!;
    requestCreateService requestCreateServices = requestCreateService();
    requestCreateServices.machineType =
        selectedRadioListTile == 'Petrol' ? "0" : "1";
    requestCreateServices.complaintType = complaintTypes;
    requestCreateServices.customerId = customerId;
    requestCreateServices.status = "1";
    requestCreateServices.version = versionApp;
    requestCreateServices.addintionalReq = additionalRequirementController.text;

    try {
      setState(() {
        _isLoading = true;
      });
      final responseCreateService =
          await createServiceRequest(requestCreateServices);
      if (responseCreateService.code == "200" &&
          responseCreateService.data != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Service Request'),
              content: Text(responseCreateService.message!),
              actions: [
                TextButton(
                  onPressed: () {
                    _fetchComplaints();
                    setState(() {
                      selectedComplaint = null;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(
                        color: Color.fromRGBO(0, 179, 134, 1.0), fontSize: 20),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        if (responseCreateService.message ==
            'Please update the app to keep using it. If you don\'t update, the app might stop working.') {
          _logoutUser();
        } else {
          showDialog(
            context: context,
            barrierDismissible:
                false, // Prevent dismissing the dialog by tapping outside
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Service Request'),
                content: Text(responseCreateService.message!),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Done'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchComplaints() async {
    setState(() {
      _isLoading = true;
    });

    String? customerId = sharedPreferences?.getString(CUSTOMERID);
    final responseGetServiceRequestList = await fetchComplaints(customerId!);
    if (responseGetServiceRequestList.code == "200" &&
        responseGetServiceRequestList.data != null) {
      dataComplainList = responseGetServiceRequestList.data;
      if (dataComplainList != null && dataComplainList!.isNotEmpty) {
        for (int i = 0; i < dataComplainList!.length; i++) {
          if (dataComplainList![i].ratings == null) {
            isComplaintOpen = true;
            break;
          }
        }

        if (isComplaintOpen) {
          setState(() {});
        } else {
          getComplaintList();
        }
      } else {
        getComplaintList();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseGetServiceRequestList.message!)));
    }

    setState(() {
      _isLoading = false;
    });
  }

  void showDropdownMenu() {
    try {
      final RenderBox button = context.findRenderObject() as RenderBox;
      final RenderBox overlay =
          Overlay.of(context).context.findRenderObject() as RenderBox;
      final RelativeRect position = RelativeRect.fromRect(
        Rect.fromPoints(
          button.localToGlobal(Offset.zero, ancestor: overlay),
          button.localToGlobal(button.size.bottomRight(Offset.zero),
              ancestor: overlay),
        ),
        Offset.zero & overlay.size,
      );

      final List<PopupMenuEntry<dataComplainType>> items =
          complaintDatas.map((dataComplainType complaint) {
        return PopupMenuItem<dataComplainType>(
          value: complaint,
          child: Text(complaint.name!),
        );
      }).toList();

      showMenu<dataComplainType>(
        context: context,
        position: position,
        items: items,
      ).then((selectedValue) {
        if (selectedValue != null) {
          setState(() {
            selectedComplaint = selectedValue;
          });
        } else {
          setState(() {
            selectedComplaint = null; // You can set it to any default value
          });
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  void _launchPlayStore() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.request.ni_service&pli=1'; // Replace with your app's Play Store link

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showOtpDialog(String? customercode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enter OTP"),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "You have recieved your one time password on your registered email, please check your email.",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 25),
              OtpPinField(
                key: _otpPinFieldController,
                autoFillEnable: true,
                textInputAction: TextInputAction.done,
                onSubmit: (text) {
                  _sendOTP(text, customercode);
                },
                onChange: (text) {
                  debugPrint('Enter on change pin is $text');
                },
                otpPinFieldStyle: const OtpPinFieldStyle(
                  showHintText: true,
                  activeFieldBorderGradient:
                      LinearGradient(colors: [Colors.black, Colors.redAccent]),
                  filledFieldBorderGradient:
                      LinearGradient(colors: [Colors.green, Colors.tealAccent]),
                  defaultFieldBorderGradient:
                      LinearGradient(colors: [Colors.orange, Colors.brown]),
                  fieldBorderWidth: 3,
                ),
                maxLength: 4,
                showCursor: true,
                cursorWidth: 1,
                mainAxisAlignment: MainAxisAlignment.center,
                otpPinFieldDecoration:
                    OtpPinFieldDecoration.defaultPinBoxDecoration,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _sendOTP(String text, String? customercode) async {
    RequestSendOtp requestSendOtp = RequestSendOtp();
    requestSendOtp.customerCode = customercode;
    requestSendOtp.otp = text;
    try {
      setState(() {
        _isLoading = true;
      });
      final responseOtp = await sendOtpDetails(requestSendOtp);
      if (responseOtp.code == '200') {
        Navigator.of(context).pop();
        createServiceRequestAPI();
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseOtp.message!)),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isLoading = false;
      });
    }
  }
}
