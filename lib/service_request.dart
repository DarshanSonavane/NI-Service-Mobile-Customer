import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ni_service/model/responseGetComplaintType.dart';
import 'package:ni_service/widgets/SharedPreferencesManager.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'http_service/services.dart';
import 'model/requestCreateService.dart';
import 'model/responseGetServiceRequestList.dart';

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

  @override
  void initState() {
    selectedRadioListTile = "Petrol";
    super.initState();
    getComplaintList();
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
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38, width: 1.5),
                        borderRadius: BorderRadius.circular(
                            8.0), // Optionally, add border radius
                      ),
                      child: GestureDetector(
                        onTap: () => showDropdownMenu(),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedComplaint?.name ?? 'Select Complaint',
                              ),
                            ),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedComplaint.toString().isNotEmpty) {
                        _fetchComplaints();
                        // createServiceRequestAPI();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please Select above Options")));
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
                      // Adjust padding
                      child: Text('Submit',
                          style: TextStyle(fontSize: 18.0)), // Adjust font size
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

  Future<void> getComplaintList() async {
    try {
      setState(() {
        _isLoading = true;
      });
      responseGetComplaint = await getComplaintListAPI();
      if (responseGetComplaint.code == "200" &&
          responseGetComplaint.data != null) {
        List<dataComplainType> fetchedData =
            List<dataComplainType>.from(responseGetComplaint.data!);
        setState(() {
          complaintDatas = fetchedData;
        });
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

  Future<void> createServiceRequestAPI() async {
    String? customerId = sharedPreferences?.getString("CustomerId");
    String? complaintTypes = selectedComplaint!.sId!;
    requestCreateService requestCreateServices = requestCreateService();
    requestCreateServices.machineType =
        selectedRadioListTile == 'Petrol' ? "0" : "1";
    requestCreateServices.complaintType = complaintTypes;
    requestCreateServices.customerId = customerId;
    requestCreateServices.status = "1";
    try {
      setState(() {
        _isLoading = true;
      });
      final responseCreateService =
          await createServiceRequest(requestCreateServices);
      if (responseCreateService.code == "200" &&
          responseCreateService.data != null) {
        Alert(
          context: context,
          title: 'Service Request',
          desc: responseCreateService.message,
          buttons: [
            DialogButton(
              child: const Text(
                'Done',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                // Perform action on Done button press
                Navigator.of(context).pop(); // Close the alert
              },
              color: Color.fromRGBO(0, 179, 134, 1.0), // Button color
            ),
          ],
        ).show();
      } else {
        Alert(
          context: context,
          title: 'Service Request',
          desc: responseCreateService.message,
          buttons: [
            DialogButton(
              child: Text(
                'Done',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                // Perform action on Done button press
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

  Future<void> _fetchComplaints() async {
    setState(() {
      _isLoading = true;
    });
    bool isComplaintOpen = false;
    String? customerId = sharedPreferences?.getString("CustomerId");
    final responseGetServiceRequestList = await fetchComplaints(customerId!);
    if (responseGetServiceRequestList.code == "200" &&
        responseGetServiceRequestList.data != null) {
      dataComplainList = responseGetServiceRequestList.data;
      if (dataComplainList != null && dataComplainList!.isNotEmpty) {
        for (int i = 0; i < dataComplainList!.length; i++) {
          if(dataComplainList![i].status == "1"){
            isComplaintOpen = true;
            break;
          }
        }

        if(isComplaintOpen){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Your last Complaint is open, You can not raise a new Compalaint")));
        }else{
          createServiceRequestAPI();
        }
      }else{
        createServiceRequestAPI();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseGetServiceRequestList.message!)));
    }

    setState(() {
      _isLoading = false; // Data is fetched, set loading to false
    });
  }

  void showDropdownMenu() {
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
  }
}
