import 'package:flutter/material.dart';
import 'Calibration.dart';
import 'CalibrationListScreen.dart';

class TabbedCalibrationScreen extends StatelessWidget {
  final String title;

  const TabbedCalibrationScreen({Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Colors.grey.shade300, // Change the background color of the app bar
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  const TabBar(
                    indicatorColor: Colors.red,
                    // Change the indicator color
                    labelColor: Colors.red,
                    // Change the label text color
                    unselectedLabelColor: Colors.black,
                    // Change the unselected label text color
                    tabs: [
                      Tab(text: 'Request Calibration'),
                      Tab(text: 'Calibration List'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            Calibration(title: 'Request Calibration'),
            CalibrationListScreen(title: 'Calibration List')

          ],
        ),
      ),
    );
  }
}
