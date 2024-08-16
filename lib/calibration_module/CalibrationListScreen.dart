import 'package:flutter/material.dart';
import 'package:ni_service/Utils/Constants.dart';
import 'package:ni_service/model/RequestGetCustomerCalibrationList.dart';
import 'package:ni_service/widgets/imageprogressindicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../http_service/services.dart';
import '../model/ResponseGetCustomerCalibrationList.dart';
import '../widgets/SharedPreferencesManager.dart';

class CalibrationListScreen extends StatefulWidget {
  final String title;

  const CalibrationListScreen({super.key, required this.title});

  @override
  _CalibrationListScreenState createState() => _CalibrationListScreenState();
}

class _CalibrationListScreenState extends State<CalibrationListScreen> {
  late Future<ResponseGetCustomerCalibrationList> _futureCalibrationList;
  final sharedPreferences = SharedPreferencesManager.instance;

  @override
  void initState() {
    super.initState();
    String? customerId = sharedPreferences?.getString(CUSTOMERID);
    RequestGetCustomerCalibrationList requestCalibration =
        RequestGetCustomerCalibrationList();
    requestCalibration.customerId = customerId;
    _futureCalibrationList = fetchCalibrationList(requestCalibration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade300,
        child: FutureBuilder<ResponseGetCustomerCalibrationList>(
          future: _futureCalibrationList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Imageprogressindicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data!.data!.isEmpty) {
                return const Center(
                  child: Text('No data found', style: TextStyle(fontSize: 20)),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.data!.length,
                itemBuilder: (context, index) {
                  var calibration = snapshot.data!.data![index];
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
                    child: Card(
                        elevation: 4,
                        color: Colors.white,
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildRow("Customer Code",
                                  calibration.customerId!.customerCode),
                              const SizedBox(height: 10),
                              buildRow("Customer Name",
                                  calibration.customerId!.customerName),
                              const SizedBox(height: 10),
                              buildRow("Employee Assigned",
                                  "${calibration.employeeId!.firstName} ${calibration.employeeId!.lastName}"),
                              const SizedBox(height: 10),
                              buildRow("Employee Contact",
                                  "${calibration.employeeId!.phone}",
                                  isPhone: true),
                              const SizedBox(height: 10),
                              buildRow(
                                  "Machine Type",
                                  (calibration.machineType! == "1")
                                      ? "Diesel"
                                      : (calibration.machineType! == "2")
                                          ? "Combo"
                                          : "Petrol"),
                              const SizedBox(height: 10),
                            ],
                          ),
                        )),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('No data available.'),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildRow(String label, String? value, {bool isPhone = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label : ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            )),
        Expanded(
          child: isPhone
              ? GestureDetector(
                  onTap: () async {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: value,
                    );
                    await launchUrl(launchUri);
                  },
                  child: Text(
                    value!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              : Text(
                  value!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
        ),
      ],
    );
  }
}
