
import 'package:assessment_3/Utils/app_colors.dart';
import 'package:assessment_3/view/flight/widgets/single_flight.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Utils/custom_loading.dart';
import '../../models/flight_model.dart';
import '../../provider/profile_provider.dart';
import '../../repository/flight_repo.dart';
import 'add_flight.dart';


class Flight extends StatefulWidget {
  const Flight({Key? key}) : super(key: key);

  @override
  State<Flight> createState() => _FlightState();
}

class _FlightState extends State<Flight> {
  late ScrollController scrollController;
  bool isLoading = false;
  bool hasMore = true;
  List<FlightModel> listOfFlight = [];
  bool isAddScreen = true;

  @override
  void initState() {
    super.initState();
    getData(false);

    scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent * 0.95 &&
          !isLoading) {
        if (hasMore) {
          getData(false);
        }
      }
    });
  }

  getData(bool refresh) async {
    if (refresh) {
      hasMore = true;
      listOfFlight.clear();
    }
    setState(() {
      isLoading = true;
    });
    var response = await FlightRepo().getFlight(listOfFlight.length);
    listOfFlight.addAll(response);
    setState(() {
      isLoading = false;
      hasMore = response.isNotEmpty;
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return isAddScreen? AddFlight() : Scaffold(

      floatingActionButton: pro.role == "admin"
          ? FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () {
                setState(() {
                  isAddScreen = true;
                });
              },
              child: const Icon(Icons.add, color: Colors.white,),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          controller: scrollController,
          itemBuilder: (context, index) {
            if (index == listOfFlight.length && isLoading) {
              return buildThreeInOutLoadingWidget();
            }
            if (index == listOfFlight.length && !isLoading) {
              return SizedBox();
            }
            return SingleFlight(
              flight: listOfFlight[index],
              role: pro.role,
              reloadPage: getData,
            );
          },
          itemCount: listOfFlight.length + (hasMore ? 1 : 0),
        ),
      ),
    );
  }
}
