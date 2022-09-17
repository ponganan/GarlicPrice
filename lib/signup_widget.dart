import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:garlic_price/model/utils.dart';

import 'main.dart';

class SignUpWidget extends StatefulWidget {
  final VoidCallback onClickedSignIn;

  const SignUpWidget({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cfPasswordController = TextEditingController();

  //release memories
  // Clean up the controller when the widget is disposed.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _cfPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  //Hello
                  const Text(
                    'ลงทะเบียน',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    ' ราคากระเทียมจีน',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 50),
                  //email
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
                          controller: _emailController,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) =>
                              email != null && !EmailValidator.validate(email)
                                  ? 'Enter a valid email'
                                  : null,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.email_outlined),
                            border: InputBorder.none,
                            hintText: ('Email'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  //password
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
                          controller: _passwordController,
                          //obscureText for don't show password text
                          obscureText: true,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value != null && value.length < 6
                                  ? 'Enter min 6 characters'
                                  : null,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.key_outlined),
                            border: InputBorder.none,
                            hintText: ('Password'),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  // confirm password

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
                          controller: _cfPasswordController,
                          //obscureText for don't show password text
                          obscureText: true,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          // confirm password with 2 condition
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter min 6 characters';
                            } else if (_passwordController.text !=
                                _cfPasswordController.text) {
                              return 'Password not match';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            icon: Icon(Icons.key_outlined),
                            border: InputBorder.none,
                            hintText: ('Confirm Password'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  //sign in
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: signUp,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.arrow_forward),
                              SizedBox(width: 10),
                              Text(
                                'ลงทะเบียน',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  //register
                  RichText(
                    text: TextSpan(
                        text: ('มี Account แล้ว ?  '),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickedSignIn,
                            text: ('เข้าสู่ระบบ'),
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ]),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.purple.shade300,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      text: ('App by Ponganan'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      switch (e.code) {
        //Custom errors for Thai languages
        // switch (e.code) {case "xxxx error code xxxxx":}
        case "email-already-in-use":
          Utils.showSnackBar('Email นี้ ลงทะเบียนในระบบแล้ว');
          break;
        case "wrong-password":
          Utils.showSnackBar('รหัสผ่านไม่ถูกต้อง');
          break;
        default:
          Utils.showSnackBar(e.message);
      }
    }

    //Navigator.of(context) not working
    // go to main.dart
    // add final navigatorKey = GlobalKey<NavigatorState>();  variable
    // and add navigatorKey: navigatorKey in MaterialApp
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
