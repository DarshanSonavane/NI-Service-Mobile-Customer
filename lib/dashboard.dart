import 'package:flutter/material.dart';
import 'package:ni_service/complain.dart';
import 'package:ni_service/home.dart';
import 'package:ni_service/service_request.dart';
import 'package:ni_service/widgets/SharedPreferencesManager.dart';

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
    _titles = ['Home', 'MY Complaints', 'Service Request'];
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
        title: Text(_titles[_currentIndex]),
        leading: Builder(builder: (_context) {
          return IconButton(
            icon: Icon(Icons.menu_outlined),
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
            icon: Icon(Icons.logout),
            onPressed: () {
              logoutButtonClick();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.lightGreen,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/nilogo.png',
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Home', style: TextStyle(fontSize: 20)),
              onTap: () {
                _navigateToScreen(0);
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              title:
                  const Text('My Complaints', style: TextStyle(fontSize: 20)),
              onTap: () {
                _navigateToScreen(1);
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              title:
                  const Text('Service Request', style: TextStyle(fontSize: 20)),
              onTap: () {
                _navigateToScreen(2);
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

  void logoutButtonClick() {
    final sharedPreferences = SharedPreferencesManager.instance;
    sharedPreferences?.clear();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const LoginScreen(title: "Login")));
  }
}
