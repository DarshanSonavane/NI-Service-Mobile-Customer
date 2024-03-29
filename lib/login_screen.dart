import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ni_service/passwordSetModal.dart';
import 'package:ni_service/dashboard.dart';
import 'package:ni_service/model/requestLogin.dart';
import 'package:ni_service/widgets/SharedPreferencesManager.dart';
import 'http_service/services.dart';
import 'model/responseLogin.dart';

class LoginScreen extends StatefulWidget {
  final String title;

  const LoginScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController customerCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  BuildContext? _storedContext;
  bool passwordVisible = false;
  final sharedPreferences = SharedPreferencesManager.instance;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/images/nilogo.png',
                  width: 250,
                  height: 250,
                ),
              ),
              const Text(
                "Customer Code",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                    color: Colors.lightGreen),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 18.0, horizontal: 18.0),
                child: TextField(
                  style: TextStyle(fontSize: 20.0),
                  controller: customerCodeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Customer Code',
                    labelStyle: const TextStyle(fontSize: 20),
                    hintText: 'Enter your Customer code',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 18.0),
                child: TextField(
                  style: TextStyle(fontSize: 20.0),
                  controller: passwordController,
                  obscureText: passwordVisible,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(fontSize: 20),
                    hintText: 'Enter your Password',
                    prefixIcon: const Icon(Icons.password),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const passwordSetModal();
                          /*return AlertDialog(
                            title: const Text('Set/Reset your Password'),
                            content: const Text(
                                'Please contact Admin for your customer code'),
                            actions: <Widget>[
                              // Close button
                              TextButton(
                                child: const Text('CLOSE'),
                                onPressed: () {
                                  // Close the popup
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );*/
                        },
                      );
                    },
                    child: const Text(
                      'Set/Reset your Password',
                      style: TextStyle(
                          decoration: TextDecoration.underline, fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0), // Add spacing below the text button
              ElevatedButton(
                onPressed: () {
                  _storedContext = context;
                  onLoginClick();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
                  // Adjust padding
                  child: Text('Login',
                      style: TextStyle(fontSize: 18.0)), // Adjust font size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onLoginClick() async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (customerCodeController.text.isNotEmpty) {
        requestLogin requestlogin = requestLogin();
        requestlogin.id = customerCodeController.text.toString();
        requestlogin.type = "0";
        responseLogin res = await loginAPI(requestlogin);
        if (res.code == "200") {
          if (_storedContext != null) {
            String? email = res.data![0].email;
            String? mobile = res.data![0].mobile;
            sharedPreferences?.setString(
                "CustomerId",
                res.data![0].sId != null && res.data![0].sId!.isNotEmpty
                    ? res.data![0].sId!
                    : "");
            sharedPreferences?.setString(
                "CustomerName",
                res.data![0].customerName != null &&
                        res.data![0].customerName!.isNotEmpty
                    ? res.data![0].customerName!
                    : "");
            sharedPreferences?.setString(
                "AMCDUE",
                res.data![0].amcDue != null && res.data![0].amcDue!.isNotEmpty
                    ? res.data![0].amcDue!
                    : "");
            sharedPreferences?.setString("MOBILE", mobile ?? "");
            sharedPreferences?.setString("EMAIL", email ?? "");
            String cus_Name = res.data![0].customerName != null
                ? res.data![0].customerName!
                : "";
            String amc_due =
                res.data![0].amcDue != null ? res.data![0].amcDue! : "";
            String customerId =
                res.data![0].sId != null ? res.data![0].sId! : "";

            Navigator.pushReplacement(
                _storedContext!,
                MaterialPageRoute(
                    builder: (storedContext) => Dashboard(
                          title: "Home",
                          customerName: cus_Name,
                          amcDue: amc_due,
                          email_id: email,
                          mobile_num: mobile,
                          customer_id: customerId,
                        )));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Invalid Customer Code")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please Enter Customer Code")));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      if (kDebugMode) {
        print("Hello");
      }
      setState(() {
        _isLoading = false;
      });
    }
  }
}

//Hello Abhishek
