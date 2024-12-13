import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ni_service/Utils/Constants.dart';
import 'package:ni_service/model/RequestCalibration.dart';
import 'package:ni_service/model/RequestValidateCalibration.dart';
import 'package:ni_service/model/ResponseGetEmpList.dart';
import 'package:ni_service/widgets/imageprogressindicator.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Screens/login_screen.dart';
import '../Utils/clear_hive_data.dart';
import '../http_service/services.dart';
import '../model/otp_details/request_otp.dart';
import '../model/send_otp/request_send_otp.dart';
import '../widgets/shared_preference_manager.dart';

class Calibration extends StatefulWidget {
  final String title;

  const Calibration({Key? key, required this.title}) : super(key: key);

  @override
  State<Calibration> createState() => _CalibrationState();
}

class _CalibrationState extends State<Calibration> {
  String? selectedRadioListTile;
  late ResponseGetEmpList responseGetEmpList;
  Data? getEmpData;
  late List<Data> getEmpName = [];
  bool _isLoading = false;
  final sharedPreferences = SharedPreferencesManager.instance;
  String? customerId = "";
  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();

  @override
  void initState() {
    super.initState();
    customerId = sharedPreferences?.getString(CUSTOMERID);
    _fetchEmployeeData();
  }

  setSelectedRadioTile(String val) {
    setState(() {
      selectedRadioListTile = val;
      _validateCalibration(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: const Imageprogressindicator(),
      child: Scaffold(
        body: Container(
          color: Colors.grey.shade300,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15.0), // Add rounded corners
              ),
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
                  RadioListTile(
                    activeColor: Colors.lightGreen,
                    title: Text(
                      "Combo",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold),
                    ),
                    value: "Combo",
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
                        'Select Employee',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButton<Data>(
                          value: getEmpData,
                          onChanged: (newValue) {
                            setState(() {
                              getEmpData = newValue;
                            });
                          },
                          items: getEmpName.map((Data employee) {
                            return DropdownMenuItem<Data>(
                              value: employee,
                              child: Text(
                                '${employee.firstName} ${employee.lastName}',
                                style: const TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          hint: const Text(
                            'Select Employee',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down,
                              color: Colors.black),
                          style: const TextStyle(color: Colors.black),
                          underline: const SizedBox(),
                          // Remove the default underline
                          elevation: 8,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      if (getEmpData != null &&
                          getEmpData.toString().isNotEmpty &&
                          selectedRadioListTile!.isNotEmpty) {
                        getOTP();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please Select above Options")),
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
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showDropdownMenu() {
    try {
      final RenderBox button = context.findRenderObject() as RenderBox;
      final RenderBox overlay =
          Overlay.of(context).context.findRenderObject() as RenderBox;
      final Offset position =
          button.localToGlobal(Offset.zero, ancestor: overlay);

      final List<PopupMenuEntry<Data>> items = getEmpName.map((Data employee) {
        return PopupMenuItem<Data>(
          value: employee,
          child: Text(
            '${employee.firstName} ${employee.lastName}',
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList();

      final RenderBox containerBox = context.findRenderObject() as RenderBox;
      final Offset containerPosition = containerBox.localToGlobal(Offset.zero);

      showMenu<Data>(
        context: context,
        position: RelativeRect.fromLTRB(
          position.dx,
          containerPosition.dy + containerBox.size.height,
          0,
          0,
        ),
        items: items,
      ).then((selectedValue) {
        if (selectedValue != null) {
          setState(() {
            getEmpData = selectedValue;
          });
        } else {
          setState(() {
            getEmpData = null;
          });
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
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

  Future<void> _fetchEmployeeData() async {
    setState(() {
      _isLoading = true;
    });
    final responseGetEmpList = await fetchDataEmployeeCalibration();
    if (responseGetEmpList.data != null &&
        responseGetEmpList.data!.isNotEmpty) {
      getEmpName = responseGetEmpList.data!;
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(responseGetEmpList.message!)));
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> createCalibrationAPI(String? empId) async {
    RequestCalibration requestCalibration = RequestCalibration();
    requestCalibration.customerId = customerId;
    String machineType = selectedRadioListTile == 'Petrol'
        ? "0"
        : (selectedRadioListTile == 'Diesel' ? "1" : "2");
    requestCalibration.machineType = machineType;
    requestCalibration.employeeId = empId;
    requestCalibration.versionName = versionApp;

    try {
      setState(() {
        _isLoading = true;
      });
      final responseCreateCalibration =
          await createCalibrationRequest(requestCalibration);
      if (responseCreateCalibration.code == "200" &&
          responseCreateCalibration.data != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Calibration Request'),
              content: Text(responseCreateCalibration.message!),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      getEmpData = null;
                      selectedRadioListTile = "";
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 179, 134, 1.0),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            );
          },
        );

        // Alert(
        //   context: context,
        //   title: 'Calibration Request',
        //   desc: responseCreateCalibration.message,
        //   buttons: [
        //     DialogButton(
        //       onPressed: () {
        //         setState(() {
        //           getEmpData = null;
        //           selectedRadioListTile = "";
        //         });
        //         Navigator.of(context).pop(); // Close the alert
        //       },
        //       color: const Color.fromRGBO(0, 179, 134, 1.0),
        //       child: const Text(
        //         'Done',
        //         style: TextStyle(color: Colors.white, fontSize: 20),
        //       ), // Button color
        //     ),
        //   ],
        // ).show();
      } else {
        if (responseCreateCalibration.message ==
            'Please update the app to keep using it. If you don\'t update, the app might stop working.') {
          _logoutUser();
        } else {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Calibration'),
                content: Text(responseCreateCalibration.message!),
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

  Future<void> _validateCalibration(String val) async {
    RequestValidateCalibration requestValidateCalibration =
        RequestValidateCalibration();
    requestValidateCalibration.customerId = customerId;
    String machineType = selectedRadioListTile == 'Petrol'
        ? "0"
        : (selectedRadioListTile == 'Diesel' ? "1" : "2");
    requestValidateCalibration.machineType = machineType;

    try {
      setState(() {
        _isLoading = true;
      });
      final responseValidateCalibration =
          await validateCalibrationRequest(requestValidateCalibration);
      if (responseValidateCalibration.code == "200" &&
          !responseValidateCalibration.isNewrecord!) {
        if (responseValidateCalibration.differenceDays!.toInt() < 10) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return PopScope(
                canPop: false,
                child: AlertDialog(
                  title: const Text('Calibration Request'),
                  content: Text(
                      "You can not raise a new calibration request for this machine type for next ${10 - responseValidateCalibration.differenceDays!.toInt()} days"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          getEmpData = null;
                          selectedRadioListTile = "";
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('Done'),
                    ),
                  ],
                ),
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
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        _isLoading = false;
      });
    }
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

  void _showOtpDialog(String? customercode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Enter OTP",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
        createCalibrationAPI(getEmpData!.sId);
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

  void _launchPlayStore() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.request.ni_service&pli=1'; // Replace with your app's Play Store link

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
