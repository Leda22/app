import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChefHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chef Home'),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              child: Text('Add Meal'),
              onPressed: () {
                Navigator.pushNamed(context, '/add_meal');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              child: Text('Add Recipe'),
              onPressed: () {
                Navigator.pushNamed(context, '/add_recipe');
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('meals')
                  .snapshots(),
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
          ),
        ],
      ),
    );
  }
}
