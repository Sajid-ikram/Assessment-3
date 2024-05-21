import 'package:assessment_3/provider/profile_provider.dart';
import 'package:assessment_3/view_web/layouts/topNavigationBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Utils/app_colors.dart';
import '../../provider/drawerProvider.dart';
import '../drawer/sideMenu.dart';
import '../screens/MobileScreen.dart';
import '../screens/TabletScreen.dart';
import '../screens/WebScreen.dart';

const int lageScreenSize = 1366;
const int mediumScreenSize = 768;

class SiteLayout extends StatefulWidget {
  SiteLayout({Key? key}) : super(key: key);

  @override
  State<SiteLayout> createState() => _SiteLayoutState();
}

class _SiteLayoutState extends State<SiteLayout> {

  @override
  void initState() {
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<DrawerProvider>(context, listen: false);
    return Scaffold(
      key: pro.scaffoldKey,
      appBar: topNavigationBar(context, pro.scaffoldKey),
      drawer: Drawer(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Image.asset(
                "assets/plane.png",
                fit: BoxFit.cover,
                height:  kIsWeb ? 200 :200.w,
                width: kIsWeb ? 200 :200.w,
              ),
              Text(
                "Ealing Airline",
                style: TextStyle(
                    color: lightGrey, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(
                height: kIsWeb ? 20 :10.h,
              ),
              Expanded(child: SideMenu()),
            ],
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constrains) {
          double _width = constrains.maxWidth;
          print(_width);
          if (_width >= lageScreenSize) {
            return WebScreen();
          } else if (_width >= mediumScreenSize) {
            return TabletScreen();
          } else {
            return MobileScreen();
          }
        },
      ),
    );
  }
}
