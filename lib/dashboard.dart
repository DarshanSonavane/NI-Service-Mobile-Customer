import 'package:flutter/material.dart';
import 'package:ni_service/Constants.dart';
import 'package:ni_service/calibration_module/Calibration.dart';
import 'package:ni_service/complain.dart';
import 'package:ni_service/home.dart';
import 'package:ni_service/intro_slider_screen/OnboardingPage.dart';
import 'package:ni_service/service_request.dart';
import 'package:ni_service/widgets/SharedPreferencesManager.dart';

import 'calibration_module/TabbedCalibrationScreen.dart';
import 'login_screen.dart';

class Dashboard extends StatefulWidget {
  final String title;
  final String customerName;
  final String amcDue;
  final String? email_id;
  final String? mobile_num;
  final String? customer_id;

  const Dashboard(
      {Key? key,
      required this.title,
      required this.customerName,
      required this.amcDue,
      required this.email_id,
      required this.mobile_num,
      required this.customer_id})
      : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  late List<String> _titles;
  late List<Widget> _screens;
  bool isAmcDueValid = false;
  DateTime? amcDueDateTime; // Store amcDue as DateTime

  @override
  void initState() {
    _titles = ['Home', 'My Complaints', 'Service Request', 'Calibration','Help'];
    _screens = [
      Home(
        title: "Home",
        cus_Name: widget.customerName,
        email: widget.email_id,
        mobile: widget.mobile_num,
        customer_id: widget.customer_id,
      ),
      const ComplainRequestList(title: "My Complaints"),
      const ServiceRequest(title: "Raise Complaint"),
      const TabbedCalibrationScreen(title: "Calibration"),
      const OnBoardingPage(isLoggedIn: true,),
    ];

    checkAmcDueValidity();
    super.initState();
  }

  void checkAmcDueValidity() {
    final String amcDueString = widget.amcDue.toString();
    if (amcDueString.isNotEmpty) {
      try {
        final DateTime parsedAmcDue = DateTime.parse(amcDueString);
        setState(() {
          amcDueDateTime = parsedAmcDue;
          isAmcDueValid = amcDueDateTime!.isAfter(DateTime.now());
        });
      } catch (e) {
        print('Error parsing amcDue: $e');
      }
    }
  }

  void toggleButtonCallback(bool value) {
    //Click Unfocusable
  }

  void _showAmcDueAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("AMC Due Alert"),
          content: const Text(
              "You are not under AMC. Renew your AMC now or contact the system admin."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text(
          _titles[_currentIndex],
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(builder: (_context) {
          return IconButton(
            icon: const Icon(
              Icons.menu_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              if (isAmcDueValid) {
                Scaffold.of(_context).openDrawer();
              } else {
                _showAmcDueAlertDialog();
              }
            },
          );
        }),
        actions: [
          Switch(
            value: isAmcDueValid,
            onChanged: isAmcDueValid ? toggleButtonCallback : null,
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              logoutButtonClick();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.lightGreen,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/nilogo.png',
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text(
                      'Home',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      _navigateToScreen(0);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.feedback),
                    title: const Text(
                      'My Complaints',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      _navigateToScreen(1);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.design_services),
                    title: const Text(
                      'Service Request',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      _navigateToScreen(2);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.compass_calibration),
                    title: const Text(
                      'Calibration',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      _navigateToScreen(3);
                    },
                  ),
                  const Divider(),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text(
                'Help',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                _navigateToScreen(4);
              },
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex],
    );
  }

  void _navigateToScreen(int index) {
    setState(() {
      _currentIndex = index;
      Navigator.pop(context); // Close the drawer
    });
  }

  void logoutButtonClick() async {
    await clearExcept(ONBOARDINGCOMPLETED);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const LoginScreen(title: "Login")));
  }
}
