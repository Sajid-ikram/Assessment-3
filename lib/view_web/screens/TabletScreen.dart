import 'package:assessment_3/view_web/drawer/screenSelector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/drawerProvider.dart';

class TabletScreen extends StatefulWidget {
  const TabletScreen({Key? key}) : super(key: key);

  @override
  _TabletScreenState createState() => _TabletScreenState();
}

class _TabletScreenState extends State<TabletScreen> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<DrawerProvider>(context, listen: false).changeShow(2);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        screenSelector(1, context),
      ],
    );
  }
}
