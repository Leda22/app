import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  File? _recipeImage;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _recipeImage = File(pickedFile.path);
      }
    });
  }

  Future<void> _addRecipe() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? imageUrl;
      if (_recipeImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('recipe_images')
            .child(user.uid + '.jpg');
        await ref.putFile(_recipeImage!);
        imageUrl = await ref.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('recipes')
          .add({
        'name': _nameController.text,
        'ingredients': _ingredientsController.text,
        'imageUrl': imageUrl,
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Recipe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Recipe Name'),
              ),
              TextField(
                controller: _ingredientsController,
                decoration: InputDecoration(labelText: 'Ingredients'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Pick Recipe Image'),
                onPressed: _pickImage,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Add Recipe'),
                onPressed: _addRecipe,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
