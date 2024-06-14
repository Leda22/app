import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AddMealScreen extends StatefulWidget {
  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  File? _mealImage;
  String? _mealImageUrl;
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> _pickMealImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _mealImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadMealImage() async {
    if (_mealImage != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final imagesRef =
          storageRef.child('meal_pictures/${DateTime.now().toString()}.jpg');
      await imagesRef.putFile(_mealImage!);
      _mealImageUrl = await imagesRef.getDownloadURL();
    }
  }

  Future<void> _submitMeal() async {
    if (_formKey.currentState!.validate()) {
      await _uploadMealImage();
      try {
        await FirebaseFirestore.instance
            .collection('chefs')
            .doc(user!.uid)
            .collection('meals')
            .add({
          'name': _nameController.text,
          'price': _priceController.text,
          'imageUrl': _mealImageUrl ?? '',
          'chef': user!.displayName ?? '',
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Meal added successfully')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to add meal')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Meal'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Meal Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a meal name' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a price' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickMealImage,
                child: Text('Pick Meal Image'),
              ),
              _mealImage != null
                  ? Image.file(_mealImage!, height: 150)
                  : Text('No image selected'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitMeal,
                child: Text('Add Meal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
