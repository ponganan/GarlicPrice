import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garlic_price/home_page.dart';
import 'package:garlic_price/model/utils.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    //user need to be create before
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    // need to reload user before call isEmailVerified
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
      final firstTimeUserID = FirstTimeUserID();

      createFirstTimeUserID(firstTimeUserID);
    }
  }

  Future createFirstTimeUserID(FirstTimeUserID addFirstTimeUser) async {
    final userFirebase = FirebaseAuth.instance.currentUser!;
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(userFirebase.uid);
    //add id from Firebase Auth id
    addFirstTimeUser.id = docUser.id;

    //userAddUser.id = userFirebase.uid;

    final json = addFirstTimeUser.toJsonFirstTimeID();
    await docUser.set(json);
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      //after verify will direct to Homepage
      ? HomePage()
      : Scaffold(
          appBar: AppBar(
            title: Text('Verify Email'),
          ),
          body: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Email ????????????????????????????????? ??????????????????????????????????????????????????? \n ????????????????????????????????????????????? inbox ???????????? spam/junk',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  icon: const Icon(
                    Icons.email,
                    size: 35,
                  ),
                  label: const Text(
                    'Resent Email',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                ),
                const SizedBox(height: 10),
                TextButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                ),
              ],
            ),
          ),
        );
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
