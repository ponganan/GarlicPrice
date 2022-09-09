import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'model/user_list.dart';

class ListAllPostPage extends StatefulWidget {
  const ListAllPostPage({Key? key}) : super(key: key);

  @override
  State<ListAllPostPage> createState() => _ListAllPostPageState();
}

class _ListAllPostPageState extends State<ListAllPostPage> {
  //final userAccount = FirebaseAuth.instance.currentUser!;
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
          'ประกาศ ซื้อ - ขาย',
          //style: TextStyle(color: Colors.blue),
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<List<UserList>>(
        stream: readUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went Wrong!!! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final user = snapshot.data!;

            return ListView(
              children: user.map(buildUser).toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildUser(UserList user) => ListTile(
        leading: CircleAvatar(child: Text('${user.tel}')),
        title: Text(user.name),
        subtitle: Text(user.city),
      );

  Stream<List<UserList>> readUser() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserList.fromJson(doc.data())).toList());
}
