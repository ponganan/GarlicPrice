import 'package:flutter/material.dart';

class ListAllPostPage extends StatefulWidget {
  const ListAllPostPage({Key? key}) : super(key: key);

  @override
  State<ListAllPostPage> createState() => _ListAllPostPageState();
}

class _ListAllPostPageState extends State<ListAllPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // leading: const Icon(
        //  Icons.home_outlined,
        //  color: Colors.blue,
        // ),
        title: const Text(
          'ประกาศ',
          //style: TextStyle(color: Colors.blue),
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
