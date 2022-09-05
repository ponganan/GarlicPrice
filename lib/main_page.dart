import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garlic_price/home_page.dart';

import 'package:garlic_price/verify_email_page.dart';

import 'package:garlic_price/auth_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        //check session user login on Firebase or not
        stream: FirebaseAuth.instance.authStateChanges(),
        //check session user login on Firebase or not
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Someting went wrong !!'),
            );
          }
          //check user login or not
          // if have go to VerifyEmailPage()
          if (snapshot.hasData) {
            return const VerifyEmailPage();
          } else {
            //return const AuthPage();
            return const HomePage();
          }
        },
      ),
    );
  }
}
