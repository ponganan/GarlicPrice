import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePage();
}

class _UserProfilePage extends State<UserProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile Page'),
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
