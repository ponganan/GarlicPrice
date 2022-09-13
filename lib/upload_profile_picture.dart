import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UploadProfilePicture extends StatefulWidget {
  const UploadProfilePicture({Key? key}) : super(key: key);

  @override
  State<UploadProfilePicture> createState() => _UploadProfilePictureState();
}

class _UploadProfilePictureState extends State<UploadProfilePicture> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = 'profilePicture/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link : $urlDownload');
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
            if (pickedFile != null)
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child: Container(
                    child: Image.file(
                      File(pickedFile!.path!),
                      //width: double.infinity,
                      // fit: BoxFit.cover,
                    ),
                  )),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: IconButton(
                onPressed: () {
                  selectFile();
                },
                icon: Icon(
                  Icons.camera_alt,
                  size: 50,
                ),
              ),
            ),
            SizedBox(
              height: 50,
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
            )
          ],
        ),
      ),
    );
  }
}
