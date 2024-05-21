import 'package:assessment_3/View/Auth/widgets/snackBar.dart';
import 'package:assessment_3/view/Auth/widgets/custom_button.dart';
import 'package:assessment_3/view/Auth/widgets/switch_page.dart';
import 'package:assessment_3/view/Auth/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../Provider/auth_provider.dart';
import '../../Utils/custom_loading.dart';
import '../../provider/drawerProvider.dart';
import '../Auth/forgot_password.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          if (size.width >= 900)
            Image.asset("assets/home.jpg",
                fit: BoxFit.cover, height: size.height, width: size.width),


          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(kIsWeb) Spacer(
                  flex: size.width >= 900 ? 5 : 1
              ),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  height: kIsWeb ? 800 : 790.h,
                  width: kIsWeb ? 500 : 320.w,
                  child: Padding(
                    padding: EdgeInsets.all(30.sp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (!kIsWeb)
                          Image.asset(
                            "assets/dashboard2.jpg",
                            fit: BoxFit.contain,
                          ),
                        SizedBox(height: 45.h),

                        Text(
                          "Welcome to Ealing Airline",
                          style: TextStyle(
                            fontSize: kIsWeb ? 30 : 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          "Book your flight with us",
                          style: TextStyle(
                            fontSize: kIsWeb ? 20 : 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        GestureDetector(
                          onTap: () {
                            Provider.of<DrawerProvider>(context, listen: false)
                                .changeScreen("Flights");
                          },
                          child: SizedBox(width: 170,child: customButton("Book a flight")),
                        ),

                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
