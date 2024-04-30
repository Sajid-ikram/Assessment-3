import 'package:assessment_3/View/Auth/widgets/snackBar.dart';
import 'package:assessment_3/view/Auth/widgets/custom_button.dart';
import 'package:assessment_3/view/Auth/widgets/flat_button.dart';
import 'package:assessment_3/view/Auth/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../Provider/auth_provider.dart';
import '../../Utils/custom_button.dart';
import '../../Utils/custom_loading.dart';

class CustomDialogBox extends StatefulWidget {
  const CustomDialogBox({Key? key}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.clear();
  }

  validate(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        buildLoadingIndicator(context);
        Provider.of<Authentication>(context, listen: false)
            .resetPassword(emailController.text, context)
            .then(
          (value) {
            Navigator.of(context, rootNavigator: true).pop();
            if (value != "Success") {
              snackBar(context, "An error accor");
            } else {
              snackBar(context, "Reset password link was sent to your email");
            }
          },
        );
      } catch (e) {
        Navigator.of(context, rootNavigator: true).pop();
        snackBar(context, "An error accor");
      }
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb ? null : AppBar(
        title: const Text(
          "Forgot Password",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
        ),
      ),
      body: contentBox(context),
    );
  }

  contentBox(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: kIsWeb ? 800 :800.h,
          width: kIsWeb ? 380 : 360.w,
          padding: EdgeInsets.all(15.sp),
          margin: EdgeInsets.only(top: 10.sp),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 50.h),
              SizedBox(
                height: kIsWeb ? null : 180.h,
                child: Image.asset("assets/plane.jpg"),
              ),
              SizedBox(height: 30.h),
              Text(
                "Enter your email",
                style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "to receive a reset link",
                style: TextStyle(
                    fontSize: 12.sp, color: Colors.black.withOpacity(0.5)),
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Form(
                  key: _formKey,
                  child: customTextField(
                      emailController, "Enter your email", context,
                      iconData: Icons.remove_red_eye),
                ),
              ),

              SizedBox(height: 30.h),
              Padding(
                padding: const EdgeInsets.all(15),
                child: GestureDetector(
                  onTap: () {
                    validate(context);
                  },
                  child: customButton("Send"),
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                "Didn’t receive any link?",
                style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 7.h),
              Text(
                "Please check in spam or send again",
                style: TextStyle(
                    fontSize: 13.sp, color: Colors.black.withOpacity(0.5)),
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ],
    );
  }
}
