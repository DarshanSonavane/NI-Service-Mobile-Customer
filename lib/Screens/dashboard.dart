import 'package:flutter/material.dart';
import 'package:ni_service/Screens/customer_profile.dart';
import 'package:ni_service/Utils/Constants.dart';
import 'package:ni_service/Screens/NotificationDisplayScreen.dart';
import 'package:ni_service/Screens/complain.dart';
import 'package:ni_service/Screens/home.dart';
import 'package:ni_service/intro_slider_screen/OnboardingPage.dart';
import 'package:ni_service/Screens/service_request.dart';
import 'package:ni_service/widgets/shared_preference_manager.dart';

import '../calibration_module/TabbedCalibrationScreen.dart';
import '../http_service/firebase_api.dart';
import 'login_screen.dart';

class Dashboard extends StatefulWidget {
  final String title;
  final String customerName;
  final String amcDue;
  final String? emailid;
  final String? mobilenum;
  final String? customerid;

  const Dashboard(
      {Key? key,
      required this.title,
      required this.customerName,
      required this.amcDue,
      required this.emailid,
      required this.mobilenum,
      required this.customerid})
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
  final FirebaseApi _firebaseApi = FirebaseApi();

  @override
  void initState() {
    sendFCMNotificationDetails();
    checkAmcDueValidity();
    _titles = [
      'Home',
      'Profile',
      'My Complaints',
      'Service Request',
      'Calibration',
      'Help'
    ];
    _screens = [
      Home(
        title: "Home",
        cusName: widget.customerName,
        email: widget.emailid,
        mobile: widget.mobilenum,
        customerId: widget.customerid,
        onCalibrationRequested: () {
          if (isAmcDueValid) {
            setState(() {
              _currentIndex = 4; // Index for TabbedCalibrationScreen
            });
          } else {
            _showAmcDueAlertDialog();
          }
        },
      ),
      const CustomerProfile(title: "Profile"),
      const ComplainRequestList(title: "My Complaints"),
      const ServiceRequest(title: "Raise Complaint"),
      const TabbedCalibrationScreen(title: "Calibration"),
      const OnBoardingPage(
        isLoggedIn: true,
      ),
    ];

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
        throw ('Error parsing amcDue: $e');
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
          style: const TextStyle(color: Colors.white),
        ),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(
              Icons.menu_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              if (isAmcDueValid) {
                Scaffold.of(context).openDrawer();
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
              Icons.notifications,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              notificationIconClick();
            },
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
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.lightGreen, Colors.green.shade200],
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 6,
                              blurRadius: 10,
                              offset: const Offset(0, 9),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Image.asset(
                              'assets/images/niservice.gif',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text(
                      'Home',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      _navigateToScreen(0);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.man),
                    title: const Text(
                      'Profile',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      _navigateToScreen(1);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.feedback),
                    title: const Text(
                      'My Complaints',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      _navigateToScreen(2);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.design_services),
                    title: const Text(
                      'Service Request',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      _navigateToScreen(3);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.compass_calibration),
                    title: const Text(
                      'Calibration',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      _navigateToScreen(4);
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
                _navigateToScreen(5);
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

  void notificationIconClick() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const Notificationdisplayscreen(title: "Notification")));
  }

  void sendFCMNotificationDetails() {
    _firebaseApi.initNotifications(context);
  }
}
