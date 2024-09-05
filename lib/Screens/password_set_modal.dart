import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ni_service/model/RequestSetPassword.dart';

import '../http_service/services.dart';
import '../model/ResponseSetPassword.dart';

class passwordSetModal extends StatefulWidget {
  const passwordSetModal({super.key});

  @override
  State<passwordSetModal> createState() => _PasswordSetModalState();
}

class _PasswordSetModalState extends State<passwordSetModal> {
  final TextEditingController customCodeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  var _passwordVisible, _confirmPasswordVisible;
  bool _isLoading = false;

  @override
  void initState() {
    _passwordVisible = false;
    _confirmPasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Set Password'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStyledTextField(
              controller: customCodeController,
              labelText: 'Customer Code*',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Customer Code';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            _buildStyledTextFieldPassword(
              controller: passwordController,
              labelText: 'Password*',
              passwordVisibleTest: _passwordVisible,
              togglePasswordVisibility: _togglePasswordVisibility,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Password';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            _buildStyledTextFieldPassword(
              controller: confirmPasswordController,
              labelText: 'Re-enter Password*',
              passwordVisibleTest: _confirmPasswordVisible,
              togglePasswordVisibility: _toggleConfirmPasswordVisibility,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a Confirm Password';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Note:-Password to have at least 8 characters, "
              "at least one uppercase letter, at least one lowercase letter,"
              " at least one digit, and at least one special character.",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
              backgroundColor:
                  WidgetStateColor.resolveWith((states) => Colors.red)),
          child: const Text(
            'Close',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                WidgetStateColor.resolveWith((states) => Colors.green),
          ),
          onPressed: () async {
            String etCustomercode = customCodeController.text;
            String etPassword = passwordController.text;
            String etConfirmpassword = confirmPasswordController.text;

            if (etCustomercode.isEmpty ||
                etPassword.isEmpty ||
                etConfirmpassword.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Please enter all required fields")),
              );
              return;
            }

            if (!validatePassword(etPassword)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please Enter a Valid Password")),
              );
              return;
            }

            if (!isPasswordMatch(etPassword, etConfirmpassword)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Password and Confirm Password should match"),
                ),
              );
              return;
            }

            // All validations passed, proceed with your logic
            setorResetPassword(context);
          },
          child: const Text(
            'Submit',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.grey, // Border color
          width: 1.0, // Border width
        ),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding: const EdgeInsets.all(16.0),
          border: InputBorder.none, // Remove the default border
        ),
        validator: validator,
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildStyledTextFieldPassword({
    required TextEditingController controller,
    required String labelText,
    required passwordVisibleTest,
    required void Function(bool visible) togglePasswordVisibility,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.grey, // Border color
          width: 1.0, // Border width
        ),
      ),
      child: TextFormField(
        obscureText: !passwordVisibleTest,
        controller: controller,
        decoration: InputDecoration(
            labelText: labelText,
            contentPadding: const EdgeInsets.all(16.0),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark),
              onPressed: () {
                setState(() {
                  togglePasswordVisibility(!passwordVisibleTest);
                });
              },
            ) // Remove the default border
            ),
        validator: validator,
        keyboardType: TextInputType.text,
      ),
    );
  }

  bool validatePassword(String password) {
    // Password regex patter
    final passwordRegex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  bool isPasswordMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  void _togglePasswordVisibility(bool visible) {
    setState(() {
      _passwordVisible = visible;
    });
  }

  void _toggleConfirmPasswordVisibility(bool visible) {
    setState(() {
      _confirmPasswordVisible = visible;
    });
  }

  setorResetPassword(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (customCodeController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty) {
        RequestSetPassword requestSetPassword = RequestSetPassword();
        requestSetPassword.customerCode = customCodeController.text.toString();
        requestSetPassword.password = passwordController.text.toString();
        final scaffoldContext = context;
        ResponseSetPassword res = await setPasswordAPI(requestSetPassword);
        if (res.code == "200") {
          String message = res.message ?? "Password set successfully";
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
          Navigator.of(scaffoldContext).pop();
        }
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
