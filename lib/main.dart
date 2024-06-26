import 'package:flutter/material.dart';
import 'package:ni_service/splash.dart';
import 'package:ni_service/widgets/SharedPreferencesManager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NI Service',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
