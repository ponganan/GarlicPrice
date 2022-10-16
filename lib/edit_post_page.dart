import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  String? topicID;

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
      body: Column(
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
                    onPressed: () {
                      _controllerTopic.text = topic.topic;
                      _controllerTopicDetail.text = topic.topicDetail;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => Form(
                          key: formKey,
                          child: Dialog(
                            child: ListView(
                              children: <Widget>[
                                const SizedBox(height: 28),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
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
                                const SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: MaterialButton(
                                    onPressed: () {
                                      //if formKey validate
                                      if (formKey.currentState!.validate()) {
                                        topicID = topic.id;
                                        getUpdatePostDetail();

                                        Navigator.pop(context);
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
                      );
                    },
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

  void getUpdatePostDetail() {
    final addPostTopic = UpdateTopic(
      topic: _controllerTopic.text,
      topicDetail: _controllerTopicDetail.text,
      datePost: DateTime.now(),
    );
    updateAddTopic(addPostTopic);
  }

  Future updateAddTopic(UpdateTopic userUpdateTopic) async {
    final docTopic =
        FirebaseFirestore.instance.collection('postsell').doc(topicID);
    //add id from Firebase Auth id
    userUpdateTopic.id = docTopic.id;
    //userAddTopic.uID = userFirebase.uid;
    //userAddTopic.topicPic = picPostURL!;

    final json = userUpdateTopic.toJson();
    await docTopic.update(json);
  }

  Stream<List<TopicList>> readTopic() => FirebaseFirestore.instance
      .collection('postsell')
      .where('uID', isEqualTo: userFirebase.uid)
      //.orderBy('datePost', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => TopicList.fromJson(doc.data())).toList());
}

class UpdateTopic {
  String id;

  final String topic;
  final String topicDetail;

  final DateTime datePost;

  UpdateTopic({
    this.id = '',
    required this.topic,
    required this.topicDetail,
    required this.datePost,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'topic': topic,
        'topicDetail': topicDetail,
        'datePost': datePost,
      };
}
