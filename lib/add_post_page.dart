import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:garlic_price/home_page.dart';
import 'package:garlic_price/list_all_post_page.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPage();
}

class _AddPostPage extends State<AddPostPage> {
  final userFirebase = FirebaseAuth.instance.currentUser!;

  PlatformFile? pickedFile;
  String? picPostURL;
  UploadTask? uploadTask;

  final formKey = GlobalKey<FormState>();
  final _controllerTopic = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'เพิ่มประกาศ ซื้อ - ขาย',
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
            const SizedBox(height: 28),
            if (pickedFile != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: () {
                    selectFile();
                  },
                  child: Image.file(
                    File(pickedFile!.path!),
                    width: double.infinity,
                  ),
                ),
              ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: IconButton(
                icon: const Icon(Icons.camera_alt_outlined),
                iconSize: 35,
                onPressed: selectFile,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextFormField(
                controller: _controllerTopic,
                decoration: decorationTF('ข้อความที่ต้องการประกาศ'),
                //autovalidateMode for automatic validate value
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    value == null || value.isEmpty ? 'กรุณาระบุข้อความ' : null,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: MaterialButton(
                onPressed: () {
                  //if formKey validate
                  if (formKey.currentState!.validate()) {
                    final userAddTopic = AddTopic(
                      //get value from name TextField
                      topic: _controllerTopic.text,
                    );

                    //upload picture
                    uploadFile();

                    createAddTopic(userAddTopic);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const HomePage();
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

  Future createAddTopic(AddTopic userAddTopic) async {
    final docTopic = FirebaseFirestore.instance.collection('postsell').doc();
    //add id from Firebase Auth id
    userAddTopic.id = docTopic.id;
    userAddTopic.topicPic = picPostURL!;
    //userAddUser.id = userFirebase.uid;

    final json = userAddTopic.toJson();
    await docTopic.set(json);
  }

  //select picture function
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  //upload picture to FireStore
  Future uploadFile() async {
    //add firebase Auth id to rename profile picture
    final path = 'postpicture/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    final picPostURL = await snapshot.ref.getDownloadURL();
    print('download link: $picPostURL');
  }
}

class AddTopic {
  String id;
  String topicPic;
  final String topic;

  AddTopic({
    this.id = '',
    this.topicPic = '',
    required this.topic,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'topicpic': topicPic,
        'topic': topic,
      };
}
