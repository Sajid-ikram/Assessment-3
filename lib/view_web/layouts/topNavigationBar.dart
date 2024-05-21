import 'package:assessment_3/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Utils/app_colors.dart';
import '../../provider/drawerProvider.dart';


AppBar topNavigationBar(BuildContext context, GlobalKey<ScaffoldState> key) {
  var pro = Provider.of<ProfileProvider>(context, listen: false);
  return AppBar(
    elevation: 0,
    leading: Consumer<DrawerProvider>(
      builder: (context, provider, child) {
        return provider.screenNumber != 3 ? IconButton(
          onPressed: () {
            key.currentState!.openDrawer();
          },
          icon: Icon(Icons.menu),
        ) : Icon(Icons.admin_panel_settings);
      },
    ),

    title: Row(
      children: [
        Text(
          "Ealing Airline",
          style: TextStyle(
              color: lightGrey, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const Expanded(child: SizedBox()),


        Container(
          width: 1,
          height: 22,
          color: lightGrey,
        ),
        const SizedBox(
          width: 24,
        ),

        Consumer<ProfileProvider>(
          builder: (context, provider, child) {
            return GestureDetector(
              onTap: () {
                if (pro.profileName.isEmpty) {
                  Navigator.of(context).pushNamed("SignIn");
                }
              },
              child: Text(
                pro.profileName.isEmpty ? "SignIn" : pro.profileName,
                style: TextStyle(
                    color: lightGrey,
                    fontWeight: FontWeight.normal,
                    fontSize: 15),
              ),
            );
          },
        ),
        const SizedBox(
          width: 16,
        ),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            padding: EdgeInsets.all(2),
            margin: EdgeInsets.all(2),
            child: CircleAvatar(
              backgroundColor: light,
              child: const Icon(
                Icons.person_outline,

              ),
            ),
          ),
        )
      ],
    ),
    iconTheme: IconThemeData(color: dark),
    backgroundColor: Colors.transparent,
  );
}
