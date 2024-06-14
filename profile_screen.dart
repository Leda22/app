import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  String? _profileImageUrl;
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> _pickProfileImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadProfileImage() async {
    if (_profileImage != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final imagesRef = storageRef.child('profile_pictures/${user!.uid}.jpg');
      await imagesRef.putFile(_profileImage!);
      _profileImageUrl = await imagesRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('chefs')
          .doc(user!.uid)
          .update({
        'profileImageUrl': _profileImageUrl,
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          children: [
            _profileImageUrl != null
                ? Image.network(_profileImageUrl!, height: 150)
                : Icon(Icons.account_circle, size: 150),
            ElevatedButton(
              onPressed: _pickProfileImage,
              child: Text('Pick Profile Image'),
            ),
            ElevatedButton(
              onPressed: _uploadProfileImage,
              child: Text('Upload Profile Image'),
            ),
          ],
        ),
      ),
    );
  }
}
