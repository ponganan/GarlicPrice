import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListPrice extends StatefulWidget {
  const ListPrice({Key? key}) : super(key: key);

  @override
  State<ListPrice> createState() => _ListPriceState();
}

class _ListPriceState extends State<ListPrice> {
  // final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'ราคากระเทียมจีน',
          //style: TextStyle(color: Colors.blue),
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Text('สวัสดีคุณ.. '),
      ),
    );
  }
}
