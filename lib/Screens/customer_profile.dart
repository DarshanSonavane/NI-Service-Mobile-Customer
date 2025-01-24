import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ni_service/widgets/shared_preference_manager.dart';

class CustomerProfile extends StatelessWidget {
  const CustomerProfile({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    final sharedPreferences = SharedPreferencesManager.instance;

    String customerCode = sharedPreferences?.getString("CustomerCode") ?? "N/A";
    String cusName = sharedPreferences?.getString("CustomerName") ?? "N/A";
    String amcDue = sharedPreferences?.getString("AMCDUE") ?? "N/A";
    String mobilenum = sharedPreferences?.getString("MOBILE") ?? "N/A";
    String emailid = sharedPreferences?.getString("EMAIL") ?? "N/A";
    String gstNumber = sharedPreferences?.getString("GSTNUMBER") ?? "N/A";
    String city = sharedPreferences?.getString("LocationCity") ?? "N/A";
    String state = sharedPreferences?.getString("LocationState") ?? "N/A";
    String machineDetailsJson =
        sharedPreferences?.getString("MachineDetails") ?? "N/A";
    List<dynamic> machineDetailsData = jsonDecode(machineDetailsJson);
    List<MachineDetails> machineDetailsList = machineDetailsData
        .map((data) => MachineDetails.fromJson(data))
        .toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(cusName),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(Icons.confirmation_number, 'Customer Code',
                          customerCode),
                      _buildInfoRow(
                          Icons.location_city, 'Location', "$city, $state"),
                      _buildInfoRow(Icons.email, 'Email', emailid),
                      _buildInfoRow(Icons.phone, 'Mobile', mobilenum),
                      _buildInfoRow(
                          Icons.calendar_today, 'AMC Due Date', amcDue),
                      _buildInfoRow(Icons.business, 'GST No', gstNumber),
                      const SizedBox(height: 20),
                      // Heading for Machine Details
                      const Text(
                        'Machine Details',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      // Display Machine Details
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: machineDetailsList.length,
                        itemBuilder: (context, index) {
                          MachineDetails machine = machineDetailsList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow(Icons.build, 'Machine Model',
                                    machine.model ?? 'N/A'),
                                _buildInfoRow(Icons.numbers, 'Machine No',
                                    machine.machineno ?? 'N/A'),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String name) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.lightGreen,
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 191, 195, 74),
          Color.fromARGB(255, 89, 225, 255)
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Center(
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MachineDetails {
  String? sId;
  String? model;
  String? machineno;
  String? customercode;

  MachineDetails({this.sId, this.model, this.machineno, this.customercode});

  MachineDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    model = json['MODEL'];
    machineno = json['MACHINE_NO'];
    customercode = json['CUSTOMER_CODE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['MODEL'] = model;
    data['MACHINE_NO'] = machineno;
    data['CUSTOMER_CODE'] = customercode;
    return data;
  }
}
