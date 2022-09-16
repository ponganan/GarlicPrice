import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garlic_price/upload_profile_picture.dart';
import 'package:garlic_price/user_detail_page.dart';

import 'home_page.dart';
import 'model/user_list.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePage();
}

class _UserProfilePage extends State<UserProfilePage> {
  final userFirebase = FirebaseAuth.instance.currentUser!;

  PlatformFile? pickedFile;
  String? downloadURL;
  //String? getUserPic;

  final formKey = GlobalKey<FormState>();
  late TextEditingController _controllerName = TextEditingController();
  late TextEditingController _controllerTel = TextEditingController();
  late TextEditingController _controllerCity = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controllerName.dispose();
    _controllerTel.dispose();
    _controllerCity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'รายละเอียดบัญชี',
        ),
      ),
      body: FutureBuilder<UserList?>(
        future: readUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went Wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final user = snapshot.data;

            _controllerName.text = user!.name!;
            _controllerTel.text = user!.tel!;
            _controllerCity.text = user!.city!;
            // getUserPic = user!.userPic!;
            // print('test =$getUserPic');

            return user == null
                ? const Center(
                    child: Text('No User'),
                  )
                : buildUser(user);
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

  Future createUserAddUser(UserAddUser userAddUser) async {
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(userFirebase.uid);
    //add id from Firebase Auth id
    userAddUser.id = docUser.id;
    //userAddUser.userPic = getUserPic!;
    //userAddUser.id = userFirebase.uid;

    final json = userAddUser.toJson();
    await docUser.set(json);
  }

  Stream<List<UserList>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserList.fromJson(doc.data())).toList());

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

  Widget buildUser(UserList user) => Form(
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
                //autofocus at this field for first time
                autofocus: true,
                textInputAction: TextInputAction.next,
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

                //let user insert number only
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                //set input only 10 digit
                maxLength: 10,

                textInputAction: TextInputAction.next,
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
                textInputAction: TextInputAction.next,
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
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return HomePage();
                      },
                    ),
                  );
                },
                icon: Icon(Icons.home),
                label: Text(
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
      );
}

InputDecoration decorationTF(String label) => InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      //use OutlineInputBorder to Border all Textfield

      border: const OutlineInputBorder(),
    );

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
