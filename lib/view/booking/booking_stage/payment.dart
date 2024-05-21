import 'dart:io';
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

import '../../../provider/booking_provider.dart';
import '../../Auth/widgets/custom_button.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController testController = TextEditingController();

  bookTicket() {
    var pro = Provider.of<BookingProvider>(context, listen: false);
    pro.bookFlight();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                          .changeScreenNumber(3);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: kIsWeb ? 30 : 25.sp,
                    )),
                GestureDetector(
                  onTap: () {
                    bookTicket();
                  },
                  child: customButton(
                    "Book",
                    isAddPage: kIsWeb ? 130 : 80.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          Text("Flight Details",
              style: GoogleFonts.inter(
                  fontSize: kIsWeb ? 30 : 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          SizedBox(
            width: kIsWeb ? 700 : 340.w,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  buildTextField(testController, "Flight Number"),
                ],
              ),
            ),
          ),
        ],
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
