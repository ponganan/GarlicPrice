import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:garlic_price/model/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: messengerKey,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        fontFamily: 'NotoSansThai',
      ),
      home: const MainPage(),
    );
  }
}
