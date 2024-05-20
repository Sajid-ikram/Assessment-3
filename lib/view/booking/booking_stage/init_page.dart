import 'package:assessment_3/view/booking/booking_landing_page.dart';
import 'package:assessment_3/view/booking/booking_stage/number_of_passenger1.dart';
import 'package:assessment_3/view/booking/booking_stage/passengers_details2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/booking_provider.dart';
import '../plane1.dart';
import '../plane2.dart';

class InitPage extends StatelessWidget {
  const InitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<BookingProvider>(
      builder: (context, provider, child) {
        switch (provider.screenNumber) {
          case 1:
            {
              return NumberOfPassenger();
            }
          case 2:
            {
              return PassengersDetails();
            }

          case 3:
            {
              return provider.planeNumber == 2 ? Plane2() : Plane1();
            }
          default:
            {
              return BookingLandingPage();
            }
        }
      },
    ));
  }
}
