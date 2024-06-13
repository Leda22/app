import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderScreen extends StatefulWidget {
  final String mealId;

  OrderScreen({required this.mealId});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _scheduleController = TextEditingController();

  Future<void> _placeOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('orders').add({
      'mealId': widget.mealId,
      'userId': user?.uid,
      'address': _addressController.text,
      'schedule': _scheduleController.text,
      'status': 'pending',
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Order'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _scheduleController,
              decoration: InputDecoration(labelText: 'Schedule'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Place Order'),
              onPressed: _placeOrder,
            ),
          ],
        ),
      ),
    );
  }
}
