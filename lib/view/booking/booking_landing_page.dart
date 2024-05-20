import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookingLandingPage extends StatelessWidget {
  const BookingLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('You Have Not Booked Any Flight Yet!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ));
  }
}
