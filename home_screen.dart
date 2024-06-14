import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool isChef = false;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    setState(() {
      isChef = userData['isChef'];
    });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collectionGroup('meals')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final meals = snapshot.data!.docs
                    .map((doc) => Meal.fromFirestore(doc))
                    .toList();
                if (meals.isEmpty) {
                  return Center(child: Text('No meals available'));
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (meals.isNotEmpty) FeaturedMeal(meal: meals.first),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Chef's Menu",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: meals.length,
                        itemBuilder: (context, index) {
                          return MealCard(meal: meals[index]);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            if (isChef)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add_meal');
                  },
                  child: Text('Add Meal'),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Orders'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Account'),
        ],
      ),
    );
  }
}

class Meal {
  final String name;
  final String imageUrl;
  final String chef;
  final String price;

  Meal({
    required this.name,
    required this.imageUrl,
    required this.chef,
    required this.price,
  });

  factory Meal.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Meal(
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      chef: data['chef'] ?? '',
      price: data['price'] ?? '',
    );
  }
}

class FeaturedMeal extends StatelessWidget {
  final Meal meal;

  FeaturedMeal({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(meal.imageUrl),
          Text(meal.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('By ${meal.chef}'),
          Text('\$${meal.price}', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final Meal meal;

  MealCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          meal.imageUrl.isNotEmpty
              ? Image.network(meal.imageUrl,
                  height: 100, width: 160, fit: BoxFit.cover)
              : Icon(Icons.fastfood, size: 100),
          SizedBox(height: 8.0),
          Text(meal.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text('\$${meal.price}', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
