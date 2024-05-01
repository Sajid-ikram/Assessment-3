import 'package:assessment_3/View/Auth/signin.dart';
import 'package:assessment_3/View/home/home.dart';
import 'package:assessment_3/view_web/layouts/screen_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Utils/custom_loading.dart';
import 'View/Auth/verification.dart';


class MiddleOfHomeAndSignIn extends StatefulWidget {
  const MiddleOfHomeAndSignIn({Key? key}) : super(key: key);

  @override
  _MiddleOfHomeAndSignInState createState() => _MiddleOfHomeAndSignInState();
}

class _MiddleOfHomeAndSignInState extends State<MiddleOfHomeAndSignIn> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoadingWidget();
        }
        if (snapshot.data != null && snapshot.data!.emailVerified) {
          return  SiteLayout();
        }
        return snapshot.data == null
            ? const SignIn()
            : const Verification();
      },
    );
  }
}

