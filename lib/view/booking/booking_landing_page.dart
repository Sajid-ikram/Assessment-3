import 'dart:ui';
import 'package:assessment_3/provider/booking_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Utils/custom_loading.dart';
import '../../../provider/profile_provider.dart';
import '../Auth/widgets/snackBar.dart';

enum WhyFarther { cancel, edit }

class BookingLandingPage extends StatefulWidget {
  const BookingLandingPage({Key? key}) : super(key: key);

  @override
  State<BookingLandingPage> createState() => _BookingLandingPageState();
}

class _BookingLandingPageState extends State<BookingLandingPage> {
  int size = 0;

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("booking")
            .where('userId',
                isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? "")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot);
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildLoadingWidget();
          }

          final data = snapshot.data;
          if (data != null) {
            size = data.size;
          }

          if (size == 0) {
            return const Center(
                child: Text(
              'You Have Not Booked Any Flight Yet!',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ));
          }
          return ListView.builder(
            padding: EdgeInsets.only(top: 20.h),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Ticket(
                adults: data?.docs[index]["adults"],
                teenagers: data?.docs[index]["teenagers"],
                id: data?.docs[index].id ?? "",
                babies: data?.docs[index]["babies"],
                flightNumber: data?.docs[index]["flightNumber"],
                departureTime: data?.docs[index]["departureDate"],
                selectedSeats: (data?.docs[index]["selectedSeats"] as List)
                    .map((item) => Map<String, String>.from(item))
                    .toList(),
              );
              /*return Container(
                width: 350.w,
                margin: EdgeInsets.fromLTRB(32.w, 10.h, 32.w, 10.h),
                padding: EdgeInsets.fromLTRB(20.w, 21.h, 5, 20.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xffE3E3E3), width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      data?.docs[index]["flightNumber"],
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.inter(fontSize: 15.sp, height: 1.4),
                    ),
                  ),
                ),
              );*/
            },
            itemCount: size,
          );
        },
      ),
    );
  }
}

class Ticket extends StatelessWidget {
  final int adults;
  final int teenagers;
  final int babies;
  final String flightNumber;
  final String id;
  final String departureTime;
  final List<Map<String, String>> selectedSeats;

  Ticket({
    required this.adults,
    required this.teenagers,
    required this.id,
    required this.babies,
    required this.flightNumber,
    required this.selectedSeats,
    required this.departureTime,
  });

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    var pro2 = Provider.of<BookingProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      color: Colors.grey.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.grey.withOpacity(0.1),
            padding: EdgeInsets.only(left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Flight Number: $flightNumber",
                    style:  TextStyle(
                        fontSize: kIsWeb? 20 : 14.sp, fontWeight: FontWeight.bold)),
                const Spacer(),
                PopupMenuButton<WhyFarther>(
                  onSelected: (WhyFarther item) async {
                    if (item == WhyFarther.cancel) {
                      if (DateTime.parse(departureTime)
                              .difference(DateTime.now())
                              .inHours >
                          72) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Are you sure?'),
                              content:
                                  Text('Do you want to cancel your booking?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    pro2.deleteBooking(
                                        id, selectedSeats, flightNumber);
                                    Navigator.of(context).pop();
                                    snackBar(context,
                                        "Your booking has been cancelled successfully! Payment will be refunded within 7 working days.");
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        snackBar(context, "you can not cancel it");
                      }
                    } else {
                      snackBar(context, "Not Implemented Yet");
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<WhyFarther>>[
                    const PopupMenuItem<WhyFarther>(
                      value: WhyFarther.cancel,
                      child: Text('Cancel'),
                    ),
                    const PopupMenuItem<WhyFarther>(
                      value: WhyFarther.edit,
                      child: Text('Edit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text('Adults: $adults'),
          Text('Teenagers: $teenagers'),
          Text('Babies: $babies'),
          SizedBox(height: 10),
          Text(
            'Seats:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Column(
            children: selectedSeats.map((seat) {
              return Text('Seat Number: ${seat['seatNumber']}');
            }).toList(),
          ),
          Text(
            "Remaining time to departure: ${DateTime.parse(departureTime).difference(DateTime.now()).inDays} days and ${DateTime.parse(departureTime).difference(DateTime.now()).inHours - (DateTime.parse(departureTime).difference(DateTime.now()).inDays * 24)} hours",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          if (DateTime.parse(departureTime).difference(DateTime.now()).inHours <
              72)
            const Text(
              "This flight cannot be cancelled within 72 hours of departure due to airline policy.",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent),
            ),
        ],
      ),
    );
  }
}
