import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ni_service/Screens/login_screen.dart';
import 'package:ni_service/Utils/Constants.dart';
import 'package:ni_service/Screens/custom_dialog_for_mobile_gst_and_email.dart';
import 'package:ni_service/model/ResponseDashboardDetails.dart';
import 'package:ni_service/widgets/shared_preference_manager.dart';
import 'package:ni_service/widgets/imageprogressindicator.dart';

import '../Utils/clear_hive_data.dart';
import '../http_service/services.dart';

class Home extends StatefulWidget {
  final String title;
  final String cusName;
  final String? email;
  final String? mobile;
  final String? customerId;
  final VoidCallback onCalibrationRequested;
  final bool isAmcDueValid;

  const Home({
    Key? key,
    required this.title,
    required this.cusName,
    required this.email,
    required this.mobile,
    required this.customerId,
    required this.onCalibrationRequested,
    required this.isAmcDueValid,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int countOfComplaints = 0;
  late int openComplaints = 0;
  late int closedComplaints = 0;
  bool _isLoading = false;
  final sharedPreferences = SharedPreferencesManager.instance;
  bool emailMobileAvailable = false;

  @override
  void initState() {
    if (widget.email != null &&
        widget.email!.isNotEmpty &&
        widget.mobile != null &&
        widget.mobile!.isNotEmpty) {
      emailMobileAvailable = true;
      _fetchCountOfComplaints();
    } else {
      _fetchCountOfComplaints();
      emailMobileAvailable = false;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: const Imageprogressindicator(),
      child: widget.isAmcDueValid
          ? Container(
              color: Colors.grey.shade300,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.onCalibrationRequested,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          'Request Calibration',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: emailMobileAvailable
                            ? Card(
                                elevation:
                                    4, // Add elevation for a shadow effect
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      15.0), // Add rounded corners
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            countOfVisit(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurpleAccent,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        widget.cusName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.lightGreen,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      if (countOfComplaints == 0 &&
                                          openComplaints == 0 &&
                                          closedComplaints == 0)
                                        const Padding(
                                          padding: EdgeInsets.only(top: 100.0),
                                          child: Text(
                                            'No complaints found',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      else
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: AspectRatio(
                                            aspectRatio: 1.2,
                                            child: PieChart(
                                              PieChartData(
                                                sections: [
                                                  PieChartSectionData(
                                                    color:
                                                        const Color(0xff0293ee),
                                                    value: countOfComplaints
                                                        .toDouble(),
                                                    title: countOfComplaints
                                                        .toString(),
                                                    radius: 80,
                                                    titleStyle: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                  PieChartSectionData(
                                                    color: Colors.red,
                                                    value: openComplaints
                                                        .toDouble(),
                                                    title: openComplaints
                                                        .toString(),
                                                    radius: 80,
                                                    titleStyle: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                  PieChartSectionData(
                                                    color: Colors.green,
                                                    value: closedComplaints
                                                        .toDouble(),
                                                    title: closedComplaints
                                                        .toString(),
                                                    radius: 80,
                                                    titleStyle: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                                borderData:
                                                    FlBorderData(show: false),
                                                sectionsSpace: 0,
                                                centerSpaceRadius: 40,
                                              ),
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 40),
                                      // Add spacing between chart and text
                                      if (!(countOfComplaints == 0 &&
                                          openComplaints == 0 &&
                                          closedComplaints == 0))
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 30.0),
                                          child: Column(
                                            children: [
                                              _buildColorBox(
                                                  const Color(0xff0293ee),
                                                  'Total Complaint Count'),
                                              const SizedBox(height: 10),
                                              _buildColorBox(
                                                  Colors.red, 'Open Complaint'),
                                              const SizedBox(height: 10),
                                              _buildColorBox(Colors.green,
                                                  'Close Complaint'),
                                              const SizedBox(height: 10),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Scaffold(
              body: Center(
                child: Text(
                  "You are not under AMC. Renew your AMC now or contact the system admin.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign
                      .center, // To align text centrally within the widget
                ),
              ),
            ),
    );
  }

  Future<void> _fetchCountOfComplaints() async {
    setState(() {
      _isLoading = true;
    });
    String? customerId = sharedPreferences?.getString(CUSTOMERID);
    ResponseDashboardDetails responseDashboardDetails =
        await complaintsCounts(customerId!, versionApp);
    BuildContext currentContext = context;
    if (responseDashboardDetails.code == "200") {
      if (emailMobileAvailable) {
        countOfComplaints = responseDashboardDetails.totalComplaints!;
        openComplaints = responseDashboardDetails.openComplaints!;
        closedComplaints = responseDashboardDetails.closeComplaints!;
      } else {
        showDialog(
          context: currentContext,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return PopScope(
              canPop: false,
              child: CustomDialogForMobileGSTAndEmail(
                widget.customerId!,
                callback: setFlagForMobileAndEmail,
              ),
            );
          },
        );

        countOfComplaints = responseDashboardDetails.totalComplaints!;
        openComplaints = responseDashboardDetails.openComplaints!;
        closedComplaints = responseDashboardDetails.closeComplaints!;
      }
    } else {
      if (responseDashboardDetails.message ==
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
              content: Text(responseDashboardDetails.message!),
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
    setState(() {
      _isLoading = false; // Data is fetched, set loading to false
    });
  }

  Widget _buildColorBox(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
          margin: const EdgeInsets.only(right: 8),
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  setFlagForMobileAndEmail(String status) {
    if (status == "200") {
      setState(() {
        emailMobileAvailable = true;
        _fetchCountOfComplaints();
      });
    }
  }

  String countOfVisit() {
    if (closedComplaints > 1) {
      return "Total Visits :- $closedComplaints";
    } else {
      return "Total Visit :- $closedComplaints";
    }
  }

  void _logoutUser() async {
    // clearUserBox();
    await clearExcept(ONBOARDINGCOMPLETED);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const LoginScreen(
                  title: "Login",
                  showDialogOnLoad: true,
                )));
  }
}
