import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _results = [];

  void _search() async {
    final query = _searchController.text;
    final results = await FirebaseFirestore.instance
        .collection('meals')
        .where('name', isGreaterThanOrEqualTo: query)
        .get();
    setState(() {
      _results = results.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Food'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final meal = _results[index];
                  return ListTile(
                    title: Text(meal['name']),
                    subtitle: Text(meal['description']),
                    onTap: () {
                      // Navigate to meal details
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
