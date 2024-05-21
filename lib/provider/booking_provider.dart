import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../View/Auth/widgets/snackBar.dart';

class BookingProvider extends ChangeNotifier {
  int screenNumber = 0;
  int planeNumber = 0;
  int totalPassengers = 0;
  int adults = 0;
  int teenagers = 0;
  int babies = 0;
  int totalSeatSelected = 0;
  String flightNumber = "";
  List<Map<String, String>> selectedSeats = [];
  String departureDate = "";

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void changeScreenNumber(int value) {
    screenNumber = value;
    notifyListeners();
  }

  void changePassengers(int adults, int teenagers, int babies) {
    totalPassengers = adults + teenagers + babies;
    this.adults = adults;
    this.teenagers = teenagers;
    this.babies = babies;
    notifyListeners();
  }

  Future<String> bookFlight() async {
    try {
      await FirebaseFirestore.instance.collection("booking").doc().set(
        {
          "adults": adults,
          "teenagers": teenagers,
          "babies": babies,
          "userId": _firebaseAuth.currentUser!.uid,
          "flightNumber": flightNumber,
          "selectedSeats": selectedSeats,
          "departureDate": departureDate,
        },
      );

      List<String> newSeats = [];
      for (var element in selectedSeats) {
        newSeats.add(element["seatNumber"]!);
      }
      updateBookedFlight(newSeats);

      return "Success";
    } catch (e) {
      print("--------------------------+++++++++++++++++++++++1 11 1");
      return "An Error occur";
    }
  }

  Future<String> deleteBooking(String id,  List<Map<String, String>> seats, String flightNumber) async {
    try {
      // Retrieve the booking
      DocumentSnapshot booking = await FirebaseFirestore.instance.collection("booking").doc(id).get();




      // Delete the booking
      await FirebaseFirestore.instance.collection("booking").doc(id).delete();

      // Remove the seats from the flightBookedSeats collection
      try {
        final docRef = FirebaseFirestore.instance
            .collection('flightBookedSeats')
            .doc(flightNumber);

        await docRef.update({
          'bookedSeats': FieldValue.arrayRemove(seats.map((e) => e["seatNumber"]).toList()),
        });
        print("Seats removed from flightBookedSeats collection--------------------");
      } catch (e) {
        print(e);
        print("Error removing seats from flightBookedSeats collection");
      }

      return "Success";
    } catch (e) {
      print("--------------------------+++++++++++++++++++++++1 11 1");
      return "An Error occur";
    }
  }

  Future<bool> checkIfCollectionExists(String collectionName) async {
    final collectionRef = FirebaseFirestore.instance.collection(collectionName);
    final docSnapshot = await collectionRef.doc(flightNumber).get();

    return docSnapshot.exists;
  }

  Future<String> updateBookedFlight(List<String> newSeats) async {
    bool isExist = await checkIfCollectionExists("flightBookedSeats");
    print(isExist);
    print(isExist);
    if (isExist) {
      try {
        final docRef = FirebaseFirestore.instance
            .collection('flightBookedSeats')
            .doc(flightNumber);

        await docRef.update({
          'bookedSeats': FieldValue.arrayUnion(newSeats),

        });

        return "Success";
      } catch (e) {
        print("--------------------------+++++++++++++++++++++++1 11 1");
        return "An Error occur";
      }
    } else {
      try {
        await FirebaseFirestore.instance
            .collection('flightBookedSeats')
            .doc(flightNumber)
            .set({"bookedSeats": newSeats});

        return "Success";
      } catch (e) {
        print("--------------------------+++++++++++++++++++++++1 11 1");
        return "An Error occur";
      }
    }
  }

   getBookedSeats() async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('flightBookedSeats')
          .doc(flightNumber);

      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      } else {
        return null;
      }
    } catch (e) {
      print("--------------------------+++++++++++++++++++++++1 11 1");
      return null;
    }
  }
}
