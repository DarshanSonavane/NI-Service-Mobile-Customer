import 'package:flutter/material.dart';

class DropDownWidget extends StatefulWidget {
  final Function(String)
      onValueChanged; // Callback function to pass the selected value
  List<String> listValue = [];
  String hintText;

  DropDownWidget(
      {Key? key,
      required this.onValueChanged,
      required this.listValue,
      required this.hintText})
      : super(key: key);

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  late String _selectedOption;

  @override
  void initState() {
    _selectedOption = widget.listValue[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38, width: 1.5),
        // Add a border to the container
        borderRadius:
            BorderRadius.circular(8.0), // Optionally, add border radius
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedOption,
          hint: Text(
            widget.hintText,
            style: const TextStyle(fontSize: 18.0),
          ),
          onChanged: (newValue) {
            setState(() {
              _selectedOption = newValue!;
            });
            widget.onValueChanged(_selectedOption);
          },
          items: widget.listValue.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              key: Key(option),
              child: Text(option,
                  style: const TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.w500)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
