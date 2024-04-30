import 'package:assessment_3/View/Auth/widgets/snackBar.dart';
import 'package:assessment_3/view/Auth/widgets/custom_button.dart';
import 'package:assessment_3/view/Auth/widgets/switch_page.dart';
import 'package:assessment_3/view/Auth/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../Provider/auth_provider.dart';
import '../../Utils/custom_loading.dart';
import 'forgot_password.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();
    super.dispose();
  }

  validate() async {
    if (_formKey.currentState!.validate()) {
      try {
        buildLoadingIndicator(context);
        Provider.of<Authentication>(context, listen: false)
            .signIn(emailController.text, passwordController.text, context)
            .then(
          (value) {
            Navigator.of(context, rootNavigator: true).pop();
            if (value != "Success") {
              snackBar(context, value);
            } else {
              Navigator.of(context)
                  .pushReplacementNamed("MiddleOfHomeAndSignIn");
            }
          },
        );
      } catch (e) {
        Navigator.of(context, rootNavigator: true).pop();
        snackBar(context, "Some error occur");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: kIsWeb ? 800 :790.h,
              width: kIsWeb ? 380 : 360.w,
              child: Padding(
                padding: EdgeInsets.all(30.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 45.h),
                    Image.asset("assets/plane.jpg"),
                    const Spacer(),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          customTextField(
                              emailController, "Enter your email", context),
                          SizedBox(height: 25.h),
                          customTextField(passwordController, "Password", context,
                              iconData: Icons.remove_red_eye),
                        ],
                      ),
                    ),
                    SizedBox(height: 17.h),
                    switchPageButton("New Member? ", "Register now", context),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        validate();
                      },
                      child: customButton("SignIn"),
                    ),
                    SizedBox(height: 40.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CustomDialogBox(),
                              ),
                            );
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontSize: kIsWeb ? 13 :12.sp,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
