import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:sajhabackup/Cart/cartmodel.dart';
import 'package:sajhabackup/Splashes/splashscreen.dart';
import 'package:sajhabackup/themes/themeprovider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyB22xWy99xjXerlI-c-sFvShkTrUlFs3nc',
              appId: '1:198996371343:android:508c7cd18165d39e404dfa',
              messagingSenderId: '198996371343',
              projectId: 'sajhabookstore',
              storageBucket: 'gs://sajhabookstore.appspot.com'))
      : await Firebase.initializeApp();
  runApp(Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartModel()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: splashscreen(),
    );
  }
}
