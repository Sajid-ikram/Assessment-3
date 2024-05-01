import 'package:assessment_3/view_web/drawer/screenSelector.dart';
import 'package:assessment_3/view_web/drawer/sideMenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/drawerProvider.dart';


class WebScreen extends StatefulWidget {
  const WebScreen({Key? key}) : super(key: key);

  @override
  _WebScreenState createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DrawerProvider>(context, listen: false)
          .changeShow(3);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Expanded(child: SideMenu()),
        screenSelector(6, context),
      ],
    );
  }

}
