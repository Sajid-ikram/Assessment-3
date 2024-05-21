import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Utils/custom_loading.dart';
import '../../../provider/profile_provider.dart';
import '../../Auth/widgets/snackBar.dart';

enum WhyFarther { delete, edit }

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
      body: Align(
          alignment: Alignment.bottomCenter,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("notice")
                .orderBy('dateTime', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("Something went wrong"));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return buildLoadingWidget();
              }

              final data = snapshot.data;
              if (data != null) {
                size = data.size;
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    width: 350.w,
                    margin: EdgeInsets.fromLTRB(32.w, 10.h, 32.w, 10.h),
                    padding: EdgeInsets.fromLTRB(20.w, 21.h, 5, 20.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border:
                      Border.all(color: const Color(0xffE3E3E3), width: 1),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [

                            if (pro.currentUserUid ==
                                data?.docs[index]["ownerUid"])
                              Positioned(
                                right: 0,
                                child: PopupMenuButton<WhyFarther>(
                                  icon: const Icon(Icons.more_horiz),
                                  padding: EdgeInsets.zero,
                                  onSelected: (WhyFarther result) {
                                    snackBar(context, "Not implemented yet");
                                  },
                                  itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<WhyFarther>>[
                                    const PopupMenuItem<WhyFarther>(
                                      value: WhyFarther.delete,
                                      child: Text('Delete'),
                                    ),
                                    const PopupMenuItem<WhyFarther>(
                                      value: WhyFarther.edit,
                                      child: Text('Edit'),
                                    ),
                                  ],
                                ),
                              )
                          ],
                        ),
                        SizedBox(height: 18.h),
                        Padding(
                          padding: EdgeInsets.only(right: 15.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              data?.docs[index]["postText"],
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.inter(
                                  fontSize: 15.sp, height: 1.4),
                            ),
                          ),
                        ),

                      ],
                    ),
                  );
                },
                itemCount: size,
              );
            },
          )),
    );
  }
}

Future<void> _showMyDialog(BuildContext context, String id) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Notice'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Do you want to delete this notice'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
