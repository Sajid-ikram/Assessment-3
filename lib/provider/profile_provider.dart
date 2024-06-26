
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../Utils/error_dialoge.dart';


class ProfileProvider extends ChangeNotifier {
  String profileUrl = '';
  String profileName = '';
  String role = '';
  String email = '';
  String currentUserUid = '';

  bool refreshAssignBus = false;

  getUserInfo() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userInfo = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      profileUrl = userInfo["url"];
      profileName = userInfo["name"];
      role = userInfo["role"];
      email = userInfo["email"];
      currentUserUid = user.uid;
      notifyListeners();
    }
  }

  Future updateProfileInfo({
    required String name,
    required String department,
    required BuildContext context,
  }) async {
    try {
      FirebaseFirestore.instance.collection("users").doc(currentUserUid).update(
        {
          "name": name,
          "department": department,
        },
      );
      profileName = name;

      notifyListeners();
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }

  Future changeRole({
    required String role,
    required String uid,
    required BuildContext context,
  }) async {
    try {
      FirebaseFirestore.instance.collection("users").doc(uid).update(
        {
          "role": role,
        },
      );
    } catch (e) {
      return onError(context, "Having problem connecting to the server");
    }
  }



  refreshAssignBusPage() {
    refreshAssignBus = !refreshAssignBus;
    notifyListeners();
  }
}
