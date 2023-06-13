import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoSelectorScreen extends StatefulWidget {
  const PhotoSelectorScreen({
    super.key,
    // required this.onPickImage,
  });

//   final void Function(File pickedImage) onPickImage;

  @override
  State<PhotoSelectorScreen> createState() => _PhotoSelectorScreenState();
}

File? _pickedImageFile;

class _PhotoSelectorScreenState extends State<PhotoSelectorScreen> {
  void _pickImageCamera() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }
    Navigator.of(context).pop();

    final userData = FirebaseAuth.instance.currentUser!;
    final oldProfilePictureRef = FirebaseStorage.instance.ref().child('user_images').child('${userData.uid}.jpg');

    await oldProfilePictureRef.delete();

    final newProfilePictureRef = FirebaseStorage.instance.ref().child('user_images').child('${userData.uid}.jpg');
    await newProfilePictureRef.putFile(File(pickedImage.path));

    final imageUrl = await newProfilePictureRef.getDownloadURL();

    final userRef = FirebaseFirestore.instance.collection('users').doc(userData.uid);
    await userRef.update({'image_url': imageUrl});
  }

  void _pickImageGallery() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }
    Navigator.of(context).pop();

    final userData = FirebaseAuth.instance.currentUser!;
    final oldProfilePictureRef = FirebaseStorage.instance.ref().child('user_images').child('${userData.uid}.jpg');

    await oldProfilePictureRef.delete();

    final newProfilePictureRef = FirebaseStorage.instance.ref().child('user_images').child('${userData.uid}.jpg');
    await newProfilePictureRef.putFile(File(pickedImage.path));

    final imageUrl = await newProfilePictureRef.getDownloadURL();

    final userRef = FirebaseFirestore.instance.collection('users').doc(userData.uid);
    await userRef.update({
      'image_url': imageUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edytuj zdjęcie"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: _pickImageCamera,
              child: Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Text(
                    'Zrób zdjęcie telefonem',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: _pickImageGallery,
              child: Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Text(
                    'Wybierz zdjęcie z galerii',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
