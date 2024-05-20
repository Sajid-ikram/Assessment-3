import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  void toggleSeat(int row, int column) {
    setState(() {
      seatStatus[row][column] = !seatStatus[row][column];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(seatStatus);
    return Scaffold(

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              buildExit(),
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
                    if(row == 15 || row == 14)   buildExit(text: "Emergency Exit", padding: 10, width: 90),
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
                              onTap: () =>
                                  col == 0 ? null : toggleSeat(row, col),
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
                                  color: seatStatus[row][col]
                                      ? Colors.green
                                      : col == 0
                                          ? Color(0xff153448)
                                          : Colors.grey.withOpacity(0.2),
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: col == 0
                                      ? null
                                      : Text(
                                          '${row + 1}${String.fromCharCode(65 + col)}',
                                          style: TextStyle(color: Colors.black),
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
    return  Padding(
      padding:  EdgeInsets.symmetric(vertical: padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.arrow_back_ios),
          Text(text ?? "Exit"),
           SizedBox(width: width??  200),
          Text(text ?? "Exit"),
          const Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
