import 'package:assessment_3/provider/drawerProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/auth_provider.dart';
import '../../Utils/app_colors.dart';
import '../../View/home/home.dart';
import '../../view/Auth/widgets/custom_button.dart';
import '../../view/booking/booking_landing_page.dart';
import '../../view/booking/booking_stage/init_page.dart';
import '../../view/booking/booking_stage/number_of_passenger1.dart';
import '../../view/booking/plane1.dart';
import '../../view/booking/plane2.dart';
import '../../view/flight/flight.dart';

Widget screenSelector(int flx, BuildContext context) {
  var pro = Provider.of<DrawerProvider>(context, listen: false);
  return Expanded(
    flex: 6,
    child: Container(
      height: 1000,
      padding: const EdgeInsets.all(20),
      color: Colors.black12,
      child: Consumer<DrawerProvider>(
        builder: (context, provider, child) {
          if (pro.scaffoldKey.currentState!.isDrawerOpen) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              pro.scaffoldKey.currentState!.closeDrawer();
            });
          }
          switch (provider.screenName) {
            case "Dashboard":
              {
                return _buildContainer(provider.screenName);
              }
            case "Flights":
              {
                return const Flight();
              }
            case "Booking":
              {
                return InitPage();
              }
            case "Customers":
              {
                return _buildContainer(provider.screenName);
              }
            case "Statistics":
              {
                return _buildContainer(provider.screenName);
              }
            case "Logout":
              {
                return _logOutMethod(context);
              }
            case "AddProducts":
              {
                return _buildContainer(provider.screenName);
              }
            default:
              {
                return _buildContainer("Error");
              }
          }
        },
      ),
    ),
  );
}

Center _logOutMethod(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Do you want to Logout',
          style: TextStyle(
            color: primaryColor,
            fontSize: 26,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed("SignIn");
            Provider.of<Authentication>(context, listen: false).signOut();
          },
          child: customButton("SignIn"),
        ),
      ],
    ),
  );
}

Container _buildContainer(String name) => Container(
      child: Center(
        child: Text(name),
      ),
    );
