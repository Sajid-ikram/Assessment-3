import 'package:assessment_3/provider/drawerProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/flight_model.dart';
import '../../../provider/booking_provider.dart';
import '../../../repository/flight_repo.dart';
import '../../auth/widgets/snackBar.dart';
import '../add_flight.dart';

enum SampleItem { update, delete }

class SingleFlight extends StatelessWidget {
  const SingleFlight(
      {Key? key,
      required this.flight,
      required this.role,
      required this.reloadPage})
      : super(key: key);
  final FlightModel flight;
  final String role;
  final Function reloadPage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<DrawerProvider>(context, listen: false)
            .changeScreen("Booking");
        var pro = Provider.of<BookingProvider>(context, listen: false);
        pro.changeScreenNumber(1);
        pro.planeNumber = int.parse(flight.travelDuration ?? "1");
        pro.flightNumber = flight.flightNumber ?? "";
        pro.departureDate = flight.departureTime ?? "";
      },
      child: Container(
        width: 350.w,
        margin: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 10.h),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
        ),
        child: Column(
          children: [
            Container(
              color: Colors.grey.withOpacity(0.1),
              padding: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Flight Number: ${flight.flightNumber}",
                    style: TextStyle(
                      fontSize: kIsWeb ? 16 : 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (role == "admin") const Spacer(),
                  if (role == "admin")
                    PopupMenuButton<SampleItem>(
                      onSelected: (SampleItem item) async {
                        if (item == SampleItem.update) {
                          snackBar(context, "Not Implemented Yet");
                        } else {
                          bool response =
                              await FlightRepo().deleteFlight(flight.id ?? "");
                          if (response) {
                            reloadPage(true);
                          } else {
                            snackBar(context, "Fail to delete flight");
                          }
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<SampleItem>>[
                        const PopupMenuItem<SampleItem>(
                          value: SampleItem.update,
                          child: Text('Update'),
                        ),
                        const PopupMenuItem<SampleItem>(
                          value: SampleItem.delete,
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.only(right: kIsWeb ? 15 : 15.w),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                flight.start ?? "",
                                style: TextStyle(
                                  fontSize: kIsWeb ? 16 : 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                convertDateTimeToString(
                                    flight.departureTime ?? ""),
                                style: TextStyle(
                                  fontSize: kIsWeb ? 14 : 8.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: kIsWeb ? 20 : 10.w),
                          Column(
                            children: [
                              Text(
                                "${DateTime.parse(flight.arrivalTime!).difference(DateTime.parse(flight.departureTime!)).inHours}h ${DateTime.parse(flight.arrivalTime!).difference(DateTime.parse(flight.departureTime!)).inMinutes}m",
                                style: TextStyle(
                                  fontSize: kIsWeb ? 14 : 10.sp,
                                  color: Colors.grey,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.plane,
                                    size: kIsWeb ? 18 : 12.sp,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    kIsWeb
                                        ? "---------------------------------------------"
                                        : "--------",
                                    style: TextStyle(
                                      fontSize: kIsWeb ? 14 : 14.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Icon(
                                    FontAwesomeIcons.circle,
                                    size: kIsWeb ? 14 : 10.sp,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(width: kIsWeb ? 20 : 10.w),
                          Column(
                            children: [
                              Text(
                                flight.destination ?? "",
                                style: TextStyle(
                                  fontSize: kIsWeb ? 16 : 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                convertDateTimeToString(
                                    flight.arrivalTime ?? ""),
                                style: TextStyle(
                                  fontSize: kIsWeb ? 14 : 8.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ],
            ),
            SizedBox(height: 14.h),
          ],
        ),
      ),
    );
  }
}

String convertDateTimeToString(String inputString,
    {String outputFormat = 'yyyy-MM-dd HH:mm'}) {
  try {
    DateTime datetimeObj = DateTime.parse(inputString);
    return DateFormat(outputFormat).format(datetimeObj);
  } catch (ValueError) {
    print(
        "Invalid input format. Please provide a string in ISO 8601 format (YYYY-MM-DDTHH:MM:SS).");
    return ""; // Or throw an exception if you prefer
  }
}
