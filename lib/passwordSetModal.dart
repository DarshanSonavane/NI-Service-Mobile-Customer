import 'package:flutter/material.dart';

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

  @override
  void initState() {
    _passwordVisible = false;
    _confirmPasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Set Password'),
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
            SizedBox(height: 10),
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
            SizedBox(height: 10),
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
            SizedBox(height: 20),
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
          child: const Text(
            'Close',
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.red)),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateColor.resolveWith((states) => Colors.green),
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
            print("SUCCESS");
          },
          child: const Text(
            'Submit',
            style: TextStyle(color: Colors.white),
          ),
        ),

        /*ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.green)),
          onPressed: () async {
            // You can access the entered values using the controllers:
            String et_Customercode = customCodeController.text;
            String et_Password = passwordController.text;
            String et_ConfirmPassword = confirmPasswordController.text;
            if (et_Customercode.isNotEmpty &&
                et_Password.isNotEmpty &&
                validatePassword(et_Password) &&
                et_ConfirmPassword.isNotEmpty &&
                isPasswordMatch(et_Password, et_ConfirmPassword)) {
              print("SUCCESS");
            } else {
              if (et_Password.isNotEmpty && !validatePassword(et_Password)) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please Enter Valid Password")));
              } else if (et_ConfirmPassword.isNotEmpty &&
                  !isPasswordMatch(et_Password, et_ConfirmPassword)) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text("Confirm password and password should match")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please enter required Field")));
              }
            }
          },
          child: Text(
            'Submit',
            style: TextStyle(color: Colors.white),
          ),
        ),*/
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
          contentPadding: EdgeInsets.all(16.0),
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
            contentPadding: EdgeInsets.all(16.0),
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
    // Password regex pattern
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
}
