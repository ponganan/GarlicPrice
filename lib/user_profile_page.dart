import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePage();
}

class _UserProfilePage extends State<UserProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;

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
              onPressed: () {},
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
}
