import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/booking_provider.dart';
import '../Auth/widgets/custom_button.dart';
import '../Auth/widgets/snackBar.dart';

class Plane1 extends StatefulWidget {
  @override
  _Plane1State createState() => _Plane1State();
}

class _Plane1State extends State<Plane1> {
  final int rows1 = 3;
  final int rows2 = 19;
  final int rows3 = 20;
  final int columns1 = 4;
  final int columns2 = 6;
  final int columns3 = 4;
  final List<List<bool>> seatStatus =
      List.generate(20, (index) => List.filled(6, false));

  /*void toggleSeat(int row, int column) {
    setState(() {
      seatStatus[row][column] = !seatStatus[row][column];
    });
  }*/

  void toggleSeat(int row, int column) {
    var pro = Provider.of<BookingProvider>(context, listen: false);

    // Check if the selected seat is already booked

    // Check if booking this seat would leave a single empty seat between two booked seats
    if (row > 2 && row < 20) {
      if (column == 1 || column == 4) {
        if (seatStatus[row][column - 1] || seatStatus[row][column + 1]) {
          setState(() {
            if (!seatStatus[row][column]) {
              if (pro.totalSeatSelected ==
                  (pro.adults + pro.teenagers + pro.babies)) {
                snackBar(context, 'You have selected all the seats you need.');
                return;
              }
              pro.totalSeatSelected++;
            } else {
              if (seatStatus[row][column - 1] && seatStatus[row][column + 1]) {
                snackBar(context,
                    'You can not unselect this seat as it would leave simple empty seats between two booked seats');
                return;
              } else {
                pro.totalSeatSelected--;
              }
            }
            seatStatus[row][column] = !seatStatus[row][column];
          });
        } else {
          snackBar(context,
              'Cannot book this seat as it would leave two simple empty seats');
          return;
        }
      }
      if (column == 0 || column == 3) {
        if (seatStatus[row][column + 2] && !seatStatus[row][column + 1]) {
          snackBar(context,
              'Cannot book this seat as it would leave simple empty seats in between two booked seats');
          return;
        } else {
          setState(() {
            if (!seatStatus[row][column]) {
              if (pro.totalSeatSelected ==
                  (pro.adults + pro.teenagers + pro.babies)) {
                snackBar(context, 'You have selected all the seats you need.');
                return;
              }
              pro.totalSeatSelected++;
            } else {
              if (seatStatus[row][column + 1] && !seatStatus[row][column + 2]) {
                snackBar(context,
                    'You can not unselect this seat as it would leave simple empty seats between two booked seats');
                return;
              } else {
                pro.totalSeatSelected--;
              }
            }
            seatStatus[row][column] = !seatStatus[row][column];
          });
        }
      }

      if (column == 2 || column == 5) {
        if (seatStatus[row][column - 2] && !seatStatus[row][column - 1]) {
          snackBar(context,
              'Cannot book this seat as it would leave simple empty seats in between two booked seats');
          return;
        } else {
          setState(() {
            if (!seatStatus[row][column]) {
              if (pro.totalSeatSelected ==
                  (pro.adults + pro.teenagers + pro.babies)) {
                snackBar(context, 'You have selected all the seats you need.');
                return;
              }
              pro.totalSeatSelected++;
            } else {
              if (seatStatus[row][column - 1] && !seatStatus[row][column - 2]) {
                snackBar(context,
                    'You can not unselect this seat as it would leave simple empty seats between two booked seats');
                return;
              } else {
                pro.totalSeatSelected--;
              }
            }
            seatStatus[row][column] = !seatStatus[row][column];
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.center,
                child: Text("Select Your Seats",
                    style: GoogleFonts.inter(
                        fontSize: kIsWeb ? 25 : 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          Provider.of<BookingProvider>(context, listen: false)
                              .changeScreenNumber(2);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: kIsWeb ? 30 : 25.sp,
                        )),
                    GestureDetector(
                      onTap: () {
                        Provider.of<BookingProvider>(context, listen: false)
                            .changeScreenNumber(4);
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
              SizedBox(height: 20.h),
              for (int row = 0; row < rows1; row++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int col = 0; col < columns1; col++)
                      GestureDetector(
                        onTap: () => toggleSeat(row, col),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(
                              4,
                              4,
                              col == 1
                                  ? kIsWeb
                                      ? 50
                                      : 30.sp
                                  : 4,
                              4),
                          width: 40,
                          height: 50,
                          decoration: BoxDecoration(
                            color: seatStatus[row][col]
                                ? Colors.green
                                : Color(0xff3278CA),
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              '${row + 1}${String.fromCharCode(65 + col)}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              buildExit(text: "Restroom", padding: 20, width: 170),
              for (int row = 3; row < rows2; row++)
                Column(
                  children: [
                    if (row == 9) buildExit(padding: 10, text: "Exit"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int col = 0; col < columns2; col++)
                          GestureDetector(
                            onTap: () => toggleSeat(row, col),
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  4,
                                  4,
                                  col == 2
                                      ? kIsWeb
                                          ? 50
                                          : 30.sp
                                      : 4,
                                  4),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: seatStatus[row][col]
                                    ? Colors.green
                                    : row < 8
                                        ? Color(0xffFF8839)
                                        : Color(0xff3FB8B9),
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  '${row + 1}${String.fromCharCode(65 + col)}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              for (int row = 19; row < rows3; row++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int col = 0; col < columns3; col++)
                      GestureDetector(
                        onTap: () => toggleSeat(row, col),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(
                              4,
                              4,
                              col == 1
                                  ? kIsWeb
                                      ? 50
                                      : 30.sp
                                  : 4,
                              4),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: seatStatus[row][col]
                                ? Colors.green
                                : Color(0xff3FB8B9),
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              '${row + 1}${String.fromCharCode(65 + col)}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
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

Padding buildExit({String? text, double padding = 20, double? width}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: padding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.arrow_back_ios),
        Text("Exit"),
        SizedBox(width: width ?? 200),
        Text("$text   " ?? "Exit"),
        text == "Restroom"
            ? Icon(FontAwesomeIcons.restroom)
            : Icon(Icons.arrow_forward_ios),
      ],
    ),
  );
}
