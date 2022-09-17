import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:garlic_price/user_profile_page.dart';

class UploadProfilePicture extends StatefulWidget {
  const UploadProfilePicture({Key? key}) : super(key: key);

  @override
  State<UploadProfilePicture> createState() => _UploadProfilePictureState();
}

class _UploadProfilePictureState extends State<UploadProfilePicture> {
  final userFirebase = FirebaseAuth.instance.currentUser!;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  String? imagePath;
  String? oldImagePath = 'profilePicture/post_1663389906314';

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'profilePicture/${'post_$postID'}';
    //final path = 'profilePicture/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    final imagePath2 = ref.fullPath;
    debugPrint('imagepath2 = ' + imagePath2);
    imagePath = imagePath2;

    //delete old profile picture after upload new picture
    debugPrint('old image path = ' + oldImagePath!);
    final oldPic = FirebaseStorage.instance.ref().child(oldImagePath!);
    await oldPic.delete();

    setState(() {
      uploadTask == null;
    });

    //***************** if want to get value from async  when complete ************ //
    //******* we have to use then((value) => for get value when async complete ***** //
    return snapshot.ref.getDownloadURL().then(
          (value) => {
            debugPrint(value),
            //urlDownload = value,
            getProfileURL(value),
          },
        );
    //***************** if want to get value from async  when complete ************ //
    //******* we have to use then((value) => for get value when async complete ***** //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มรูปบัญชี'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            if (pickedFile != null) selectedPicture() else unSelectedPicture(),
            const SizedBox(
              height: 20,
            ),
            buildProgress(),
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
              width: double.infinity,
              child: IconButton(
                onPressed: () {
                  selectFile();
                },
                icon: const Icon(
                  Icons.camera_alt,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'กรุณาเลือกรูปภาพ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      );

  Widget selectedPicture() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: selectFile,
              child: Image.file(
                File(pickedFile!.path!),
                //width: double.infinity,
                // fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                uploadFile();
              },
              child: const Text(
                'ยืนยัน',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;
            return Column(children: [
              SizedBox(
                height: 50,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey,
                      color: Colors.blueAccent,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'อัพโหลดสำเร็จ ${(100 * progress).roundToDouble()} %',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const UserProfilePage();
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_back_ios_new),
                label: const Text(
                  'ย้อนกลับ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ]);
          } else {
            return const SizedBox(
              height: 20,
            );
          }
        },
      );

  void getProfileURL(String gotProfileURL) {
    final addPic = AddProfilePicture(
      userProfilePicture: gotProfileURL,
      imagePath: imagePath!,
    );
    addProfilePicture(addPic);
  }

  Future addProfilePicture(AddProfilePicture profilePicture) async {
    final docProfilePic =
        FirebaseFirestore.instance.collection('users').doc(userFirebase.uid);

    profilePicture.id = docProfilePic.id;
    //profilePicture.userpic = docProfilePic.id;

    final json = profilePicture.toJson();
    await docProfilePic.update(json);
  }
}

class AddProfilePicture {
  String id;
  final String userProfilePicture;
  final String imagePath;

  AddProfilePicture({
    this.id = '',
    required this.userProfilePicture,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userpic': userProfilePicture,
        'imagePath': imagePath,
      };
}
