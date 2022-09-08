import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePage();
}

class _UserProfilePage extends State<UserProfilePage> {
  final userFirebase = FirebaseAuth.instance.currentUser!;

  final _controllerName = TextEditingController();
  final _controllerTel = TextEditingController();
  final _controllerCity = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Profile Page',
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
                child: Icon(Icons.logout),
              )),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          const SizedBox(height: 28),
          Text(
            'ตั้งค่าบัญชี',
            style: const TextStyle(fontSize: 22),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: _controllerName,
              decoration: decorationTF('ชื่อ'),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: _controllerTel,
              decoration: decorationTF('เบอร์โทร'),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: _controllerCity,
              decoration: decorationTF('จังหวัด'),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: MaterialButton(
              onPressed: () {
                final userAddUser = UserAddUser(
                  //get value from name TextField
                  name: _controllerName.text,
                  //get int value to string
                  tel: int.parse(_controllerTel.text),
                  //get date value to string
                  // birthday: DateTime.parse(controllerDate.text),
                  city: _controllerCity.text,
                );
                createUserAddUser(userAddUser);

                Navigator.pop(context);
              },
              color: Colors.green[200],
              child: const Text(
                'Save',
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
  }

  InputDecoration decorationTF(String label) => InputDecoration(
        labelText: label,
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        //use OutlineInputBorder to Border all Textfield

        border: const OutlineInputBorder(),
      );

  Future createUserAddUser(UserAddUser userAddUser) async {
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(userFirebase.uid);
    //add id from Firebase Auth id
    userAddUser.id = docUser.id;
    //userAddUser.id = userFirebase.uid;

    final json = userAddUser.toJson();
    await docUser.set(json);
  }
}

class UserAddUser {
  String id;
  final String name;
  final int tel;
  final String city;

  UserAddUser({
    this.id = '',
    required this.name,
    required this.tel,
    required this.city,
  });
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tel': tel,
        'city': city,
      };
}
