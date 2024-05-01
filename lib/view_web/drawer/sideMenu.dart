import 'package:assessment_3/Utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../provider/drawerProvider.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  List<String> menuItems = [
    "Dashboard",
    "Flights",
    "Tickets",
    "Customers",
    "Statistics",
    "Logout"
  ];

  List<Widget> menuIcons = [
    Icon(Icons.dashboard, color: primaryColor),
    Icon(FontAwesomeIcons.planeDeparture, color: primaryColor),
    Icon(FontAwesomeIcons.ticket, color: primaryColor),
    Icon(FontAwesomeIcons.userGroup, color: primaryColor),
    Icon(FontAwesomeIcons.chartSimple, color: primaryColor),
    Icon(FontAwesomeIcons.rightFromBracket, color: primaryColor),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Center(
          child: GestureDetector(
            onTap: () {
              Provider.of<DrawerProvider>(context, listen: false)
                  .changeScreen(menuItems[index]);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                  ),
                  menuIcons[index],
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    menuItems[index],
                    style: TextStyle(color: secondaryColor),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: menuItems.length,
    );
  }
}
