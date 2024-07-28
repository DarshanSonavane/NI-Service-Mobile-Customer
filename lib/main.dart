import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ni_service/Screens/NotificationDisplayScreen.dart';
import 'package:ni_service/firebase_options.dart';
import 'package:ni_service/http_service/firebase_api.dart';
import 'package:ni_service/Screens/splash.dart';
import 'package:ni_service/widgets/SharedPreferencesManager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPreferencesManager.initialize();
  await Hive.initFlutter();
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'NI Service',
      routes: {
        Notificationdisplayscreen.routeName: (context) => const Notificationdisplayscreen(title: "Notification"),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
