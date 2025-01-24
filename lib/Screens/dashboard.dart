import 'package:flutter/material.dart';

import 'package:ni_service/Screens/customer_profile.dart';
import 'package:ni_service/Utils/Constants.dart';
import 'package:ni_service/Screens/NotificationDisplayScreen.dart';
import 'package:ni_service/Screens/complain.dart';
import 'package:ni_service/Screens/home.dart';
import 'package:ni_service/intro_slider_screen/OnboardingPage.dart';
import 'package:ni_service/Screens/service_request.dart';
import 'package:ni_service/model/checkAmcDue/request_check_amc_due.dart';
import 'package:ni_service/model/checkAmcDue/response_check_amc_due.dart';
import 'package:ni_service/renew_amc_screen/amc_renew.dart';
import 'package:ni_service/widgets/shared_preference_manager.dart';
import '../calibration_module/TabbedCalibrationScreen.dart';
import '../http_service/firebase_api.dart';
import '../http_service/services.dart';
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
  String? amcDueString;
  DateTime? amcDueDateTime;
  final FirebaseApi _firebaseApi = FirebaseApi();
  final sharedPreferences = SharedPreferencesManager.instance;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    sendFCMNotificationDetails();
    await _checkAmcDueValidity();
  }

  void _initializeScreens() {
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
              _currentIndex = 4; // TabbedCalibrationScreen index
            });
          } else {
            _showAmcDueAlertDialog();
          }
        },
        amcDueString: amcDueString,
        onRenewAMCRequested: (differenceInDays) {
          _openAMCTypeScreen(context, differenceInDays);
        },
      ),
      const CustomerProfile(title: "Profile"),
      const ComplainRequestList(title: "My Complaints"),
      const ServiceRequest(title: "Raise Complaint"),
      const TabbedCalibrationScreen(title: "Calibration"),
      const OnBoardingPage(isLoggedIn: true),
    ];
  }

  void toggleButtonCallback(bool value) {
    //Click Unfocusable
  }

  Future<void> _checkAmcDueValidity() async {
    setState(() => isLoading = true);
    String? customerId = sharedPreferences?.getString(CUSTOMERID);
    if (customerId == null) {
      setState(() => isLoading = false);
      return;
    }

    final requestCheckAmcDue = RequestCheckAmcDue(customerId: customerId);
    final responseCheckAmcDue = await checkAmcDueDate(requestCheckAmcDue);

    if (responseCheckAmcDue.code == 200) {
      amcDueString = responseCheckAmcDue.data?.amcDue ?? "";
      sharedPreferences?.setString("AMCDUE", amcDueString!);

      if (amcDueString!.isNotEmpty) {
        try {
          final parsedAmcDue = DateTime.parse(amcDueString!);
          setState(() {
            amcDueDateTime = parsedAmcDue;
            isAmcDueValid = amcDueDateTime!.isAfter(DateTime.now());
            _screens[0] = Home(
              title: "Home",
              cusName: widget.customerName,
              email: widget.emailid,
              mobile: widget.mobilenum,
              customerId: widget.customerid,
              onCalibrationRequested: () {
                if (isAmcDueValid) {
                  setState(() {
                    _currentIndex = 4; // TabbedCalibrationScreen index
                  });
                } else {
                  _showAmcDueAlertDialog();
                }
              },
              amcDueString: amcDueString,
              onRenewAMCRequested: (differenceInDays) {
                _openAMCTypeScreen(context, differenceInDays);
              },
            );
            _currentIndex = 0;
          });
        } catch (e) {
          debugPrint("Error parsing amcDue: $e");
        }
      }
    }
    setState(() => isLoading = false);
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToScreen(int index) {
    Navigator.pop(context); // Close the drawer

    if (index == 0) {
      // Navigate to a new instance of the Dashboard to trigger initState
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(
            title: widget.title,
            customerName: widget.customerName,
            amcDue: widget.amcDue,
            emailid: widget.emailid,
            mobilenum: widget.mobilenum,
            customerid: widget.customerid,
          ),
        ),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _openAMCTypeScreen(BuildContext context, int differenceInDays) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AmcRenew(
          customerId: widget.customerid!,
          differenceInDays: differenceInDays,
        ),
      ),
    );
  }

  void _logoutButtonClick([String? message]) async {
    await clearExcept(ONBOARDINGCOMPLETED);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LoginScreen(title: "Login", showDialogOnRenewAMC: message),
      ),
    );
  }

  void sendFCMNotificationDetails() {
    _firebaseApi.initNotifications(context);
  }

  void _notificationIconClick() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const Notificationdisplayscreen(title: "Notification"),
      ),
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
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu_outlined, color: Colors.white),
              onPressed: () {
                if (isAmcDueValid) {
                  Scaffold.of(context).openDrawer();
                } else {
                  _showAmcDueAlertDialog();
                }
              },
            );
          },
        ),
        actions: [
          isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  ),
                )
              : !isAmcDueValid
                  ? IconButton(
                      icon: const Icon(Icons.refresh,
                          color: Colors.white, size: 30),
                      onPressed: _checkAmcDueValidity,
                    )
                  : const SizedBox(),
          Switch(
            value: isAmcDueValid,
            onChanged: isAmcDueValid ? toggleButtonCallback : null,
          ),
          IconButton(
            icon:
                const Icon(Icons.notifications, color: Colors.white, size: 30),
            onPressed: _notificationIconClick,
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logoutButtonClick,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightGreen, Colors.green.shade200],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Image.asset('assets/images/niservice.gif'),
                  ),
                ),
              ),
            ),
            _buildDrawerItem(Icons.home, "Home", 0),
            _buildDrawerItem(Icons.person, "Profile", 1),
            _buildDrawerItem(Icons.feedback, "My Complaints", 2),
            _buildDrawerItem(Icons.design_services, "Service Request", 3),
            _buildDrawerItem(Icons.compass_calibration, "Calibration", 4),
            _buildDrawerItem(Icons.help_outline, "Help", 5),
          ],
        ),
      ),
      body: _screens[_currentIndex],
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      onTap: () => _navigateToScreen(index),
    );
  }
}
