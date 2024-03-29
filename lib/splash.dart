import 'package:flutter/material.dart';
import 'package:ni_service/dashboard.dart';
import 'package:ni_service/login_screen.dart';
import 'package:ni_service/widgets/SharedPreferencesManager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final sharedPreferences = SharedPreferencesManager.instance;

  @override
  void initState() {
    navigateToLoginScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/nilogo.png', // Replace with your image path
          width: 300,
          height: 300,
        ),
      ),
    );
  }

  navigateToLoginScreen() async {
    try{
      String? customerId = sharedPreferences?.getString("CustomerId");
      String? cusName = sharedPreferences?.getString("CustomerName");
      String? amc_Due = sharedPreferences?.getString("AMCDUE");
      String? mobile_num = sharedPreferences?.getString("MOBILE");
      String? email_id = sharedPreferences?.getString("EMAIL");
      if (customerId != null && customerId.isNotEmpty) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Dashboard(title: "Home", customerName: cusName!, amcDue: amc_Due!,email_id: email_id,mobile_num: mobile_num,customer_id: customerId)));
        });

      } else {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const LoginScreen(title: "Login")));
        });

      }
    }catch(e){
      print(e.toString());
    }
  }
}
