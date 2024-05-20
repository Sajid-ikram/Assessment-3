import 'dart:io';
import 'package:assessment_3/provider/booking_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker/date_time_picker.dart';

import '../../../provider/drawerProvider.dart';
import '../../Auth/widgets/custom_button.dart';

class PassengersDetails extends StatefulWidget {
  @override
  State<PassengersDetails> createState() => _PassengersDetailsState();
}

class _PassengersDetailsState extends State<PassengersDetails> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController temporaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<BookingProvider>(context);
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 600,
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            Provider.of<BookingProvider>(context, listen: false)
                                .changeScreenNumber(1);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: kIsWeb ? 30 : 25.sp,
                          )),
                      GestureDetector(
                        onTap: () {
                          Provider.of<BookingProvider>(context, listen: false)
                              .changeScreenNumber(3);
                        },
                        child: customButton(
                          "Next",
                          isAddPage: kIsWeb ? 130 : 80.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: Text("Passengers Details",
                        style: GoogleFonts.inter(
                            fontSize: kIsWeb ? 30 : 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: Text(
                        "I'm not storing any passenger information to keep things simpler for this assignment.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            fontSize: kIsWeb ? 14 : 10.sp,
                            color: Colors.grey)),
                  ),
                ),
                SizedBox(height: 20.h),
                for (int i = 0; i < pro.adults; i++)
                  SizedBox(
                    width: kIsWeb ? 700 : 340.w,
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Text("Adult ${i + 1} Details:",
                                style: GoogleFonts.inter(
                                    fontSize: kIsWeb ? 20 : 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                          ),
                          buildTextField(temporaryController, "Title"),
                          buildTextField(temporaryController, "Fist name"),
                          buildTextField(temporaryController, "Last Name"),
                          buildTextField(temporaryController, "Nationality"),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 20.h),
                for (int i = 0; i < pro.teenagers; i++)
                  SizedBox(
                    width: kIsWeb ? 700 : 340.w,
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Text("Teenagers ${i + 1} Details:",
                                style: GoogleFonts.inter(
                                    fontSize: kIsWeb ? 20 : 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                          ),
                          buildTextField(temporaryController, "Title"),
                          buildTextField(temporaryController, "Fist name"),
                          buildTextField(temporaryController, "Last Name"),
                          buildTextField(temporaryController, "Nationality"),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 20.h),
                for (int i = 0; i < pro.babies; i++)
                  SizedBox(
                    width: kIsWeb ? 700 : 340.w,
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Text("Babies ${i + 1} Details:",
                                style: GoogleFonts.inter(
                                    fontSize: kIsWeb ? 20 : 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                          ),
                          buildTextField(temporaryController, "Fist name"),
                          buildTextField(temporaryController, "Last Name"),
                          buildTextField(temporaryController, "Nationality"),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 50.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding buildDateTimePicker(TextEditingController controller, String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 30, 32, 0),
      child: DateTimePicker(
        type: DateTimePickerType.dateTimeSeparate,
        dateMask: 'd MMM, yyyy',
        initialValue: DateTime.now().toString(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        icon: Text(text,
            style: GoogleFonts.inter(
                color: Colors.grey, fontSize: kIsWeb ? 17 : 12.sp)),
        dateLabelText: 'Date',
        timeLabelText: "Hour",
        style: TextStyle(color: Colors.black, fontSize: kIsWeb ? 17 : 12.sp),
        onChanged: (val) {
          controller.text = val ?? "";
        },
        validator: (val) {
          print(val);
          controller.text = val!;
          print("arrivalTimeController.text: ${controller.text}");
          return null;
        },
      ),
    );
  }
}

Padding buildTextField(TextEditingController controller, String text,
    {int maxLine = 1, bool enabled = true}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(32, 30, 32, 0),
    child: TextField(
      enabled: enabled,
      maxLines: maxLine,
      style: const TextStyle(color: Colors.black),
      controller: controller,
      decoration: InputDecoration(
        fillColor: Color(0xffC4C4C4).withOpacity(0.2),
        filled: true,
        hintText: text,
        hintStyle: GoogleFonts.inter(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          // Set desired corner radius
          borderSide: BorderSide.none, // Set border color (optional)
        ),
      ),
    ),
  );
}
