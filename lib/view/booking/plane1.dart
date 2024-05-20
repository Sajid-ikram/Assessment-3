import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                    if(row == 9)   buildExit(padding: 10, text: "Exit"),
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
        text == "Restroom" ? Icon(FontAwesomeIcons.restroom) : Icon(Icons.arrow_forward_ios),
      ],
    ),
  );
}
