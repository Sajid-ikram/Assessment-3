import 'package:assessment_3/provider/booking_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../provider/drawerProvider.dart';
import '../../Auth/widgets/custom_button.dart';
import '../../Auth/widgets/snackBar.dart';

class NumberOfPassenger extends StatefulWidget {
  @override
  _NumberOfPassengerState createState() => _NumberOfPassengerState();
}

class _NumberOfPassengerState extends State<NumberOfPassenger> {
  final _formKey = GlobalKey<FormState>();
  int adults = 0;
  int teenagers = 0;
  int babies = 0;
  final int maxPassengers = 6;

  void _validateAndSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // Proceed with booking logic
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Proceeding with booking...')));
    }
  }

  @override
  void initState() {
    adults = Provider.of<BookingProvider>(context, listen: false).adults;

    teenagers = Provider.of<BookingProvider>(context, listen: false).teenagers;

    babies = Provider.of<BookingProvider>(context, listen: false).babies;
    super.initState();
  }

  int get totalPassengers => adults + teenagers + babies;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Are you sure?'),
                                    content: Text('Do you want to cancel and leave this page?'),
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
                                          Provider.of<BookingProvider>(context,
                                              listen: false)
                                              .changePassengers(0, 0, 0);
                                          Provider.of<BookingProvider>(context,
                                              listen: false)
                                              .changeScreenNumber(0);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );

                            },
                            child: Icon(
                              Icons.close,
                              size: kIsWeb ? 30 : 25.sp,
                            )),
                        SizedBox(
                          width: 350,
                        ),
                        GestureDetector(
                          onTap: () {
                            print(
                                "adults + teenagers + babies ${adults + teenagers + babies}");
                            if (adults + teenagers + babies > 0 &&
                                adults + teenagers + babies <= 6) {
                              Provider.of<BookingProvider>(context,
                                      listen: false)
                                  .changePassengers(adults, teenagers, babies);
                              Provider.of<BookingProvider>(context,
                                      listen: false)
                                  .changeScreenNumber(2);
                            } else {
                              snackBar(context,
                                  "Passenger must be greater than 0 and less than 6");
                            }
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
                  Text("Number of Passengers",
                      style: GoogleFonts.inter(
                          fontSize: kIsWeb ? 25 : 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  SizedBox(height: 30),
                  SizedBox(
                    width: kIsWeb ? 500 : 340.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PassengerDropdown(
                            label: 'Adults',
                            value: adults,
                            onChanged: (val) => setState(() => adults = val)),
                        SizedBox(height: 20),
                        PassengerDropdown(
                            label: 'Teenagers',
                            value: teenagers,
                            onChanged: (val) =>
                                setState(() => teenagers = val)),
                        SizedBox(height: 20),
                        PassengerDropdown(
                            label: 'Babies',
                            value: babies,
                            onChanged: (val) => setState(() => babies = val)),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text("Maximum Limit is 6 passengers",
                      style: GoogleFonts.inter(
                          fontSize: kIsWeb ? 18 : 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey)),
                  SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PassengerDropdown extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  PassengerDropdown(
      {required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        DropdownButtonFormField<int>(
          value: value,
          items: List.generate(7,
              (index) => DropdownMenuItem(value: index, child: Text('$index'))),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          validator: (val) {
            if (val == null) return 'Select a number';
            return null;
          },
          onChanged: (int? value) {
            onChanged(value ?? 0);
          },
        ),
      ],
    );
  }
}
