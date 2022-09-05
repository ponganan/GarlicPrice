import 'package:flutter/material.dart';

// have to add to main.dart also
// and add scaffoldMessengerKey: Utils.messengerKey, to  MaterialApp
//--****************** UPDATE ***************
// use this code
//scaffoldMessengerKey: messengerKey
//--*******************************************

final messengerKey = GlobalKey<ScaffoldMessengerState>();

class Utils {
  static showSnackBar(String? text) {
    if (text == null) return;
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
