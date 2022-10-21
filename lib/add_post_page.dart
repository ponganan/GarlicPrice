import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garlic_price/edit_post_page.dart';
import 'package:garlic_price/list_all_post_page.dart';
import 'package:image_picker/image_picker.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPage();
}

class _AddPostPage extends State<AddPostPage> {
  final userFirebase = FirebaseAuth.instance.currentUser!;

  File? image;

  UploadTask? uploadTask;

  String? fireBaseImagePath;
  String? imageName;
  String? picPostURL;

  final formKey = GlobalKey<FormState>();
  final _controllerTopic = TextEditingController();
  final _controllerTopicDetail = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controllerTopic.dispose();
    _controllerTopicDetail.dispose();
    super.dispose();
  }

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
            if (image != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: GestureDetector(
                  onTap: () {
                    pickImage(ImageSource.gallery);
                  },
                  child: Image.file(
                    File(image!.path!),
                    width: double.infinity,
                  ),
                ),
              ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextFormField(
                controller: _controllerTopic,
                decoration: decorationTF('หัวข้อประกาศ'),

                //autovalidateMode for automatic validate value
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value == null || value.isEmpty
                    ? 'กรุณาระบุหัวข้อประกาศ'
                    : null,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextFormField(
                controller: _controllerTopicDetail,
                decoration: decorationTF('ข้อความที่ต้องการประกาศ'),
                maxLines: 5,
                //autovalidateMode for automatic validate value
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    value == null || value.isEmpty ? 'กรุณาระบุประกาศ' : null,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: IconButton(
                    alignment: Alignment.bottomRight,
                    icon: const Icon(Icons.image_outlined),
                    iconSize: 35,
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: IconButton(
                    alignment: Alignment.bottomRight,
                    icon: const Icon(Icons.camera_enhance_outlined),
                    iconSize: 35,
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: MaterialButton(
                onPressed: () {
                  //if formKey validate
                  if (formKey.currentState!.validate()) {
                    if (image == null) {
                      picPostURL = '';
                      getPostDetail(picPostURL!);
                    } else {
                      uploadFile();
                    }
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const ListAllPostPage();
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
            const SizedBox(height: 55),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: MaterialButton(
                onPressed: () {
                  //if formKey validate

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const EditPostPage();
                      },
                    ),
                  );
                },
                color: Colors.blueAccent[200],
                child: const Text(
                  'แก้ไขประกาศของคุณ',
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

  Widget unSelectedPicture() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 80,
              width: double.infinity,
              child: IconButton(
                onPressed: () {
                  pickImage(
                    ImageSource.gallery,
                  );
                },
                icon: const Icon(
                  Icons.image_outlined,
                  size: 60,
                ),
              ),
            ),
            const Text(
              'เลือกรูปภาพ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 80,
              width: double.infinity,
              child: IconButton(
                onPressed: () {
                  pickImage(ImageSource.camera);
                },
                icon: const Icon(
                  Icons.camera_enhance_outlined,
                  size: 60,
                ),
              ),
            ),
            const Text(
              'เลือกรูปถ่าย',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      );
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 600,
      );
      if (image == null) return;

      final imageTemp = File(image.path);
      //save image cache
      //final imagePermanent = await saveImagePermanently(image.path);
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  //upload picture to FireStore
  Future uploadFile() async {
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'postPicture/${'post_$postID'}';
    //final path = 'profilePicture/${imageName}';
    final file = File(image!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    final imagePath2 = ref.fullPath;
    debugPrint('imagepath2 = ' + imagePath2);
    fireBaseImagePath = imagePath2;

    //delete old profile picture after upload new picture
    // debugPrint('old image path = ' + oldImagePath!);
    // final oldPic = FirebaseStorage.instance.ref().child(oldImagePath!);
    // await oldPic.delete();

    setState(() {
      uploadTask == null;
    });

    //***************** if want to get value from async  when complete ************ //
    //******* we have to use then((value) => for get value when async complete ***** //
    return snapshot.ref.getDownloadURL().then(
          (value) => {
            debugPrint(value),
            picPostURL = value,
            getPostDetail(value),
          },
        );
    //***************** if want to get value from async  when complete ************ //
    //******* we have to use then((value) => for get value when async complete ***** //
  }

  void getPostDetail(String gotPostURL) {
    final addPostTopic = AddTopic(
      topicPic: picPostURL!,
      uID: userFirebase.uid,
      topic: _controllerTopic.text,
      topicDetail: _controllerTopicDetail.text,
      datePost: DateTime.now(),
    );
    createAddTopic(addPostTopic);
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
    //userAddTopic.uID = userFirebase.uid;
    //userAddTopic.topicPic = picPostURL!;

    final json = userAddTopic.toJson();
    await docTopic.set(json);
  }

  //select picture function

  // Future addPostTopic(AddPostTopic postTopic) async {
  //   final docPostTopic =
  //       FirebaseFirestore.instance.collection('users').doc(userFirebase.uid);
  //
  //   postTopic.id = docPostTopic.id;
  //   //profilePicture.userpic = docProfilePic.id;
  //
  //   final json = postTopic.toJson();
  //   await docPostTopic.update(json);
  // }

}

class AddTopic {
  String id;
  String uID;
  String topicPic;

  final String topic;
  final String topicDetail;

  final DateTime datePost;

  AddTopic({
    this.id = '',
    required this.uID,
    this.topicPic = '',
    required this.topic,
    required this.topicDetail,
    required this.datePost,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'uID': uID,
        'topicPic': topicPic,
        'topic': topic,
        'topicDetail': topicDetail,
        'datePost': datePost,
      };
}
