import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Utils/custom_loading.dart';
import '../../provider/booking_provider.dart';
import '../Auth/widgets/custom_button.dart';
import '../Auth/widgets/snackBar.dart';

class Plane2 extends StatefulWidget {
  @override
  _Plane2State createState() => _Plane2State();
}

class _Plane2State extends State<Plane2> {
  final int rows1 = 4;
  final int rows2 = 32;
  final int rows3 = 33;
  final int columns1 = 4;
  final int columns2 = 6;
  final int columns3 = 6;
  final List<List<bool>> seatStatus =
      List.generate(35, (index) => List.filled(6, false));

  /*void toggleSeat(int row, int column) {
    setState(() {
      seatStatus[row][column] = !seatStatus[row][column];
    });
  }*/

  void toggleSeat(int row, int column) {
    var pro = Provider.of<BookingProvider>(context, listen: false);

    // Check if the selected seat is already booked

    // Check if booking this seat would leave a single empty seat between two booked seats
    if (row > 8 && row < 34) {
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
          pro.totalSeatSelected--;
        }
        seatStatus[row][column] = !seatStatus[row][column];
      });
    }
  }

  makePayment() {
    var pro = Provider.of<BookingProvider>(context, listen: false);
    if (pro.totalSeatSelected == (pro.adults + pro.teenagers + pro.babies)) {
      List<Map<String, String>> selectedSeats = [];
      for (int i = 0; i < 35; i++) {
        for (int j = 0; j < 6; j++) {
          if (seatStatus[i][j]) {
            selectedSeats.add({
              "row": "$i",
              "column": "$j",
              "seatNumber": "${i + 1}${String.fromCharCode(65 + j)}"
            });
          }
        }
      }
      pro.selectedSeats = selectedSeats;
      pro.changeScreenNumber(4);
    } else {
      snackBar(context, 'Please select all the seats you need');
    }
  }

  List<String> bookedSeats = [];
  bool isLoading = true;

  getExistingSeats() {
    try {
      var pro = Provider.of<BookingProvider>(context, listen: false);
      pro.getBookedSeats().then((value) {

        if(value == null){
          setState(() {
            isLoading = false;
          });
          return;
        }
        value["bookedSeats"].forEach((element) {
          bookedSeats.add(element);
        });

        for (int i = 0; i < 20; i++) {
          for (int j = 0; j < 6; j++) {
            if (bookedSeats
                .contains("${i + 1}${String.fromCharCode(65 + j)}")) {
              seatStatus[i][j] = true;
            }
          }
        }

        setState(() {
          isLoading = false;
        });
      });
    } catch (e) {
      print("Error getting booked seats ++++++++++++++++++++++++++++++");
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  @override
  void initState() {
    getExistingSeats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? buildLoadingWidget()
          : Center(
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
                                Provider.of<BookingProvider>(context,
                                        listen: false)
                                    .changeScreenNumber(2);
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: kIsWeb ? 30 : 25.sp,
                              )),
                          GestureDetector(
                            onTap: () {
                              makePayment();
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
                    buildExit(),
                    for (int row = 0; row < rows1; row++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int col = 0; col < columns1; col++)
                            GestureDetector(
                              onTap: () => bookedSeats.contains(
                                      "${row + 1}${String.fromCharCode(65 + col)}")
                                  ? snackBar(context, 'Seat already booked')
                                  : toggleSeat(row, col),
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
                                  color: bookedSeats.contains(
                                          "${row + 1}${String.fromCharCode(65 + col)}")
                                      ? Colors.grey
                                      : seatStatus[row][col]
                                          ? Colors.green
                                          : Colors.grey.withOpacity(0.2),
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    '${row + 1}${String.fromCharCode(65 + col)}',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    SizedBox(height: 20.h),
                    for (int row = 9; row < rows2; row++)
                      Column(
                        children: [
                          if (row == 15 || row == 14)
                            buildExit(
                                text: "Emergency Exit", padding: 10, width: 90),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int col = 0; col < columns2; col++)
                                GestureDetector(
                                  onTap: () => bookedSeats.contains(
                                          "${row + 1}${String.fromCharCode(65 + col)}")
                                      ? snackBar(context, 'Seat already booked')
                                      : toggleSeat(row, col),
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
                                      color: bookedSeats.contains(
                                              "${row + 1}${String.fromCharCode(65 + col)}")
                                          ? Colors.grey
                                          : seatStatus[row][col]
                                              ? Colors.green
                                              : Colors.grey.withOpacity(0.2),
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${row + 1}${String.fromCharCode(65 + col)}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    for (int row = 32; row < rows3; row++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int col = 0; col < columns3; col++)
                            (col == 1 || col == 2)
                                ? SizedBox()
                                : GestureDetector(
                                    onTap: () => bookedSeats.contains(
                                            "${row + 1}${String.fromCharCode(65 + col)}")
                                        ? snackBar(
                                            context, 'Seat already booked')
                                        : col == 0
                                            ? null
                                            : toggleSeat(row, col),
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          4,
                                          4,
                                          col == 0
                                              ? kIsWeb
                                                  ? 50
                                                  : 30.sp
                                              : 4,
                                          4),
                                      width: col == 0 ? 132 : 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: bookedSeats.contains(
                                                "${row + 1}${String.fromCharCode(65 + col)}")
                                            ? Colors.grey
                                            : seatStatus[row][col]
                                                ? Colors.green
                                                : col == 0
                                                    ? Color(0xff153448)
                                                    : Colors.grey
                                                        .withOpacity(0.2),
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: col == 0
                                            ? null
                                            : Text(
                                                '${row + 1}${String.fromCharCode(65 + col)}',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                      ),
                                    ),
                                  ),
                        ],
                      ),
                    buildExit(),
                    SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Padding buildExit({String? text, double padding = 20, double? width}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.arrow_back_ios),
          Text(text ?? "Exit"),
          SizedBox(width: width ?? 200),
          Text(text ?? "Exit"),
          const Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
