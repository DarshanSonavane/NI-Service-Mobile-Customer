import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ni_service/model/RequestCustomerDetailsModel.dart';
import 'package:ni_service/widgets/shared_preference_manager.dart';

import '../http_service/services.dart';
import 'login_screen.dart';

class CustomDialogForMobileGSTAndEmail extends StatefulWidget {
  final String customerId;
  final Function(String) callback;

  const CustomDialogForMobileGSTAndEmail(this.customerId,
      {Key? key, required this.callback})
      : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialogForMobileGSTAndEmail> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController gstController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final sharedPreferences = SharedPreferencesManager.instance;

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Enter Details'),
          IconButton(
            icon: const Icon(Icons.logout,
                color: Colors.green), // You can change the icon as needed
            onPressed: () {
              logoutButtonClick();
            },
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStyledTextFieldNormal(
            controller: emailController,
            labelText: 'Email ID*',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email';
              } else if (!_validateEmail(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          _buildStyledTextField(
            controller: mobileController,
            labelText: 'Mobile Number*',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a mobile number';
              } else if (!_validateMobile(value)) {
                return 'Mobile number must be 10 digits';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          _buildStyledTextFieldGST(
            controller: gstController,
            labelText: 'GST Number (Optional)',
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () async {
            // You can access the entered values using the controllers:
            String email = emailController.text;
            String mobile = mobileController.text;
            String gstNumber = gstController.text;
            if (email.isNotEmpty &&
                _validateEmail(email) &&
                mobile.isNotEmpty &&
                _validateMobile(mobile) &&
                widget.customerId.isNotEmpty) {
              RequestCustomerDetails requestCustomer = RequestCustomerDetails();
              requestCustomer.mobile = mobile;
              requestCustomer.email = email;
              requestCustomer.gstNo = gstNumber;
              requestCustomer.customerId = widget.customerId;
              final responseCustomerDetailsAPI =
                  await CustomerDetailsAPI(requestCustomer);
              if (responseCustomerDetailsAPI.code == "200") {
                sharedPreferences?.setString("MOBILE", mobile);
                sharedPreferences?.setString("EMAIL", email);
                Navigator.of(context).pop();
                widget.callback("200");
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text(responseCustomerDetailsAPI.message.toString())));
              }
            } else {
              if (email.isNotEmpty &&
                  mobile.isNotEmpty &&
                  widget.customerId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Something went wrong Please try again!!")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please enter required Field")));
              }
            }
          },
          child: const Text('OK'),
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
        inputFormatters: [
          LengthLimitingTextInputFormatter(10),
        ],
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildStyledTextFieldNormal({
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
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget _buildStyledTextFieldGST({
    required TextEditingController controller,
    required String labelText,
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
      ),
    );
  }

  bool _validateEmail(String email) {
    // Simple email regex pattern
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  bool _validateMobile(String mobile) {
    // Validate that the mobile number has exactly 10 digits and is numeric
    return mobile.length == 10 && int.tryParse(mobile) != null;
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
