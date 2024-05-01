import 'package:assessment_3/view_web/drawer/screenSelector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/drawerProvider.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({Key? key}) : super(key: key);

  @override
  _MobileScreenState createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<DrawerProvider>(context, listen: false).changeShow(1);
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
