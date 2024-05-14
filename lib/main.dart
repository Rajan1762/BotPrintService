import 'dart:convert';
import 'dart:io';

import 'package:dummy/colors.dart';
import 'package:dummy/common_values.dart';
import 'package:dummy/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'background_service_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // startForegroundService();
  await readData();
  runApp(const MyApp());
}

void startForegroundService() async {
  const platform = MethodChannel('foreground_service');
  try {
    await platform.invokeMethod('startForegroundService');
  } on PlatformException catch (e) {
    print("Failed to start foreground service: '${e.message}'.");
  }
}

Future readData() async
{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  ipAddress = prefs.getString('ip') ?? '';
  portNumber = prefs.getInt('port') ?? 0;
  print('ipAddress = $ipAddress ,portNumber = $portNumber');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: appThemeColor,
          foregroundColor: Colors.white
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
