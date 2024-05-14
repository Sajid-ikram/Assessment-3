import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Utils/custom_loading.dart';
import '../../models/flight_model.dart';
import '../../provider/profile_provider.dart';
import '../../repository/flight_repo.dart';
import '../Auth/widgets/custom_button.dart';
import '../auth/widgets/snackBar.dart';
import 'package:http/http.dart' as http;

class AddFlight extends StatefulWidget {
  AddFlight({Key? key, this.flight, this.reloadPage}) : super(key: key);

  FlightModel? flight;
  Function? reloadPage;

  @override
  State<AddFlight> createState() => _AddFlightState();
}

class _AddFlightState extends State<AddFlight> {
  late TextEditingController flightNumberController;
  late TextEditingController startController;
  late TextEditingController destinationController;
  late TextEditingController departureTimeController;
  late TextEditingController arrivalTimeController;
  late TextEditingController travelDurationController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    flightNumberController = TextEditingController(
        text: widget.flight != null ? widget.flight!.flightNumber : "");
    startController = TextEditingController(
        text: widget.flight != null ? widget.flight!.start : "");
    destinationController = TextEditingController(
        text: widget.flight != null ? widget.flight!.destination : "");
    departureTimeController = TextEditingController(
        text: widget.flight != null ? widget.flight!.departureTime : "");
    arrivalTimeController = TextEditingController(
        text: widget.flight != null ? widget.flight!.arrivalTime : "");
    travelDurationController = TextEditingController(
        text: widget.flight != null ? widget.flight!.travelDuration : "");

    super.initState();
  }

  validate() async {
    if (_formKey.currentState!.validate()) {
      buildLoadingIndicator(context);
      try {
        bool response = false;

        if (widget.flight == null) {
          response = await FlightRepo().createFlight({
            "flightNumber": flightNumberController.text,
            "start": startController.text,
            "destination": destinationController.text,
            "departureTime": departureTimeController.text,
            "arrivalTime": arrivalTimeController.text,
            "travelDuration": travelDurationController.text,
          });
        } else {
          /*response = await FlightRepo().updateFlight(
              pro.profileName,
              descriptionController.text,
              url.isEmpty ? widget.flight!.imageUrl ?? "" : url,
              widget.flight!.sId ?? "");
          if (response) {
            widget.reloadPage!(true);
          }*/
        }

        Navigator.of(context).pop();
        Navigator.of(context).pop();

        if (!response) {
          snackBar(context,
              "Fail to ${widget.flight == null ? "add" : "update"} flight");
        }
      } catch (e) {
        Navigator.of(context, rootNavigator: true).pop();
        snackBar(context, "Some error occur");
      }
    } else {
      snackBar(context, "Enter description");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.close,
                      size: kIsWeb ? 30 : 30.sp,
                    )),
                GestureDetector(
                  onTap: () {
                    validate();
                  },
                  child: customButton(
                      widget.flight == null ? "Create" : "Update",
                      isAddPage: 130),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Text("Flight Details",
              style: GoogleFonts.inter(
                  fontSize: kIsWeb ? 30 : 30.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          SizedBox(
            width: kIsWeb ? 700 : 340.w,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  buildTextField(flightNumberController, "Flight Number"),
                  buildTextField(startController, "Start"),
                  buildTextField(destinationController, "Destination"),
                  GestureDetector(
                    onTap: (){
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2025),

                      ).then((value) {
                        if(value != null){
                          departureTimeController.text = value.toString();
                        }
                      });
                    },
                    child: buildTextField(
                        departureTimeController, "Departure Time and Date",enabled: false),
                  ),
                  buildTextField(
                      arrivalTimeController, "Arrival Time and Date"),
                  buildTextField(travelDurationController, "Travel Duration"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Padding buildTextField(TextEditingController controller, String text,
    {int maxLine = 1, bool enabled = true}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(32, 30, 32, 0),
    child: TextField(
      enabled: enabled,
      maxLines: maxLine,
      style: const TextStyle(color: Colors.black),
      controller: controller,
      decoration: InputDecoration(
        fillColor: Color(0xffC4C4C4).withOpacity(0.2),
        filled: true,
        hintText: text,
        hintStyle: GoogleFonts.inter(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          // Set desired corner radius
          borderSide: BorderSide.none, // Set border color (optional)
        ),
      ),
    ),
  );
}
