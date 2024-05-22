import 'package:flutter/material.dart';
import 'package:ni_service/model/RequestGetCustomerCalibrationList.dart';
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
    String? customerId = sharedPreferences?.getString("CustomerId");
    RequestGetCustomerCalibrationList requestCalibration =
        RequestGetCustomerCalibrationList();
    requestCalibration.customerId = customerId;
    _futureCalibrationList = fetchCalibrationList(requestCalibration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ResponseGetCustomerCalibrationList>(
        future: _futureCalibrationList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.data!.length,
              itemBuilder: (context, index) {
                var calibration = snapshot.data!.data![index];
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0,left: 8.0,right: 8.0),
                  child: Card(
                    elevation: 4,
                    color: Colors.white,
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildRow("Customer Code", calibration.customerId!.customerCode),
                          const SizedBox(height: 10),
                          buildRow("Customer Name", calibration.customerId!.customerName),
                          const SizedBox(height: 10),
                          buildRow("Employee Assigned", "${calibration.employeeId!.firstName} ${calibration.employeeId!.lastName}"),
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
                    )
                    ),
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
    );
  }

  Widget buildRow(String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label : ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            )),
        Expanded(
            child: Text(value!, overflow: TextOverflow.ellipsis, maxLines: 4)),
      ],
    );
  }
}


/*
* Card(
                    child: ListTile(
                      title: Text(
                          'Customer Code: ${calibration.customerId!.customerCode}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Customer Name: ${calibration.customerId!.customerName}'),
                          Text(
                              'Employee: ${calibration.employeeId!.firstName} ${calibration.employeeId!.lastName}'),
                          Text('Machine Type: ${calibration.machineType}'),
                        ],
                      ),
                    ),
                  ),
*
* */