import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'model/user_list.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({Key? key}) : super(key: key);

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ข้อมูลบัญชี',
        ),
      ),
      body: FutureBuilder<UserList?>(
        future: readUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went Wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final user = snapshot.data;
            return user == null
                ? const Center(child: Text('No User'))
                : buildUser(user);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget buildUser(UserList user) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'ชื่อ : ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Text(
                  'เบอร์โทร : ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.tel.toString(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Text(
                  'จังหวัด : ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.city,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.green[200],
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  // List All Users Data
  Stream<List<UserList>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserList.fromJson(doc.data())).toList());

  //List User Login data with Firebase Auth ID
  Future<UserList?> readUser() async {
    // get single document by ID
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return UserList.fromJson(snapshot.data()!);
    }
    return null;
  }
}
