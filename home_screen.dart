import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/screens/chef_home_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Something went wrong')),
          );
        }

        var userData = snapshot.data;
        bool isChef = userData!['isChef'];

        if (isChef) {
          return ChefHomeScreen();
        } else {
          return ClientHomeScreen();
        }
      },
    );
  }
}

class ClientHomeScreen extends StatelessWidget {
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
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collectionGroup('meals').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final meals = snapshot.data!.docs;
          return ListView.builder(
            itemCount: meals.length,
            itemBuilder: (context, index) {
              var meal = meals[index];
              return Card(
                child: ListTile(
                  leading: meal['imageUrl'] != null
                      ? Image.network(meal['imageUrl'])
                      : Icon(Icons.fastfood),
                  title: Text(meal['name']),
                  subtitle: Text(
                      'Ingredients: ${meal['ingredients']}\nPrice: ${meal['price']}'),
                  onTap: () {
                    // Add functionality to view meal details
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
