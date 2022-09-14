import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:garlic_price/upload_profile_picture.dart';
import 'package:garlic_price/user_detail_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePage();
}

class _UserProfilePage extends State<UserProfilePage> {
  final userFirebase = FirebaseAuth.instance.currentUser!;

  PlatformFile? pickedFile;
  String? downloadURL;

  final formKey = GlobalKey<FormState>();
  final _controllerName = TextEditingController();
  final _controllerTel = TextEditingController();
  final _controllerCity = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'รายละเอียดบัญชี',
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
                child: const Icon(Icons.logout),
              )),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: <Widget>[
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const UploadProfilePicture();
                      },
                    ),
                  ),
                  child: Stack(children: const [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage("assets/images/profile.png"),
                      radius: 60,
                    ),
                    Positioned(
                      bottom: 3,
                      right: 45,
                      child: Icon(
                        Icons.camera_alt,
                        size: 25,
                        color: Colors.teal,
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextFormField(
                controller: _controllerName,
                decoration: decorationTF('ชื่อ'),
                //autovalidateMode for automatic validate value
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    value == null || value.isEmpty ? 'กรุณากรอกชื่อ' : null,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextFormField(
                controller: _controllerTel,
                keyboardType: TextInputType.number,
                decoration: decorationTF('เบอร์โทร'),
                //autovalidateMode for automatic validate value
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    value == null || value.isEmpty ? 'กรุณากรอกเบอร์โทร' : null,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextFormField(
                controller: _controllerCity,
                decoration: decorationTF('จังหวัด'),
                //autovalidateMode for automatic validate value
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    value == null || value.isEmpty ? 'กรุณากรอกจังหวัด' : null,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: MaterialButton(
                onPressed: () {
                  //if formKey validate
                  if (formKey.currentState!.validate()) {
                    final userAddUser = UserAddUser(
                      //get value from name TextField
                      name: _controllerName.text,
                      //get int value to string
                      //tel: int.parse(_controllerTel.text),
                      tel: _controllerTel.text,
                      //get date value to string
                      // birthday: DateTime.parse(controllerDate.text),
                      city: _controllerCity.text,
                    );

                    //upload picture
                    //uploadFile();

                    createUserAddUser(userAddUser);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const UserDetailPage();
                        },
                      ),
                    );
                  }
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: MaterialButton(
                onPressed: () {
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
                  'ดูข้อมูลบัญชี',
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
  }

  InputDecoration decorationTF(String label) => InputDecoration(
        labelText: label,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        //use OutlineInputBorder to Border all Textfield

        border: const OutlineInputBorder(),
      );

  Future createUserAddUser(UserAddUser userAddUser) async {
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(userFirebase.uid);
    //add id from Firebase Auth id
    userAddUser.id = docUser.id;
    userAddUser.userPic = 'downloadURL!';
    //userAddUser.id = userFirebase.uid;

    final json = userAddUser.toJson();
    await docUser.set(json);
  }
}

class UserAddUser {
  String id;
  String userPic;
  final String name;
  final String tel;
  final String city;

  UserAddUser({
    this.id = '',
    this.userPic = '',
    required this.name,
    required this.tel,
    required this.city,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userpic': userPic,
        'name': name,
        'tel': tel,
        'city': city,
      };
}
