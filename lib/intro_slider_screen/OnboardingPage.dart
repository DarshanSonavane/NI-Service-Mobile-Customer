import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:ni_service/Screens/login_screen.dart';

import '../Constants.dart';
import '../widgets/SharedPreferencesManager.dart';

class OnBoardingPage extends StatefulWidget {
  final bool isLoggedIn;

  const OnBoardingPage({super.key, required this.isLoggedIn});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final sharedPreferences = SharedPreferencesManager.instance;

  void _onIntroEnd(context) async {
    if (!widget.isLoggedIn) {
      await sharedPreferences?.setBool(ONBOARDINGCOMPLETED, true);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen(title: "Login")),
      );
    }
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      autoScrollDuration: 20000,
      infiniteAutoScroll: true,
      globalFooter: widget.isLoggedIn
          ? null
          : SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                child: const Text(
                  'Let\'s go right away!',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                onPressed: () => _onIntroEnd(context),
              ),
            ),
      pages: [
        PageViewModel(
          titleWidget: Container(),
          bodyWidget: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Login Screen",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildImage(
                        'img1.png', MediaQuery.of(context).size.width * 0.35),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    _buildImage(
                        'img2.png', MediaQuery.of(context).size.width * 0.35),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  INFOSCREENLOGIN,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                  textAlign: TextAlign.center,
                ),
                Text(
                  INFOSCREENLOGIN2,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ],
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Container(),
          bodyWidget: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Home Screen",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                _buildImage(
                    'img3.png', MediaQuery.of(context).size.width * 0.35),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  HOMESCREEN,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ],
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Container(),
          bodyWidget: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Navigation Drawer Screen",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildImage(
                        'img5.png', MediaQuery.of(context).size.width * 0.35),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    _buildImage(
                        'img4.png', MediaQuery.of(context).size.width * 0.35),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  NAVSCREEN,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ],
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Container(),
          bodyWidget: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Service Request Screen",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildImage('imgred1.png',
                        MediaQuery.of(context).size.width * 0.35),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    _buildImage(
                        'img6.png', MediaQuery.of(context).size.width * 0.35),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  SERVICEREQUESTSCREEN,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ],
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Container(),
          bodyWidget: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "My Complaint Screen",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildImage('imgred2.png',
                        MediaQuery.of(context).size.width * 0.35),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    _buildImage(
                        'img7.png', MediaQuery.of(context).size.width * 0.35),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  MYCOMPLAINT,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ],
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Container(),
          bodyWidget: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Calibration Screen",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildImage('imgred3.png',
                        MediaQuery.of(context).size.width * 0.35),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    _buildImage(
                        'img8.png', MediaQuery.of(context).size.width * 0.35),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  CALIBRATION,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ],
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
            titleWidget: Container(),
            bodyWidget: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Calibration List Screen",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  _buildImage(
                      'img9.png', MediaQuery.of(context).size.width * 0.35),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text(
                    CALIBRATIONLIST,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ],
              ),
            ),
            reverse: true,
            decoration: pageDecoration),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      // You can override onSkip callback
      showSkipButton: !widget.isLoggedIn,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      showDoneButton: true,
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
