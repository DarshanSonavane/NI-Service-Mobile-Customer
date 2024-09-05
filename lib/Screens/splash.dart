import 'package:flutter/material.dart';
import 'package:ni_service/Utils/Constants.dart';
import 'package:ni_service/Screens/dashboard.dart';
import 'package:ni_service/intro_slider_screen/OnboardingPage.dart';
import 'package:ni_service/Screens/login_screen.dart';
import 'package:ni_service/widgets/shared_preference_manager.dart';

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
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          image: AssetImage(
              'assets/images/niservice.gif'), // Replace with your GIF image path
          width: 300,
          height: 300,
        ),
      ),
    );
  }

  navigateToLoginScreen() async {
    try {
      bool onboardingCompleted =
          sharedPreferences?.getBool(ONBOARDINGCOMPLETED) ?? false;
      if (onboardingCompleted) {
        String? customerId = sharedPreferences?.getString(CUSTOMERID);
        String? cusName = sharedPreferences?.getString("CustomerName");
        String? amcDue = sharedPreferences?.getString("AMCDUE");
        String? mobilenum = sharedPreferences?.getString("MOBILE");
        String? emailid = sharedPreferences?.getString("EMAIL");
        if (customerId != null && customerId.isNotEmpty) {
          Future.delayed(const Duration(seconds: 5), () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Dashboard(
                        title: "Home",
                        customerName: cusName!,
                        amcDue: amcDue!,
                        emailid: emailid,
                        mobilenum: mobilenum,
                        customerid: customerId)));
          });
        } else {
          Future.delayed(const Duration(seconds: 5), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(title: "Login"),
              ),
            );
          });
        }
      } else {
        Future.delayed(const Duration(seconds: 10), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const OnBoardingPage(
                      isLoggedIn: false,
                    )),
          );
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
