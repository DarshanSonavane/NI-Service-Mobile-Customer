import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ni_service/Utils/Constants.dart';
import 'package:ni_service/model/RequestCalibration.dart';
import 'package:ni_service/model/RequestValidateCalibration.dart';
import 'package:ni_service/model/ResponseGetEmpList.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../http_service/services.dart';
import '../widgets/SharedPreferencesManager.dart';

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
      progressIndicator: const CircularProgressIndicator(
        valueColor:
            AlwaysStoppedAnimation<Color>(Colors.red), // Change color here
      ),
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
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                          icon:
                              Icon(Icons.arrow_drop_down, color: Colors.black),
                          style: const TextStyle(color: Colors.black),
                          underline: SizedBox(),
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
                          getEmpData.toString().isNotEmpty) {
                        createCalibrationAPI(getEmpData!.sId);
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
          Overlay.of(context)!.context.findRenderObject() as RenderBox;
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

    try {
      setState(() {
        _isLoading = true;
      });
      final responseCreateCalibration =
          await createCalibrationRequest(requestCalibration);
      if (responseCreateCalibration.data != null) {
        Alert(
          context: context,
          title: 'Calibration Request',
          desc: responseCreateCalibration.message,
          buttons: [
            DialogButton(
              child: const Text(
                'Done',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                setState(() {
                  getEmpData = null;
                  selectedRadioListTile = "";
                });
                Navigator.of(context).pop(); // Close the alert
              },
              color: Color.fromRGBO(0, 179, 134, 1.0), // Button color
            ),
          ],
        ).show();
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
        if(responseValidateCalibration.differenceDays!.toInt() < 10){
          Alert(
            context: context,
            title: 'Calibration Request',
            desc:
            "You can not raise a new calibration request for this machine type for next ${10 - responseValidateCalibration.differenceDays!.toInt()} days",
            buttons: [
              DialogButton(
                child: const Text(
                  'Done',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  setState(() {
                    getEmpData = null;
                    selectedRadioListTile = "";
                  });
                  Navigator.of(context).pop();
                },
                color: Color.fromRGBO(0, 179, 134, 1.0), // Button color
              ),
            ],
          ).show();
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
}
