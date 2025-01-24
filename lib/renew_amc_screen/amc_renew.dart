import 'package:flutter/material.dart';

import '../Utils/show_snackbar.dart';
import '../http_service/services.dart';
import '../model/renew_amc/request_renew_amc.dart';
import '../model/renew_amc/response_renew_amc.dart';

class AmcRenew extends StatefulWidget {
  final String customerId;
  final int differenceInDays;

  const AmcRenew({
    Key? key,
    required this.customerId,
    required this.differenceInDays,
  }) : super(key: key);

  @override
  State<AmcRenew> createState() => _AmcRenewScreenState();
}

class _AmcRenewScreenState extends State<AmcRenew> {
  int? selectedValue;
  bool isLoading = false;

  void fetchFuelValue(int value) {
    String fuelType = "";
    switch (value) {
      case 0:
        fuelType = "0";
        break;
      case 1:
        fuelType = "1";
        break;
      case 2:
        fuelType = "2";
        break;
    }
    sendRenewAMCRequestService(fuelType);
  }

  Future<void> sendRenewAMCRequestService(String fuelType) async {
    try {
      setState(() {
        isLoading = true;
      });
      RequestRenewAMC requestRenewAMC = RequestRenewAMC();
      requestRenewAMC.customerId = widget.customerId;
      requestRenewAMC.amcType = fuelType;
      ResponseRenewAMC responseRenewAMC =
          await sendRenewAMCRequest(requestRenewAMC);

      if (responseRenewAMC.code == 200) {
        showSnackBar(context, responseRenewAMC.message!);
      } else {
        showSnackBar(context, responseRenewAMC.message!);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    } finally {
      setState(() {
        isLoading = false;
        selectedValue = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text(
          "Rewnew AMC",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Card(
                margin: const EdgeInsets.all(16.0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: setAMCHeaderText(widget.differenceInDays),
                      ),
                      const SizedBox(height: 20),
                      RadioListTile<int>(
                        title: const Text(
                          "Petrol",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        value: 0,
                        groupValue: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                      ),
                      RadioListTile<int>(
                        title: const Text(
                          "Diesel",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        value: 1,
                        groupValue: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                      ),
                      RadioListTile<int>(
                        title: const Text(
                          "Combo",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        value: 2,
                        groupValue: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel",
                                style: TextStyle(fontSize: 18)),
                          ),
                          ElevatedButton(
                            onPressed: selectedValue == null
                                ? null
                                : () => fetchFuelValue(selectedValue!),
                            child: const Text("OK",
                                style: TextStyle(fontSize: 18)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Text setAMCHeaderText(int differenceInDays) {
    if (differenceInDays <= 0) {
      return const Text(
        "Your AMC has expired, Please select the fuel type to renew",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      );
    } else {
      return Text(
        "Your AMC will expire in $differenceInDays days, Please select the fuel type to renew",
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      );
    }
  }
}
