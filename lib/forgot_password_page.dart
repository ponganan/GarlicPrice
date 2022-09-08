import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:garlic_price/model/utils.dart';

import 'main.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        //padding: EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'กรุณากรอก Email\n เพื่อตั้งค่ารหัสผ่านใหม่',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextFormField(
                      controller: emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Enter a valid email'
                              : null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: ('Email'),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              //use icon as button
              Padding(
                padding: const EdgeInsets.all(15),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    backgroundColor: Colors.deepPurpleAccent,
                  ),
                  icon: const Icon(Icons.email_outlined),
                  label: const Text(
                    'Reset Password',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    resetPassword();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.toString());
      Utils.showSnackBar('ส่ง รหัสผ่านผ่านใหม่แล้ว กรุณากดยืนยันที่ email');
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop;
    }
  }
}
