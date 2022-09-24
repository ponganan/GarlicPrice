import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garlic_price/auth_post_page.dart';

import 'model/topic_list.dart';

class ListAllPostPage extends StatefulWidget {
  const ListAllPostPage({Key? key}) : super(key: key);

  @override
  State<ListAllPostPage> createState() => _ListAllPostPageState();
}

class _ListAllPostPageState extends State<ListAllPostPage> {
  //final userAccount = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // leading: const Icon(
        //  Icons.home_outlined,
        //  color: Colors.blue,
        // ),
        title: const Text(
          'ประกาศ ซื้อ - ขาย',
          //style: TextStyle(color: Colors.blue),
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green[200],
              ),
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              label: const Text(
                'เพิ่มประกาศ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return AuthPostPage();
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
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
                  Text(
                    topic.topic,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
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
              Container(
                // height: double.infinity,
                alignment: Alignment.center, // This is needed
                child: Image.network(
                  topic.topicPic,
                  fit: BoxFit.contain,
                  width: 350,
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      );

  Stream<List<TopicList>> readTopic() => FirebaseFirestore.instance
      .collection('postsell')
      .orderBy('datePost', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => TopicList.fromJson(doc.data())).toList());
}
