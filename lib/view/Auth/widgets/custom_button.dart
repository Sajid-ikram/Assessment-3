import 'package:assessment_3/Utils/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

Widget customButton(String text, { double? isAddPage}) {
  return Container(
    margin: EdgeInsets.only(right: 2.w),
    height: kIsWeb ? 50 : 50.sp,
    width: isAddPage ?? double.infinity,
    decoration: BoxDecoration(
      color: secondaryColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
        child: Text(
      text,
      style: TextStyle(
        fontSize: kIsWeb ?14 : 14.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,

      ),
    )),
  );
}
