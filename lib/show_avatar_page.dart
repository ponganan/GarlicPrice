import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'model/user_list.dart';

class ShowAvatarPage extends StatelessWidget {
  final String? uID;
  String? userPic;
  ShowAvatarPage(this.uID, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<UserList?>(
        future: readUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went Wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final user = snapshot.data;
            userPic = user!.userPic!;
            return user == null
                ? const Center(child: Text('No User'))
                : showAvatar();

            // : UserProfilePicture();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<UserList?> readUser() async {
    // get single document by ID
    final docUser = FirebaseFirestore.instance.collection('users').doc(uID);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return UserList.fromJson(snapshot.data()!);
    }
    return null;
  }

  Widget showAvatar() => Center(
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.blue,
          child: CircleAvatar(
            backgroundImage: NetworkImage('$userPic'),
            radius: 23,
          ),
        ),
      );
}
