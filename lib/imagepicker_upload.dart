import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garlic_price/user_profile_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ImagePickerUpload extends StatefulWidget {
  const ImagePickerUpload({Key? key}) : super(key: key);

  @override
  State<ImagePickerUpload> createState() => _ImagePickerUploadState();
}

class _ImagePickerUploadState extends State<ImagePickerUpload> {
  final userFirebase = FirebaseAuth.instance.currentUser!;
  //PlatformFile? pickedFile;
  File? image;

  UploadTask? uploadTask;

  String? fireBaseimagePath;
  String? imageName;
  String? oldImagePath = 'profilePicture/post_1663389906314';

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 600,
      );
      if (image == null) return;

      //final imageTemp = File(image.path);
      //save image cache
      final imagePermanent = await saveImagePermanently(image.path);
      setState(() {
        this.image = imagePermanent;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<File> saveImagePermanently(String saveImagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(saveImagePath);
    //imageName = name;
    final image = File('${directory.path}/$name');

    return File(saveImagePath).copy(image.path);
  }

  Future uploadFile() async {
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'profilePicture/${'post_$postID'}';
    //final path = 'profilePicture/${imageName}';
    final file = File(image!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    final imagePath2 = ref.fullPath;
    debugPrint('imagepath2 = ' + imagePath2);
    fireBaseimagePath = imagePath2;

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
            //urlDownload = value,
            getProfileURL(value),
          },
        );
    //***************** if want to get value from async  when complete ************ //
    //******* we have to use then((value) => for get value when async complete ***** //
  }

  void getProfileURL(String gotProfileURL) {
    final addPic = AddProfilePicture(
      userProfilePicture: gotProfileURL,
      imagePath: fireBaseimagePath!,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Text('เพิ่มรูปบัญชี')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              if (image != null) selectedPicture() else unSelectedPicture(),
              const SizedBox(
                height: 20,
              ),
              buildProgress(),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget selectedPicture() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {}, //selectFile,
              child: Image.file(
                File(image!.path!),
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
