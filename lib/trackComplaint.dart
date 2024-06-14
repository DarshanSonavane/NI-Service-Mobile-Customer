import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'http_service/services.dart';
import 'model/RequestTrackComplaint.dart';
import 'model/ResponseTrackComplaint.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class TrackComplaint extends StatefulWidget {
  final String complaintID;

  const TrackComplaint({Key? key, required this.complaintID}) : super(key: key);

  @override
  State<TrackComplaint> createState() => _TrackComplaintState();
}

class _TrackComplaintState extends State<TrackComplaint> {
  late Future<ResponseTrackComplaint> _futureStages;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _futureStages = fetchTrackComplaint(
        RequestTrackComplaint(complaintId: widget.complaintID));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Track your complaint',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<ResponseTrackComplaint>(
        future: _futureStages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!.data!.complaintHistory!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final stages = snapshot.data!.data;
            return _buildTimeline(stages!);
          }
        },
      ),
    );
  }

  Widget _buildTimeline(Data stages) {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                stages.complaint!.complaintType!.name ?? "",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: stages.complaintHistory!.length,
              itemBuilder: (context, index) {
                final stage = stages.complaintHistory![index];
                final isLastStage =
                    index == stages.complaintHistory!.length - 1;
                return TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.1,
                  isFirst: index == 0,
                  isLast: isLastStage,
                  indicatorStyle: IndicatorStyle(
                    width: 40,
                    color: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    iconStyle: IconStyle(
                      iconData: Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  beforeLineStyle: const LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  ),
                  endChild: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 8.0),
                    padding: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (stage.status == "2")
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Assigned to: ${stages.assignedDetails!.assignedTo!.firstName ?? ""} ${stages.assignedDetails!.assignedTo!.lastName}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text(
                                    'Contact Number: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _launchPhone(stages
                                        .assignedDetails!.assignedTo!.phone!),
                                    child: Text(
                                      stages.assignedDetails!.assignedTo!
                                              .phone ??
                                          "",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        else
                          Text(
                            'Status: ${getStatusText(stage.status!)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        const SizedBox(height: 5),
                        Text(
                          getFormattedDate(stage.createdAt!, stage.status!),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case "1":
        return "Raised on";
      case "2":
        return "Assigned on";
      case "0":
        return "Closed on";
      default:
        return "";
    }
  }

  String getFormattedDate(String createdAt, String status) {
    DateTime dateTime = DateTime.parse(createdAt).toUtc();
    final istTimeZone = tz.getLocation('Asia/Kolkata');
    final istDateTime = tz.TZDateTime.from(dateTime, istTimeZone);
    String formattedDate =
        DateFormat('dd MMM yyyy, hh:mm a').format(istDateTime);
    return '${_getStatusText(status)} $formattedDate';
  }

  String getStatusText(String status) {
    switch (status) {
      case "0":
        return "Closed";
      case "1":
        return "Open";
      case "2":
        return "Assigned";
      default:
        return "";
    }
  }

  void _launchPhone(String phoneNumber) async {
    launchUrlString("tel://$phoneNumber");

  }
}
