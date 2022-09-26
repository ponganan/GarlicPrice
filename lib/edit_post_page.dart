import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';

import 'list_all_post_page.dart';
import 'model/format_datetime.dart';
import 'model/topic_list.dart';

class EditPostPage extends StatefulWidget {
  const EditPostPage({Key? key}) : super(key: key);

  @override
  State<EditPostPage> createState() => _EditPostPage();
}

class _EditPostPage extends State<EditPostPage> {
  final userFirebase = FirebaseAuth.instance.currentUser!;
  final FormatDatetime convertDatetime = FormatDatetime();

  final formKey = GlobalKey<FormState>();
  final _controllerTopic = TextEditingController();
  final _controllerTopicDetail = TextEditingController();

  File? image;

  UploadTask? uploadTask;

  String? fireBaseImagePath;
  String? imageName;
  String? picPostURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'แก้ไขประกาศ',
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
        child: Column(
          children: [
            const SizedBox(height: 10),
            Flexible(
              child: StreamBuilder<List<TopicList>>(
                stream: readTopic(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went Wrong!!! ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final topic = snapshot.data!;

                    return ListView(
                      children: topic.map(buildTopic).toList(),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTopic(TopicList topic) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row(
                children: [
                  const Text(
                    'หัวข้อ : ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      topic.topic,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  //Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                    ),
                    color: Colors.grey,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        child: ListView(
                          children: <Widget>[
                            const SizedBox(height: 15),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: TextFormField(
                                controller: _controllerTopic,
                                decoration: decorationTF('หัวข้อประกาศ'),

                                //autovalidateMode for automatic validate value
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'กรุณาระบุหัวข้อประกาศ'
                                        : null,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: TextFormField(
                                controller: _controllerTopicDetail,
                                decoration:
                                    decorationTF('ข้อความที่ต้องการประกาศ'),
                                maxLines: 5,
                                //autovalidateMode for automatic validate value
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'กรุณาระบุประกาศ'
                                        : null,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: IconButton(
                                    alignment: Alignment.bottomRight,
                                    icon: const Icon(
                                        Icons.camera_enhance_outlined),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
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
                                    Navigator.of(context).push(
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      topic.topicDetail,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      convertDatetime.formattedDateAndTime(
                          topic.datePost.millisecondsSinceEpoch),
                      // topic.datePost.toIso8601String(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              topic.topicPic.toString() != ""
                  ? Container(
                      // height: double.infinity,
                      alignment: Alignment.center, // This is needed
                      child: Image.network(
                        topic.topicPic,
                        fit: BoxFit.contain,
                        width: 350,
                      ),
                    )
                  : Container(),
              const SizedBox(height: 15),
              IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  size: 30,
                ),
                color: Colors.red,
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('ลบประกาศนี้'),
                    content: const Text('ต้องการลบประกาศนี้ใช่หรือไม่'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'OK');
                          final docTopic = FirebaseFirestore.instance
                              .collection('postsell')
                              .doc(topic.id);
                          docTopic.delete();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
            ],
          ),
        ),
      );

  InputDecoration decorationTF(String label) => InputDecoration(
        labelText: label,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        //use OutlineInputBorder to Border all Textfield

        border: const OutlineInputBorder(),
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

  Future createAddTopic(AddTopic userAddTopic) async {
    final docTopic = FirebaseFirestore.instance.collection('postsell').doc();
    //add id from Firebase Auth id
    userAddTopic.id = docTopic.id;
    //userAddTopic.uID = userFirebase.uid;
    //userAddTopic.topicPic = picPostURL!;

    final json = userAddTopic.toJson();
    await docTopic.set(json);
  }

  Stream<List<TopicList>> readTopic() => FirebaseFirestore.instance
      .collection('postsell')
      .where('uID', isEqualTo: userFirebase.uid)
      //.orderBy('datePost', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => TopicList.fromJson(doc.data())).toList());
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
