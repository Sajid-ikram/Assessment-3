import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/app_colors.dart';
import '../Auth/widgets/custom_button.dart';
import '../Auth/widgets/snackBar.dart';
import 'add_flight.dart';

class FlightFilter extends StatefulWidget {
  @override
  _FlightFilterState createState() => _FlightFilterState();
}

class _FlightFilterState extends State<FlightFilter> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _startLocation = TextEditingController();
  TextEditingController _destination = TextEditingController();

  DateTime? _date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(32, 30, 32, 0),
                      child: Text(
                        "Filter:",
                        style: TextStyle(
                          fontSize: kIsWeb ?26 : 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,

                        ),
                      )),
                  SizedBox(width: 250,child: buildTextField(_startLocation, "Start")),
                  SizedBox(width: 250,child: buildTextField(_destination, "Destination")),
                  GestureDetector(
                    onTap: () {
                      snackBar(context, "Not Implemented Yet");
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(32, 30, 32, 0),
                      height: kIsWeb ? 50 : 50.sp,
                      width: 200,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Text(
                            "Select Date",
                            style: TextStyle(
                              fontSize: kIsWeb ?14 : 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,

                            ),
                          )),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      snackBar(context, "Not Implemented Yet");
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(32, 30, 32, 0),
                      height: kIsWeb ? 50 : 50.sp,
                      width: 200,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Text(
                            "Search",
                            style: TextStyle(
                              fontSize: kIsWeb ?14 : 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,

                            ),
                          )),
                    ),
                  ),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
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