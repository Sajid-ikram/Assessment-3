import 'package:assessment_3/Utils/app_colors.dart';
import 'package:assessment_3/View/Auth/widgets/snackBar.dart';
import 'package:flutter/material.dart';

Widget customTextField(
    TextEditingController controller, String text, BuildContext context,
    {IconData? iconData}) {
  return Ctext(
    controller: controller,
    text: text,
    iconData: iconData,
  );
}

class Ctext extends StatefulWidget {
  Ctext({
    super.key,
    required this.controller,
    required this.text,
    this.iconData,
  });

  TextEditingController controller;
  String text;
  IconData? iconData;

  @override
  State<Ctext> createState() => _CtextState();
}

class _CtextState extends State<Ctext> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextFormField(
        controller: widget.controller,
        keyboardAppearance: Brightness.light,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: widget.text,
          fillColor: Color(0xffC4C4C4).withOpacity(0.2),
          filled: true,
          suffixIcon: InkWell(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
              child: Icon(widget.iconData)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: secondaryColor.withOpacity(0.4)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: secondaryColor.withOpacity(0.4)),
          ),
        ),
        validator: (value) {
          if (widget.text == "Full name") {
            if (value != null && value.length > 50) {
              snackBar(context, "Name should be less then 50 character");
              return "Name should be less then 50 character";
            } else if (value == null || value.isEmpty) {
              snackBar(context, "Field can not be empty!");
              return "Field can not be empty!";
            } else if (isNameValid(value)) {
              snackBar(context, "Name should contain only character");
              return "Name should contain only character";
            }
          } else if (widget.text == "email") {
            if (value == null || value.isEmpty) {
              snackBar(context, "Field can not be empty!");
              return "Field can not be empty!";
            }
          } else if (widget.text == "Password" ||
              widget.text == "Confirm Password") {
            if (value == null || value.isEmpty) {
              snackBar(context, "Field can not be empty!");
              return "Field can not be empty!";
            } else if (value.length < 6) {
              snackBar(context, "Password should be at least 6 character long");
              return "Password should be at least 6 character long";
            }
          }

          return null;
        },
        obscureText:
            widget.text == "Password" || widget.text == "Confirm Password"
                ? obscureText
                : false,
      ),
    );
  }
}

bool isNameValid(String name) {
  if (name.isEmpty) {
    return false;
  }
  bool hasDigits = name.contains(RegExp(r'[0-9]'));
  bool hasSpecialCharacters = name.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  return hasDigits & hasSpecialCharacters;
}
