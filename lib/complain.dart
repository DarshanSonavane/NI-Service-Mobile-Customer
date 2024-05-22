import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ni_service/trackComplaint.dart';
import 'package:ni_service/widgets/SharedPreferencesManager.dart';
import 'package:intl/intl.dart';
import 'feedbackDialog.dart';
import 'http_service/services.dart';
import 'model/dataComplaintTrack.dart';
import 'model/responseGetServiceRequestList.dart';

class ComplainRequestList extends StatefulWidget {
  final String title;

  const ComplainRequestList({Key? key, required this.title}) : super(key: key);

  @override
  State<ComplainRequestList> createState() => _ComplainRequestListState();
}

class _ComplainRequestListState extends State<ComplainRequestList> {
  bool _isLoading = false;
  final sharedPreferences = SharedPreferencesManager.instance;
  List<DataComplaintsList>? dataComplainList;

  @override
  void initState() {
    super.initState();
    _fetchComplaints();
  }

  void ratingsCallback(String status) {
    if (status == "200") {
      _fetchComplaints();
    }
  }

  Future<void> _fetchComplaints() async {
    setState(() {
      _isLoading = true;
    });
    String? customerId = sharedPreferences?.getString("CustomerId");
    final responseGetServiceRequestList = await fetchComplaints(customerId!);
    if (responseGetServiceRequestList.code == "200" &&
        responseGetServiceRequestList.data != null) {
      dataComplainList = responseGetServiceRequestList.data;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseGetServiceRequestList.message!)));
    }

    setState(() {
      _isLoading = false; // Data is fetched, set loading to false
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
          child: dataComplainList == null || dataComplainList!.isEmpty
              ? const Center(
                  child: Text(
                    'You have not raised any complaints yet',
                    style: TextStyle(fontSize: 20.0),
                  ),
                )
              : ListView.builder(
                  itemCount: _isLoading ? 1 : dataComplainList?.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (_isLoading) {
                      return const SizedBox.shrink();
                    }
                    final reversedIndex = dataComplainList!.length - index - 1;
                    final complaint = dataComplainList![reversedIndex];
                    return Card(
                      elevation: 10,
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildRow("Complaint Id", complaint.sId!),
                            const SizedBox(height: 10),
                            buildRow("Date of Complaint",
                                getDate(complaint.createdAt!)),
                            const SizedBox(height: 10),
                            buildRowStatus(
                                "Status", getStatusDisplay(complaint.status!)),
                            const SizedBox(height: 10),
                            buildRow("Complaint Type",
                                complaint.complaintType!.name!),
                            const SizedBox(height: 10),
                            buildRow(
                                "Machine Type",
                                (complaint.machineType! == "1")
                                    ? "Diesel"
                                    : "Petrol"),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        openTrackComplaint(
                                            context, complaint.sId!);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green.shade700,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                      ),
                                      child: const Text('Track',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 4.0),
                                    child: ElevatedButton(
                                      onPressed:
                                          checkButtonVisibility(complaint)
                                              ? () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return FeedbackDialog(
                                                          complaint, _isLoading,
                                                          callback:
                                                              ratingsCallback);
                                                    },
                                                  );
                                                }
                                              : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade700,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 5.0),
                                        // Adjust padding
                                        child: Text('Feedback',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    18.0)), // Adjust font size
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  //108692
  Widget buildRowStatus(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label : ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            )),
        Expanded(
            child: Text(value,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                style: TextStyle(
                    color: value == "Open" ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label : ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            )),
        Expanded(
            child: Text(value, overflow: TextOverflow.ellipsis, maxLines: 4)),
      ],
    );
  }

  String getDate(String timeString) {
    String dateString = timeString;
    DateTime dateTime = DateTime.parse(dateString);

    int day = dateTime.day;
    String month =
        DateFormat.MMM().format(dateTime); // Get month in "Aug" format
    int year = dateTime.year;
    return "$day-$month-$year";
  }

  String getStatus(String status) {
    return (status == "1") ? "Open" : "Closed";
  }

  checkButtonVisibility(DataComplaintsList complaint) {
    if (complaint.status! == "1") {
      return false;
    } else if (complaint.status! == "0" &&
        complaint.ratings != null &&
        complaint.ratings.toString().isNotEmpty) {
      return false;
    } else if (complaint.status! == "0" && complaint.ratings == null) {
      return true;
    }
    return false;
  }

  void openTrackComplaint(BuildContext context, String complaintId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TrackComplaint(complaintID: complaintId)));
  }

  String getStatusDisplay(String status) {
    switch (status) {
      case "1":
        return "Open";
      case "0":
        return "Closed";
      case "2":
        return "In-Process";
      default:
        return "";
    }
  }
}
