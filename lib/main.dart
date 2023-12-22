import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'home_page.dart';
import 'notifi_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  NotificationService().initNotification();
  tz.initializeTimeZones();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notifications',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Local Notifications'),
    );
  }
}
