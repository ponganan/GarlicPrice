import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListAllPostPage extends StatefulWidget {
  const ListAllPostPage({Key? key}) : super(key: key);

  @override
  State<ListAllPostPage> createState() => _ListAllPostPageState();
}

class _ListAllPostPageState extends State<ListAllPostPage> {
  final user = FirebaseAuth.instance.currentUser!;
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
      body: Center(
        child: Column(children: [
          const SizedBox(height: 28),
          Text(
            'Signed In as : ' + user.email! + ' and UID : ' + user.uid,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 15),
          MaterialButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            color: Colors.green[200],
            child: const Text('Sign Out'),
          ),
        ]),
      ),
    );
  }
}
