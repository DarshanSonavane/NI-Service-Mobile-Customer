import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ni_service/Utils/Constants.dart';
import 'package:ni_service/Screens/customDialogForMobileGSTAndEmail.dart';
import 'package:ni_service/model/ResponseDashboardDetails.dart';
import 'package:ni_service/widgets/SharedPreferencesManager.dart';
import 'package:ni_service/widgets/imageprogressindicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import '../http_service/services.dart';

class Home extends StatefulWidget {
  final String title;
  final String cus_Name;
  final String? email;
  final String? mobile;
  final String? customer_id;

  const Home(
      {Key? key,
      required this.title,
      required this.cus_Name,
      required this.email,
      required this.mobile,
      required this.customer_id})
      : super(key: key);

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
      child: Container(
        color: Colors.grey.shade300,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: emailMobileAvailable
                ? Card(
                    elevation: 4, // Add elevation for a shadow effect
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15.0), // Add rounded corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                countOfVisit(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurpleAccent,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            widget.cus_Name,
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
                                        color: const Color(0xff0293ee),
                                        value: countOfComplaints.toDouble(),
                                        title: countOfComplaints.toString(),
                                        radius: 80,
                                        titleStyle: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      PieChartSectionData(
                                        color: Colors.red,
                                        value: openComplaints.toDouble(),
                                        title: openComplaints.toString(),
                                        radius: 80,
                                        titleStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      PieChartSectionData(
                                        color: Colors.green,
                                        value: closedComplaints.toDouble(),
                                        title: closedComplaints.toString(),
                                        radius: 80,
                                        titleStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                    borderData: FlBorderData(show: false),
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
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Column(
                                children: [
                                  _buildColorBox(const Color(0xff0293ee),
                                      'Total Complaint Count'),
                                  const SizedBox(height: 10),
                                  _buildColorBox(Colors.red, 'Open Complaint'),
                                  const SizedBox(height: 10),
                                  _buildColorBox(
                                      Colors.green, 'Close Complaint'),
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
    );
  }

  Future<void> _fetchCountOfComplaints() async {
    setState(() {
      _isLoading = true;
    });
    String? customerId = sharedPreferences?.getString(CUSTOMERID);
    ResponseDashboardDetails responseDashboardDetails =
        await complaintsCounts(customerId!, VersionApp);
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
                widget.customer_id!,
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
      Alert(
        context: context,
        title: 'Service Request',
        desc: responseDashboardDetails.message,
        buttons: [
          if (responseDashboardDetails.message !=
              'Please update the app to keep using it. If you don\'t update, the app might stop working.')
            DialogButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert
              },
              color: Color.fromRGBO(0, 179, 134, 1.0),
              child: const Text(
                'Done',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ), // Button color
            ),
          if (responseDashboardDetails.message ==
              'Please update the app to keep using it. If you don\'t update, the app might stop working.')
            DialogButton(
              onPressed: () {
                _launchPlayStore();
                Navigator.of(context).pop(); // Close the alert
              },
              color: Colors.blue,
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ), // Button color
            ),
        ],
      ).show();
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
