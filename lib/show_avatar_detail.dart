import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model/user_list.dart';

class ShowAvatarDetail extends StatelessWidget {
  final String? uID;

  ShowAvatarDetail(this.uID, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<UserList?>(
          future: readUser(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went Wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final user = snapshot.data;
              return user == null
                  ? const Center(child: Text('No User'))
                  : buildUser(user);

              // : UserProfilePicture();
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildUser(UserList user) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 85,
                    backgroundColor: Colors.blue,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.userPic.toString()),
                      radius: 80,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 25),
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
                    user.tel,
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
            ],
          ),
        ),
      );

  // List All Users Data
  // Stream<List<UserList>> readUsers() => FirebaseFirestore.instance
  //     .collection('users')
  //     .snapshots()
  //     .map((snapshot) =>
  //         snapshot.docs.map((doc) => UserList.fromJson(doc.data())).toList());

  //List User Login data with Firebase Auth ID
  Future<UserList?> readUser() async {
    // get single document by ID
    final docUser = FirebaseFirestore.instance.collection('users').doc(uID);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return UserList.fromJson(snapshot.data()!);
    }
    return null;
  }
}
