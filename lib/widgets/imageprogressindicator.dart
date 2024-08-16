import 'package:flutter/material.dart';

class Imageprogressindicator extends StatelessWidget {
  const Imageprogressindicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/loader.gif',
      width: 100,
      height: 100,
    );
  }
}
