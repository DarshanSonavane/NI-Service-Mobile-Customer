import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ni_service/Screens/password_set_modal.dart';
import 'package:ni_service/Screens/dashboard.dart';
import 'package:ni_service/model/requestLogin.dart';
import 'package:ni_service/widgets/shared_preference_manager.dart';
import 'package:ni_service/widgets/imageprogressindicator.dart';
import 'package:searchfield/searchfield.dart';
import '../http_service/services.dart';
import '../model/response_login.dart';

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
  final sharedPreferences = SharedPreferencesManager.instance;
  bool _isLoading = false;
  bool passwordVisible = false;
  List<String> _usernames = [];
  List<String> _filteredUsernames = [];

  @override
  void initState() {
    super.initState();
    _loadUsernames().then((usernames) {
      setState(() {
        _usernames = usernames!;
        _filteredUsernames = usernames;
      });
    });
  }

  @override
  void dispose() {
    customerCodeController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<SearchFieldListItem<String>> convertToSearchFieldList(
        List<String> filteredUsernames) {
      return filteredUsernames
          .map((String username) => SearchFieldListItem<String>(username))
          .toList();
    }

    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: const Imageprogressindicator(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 150),
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/nilogo.png',
                    width: 120,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.title,
                  style: const TextStyle(
                      color: Colors.lightGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 28.5),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey), // Add border
                          borderRadius: BorderRadius.circular(12.0),
                          // Optional: Adjust border radius
                        ),
                        child: SearchField(
                            suggestionStyle: const TextStyle(fontSize: 25.0),
                            searchInputDecoration: const InputDecoration(
                              labelText: "Customer Code",
                              border: InputBorder.none,
                              labelStyle: TextStyle(fontSize: 20),
                              prefixIcon: Icon(Icons.person),
                            ),
                            suggestions:
                                convertToSearchFieldList(_filteredUsernames),
                            hint: 'Enter your Customer code',
                            itemHeight: 60,
                            onSubmit: (value) {
                              setState(() {
                                customerCodeController.text = value;
                              });
                            },
                            onSearchTextChanged: (value) {
                              setState(() {
                                customerCodeController.text = value;

                                // Filter suggestions based on the search input
                                _filteredUsernames = _usernames
                                    .where((username) => username
                                        .toLowerCase()
                                        .startsWith(value.toLowerCase()))
                                    .toList();
                              });

                              return null;
                            },
                            onSuggestionTap: (value) {
                              setState(() {
                                customerCodeController.text = value.searchKey;
                              });
                              FocusScope.of(context).unfocus();
                            }),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 18.0),
                  child: TextField(
                    style: const TextStyle(fontSize: 20.0),
                    controller: passwordController,
                    obscureText: !passwordVisible,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(fontSize: 20),
                      hintText: 'Enter your Password',
                      prefixIcon: const Icon(Icons.password),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            passwordVisible =
                                !passwordVisible; // Toggle password visibility
                          });
                        },
                      ),
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
                const SizedBox(
                    height: 16.0), // Add spacing below the text button
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
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white)), // Adjust font size
                  ),
                ),
              ],
            ),
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
      if (customerCodeController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        requestLogin requestlogin = requestLogin();
        requestlogin.id = customerCodeController.text.toString();
        requestlogin.type = "0";
        requestlogin.password = passwordController.text.toString();
        ResponseLogin res = await loginAPI(requestlogin);

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
                "CustomerCode",
                res.data![0].customerCode != null &&
                        res.data![0].customerCode!.isNotEmpty
                    ? res.data![0].customerCode!
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
            sharedPreferences?.setString(
                "LocationCity",
                res.data![0].city != null && res.data![0].city!.isNotEmpty
                    ? res.data![0].city!
                    : "");
            sharedPreferences?.setString(
                "LocationState",
                res.data![0].stateCode != null &&
                        res.data![0].stateCode!.isNotEmpty
                    ? res.data![0].stateCode!
                    : "");
            sharedPreferences?.setString(
                "GSTNUMBER",
                res.data![0].gstNo != null && res.data![0].gstNo!.isNotEmpty
                    ? res.data![0].gstNo!
                    : "");

            sharedPreferences?.setString("MOBILE", mobile ?? "");
            sharedPreferences?.setString("EMAIL", email ?? "");
            String cusName = res.data![0].customerName != null
                ? res.data![0].customerName!
                : "";
            String amcDue =
                res.data![0].amcDue != null ? res.data![0].amcDue! : "";
            String customerId =
                res.data![0].sId != null ? res.data![0].sId! : "";

            // Convert machine details to JSON and store it in SharedPreferences
            if (res.machineDetails != null && res.machineDetails!.isNotEmpty) {
              String machineDetailsJson = jsonEncode(
                  res.machineDetails!.map((e) => e.toJson()).toList());
              sharedPreferences?.setString(
                  "MachineDetails", machineDetailsJson);
            }
            _saveUsername(customerCodeController.text.toString());

            Navigator.pushReplacement(
                _storedContext!,
                MaterialPageRoute(
                    builder: (storedContext) => Dashboard(
                          title: "Home",
                          customerName: cusName,
                          amcDue: amcDue,
                          emailid: email,
                          mobilenum: mobile,
                          customerid: customerId,
                        )));
          }
        } else {
          passwordController.text = "";
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text("Something went wrong, please try after sometime")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter required fields")));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

Future<void> _saveUsername(String userName) async {
  var box = await Hive.openBox<List<String>>('userBox');
  List<String>? usernames = box.get('usernames', defaultValue: <String>[]);
  if (!usernames!.contains(userName)) {
    usernames.add(userName);
    await box.put('usernames', usernames);
  }
  await box.close();
}

Future<List<String>?> _loadUsernames() async {
  var box = await Hive.openBox<List<String>>('userBox');
  List<String>? usernames = box.get('usernames', defaultValue: <String>[]);
  await box.close();
  return usernames;
}
