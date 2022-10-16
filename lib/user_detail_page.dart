import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garlic_price/user_profile_page.dart';

import 'home_page.dart';
import 'image_dialog.dart';
import 'model/user_list.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({Key? key}) : super(key: key);

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final userFirebase = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ข้อมูลบัญชี',
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return HomePage();
                      },
                    ),
                  );
                },
                child: const Icon(Icons.logout),
              )),
        ],
      ),
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
              return userFirebase != null
                  ? buildFirstTimeUserID()
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            }
          },
        ),
      ),
    );
  }

  Widget buildFirstTimeUserID() => Center(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 25.0, vertical: 200.0),
          child: MaterialButton(
            onPressed: () {
              //if formKey validate

              final firstTimeUserID = FirstTimeUserID();

              //upload picture
              //uploadFile();

              createFirstTimeUserID(firstTimeUserID);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const UserDetailPage();
                  },
                ),
              );
            },
            color: Colors.green[200],
            child: const Text(
              'ตั้งค่าบัญชี',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );

  Widget buildUser(UserList user) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  user.userPic.toString() != ""
                      ? GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            builder: (_) =>
                                ImageDialog(user.userPic.toString()),
                          ),
                          child: CircleAvatar(
                            radius: 85,
                            backgroundColor: Colors.blue,
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(user.userPic.toString()),
                              radius: 80,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 85,
                          backgroundColor: Colors.blue,
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(user.userPic.toString()),
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
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const UserProfilePage();
                        },
                      ),
                    );
                  },
                  color: Colors.green[200],
                  child: const Text(
                    'เพิ่มข้อมูล / แก้ไข',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const HomePage();
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.home),
                  label: const Text(
                    'กลับหน้าแรก',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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

  Future createFirstTimeUserID(FirstTimeUserID addFirstTimeUser) async {
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(userFirebase.uid);
    //add id from Firebase Auth id
    addFirstTimeUser.id = docUser.id;

    //userAddUser.id = userFirebase.uid;

    final json = addFirstTimeUser.toJsonFirstTimeID();
    await docUser.set(json);
  }

  //List User Login data with Firebase Auth ID
  Future<UserList?> readUser() async {
    // get single document by ID
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(userFirebase.uid);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return UserList.fromJson(snapshot.data()!);
    }
    return null;
  }
}

class FirstTimeUserID {
  String id;
  String userPic;
  String name;
  String tel;
  String city;
  String imagePath;

  FirstTimeUserID({
    this.id = '',
    this.userPic = '',
    this.name = '',
    this.tel = '',
    this.city = '',
    this.imagePath = '',
  });
  Map<String, dynamic> toJsonFirstTimeID() => {
        'id': id,
        'userpic': userPic,
        'name': name,
        'tel': tel,
        'city': city,
        'imagePath': imagePath,
      };
}
